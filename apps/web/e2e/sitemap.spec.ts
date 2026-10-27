import { expect, test } from "@playwright/test";

/**
 * Sitemap integrity (P1.6.18).
 *
 * The sitemap shipped to Google with **zero articles** in it: a CMS blip during
 * generation made the content queries return empty, the route emitted static pages
 * only, and Next cached that 200 for an hour. Nothing failed — it was quietly wrong,
 * which is the worst shape for this particular file, because a page's absence from a
 * sitemap is read by a crawler as a signal about the page.
 *
 * Tagged `@cms`, not `@live`: these need a real CMS, which is a different dependency
 * from the live Supabase the product specs need. Lumping both under one tag is what
 * kept onboarding, tracking, symptoms, consent and the summary out of CI for the sake
 * of a sitemap (docs/26 §1.2) — the product specs now run there and these do not.
 * `NEXT_PUBLIC_CMS_URL` is deliberately unset in CI, where the sitemap correctly emits
 * static pages only. Run them locally with the
 * CMS configured. The production-facing counterpart — which is what would actually have
 * caught this — is `scripts/seo/sitemap-check.mjs`, run on a schedule against the live
 * site, because the failure was invisible from inside a build.
 */
test("@cms the sitemap includes published article and condition URLs", async ({ request }) => {
  const res = await request.get("/sitemap.xml");
  expect(res.status()).toBe(200);
  const xml = await res.text();

  const locs = [...xml.matchAll(/<loc>([^<]+)<\/loc>/g)].map((m) => m[1]!);
  expect(locs.length).toBeGreaterThan(0);

  const articles = locs.filter((u) => /\/learn\/[^/]+$/.test(u));
  const conditions = locs.filter((u) => /\/conditions\/[^/]+$/.test(u));

  expect(
    articles.length,
    "no article URLs in the sitemap — the content query returned empty and the route " +
      "emitted static pages only. Check the CMS is reachable.",
  ).toBeGreaterThan(0);
  expect(conditions.length, "no condition URLs in the sitemap").toBeGreaterThan(0);
});

test("@cms the sitemap does not advertise untranslated locales", async ({ request }) => {
  // Articles are English-only today. Listing /ar, /fr and /es for them would advertise
  // three duplicate English pages per article (P1.6.15).
  const xml = await (await request.get("/sitemap.xml")).text();
  const locs = [...xml.matchAll(/<loc>([^<]+)<\/loc>/g)].map((m) => m[1]!);

  const nonEnglishArticles = locs.filter((u) => /\/(ar|fr|es)\/(learn|conditions)\/[^/]+$/.test(u));
  expect(
    nonEnglishArticles,
    "articles are listed under a locale they are not written in — Payload's fallback " +
      "makes those URLs serve English, so indexing them is duplicate content",
  ).toEqual([]);
});

test("@cms the sitemap is well-formed and self-consistent", async ({ request }) => {
  const xml = await (await request.get("/sitemap.xml")).text();

  expect(xml.startsWith("<?xml")).toBe(true);
  expect(xml).toContain("http://www.sitemaps.org/schemas/sitemap/0.9");

  const locs = [...xml.matchAll(/<loc>([^<]+)<\/loc>/g)].map((m) => m[1]!);
  // A duplicate <loc> is a crawl-budget waste and usually a sign of a double-add bug.
  expect(new Set(locs).size, "duplicate <loc> entries in the sitemap").toBe(locs.length);
  // Every URL absolute and on the canonical host, or hreflang clusters point nowhere.
  for (const loc of locs) expect(loc).toMatch(/^https:\/\//);

  // The legal pages are listed since R2.4 (the stores link to them; they are indexable).
  expect(locs.some((u) => u.endsWith("/privacy"))).toBe(true);
  expect(locs.some((u) => u.endsWith("/terms"))).toBe(true);
  // The crisis page is noindex and must never be advertised.
  expect(locs.some((u) => u.includes("/help-now"))).toBe(false);
});
