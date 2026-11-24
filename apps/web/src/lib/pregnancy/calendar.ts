/**
 * The pregnancy week-by-week calendar (MR-53): which dates each week covers.
 *
 * Why it exists: "what dates is week 24?" is the question behind most pregnancy
 * calendar searches, and the reviewed week guides answer what happens in it. Each row
 * is labelled by completed weeks, the way the guides are titled ("24 weeks pregnant"
 * runs 24w0d to 24w6d and opens `pregnancy-week-24`).
 *
 * Pure arithmetic from a due date (MR-23: the last period is 280 days before it). It
 * never says whether a pregnancy is on track; it returns dates, and the result is a
 * typed value a later explainer can read without parsing prose.
 *
 * Twin of `apps/mobile/lib/domain/pregnancy_calendar.dart`, bound by
 * `fixtures/domain/pregnancy-calendar.json` (generated in Python, not by either client).
 */
import { addDays, diffDays, isValidISODate } from "../calculators/dates.ts";
import { GESTATION_DAYS, trimesterFor, type Trimester } from "./index.ts";

/** MR-53: the first and last week rows. */
export const FIRST_ROW_WEEK = 4;
export const LAST_ROW_WEEK = 41;
/** MR-53: the weeks that have a reviewed week guide (`pregnancy-week-N`). */
export const FIRST_GUIDE_WEEK = 4;
export const LAST_GUIDE_WEEK = 40;
/** MR-25: the second trimester starts at 14w0d, the third at 28w0d. */
const SECOND_TRIMESTER_DAYS = 98;
const THIRD_TRIMESTER_DAYS = 196;
/** MR-24: the term window, 37w0d to 42w0d. */
const TERM_START_DAYS = 259;
const TERM_END_DAYS = 294;
const DAYS_PER_WEEK = 7;

export type PregnancyWeekRow = {
  /** Completed weeks: the row covers `week`w0d to `week`w6d. */
  week: number;
  start: string;
  end: string;
  trimester: Trimester;
  /** The week guide's slug, or null where no guide exists (week 41). */
  guide: string | null;
};

export type PregnancyCalendar = {
  lmp: string;
  edd: string;
  secondTrimester: string;
  thirdTrimester: string;
  termStart: string;
  termEnd: string;
  /** The row today falls in, or null when today is outside rows 4–41. */
  currentWeek: number | null;
  weeks: PregnancyWeekRow[];
};

/**
 * Every week row from a due date.
 *
 * @param eddISO the estimated due date (from any method, MR-23/MR-52).
 * @param todayISO the device's local day (MR-11), used only to mark the current row.
 * @returns the calendar, or null when either date is invalid.
 */
export function pregnancyCalendar(eddISO: string, todayISO: string): PregnancyCalendar | null {
  if (!isValidISODate(eddISO) || !isValidISODate(todayISO)) return null;
  const lmp = addDays(eddISO, -GESTATION_DAYS);
  const weeks: PregnancyWeekRow[] = [];
  for (let week = FIRST_ROW_WEEK; week <= LAST_ROW_WEEK; week += 1) {
    const start = addDays(lmp, week * DAYS_PER_WEEK);
    weeks.push({
      week,
      start,
      end: addDays(start, DAYS_PER_WEEK - 1),
      trimester: trimesterFor(week * DAYS_PER_WEEK),
      guide: week >= FIRST_GUIDE_WEEK && week <= LAST_GUIDE_WEEK ? `pregnancy-week-${week}` : null,
    });
  }
  const since = diffDays(lmp, todayISO);
  const current = since >= 0 ? Math.floor(since / DAYS_PER_WEEK) : null;
  return {
    lmp,
    edd: eddISO,
    secondTrimester: addDays(lmp, SECOND_TRIMESTER_DAYS),
    thirdTrimester: addDays(lmp, THIRD_TRIMESTER_DAYS),
    termStart: addDays(lmp, TERM_START_DAYS),
    termEnd: addDays(lmp, TERM_END_DAYS),
    currentWeek: current !== null && current >= FIRST_ROW_WEEK && current <= LAST_ROW_WEEK ? current : null,
    weeks,
  };
}
