/**
 * Consent purposes and how a consent ledger resolves to yes/no (P1.20.2).
 *
 * `consent_records` is an append/revoke-only ledger (no delete policy in 0002):
 * granting writes a row, revoking stamps `revoked_at` on the live grant and
 * writes a `granted = false` row. So "does she consent to X *now*" is a reduction
 * over rows, not a column — and it must fail closed, because docs/13 §6 requires
 * that nothing non-essential happens before consent, and the absence of a record
 * is the normal state (every user predates every new purpose).
 *
 * This module is pure so the rule is testable and stated exactly once; the
 * Supabase round-trip lives in `actions.ts`.
 */

/** Required to use Femio at all: it gates every health write in RLS (0002). */
export const CORE_PURPOSE = "core" as const;

/**
 * Optional purposes, in the order they are shown. Each is independently
 * grantable and independently revocable (GDPR Art. 7(3): withdrawal must be as
 * easy as giving). `ads_contextual` exists in the schema but has no UI yet —
 * there is no advertising, so asking for it now would be consent theatre.
 */
export const OPTIONAL_PURPOSES = ["insights", "research", "analytics"] as const;
export type OptionalPurpose = (typeof OPTIONAL_PURPOSES)[number];
export type ConsentPurpose = typeof CORE_PURPOSE | OptionalPurpose;

/**
 * Consent policy version, recorded on every row so the ledger says exactly what
 * wording was agreed to (docs/13 §3). Bump when purposes or wording change —
 * 2026-07-30 added `analytics` and the Settings surface. Nothing reads it as a
 * gate: an older version still counts as consent to what it described.
 */
export const CONSENT_VERSION = "2026-07-30";

export type ConsentRow = {
  purpose: string;
  granted: boolean;
  granted_at?: string | null;
  revoked_at?: string | null;
};

/**
 * A row counts as live consent only if it granted and was never revoked. Takes
 * the two fields that decide it, so a caller that selected a narrower row (the
 * analytics gate does) can share this one definition.
 */
export function isLiveGrant(
  row: Pick<ConsentRow, "granted" | "revoked_at"> | undefined | null,
): boolean {
  return Boolean(row && row.granted === true && !row.revoked_at);
}

/**
 * The newest record for a purpose — newest wins, so a later revoke beats an
 * earlier grant and a re-grant beats the revoke. Rows without `granted_at`
 * (only possible in tests) sort oldest.
 */
export function latestFor(rows: ConsentRow[], purpose: string): ConsentRow | undefined {
  return rows
    .filter((r) => r.purpose === purpose)
    .reduce<ConsentRow | undefined>((newest, row) => {
      if (!newest) return row;
      return (row.granted_at ?? "") >= (newest.granted_at ?? "") ? row : newest;
    }, undefined);
}

/** Whether a purpose is consented to right now. Fails closed on no rows. */
export function isGranted(rows: ConsentRow[], purpose: string): boolean {
  return isLiveGrant(latestFor(rows, purpose));
}

/** Current answer for every optional purpose (missing → false). */
export function resolveOptionalConsents(rows: ConsentRow[]): Record<OptionalPurpose, boolean> {
  return {
    insights: isGranted(rows, "insights"),
    research: isGranted(rows, "research"),
    analytics: isGranted(rows, "analytics"),
  };
}
