import { addDays, diffDays, isValidISODate, todayISO } from "@/lib/calculators/dates";

// Prediction v1: a simple variability model over the user's own period-start
// history. Uncertainty-honest by construction (docs/09 invariant 5, docs/12):
// returns a WINDOW + confidence, never a single certain date. In irregular mode
// the UI degrades to "expected around" + trend and shows NO "late" counter.

export type Confidence = "high" | "medium" | "low";

export type CyclePrediction = {
  averageLength: number;
  /** Point estimate — always rendered soft/uncertain, never as a guarantee. */
  predictedStart: string;
  windowStart: string;
  windowEnd: string;
  confidence: Confidence;
  irregular: boolean;
};

function mean(values: number[]): number {
  return values.reduce((a, b) => a + b, 0) / values.length;
}

/** Sorted, de-duped, valid period-start dates. */
function cleanStarts(starts: string[]): string[] {
  return [...new Set(starts.filter(isValidISODate))].sort();
}

/**
 * Predict the next period from period-start history. Needs at least two starts
 * (one full cycle). Returns null when there isn't enough data — the UI shows a
 * "keep logging" state rather than a fabricated date.
 */
export function predictNextPeriod(starts: string[]): CyclePrediction | null {
  const sorted = cleanStarts(starts);
  if (sorted.length < 2) return null;

  const lengths: number[] = [];
  for (let i = 1; i < sorted.length; i += 1) lengths.push(diffDays(sorted[i - 1]!, sorted[i]!));

  const averageLength = Math.round(mean(lengths));
  const spread = Math.max(...lengths) - Math.min(...lengths);
  const last = sorted[sorted.length - 1]!;
  const predictedStart = addDays(last, averageLength);

  // Window widens with variability; never tighter than ±2 days (honest floor).
  const margin = Math.max(2, Math.ceil(spread / 2));

  // Irregular when cycles vary widely or there's too little history to trust.
  const irregular = spread > 9 || lengths.length < 2;

  let confidence: Confidence;
  if (lengths.length >= 6 && spread <= 4) confidence = "high";
  else if (lengths.length >= 3 && spread <= 9) confidence = "medium";
  else confidence = "low";

  return {
    averageLength,
    predictedStart,
    windowStart: addDays(predictedStart, -margin),
    windowEnd: addDays(predictedStart, margin),
    confidence,
    irregular,
  };
}

/**
 * Days until the predicted start — ONLY when cycles are regular. In irregular
 * mode this returns null so the UI never shows a "late" counter (docs/09 §1.5).
 */
export function daysUntilPredicted(prediction: CyclePrediction, today = todayISO()): number | null {
  if (prediction.irregular) return null;
  return diffDays(today, prediction.predictedStart);
}
