/**
 * The website's calculator maths (docs/33_REBUILD_V3/01_PRODUCT_SCOPE.md §4–5).
 *
 * Every function returns windows and ranges, never one certain date (product rule
 * 3). Nothing here diagnoses or acts as a way to avoid pregnancy; the components
 * frame every result as an estimate and the register's sentences sit under them.
 *
 * Constants are named once here and twinned in `apps/mobile/lib/domain/`; the
 * register row each one carries is noted beside it so a change is a decision, not
 * a typo. Out-of-range input returns `null` rather than a silently clamped answer
 * (§5: "a cycle length outside the range silently clamped" is a must-not).
 */
import { MIN_WINDOW_MARGIN_DAYS } from "@/lib/cycle/predict";

import { addDays, diffDays, isValidISODate } from "./dates";
import { eddFromConception, eddFromLmp, eddFromScan, eddFromTransfer, GESTATION_DAYS } from "@/lib/pregnancy";

/** MR-03: a stated cycle length is accepted from 21 days. */
export const MIN_CYCLE = 21;
/** The stepper's upper bound; above `REGULAR_CYCLE_MAX` the fertile window is withheld (MR-08). */
export const MAX_CYCLE = 45;
/** MR-08: a fertile window is only named for cycles in this range. */
export const REGULAR_CYCLE_MIN = 21;
export const REGULAR_CYCLE_MAX = 35;
/** MR-09: "regular" means a spread of at most this many days, everywhere. */
export const REGULAR_SPREAD_MAX = 9;
/** The untouched stepper value; the typical cycle, never a claim about hers. */
export const DEFAULT_CYCLE_DAYS = 28;
/** "Not sure" seeds the shortest/longest steppers with the MR-03 accepted range. */
export const IRREGULAR_SEED = { shortest: 21, longest: 35 } as const;
/** MR-07: ovulation is estimated this many days before the next period. */
export const LUTEAL_PHASE_DAYS = 14;
/** MR-07: the fertile window is the six days ending on ovulation day. */
export const FERTILE_WINDOW_DAYS = 6;
/** Period length bounds and the default for a first tap (MR-12). */
export const MIN_PERIOD = 2;
export const MAX_PERIOD = 10;
export const DEFAULT_PERIOD_DAYS = 5;
/** How far back a period start may be tapped (one long cycle and some). */
export const CYCLE_LOOKBACK_DAYS = 90;
/** 37w0d and 42w0d from the last period: the term window (MR-24). */
export const TERM_START_DAYS = 259;
export const TERM_END_DAYS = 294;
/** The term bar's axis ends at 42w0d (MR-24); the window starts at 37w0d. */
export const AXIS_WEEKS = 42;
export const TERM_START_WEEKS = 37;
/** MR-25, ACOG: the second trimester starts at 14w0d, the third at 28w0d. */
export const TRIMESTER_ENDS_WEEKS: readonly [number, number, number] = [14, 28, AXIS_WEEKS];
/** MR-26: a gestation past this is refused with "check the date", not computed. */
export const MAX_GESTATION_DAYS = 315;
/** MR-21, NHS: with no period date, test at least this many days after sex. */
export const DAYS_AFTER_SEX_TO_TEST = 21;

export type BmiCategory = "underweight" | "normal" | "overweight" | "obese";

function cycleInRange(cycleLength: number): boolean {
  return Number.isInteger(cycleLength) && cycleLength >= MIN_CYCLE && cycleLength <= MAX_CYCLE;
}

/** True when a stated cycle length earns a named fertile window (MR-08). */
export function isRegularCycleLength(cycleLength: number): boolean {
  return cycleLength >= REGULAR_CYCLE_MIN && cycleLength <= REGULAR_CYCLE_MAX;
}

export type DueDateEstimate = {
  edd: string;
  /** 37w0d: the start of the window most babies arrive in. */
  termStart: string;
  /** 42w0d. */
  termEnd: string;
};

/**
 * Due date from the last period (MR-23): the shared `eddFromLmp` (280 days), shifted
 * by how far her cycle length is from 28 when she has stated one. The window is
 * 37w0d–42w0d from the same anchor (MR-24). `null` for an invalid date or a cycle
 * length outside the accepted range.
 */
export function estimateDueDate(lmpISO: string, cycleLength = DEFAULT_CYCLE_DAYS): DueDateEstimate | null {
  if (!isValidISODate(lmpISO) || !cycleInRange(cycleLength)) return null;
  const adjust = cycleLength - DEFAULT_CYCLE_DAYS;
  const edd = eddFromLmp(lmpISO);
  if (!edd) return null;
  return {
    edd: addDays(edd, adjust),
    termStart: addDays(lmpISO, TERM_START_DAYS + adjust),
    termEnd: addDays(lmpISO, TERM_END_DAYS + adjust),
  };
}

