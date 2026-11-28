import type { MetadataRoute } from "next";
import { routing } from "@/i18n/routing";
import { siteConfig } from "@/lib/seo/config";
import { listContent, listPeople, translatedSlugs, LIST_FIELDS } from "@/lib/cms/client";
import { isUnpublishedSection } from "@/lib/content/unpublished-sections";
import { PCOS_CHECKLIST_PATH } from "@/lib/checklists/pcos";

// Static routes + published CMS content (P1.11.1). Deliberate exclusions:
//  - /help-now (crisis-safety routing) is `noindex` and must never surface in search;
//  - /privacy + /terms are listed (R2.4): the v3 texts from the legal pack are final
//    drafts, indexable, and the stores link to them;
//  - /glossary + /faq are filtered below while their collections are empty (R3.7).
//    Submitting an empty page for indexing earns a thin-content impression against
//    the domain and sends anyone who lands on it straight back out.
//  - /search is absent by design: a results page is `noindex` (every URL a thin
//    duplicate of the library it points at) and the library pages are the ones
//    worth indexing.
const STATIC_PATHS = [
  "",
  "/learn",
  "/conditions",
  PCOS_CHECKLIST_PATH,
  "/faq",
  "/glossary",
  "/about",
  "/editorial-policy",
  "/medical-review",
  "/privacy",
  "/terms",
  "/consumer-health-data",
  "/authors",
  "/calculators",
  "/app",
  "/demo",
  "/calculators/period",
  "/calculators/pregnancy-test",
  "/calculators/due-date",
  "/calculators/fertile-window",
  "/calculators/gestational-age",
  "/calculators/pregnancy-calendar",
  "/calculators/pregnancy-weight-gain",
  "/calculators/contraction-timer",
  "/calculators/bmi",
  "/calculators/cycle-length",
];

export const revalidate = 3600;

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const entries: MetadataRoute.Sitemap = [];

  /**
   * `locales` defaults to every locale, which is right for UI pages — they are fully
   * translated. Authored content is not: an English-only article served at `/ar/...`
   * returns English via Payload's fallback, so listing all four locales advertised
   * three duplicate English pages per article and claimed hreflang alternates that do
   * not exist (P1.6.15). Content passes the locales it is actually written in.
   */
  const add = (path: string, lastModified: Date | undefined, locales: readonly string[] = routing.locales) => {
    if (locales.length === 0) return;
    const languages: Record<string, string> = {};
    for (const l of locales) languages[l] = `${siteConfig.baseUrl}/${l}${path}`;
    // x-default mirrors the on-page hreflang cluster (see localizedAlternates): the
    // default locale when it is in the set, else the first one that is.
    const fallback = locales.includes(routing.defaultLocale) ? routing.defaultLocale : locales[0];
    if (fallback) languages["x-default"] = `${siteConfig.baseUrl}/${fallback}${path}`;
    for (const locale of locales) {
      entries.push({
        url: `${siteConfig.baseUrl}/${locale}${path}`,
        ...(lastModified ? { lastModified } : {}),
        alternates: { languages },
      });
    }
  };

  // No `lastmod` for static pages: their copy changes with deploys, not on a date we
  // track, and stamping "now" on every hourly regeneration teaches Google to ignore
  // `lastmod` for the whole site. Content pages below carry their real `updatedAt`.
  for (const path of STATIC_PATHS.filter((p) => !isUnpublishedSection(p))) add(path, undefined);

  // Published content (slugs shared across locales). Graceful if the CMS is unset.
  for (const { collection, base } of [
    { collection: "articles", base: "/learn" },
    { collection: "conditions", base: "/conditions" },
  ]) {
    // `throwOnFailure` matters more here than anywhere else. A CMS blip used to make
    // this silently emit static pages only — a 200 sitemap with every article missing,
    // cached for an hour and handed to Google, which reads absence as "these pages are
    // gone". A 5xx on /sitemap.xml is simply retried. Loud beats quietly wrong.
    const docs = await listContent(collection, routing.defaultLocale, {
      throwOnFailure: true,
      fields: LIST_FIELDS,
    });
    // One lookup for the whole collection, not one per document — see translatedSlugs.
    const byLocale = await translatedSlugs(collection, { throwOnFailure: true });
    // A page marked `noindex` (a draft, or a hub that duplicates its article) must not be
    // submitted: Search Console reports "Submitted URL marked 'noindex'" for each one, and
    // an hreflang alternate that points at a noindex page is ignored. `seo.noIndex` is
    // per locale, so each locale's own document decides.
    const hidden = new Set<string>();
    for (const l of routing.locales) {
      for (const d of await listContent(collection, l, { fields: [...LIST_FIELDS, "seo"] })) {
        if (d.seo?.noIndex) hidden.add(`${l}/${d.slug}`);
      }
    }
    for (const d of docs) {
      const locales = routing.locales.filter((l) => byLocale[l]?.has(d.slug) && !hidden.has(`${l}/${d.slug}`));
      add(`${base}/${d.slug}`, d.updatedAt ? new Date(d.updatedAt) : undefined, locales);
    }
  }

  // Published author/reviewer bios (E-E-A-T surfaces, so they should be indexed).
  for (const p of await listPeople(routing.defaultLocale, { throwOnFailure: true })) {
    add(`/authors/${p.slug}`, p.updatedAt ? new Date(p.updatedAt) : undefined);
  }

  return entries;
}
