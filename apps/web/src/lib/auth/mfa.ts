import type { SupabaseClient } from "@supabase/supabase-js";

/**
 * Two-factor authentication for staff (P1.23.3 / SECURITY_REVIEW A07).
 *
 * Supabase models this as **assurance levels**: `aal1` is "signed in",
 * `aal2` is "signed in and passed a second factor this session". The pair
 * (current, next) is the whole state machine — `next` is what the account is
 * *capable* of, `current` is what this session has actually done:
 *
 *   next=aal1                → no factor enrolled
 *   next=aal2, current=aal1  → enrolled, but this session hasn't stepped up
 *   next=aal2, current=aal2  → stepped up
 *
 * Why staff specifically: a back-office account can read the translation portal
 * and the aggregate insights, and — more importantly — an admin can grant roles.
 * A stolen staff password should not be enough for any of that. Consumer accounts
 * may enrol too (it is offered in Settings), it is simply not forced on them.
 */

export type AalLevel = "aal1" | "aal2";

export type MfaStatus =
  /** No second factor on the account. */
  | "not_enrolled"
  /** A factor exists but this session hasn't satisfied it yet — step up. */
  | "step_up_required"
  /** Factor enrolled and satisfied for this session. */
  | "verified";

/**
 * Pure: turn Supabase's (current, next) pair into the one thing callers need.
 * Kept separate from the client call so the rule is testable without a session,
 * and stated exactly once.
 */
export function mfaStatus(
  current: AalLevel | null | undefined,
  next: AalLevel | null | undefined,
): MfaStatus {
  if (next !== "aal2") return "not_enrolled";
  return current === "aal2" ? "verified" : "step_up_required";
}

/** Read the assurance levels for the current session. Fails closed on error. */
export async function getMfaStatus(supabase: SupabaseClient): Promise<MfaStatus> {
  const { data, error } = await supabase.auth.mfa.getAuthenticatorAssuranceLevel();
  if (error || !data) return "not_enrolled";
  return mfaStatus(data.currentLevel as AalLevel | null, data.nextLevel as AalLevel | null);
}

/**
 * A TOTP factor that has completed enrolment. Supabase keeps `unverified`
 * factors around when someone abandons the QR step; treating those as "enrolled"
 * would lock an account out of its own step-up page, so they are filtered here.
 */
export async function hasVerifiedTotpFactor(supabase: SupabaseClient): Promise<boolean> {
  const { data, error } = await supabase.auth.mfa.listFactors();
  if (error || !data) return false;
  return (data.totp ?? []).some((f) => f.status === "verified");
}

/**
 * Where a staff request should go, given its MFA state. Pure so the policy is
 * visible and tested rather than buried in a guard.
 *
 * `not_enrolled` deliberately routes to Settings rather than blocking outright:
 * Settings is not staff-gated, so an admin can always reach the enrolment form.
 * There is no lockout path — which is what makes hard enforcement safe here.
 */
export function staffMfaRedirect(
  status: MfaStatus,
  locale: string,
  /** Locale-LESS destination, e.g. "/admin/insights" — the i18n router adds the prefix. */
  from: string,
): string | null {
  if (status === "verified") return null;
  if (status === "step_up_required") {
    return `/${locale}/mfa?next=${encodeURIComponent(from)}`;
  }
  return `/${locale}/settings?mfa=required`;
}

/** Only same-origin paths may be used as a post-step-up destination. */
export function safeNextPath(next: string | null | undefined, fallback: string): string {
  if (next && next.startsWith("/") && !next.startsWith("//")) return next;
  return fallback;
}
