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

  it("falls back to English per document, like Payload's fallback: true", async () => {
    const en = await getContentBySlug("articles", "en", "pcos-signs");
    const ar = await getContentBySlug("articles", "ar", "pcos-signs");
    expect(en?.body).toBeTruthy();
    expect(ar?.title).toBe(en?.title);
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
