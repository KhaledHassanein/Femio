import type { PersonaMode } from "./modes";

/**
 * The condition vocabulary the wizard asks about (P1.27.8, docs/09 §4 Q2–Q6).
 *
 * This is the highest-value signal in the whole taxonomy: reading all 73 specs,
 * **53 of them key on a self-reported condition** (ADR-058). `conditions_flagged`
 * has existed since schema v1 and nothing has ever written to it, which is why the
 * resolver could only reach 15 personas.
 *
 * ## Where these codes come from
 *
 * Straight from the persona list in `docs/08` §2 — one code per condition that
 * *defines* a persona, and nothing else. It is deliberately not derived from a
 * keyword sweep over the spec files: almost every persona mentions anxiety
 * somewhere, which would have produced a vocabulary of things no persona is
 * actually keyed on.
 *
 * ## Three rules this file exists to hold
 *
 * 1. **Asked, never inferred.** Conditions are special-category data. Femio does
 *    not deduce a condition from symptom logs and quietly store it — she ticks a
 *    box or it does not exist. (`source: "self"` on every row we write.)
 * 2. **Non-diagnostic, always.** `conditions_flagged.non_diagnostic` defaults true
 *    and we never set it false. The wizard's wording is "conditions your clinician
 *    is watching", not "select your diagnoses" — she is reporting what she has been
 *    told, not being assessed (product rule 1).
 * 3. **Stage-scoped for relevance, never for access.** Each life stage offers the
 *    conditions its personas key on, because asking a pregnant woman about
 *    contraception side-effects is noise. Scoping the *question* is not restricting
 *    the *app*: every article and tool stays reachable from every mode (invariant
 *    1), and Settings can re-run the wizard at any stage.
 */

export const CONDITION_CODES = [
  // Gynae / cycle (Track B)
  "pcos",
  "endometriosis",
  "fibroids",
  "adenomyosis",
  "heavy_bleeding",
  "pmdd",
  "dysmenorrhea",
  "menstrual_migraine",
  "thyroid",
  "poi",
  // Pregnancy (Track D)
  "gestational_diabetes",
  "diabetes",
  "hypertension",
  "pre_eclampsia",
  "prior_preterm",
  "multiple_gestation",
  "anemia",
  "high_bmi",
  "prior_csection",
  "hyperemesis",
  "cholestasis",
  "rh_negative",
  // Cross-stage
  "depression_anxiety",
  "prior_loss",
] as const;

export type ConditionCode = (typeof CONDITION_CODES)[number];

/**
 * Which conditions each stage asks about. A code may appear in several stages —
 * thyroid keys B17, C8, D7 and E7 — because the same condition means different
 * things at different points in a life, which is the entire premise of the app.
 */
export const CONDITIONS_BY_MODE: Record<PersonaMode, readonly ConditionCode[]> = {
  cycle: [
    "pcos",
    "endometriosis",
    "fibroids",
    "adenomyosis",
    "heavy_bleeding",
    "pmdd",
    "dysmenorrhea",
    "menstrual_migraine",
    "thyroid",
    "depression_anxiety",
  ],
  ttc: [
    "pcos",
    "endometriosis",
    "thyroid",
    "poi",
    "prior_loss",
    "depression_anxiety",
  ],
  pregnancy: [
    // `gestational_diabetes` and `diabetes` are separate codes on purpose. docs/09
    // §8 rule 3: D3 resolves postpartum with a one-off OGTT, D4 is lifelong care,
    // and conflating them gives the wrong follow-up to a real condition. Asking
    // two questions is how the resolver gets to gate on the difference.
    "gestational_diabetes",
    "diabetes",
    "hypertension",
    "pre_eclampsia",
    "thyroid",
    "prior_preterm",
    "multiple_gestation",
    "anemia",
    "high_bmi",
    "prior_csection",
    "hyperemesis",
    "cholestasis",
    "rh_negative",
    "prior_loss",
    "depression_anxiety",
  ],
  menopause: ["thyroid", "poi", "depression_anxiety"],
  // Z1. Offering the union here would be a wall of checkboxes to someone who has
  // just told us she does not want to categorise herself. The progressive resolver
  // (P1.27.5) is how she gets tailored instead.
  general: [],
};

/** Rows for `conditions_flagged`. Always self-reported, always non-diagnostic. */
export function buildConditionRows(
  profileId: string,
  codes: Iterable<ConditionCode>,
): Array<{
  profile_id: string;
  condition_code: ConditionCode;
  source: "self";
  non_diagnostic: true;
}> {
  return [...new Set(codes)].map((condition_code) => ({
    profile_id: profileId,
    condition_code,
    source: "self",
    non_diagnostic: true,
  }));
}

export function isConditionCode(value: unknown): value is ConditionCode {
  return typeof value === "string" && (CONDITION_CODES as readonly string[]).includes(value);
}
