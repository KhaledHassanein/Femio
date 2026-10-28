/**
 * Month-grid maths for the interactive calendar (docs/33_REBUILD_V3/02_DESIGN_SPEC.md §2).
 *
 * Pure functions over ISO calendar dates (`YYYY-MM-DD`): which day a week starts
 * on for a language, the rows of a month, which months a result touches, and
 * where a band (a date range drawn behind the day numbers) falls inside one
 * week row. Nothing here knows about React, the DOM or a time zone: "today" is
 * taken from the device's local calendar date (MR-11), and every other date is
 * arithmetic on ISO strings done in UTC so DST can never shift a day.
 *
 * The Dart twin is `apps/mobile/lib/domain/calendar_grid.dart`; both are bound by
 * `fixtures/domain/calendar-grid.json`, so the two clients draw the same month.
 */
import { addDays, diffDays, isValidISODate, todayISO } from "@/lib/calculators/dates";

/** Day of week a calendar row starts on, keyed by language (0 = Sunday … 6 = Saturday). */
export const WEEK_START_BY_LANGUAGE: Readonly<Record<string, number>> = { ar: 6, en: 1, fr: 1, es: 1 };
const DEFAULT_WEEK_START = 1;
export const DAYS_IN_WEEK = 7;

/** Week start for a locale, matched on its language part so `ar-u-nu-latn` still gives Saturday. */
export function weekStartFor(locale: string): number {
  const language = locale.toLowerCase().split(/[-_]/)[0] ?? "";
  return WEEK_START_BY_LANGUAGE[language] ?? DEFAULT_WEEK_START;
}

/** The device's local calendar date as ISO (MR-11). */
export const localTodayISO = todayISO;

/** First day of the month an ISO date belongs to. */
export function monthStart(iso: string): string {
  return `${iso.slice(0, 7)}-01`;
}

/** First day of the month `n` months after (or before, when negative) the given month. */
export function shiftMonth(monthISO: string, n: number): string {
  const d = new Date(`${monthStart(monthISO)}T00:00:00Z`);
  d.setUTCMonth(d.getUTCMonth() + n, 1);
  return d.toISOString().slice(0, 10);
}

/** Number of days in the month of an ISO date. */
export function daysInMonth(iso: string): number {
  return diffDays(monthStart(iso), shiftMonth(iso, 1));
}

/** 0 = Sunday … 6 = Saturday, for an ISO date. */
export function dayOfWeek(iso: string): number {
  return new Date(`${iso}T00:00:00Z`).getUTCDay();
}

/**
 * A month as rows of seven cells. Cells outside the month are `null`, so the grid
 * keeps its column alignment without drawing another month's days (which would
 * invite a tap on a day that belongs to a different card).
 */
export type MonthGrid = {
  /** First day of the month, ISO. */
  month: string;
  /** Rows of exactly seven cells, in visual order from the week-start column. */
  weeks: ReadonlyArray<ReadonlyArray<string | null>>;
};

export function monthGrid(monthISO: string, weekStart: number): MonthGrid {
  const first = monthStart(monthISO);
  const total = daysInMonth(first);
  const lead = (dayOfWeek(first) - weekStart + DAYS_IN_WEEK) % DAYS_IN_WEEK;
  const cells: Array<string | null> = Array.from({ length: lead }, () => null);
  for (let i = 0; i < total; i += 1) cells.push(addDays(first, i));
  while (cells.length % DAYS_IN_WEEK !== 0) cells.push(null);
  const weeks: Array<Array<string | null>> = [];
  for (let i = 0; i < cells.length; i += DAYS_IN_WEEK) weeks.push(cells.slice(i, i + DAYS_IN_WEEK));
  return { month: first, weeks };
}

/** The months from `fromISO` through `toISO`, as month-start ISO dates, capped at `max`. */
export function monthsSpanning(fromISO: string, toISO: string, max: number): string[] {
  const out: string[] = [];
  for (let m = monthStart(fromISO); m <= toISO && out.length < max; m = shiftMonth(m, 1)) out.push(m);
  return out;
}

/**
 * The `count` most recent months ending at the month of `today`, oldest first, as
 * month-start ISO dates. The month strip above the pregnancy calendars (§2.3) is built
 * from this, so a woman can jump to the month her last period fell in without a dropdown.
 * A non-positive count gives an empty list.
 */
export function recentMonths(today: string, count: number): string[] {
  const current = monthStart(today);
  return Array.from({ length: Math.max(0, count) }, (_, i) => shiftMonth(current, i - count + 1));
}

