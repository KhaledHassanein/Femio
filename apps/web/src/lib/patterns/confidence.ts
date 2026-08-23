/**
 * How sure Femio is about a pattern it has found (P2.5).
 *
 * One model, shared by all three pattern dimensions, so timing, co-occurrence and
 * severity cannot end up meaning different things by the same word. Pure and
 * portable like the rest of tier 2 — a Dart twin has to reach the same answer, and
 * "how confident is the app" is not something two clients may disagree about.
 *
 * ## Why confidence is attached rather than implied
 *
 * `docs/03` §H.3 calls pattern analysis *"the one feature I would actually pay
 * for"*, and the reason people pay for it is the same reason it is dangerous: a
 * pattern is the shape of evidence humans over-read. Three cycles of cramps on day
 * two is a repetition; it is not a rule about her body, and a UI that states it
 * flatly invites her to treat it as one.
 *
 * Product rule 3 already forbids a single certain date for a prediction. This is
 * the same rule applied to an observation: **every pattern arrives with how much
 * it rests on, and the UI is required to render that.**
 *
 * ## The model, and what it deliberately is not
 *
 * It is a **coverage** measure — in how many of the cycles it could have appeared
 * in did it actually appear — with a floor on the absolute number of cycles. It is
 * not a p-value, not a correlation coefficient, and not a Bayesian posterior.
 * Femio has three to twelve cycles of self-reported data collected without any
 * protocol; a statistic implying more rigour than that would be a false claim
 * dressed as maths, which is worse than a vaguer honest one.
 */

export type PatternConfidence = "low" | "medium" | "high";

/**
 * The minimum evidence for a pattern to be reported at all.
 *
 * Three, matching `MIN_CYCLES_FOR_PATTERN` in `lib/cycle/symptom-patterns.ts` —
 * the same number, stated in both places on purpose, because two occurrences are a
 * line and three are the beginning of a shape. Below this the honest output is
 * nothing, not a low-confidence pattern.
 */
export const MIN_CYCLES = 3;

/** Coverage at or above this, with enough cycles behind it, reads as consistent. */
const HIGH_COVERAGE = 0.8;
const MEDIUM_COVERAGE = 0.5;
/** Below this many observed cycles, nothing is ever called `high`, however clean. */
const HIGH_MIN_CYCLES = 5;

export type Evidence = {
  /** Cycles the pattern appeared in. */
  cycles: number;
  /** Cycles it could have appeared in — the denominator, never hidden from her. */
  ofCycles: number;
};

/**
 * `null` means "not enough to say anything", and callers must drop the pattern
 * rather than render it quietly. A returned confidence always means the pattern
 * cleared the floor.
 */
export function confidenceFrom({ cycles, ofCycles }: Evidence): PatternConfidence | null {
  if (!Number.isFinite(cycles) || !Number.isFinite(ofCycles)) return null;
  if (cycles < MIN_CYCLES || ofCycles < MIN_CYCLES) return null;
  if (cycles > ofCycles) return null;

  const coverage = cycles / ofCycles;
  if (coverage >= HIGH_COVERAGE && cycles >= HIGH_MIN_CYCLES) return "high";
  if (coverage >= MEDIUM_COVERAGE) return "medium";
  return "low";
}

/**
 * Sort key so a list of patterns is ordered by how much it rests on.
 *
 * Exported rather than inlined because three modules order their own results and a
 * screen may interleave them; two orderings of the same word would show her a
 * "high" beneath a "medium".
 */
export const CONFIDENCE_RANK: Record<PatternConfidence, number> = {
  high: 3,
  medium: 2,
  low: 1,
};
