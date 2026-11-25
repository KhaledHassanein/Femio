import { describe, expect, it } from "vitest";
import { siteConfig } from "./config";
import { fitDescription, fitTitle, localizedAlternates, pageMetadata, socialMetadata } from "./metadata";

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

describe("socialMetadata", () => {
  it("carries the per-locale share image and the card type with the page's own copy", () => {
    const m = socialMetadata("ar", "/learn/pcos-signs", "عنوان", "وصف");
    expect(m.openGraph).toMatchObject({
      type: "article",
      title: "عنوان",
      description: "وصف",
      url: expect.stringMatching(/\/ar\/learn\/pcos-signs$/),
      images: [expect.objectContaining({ url: "/og/ar.png", width: 1200, height: 630 })],
    });
    expect(m.twitter).toMatchObject({ card: "summary_large_image", title: "عنوان", images: ["/og/ar.png"] });
  });
});

describe("fitDescription", () => {
  it("returns short copy unchanged", () => {
    expect(fitDescription("A short line.")).toBe("A short line.");
  });

  it("cuts at the last whole sentence that fits", () => {
    const first = "Cited guides, calculators and records that never leave your phone, for every stage.";
    const text = `${first} ${"More words follow here and keep going. ".repeat(6)}`;
    const out = fitDescription(text);
    expect(out.length).toBeLessThanOrEqual(160);
    expect(out.endsWith(".")).toBe(true);
    expect(text.startsWith(out)).toBe(true);
  });

  it("falls back to a whole word and an ellipsis when no sentence is short enough", () => {
    const out = fitDescription("word ".repeat(80));
    expect(out.length).toBeLessThanOrEqual(160);
    expect(out.endsWith("…")).toBe(true);
  });
});

describe("fitTitle", () => {
  it("keeps the wordmark suffix when the whole title fits", () => {
    expect(fitTitle("About femio")).toBe("About femio");
  });

  it("drops the suffix for a title that would pass 60 characters with it", () => {
    const long = "Saignements après l’accouchement : normal ou alerte ?";
    expect(fitTitle(long)).toEqual({ absolute: long });
  });
});

describe("pageMetadata", () => {
  it("gives a page its own canonical, hreflang, Open Graph URL and title", () => {
    // The regression: pages that set only title/description inherited the home page's
    // og:url and og:title, so a shared /about link previewed as the home page.
    const m = pageMetadata({ locale: "ar", path: "/about", title: "About", description: "Who we are." });
    expect(m.alternates?.canonical).toBe("/ar/about");
    expect(m.alternates?.languages?.["x-default"]).toBe("/en/about");
    expect(m.openGraph).toMatchObject({ url: `${siteConfig.baseUrl}/ar/about`, title: "About", type: "website" });
    expect(m.twitter).toMatchObject({ card: "summary_large_image", title: "About" });
  });
});
