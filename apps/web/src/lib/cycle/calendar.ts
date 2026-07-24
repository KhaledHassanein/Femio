import { addDays, diffDays } from "@/lib/calculators/dates";

// Pure month-grid builder for the cycle calendar (P1.13.1). No rendering, no
// locale — the component supplies locale labels. All date math is UTC (mirrors
// lib/calculators/dates), so a cell never drifts across a timezone/DST boundary.

export const FLOWS = ["spotting", "light", "medium", "heavy"] as const;
export type Flow = (typeof FLOWS)[number];

export type DayCell = {
  iso: string;
  day: number;
  inMonth: boolean;
  isToday: boolean;
  isPeriod: boolean;
  flow: Flow | null;
  isPredicted: boolean;
};

export type MonthGrid = {
  year: number;
  month: number; // 0–11
  weeks: DayCell[][]; // rows of 7
};

export function daysInMonth(year: number, month: number): number {
  return new Date(Date.UTC(year, month + 1, 0)).getUTCDate();
}

function pad(n: number): string {
  return String(n).padStart(2, "0");
}

/**
 * Build a fixed grid of whole weeks covering `month`, padded with the trailing
 * days of the previous month and the leading days of the next so every row has 7
 * cells. `weekStartsOn`: 0=Sun … 6=Sat.
 */
export function buildMonthGrid(
  year: number,
  month: number,
  opts: {
    periods?: Map<string, Flow | null>;
    windowStart?: string | null;
    windowEnd?: string | null;
    today?: string | null;
    weekStartsOn?: number;
  } = {},
): MonthGrid {
  const weekStartsOn = ((opts.weekStartsOn ?? 1) % 7 + 7) % 7;
  const periods = opts.periods ?? new Map<string, Flow | null>();
  const today = opts.today ?? null;

  const firstIso = `${year}-${pad(month + 1)}-01`;
  const firstDow = new Date(`${firstIso}T00:00:00Z`).getUTCDay();
  const lead = (firstDow - weekStartsOn + 7) % 7;
  const total = lead + daysInMonth(year, month);
  const weekCount = Math.ceil(total / 7);

  const inWindow = (iso: string): boolean =>
    opts.windowStart != null && opts.windowEnd != null
      ? diffDays(opts.windowStart, iso) >= 0 && diffDays(iso, opts.windowEnd) >= 0
      : false;

  let cursor = addDays(firstIso, -lead);
  const weeks: DayCell[][] = [];
  for (let w = 0; w < weekCount; w++) {
    const row: DayCell[] = [];
    for (let d = 0; d < 7; d++) {
      const date = new Date(`${cursor}T00:00:00Z`);
      row.push({
        iso: cursor,
        day: date.getUTCDate(),
        inMonth: date.getUTCMonth() === month,
        isToday: today === cursor,
        isPeriod: periods.has(cursor),
        flow: periods.get(cursor) ?? null,
        isPredicted: inWindow(cursor),
      });
      cursor = addDays(cursor, 1);
    }
    weeks.push(row);
  }
  return { year, month, weeks };
}

/** Week-start convention per locale (v1): Arabic → Saturday, others → Monday. */
export function weekStartForLocale(locale: string): number {
  return locale === "ar" ? 6 : 1;
}
