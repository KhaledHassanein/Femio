/**
 * The stage-scoped follow-up question (P1.27.8, `docs/09` §4 Q3-Q6).
 *
 * `docs/09` §4 specifies six wizard branches; Q1 (life stage) and Q2 (the condition
 * triage) shipped in P1.27.4/P1.27.8's first half. Q3-Q6 are one further question
 * per stage, and the wizard's own comment already described them as "collapsed into
 * one stage-scoped question, because they only ever differ by which conditions they
 * offer" — this is the other axis of that: they differ by what they *ask*.
 *
 * Only two stages have a question worth asking today, and the discipline is that a
 * question exists here **only if a resolver rule reads its answer**. Asking a woman
 * something Femio then ignores is worse than not asking:
 *
 * - **TTC — how long have you been trying?** The only thing separating C1 from C2
 *   and C3, and utterly underivable: she was trying long before she installed an
 *   app. C2 §I sets it at twelve months under 35, C3 at six months over — the
 *   published evaluation clocks, not our invention.
 * - **Postpartum — roughly when did you give birth?** `weeksSincePregnancyEnd`
 *   could only ever come from a pregnancy row Femio watched end, and the common
 *   Track E user installed Femio *after* the birth. Without this her E1 gate fails
 *   and she falls to Z1 — the defect R2.4 fixed for the minority and this fixes for
 *   the majority.
 *
 * Bands rather than dates, for the same reason age is a band: nothing downstream
 * needs more precision, and a due date or a delivery date is a sharper piece of
 * health data than the answer requires (data minimisation, `docs/14`).
 */

import type { PersonaMode } from "./modes.ts";

/** Months, as the lower bound of the band she picked. */
export const TTC_DURATION_BANDS = [
  { id: "under6", months: 0 },
  { id: "sixToTwelve", months: 6 },
  { id: "oneToTwoYears", months: 12 },
  { id: "overTwoYears", months: 24 },
] as const;

/** Weeks, as the lower bound of the band she picked. */
export const BIRTH_RECENCY_BANDS = [
  { id: "underSixWeeks", weeks: 0 },
  { id: "sixWeeksToThreeMonths", weeks: 6 },
  { id: "threeToSixMonths", weeks: 13 },
  { id: "sixToTwelveMonths", weeks: 26 },
  { id: "overAYear", weeks: 52 },
] as const;

export type TtcDurationBand = (typeof TTC_DURATION_BANDS)[number]["id"];
export type BirthRecencyBand = (typeof BIRTH_RECENCY_BANDS)[number]["id"];
export type FollowUpBand = TtcDurationBand | BirthRecencyBand;

export type FollowUp = {
  /** Names the i18n block and decides which field the answer becomes. */
  id: "ttc" | "birth";
  bands: readonly { readonly id: FollowUpBand }[];
};

/**
 * Which stage gets which question — **a lookup, not a branch**.
 *
 * The wizard's first version wrote `mode === "ttc"` and `mode === "postpartum"`
 * around two near-identical blocks, and `persona-branch-lint` failed the build
 * over it. It was right, and for the reason `CONDITIONS_BY_MODE` already existed:
 * what a stage asks is data. A mode with no entry has no follow-up, and the
 * wizard renders nothing without knowing which mode that is.
 */
export const FOLLOWUP_BY_MODE: Partial<Record<PersonaMode, FollowUp>> = {
  ttc: { id: "ttc", bands: TTC_DURATION_BANDS },
  postpartum: { id: "birth", bands: BIRTH_RECENCY_BANDS },
};

/**
 * The **lower** bound, always.
 *
 * "One to two years" becomes twelve months, not eighteen. Every rule that reads
 * these is a `>=` threshold, so taking the bottom of the band means a woman is
 * never moved into a persona her own answer does not support — the error, when
 * there is one, is on the side of not assuming.
 */
export function monthsFromTtcBand(band: TtcDurationBand | null): number | null {
  return TTC_DURATION_BANDS.find((b) => b.id === band)?.months ?? null;
}

export function weeksFromBirthBand(band: BirthRecencyBand | null): number | null {
  return BIRTH_RECENCY_BANDS.find((b) => b.id === band)?.weeks ?? null;
}
