import { addDays, diffDays, isValidISODate, todayISO } from "../calculators/dates.ts";

// Prediction v1: a simple variability model over the user's own period-start
// history. Uncertainty-honest by construction (docs/09 invariant 5, docs/12):
// returns a WINDOW + confidence, never a single certain date. In irregular mode
// the UI degrades to "expected around" + trend and shows NO "late" counter.

export type Confidence = "high" | "medium" | "low";

/**
 * Where `averageLength` came from. Carried rather than inferred, because the visit
 * report must tell a clinician which numbers she recorded and which Femio derived
 * (phase 1c) — and "her stated usual length" and "the mean of her logged cycles"
 * are different kinds of fact wearing the same shape.
 */
export type PredictionBasis = "stated" | "observed";

export type CyclePrediction = {
  averageLength: number;
  basis: PredictionBasis;
  /** Point estimate — always rendered soft/uncertain, never as a guarantee. */
  predictedStart: string;
  windowStart: string;
  windowEnd: string;
  confidence: Confidence;
  /**
   * Her cycles genuinely vary — a claim about her body, made only from evidence.
   *
   * This used to also be `true` whenever there was too little history, so two
   * logged periods — one interval, no measurable variance at all — made the UI say
   * "your cycles vary, so predictions stay a wider range". That is an inference
   * drawn from a single data point, and it is exactly the error ADR-066 refuses to
   * make when naming a phase. Femio cannot know whether her cycles vary until it
   * has seen more than one of them.
   */
  irregular: boolean;
  /**
   * Not enough history to characterise her pattern yet.
   *
   * Separate from `irregular` because the two need opposite copy: this one is
   * about Femio, and narrows on its own as she logs; that one is about her, and
   * may not. They share every *safety* behaviour — neither may show a "late"
   * counter — which is why `daysUntilPredicted` tests both.
   */
  learning: boolean;
  /**
   * Why this prediction says what it says (D3, `0018`'s `basis_json`).
   *
   * `0018`'s header: *storing the prediction is what separates hedging from
   * explaining*, and the teardown found Flo hedging well and unable to say why
   * because **there was nowhere for the reasoning to live**. This function already
   * computed every number below and then dropped all of them on the floor, which
   * is the same problem one layer earlier.
   *
   * It is evidence, never a justification. Nothing here argues the prediction is
   * right — it says what it was built from, so she can judge it herself. That is
   * also why `margin` is exposed: a woman who can see the window is ±2 days
   * *because her cycles have varied by four* is being told something true, where
   * "we are fairly confident" alone is a mood.
   */
  evidence: PredictionEvidence;
};

/**
 * Which rule set the window's half-width (D3).
 *
 * `margin = max(2, ceil(spread / 2))`, so the floor wins whenever her spread is 3
 * days or less. An explanation that says *"±2 days, which is half that
 * difference"* for a spread of 0 is not merely clumsy — it is **false**, and this
 * feature exists to be trusted. Exported so the sentence and the arithmetic cannot
 * drift: the UI asks which branch ran rather than guessing from the numbers.
 */
export function marginSource(evidence: {
  margin: number;
  spread: number;
}): "spread" | "floor" {
  return evidence.margin === Math.ceil(evidence.spread / 2) && evidence.spread > 3
    ? "spread"
    : "floor";
}

export type PredictionEvidence = {
  /** Intervals behind the average. Not periods logged — one fewer than that. */
  cyclesUsed: number;
  /** Longest minus shortest, across her **whole** history. */
  spread: number;
  /** Half-width of the window, in days. Never below 2 — an honest floor. */
  margin: number;
  /** How many of her most recent cycles the average was taken over. */
  recentWindow: number;
  /**
   * Which rule produced the window. `stated` means she has not logged enough for
   * Femio to have measured anything, and the number came from what she told us at
   * onboarding — a distinction she is entitled to see rather than infer.
   */
  rule: "stated" | "observed";
};

