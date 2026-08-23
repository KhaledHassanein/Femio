import { createClient } from "@/lib/supabase/client";
import { isMinor } from "@/lib/persona/minor";
import type { AgeBand } from "@/lib/persona/age";
import {
  INVITE_TTL_DAYS,
  PARTNER_CONSENT_VERSION,
  SHARE_DURATION_DAYS,
  addDays,
  hasAnyCategory,
  inviteCodeFrom,
  isLiveShare,
  isPendingInvite,
  normalizeRecipientLabel,
  normalizeScope,
  parseInviteCode,
  sharedCategories,
  type ShareCategory,
  type ShareScope,
} from "./index";

/**
 * Creating, reading and ending a partner share from the browser (Phase 4.5).
 *
 * The rules live in `./index.ts` and the boundary lives in RLS and the two
 * database functions from migration 0011. This file is the round-trip between
 * them, and it is deliberately thin — every refusal it makes is also made in the
 * database, because a UI that merely hides a control is one refactor away from
 * granting it anyway (the lesson `consent/actions.ts` records for the minor gate).
 */

/** The columns `readOwnerShares` selects, as the database can actually return them. */
type LinkRow = {
  id: string;
  recipient_label: string | null;
  scope_json: unknown;
  revoked_at: string | null;
  expires_at: string | null;
  partner_profile_id: string | null;
  invite_code: string | null;
};

export type OwnerShare = {
  id: string;
  /**
   * What she calls this person. Named at the moment of consent, which is what
   * turns granular consent into Art. 9(2)(a) *explicit* consent (migration 0012).
   * Never leaves her side of the feature.
   */
  recipientLabel: string | null;
  scope: ShareScope;
  categories: ShareCategory[];
  expiresAt: string;
  /** Present only while the invite is waiting to be taken up. */
  inviteCode: string | null;
};

type Ok = { ok: true };
type Value<T> = { ok: true; value: T };
type Failure = { ok: false; error: string };

const fail = (error: string): Failure => ({ ok: false, error });

/**
 * Every share she has going right now, plus every invite still waiting.
 *
 * Expired and revoked rows are dropped rather than listed as "ended": the panel is
 * *"what he can see right now"*, and a history of who used to be able to see what
 * is a list she may not want on a phone someone else can pick up.
 */
export async function readOwnerShares(nowISO = new Date().toISOString()): Promise<OwnerShare[]> {
  const supabase = createClient();
  const { data: auth } = await supabase.auth.getUser();
  if (!auth.user) return [];

  const { data, error } = await supabase
    .from("partner_links")
    .select("id, scope_json, revoked_at, expires_at, partner_profile_id, invite_code, recipient_label")
    .eq("profile_id", auth.user.id)
    .order("created_at", { ascending: false });
  if (error || !data) return [];

  const rows = data as unknown as LinkRow[];
  return rows
    .filter((row) => isLiveShare(row, nowISO) || isPendingInvite(row, nowISO))
    .map((row) => {
      const scope = normalizeScope(row.scope_json);
      return {
        id: row.id,
        recipientLabel: row.recipient_label,
        scope,
        categories: sharedCategories(scope),
        expiresAt: row.expires_at ?? "",
        inviteCode: row.invite_code,
      };
    });
}

/**
 * Start a share: write the scope, mint a single-use code, and time-box it.
 *
 * The code is generated in the browser from `crypto.getRandomValues` and inserted
 * with the row, so nothing has to be handed back down a second channel. It is not
 * a secret in the security sense — it is useless without an account redeeming it,
 * it works once, and it dies in a fortnight.
 */
export async function createShare(
  scope: ShareScope,
  recipientLabel: string,
  nowISO = new Date().toISOString(),
): Promise<Value<string> | Failure> {
  if (!hasAnyCategory(scope)) return fail("nothing_selected");

  /**
   * Required, not optional. Art. 9(2)(a) consent names the recipient, and a share
   * created without one would be a grant to "whoever redeems this" — which is the
   * shape the design explicitly rules out. Refusing here rather than defaulting to
   * "someone" keeps the record honest about what she actually agreed to.
   */
  const label = normalizeRecipientLabel(recipientLabel);
  if (!label) return fail("recipient_required");

  const supabase = createClient();
  const { data: auth } = await supabase.auth.getUser();
  if (!auth.user) return fail("not_signed_in");

  /**
   * The minor gate, checked here as well as in `partner_shared_rows` (R3.0.8's
   * pattern, and design §5). `isMinor(null)` is `true`, so skipping the age
   * question refuses the grant — Art. 8 parental consent has no bearing on a
   * fifteen-year-old disclosing her cycle to a boyfriend, and the honest path is
   * to say so and offer her the question rather than to fail silently.
   */
  const { data: profile } = await supabase.from("profiles").select("age_band").maybeSingle();
  if (isMinor((profile?.age_band as AgeBand | null) ?? null)) return fail("not_permitted_for_age");

  const bytes = new Uint8Array(16);
  crypto.getRandomValues(bytes);
  const code = inviteCodeFrom(bytes);

  const { error } = await supabase.from("partner_links").insert({
    profile_id: auth.user.id,
    // Nobody yet. The row grants nothing until an account redeems the code.
    partner_profile_id: null,
    scope_json: scope,
    recipient_label: label,
    consent_ts: nowISO,
    version: PARTNER_CONSENT_VERSION,
    invite_code: code,
    // Until it is redeemed the row lives on the invite clock; redemption is what
    // starts the six months. An invite left in a message thread should die quickly.
    expires_at: addDays(nowISO, INVITE_TTL_DAYS),
  });
  if (error) return fail(error.message);

  return { ok: true, value: code };
}

