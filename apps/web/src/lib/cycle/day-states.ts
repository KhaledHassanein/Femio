import { diffDays, isValidISODate } from "../calculators/dates.ts";

/**
 * What a calendar day *is* — tier 2, so pure, portable and testable
 * (RB-C5, `docs/29_REBUILD/06` §2).
 *
 * ## Why this is a set, not a state
 *
 * The spec lists seven "day states" and the tempting shape is an enum. It is the
 * wrong shape: a day can be a logged period day **and** today **and** carry
 * symptom logs, and the calendar has to draw all three. An enum forces a
 * precedence order into the data model, where it becomes a rule nobody can see —
 * and the first time two states need to coexist, someone adds `todayAndPeriod`.
 *
 * So this returns independent facts and the renderer composes them. Precedence
 * lives in CSS, where it is visible.
 *
 * ## The two probability tiers are the point
 *
 * `predictions` (migration `0018`) carries `likely_start/end` **and**
 * `window_start/end`. Flo computes both — its own string catalogue distinguishes
 * "likely to start" from "may start" — and renders them as one dotted ring. Femio
 * renders them as two, because collapsing a confident band and a wide one into a
 * single treatment throws away the honest part of the answer.
 *
 * `likely` is a subset of `window` in practice, but this does not assume it: a day
 * can carry both flags and the renderer draws the firmer one. Assuming containment
 * would silently mis-draw the day a model change makes them disjoint.
 *
 * ## What it will not do
 *
 * No day is ever marked "safe", "infertile", or anything a reader could act on as
 * contraception (product rule 1). `fertile` marks the *estimated* window and
 * nothing marks its complement — the absence of a band is not a claim.
 */

/** Flow intensity as `period_days.flow` records it. Ordered, weakest first. */
export const FLOW_LEVELS = ["spotting", "light", "medium", "heavy"] as const;
export type FlowLevel = (typeof FLOW_LEVELS)[number];

export type DayState = {
  /** ISO date this describes. */
  date: string;
  /** She logged bleeding. `flow` is her own entry, never inferred. */
  period: { flow: FlowLevel } | null;
  /**
   * First and last day of a *contiguous run* of logged bleeding, so a period's
   * length reads without counting (OD-15).
   *
   * Deliberately computed from the run rather than from `cycles.period_start`: a
   * woman who logged days 2–5 but not day 1 has a run that starts on day 2, and
   * drawing a cap on day 1 would claim a day she did not record.
   */
  runStart: boolean;
  runEnd: boolean;
  /** Inside `predictions.likely_*` — the firmer tier. */
  predictedLikely: boolean;
  /** Inside `predictions.window_*` — the wider tier. */
  predictedPossible: boolean;
  /** Inside the estimated fertile window. Never its complement. */
  fertile: boolean;
  /** The estimated ovulation day, a distinct marker inside the band. */
  ovulation: boolean;
  /** Composable with everything above. */
  today: boolean;
  /** She logged something other than bleeding — a dot under the numeral. */
  hasLogs: boolean;
};

export type DayStateInput = {
  /** The days the grid covers, ISO, any order. */
  dates: readonly string[];
  /** Her logged bleeding, one row per day (`period_days`). */
  periodDays: readonly { day: string; flow: FlowLevel }[];
  /** Dates on which she logged anything else. */
  logDates?: readonly string[];
  /** `predictions` row for the next period, either tier optional. */
  prediction?: {
    likelyStart?: string | null;
    likelyEnd?: string | null;
    windowStart?: string | null;
    windowEnd?: string | null;
  } | null;
  /** Estimated fertile window and ovulation, when they can be estimated at all. */
  fertile?: { start: string; end: string; ovulation?: string | null } | null;
  todayISO: string;
};

/** Inclusive range test that tolerates a missing or malformed bound. */
function within(date: string, start?: string | null, end?: string | null): boolean {
  if (!start || !end || !isValidISODate(start) || !isValidISODate(end)) return false;
  return diffDays(start, date) >= 0 && diffDays(date, end) >= 0;
}

/**
 * Every day's facts, in the order given.
 *
 * Total by construction — an unparseable date yields a day with nothing set rather
 * than throwing, because a calendar that cannot draw one cell must still draw the
 * month.
 */
export function dayStates(input: DayStateInput): DayState[] {
  const { dates, periodDays, logDates = [], prediction, fertile, todayISO } = input;

  const flowByDate = new Map<string, FlowLevel>();
  for (const row of periodDays) {
    if (isValidISODate(row.day)) flowByDate.set(row.day, row.flow);
  }
  const logged = new Set(logDates.filter(isValidISODate));

  return dates.map((date) => {
    const blank: DayState = {
      date,
      period: null,
      runStart: false,
      runEnd: false,
      predictedLikely: false,
      predictedPossible: false,
      fertile: false,
      ovulation: false,
      today: false,
      hasLogs: false,
    };
    if (!isValidISODate(date)) return blank;

    const flow = flowByDate.get(date);
    // A run boundary is decided by the neighbouring *days*, not by the array — the
    // grid may start mid-run, and a month boundary is not a period boundary.
    const prev = addDaysISO(date, -1);
    const next = addDaysISO(date, 1);

    return {
      ...blank,
      period: flow ? { flow } : null,
      runStart: flow !== undefined && !flowByDate.has(prev),
      runEnd: flow !== undefined && !flowByDate.has(next),
      predictedLikely: within(date, prediction?.likelyStart, prediction?.likelyEnd),
      predictedPossible: within(date, prediction?.windowStart, prediction?.windowEnd),
      fertile: fertile ? within(date, fertile.start, fertile.end) : false,
      ovulation: Boolean(fertile?.ovulation) && fertile?.ovulation === date,
      today: date === todayISO,
      hasLogs: logged.has(date),
    };
  });
}

/** Local ±1 day, kept here so this module imports only `dates.ts`. */
function addDaysISO(iso: string, delta: number): string {
  const d = new Date(`${iso}T00:00:00Z`);
  d.setUTCDate(d.getUTCDate() + delta);
  return d.toISOString().slice(0, 10);
}
