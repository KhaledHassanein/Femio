import { createClient } from "@/lib/supabase/client";
import {
  CONSENT_VERSION,
  resolveOptionalConsents,
  type ConsentRow,
  type OptionalPurpose,
} from "./purposes";

/**
 * Reading and changing consent from the browser (P1.20.2).
 *
 * RLS is the boundary, not this file: `consent_records` allows select/insert/
 * update of your own rows and **no delete** (0002), so the ledger can be added to
 * and revoked, never rewritten or erased.
 */

/** Every consent row for the signed-in user. Signed out or errored → empty. */
export async function readConsentRows(): Promise<ConsentRow[]> {
  const supabase = createClient();
  const { data: auth } = await supabase.auth.getUser();
  if (!auth.user) return [];

  const { data, error } = await supabase
    .from("consent_records")
    .select("purpose, granted, granted_at, revoked_at")
    .eq("profile_id", auth.user.id)
    .order("granted_at", { ascending: false });

  if (error || !data) return [];
  return data as ConsentRow[];
}

/** Current yes/no for each optional purpose. Fails closed. */
export async function readOptionalConsents() {
  return resolveOptionalConsents(await readConsentRows());
}

type Result = { ok: true } | { ok: false; error: string };

/**
 * Grants or withdraws one optional purpose.
 *
 * Withdrawing does two things, and both matter: it stamps `revoked_at` on the
 * live grant (so the ledger shows *when* permission ended, which is what a DSAR
 * or an audit asks) and appends an explicit `granted = false` row (so the newest
 * record states the current answer without needing to interpret timestamps).
 * Granting appends a row with the current policy version.
 */
export async function setConsent(purpose: OptionalPurpose, granted: boolean): Promise<Result> {
  const supabase = createClient();
  const { data: auth } = await supabase.auth.getUser();
  if (!auth.user) return { ok: false, error: "not_signed_in" };
  const profileId = auth.user.id;

  if (!granted) {
    const { error: revokeError } = await supabase
      .from("consent_records")
      .update({ revoked_at: new Date().toISOString() })
      .eq("profile_id", profileId)
      .eq("purpose", purpose)
      .eq("granted", true)
      .is("revoked_at", null);
    if (revokeError) return { ok: false, error: revokeError.message };
  }

  const { error } = await supabase
    .from("consent_records")
    .insert({ profile_id: profileId, purpose, granted, version: CONSENT_VERSION });
  if (error) return { ok: false, error: error.message };

  return { ok: true };
}
