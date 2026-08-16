/**
 * PHQ-9 and GAD-7 (P2.7) — scoring, in tier 1.
 *
 * The two most widely used mood screeners in general practice, and the pair a
 * clinician is most likely to recognise from a sentence. Both share a shape — items
 * rated 0–3 over "the last two weeks", summed — so they share a module rather than
 * two near-identical files, and the *differences* are what the code makes explicit.
 *
 * They follow the pattern the MRS set (`./mrs.ts`) and the EPDS sharpened
 * (`./epds.ts`):
 *
 * - **A number, never a grade.** No band, no "moderately severe", no colour. The
 *   published severity bands are real and Femio applies none of them: reporting
 *   "your total is 14" is arithmetic on her own answers, while reporting "moderate
 *   depression" is a clinical assessment, and the person that hurts is the one who
 *   reads the milder label and decides the appointment can wait.
 * - **Partial answers carry their count.** A total from four items is not
 *   comparable to one from nine, and scoring a blank as zero would describe her as
 *   having fewer symptoms than she reported.
 * - **PHQ-9 item 9 behaves like EPDS item 10.** Any answer above "not at all"
 *   returns `selfHarmItemPositive` as a separate flag no total can mask, and the
 *   client opens the crisis route on the answer rather than on submit (P1.26.3).
 *   GAD-7 has no such item and the flag is always false for it — stated in the type
 *   rather than left for a screen to know.
 *
 * Sources: Kroenke, Spitzer & Williams, *J Gen Intern Med* (2001) 16, 606–613
 * (PHQ-9); Spitzer, Kroenke, Williams & Löwe, *Arch Intern Med* (2006) 166,
 * 1092–1097 (GAD-7). Both instruments are used unchanged; only the scoring is here.
 */

export const PHQ9_ITEMS = [
  "littleInterest",
  "feelingDown",
  "sleepTrouble",
  "tiredLowEnergy",
  "appetiteChange",
  "feelingBadAboutSelf",
  "troubleConcentrating",
  "movingSlowlyOrRestless",
  // Item 9 — handled apart from the total. See the module note.
  "betterOffDead",
] as const;

export const GAD7_ITEMS = [
  "feelingNervous",
  "cannotStopWorrying",
  "worryingTooMuch",
  "troubleRelaxing",
  "restless",
  "easilyAnnoyed",
  "afraidSomethingAwful",
] as const;

export type Phq9Item = (typeof PHQ9_ITEMS)[number];
export type Gad7Item = (typeof GAD7_ITEMS)[number];
export type MoodItem = Phq9Item | Gad7Item;

export const MOOD_MIN = 0;
export const MOOD_MAX = 3;

/** PHQ-9's item 9. GAD-7 has no equivalent, which is why this is per-instrument. */
export const PHQ9_SELF_HARM_ITEM: Phq9Item = "betterOffDead";

export type MoodTool = "PHQ9" | "GAD7";

export const MOOD_ITEMS: Record<MoodTool, readonly MoodItem[]> = {
  PHQ9: PHQ9_ITEMS,
  GAD7: GAD7_ITEMS,
};

export type MoodAnswers = Partial<Record<MoodItem, number>>;

export type MoodScore = {
  tool: MoodTool;
  total: number;
  answered: number;
  complete: boolean;
  /**
   * PHQ-9 item 9 answered above "not at all". Always false for GAD-7, which has no
   * such item — a fact of the instrument, kept in the type so no screen has to know
   * it and none can get it wrong.
   *
   * Not folded into the total and not a severity: it is the trigger for
   * `useCrisisHelp().open()` (P1.26.3), and it fires whatever the total is, because
   * a woman can answer it above zero while scoring below every published band.
   */
  selfHarmItemPositive: boolean;
};

function valid(value: number | undefined): value is number {
  return (
    typeof value === "number" &&
    Number.isInteger(value) &&
    value >= MOOD_MIN &&
    value <= MOOD_MAX
  );
}

export function scoreMood(tool: MoodTool, answers: MoodAnswers): MoodScore {
  const items = MOOD_ITEMS[tool];
  let total = 0;
  let answered = 0;

  for (const item of items) {
    const value = answers[item];
    if (!valid(value)) continue;
    total += value;
    answered += 1;
  }

  const selfHarm = tool === "PHQ9" ? answers[PHQ9_SELF_HARM_ITEM] : undefined;

  return {
    tool,
    total,
    answered,
    complete: answered === items.length,
    selfHarmItemPositive: valid(selfHarm) && selfHarm > MOOD_MIN,
  };
}

/**
 * The row this writes to `screener_results`.
 *
 * `non_diagnostic` is not passed — the column defaults to true and nothing in Femio
 * has ever set it false, so a screener row cannot become diagnostic by someone
 * forgetting a field.
 */
export function moodResultRow(profileId: string, score: MoodScore) {
  return {
    profile_id: profileId,
    tool: score.tool,
    score: score.total,
    subscores_json: {
      answered: score.answered,
      selfHarmItemPositive: score.selfHarmItemPositive,
    },
  };
}
