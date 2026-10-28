/**
 * The seek-help clock (register MR-13, MR-14), as one pure function shared with the
 * app through `fixtures/domain/ttc-guidance.json`.
 *
 * Evaluation is reasonable after 12 months of trying under 35 and after 6 months
 * from 35 (ACOG, ASRM, NHS via docs/compliance/FERTILITY_AWARENESS_SAFETY.md).
 * With irregular or absent cycles there is no clock: it is reasonable to talk to a
 * clinician now, and the word "infertile" never appears. A suggestion, never a verdict.
 */
export type TryingFor = "justStarted" | "under6" | "sixTo12" | "over12";

export type GuidanceReason = "twelveMonths" | "sixMonthsFrom35" | "irregularCycles";

export type TtcGuidance = { suggestClinician: boolean; reason: GuidanceReason | null };

/** From this age, six to twelve months of trying already earns the suggestion. */
export const EARLIER_REFERRAL_AGE = 35;

export function ttcGuidance(input: { tryingFor: TryingFor | null; age: number | null; irregular: boolean }): TtcGuidance {
  if (input.irregular) return { suggestClinician: true, reason: "irregularCycles" };
  if (input.tryingFor === "over12") return { suggestClinician: true, reason: "twelveMonths" };
  if (input.tryingFor === "sixTo12" && input.age !== null && input.age >= EARLIER_REFERRAL_AGE) {
    return { suggestClinician: true, reason: "sixMonthsFrom35" };
  }
  return { suggestClinician: false, reason: null };
}
