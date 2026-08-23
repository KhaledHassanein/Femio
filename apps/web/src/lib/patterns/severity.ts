import { CONFIDENCE_RANK, confidenceFrom, type PatternConfidence } from "./confidence.ts";
import { frameFor, placeInCycle, type Entry } from "./cycles.ts";

/**
 * How hard a symptom has been hitting, recently versus before (P2.5).
 *
 * The third dimension. It is the one with the sharpest edges, because a severity
 * trend is the single most over-readable thing this product could show: "your pain
 * is getting worse" is heard as a prognosis, and it is not one — it is the mean of
 * a handful of numbers she typed on days she remembered to.
 *
 * ## The three refusals, each with a reason
 *
 * **It never says better or worse.** The direction is `higher` or `lower`, and the
 * copy that renders it keeps those words. "Worse" is a judgement about her health;
 * "higher" is a fact about her entries. `docs/09` invariant 7 exists because apps
 * that grade people on their bad days make the bad days worse, and P2.4 already
 * refused an adherence score on the same ground.
 *
 * **It never extrapolates.** There is no next-cycle projection, no slope, no
 * "if this continues". Two means and the number of cycles behind each.
 *
 * **It never fires on thin data.** Both windows need `MIN_CYCLES` cycles of their
 * own, and the gap between the means must clear `MIN_SHIFT` — a tenth of a point
 * on a five-point scale is noise, and reporting it would teach her to distrust the
 * whole screen. `steady` is a real, common and useful answer, returned rather than
 * hidden.
 *
 * ## Why the split is by cycle and not by date
 *
 * A calendar window would cut a cycle in half and average two different phases
 * together. Cycles are the unit her body actually works in, and the same frame
 * every other pattern module uses.
 */

export type SeverityDirection = "higher" | "lower" | "steady";

export type SeverityTrend = {
  type: string;
  direction: SeverityDirection;
  /** Mean severity in the recent window, to one decimal. Her numbers, not a score. */
  recentMean: number;
  /** Mean severity in everything before it. */
  earlierMean: number;
  /** Cycles behind each mean, shown so the evidence is never implied. */
  recentCycles: number;
  earlierCycles: number;
  confidence: PatternConfidence;
};

/** How many of her most recent complete cycles count as "recently". */
export const RECENT_CYCLES = 3;

/**
 * The smallest difference in mean severity worth naming, on the 0–4 scale
 * `symptom_logs.severity` uses. Half a point: below that, two people describing
 * the same day would disagree by more than the signal.
 */
export const MIN_SHIFT = 0.5;

const round1 = (n: number) => Math.round(n * 10) / 10;

export function severityTrends(
  entries: readonly Entry[],
  periodStarts: readonly string[],
  limit = 3,
): SeverityTrend[] {
  const frame = frameFor(periodStarts);
  if (!frame) return [];

  const recentFrom = frame.completeCycles - RECENT_CYCLES;
  if (recentFrom < 1) return []; // not enough history to have a "before" at all

  type Bucket = { sum: number; n: number; cycles: Set<number> };
  const empty = (): Bucket => ({ sum: 0, n: 0, cycles: new Set<number>() });
  const byType = new Map<string, { recent: Bucket; earlier: Bucket }>();

  for (const entry of entries) {
    // A symptom logged without a rating is a real entry and not a zero. Averaging
    // it in as 0 would make "she didn't rate it" look like "it didn't hurt".
    if (typeof entry.severity !== "number" || !Number.isFinite(entry.severity)) continue;
    const placed = placeInCycle(frame, entry.date);
    if (!placed) continue;

    const bucketPair = byType.get(entry.type) ?? { recent: empty(), earlier: empty() };
    const bucket = placed.cycle >= recentFrom ? bucketPair.recent : bucketPair.earlier;
    bucket.sum += entry.severity;
    bucket.n += 1;
    bucket.cycles.add(placed.cycle);
    byType.set(entry.type, bucketPair);
  }

  const trends: SeverityTrend[] = [];
  for (const [type, { recent, earlier }] of byType) {
    const recentCycles = recent.cycles.size;
    const earlierCycles = earlier.cycles.size;
    if (recent.n === 0 || earlier.n === 0) continue;

    /**
     * Confidence is taken over the *whole* observation, not over one window: the
     * claim being made is "this is what your entries show across these cycles", so
     * the evidence is every cycle it appeared in out of every complete cycle.
     */
    const confidence = confidenceFrom({
      cycles: recentCycles + earlierCycles,
      ofCycles: frame.completeCycles,
    });
    if (!confidence) continue;

    const recentMean = round1(recent.sum / recent.n);
    const earlierMean = round1(earlier.sum / earlier.n);
    const shift = recentMean - earlierMean;
    const direction: SeverityDirection =
      Math.abs(shift) < MIN_SHIFT ? "steady" : shift > 0 ? "higher" : "lower";

    trends.push({
      type,
      direction,
      recentMean,
      earlierMean,
      recentCycles,
      earlierCycles,
      confidence,
    });
  }

  /**
   * Movement first, then confidence — a `steady` result is worth showing and is
   * not worth showing *above* a change. Alphabetical last, so the list is stable
   * across sessions.
   */
  return trends
    .sort(
      (x, y) =>
        Number(y.direction !== "steady") - Number(x.direction !== "steady") ||
        CONFIDENCE_RANK[y.confidence] - CONFIDENCE_RANK[x.confidence] ||
        x.type.localeCompare(y.type),
    )
    .slice(0, limit);
}