/** How she knows the date she taps (MR-23, MR-53). */
export type DueMethod = "lmp" | "conception" | "transfer3" | "transfer5" | "scan";

export type DueDateByMethod = DueDateEstimate & {
  /** The last-period date the due date implies (due date − 280), for the week marker. */
  lmp: string;
};

/** How far ahead a due date may be tapped: a full pregnancy and a little more (MR-26). */
export const DUE_DATE_LOOKAHEAD_DAYS = 300;

/** MR-53: the scan-report steppers run 4–41 weeks; the untouched value is a typical dating scan week. */
export const SCAN_MIN_WEEKS = 4;
export const SCAN_MAX_WEEKS = 41;
export const SCAN_DEFAULT_WEEKS = 12;

/** MR-24: the term window is 21 days before to 14 days after the due date (37w0d–42w0d). */
const TERM_BEFORE_EDD_DAYS = GESTATION_DAYS - TERM_START_DAYS;
const TERM_AFTER_EDD_DAYS = TERM_END_DAYS - GESTATION_DAYS;

/**
 * Due date from any of the methods (R13.1): last period (with her cycle length),
 * conception, an IVF transfer of a day-3 or day-5 embryo, or a dating scan's weeks and
 * days. The window is 37w0d–42w0d around the result (MR-24). `null` when the shared
 * function refuses the input (an invalid date, a cycle length outside 21–45, a scan
 * gestation outside 4w0d–41w6d).
 */
export function estimateDueDateFrom(
  method: DueMethod,
  dateISO: string,
  options: { cycleLength?: number; scanWeeks?: number; scanDays?: number } = {},
): DueDateByMethod | null {
  if (method === "lmp") {
    const r = estimateDueDate(dateISO, options.cycleLength ?? DEFAULT_CYCLE_DAYS);
    return r && { ...r, lmp: addDays(r.edd, -GESTATION_DAYS) };
  }
  const edd =
    method === "conception"
      ? eddFromConception(dateISO)
      : method === "scan"
        ? eddFromScan(dateISO, options.scanWeeks ?? -1, options.scanDays ?? -1)
        : eddFromTransfer(dateISO, method === "transfer3" ? 3 : 5);
  if (!edd) return null;
  return {
    edd,
    termStart: addDays(edd, -TERM_BEFORE_EDD_DAYS),
    termEnd: addDays(edd, TERM_AFTER_EDD_DAYS),
    lmp: addDays(edd, -GESTATION_DAYS),
  };
}

export type FertileEstimate = {
  /** When the next period may start, from the stated cycle length. */
  nextPeriod: string;
  /** The window and the day it ends on; `null` when the cycle length is outside 21–35 (MR-06/08). */
  window: { start: string; end: string; ovulation: string } | null;
};

/**
 * Fertile window from the last period and cycle length (MR-07): ovulation 14 days
 * before the next period, the six days ending on it. Withheld, with the next period
 * still estimated, when the cycle length is outside the regular range (MR-08), so
 * the component shows the "no confident window" box instead of a day.
 */
export function fertileWindow(lmpISO: string, cycleLength = DEFAULT_CYCLE_DAYS): FertileEstimate | null {
  if (!isValidISODate(lmpISO) || !cycleInRange(cycleLength)) return null;
  const nextPeriod = addDays(lmpISO, cycleLength);
  if (!isRegularCycleLength(cycleLength)) return { nextPeriod, window: null };
  const ovulation = addDays(nextPeriod, -LUTEAL_PHASE_DAYS);
  return {
    nextPeriod,
    window: { start: addDays(ovulation, -(FERTILE_WINDOW_DAYS - 1)), end: ovulation, ovulation },
  };
}

export type GestationalAge = { weeks: number; days: number; totalDays: number };

/** Weeks and days from the last period at a date; `null` before it or past `MAX_GESTATION_DAYS` (MR-26). */
export function gestationalAge(lmpISO: string, atISO: string): GestationalAge | null {
  if (!isValidISODate(lmpISO) || !isValidISODate(atISO)) return null;
  const totalDays = diffDays(lmpISO, atISO);
  if (totalDays < 0 || totalDays > MAX_GESTATION_DAYS) return null;
  return { weeks: Math.floor(totalDays / 7), days: totalDays % 7, totalDays };
}

/** BMI (metric). Category uses WHO adult cut-offs: general information, never a verdict on a person. */
export function bmi(weightKg: number, heightCm: number): { value: number; category: BmiCategory } | null {
  if (!(weightKg > 0) || !(heightCm > 0)) return null;
  const meters = heightCm / 100;
  const value = Math.round((weightKg / (meters * meters)) * 10) / 10;
  let category: BmiCategory;
  if (value < 18.5) category = "underweight";
  else if (value < 25) category = "normal";
  else if (value < 30) category = "overweight";
  else category = "obese";
  return { value, category };
}