/**
 * How wide a window a stated length earns.
 *
 * Wider than the ±2 floor an observed history gets, because a remembered "about
 * 28 days" is a rounder fact than three measured intervals, and the picture should
 * say so before she has logged anything.
 */
/** The narrowest a predicted period window may be, either side of the date (MR-04, MR-56). */
export const MIN_WINDOW_MARGIN_DAYS = 2;

const STATED_MARGIN_DAYS = 4;

/**
 * The stated cycle lengths that earn a period range (MR-03, owner 2026-11-26). Onboarding
 * offers 21-45; a long cycle of 36-45 days still gets a low-confidence range, and the
 * fertile window stays withheld outside 21-35 (MR-08), which is where the clinical caution
 * belongs. Dropping 36-45 silently left exactly the PCOS wedge with an empty calendar.
 */
export const STATED_CYCLE_MIN_DAYS = 21;
export const STATED_CYCLE_MAX_DAYS = 45;

/**
 * Her stated length stands in until she has logged this many starts (MR-57 extension,
 * owner ruling 2026-11-26). With two starts there is one interval, too little to replace
 * what she told us: switching then made the calendar show *less* after she logged more.
 */
export const STATED_UNTIL_STARTS = 3;

function mean(values: number[]): number {
  return values.reduce((a, b) => a + b, 0) / values.length;
}

/**
 * The longest a single bleed can run, and therefore the gap below which two
 * logged dates are the *same* period rather than two cycles.
 *
 * 10 is the upper bound `profiles.stated_period_length` accepts and the outside of
 * what the NHS describes as usual bleeding, so it is deliberately generous: it
 * would rather merge two dates that were separate than split one period into two
 * cycles, because the second error is the catastrophic one (see below).
 */
const SAME_BLEED_WITHIN_DAYS = 10;

/** Sorted, de-duped, valid dates. */
function cleanStarts(starts: string[]): string[] {
  return [...new Set(starts.filter(isValidISODate))].sort();
}

/**
 * Collapse logged dates into one entry per bleed (R3.1.9).
 *
 * `cycles` holds one row per period **start**, but the tracker inserts a row for
 * whatever date is selected and nothing stopped consecutive days. A woman logging
 * Monday, Tuesday and Wednesday while bleeding — the most natural behaviour there
 * is, and exactly what a strip labelled "your bleeding" invites — created three
 * cycle starts one day apart. The app then told her:
 *
 *     Your average cycle — 1 days
 *
 * with a window already in the past, and `irregular` **false**, because 1-day
 * intervals are perfectly consistent. So it was not merely wrong; the entire
 * uncertainty apparatus reported that everything was fine. That is worse than the
 * flag confusion R3.1.7 fixed, which at least erred toward caution.
 *
 * The first date of each run wins, because a cycle is measured from the first day
 * of bleeding.
 *
 * Exported because the visit report has to show the same starts the dashboard
 * predicted from. Two answers to "when did her periods begin" is precisely the
 * drift the tier-1 rule exists to prevent.
 */
export function bleedStarts(dates: string[]): string[] {
  const sorted = cleanStarts(dates);
  const starts: string[] = [];
  for (const date of sorted) {
    const previous = starts[starts.length - 1];
    if (previous === undefined || diffDays(previous, date) > SAME_BLEED_WITHIN_DAYS) {
      starts.push(date);
    }
  }
  return starts;
}

/**
 * Predict the next period from period-start history.
 *
 * With two or more starts the intervals are her own. With exactly one start and a
 * **stated** cycle length (R3.1b.1) that number stands in, which is how every app
 * in this category behaves and is why theirs say something useful on day one while
 * Femio said nothing until the second cycle.
 *
 * The stated baseline is never mistaken for an observation: it produces
 * `basis: "stated"`, `learning: true` and no countdown, and her own intervals take
 * over the moment there are two. The report she hands a clinician has to be able
 * to say which of the two a number came from (phase 1c), and that is only possible
 * because the distinction is carried here rather than reconstructed later.
 *
 * Returns null when there is nothing to work from at all.
 */
