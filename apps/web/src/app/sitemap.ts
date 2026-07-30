import type { MetadataRoute } from "next";
import { routing } from "@/i18n/routing";
import { siteConfig } from "@/lib/seo/config";
import { listContent, listPeople } from "@/lib/cms/client";

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

  const add = (path: string, lastModified: Date) => {
    const languages: Record<string, string> = {};
    for (const l of routing.locales) languages[l] = `${siteConfig.baseUrl}/${l}${path}`;
    for (const locale of routing.locales) {
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
    for (const d of docs) add(`${base}/${d.slug}`, d.updatedAt ? new Date(d.updatedAt) : now);
  }

  // Published author/reviewer bios (E-E-A-T surfaces, so they should be indexed).
  for (const p of await listPeople(routing.defaultLocale)) {
    add(`/authors/${p.slug}`, p.updatedAt ? new Date(p.updatedAt) : now);
  }

  return entries;
}