/**
 * Extend a live share by another six months.
 *
 * Only she can call it — RLS scopes the update to `profile_id = auth.uid()`. A
 * recipient who could extend his own access would make the time-box decorative,
 * and the renewal prompt is meant to be a moment where she reconsiders, not a
 * formality he can discharge for her.
 */
export async function renewShare(
  id: string,
  nowISO = new Date().toISOString(),
): Promise<Ok | Failure> {
  const supabase = createClient();
  const { error } = await supabase
    .from("partner_links")
    .update({ expires_at: addDays(nowISO, SHARE_DURATION_DAYS), consent_ts: nowISO })
    .eq("id", id)
    .is("revoked_at", null);
  return error ? fail(error.message) : { ok: true };
}

/**
 * End a share. One call, no confirmation dialog, and **no notification of any kind**.
 *
 * Art. 7(3) requires withdrawal to be as easy as granting; that is the floor, and
 * the requirement above it is that he cannot detect it. There is no email, no
 * "access removed" screen and no state he can observe — his next load simply
 * returns nothing, exactly as it would if she had never shared. A revocation he can
 * detect is a revocation she may not feel safe making, and the population this
 * feature serves includes women whose partner is the reason they would want to
 * revoke (design §2).
 *
 * The row is stamped rather than deleted: `partner_links` follows the same
 * append/revoke discipline as `consent_records`, so the ledger can say *when*
 * permission ended, which is what a DSAR asks. `invite_code` is cleared in the same
 * write so a revoked-before-redemption invite cannot be taken up afterwards.
 */
export async function revokeShare(
  id: string,
  nowISO = new Date().toISOString(),
): Promise<Ok | Failure> {
  const supabase = createClient();
  const { error } = await supabase
    .from("partner_links")
    .update({ revoked_at: nowISO, invite_code: null })
    .eq("id", id)
    .is("revoked_at", null);
  return error ? fail(error.message) : { ok: true };
}

/** Take up an invite. Wrong, expired and already-used codes are one answer. */
export async function redeemInvite(input: string): Promise<Ok | Failure> {
  const code = parseInviteCode(input);
  if (!code) return fail("bad_code");

  const supabase = createClient();
  const { data, error } = await supabase.rpc("redeem_partner_invite", { code });
  if (error) return fail(error.message);
  return data === true ? { ok: true } : fail("bad_code");
}

/** One share as the recipient sees it: granted categories only, nothing else. */
export type PartnerShareView = {
  id: string;
  expiresAt: string;
  nextPeriod?: {
    windowStart: string;
    windowEnd: string;
    confidence: "high" | "medium" | "low";
    learning: boolean;
    irregular: boolean;
  } | null;
  cycleDates?: string[];
  phase?: { phase: string | null; cycleDay: number | null };
  pregnancy?: { weeks: number; days: number; edd: string | null } | null;
  symptoms?: { type: string; loggedAt: string }[];
  medications?: string[];
  fertility?: { loggedAt: string; opk: string | null }[];
};

/**
 * What is shared with the signed-in user, from the `partner-view` Edge Function.
 *
 * There is no local fallback and there must not be one. The client cannot compute
 * this — RLS refuses him her rows, which is the entire security model — so an
 * undeployed function is an error state, not a degraded one. `experience` can fall
 * back because it reads the caller's own record; this cannot, and pretending
 * otherwise would mean handing the browser data it is not entitled to.
 */
export async function readSharedWithMe(
  today: string,
): Promise<{ ok: true; shares: PartnerShareView[] } | { ok: false; error: string }> {
  const supabase = createClient();
  const { data: auth } = await supabase.auth.getUser();
  if (!auth.user) return { ok: false, error: "not_signed_in" };

  const { data, error } = await supabase.functions.invoke<{ shares: PartnerShareView[] }>(
    "partner-view",
    { body: { today } },
  );
  if (error || !data) return { ok: false, error: "unavailable" };
  return { ok: true, shares: data.shares ?? [] };
}
