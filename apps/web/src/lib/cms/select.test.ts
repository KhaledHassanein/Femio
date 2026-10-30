import { describe, expect, it } from "vitest";
import {
  LIST_FIELDS,
  allSlugs,
  availableLocales,
  getContentBySlug,
  listContent,
  listPeople,
  translatedSlugs,
} from "./client";

// The content client reads the committed snapshot (D3 step 1), so these run against
// the real published library, offline.
describe("content snapshot client", () => {
  it("serves the published library with no network", async () => {
    const list = await listContent("articles", "en");
    expect(list.length).toBeGreaterThan(50);
    expect(allSlugs("articles")).toContain("fertile-window-explained");
  });

  // A list must never carry article bodies: that was 2.1 MB per request when this
  // came from the CMS, and it still decides how heavy the hub's payload is.
  it("never puts a body in a list", async () => {
    expect(LIST_FIELDS).not.toContain("body");
    const list = await listContent("articles", "en", { fields: LIST_FIELDS });
    expect(list.every((d) => d.body === undefined && d.slug && d.title)).toBe(true);
  });

  it("serves each locale its own translation, and falls back to English for a locale with none", async () => {
    // Since 2026-10-30 every guide exists in en, ar, fr and es; a locale outside that set still
    // falls back per document, which is the path this test keeps honest.
    const en = await getContentBySlug("articles", "en", "afterpains-after-birth");
    expect(en?.body).toBeTruthy();
    for (const loc of ["ar", "fr", "es"]) {
      const tr = await getContentBySlug("articles", loc, "afterpains-after-birth");
      expect(tr?.title).not.toBe(en?.title);
    }
    const other = await getContentBySlug("articles", "de", "afterpains-after-birth");
    expect(other?.title).toBe(en?.title);
  });

  it("counts only real translations, so fallbacks are never advertised as Arabic", async () => {
    const byLocale = await translatedSlugs("articles");
    expect(byLocale.en?.has("pcos-signs")).toBe(true);
    expect(await availableLocales("articles", "pcos-signs")).toContain("en");
  });

  it("returns null and empty for things that do not exist", async () => {
    expect(await getContentBySlug("articles", "en", "no-such-guide")).toBeNull();
    expect(await listContent("no-such-collection", "en")).toEqual([]);
    expect((await listPeople("en")).length).toBeGreaterThan(0);
  });
});