/** Weekday ISO dates in visual order for a week start; used for the header row. */
export function weekdayHeaderDates(weekStart: number): string[] {
  // 2026-01-04 is a Sunday (day 0), whatever the locale.
  const sunday = "2026-01-04";
  return Array.from({ length: DAYS_IN_WEEK }, (_, i) => addDays(sunday, (weekStart + i) % DAYS_IN_WEEK));
}

/**
 * A date range drawn behind the day numbers. `soft` edges fade in and out; a
 * `breathe` band is the one uncertain thing on the view that moves (§2.10).
 */
export type BandKind = "period" | "fertile" | "nextPeriod" | "testFrom" | "term" | "cycleSpan";

export type Band = {
  id: string;
  kind: BandKind;
  /** Inclusive ISO start. */
  start: string;
  /** Inclusive ISO end. */
  end: string;
  softStart?: boolean;
  softEnd?: boolean;
  breathe?: boolean;
};

export type BandSegment = {
  /** 1-based grid column where the segment begins (visual, from the inline start). */
  colStart: number;
  /** 1-based grid column where the segment ends, inclusive. */
  colEnd: number;
  /** True when the band's real start is in this row (a rounded, possibly soft, edge). */
  isStart: boolean;
  /** True when the band's real end is in this row. */
  isEnd: boolean;
};

/**
 * The part of a band that falls inside one week row, or `null` when none does.
 * Cells that are `null` (outside the month) never carry a band: a band that runs
 * past the month's last day ends at that day's column and continues in the next
 * month's grid.
 */
export function bandSegment(band: Band, week: ReadonlyArray<string | null>): BandSegment | null {
  let colStart = 0;
  let colEnd = 0;
  for (let i = 0; i < week.length; i += 1) {
    const day = week[i];
    if (!day || day < band.start || day > band.end) continue;
    if (colStart === 0) colStart = i + 1;
    colEnd = i + 1;
  }
  if (colStart === 0) return null;
  const firstDay = week[colStart - 1];
  const lastDay = week[colEnd - 1];
  return {
    colStart,
    colEnd,
    isStart: firstDay === band.start,
    isEnd: lastDay === band.end,
  };
}

/** Inclusive length in days of a band. */
export function bandLength(band: Pick<Band, "start" | "end">): number {
  return diffDays(band.start, band.end) + 1;
}

const HIJRI_LOCALE = "ar-SA-u-ca-islamic-umalqura-nu-latn";

/**
 * Hijri day-of-month for an ISO date, Western digits, Umm al-Qura calendar. Display
 * only: everything is stored and computed in Gregorian (CLAUDE.md rule 6). Returns
 * an empty string when the runtime lacks the calendar, so a missing label is the
 * only failure mode.
 */
export function hijriDay(iso: string): string {
  if (!isValidISODate(iso)) return "";
  try {
    return new Intl.DateTimeFormat(HIJRI_LOCALE, { day: "numeric", timeZone: "UTC" }).format(
      new Date(`${iso}T00:00:00Z`),
    );
  } catch {
    return "";
  }
}

/**
 * Hijri month index (1-12) and year (AH) for an ISO date, Umm al-Qura, as numbers. The
 * app twin (`domain/hijri.dart`) is bound to this by `fixtures/domain/hijri.json`;
 * `null` when the date is invalid or the runtime lacks the calendar.
 */
export function hijriMonthYear(iso: string): { month: number; year: number } | null {
  if (!isValidISODate(iso)) return null;
  try {
    const at = new Date(`${iso}T00:00:00Z`);
    const read = (opts: Intl.DateTimeFormatOptions) =>
      Number(
        new Intl.DateTimeFormat("en-u-ca-islamic-umalqura-nu-latn", { ...opts, timeZone: "UTC" })
          .format(at)
          .replace(/\D/g, ""),
      );
    return { month: read({ month: "numeric" }), year: read({ year: "numeric" }) };
  } catch {
    return null;
  }
}

/**
 * The Hijri month(s) and year a Gregorian month spans, as one line ("جمادى الأولى –
 * جمادى الآخرة 1448 هـ"). Empty when unsupported.
 */
export function hijriMonthLine(firstISO: string, lastISO: string): string {
  try {
    const month = new Intl.DateTimeFormat(HIJRI_LOCALE, { month: "long", timeZone: "UTC" });
    const year = new Intl.DateTimeFormat(HIJRI_LOCALE, { year: "numeric", timeZone: "UTC" });
    const a = month.format(new Date(`${firstISO}T00:00:00Z`));
    const b = month.format(new Date(`${lastISO}T00:00:00Z`));
    const y = year.format(new Date(`${lastISO}T00:00:00Z`));
    return a === b ? `${a} ${y}` : `${a} – ${b} ${y}`;
  } catch {
    return "";
  }
}
