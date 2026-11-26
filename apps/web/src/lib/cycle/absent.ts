// MR-10: a calm prompt when her period has not come for a long time.
//
// Why it exists: after 90 days with no bleed logged, a pregnancy is ruled out first and then
// a clinician should hear about it (ASRM 2024; docs/compliance/MENSTRUAL_SAFETY_THRESHOLDS.md).
// Never a count, never a cause. Twin of apps/mobile/lib/domain/absent_period.dart, bound by
// fixtures/domain/absent-period.json.

import { diffDays, isValidISODate } from "../calculators/dates";

/** Days since her last logged bleed after which the prompt shows (MR-10). */
export const ABSENT_PERIOD_DAYS = 90;

/** After a birth her period is often away for months; no prompt in that year. */
export const ABSENT_AFTER_BIRTH_DAYS = 365;

export type AbsentGoal = "period" | "ttc" | "pregnant" | "menopause";

/**
 * Whether the MR-10 prompt shows for `goal` with these bleed days (any order), an optional
 * birth date, on `today`. Only in the cycle goals, only with a bleed on record, never in the
 * year after a birth.
 */
export function periodAbsent(input: {
  goal: AbsentGoal;
  starts: readonly string[];
  birthDate: string | null;
  today: string;
}): boolean {
  const { goal, starts, birthDate, today } = input;
  if (goal !== "period" && goal !== "ttc") return false;
  if (starts.length === 0) return false;
  if (birthDate !== null && isValidISODate(birthDate) && diffDays(birthDate, today) < ABSENT_AFTER_BIRTH_DAYS) {
    return false;
  }
  const last = [...starts].sort().at(-1) as string;
  return diffDays(last, today) >= ABSENT_PERIOD_DAYS;
}
