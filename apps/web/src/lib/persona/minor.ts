import type { AgeBand } from "./age";

/**
 * Minor tier (R2.5b, `docs/09` invariant 1, product rule 2).
 *
 * Pure and portable, like the rest of tier 1 — a Flutter client has to reach the
 * same answer, and this one decides whether a third-party SDK ever sees a child's
 * data.
 *
 * ## The rule, and the one thing it is not
 *
 * Teen mode **gates ads, social and data sharing — never knowledge.** Every article
 * and every tool stays reachable, because a fifteen-year-old asking whether her
 * periods are normal is exactly who the library was written for. Withholding it
 * would be the one restriction the product forbids itself, dressed up as
 * protection.
 *
 * ## Why the boundary sits at 18 here
 *
 * GDPR Art. 8 puts the age of consent for information-society services between 13
 * and 16 depending on the member state, and Femio ships in four locales across the
 * EU, the UK and MENA. Rather than encode a jurisdiction map the legal work
 * (P0.12) has not produced yet, this is deliberately **the most protective reading
 * available**: everyone below `18_24` is treated as a minor for analytics and
 * sharing purposes. Over-protecting an eighteen-year-old costs her nothing —
 * nothing is hidden, only a vendor script is not loaded. Under-protecting a
 * fourteen-year-old is not recoverable.
 *
 * When P0.12 lands with real per-jurisdiction ages, this is the single function to
 * change, and `docs/13` §3 is where the mapping belongs.
 */

const MINOR_BANDS: readonly AgeBand[] = ["under_13", "13_15", "16_17"];

/**
 * `null` means she has not told us — and an unknown age is treated as a minor.
 *
 * That is the uncomfortable default and the right one: the alternative is that
 * skipping an optional question silently opts a child into analytics. Failing
 * closed here costs an adult one un-fired vendor script.
 */
export function isMinor(ageBand: AgeBand | null | undefined): boolean {
  if (!ageBand) return true;
  return MINOR_BANDS.includes(ageBand);
}

/**
 * Consent purposes a minor may not be offered, regardless of what she taps.
 *
 * `analytics` sends pseudonymous product events to a third-party SDK (ADR-017),
 * and `research` shares aggregated patterns. Neither is something a child can
 * meaningfully consent to under Art. 8 without verifiable parental consent, which
 * Femio does not implement. `insights` stays available: it is first-party
 * processing of her own record, inside our own database, and it is what makes the
 * app useful to her.
 */
export const MINOR_BLOCKED_PURPOSES = ["analytics", "research"] as const;

export function purposeAllowedForAge(
  purpose: string,
  ageBand: AgeBand | null | undefined,
): boolean {
  if (!isMinor(ageBand)) return true;
  return !(MINOR_BLOCKED_PURPOSES as readonly string[]).includes(purpose);
}
