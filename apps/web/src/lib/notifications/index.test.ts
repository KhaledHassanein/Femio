import { describe, expect, it } from "vitest";
import {
  DEFAULT_PREFS,
  NOTIFICATION_KINDS,
  anyKindEnabled,
  bodyKeyFor,
  isQuietHour,
  normalizePrefs,
  shouldSend,
  type NotificationPrefs,
} from "./index";

const on = (...kinds: string[]): NotificationPrefs =>
  normalizePrefs({ kinds: Object.fromEntries(kinds.map((k) => [k, true])) });

describe("defaults", () => {
  /**
   * The whole posture in one assertion. An app that opts her into being
   * interrupted about her cycle and waits to be corrected has already made the
   * disclosure it was supposed to be asking about.
   */
  it("sends nothing until she turns something on", () => {
    expect(anyKindEnabled(DEFAULT_PREFS)).toBe(false);
    for (const kind of NOTIFICATION_KINDS) {
      expect(DEFAULT_PREFS.kinds[kind]).toBe(false);
    }
  });

  it("defaults to discreet wording and a quiet night", () => {
    expect(DEFAULT_PREFS.discreet).toBe(true);
    expect(isQuietHour(2, DEFAULT_PREFS)).toBe(true);
    expect(isQuietHour(14, DEFAULT_PREFS)).toBe(false);
  });
});

describe("normalizePrefs", () => {
  it("treats anything it does not recognise as off", () => {
    for (const raw of [undefined, null, "periodWindow", 7, { kinds: "all" }]) {
      expect(anyKindEnabled(normalizePrefs(raw))).toBe(false);
    }
  });

  it("reads only exact true, and drops kinds it has no id for", () => {
    const prefs = normalizePrefs({ kinds: { periodWindow: true, logReminder: 1, gossip: true } });
    expect(prefs.kinds.periodWindow).toBe(true);
    expect(prefs.kinds.logReminder).toBe(false);
    expect(prefs.kinds).not.toHaveProperty("gossip");
  });

  /**
   * Discreet fails *safe*, not closed: the cost of getting it wrong is a health
   * word on a lock screen, so only an explicit `false` turns it off.
   */
  it("keeps discreet wording unless she explicitly turned it off", () => {
    expect(normalizePrefs({}).discreet).toBe(true);
    expect(normalizePrefs({ discreet: "no" }).discreet).toBe(true);
    expect(normalizePrefs({ discreet: null }).discreet).toBe(true);
    expect(normalizePrefs({ discreet: false }).discreet).toBe(false);
  });

  it("rejects impossible quiet hours rather than storing them", () => {
    const prefs = normalizePrefs({ quietFrom: 25, quietTo: -3 });
    expect(prefs.quietFrom).toBe(DEFAULT_PREFS.quietFrom);
    expect(prefs.quietTo).toBe(DEFAULT_PREFS.quietTo);
  });
});

describe("quiet hours", () => {
  it("wraps past midnight, which is what almost everyone sets", () => {
    const prefs = normalizePrefs({ quietFrom: 22, quietTo: 8 });
    expect(isQuietHour(23, prefs)).toBe(true);
    expect(isQuietHour(0, prefs)).toBe(true);
    expect(isQuietHour(7, prefs)).toBe(true);
    expect(isQuietHour(8, prefs)).toBe(false);
    expect(isQuietHour(21, prefs)).toBe(false);
  });

  it("handles a daytime window too", () => {
    const prefs = normalizePrefs({ quietFrom: 9, quietTo: 17 });
    expect(isQuietHour(12, prefs)).toBe(true);
    expect(isQuietHour(8, prefs)).toBe(false);
    expect(isQuietHour(17, prefs)).toBe(false);
  });

  /**
   * The other reading would let a mis-set pair silence everything forever with no
   * feedback, which is indistinguishable from the feature being broken.
   */
  it("treats an empty window as no quiet hours, not twenty-four of them", () => {
    const prefs = normalizePrefs({ quietFrom: 9, quietTo: 9 });
    for (let h = 0; h < 24; h += 1) expect(isQuietHour(h, prefs)).toBe(false);
  });
});

describe("shouldSend", () => {
  const prefs = on("periodWindow");

  it("sends an enabled kind outside quiet hours", () => {
    expect(shouldSend("periodWindow", prefs, { localHour: 10, subscribed: true })).toEqual({
      send: true,
    });
  });

  it("refuses a kind she did not turn on", () => {
    expect(shouldSend("logReminder", prefs, { localHour: 10, subscribed: true })).toEqual({
      send: false,
      reason: "kind_off",
    });
  });

  it("refuses inside quiet hours even for a kind she wants", () => {
    expect(shouldSend("periodWindow", prefs, { localHour: 3, subscribed: true })).toEqual({
      send: false,
      reason: "quiet_hours",
    });
  });

  it("refuses when there is no subscription at all, before anything else", () => {
    expect(shouldSend("periodWindow", prefs, { localHour: 10, subscribed: false })).toEqual({
      send: false,
      reason: "not_subscribed",
    });
  });
});

describe("wording", () => {
  /**
   * The subtle one. Five distinct discreet messages would be five distinguishable
   * notifications, and someone reading over her shoulder twice learns the mapping
   * — which defeats discreet mode more quietly than naming the period would.
   */
  it("uses one identical discreet body for every kind", () => {
    const prefs = normalizePrefs({ discreet: true });
    const keys = new Set(NOTIFICATION_KINDS.map((k) => bodyKeyFor(k, prefs)));
    expect(keys.size).toBe(1);
    expect([...keys][0]).toBe("discreet");
  });

  it("uses a per-kind body only when she opted out of discreet", () => {
    const prefs = normalizePrefs({ discreet: false });
    const keys = new Set(NOTIFICATION_KINDS.map((k) => bodyKeyFor(k, prefs)));
    expect(keys.size).toBe(NOTIFICATION_KINDS.length);
  });

  /** Keys, never text: copy lives in four catalogs, not in a tier-2 module. */
  it("returns keys rather than sentences", () => {
    for (const kind of NOTIFICATION_KINDS) {
      expect(bodyKeyFor(kind, DEFAULT_PREFS)).not.toMatch(/\s/);
    }
  });
});