export function predictNextPeriod(
  starts: string[],
  statedCycleLength?: number | null,
): CyclePrediction | null {
  // Consecutive logged days are one period, not several cycles (R3.1.9).
  const sorted = bleedStarts(starts);
  if (sorted.length === 0) return null;

  const stated =
    typeof statedCycleLength === "number" &&
    statedCycleLength >= STATED_CYCLE_MIN_DAYS &&
    statedCycleLength <= STATED_CYCLE_MAX_DAYS
      ? statedCycleLength
      : null;

  // One logged start plus a stated length is enough to say something honest. One
  // start and no stated length is not, and inventing 28 there would be a number she
  // never gave us presented as though she had. Her stated length keeps standing in,
  // from her latest start, until STATED_UNTIL_STARTS starts are logged (MR-57).
  if (sorted.length === 1 && stated === null) return null;
  if (sorted.length < STATED_UNTIL_STARTS && stated !== null) {
    const last = sorted[sorted.length - 1]!;
    const predictedStart = addDays(last, stated);
    return {
      // A number she gave us. `cyclesUsed: 0` is the honest count: no interval is
      // used, so nothing has been measured, and the explanation must not imply
      // otherwise (D3).
      evidence: {
        cyclesUsed: 0,
        spread: 0,
        margin: STATED_MARGIN_DAYS,
        recentWindow: 0,
        rule: "stated",
      },
      averageLength: stated,
      basis: "stated",
      predictedStart,
      windowStart: addDays(predictedStart, -STATED_MARGIN_DAYS),
      windowEnd: addDays(predictedStart, STATED_MARGIN_DAYS),
      confidence: "low",
      irregular: false,
      learning: true,
    };
  }

  const lengths: number[] = [];
  for (let i = 1; i < sorted.length; i += 1) lengths.push(diffDays(sorted[i - 1]!, sorted[i]!));

  /**
   * The average is drawn from her **recent** cycles; everything else is not
   * (R3.1.10, owner direction 2026-08-22).
   *
   * A cycle from eighteen months ago is not evidence about this month. Averaging
   * it in drags her estimate toward a body she no longer has — cycle length shifts
   * with age, with a new contraceptive, after a birth, and through perimenopause.
   *
   * **The window applies to the average and nothing else, and that scope is the
   * whole safety of it.** An earlier attempt filtered long gaps inside this
   * function and broke Track F: `regularityFrom` reads `irregular` from here, so a
   * menopausal woman who bled after eighteen months had that gap discarded and was
   * reported *regular* — the opposite of the postmenopausal-bleed red flag the
   * track exists to raise (`docs/26` §18). So `spread`, and therefore `irregular`,
   * still see every interval she has logged.
   *
   * Recent *cycles*, not recent months: a month cutoff drops a cycle at thirteen
   * months and keeps one at eleven, and for someone who logs sparsely a count is
   * the stabler unit. Six is what Flo and Clue work in and what `confidence`
   * already treats as a full history below.
   */
  const RECENT_CYCLES = 6;

  /**
   * And a gap too long to be a cycle is excluded from the average as well.
   *
   * A 542-day interval between two bleeds is not a 542-day cycle; it is a stretch
   * she did not log, or periods that did not come. The visit report has filtered
   * these since it was written and this function never did, so **the printed page
   * and the dashboard could disagree about her average** — with the printed one
   * winning any argument in a consulting room (`docs/26` §18).
   *
   * The earlier attempt to unify them applied this to `lengths` and broke Track F.
   * Scoped here to the average alone it is safe: `spread` and `irregular` below
   * still see every interval, so a bleed after eighteen months still reports as
   * irregular and still reaches the postmenopausal red flag. The gap is excluded
   * from *the arithmetic*, not from *the record* — which is the distinction the
   * first attempt missed.
   */
  const MAX_PLAUSIBLE_CYCLE_DAYS = 90;
  const usable = lengths.filter((n) => n <= MAX_PLAUSIBLE_CYCLE_DAYS);

  /**
   * If nothing she has logged is plausibly a cycle, there is no observed average.
   *
   * Two bleeds 151 days apart do not make a 151-day cycle — averaging the gap and
   * calling it her average would state a number nothing in her body produced.
   * Her stated baseline is a better answer, and "we cannot tell yet" is better
   * than both. The visit report has behaved this way since it was written; this is
   * where that behaviour moves to, rather than being lost in the unification.
   */
  if (usable.length === 0) {
    if (stated === null) return null;
    const last = sorted[sorted.length - 1]!;
    const predictedStart = addDays(last, stated);
    return {
      // She has bled more than once, but every gap was implausible as a cycle, so
      // none of them was used. `cyclesUsed: 0` again — it counts intervals the
      // average rests on, not periods she logged, and here that is none.
      evidence: {
        cyclesUsed: 0,
        spread: 0,
        margin: STATED_MARGIN_DAYS,
        recentWindow: 0,
        rule: "stated",
      },
      averageLength: stated,
      basis: "stated",
      predictedStart,
      windowStart: addDays(predictedStart, -STATED_MARGIN_DAYS),
      windowEnd: addDays(predictedStart, STATED_MARGIN_DAYS),
      confidence: "low",
      irregular: false,
      learning: true,
    };
  }

  const recent = usable.slice(-RECENT_CYCLES);
  const averageLength = Math.round(mean(recent));
  const spread = Math.max(...lengths) - Math.min(...lengths);
  const last = sorted[sorted.length - 1]!;
  const predictedStart = addDays(last, averageLength);

  // Window widens with variability; never tighter than ±2 days (honest floor).
  const margin = Math.max(MIN_WINDOW_MARGIN_DAYS, Math.ceil(spread / 2));

  // Two questions, deliberately not one: "do her cycles vary" and "have we seen
  // enough to say". `spread` over a single interval is always 0, so the first is
  // unanswerable until there are two, and answering it anyway is what produced a
  // confident claim about her body from one data point (R3.1.7).
  const learning = lengths.length < 2;
  const irregular = !learning && spread > 9;

  let confidence: Confidence;
  if (lengths.length >= 6 && spread <= 4) confidence = "high";
  else if (lengths.length >= 3 && spread <= 9) confidence = "medium";
  else confidence = "low";

  return {
    averageLength,
    basis: "observed",
    predictedStart,
    windowStart: addDays(predictedStart, -margin),
    windowEnd: addDays(predictedStart, margin),
    confidence,
    irregular,
    learning,
    evidence: {
      cyclesUsed: lengths.length,
      spread,
      margin,
      recentWindow: recent.length,
      rule: "observed",
    },
  };
}

/**
 * Days until the predicted start — ONLY when cycles are regular. In irregular
 * mode this returns null so the UI never shows a "late" counter (docs/09 §1.5).
 *
 * **Nothing calls this, and that is deliberate rather than an oversight** (noted
 * again in the R3.6 cleanup pass, 2026-08-22). Femio shows no countdown anywhere:
 * product rule 3 forbids a "late" counter, and a "3 days to go" is barely better —
 * it invites the same reading of a range as a date. So there is no caller.
 *
 * It is kept rather than deleted because deleting it makes the *next* countdown
 * easy to add without the guard. Whoever wires a day count reaches for this and
 * inherits the two refusals already baked in — irregular and still-learning both
 * return null, which is asserted by four tests. An empty function with a hostile
 * contract is a cheaper safeguard than a comment nobody reads.
 */
export function daysUntilPredicted(prediction: CyclePrediction, today = todayISO()): number | null {
  // Both states suppress the counter. Splitting `irregular` in two would have
  // silently re-enabled a "late" count for the thinnest histories — the users it
  // is least defensible for — if this had kept testing only the one flag.
  if (prediction.irregular || prediction.learning) return null;
  return diffDays(today, prediction.predictedStart);
}
