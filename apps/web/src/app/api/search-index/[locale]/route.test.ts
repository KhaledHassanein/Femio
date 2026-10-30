import { describe, expect, it } from "vitest";

import type { LibraryIndex } from "@/lib/search/library";

import { GET, generateStaticParams } from "./route";

const get = async (locale: string) => {
  const res = await GET(new Request(`https://femioapp.com/api/search-index/${locale}`), {
    params: Promise.resolve({ locale }),
  });
  return (await res.json()) as LibraryIndex;
};

describe("the search index route", () => {
  it("is prerendered for every locale", () => {
    expect(generateStaticParams().map((p) => p.locale)).toEqual(["en", "ar", "fr", "es"]);
  });

  it("indexes the published library from the build, with no body text", async () => {
    const index = await get("en");
    expect(index.englishOnly).toBe(false);
    expect(index.docs.filter((d) => d.kind === "article").length).toBeGreaterThanOrEqual(100);
    expect(index.docs.some((d) => d.kind === "condition")).toBe(true);
    // Titles, summaries and headings only: a phone downloads this before its first result.
    expect(JSON.stringify(index).length).toBeLessThan(150_000);
  });

  it("says when a locale has no translations, so the screen can say so too", async () => {
    // All three translated locales carry the full library since 2026-10-30, so none is English-only.
    const en = await get("en");
    for (const loc of ["ar", "fr", "es"]) {
      const res = await get(loc);
      expect(res.englishOnly).toBe(false);
      expect(res.docs.length).toBe(en.docs.length);
    }
  });
});
