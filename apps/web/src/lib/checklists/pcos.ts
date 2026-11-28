/**
 * The PCOS visit checklist (R13.6, owner action 37): which lines the printable page
 * shows and which cited femio guide each line comes from.
 *
 * Pure data. It holds no score, weight, order of severity or cut-off, because the page
 * is a list to bring to a clinician and not a screener (decision D-04). The words live
 * in the message catalogues (`pcosChecklist`) and are copied from the guides;
 * `pcos.test.ts` fails when a line is no longer in its guide, in any of the four
 * languages, so a guide revision cannot silently leave an unsourced line behind.
 */

/** The page's locale-less route. */
export const PCOS_CHECKLIST_PATH = "/conditions/pcos/visit-checklist";

/** One block of lines under one heading. */
export interface ChecklistGroup {
  /** Key of the group's heading in the catalogue. */
  readonly key: string;
  readonly lines: ReadonlyArray<{
    /** Key of the line's text in the catalogue. */
    readonly key: string;
    /** Slug of the guide whose wording the line copies. */
    readonly guide: string;
  }>;
}

const from = (guide: string, ...keys: string[]) => keys.map((key) => ({ key, guide }));

/** Things she may have noticed. She ticks them on screen or on paper. */
export const PCOS_EXPERIENCES: readonly ChecklistGroup[] = [
  {
    key: "periods",
    lines: from("pcos-signs", "longGaps", "fewerPeriods", "periodsStop", "hardToPredict", "heavyAfterGap"),
  },
  {
    key: "skinHair",
    lines: [
      ...from("pcos-signs", "coarseHair", "acne", "scalpThinning", "oilySkin"),
      ...from("pcos", "darkPatches"),
    ],
  },
  { key: "fertility", lines: from("pcos", "ovulationTiming", "gettingPregnant") },
  {
    key: "wellbeing",
    lines: [
      ...from("pcos-hair-skin-and-mood", "lowMood", "eatingBodyImage"),
      ...from("pcos-lifestyle-and-weight", "snoring"),
      ...from("how-pcos-is-assessed", "weightChanges"),
    ],
  },
];

/** Questions she may want to ask. */
export const PCOS_QUESTIONS: readonly ChecklistGroup[] = [
  {
    key: "assessment",
    lines: from("how-pcos-is-assessed", "criteria", "otherCauses", "testsAdd", "medicines", "longTerm", "reviewFindings"),
  },
  {
    key: "hairSkinMood",
    lines: from("pcos-hair-skin-and-mood", "acneOtherCause", "moodCheck", "support", "hairSkinOption"),
  },
  { key: "bloodSugar", lines: from("pcos-insulin-resistance", "sugarTest", "heartRisk", "repeatSugar") },
  {
    key: "goals",
    lines: from("pcos-treatment-options-to-discuss", "goalFirst", "optionWhy", "notTrying", "sideEffects"),
  },
  { key: "habits", lines: from("pcos-lifestyle-and-weight", "habits", "sleepCheck", "weightTalk") },
];

/** Guides quoted in the safety and context notes, beyond those the lines come from. */
const NOTE_GUIDES = ["pcos-signs", "pcos-hair-skin-and-mood"] as const;

/** Every guide the page quotes, once each, in the order it first appears. */
export function pcosChecklistGuides(): string[] {
  const used = [...PCOS_EXPERIENCES, ...PCOS_QUESTIONS].flatMap((g) => g.lines.map((l) => l.guide));
  return [...new Set([...used, ...NOTE_GUIDES])];
}
