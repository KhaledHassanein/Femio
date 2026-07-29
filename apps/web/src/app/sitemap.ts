import type { MetadataRoute } from "next";
import { routing } from "@/i18n/routing";
import { siteConfig } from "@/lib/seo/config";
import { listContent } from "@/lib/cms/client";

// Static routes + published CMS content (P1.11.1). NOTE: /help-now (crisis-safety
// routing) is deliberately excluded here and marked `noindex` — it must not surface
// in search or a sitemap.
const STATIC_PATHS = [
  "",
  "/learn",
  "/conditions",
  "/faq",
  "/glossary",
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

  return entries;
}
