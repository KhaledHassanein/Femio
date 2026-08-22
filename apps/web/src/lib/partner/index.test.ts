import { describe, expect, it } from "vitest";
import {
  EMPTY_SCOPE,
  NEVER_SHAREABLE,
  SHARE_CATEGORIES,
  addDays,
  formatInviteCode,
  hasAnyCategory,
  inviteCodeFrom,
  isLiveShare,
  isPendingInvite,
  normalizeScope,
  parseInviteCode,
  sharedCategories,
} from "./index";

const NOW = "2026-08-23T12:00:00.000Z";
const live = {
  partner_profile_id: "partner-1",
  revoked_at: null,
  expires_at: "2027-01-01T00:00:00.000Z",
};

describe("what may be shared", () => {
  /**
   * The design point that matters most (§4). These three are not "off by
   * default" — they have no id, so no screen can offer them, no `scope_json`
   * can carry them and no pressure can produce them. If someone ever adds one
   * to `SHARE_CATEGORIES`, this is the test that stops the commit.
   */
  it("never lets the never-shareable class become a category", () => {
    for (const forbidden of NEVER_SHAREABLE) {
      expect(SHARE_CATEGORIES as readonly string[]).not.toContain(forbidden);
    }
    expect(NEVER_SHAREABLE).toContain("screenerResults");
    expect(NEVER_SHAREABLE).toContain("crisis");
    expect(NEVER_SHAREABLE).toContain("appointmentQuestions");
  });

  it("starts with nothing shared", () => {
    expect(Object.values(EMPTY_SCOPE).every((v) => v === false)).toBe(true);
    expect(hasAnyCategory(EMPTY_SCOPE)).toBe(false);
  });

  /**
   * A scope Femio cannot read shares nothing, rather than sharing everything or
   * throwing. `undefined`, a string, a null and an object of junk all reduce to
   * the same closed answer.
   */
  it("fails closed on anything it does not recognise", () => {
    for (const raw of [undefined, null, "cycleDates", 42, { cycleDates: "yes" }, {}]) {
      expect(hasAnyCategory(normalizeScope(raw))).toBe(false);
    }
  });

  it("reads only exact `true`, and drops keys it has no id for", () => {
    const scope = normalizeScope({ nextPeriod: true, symptoms: 1, screenerResults: true });
    expect(scope.nextPeriod).toBe(true);
    expect(scope.symptoms).toBe(false);
    expect(scope).not.toHaveProperty("screenerResults");
  });

  /**
   * §3: the partner's view is built from this list, so a withheld category has
   * to be *absent* rather than present-and-false. A list that carried
   * `{ symptoms: false }` would let his screen render "Symptoms: hidden", which
   * is the map of what she concealed that the whole design exists to prevent.
   */
  it("returns granted categories only — never a withheld one marked false", () => {
    const scope = normalizeScope({ nextPeriod: true, phase: true });
    expect(sharedCategories(scope)).toEqual(["nextPeriod", "phase"]);
    expect(sharedCategories(scope)).not.toContain("symptoms");
  });
});

describe("whether a share is returning data", () => {
  it("is live only when redeemed, unrevoked and unexpired", () => {
    expect(isLiveShare(live, NOW)).toBe(true);
  });

  /** Revocation is silent, so "he sees nothing" is the only signal there is. */
  it("stops the moment she revokes", () => {
    expect(isLiveShare({ ...live, revoked_at: "2026-08-23T11:00:00.000Z" }, NOW)).toBe(false);
  });

  it("stops at expiry without anyone doing anything", () => {
    expect(isLiveShare({ ...live, expires_at: "2026-08-23T11:59:59.000Z" }, NOW)).toBe(false);
  });

  /**
   * A row with no expiry is a row this code did not write — a v1 `partner_links`
   * row, or one inserted before migration 0011. Dead, not eternal.
   */
  it("treats a missing expiry as dead rather than unlimited", () => {
    expect(isLiveShare({ ...live, expires_at: null }, NOW)).toBe(false);
  });

  it("is not live while the invite is still only an invite", () => {
    expect(isLiveShare({ ...live, partner_profile_id: null }, NOW)).toBe(false);
  });

  it("counts an unredeemed, unexpired code as a pending invite and nothing more", () => {
    const invite = { partner_profile_id: null, revoked_at: null, expires_at: "2026-09-01T00:00:00.000Z", invite_code: "ABCD2345" };
    expect(isPendingInvite(invite, NOW)).toBe(true);
    expect(isLiveShare(invite, NOW)).toBe(false);
    expect(isPendingInvite({ ...invite, invite_code: null }, NOW)).toBe(false);
    expect(isPendingInvite({ ...invite, partner_profile_id: "p" }, NOW)).toBe(false);
  });
});

describe("the invite code", () => {
  it("round-trips through what she is likely to type", () => {
    const code = inviteCodeFrom(new Uint8Array([1, 2, 3, 4, 5, 6, 7, 8]));
    expect(code).toHaveLength(8);
    expect(parseInviteCode(formatInviteCode(code))).toBe(code);
    expect(parseInviteCode(code.toLowerCase())).toBe(code);
    expect(parseInviteCode(` ${code.slice(0, 4)} ${code.slice(4)} `)).toBe(code);
  });

  /** Ambiguous glyphs are never generated, so they are never accepted either. */
  it("refuses codes that are the wrong length or use excluded characters", () => {
    expect(parseInviteCode("ABC")).toBeNull();
    expect(parseInviteCode("ABCD23456")).toBeNull();
    expect(parseInviteCode("ABCD0111")).toBeNull();
  });

  it("only ever emits characters from its own alphabet", () => {
    const bytes = new Uint8Array(Array.from({ length: 64 }, (_, i) => i * 7));
    expect(inviteCodeFrom(bytes)).toMatch(/^[ABCDEFGHJKMNPQRSTUVWXYZ23456789]{8}$/);
  });
});

describe("expiry maths", () => {
  it("adds whole days in UTC", () => {
    expect(addDays("2026-08-23T12:00:00.000Z", 183)).toBe("2027-02-22T12:00:00.000Z");
    expect(addDays("2026-08-23T12:00:00.000Z", 14)).toBe("2026-09-06T12:00:00.000Z");
  });
});
