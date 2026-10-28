import { afterEach, describe, expect, it, vi } from "vitest";
import { ALLOWED_EVENTS, buildEntry, isSafeValue, outboundHost, pageTypeFor, track } from "./events";

// The promise under test: the website never sends what she typed. The allow-list is
// closed on event names, on parameter names and on the shape of values.
describe("event allow-list", () => {
  it("lists exactly the events the measurement design names", () => {
    expect(Object.keys(ALLOWED_EVENTS).sort()).toEqual(
      [
        "article_read",
        "calculator_open",
        "calculator_used",
        "femio_page",
        "get_app_click",
        "help_now_open",
        "language_switch",
        "outbound_source_click",
      ].sort(),
    );
  });

  it("names no parameter that could hold a health value", () => {
    const forbidden = /date|day|cycle|period|length|symptom|result|note|text|query|birth|year|weight|dob|lmp|edd/i;
    for (const params of Object.values(ALLOWED_EVENTS)) for (const p of params) expect(p).not.toMatch(forbidden);
  });

  it("accepts an allowed event with allowed, slug-like parameters", () => {
    expect(buildEntry("calculator_open", { calculator_slug: "fertile-window" })).toEqual({
      ok: true,
      entry: { event: "calculator_open", calculator_slug: "fertile-window" },
    });
  });

  it("refuses unknown events and unknown parameters", () => {
    expect(buildEntry("purchase", {}).ok).toBe(false);
    expect(buildEntry("calculator_open", { start_date: "2026-01-02" }).ok).toBe(false);
    expect(buildEntry("get_app_click", { placement: "hero", page_type: "home", utm: "x" }).ok).toBe(false);
  });

  it("refuses values that look like dates, counts of days or prose", () => {
    expect(isSafeValue("2026-01-02")).toBe(false);
    expect(isSafeValue("02/01/2026")).toBe(false);
    expect(isSafeValue("my period started yesterday")).toBe(false);
    expect(isSafeValue("")).toBe(false);
    expect(isSafeValue("x".repeat(65))).toBe(false);
    expect(isSafeValue(28)).toBe(false);
    expect(isSafeValue("pcos-and-fertility")).toBe(true);
    expect(isSafeValue("acog.org")).toBe(true);
    expect(buildEntry("article_read", { article_slug: "late period 3 days" }).ok).toBe(false);
  });

  it("drops undefined parameters instead of refusing", () => {
    expect(buildEntry("help_now_open", { country: undefined })).toEqual({ ok: true, entry: { event: "help_now_open" } });
  });
});

describe("track()", () => {
  const originalWindow = globalThis.window;
  afterEach(() => {
    (globalThis as { window?: unknown }).window = originalWindow;
    vi.unstubAllEnvs();
  });

  it("is a no-op without a dataLayer (no container id rendered)", () => {
    // @ts-expect-error minimal window stand-in
    globalThis.window = {};
    expect(track("calculator_open", { calculator_slug: "period" })).toBe(false);
  });

  it("pushes exactly the validated entry when a dataLayer exists", () => {
    const dataLayer: unknown[] = [];
    // @ts-expect-error minimal window stand-in
    globalThis.window = { dataLayer };
    expect(track("get_app_click", { page_type: "calculator", placement: "handoff" })).toBe(true);
    expect(dataLayer).toEqual([{ event: "get_app_click", page_type: "calculator", placement: "handoff" }]);
  });

  it("throws in development on a forbidden parameter so the mistake is caught before release", () => {
    const dataLayer: unknown[] = [];
    // @ts-expect-error minimal window stand-in
    globalThis.window = { dataLayer };
    vi.stubEnv("NODE_ENV", "test");
    // @ts-expect-error deliberately wrong parameter
    expect(() => track("calculator_used", { start_date: "2026-01-02" })).toThrow(/not allowed/);
    expect(dataLayer).toEqual([]);
  });

  it("drops silently in production (never breaks a page over measurement)", () => {
    const dataLayer: unknown[] = [];
    // @ts-expect-error minimal window stand-in
    globalThis.window = { dataLayer };
    vi.stubEnv("NODE_ENV", "production");
    // @ts-expect-error deliberately wrong parameter
    expect(track("calculator_used", { start_date: "2026-01-02" })).toBe(false);
    expect(dataLayer).toEqual([]);
  });
});

describe("pageTypeFor()", () => {
  it("maps every locale-prefixed route family", () => {
    expect(pageTypeFor("/ar")).toBe("home");
    expect(pageTypeFor("/en/")).toBe("home");
    expect(pageTypeFor("/ar/learn")).toBe("learn");
    expect(pageTypeFor("/ar/learn/pcos-signs")).toBe("article");
    expect(pageTypeFor("/en/conditions/pcos")).toBe("hub");
    expect(pageTypeFor("/ar/calculators/fertile-window")).toBe("calculator");
    expect(pageTypeFor("/ar/help-now")).toBe("help");
    expect(pageTypeFor("/en/privacy")).toBe("legal");
    expect(pageTypeFor("/en/app")).toBe("app");
    expect(pageTypeFor("/fr/search")).toBe("search");
    expect(pageTypeFor("/es/glossary")).toBe("other");
  });
});

describe("outboundHost()", () => {
  it("returns the bare host for external https links and null otherwise", () => {
    expect(outboundHost("https://www.acog.org/womens-health/faqs", "femioapp.com")).toBe("acog.org");
    expect(outboundHost("https://femioapp.com/ar/learn", "femioapp.com")).toBeNull();
    expect(outboundHost("/ar/learn", "femioapp.com")).toBeNull();
    expect(outboundHost("mailto:x@y.z", "femioapp.com")).toBeNull();
  });
});
