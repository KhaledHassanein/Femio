/**
 * Partner sharing — the scope vocabulary and the liveness rule (Phase 4.5).
 *
 * Design and reasoning: `docs/compliance/PARTNER_SHARING_DESIGN.md`, approved by
 * the owner on 2026-08-23, with the risk analysis in `DPIA.md` §3–§4.
 *
 * Pure and framework-free on purpose. Every decision this file makes is a
 * *privacy* decision rather than a medical one, so it does not belong in tier 1 —
 * but a Flutter client has to reach exactly the same answer about what a partner
 * may see, and a second implementation that drifts is the failure mode this
 * feature cannot survive. So it is written once, here, with no imports.
 *
 * ## The three properties the rest of the code hangs off
 *
 * 1. **The never-shareable class has no representation.** `ShareCategory` cannot
 *    express "screener results" — there is no id for them, so there is no
 *    checkbox, no param, and nothing a coercive partner can ask her to tick.
 *    §4 of the design is explicit that this is the protection: *a checkbox she can
 *    be pressured into ticking is worse than no checkbox.* `NEVER_SHAREABLE` below
 *    is documentation and a test fixture, never a set the UI iterates.
 * 2. **Nothing is on by default.** `EMPTY_SCOPE` is every category false, and
 *    `normalizeScope` treats anything it does not recognise as false. A scope that
 *    fails to parse shares nothing.
 * 3. **A withheld category is absent, not false.** `sharedCategories` returns only
 *    what is granted; the payload the partner receives is built from that list, so
 *    the shape of his view carries no evidence of what she left out (§3).
 */

/**
 * What may be shared, in the order it is offered.
 *
 * `nextPeriod` first because it is the common case and the least sensitive, and
 * the three "off by default and obviously personal" categories — symptoms,
 * medications, charting — sit lower down. Order is presentation, not permission:
 * every one of them is independently grantable and independently revocable.
 */
export const SHARE_CATEGORIES = [
  "nextPeriod",
  "cycleDates",
  "phase",
  "pregnancy",
  "symptoms",
  "medications",
  "fertility",
] as const;

export type ShareCategory = (typeof SHARE_CATEGORIES)[number];

/**
 * Never offered — not as an unticked box, not behind a warning, not at all.
 *
 * These are strings rather than members of `ShareCategory` precisely because the
 * type must not be able to name them. They exist so the decision is legible in
 * code and so a test can assert the two sets never intersect: the day someone adds
 * `"screeners"` to `SHARE_CATEGORIES`, that test is what stops it.
 *
 * - `screenerResults` — PHQ-9, GAD-7, EPDS. The highest-harm disclosure in the
 *   product and the most weaponisable in a custody or immigration dispute.
 * - `crisis` — `help-now` collects nothing by design (P1.26) and nothing from that
 *   flow becomes shareable later either.
 * - `appointmentQuestions` — `prep_json`. She writes those for a clinician; they
 *   are the most candid text in the record.
 */
export const NEVER_SHAREABLE = ["screenerResults", "crisis", "appointmentQuestions"] as const;

export type ShareScope = Readonly<Record<ShareCategory, boolean>>;

/** Nothing shared. The starting point of every grant, and the fallback of every parse. */
export const EMPTY_SCOPE: ShareScope = Object.freeze(
  Object.fromEntries(SHARE_CATEGORIES.map((c) => [c, false])) as Record<ShareCategory, boolean>,
);

/**
 * The consent policy version recorded on a partner grant.
 *
 * Deliberately **not** `CONSENT_VERSION`. A disclosure to a third party under Art.
 * 9(2)(a) is a materially different thing from the Art. 6 consent that covers
 * analytics, and a future change to the partner wording must be able to invalidate
 * partner grants without touching anything else in the ledger (design §1).
 */
export const PARTNER_CONSENT_VERSION = "partner-2026-08-23";

/**
 * How long a grant lasts before it stops returning data.
 *
 * Consent that never expires stops being informed. Six months is short enough that
 * she reconsiders while the reasons are still current, and long enough that the
 * renewal is not itself a burden — and a renewal prompt is a natural, unsuspicious
 * moment to change her mind, which matters when the reason for changing it is the
 * person she would otherwise have to explain it to.
 */
