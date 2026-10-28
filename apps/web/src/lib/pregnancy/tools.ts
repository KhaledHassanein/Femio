/**
 * Pregnancy tool ordering and test timing: the website's twin of the app's
 * `lib/domain/pregnancy_tools.dart` and `lib/domain/test_timing.dart`, bound by
 * `fixtures/domain/pregnancy-tools.json` and `fixtures/domain/test-timing.json`.
 *
 * The website has no tools tab; these exist so the rules (MR-21, MR-31) are checked on
 * both sides and cannot drift apart (ADR-070).
 */

/** From this gestational week the contraction timer is listed first (MR-31). */
export const CONTRACTIONS_FIRST_FROM_WEEK = 36;

export type PregnancyTool = "movements" | "contractions" | "appointments" | "weight";

/** The pregnancy tools in display order; `weeks` null while the due date is unknown. */
export function pregnancyToolOrder(weeks: number | null): PregnancyTool[] {
  const late = weeks !== null && weeks >= CONTRACTIONS_FIRST_FROM_WEEK;
  return late ? ["contractions", "movements", "appointments", "weight"] : ["movements", "contractions", "appointments", "weight"];
}

/**
 * The first honest day for a home pregnancy test (MR-21): the end of the predicted
 * period window, or null when cycles are irregular and no day can be named.
 */
export function pregnancyTestDay(windowEnd: string, irregular: boolean): string | null {
  return irregular ? null : windowEnd;
}
