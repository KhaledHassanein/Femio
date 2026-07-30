/**
 * Analytics consent.
 *
 * docs/13 §6: "no non-essential cookies/SDKs fire before consent". Product
 * analytics is non-essential, so it needs its own granted purpose — not a
 * side-effect of another one.
 *
 * `insights` is NOT that purpose. It reads "Use my entries to show me patterns
 * and insights" — first-party processing of her own data to show her something.
 * Treating it as permission to send events to a US-headquartered vendor would be
 * exactly the purpose-creep the FTC pursued Flo for. Hence a distinct
 * `analytics` purpose (migration 0005).
 *
 * Consent is *opt-in*: absent a granted, unrevoked record, the answer is no. No
 * consent record exists for anyone until the P1.20.2 toggle ships, so `track()`
 * is off for every user today by design.
 */

import { createClient } from "@/lib/supabase/client";

export const ANALYTICS_CONSENT_PURPOSE = "analytics";

/**
 * Whether the signed-in user has granted analytics consent. Fails closed: a
 * signed-out visitor, a query error, or a revoked record all return `false`.
 */
export async function hasAnalyticsConsent(): Promise<boolean> {
  const supabase = createClient();

  const { data: auth } = await supabase.auth.getUser();
  if (!auth.user) return false;

  // RLS already scopes this to the caller; the filter keeps the row count small.
  const { data, error } = await supabase
    .from("consent_records")
    .select("granted, granted_at, revoked_at")
    .eq("profile_id", auth.user.id)
    .eq("purpose", ANALYTICS_CONSENT_PURPOSE)
    .order("granted_at", { ascending: false })
    .limit(1);

  if (error || !data || data.length === 0) return false;

  const latest = data[0];
  return latest?.granted === true && latest.revoked_at === null;
}
