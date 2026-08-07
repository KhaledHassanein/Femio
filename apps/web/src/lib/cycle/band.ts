import { addDays, diffDays, isValidISODate } from "@/lib/calculators/dates";

/**
 * Geometry for the prediction band on the dashboard hero (P1.28.2).
 *
 * A range is what `predictNextPeriod` actually returns (product rule 3), and a bar
 * is a more honest picture of a range than a sentence with two dates in it — the
 * width *is* the uncertainty, so a wide irregular-mode window looks wide.
 *
 * Pure and unit-tested on purpose: a band that quietly mispositions "today" would
 * misinform without ever throwing.
 */
export type BandGeometry = {
  /** Left edge of the predicted window, 0–100 along the axis. */
  windowStartPct: number;
  /** Right edge of the predicted window, 0–100. */
  windowEndPct: number;
  /** Position of today, 0–100. */
  todayPct: number;
  /** True once today is past the end of the window. */
  pastWindow: boolean;
};

const clamp = (n: number) => Math.min(100, Math.max(0, n));

/**
 * The axis runs from day 1 of the current cycle to a little past the end of the
 * predicted window — or to today, if today has already run past it, so the
 * marker never pins silently at 100% and pretends to be inside the window.
 *
 * The trailing pad matters: with the axis ending exactly at `windowEnd` the
 * window is flush against the right edge in *every* cycle, which reads as the
 * bar running out rather than as a window with an end to it.
 *
 * Returns null when the inputs cannot describe a span (bad dates, or a window
 * that ends before it starts), so the caller renders the sentence alone.
 */
export function predictionBand(args: {
  cycleStart: string;
  windowStart: string;
  windowEnd: string;
  today: string;
}): BandGeometry | null {
  const { cycleStart, windowStart, windowEnd, today } = args;
  if (![cycleStart, windowStart, windowEnd, today].every(isValidISODate)) return null;
  if (diffDays(windowStart, windowEnd) < 0) return null;
  if (diffDays(cycleStart, windowStart) < 0) return null;
  if (diffDays(cycleStart, today) < 0) return null;

  const pad = Math.max(2, Math.ceil(diffDays(windowStart, windowEnd) / 2));
  const paddedEnd = addDays(windowEnd, pad);
  const pastWindow = diffDays(windowEnd, today) > 0;
  const axisEnd = diffDays(paddedEnd, today) > 0 ? today : paddedEnd;
  // Always ≥ 2: the guards above put `windowStart` on or after `cycleStart`, and
  // the pad has a floor of two days.
  const span = diffDays(cycleStart, axisEnd);

  const pct = (iso: string) => clamp((diffDays(cycleStart, iso) / span) * 100);

  return {
    windowStartPct: pct(windowStart),
    windowEndPct: pct(windowEnd),
    todayPct: pct(today),
    pastWindow,
  };
}