export const SHARE_DURATION_DAYS = 183;

/** How long an unredeemed invite code stays usable. Short: it is a rendezvous, not access. */
export const INVITE_TTL_DAYS = 14;

/** Read a stored `scope_json` without trusting it. Unknown or missing keys are false. */
export function normalizeScope(raw: unknown): ShareScope {
  const source = raw && typeof raw === "object" ? (raw as Record<string, unknown>) : {};
  return Object.freeze(
    Object.fromEntries(SHARE_CATEGORIES.map((c) => [c, source[c] === true])) as Record<
      ShareCategory,
      boolean
    >,
  );
}

/**
 * The granted categories, in offer order — the list the partner's view is built
 * from. A withheld category is simply not in it, which is what makes his view
 * indistinguishable from one where Femio has no such feature (§3).
 */
export function sharedCategories(scope: ShareScope): ShareCategory[] {
  return SHARE_CATEGORIES.filter((c) => scope[c]);
}

/** A grant with no category is not a grant. The UI refuses to create one. */
export function hasAnyCategory(scope: ShareScope): boolean {
  return sharedCategories(scope).length > 0;
}

/** `days` after `fromISO`, as an ISO timestamp. Pure date maths, no clock read. */
export function addDays(fromISO: string, days: number): string {
  const at = new Date(fromISO);
  at.setUTCDate(at.getUTCDate() + days);
  return at.toISOString();
}

export type ShareRow = {
  scope_json?: unknown;
  revoked_at?: string | null;
  expires_at?: string | null;
  partner_profile_id?: string | null;
};

/**
 * Whether a row is returning data right now.
 *
 * Three conditions and all of them fail closed: it must have been redeemed by a
 * real account, never revoked, and not past its expiry. A row missing `expires_at`
 * is dead rather than eternal — the column arrived with migration 0011 and a row
 * without one is a row this code did not write.
 */
export function isLiveShare(row: ShareRow, nowISO: string): boolean {
  if (!row.partner_profile_id) return false;
  if (row.revoked_at) return false;
  if (!row.expires_at) return false;
  return row.expires_at > nowISO;
}

/** An invite that has been created and not yet taken up. Same fail-closed shape. */
export function isPendingInvite(
  row: ShareRow & { invite_code?: string | null },
  nowISO: string,
): boolean {
  if (row.partner_profile_id) return false;
  if (row.revoked_at) return false;
  if (!row.invite_code) return false;
  if (!row.expires_at) return false;
  return row.expires_at > nowISO;
}

/**
 * A human-transcribable invite code.
 *
 * She reads it out, or types it into a message; he types it into his own Femio.
 * That indirection is the whole reason the feature is account-based rather than
 * link-based — a forwarded link cannot be cut off, and revocation is meaningless
 * without that (design, "Account-based, not link-based").
 *
 * The alphabet drops `0/O` and `1/I/L` because the failure mode of a mis-read code
 * is her reading it out again, and the code is a rendezvous rather than a secret:
 * it is single-use, expires in a fortnight, and grants nothing until the account
 * that redeems it is named on the row.
 */
const CODE_ALPHABET = "ABCDEFGHJKMNPQRSTUVWXYZ23456789";
const CODE_LENGTH = 8;

export function formatInviteCode(code: string): string {
  return code.length === CODE_LENGTH ? `${code.slice(0, 4)}-${code.slice(4)}` : code;
}

/** Accepts what she types: spaces, dashes and lower case all normalise away. */
export function parseInviteCode(input: string): string | null {
  const cleaned = input.toUpperCase().replace(/[^A-Z0-9]/g, "");
  if (cleaned.length !== CODE_LENGTH) return null;
  if ([...cleaned].some((ch) => !CODE_ALPHABET.includes(ch))) return null;
  return cleaned;
}

/** Takes its randomness as an argument so the generator itself stays pure and testable. */
export function inviteCodeFrom(bytes: Uint8Array): string {
  if (bytes.length === 0) return "";
  let code = "";
  for (let i = 0; i < CODE_LENGTH; i++) {
    const byte = bytes[i % bytes.length] ?? 0;
    code += CODE_ALPHABET[byte % CODE_ALPHABET.length];
  }
  return code;
}
