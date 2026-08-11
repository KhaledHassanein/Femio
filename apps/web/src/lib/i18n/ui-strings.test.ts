import { describe, expect, it } from "vitest";
import { flatten, overlay, unflatten } from "./ui-strings";
import { overlaysFromDatabase } from "./ui-strings-loader";

describe("flatten / unflatten", () => {
  it("round-trips nested messages through dotted keys", () => {
    const nested = { a: "1", b: { c: "2", d: { e: "3" } } };
    const flat = flatten(nested);
    expect(flat).toEqual({ a: "1", "b.c": "2", "b.d.e": "3" });
    expect(unflatten(flat)).toEqual(nested);
  });
});

describe("overlay", () => {
  it("applies DB values over the JSON base, ignoring empty values", () => {
    const base = { track: { calendar: { heading: "Calendar", legendToday: "Today" } } };
    const merged = overlay(base, { "track.calendar.heading": "Cal.", "track.calendar.legendToday": "" });
    expect(merged).toEqual({ track: { calendar: { heading: "Cal.", legendToday: "Today" } } });
  });

  it("adds keys the base does not have", () => {
    expect(overlay({ a: "1" }, { "b.c": "2" })).toEqual({ a: "1", b: { c: "2" } });
  });

  it("leaves the base untouched when there are no overrides", () => {
    const base = { a: "1", b: { c: "2" } };
    expect(overlay(base, {})).toEqual(base);
  });

  it("preserves array-valued messages through the round-trip (e.g. page points)", () => {
    const base = { about: { points: [{ heading: "H1", body: "B1" }, { heading: "H2", body: "B2" }] } };
    const merged = overlay(base as unknown as Parameters<typeof overlay>[0], {}) as unknown as {
      about: { points: { heading: string; body: string }[] };
    };
    expect(Array.isArray(merged.about.points)).toBe(true);
    expect(merged.about.points[1]!.heading).toBe("H2");
  });
});

describe("overlaysFromDatabase", () => {
  /**
   * ADR-064. This one line was a live defect: `home.heroTitle` had been seeded to
   * `ui_strings` as `human_reviewed`, so the new R1.3 homepage shipped with its new
   * markup and the old English text, and every English copy edit to a seeded key
   * since P1.19 had silently done nothing in production.
   */
  it("never overlays the source locale — English is the master and lives in the repo", () => {
    expect(overlaysFromDatabase("en", "en")).toBe(false);
  });

  it("still overlays every translated locale — the portal keeps working", () => {
    for (const locale of ["ar", "fr", "es"]) {
      expect(overlaysFromDatabase(locale, "en")).toBe(true);
    }
  });
});
