import type { MetadataRoute } from "next";
import { routing } from "@/i18n/routing";
import { siteConfig } from "@/lib/seo/config";

// Static routes today; content pages (P1.9) will extend this from the CMS.
const PATHS = [
  "",
  "/calculators",
  "/calculators/due-date",
  "/calculators/fertile-window",
  "/calculators/gestational-age",
  "/calculators/bmi",
  "/calculators/cycle-length",
];

export default function sitemap(): MetadataRoute.Sitemap {
  const now = new Date();
  const entries: MetadataRoute.Sitemap = [];

  for (const path of PATHS) {
    const languages: Record<string, string> = {};
    for (const l of routing.locales) languages[l] = `${siteConfig.baseUrl}/${l}${path}`;

    for (const locale of routing.locales) {
      entries.push({
        url: `${siteConfig.baseUrl}/${locale}${path}`,
        lastModified: now,
        alternates: { languages },
      });
    }
  }

  return entries;
}
