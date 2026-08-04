import { describe, expect, it } from "vitest";
import { localizedAlternates } from "./metadata";

describe("localizedAlternates", () => {
  it("advertises every locale for a fully translated UI page", () => {
    const { canonical, languages } = localizedAlternates("en", "/calculators");
    expect(canonical).toBe("/en/calculators");
    expect(Object.keys(languages ?? {}).sort()).toEqual(["ar", "en", "es", "fr", "x-default"]);
    expect(languages?.["x-default"]).toBe("/en/calculators");
  });

  it("advertises only the locales an article is actually written in", () => {
    // The regression this exists for: Payload falls back to English, so /ar/learn/x
    // served English. Claiming an `ar` alternate made it three duplicate pages.
    const { languages } = localizedAlternates("en", "/learn/pcos", ["en"]);
    expect(Object.keys(languages ?? {}).sort()).toEqual(["en", "x-default"]);
    expect(languages?.ar).toBeUndefined();
  });

  it("keeps the alternates it does have when a translation exists", () => {
    const { languages } = localizedAlternates("ar", "/learn/pcos", ["en", "ar"]);
    expect(Object.keys(languages ?? {}).sort()).toEqual(["ar", "en", "x-default"]);
    expect(languages?.["x-default"]).toBe("/en/learn/pcos");
  });

  it("points x-default at an available locale when the default is missing", () => {
    // An x-default aimed at a page we do not have is worse than none.
    const { languages } = localizedAlternates("fr", "/learn/x", ["fr", "es"]);
    expect(languages?.["x-default"]).toBe("/fr/learn/x");
  });

  it("falls back to all locales rather than emitting an empty cluster", () => {
    const { languages } = localizedAlternates("en", "/learn/x", []);
    expect(Object.keys(languages ?? {}).length).toBeGreaterThan(1);
  });

  it("still self-references the requested locale even when untranslated", () => {
    // The page is noindex in that case, but the canonical must not point nowhere.
    const { canonical } = localizedAlternates("ar", "/learn/pcos", ["en"]);
    expect(canonical).toBe("/ar/learn/pcos");
  });
});
