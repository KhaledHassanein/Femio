/**
 * TTC logging (P2.1) — the arithmetic, on its own.
 *
 * `public.fertility_logs` has existed since schema v1 and **nothing has ever written
 * to it** (`docs/23` §3.2), which is the same story as `appointments` and
 * `screener_results`. Its own schema comment carries the rule this whole module is
 * built around:
 *
 * > *TTC logs. Fertile-window is conception AWARENESS, never contraception
 * > (medical-device guardrail).*
 *
 * ## The line this module will not cross
 *
 * A BBT series has a well-known reading: a sustained temperature rise means
 * ovulation has probably already happened. **Femio does not make that reading.** It
 * draws her temperatures and stops. The moment a function here returned
 * `ovulatedOn`, Femio would be producing a clinical finding from a home
 * measurement — product rule 1 — and the very next thing anyone would build on it
 * is "days you could avoid", which is product rule 1 *and* the contraception
 * guardrail in one step.
 *
 * So there is no `thermalShift`, no `ovulationDay`, no `phase`, and no `fertile`
 * boolean in this file, and `FertilityEntry` has no field to put one in. What she
 * gets is her own numbers, drawn honestly, next to the OPK result **she** read off
 * the stick. Interpretation belongs to her and her clinician.
 *
 * Same shape as `lib/appointments`: pure, clock-injected, and the Dart client will
 * load the identical golden fixtures.
 */

import { diffDays } from "../calculators/dates.ts";

/** What the stick said. Her reading, recorded verbatim — never Femio's conclusion. */
export const OPK_RESULTS = ["negative", "low", "high", "peak", "positive"] as const;
export type OpkResult = (typeof OPK_RESULTS)[number];

/**
 * Cervical mucus, in the vocabulary the trackers and the literature share. Recorded
 * as an observation; no entry here is "good" or "bad" and the type says nothing
 * about which is which.
 */
export const CM_TYPES = ["dry", "sticky", "creamy", "watery", "eggWhite"] as const;
export type CmType = (typeof CM_TYPES)[number];

export type FertilityEntry = {
  id: string;
  /** ISO date. One entry per day is the intended shape, not enforced. */
  loggedAt: string;
  /** Basal body temperature, in whatever unit she chose. Null when not taken. */
  bbt: number | null;
  opk: OpkResult | null;
  cm: CmType | null;
  intercourse: boolean | null;
};

/** Plausible basal readings, wide on purpose — this rejects typos, not people. */
const CELSIUS = { min: 34, max: 40 };
const FAHRENHEIT = { min: 93, max: 104 };

export type TemperatureUnit = "c" | "f";

/**
 * Reject a reading no thermometer produced.
 *
 * The range is deliberately wider than any "normal" range: this is a typo guard —
 * a stray keypress turning 36.5 into 365 — and not a judgement about her
 * temperature. A number inside the range is never commented on.
 */
export function isPlausibleBbt(value: number, unit: TemperatureUnit): boolean {
  const range = unit === "c" ? CELSIUS : FAHRENHEIT;
  return Number.isFinite(value) && value >= range.min && value <= range.max;
}

/** Guess the unit from the magnitude, so she does not have to pick one twice. */
export function unitOf(value: number): TemperatureUnit | null {
  if (isPlausibleBbt(value, "c")) return "c";
  if (isPlausibleBbt(value, "f")) return "f";
  return null;
}

/** Cycle day for an entry, 1-based, or null when there is no cycle to count from. */
export function cycleDayOf(entry: FertilityEntry, cycleStartISO: string | null): number | null {
  if (!cycleStartISO) return null;
  const day = diffDays(cycleStartISO, entry.loggedAt) + 1;
  return day >= 1 ? day : null;
}

export type ChartPoint = {
  entryId: string;
  loggedAt: string;
  cycleDay: number | null;
  bbt: number;
  /** 0–1, bottom to top, for drawing. Geometry, never meaning. */
  y: number;
};

export type BbtChart = {
  points: ChartPoint[];
  low: number;
  high: number;
  unit: TemperatureUnit;
};

/**
 * The geometry of a temperature chart, and nothing else.
 *
 * It returns where to put the dots. It does not return a line, a shift, a phase or
 * a conclusion, and a caller cannot derive one from it without doing the reading
 * itself — which is the point. `null` when there is nothing to draw, so the screen
 * shows "keep logging" rather than a chart of one dot pretending to be a trend.
 *
 * The axis is padded by a fixed margin rather than fitted tightly to her data:
 * a tight fit turns a 0.1° wobble into a dramatic mountain, which is a chart
 * implying something the numbers do not.
 */
const AXIS_PADDING = { c: 0.4, f: 0.7 };
const MIN_POINTS = 3;

export function bbtChart(entries: readonly FertilityEntry[], cycleStartISO: string | null): BbtChart | null {
  const withTemps = entries
    .filter((e): e is FertilityEntry & { bbt: number } => e.bbt !== null)
    .sort((a, b) => a.loggedAt.localeCompare(b.loggedAt));
  if (withTemps.length < MIN_POINTS) return null;

  const unit = unitOf(withTemps[0]!.bbt) ?? "c";
  const values = withTemps.map((e) => e.bbt);
  const padding = AXIS_PADDING[unit];
  const low = Math.min(...values) - padding;
  const high = Math.max(...values) + padding;
  const span = high - low || 1;

  return {
    unit,
    low,
    high,
    points: withTemps.map((entry) => ({
      entryId: entry.id,
      loggedAt: entry.loggedAt,
      cycleDay: cycleDayOf(entry, cycleStartISO),
      bbt: entry.bbt,
      y: (entry.bbt - low) / span,
    })),
  };
}

/** Newest first, for the log list under the chart. */
export function recentFirst(entries: readonly FertilityEntry[]): FertilityEntry[] {
  return [...entries].sort((a, b) => b.loggedAt.localeCompare(a.loggedAt));
}

/** Whether an entry says anything at all. An empty row is not worth a round trip. */
export function isEmptyEntry(entry: Omit<FertilityEntry, "id" | "loggedAt">): boolean {
  return entry.bbt === null && entry.opk === null && entry.cm === null && !entry.intercourse;
}
