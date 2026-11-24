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
 * Estimated due date from a conception date: 266 days, the 280 less the two weeks
 * before ovulation that an LMP count includes. Twin of `eddFromConception` in
 * `apps/mobile/lib/domain/pregnancy.dart` (fixture `edd-from.json`).
 */
export function eddFromConception(conceptionISO: string): string | null {
  if (!isValidISODate(conceptionISO)) return null;
  return addDays(conceptionISO, GESTATION_DAYS - 14);
}

/**
 * Estimated due date from an IVF embryo transfer: 266 days less the embryo's age at
 * transfer (3 or 5 days). ACOG Committee Opinion 700, "Methods for Estimating the Due
 * Date". Twin of `eddFromTransfer` in the Dart app.
 */
export function eddFromTransfer(transferISO: string, embryoDays: 3 | 5): string | null {
  if (!isValidISODate(transferISO)) return null;
  return addDays(transferISO, GESTATION_DAYS - 14 - embryoDays);
}

/** MR-52: the gestation on a scan report is accepted from 4w0d … */
export const SCAN_MIN_GESTATION_DAYS = 28;
/** … to 41w6d (the engine's sanity range, like MR-26). */
export const SCAN_MAX_GESTATION_DAYS = 293;

/**
 * Estimated due date from a dating scan (MR-52): the scan date plus what is left of
 * 280 days after the gestation the report gives. femio never re-dates or compares
 * methods; the report's weeks and days are taken as written (ACOG Committee Opinion
 * 700 leaves re-dating to the clinician). Twin of `eddFromScan` in the Dart app.
 *
 * @param scanISO the day of the scan.
 * @param weeks completed weeks on the report.
 * @param days extra days on the report, 0–6.
 * @returns the due date, or `null` for an invalid date, days outside 0–6, or a
 *   gestation outside 4w0d–41w6d (she is asked to check the report).
 */
export function eddFromScan(scanISO: string, weeks: number, days: number): string | null {
  if (!isValidISODate(scanISO)) return null;
  if (!Number.isInteger(weeks) || !Number.isInteger(days) || weeks < 0 || days < 0 || days > 6) return null;
  const total = weeks * 7 + days;
  if (total < SCAN_MIN_GESTATION_DAYS || total > SCAN_MAX_GESTATION_DAYS) return null;
  return addDays(scanISO, GESTATION_DAYS - total);
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
