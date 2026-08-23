import { diffDays, isValidISODate } from "../calculators/dates.ts";
import { bleedStarts } from "../cycle/predict.ts";

/**
 * Placing a logged entry inside a cycle — the one piece every pattern dimension
 * needs, written once (P2.5).
 *
 * `lib/cycle/symptom-patterns.ts` already had a private `cycleDayOf`, and the two
 * new dimensions need the same thing. Three copies of "which cycle does this date
 * belong to" is exactly the drift the tier rules exist to stop: a co-occurrence
 * counted against a different cycle boundary than a timing pattern would let two
 * cards on one screen disagree about her record.
 *
 * The bleed-collapsing and the drop-the-current-cycle rule are inherited rather
 * than re-decided, for the same reason.
 */

export type CycleFrame = {
  /** Bleed-collapsed period starts, ascending. */
  starts: string[];
  /**
   * Complete cycles only. The current one is still running, so an absence in it is
   * not evidence of anything — counting it would drag every denominator down and
   * make every pattern look weaker the day after her period started (R3.1.9).
   */
  completeCycles: number;
};

export function frameFor(periodStarts: readonly string[]): CycleFrame | null {
  const starts = bleedStarts([...periodStarts]);
  if (starts.length < 2) return null;
  const completeCycles = starts.length - 1;
  if (completeCycles < 1) return null;
  return { starts, completeCycles };
}

/** Which complete cycle a date falls in, and which 1-based day of it. */
export function placeInCycle(
  frame: CycleFrame,
  date: string,
): { cycle: number; day: number } | null {
  if (!isValidISODate(date)) return null;
  for (let i = frame.starts.length - 1; i >= 0; i -= 1) {
    const offset = diffDays(frame.starts[i]!, date);
    if (offset >= 0) {
      if (i >= frame.completeCycles) return null; // the cycle still running
      return { cycle: i, day: offset + 1 };
    }
  }
  return null;
}

/** An entry as the pattern modules consume it. Date only — a cycle day has no clock. */
export type Entry = {
  type: string;
  date: string;
  /** 0–4 as logged. Absent where she recorded the symptom without rating it. */
  severity?: number | null;
};
