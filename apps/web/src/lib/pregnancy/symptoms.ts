/**
 * Pregnancy symptom logging (P1.13d).
 *
 * `/track` offered the cycle symptom set to everyone, so a pregnant user was asked about
 * period cramps and given nowhere to record vomiting, swelling or reduced movements. Worse
 * than the missing options: the ones that matter most in pregnancy are **not ordinary log
 * entries at all** — they are the reason to stop logging and contact someone.
 *
 * So this file does two jobs. It defines a symptom set appropriate to pregnancy, reusing
 * existing keys wherever one already fits so nothing needs re-translating. And it marks the
 * subset that must never be silently recorded.
 *
 * THE URGENCY TIERS MIRROR `docs/content/articles/pregnancy-warning-signs.md` deliberately,
 * item for item. If the app and the article disagree about what is an emergency, one of them
 * is wrong and the reader cannot tell which — and she is most likely to check the app.
 */

/** Groups shown on `/track` in pregnancy mode. Keys reuse the shared symptom taxonomy where one exists. */
export const PREGNANCY_SYMPTOM_GROUPS = [
  {
    group: "common",
    symptoms: [
      "nausea",
      "vomiting",
      "fatigue",
      "heartburn",
      "constipation",
      "backache",
      "breastTenderness",
      "insomnia",
      "cravings",
      "dizziness",
    ],
  },
  {
    group: "body",
    symptoms: ["swelling", "pelvicPain", "cramps", "shortnessOfBreath", "braxtonHicks", "itching"],
  },
  { group: "mood", symptoms: ["anxious", "moodSwings", "sad", "irritable", "lowMotivation", "brainFog"] },
] as const;

/**
 * Symptoms that mean "contact emergency services now", from the article's
 * "Seek emergency help now" list. Logging one of these without saying so would be the
 * app quietly filing away the exact thing it should be interrupting for.
 */
export const EMERGENCY_SYMPTOMS = [
  "heavyBleeding",
  "severeAbdominalPain",
  "severeHeadacheWithVision",
  "troubleBreathing",
  "chestPain",
  "fainting",
  "seizure",
  "legPainSwelling",
  "thoughtsOfHarm",
] as const;

/**
 * Symptoms needing same-day contact with a maternity service — urgent, but not an
 * emergency-department instruction. Kept as a separate tier because collapsing the two
 * would either under-react to the first list or over-react to this one, and an app that
 * cries emergency at everything trains people to ignore it.
 */
export const SAME_DAY_SYMPTOMS = [
  "anyBleeding",
  "fluidLeaking",
  "fever",
  "repeatedVomiting",
  "painPassingUrine",
  "faceHandSwelling",
  "persistentHeadache",
  "visionChanges",
  "severeItching",
  "reducedMovements",
] as const;

export type Urgency = "emergency" | "sameDay";

const EMERGENCY_SET: ReadonlySet<string> = new Set(EMERGENCY_SYMPTOMS);
const SAME_DAY_SET: ReadonlySet<string> = new Set(SAME_DAY_SYMPTOMS);

/** Every key selectable in pregnancy mode, including both urgency tiers. */
export const PREGNANCY_SYMPTOMS: ReadonlySet<string> = new Set([
  ...PREGNANCY_SYMPTOM_GROUPS.flatMap((g) => g.symptoms),
  ...EMERGENCY_SYMPTOMS,
  ...SAME_DAY_SYMPTOMS,
]);

/**
 * The highest urgency among the selected symptoms, or null if none is urgent.
 * Returns the *highest* rather than a list because the guidance differs by tier and
 * showing both at once buries the more serious one.
 */
export function urgencyOf(selected: Iterable<string>): Urgency | null {
  let sameDay = false;
  for (const key of selected) {
    if (EMERGENCY_SET.has(key)) return "emergency";
    if (SAME_DAY_SET.has(key)) sameDay = true;
  }
  return sameDay ? "sameDay" : null;
}

/** Is this symptom one that should carry a visible urgency marker in the picker? */
export function urgencyFor(key: string): Urgency | null {
  if (EMERGENCY_SET.has(key)) return "emergency";
  if (SAME_DAY_SET.has(key)) return "sameDay";
  return null;
}