export type CycleStats = {
  averageLength: number;
  min: number;
  max: number;
  count: number;
  /** MR-09: spread of at most `REGULAR_SPREAD_MAX` days. */
  regular: boolean;
  /** The intervals between consecutive starts, in order. */
  lengths: number[];
};

/** Average cycle length and spread from period start dates (needs at least two). */
export function cycleStats(startDatesISO: string[]): CycleStats | null {
  const sorted = startDatesISO
    .filter(isValidISODate)
    .sort()
    .filter((v, i, a) => a.indexOf(v) === i);
  if (sorted.length < 2) return null;

  const lengths: number[] = [];
  for (let i = 1; i < sorted.length; i += 1) lengths.push(diffDays(sorted[i - 1]!, sorted[i]!));
  const sum = lengths.reduce((a, b) => a + b, 0);
  const min = Math.min(...lengths);
  const max = Math.max(...lengths);
  return {
    averageLength: Math.round(sum / lengths.length),
    min,
    max,
    count: lengths.length,
    regular: max - min <= REGULAR_SPREAD_MAX,
    lengths,
  };
}

export type PeriodForecast = {
  /** First possible start day, from her shortest cycle. */
  earliest: string;
  /** Last possible start day, from her longest cycle. Equal to `earliest` if they match. */
  latest: string;
  /** Last day of bleeding if it starts on `earliest`. */
  endIfEarliest: string;
};

/**
 * The next `count` periods, each as a range (rule 3: never one certain date). The
 * range comes from her own shortest and longest cycle and widens with each cycle
 * ahead. It is never narrower than the tracker's floor (MR-56): period n spans at
 * least ceil(2 x sqrt(n)) days either side, so "my cycle is always 28 days" still
 * gives a range. `null` when a bound is outside the accepted range: the stepper
 * never lets that happen, and a silent clamp would.
 */
export function periodForecast(
  lmpISO: string,
  shortest: number,
  longest: number,
  periodLength = DEFAULT_PERIOD_DAYS,
  count = 3,
): PeriodForecast[] | null {
  if (!isValidISODate(lmpISO)) return null;
  const a = Math.min(shortest, longest);
  const b = Math.max(shortest, longest);
  if (!cycleInRange(a) || !cycleInRange(b)) return null;
  const len = Math.min(MAX_PERIOD, Math.max(MIN_PERIOD, Math.round(periodLength) || DEFAULT_PERIOD_DAYS));
  const out: PeriodForecast[] = [];
  for (let n = 1; n <= count; n += 1) {
    // Widen both sides equally until the range reaches the floor for period n.
    const floorWidth = 2 * Math.ceil(MIN_WINDOW_MARGIN_DAYS * Math.sqrt(n));
    const pad = Math.max(0, Math.ceil((floorWidth - n * (b - a)) / 2));
    const earliest = addDays(lmpISO, n * a - pad);
    out.push({ earliest, latest: addDays(lmpISO, n * b + pad), endIfEarliest: addDays(earliest, len - 1) });
  }
  return out;
}

/**
 * When a home pregnancy test is most reliable (MR-21).
 *
 * NHS, "Doing a pregnancy test": most tests work from the first day of a missed period;
 * if you do not know when your period is due, test at least 21 days after you last had
 * unprotected sex. Both rules, nothing earlier: an earlier "you could try" date is the
 * kind of precision that produces false negatives.
 * https://www.nhs.uk/pregnancy/trying-for-a-baby/doing-a-pregnancy-test/
 */
export function pregnancyTestFromPeriod(
  lmpISO: string,
  cycleLength = DEFAULT_CYCLE_DAYS,
): { expectedPeriod: string; testFrom: string } | null {
  if (!isValidISODate(lmpISO) || !cycleInRange(cycleLength)) return null;
  const expectedPeriod = addDays(lmpISO, cycleLength);
  return { expectedPeriod, testFrom: expectedPeriod };
}

export function pregnancyTestFromSex(sexISO: string): { testFrom: string } | null {
  if (!isValidISODate(sexISO)) return null;
  return { testFrom: addDays(sexISO, DAYS_AFTER_SEX_TO_TEST) };
}

/** Trimester for a gestational week (MR-25, ACOG): 14w0d and 28w0d. */
export function trimesterOf(weeks: number): 1 | 2 | 3 {
  if (weeks < 14) return 1;
  if (weeks < 28) return 2;
  return 3;
}

export { GESTATION_DAYS };
