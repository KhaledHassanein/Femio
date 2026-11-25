// The next few periods after her entries, each a range with a confidence word (MR-51).
//
// Why it exists: the owner asked that the calendar show the calculated next periods
// once she has logged (R8.10). A single next period is all `predictNextPeriod` gives;
// this extends it without inventing certainty. Twin of
// `apps/mobile/lib/domain/upcoming_periods.dart`, bound by
// `fixtures/domain/upcoming-periods.json`.

import { addDays } from "../calculators/dates.ts";
import type { Confidence, CyclePrediction } from "./predict.ts";

/** MR-51: how many periods the calendar shows ahead. */
export const UPCOMING_PERIOD_COUNT = 3;

const LEVELS: readonly Confidence[] = ["high", "medium", "low"];

export type UpcomingPeriod = {
  predictedStart: string;
  windowStart: string;
  windowEnd: string;
  confidence: Confidence;
};

/**
 * The next periods from a prediction.
 *
 * Period k starts k average lengths after her last start. Its half-width is
 * `ceil(margin × √k)`: the spread of a sum of k cycle lengths grows with the
 * square root of k, so each later range is wider than the one before. Confidence
 * drops one level per period after the first and never goes below low.
 *
 * @param prediction - from `predictNextPeriod`; null gives an empty list.
 * @param count - how many periods; defaults to {@link UPCOMING_PERIOD_COUNT}.
 * @returns the ranges in date order. Only the first when her cycles are irregular
 *   or still being learned (MR-06): a third range drawn from two data points would
 *   look like knowledge it is not.
 */
export function upcomingPeriods(
  prediction: CyclePrediction | null,
  count: number = UPCOMING_PERIOD_COUNT,
): UpcomingPeriod[] {
  if (prediction === null || count < 1) return [];
  const total = prediction.irregular || prediction.learning ? 1 : count;
  const first = LEVELS.indexOf(prediction.confidence);
  const out: UpcomingPeriod[] = [];
  for (let k = 1; k <= total; k += 1) {
    const predictedStart = addDays(prediction.predictedStart, (k - 1) * prediction.averageLength);
    const margin = Math.ceil(prediction.evidence.margin * Math.sqrt(k));
    out.push({
      predictedStart,
      windowStart: addDays(predictedStart, -margin),
      windowEnd: addDays(predictedStart, margin),
      confidence: LEVELS[Math.min(LEVELS.length - 1, first + k - 1)]!,
    });
  }
  return out;
}
