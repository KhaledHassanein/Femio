/**
 * The Edinburgh Postnatal Depression Scale (P2.7) — scoring, in tier 1.
 *
 * The EPDS is the most widely used perinatal mood screening instrument in the
 * world: ten items, each 0–3, validated in pregnancy and after birth and freely
 * reproducible with attribution. It is what a health visitor or midwife is likely
 * to hand a woman on paper, which is exactly why having it here is worth doing —
 * and exactly why the boundaries below are not negotiable.
 *
 * Scoring lives in tier 1 because `native-readiness-lint` forbids screener scoring
 * in a client component (R2.7). Two clients disagreeing about an EPDS total is a
 * safety problem, not a duplication one.
 *
 * ## Item 10 is not like the other nine
 *
 * *"The thought of harming myself has occurred to me."* Any answer above "never"
 * is the one place in this entire codebase where a **number is not the output**.
 * The published guidance is unanimous that a positive item 10 is followed up
 * regardless of the total, and a woman can answer it above zero while scoring below
 * any threshold anyone would call concerning.
 *
 * So `scoreEpds` returns `selfHarmItemPositive` as a **separate, first-class flag**
 * that no total can mask, and `P1.26.3` is the rule the client must obey: an
 * affirmative item 10 opens the crisis help route immediately, before the score is
 * shown and whatever the score is. That is a decision this module makes; it is not
 * left to a screen to remember.
 *
 * ## What it still refuses to do
 *
 * **No band, no label, no "probable depression".** The literature attaches cut-offs
 * — commonly 10, 11 or 13 depending on setting and translation, which is itself the
 * argument — and Femio applies none of them. It reports the number and says *this
 * is screening, discuss it with your clinician*, the same posture as the MRS
 * (`./mrs.ts`). The one thing it acts on is item 10, and it acts by **opening a
 * door**, never by rendering a conclusion.
 *
 * Source: Cox, Holden & Sagovsky, *British Journal of Psychiatry* (1987), 150,
 * 782–786. The instrument is used unchanged; only the scoring is implemented.
 */

export const EPDS_ITEMS = [
  "ableToLaugh",
  "lookedForward",
  "blamedMyself",
  "anxiousOrWorried",
  "scaredOrPanicky",
  "thingsGettingOnTop",
  "difficultySleeping",
  "sadOrMiserable",
  "unhappyAndCrying",
  // Item 10. See the module note — this one is handled apart from the total.
  "thoughtOfHarmingMyself",
] as const;

export type EpdsItem = (typeof EPDS_ITEMS)[number];

export const EPDS_MIN = 0;
export const EPDS_MAX = 3;

/** The item whose answer is followed up on its own, whatever the total says. */
export const EPDS_SELF_HARM_ITEM: EpdsItem = "thoughtOfHarmingMyself";

/**
 * Items the scale scores in reverse — "as much as I always could" is 0 and "not at
 * all" is 3. Getting this wrong understates a woman's score on the three items
 * about pleasure and humour, which are the ones a depressed person answers lowest.
 */
const REVERSE_SCORED: readonly EpdsItem[] = ["ableToLaugh", "lookedForward"];

export type EpdsAnswers = Partial<Record<EpdsItem, number>>;

export type EpdsScore = {
  total: number;
  answered: number;
  complete: boolean;
  /**
   * True when item 10 was answered above "never".
   *
   * Deliberately not folded into the total, and deliberately not a severity. It is
   * the trigger for `useCrisisHelp().open()` (P1.26.3) and it fires **regardless of
   * the total**, because a woman can answer this above zero while scoring below any
   * published cut-off.
   */
  selfHarmItemPositive: boolean;
};

function valid(value: number | undefined): value is number {
  return (
    typeof value === "number" &&
    Number.isInteger(value) &&
    value >= EPDS_MIN &&
    value <= EPDS_MAX
  );
}

/**
 * The stored value for an item, given which option she picked.
 *
 * Options are always presented least-symptomatic first; the reverse-scored items
 * are flipped here rather than in a screen, so a client cannot get it wrong and no
 * two clients can get it differently.
 */
export function valueForOption(item: EpdsItem, optionIndex: number): number {
  return REVERSE_SCORED.includes(item) ? EPDS_MAX - optionIndex : optionIndex;
}

/**
 * Which option is selected, given the stored value. The inverse of
 * `valueForOption`, and worth exporting rather than open-coding: a screen that
 * derives it with its own arithmetic will get the reverse-scored items subtly
 * wrong, and the wrong chip will look selected on exactly the two questions a
 * depressed woman answers lowest.
 */
export function optionForValue(item: EpdsItem, value: number): number {
  return REVERSE_SCORED.includes(item) ? EPDS_MAX - value : value;
}

export function scoreEpds(answers: EpdsAnswers): EpdsScore {
  let total = 0;
  let answered = 0;

  for (const item of EPDS_ITEMS) {
    const value = answers[item];
    if (!valid(value)) continue;
    total += value;
    answered += 1;
  }

  const selfHarm = answers[EPDS_SELF_HARM_ITEM];

  return {
    total,
    answered,
    complete: answered === EPDS_ITEMS.length,
    selfHarmItemPositive: valid(selfHarm) && selfHarm > EPDS_MIN,
  };
}

/**
 * The row this writes to `screener_results`.
 *
 * `non_diagnostic` is not passed — the column defaults to true and nothing in Femio
 * has ever set it false, so a screener row cannot become diagnostic by someone
 * forgetting a field. The item-10 flag is recorded in `subscores_json` because it
 * is a fact about what she answered; it is **not** a conclusion about her, and
 * nothing downstream may treat it as one.
 */
export function epdsResultRow(profileId: string, score: EpdsScore) {
  return {
    profile_id: profileId,
    tool: "EPDS",
    score: score.total,
    subscores_json: {
      answered: score.answered,
      selfHarmItemPositive: score.selfHarmItemPositive,
    },
  };
}
