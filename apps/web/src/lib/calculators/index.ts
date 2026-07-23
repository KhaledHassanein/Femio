import { addDays, diffDays, isValidISODate } from "./dates";

// Uncertainty-honest by design: due-date and ovulation return WINDOWS, not just a
// point. Nothing here is contraception or diagnosis — the UI frames it as awareness
// and "discuss with your clinician" (medical-device guardrail, docs/13 §7).

const GESTATION_DAYS = 280;
const LUTEAL_PHASE_DAYS = 14;
export const MIN_CYCLE = 20;
export const MAX_CYCLE = 45;

export type BmiCategory = "underweight" | "normal" | "overweight" | "obese";

function clampCycle(cycleLength: number): number {
  return Math.min(MAX_CYCLE, Math.max(MIN_CYCLE, Math.round(cycleLength)));
}

/** EDD from LMP, adjusted for cycle length, plus the full-term (37–42w) window. */
export function estimateDueDate(
  lmpISO: string,
  cycleLength = 28,
): { edd: string; termStart: string; termEnd: string } | null {
  if (!isValidISODate(lmpISO)) return null;
  const adjust = clampCycle(cycleLength) - 28;
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
  if (!isValidISODate(lmpISO)) return null;
  const cycle = clampCycle(cycleLength);
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

/** BMI (metric). Category uses WHO adult cutoffs — general information, not a diagnosis. */
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

/** Average cycle length + variability from period start dates (needs ≥2). */
export function cycleStats(
  startDatesISO: string[],
): { averageLength: number; min: number; max: number; count: number; regular: boolean } | null {
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
    regular: max - min <= 7,
  };
}
