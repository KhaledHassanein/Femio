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

  // Published articles (slugs are shared across locales). Graceful if CMS is unset.
  const articles = await listContent("articles", routing.defaultLocale);
  for (const a of articles) {
    add(`/learn/${a.slug}`, a.updatedAt ? new Date(a.updatedAt) : now);
  }

  return entries;
}
