import { addDays, diffDays, isValidISODate } from "../calculators/dates.ts";

/**
 * Pregnancy progress, derived from the estimated due date (P1.13b).
 *
 * Deliberately keyed off **EDD rather than LMP**, unlike `lib/calculators`. The
 * calculators answer a visitor's one-off question from the date she remembers; a
 * pregnancy *record* holds the due date a clinician gave her, and that date is the one
 * that gets revised after a dating scan. Deriving from LMP would quietly ignore that
 * revision and keep showing a week count her notes disagree with.
 *
 * Everything here is an estimate and is presented as one. Femio does not tell anyone
 * how her pregnancy is going — it counts days against a date she was given, which is
 * arithmetic, and points her at her clinician for anything that is not.
 */

/** Full-term gestation, by convention 40 weeks from LMP. */
export const GESTATION_DAYS = 280;

export type Trimester = 1 | 2 | 3;

export type PregnancyProgress = {
  /** Completed weeks + days, the way clinicians write it: "24w3d". */
  weeks: number;
  days: number;
  totalDays: number;
  trimester: Trimester;
  /** Days until the due date. Negative once past it — which happens, and is normal. */
  daysUntilDue: number;
  /** True once past the due date: most pregnancies are not born on it. */
  overdue: boolean;
  /** 37w0d — the point from which a birth is "term" rather than preterm. */
  termStart: string;
};

/**
 * Where a pregnancy is on a given day, from its due date.
 * Returns null for an invalid date or a gestational age outside a plausible range,
 * rather than rendering a nonsense week number.
 */
export function pregnancyProgress(eddISO: string, todayISO: string): PregnancyProgress | null {
  if (!isValidISODate(eddISO) || !isValidISODate(todayISO)) return null;

  const daysUntilDue = diffDays(todayISO, eddISO);
  const totalDays = GESTATION_DAYS - daysUntilDue;

  // Before conception, or implausibly far past term — no useful answer to give.
  if (totalDays < 0 || totalDays > 315) return null;

  const weeks = Math.floor(totalDays / 7);
  return {
    weeks,
    days: totalDays % 7,
    totalDays,
    trimester: trimesterFor(totalDays),
    daysUntilDue,
    overdue: daysUntilDue < 0,
    termStart: addDays(eddISO, -21), // 40w0d − 3w = 37w0d
  };
}

/**
 * Trimester boundaries follow the common clinical convention: first through 13w6d,
 * second through 27w6d, third thereafter. Sources differ by a few days at the edges,
 * which is exactly why this is shown as context and never as a milestone to act on.
 */
export function trimesterFor(totalDays: number): Trimester {
  if (totalDays < 98) return 1; // < 14w0d
  if (totalDays < 196) return 2; // < 28w0d
  return 3;
}

/** Estimated due date from an LMP, for the setup form. */
export function eddFromLmp(lmpISO: string): string | null {
  if (!isValidISODate(lmpISO)) return null;
  return addDays(lmpISO, GESTATION_DAYS);
}

/**
 * Is this a date someone could plausibly be pregnant against today?
 * Guards the setup form: a due date years out or long past is a typo, and a week
 * counter built on a typo is worse than an empty state.
 */
export function isPlausibleEdd(eddISO: string, todayISO: string): boolean {
  if (!isValidISODate(eddISO) || !isValidISODate(todayISO)) return false;
  const until = diffDays(todayISO, eddISO);
  return until <= GESTATION_DAYS && until >= -35;
}
