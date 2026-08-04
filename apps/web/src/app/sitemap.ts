import type { MetadataRoute } from "next";
import { routing } from "@/i18n/routing";
import { siteConfig } from "@/lib/seo/config";
import { listContent, listPeople, translatedSlugs } from "@/lib/cms/client";

// Static routes + published CMS content (P1.11.1). Deliberate exclusions:
//  - /help-now (crisis-safety routing) is `noindex` and must never surface in search;
//  - /privacy + /terms are `noindex` while they are drafts (ADR-015) — add them here
//    with counsel's finalized text (P0.12.4).
const STATIC_PATHS = [
  "",
  "/learn",
  "/conditions",
  "/faq",
  "/glossary",
  "/about",
  "/editorial-policy",
  "/medical-review",
  "/authors",
  "/calculators",
  "/calculators/due-date",
  "/calculators/fertile-window",
  "/calculators/gestational-age",
  "/calculators/bmi",
  "/calculators/cycle-length",
];

export const revalidate = 3600;

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const now = new Date();
  const entries: MetadataRoute.Sitemap = [];

  /**
   * `locales` defaults to every locale, which is right for UI pages — they are fully
   * translated. Authored content is not: an English-only article served at `/ar/...`
   * returns English via Payload's fallback, so listing all four locales advertised
   * three duplicate English pages per article and claimed hreflang alternates that do
   * not exist (P1.6.15). Content passes the locales it is actually written in.
   */
  const add = (path: string, lastModified: Date, locales: readonly string[] = routing.locales) => {
    if (locales.length === 0) return;
    const languages: Record<string, string> = {};
    for (const l of locales) languages[l] = `${siteConfig.baseUrl}/${l}${path}`;
    for (const locale of locales) {
      entries.push({ url: `${siteConfig.baseUrl}/${locale}${path}`, lastModified, alternates: { languages } });
    }
  };

  for (const path of STATIC_PATHS) add(path, now);

  // Published content (slugs shared across locales). Graceful if the CMS is unset.
  for (const { collection, base } of [
    { collection: "articles", base: "/learn" },
    { collection: "conditions", base: "/conditions" },
  ]) {
    const docs = await listContent(collection, routing.defaultLocale);
    // One lookup for the whole collection, not one per document — see translatedSlugs.
    const byLocale = await translatedSlugs(collection);
    for (const d of docs) {
      const locales = routing.locales.filter((l) => byLocale[l]?.has(d.slug));
      add(`${base}/${d.slug}`, d.updatedAt ? new Date(d.updatedAt) : now, locales);
    }
  }

  // Published author/reviewer bios (E-E-A-T surfaces, so they should be indexed).
  for (const p of await listPeople(routing.defaultLocale)) {
    add(`/authors/${p.slug}`, p.updatedAt ? new Date(p.updatedAt) : now);
  }

  return entries;
}
