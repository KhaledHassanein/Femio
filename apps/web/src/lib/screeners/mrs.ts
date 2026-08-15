/**
 * The Menopause Rating Scale (P2.4) — scoring, in tier 1.
 *
 * The MRS is a published, validated, freely usable self-report instrument: 11 items,
 * each rated 0 (none) to 4 (very severe), grouped into three subscales — somatic,
 * psychological and urogenital. It is the standard way this life stage is described
 * in a sentence a clinician recognises, which is exactly what makes it worth having
 * and exactly what makes it dangerous to get wrong.
 *
 * It lives here rather than in a screen because `native-readiness-lint` forbids
 * screener scoring in a client component (R2.7, ADR-060), and the reason that rule
 * exists is this file: two clients that disagree about an MRS total would produce
 * two different sentences for the same woman in the same appointment.
 *
 * ## What this returns, and the thing it must never return
 *
 * A total, three subtotals, and the count of items answered. **No band, no label,
 * no severity, no interpretation.** There is no `severity` field, no `isSevere`,
 * and no threshold constant anywhere in this file.
 *
 * The published literature does attach cut-offs to these totals. Femio does not
 * apply them, and the distinction is the whole of product rule 1: reporting "your
 * total is 19" is arithmetic on answers she gave, while reporting "your symptoms
 * are severe" is a clinical assessment — the thing that turns a wellness app into a
 * medical device and, more importantly, the thing a woman would reasonably act on
 * without ever speaking to anyone. Every screener in Femio outputs *"this is
 * screening — discuss it with your clinician"*, and this one carries the number to
 * that conversation rather than pre-empting it.
 *
 * If a future feature wants a band, that is a product decision needing its own ADR
 * and a clinician's sign-off — not a constant added here.
 *
 * ## Partial answers are answered honestly
 *
 * A total from 6 of 11 items is not comparable to a total from 11, so `answered` is
 * returned beside it and the UI says so. Scoring a blank as zero would quietly
 * describe someone as having fewer symptoms than she reported.
 *
 * Sources: Heinemann et al., *Health and Quality of Life Outcomes* (2003/2004) —
 * the MRS scale and its three-subscale structure. The instrument is used unchanged;
 * only the scoring is implemented.
 */

export const MRS_ITEMS = [
  // Somatic
  "hotFlushes",
  "heartDiscomfort",
  "sleepProblems",
  "jointMuscleDiscomfort",
  // Psychological
  "depressiveMood",
  "irritability",
  "anxiety",
  "exhaustion",
  // Urogenital
  "sexualProblems",
  "bladderProblems",
  "vaginalDryness",
] as const;

export type MrsItem = (typeof MRS_ITEMS)[number];

/** Each item is 0–4. The scale's own wording; Femio does not rename the anchors. */
export const MRS_MIN = 0;
export const MRS_MAX = 4;

export const MRS_SUBSCALES = {
  somatic: ["hotFlushes", "heartDiscomfort", "sleepProblems", "jointMuscleDiscomfort"],
  psychological: ["depressiveMood", "irritability", "anxiety", "exhaustion"],
  urogenital: ["sexualProblems", "bladderProblems", "vaginalDryness"],
} as const satisfies Record<string, readonly MrsItem[]>;

export type MrsSubscale = keyof typeof MRS_SUBSCALES;

/** Answers so far. A missing item is unanswered, never a zero. */
export type MrsAnswers = Partial<Record<MrsItem, number>>;

export type MrsScore = {
  total: number;
  subscales: Record<MrsSubscale, number>;
  /** How many of the 11 items she answered. Reported beside every total. */
  answered: number;
  complete: boolean;
};

function valid(value: number | undefined): value is number {
  return (
    typeof value === "number" &&
    Number.isInteger(value) &&
    value >= MRS_MIN &&
    value <= MRS_MAX
  );
}

export function scoreMrs(answers: MrsAnswers): MrsScore {
  const subscales = {} as Record<MrsSubscale, number>;
  let total = 0;
  let answered = 0;

  for (const [name, items] of Object.entries(MRS_SUBSCALES) as [MrsSubscale, readonly MrsItem[]][]) {
    let subtotal = 0;
    for (const item of items) {
      const value = answers[item];
      if (!valid(value)) continue;
      subtotal += value;
      answered += 1;
    }
    subscales[name] = subtotal;
    total += subtotal;
  }

  return { total, subscales, answered, complete: answered === MRS_ITEMS.length };
}

/**
 * The row this writes to `screener_results`.
 *
 * `non_diagnostic` is not passed: the column defaults to true and nothing in Femio
 * has ever set it false. Leaving it to the default means a screener row cannot be
 * marked diagnostic by forgetting a field — the same reasoning that keeps
 * restriction out of `ExperienceConfig` rather than merely unused.
 */
export function mrsResultRow(profileId: string, score: MrsScore) {
  return {
    profile_id: profileId,
    tool: "MRS",
    score: score.total,
    subscores_json: { ...score.subscales, answered: score.answered },
  };
}
