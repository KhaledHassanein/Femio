import { diffDays } from "../calculators/dates.ts";
import { bleedStarts } from "./predict.ts";

/**
 * What her cycles actually did — tier 2, so pure and portable.
 *
 * This is the wedge `docs/26` §7 identified: **neither Flo nor Clue handles
 * irregular cycles well**, and Femio's honesty about them was expressed only as
 * *withholding* — a warning-coloured note saying predictions stay wider, and a
 * phase strip that goes blank. Correct, and an apology.
 *
 * The reframe is Femio's own, already written and clinician-reviewed in
 * `docs/content/articles/irregular-cycles-and-timing.md`:
 *
 * > Femio widens its prediction window when your cycles vary, and stops showing
 * > one entirely when there is nothing honest to predict from. **That is not the
 * > app failing**; a confident date built on unstable data would be an invention,
 * > and acting on it is what wastes months.
 *
 * So instead of a smaller version of the regular experience, an irregular cycle
 * gets something the regular one does not need: **her own observed range, stated
 * as fact.** "Your cycles have run 24 to 41 days" is not a prediction, carries no
 * uncertainty, and is the single most useful sentence available to her — it is
 * also exactly what a clinician asks first.
 *
 * Nothing here grades the spread. `docs/25` §5a's rule against implying a target
 * applies with force: there is no ideal variability, and a wide range is a fact
 * about her body rather than a failure of it.
 */

export type ObservedRange = {
  /** Shortest observed cycle, in days. */
  shortest: number;
  /** Longest observed cycle, in days. */
  longest: number;
  /** `longest - shortest`. Stated, never judged. */
  spread: number;
  /** How many completed cycles this is drawn from. The evidence. */
  cycles: number;
};

/**
 * Below this there is no range worth stating — two intervals can differ by
 * anything and mean nothing. Matches the threshold `symptom-patterns.ts` uses for
 * the same reason: two points are a line, three begin a shape.
 */
const MIN_INTERVALS = 3;

/**
 * Intervals longer than this are gaps rather than cycles, and including one would
 * make her range read "24 to 151 days" — technically true of her logs and useless
 * as a description of her cycles. The same bound the visit report has always used
 * (`lib/account/visit-summary.ts`), and deliberately the same number, since two
 * answers to "what counts as a cycle" is the drift R3.1.10 exists to close.
 */
const MAX_PLAUSIBLE_CYCLE_DAYS = 90;

/**
 * Her observed cycle range, or `null` when there is not enough to state one.
 *
 * `null` must render as nothing at all rather than an empty card — a box asking
 * her to log more is nagging, and she is already being asked on the dashboard.
 */
export function observedRange(periodDates: readonly string[]): ObservedRange | null {
  const starts = bleedStarts([...periodDates]);
  if (starts.length < MIN_INTERVALS + 1) return null;

  const lengths: number[] = [];
  for (let i = 1; i < starts.length; i += 1) {
    const length = diffDays(starts[i - 1]!, starts[i]!);
    if (length > 0 && length <= MAX_PLAUSIBLE_CYCLE_DAYS) lengths.push(length);
  }
  if (lengths.length < MIN_INTERVALS) return null;

  const shortest = Math.min(...lengths);
  const longest = Math.max(...lengths);
  return { shortest, longest, spread: longest - shortest, cycles: lengths.length };
}
