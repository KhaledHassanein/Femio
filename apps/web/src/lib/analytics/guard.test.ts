import { describe, expect, it } from "vitest";
import { AREAS, EVENT_NAMES, EVENT_SCHEMA, FORBIDDEN_AREAS } from "./events";
import { findHealthTerm, guardEvent, tokenize } from "./guard";

describe("tokenize", () => {
  it("splits separators and camelCase", () => {
    expect(tokenize("symptom_type")).toEqual(["symptom", "type"]);
    expect(tokenize("symptomType")).toEqual(["symptom", "type"]);
    expect(tokenize("from-locale")).toEqual(["from", "locale"]);
  });
});

describe("findHealthTerm", () => {
  it("catches health fields however they are cased or separated", () => {
    expect(findHealthTerm("symptom_type")).toBe("symptom");
    expect(findHealthTerm("symptomType")).toBe("symptom");
    expect(findHealthTerm("symptoms")).toBe("symptom");
    expect(findHealthTerm("cycleDay")).toBe("cycle");
    expect(findHealthTerm("pregnancyWeek")).toBe("pregnan");
    expect(findHealthTerm("persona_id")).toBe("persona");
    expect(findHealthTerm("condition_tag")).toBe("condition");
    expect(findHealthTerm("age_band")).toBe("age");
  });

  it("catches short ambiguous terms as whole tokens", () => {
    expect(findHealthTerm("lab_result")).toBe("lab");
    expect(findHealthTerm("labValue")).toBe("lab");
    expect(findHealthTerm("labs")).toBe("labs");
  });

  it("does not fire on innocuous words that merely contain a stem", () => {
    // The exact false positives a naive substring match would produce.
    expect(findHealthTerm("language")).toBeUndefined();
    expect(findHealthTerm("page")).toBeUndefined();
    expect(findHealthTerm("message")).toBeUndefined();
    expect(findHealthTerm("storage")).toBeUndefined();
    expect(findHealthTerm("label")).toBeUndefined();
    expect(findHealthTerm("workflow")).toBeUndefined();
  });

  it("passes every key and value already in the catalog", () => {
    // Guards against a future schema addition that the denylist would reject at
    // runtime — the catalog and the denylist must stay mutually consistent.
    for (const [event, schema] of Object.entries(EVENT_SCHEMA)) {
      for (const [key, values] of Object.entries(schema)) {
        expect(findHealthTerm(key), `${event}.${key}`).toBeUndefined();
        for (const value of values) {
          expect(findHealthTerm(value), `${event}.${key}=${value}`).toBeUndefined();
        }
      }
    }
  });
});

describe("guardEvent", () => {
  it("accepts a well-formed catalog event", () => {
    const result = guardEvent("page_viewed", { area: "library", locale: "ar" });
    expect(result).toEqual({ ok: true, name: "page_viewed", props: { area: "library", locale: "ar" } });
  });

  it("rejects an event that is not in the catalog", () => {
    expect(guardEvent("symptom_logged", {}).ok).toBe(false);
    expect(guardEvent("", {}).ok).toBe(false);
  });

  it("rejects undeclared properties — the main leak path", () => {
    const result = guardEvent("page_viewed", {
      area: "library",
      locale: "en",
      slug: "endometriosis-symptoms",
    });
    expect(result.ok).toBe(false);
    expect(result.ok === false && result.reason).toContain("slug");
  });

  it("rejects missing properties", () => {
    expect(guardEvent("page_viewed", { area: "home" }).ok).toBe(false);
  });

  it("rejects values outside the allowlist", () => {
    expect(guardEvent("page_viewed", { area: "/learn/pcos", locale: "en" }).ok).toBe(false);
    expect(guardEvent("page_viewed", { area: "home", locale: "de" }).ok).toBe(false);
  });

  it("rejects non-string values, so a number cannot smuggle a date or lab value", () => {
    expect(guardEvent("page_viewed", { area: "home", locale: 3 }).ok).toBe(false);
    expect(guardEvent("page_viewed", { area: "home", locale: null }).ok).toBe(false);
    expect(guardEvent("page_viewed", { area: "home", locale: { toString: () => "en" } }).ok).toBe(false);
  });

  it("never measures the crisis surface", () => {
    // ADR-013: opening crisis help reveals mental-health intent. Even if someone
    // added it to AREAS, FORBIDDEN_AREAS must still refuse it.
    for (const forbidden of Object.keys(FORBIDDEN_AREAS)) {
      expect((AREAS as readonly string[]).includes(forbidden)).toBe(false);
      const result = guardEvent("page_viewed", { area: forbidden, locale: "en" });
      expect(result.ok).toBe(false);
    }
  });

  it("has no event carrying life-stage, condition or age — the dimensions P1.20 must not send", () => {
    const banned = ["mode", "track", "persona", "persona_id", "condition", "age", "age_band", "dob"];
    for (const event of EVENT_NAMES) {
      const keys = Object.keys(EVENT_SCHEMA[event]);
      for (const key of keys) {
        expect(banned, `${event}.${key}`).not.toContain(key);
      }
    }
  });
});
