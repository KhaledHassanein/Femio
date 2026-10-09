import { addDays, diffDays, isValidISODate } from "./dates";

// Uncertainty-honest by design: due-date and ovulation return WINDOWS, not just a
// point. Nothing here is contraception or diagnosis — the UI frames it as awareness
// and "discuss with your clinician" (medical-device guardrail, docs/13 §7).

const GESTATION_DAYS = 280;
const LUTEAL_PHASE_DAYS = 14;
export const MIN_CYCLE = 20;
export const MAX_CYCLE = 45;

export type BmiCategory = "underweight" | "normal" | "overweight" | "obese";

/**
 * Calendar maths only holds for cycles of 20–45 days. Outside that range every tool
 * returns null and the screen says why: until 2026-10-09 the value was silently
 * clamped, so a woman who typed 90 got answers computed for 45 with 90 still showing
 * in the box (public audit F02).
 */
export function cycleInRange(cycleLength: number): boolean {
  return Number.isFinite(cycleLength) && cycleLength >= MIN_CYCLE && cycleLength <= MAX_CYCLE;
}

/** EDD from LMP, adjusted for cycle length, plus the full-term (37–42w) window. */
export function estimateDueDate(
  lmpISO: string,
  cycleLength = 28,
): { edd: string; termStart: string; termEnd: string } | null {
  if (!isValidISODate(lmpISO) || !cycleInRange(cycleLength)) return null;
  const adjust = Math.round(cycleLength) - 28;
  return {
    edd: addDays(lmpISO, GESTATION_DAYS + adjust),
    termStart: addDays(lmpISO, 259 + adjust), // 37w0d
    termEnd: addDays(lmpISO, 294 + adjust), // 42w0d
  };
}

/** Estimated ovulation + fertile window from LMP and cycle length. */
export function fertileWindow(
  lmpISO: string,
  cycleLength = 28,
): { ovulation: string; windowStart: string; windowEnd: string; nextPeriod: string } | null {
  if (!isValidISODate(lmpISO) || !cycleInRange(cycleLength)) return null;
  const cycle = Math.round(cycleLength);
  const nextPeriod = addDays(lmpISO, cycle);
  const ovulation = addDays(nextPeriod, -LUTEAL_PHASE_DAYS);
  return {
    ovulation,
    windowStart: addDays(ovulation, -5),
    windowEnd: addDays(ovulation, 1),
    nextPeriod,
  };
}

/** Gestational age (weeks + days) from LMP at a given date. */
export function gestationalAge(
  lmpISO: string,
  atISO: string,
): { weeks: number; days: number; totalDays: number } | null {
  if (!isValidISODate(lmpISO) || !isValidISODate(atISO)) return null;
  const totalDays = diffDays(lmpISO, atISO);
  if (totalDays < 0 || totalDays > 320) return null;
  return { weeks: Math.floor(totalDays / 7), days: totalDays % 7, totalDays };
}

/** Outside these an entry is a typo or not an adult, and BMI says nothing useful. */
export const ADULT_WEIGHT_KG = [30, 300] as const;
export const ADULT_HEIGHT_CM = [120, 230] as const;

/** BMI (metric). Category uses WHO adult cutoffs — general information, not a diagnosis. */
export function bmi(
  weightKg: number,
  heightCm: number,
): { value: number; category: BmiCategory } | null {
  if (!(weightKg >= ADULT_WEIGHT_KG[0] && weightKg <= ADULT_WEIGHT_KG[1])) return null;
  if (!(heightCm >= ADULT_HEIGHT_CM[0] && heightCm <= ADULT_HEIGHT_CM[1])) return null;
  const meters = heightCm / 100;
  const value = Math.round((weightKg / (meters * meters)) * 10) / 10;
  // Categorised from the one-decimal value she sees, as WHO tables are read: a
  // shown 25.0 is "overweight" (reviewed 2026-10-09; unrounded categories made a
  // displayed 25.0 read "healthy", which is the worse inconsistency).
  let category: BmiCategory;
  if (value < 18.5) category = "underweight";
  else if (value < 25) category = "normal";
  else if (value < 30) category = "overweight";
  else category = "obese";
  return { value, category };
}

/** Two "starts" closer than this are almost always days of the same period. */
export const MIN_GAP_DAYS = 15;

