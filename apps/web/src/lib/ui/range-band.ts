import { addDays, diffDays, isValidISODate } from "@/lib/calculators/dates";

/**
 * Geometry for a "you are here, the window is there" bar (P1.28.2).
 *
 * A range is what every prediction in Femio actually returns (product rule 3), and
 * a bar is a more honest picture of a range than a sentence with two dates in it —
 * the width *is* the uncertainty, so a wide irregular-mode window looks wide.
 *
 * Domain-free by design: it takes four dates and returns four percentages. Three
 * callers already use it for three different things — the next-period window, the
 * fertile window, and a pregnancy's 37w–42w term range — which is why it lives in
 * `lib/ui/` rather than under `cycle/`, and why the axis start is `axisStart`
 * rather than `axisStart` (the pregnancy caller passes a computed LMP, which is
 * not a cycle start by any reading).
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
  axisStart: string;
  windowStart: string;
  windowEnd: string;
  today: string;
  /**
   * Days of axis past the window end. Defaults to half the window width (floor 2),
   * which suits a cycle. Pregnancy overrides it: its window is 37w–42w and 42w is a
   * real outer bound, so a proportional pad would push it into the middle of the bar
   * and make the end of a pregnancy look like the middle of one.
   */
  pad?: number;
}): BandGeometry | null {
  const { axisStart, windowStart, windowEnd, today } = args;
  if (![axisStart, windowStart, windowEnd, today].every(isValidISODate)) return null;
  if (diffDays(windowStart, windowEnd) < 0) return null;
  if (diffDays(axisStart, windowStart) < 0) return null;
  if (diffDays(axisStart, today) < 0) return null;

  const pad = args.pad ?? Math.max(2, Math.ceil(diffDays(windowStart, windowEnd) / 2));
  const paddedEnd = addDays(windowEnd, pad);
  const pastWindow = diffDays(windowEnd, today) > 0;
  const axisEnd = diffDays(paddedEnd, today) > 0 ? today : paddedEnd;
  // The default pad cannot produce a zero span, but a caller-supplied one can:
  // pad 0 on a window that starts on day 1 collapses the axis to nothing and every
  // percentage becomes NaN. Refuse rather than render a band of NaN%.
  const span = diffDays(axisStart, axisEnd);
  if (span <= 0) return null;

  const pct = (iso: string) => clamp((diffDays(axisStart, iso) / span) * 100);

  return {
    windowStartPct: pct(windowStart),
    windowEndPct: pct(windowEnd),
    todayPct: pct(today),
    pastWindow,
  };
}