/**
 * Average cycle length + variability from period start dates (needs ≥2).
 *
 * `regular` is null until there are two intervals: one interval has no spread to
 * judge, and calling it regular reassured a woman who had typed two consecutive
 * bleeding days (audit F04). `tooClose` flags a gap under `MIN_GAP_DAYS`, which the
 * screen treats as a data-entry problem, not a cycle.
 */
export function cycleStats(startDatesISO: string[]): {
  averageLength: number;
  min: number;
  max: number;
  count: number;
  regular: boolean | null;
  tooClose: boolean;
} | null {
  const sorted = startDatesISO
    .filter(isValidISODate)
    .sort()
    .filter((v, i, a) => a.indexOf(v) === i);
  if (sorted.length < 2) return null;

  const lengths: number[] = [];
  for (let i = 1; i < sorted.length; i += 1) {
    lengths.push(diffDays(sorted[i - 1]!, sorted[i]!));
  }
  const sum = lengths.reduce((a, b) => a + b, 0);
  const min = Math.min(...lengths);
  const max = Math.max(...lengths);
  return {
    averageLength: Math.round(sum / lengths.length),
    min,
    max,
    count: lengths.length,
    regular: lengths.length < 2 ? null : max - min <= 7,
    tooClose: min < MIN_GAP_DAYS,
  };
}

export const MIN_PERIOD = 2;
export const MAX_PERIOD = 10;

export type PeriodForecast = {
  /** First possible start day, from her shortest cycle. */
  earliest: string;
  /** Last possible start day, from her longest cycle. Equal to `earliest` if they match. */
  latest: string;
  /** Last day of bleeding if it starts on `earliest`. */
  endIfEarliest: string;
};

/**
 * The next `count` periods, each as a range (rule 3: never one certain date).
 *
 * The range comes from her own shortest and longest cycle, not from a constant we
 * chose, so it is exactly as wide as her cycles are variable and it widens with each
 * cycle ahead, which is the honest shape of the uncertainty.
 */
export function periodForecast(
  lmpISO: string,
  shortest: number,
  longest: number,
  periodLength = 5,
  count = 3,
): PeriodForecast[] | null {
  if (!isValidISODate(lmpISO) || !cycleInRange(shortest) || !cycleInRange(longest)) return null;
  const a = Math.round(Math.min(shortest, longest));
  const b = Math.round(Math.max(shortest, longest));
  const len = Math.min(MAX_PERIOD, Math.max(MIN_PERIOD, Math.round(periodLength) || 5));
  const out: PeriodForecast[] = [];
  for (let n = 1; n <= count; n += 1) {
    const earliest = addDays(lmpISO, n * a);
    out.push({
      earliest,
      latest: addDays(lmpISO, n * b),
      endIfEarliest: addDays(earliest, len - 1),
    });
  }
  return out;
}

/**
 * When a home pregnancy test is most reliable.
 *
 * NHS, "Doing a pregnancy test": most tests work from the first day of a missed period;
 * if you do not know when your period is due, test at least 21 days after you last had
 * unprotected sex. Both rules, nothing earlier: an earlier "you could try" date is the
 * kind of precision that produces false negatives.
 * https://www.nhs.uk/pregnancy/trying-for-a-baby/doing-a-pregnancy-test/
 */
export function pregnancyTestFromPeriod(
  lmpISO: string,
  cycleLength = 28,
): { expectedPeriod: string; testFrom: string } | null {
  if (!isValidISODate(lmpISO) || !cycleInRange(cycleLength)) return null;
  const expectedPeriod = addDays(lmpISO, Math.round(cycleLength));
  return { expectedPeriod, testFrom: expectedPeriod };
}

export const DAYS_AFTER_SEX_TO_TEST = 21;

export function pregnancyTestFromSex(sexISO: string): { testFrom: string } | null {
  if (!isValidISODate(sexISO)) return null;
  return { testFrom: addDays(sexISO, DAYS_AFTER_SEX_TO_TEST) };
}

/**
 * Trimester for a gestational week. ACOG's boundaries: first through 13w6d, second
 * 14w0d–27w6d, third from 28w0d.
 */
export function trimesterOf(weeks: number): 1 | 2 | 3 {
  if (weeks < 14) return 1;
  if (weeks < 28) return 2;
  return 3;
}
