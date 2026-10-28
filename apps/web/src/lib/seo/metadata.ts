import type { Metadata } from "next";
import { routing } from "@/i18n/routing";
import { ogLocale, siteConfig } from "@/lib/seo/config";

/**
 * Self-referencing canonical for the current locale + a full hreflang cluster
 * (all locales + x-default). Path is locale-less, e.g. "/calculators". Returned
 * URLs are relative; the layout's metadataBase makes them absolute.
 */
export function localizedAlternates(
  locale: string,
  path = "/",
  /**
   * Restrict hreflang to the locales that genuinely exist. Defaults to all of them,
   * which is correct for UI pages — they are fully translated. Authored content is
   * not, and claiming an `ar` alternate that serves English is a duplicate-content
   * signal rather than a helpful one (P1.6.15).
   */
  available: readonly string[] = routing.locales,
): NonNullable<Metadata["alternates"]> {
  const clean = path === "/" ? "" : path.replace(/\/$/, "");
  const locales = available.length > 0 ? available : routing.locales;
  const languages: Record<string, string> = {};
  for (const l of locales) languages[l] = `/${l}${clean}`;
  // x-default points at the default locale when it exists, else the first available —
  // an x-default aimed at a page we do not have would be worse than omitting it.
  const fallback = locales.includes(routing.defaultLocale) ? routing.defaultLocale : locales[0];
  if (fallback) languages["x-default"] = `/${fallback}${clean}`;
  return { canonical: `/${locale}${clean}`, languages };
}

/**
 * The Open Graph and Twitter blocks for a page with its own title and description.
 * Next.js replaces the layout's `openGraph` and `twitter` objects rather than merging
 * them, so a page that sets only a title silently drops the share image and the
 * Twitter card falls back to the site title. Every page that sets social copy goes
 * through here so the per-locale image and the card type always come with it.
 */
export function socialMetadata(locale: string, path: string, title: string, description: string): Pick<Metadata, "openGraph" | "twitter"> {
  const image = `/og/${locale}.png`;
  const clean = path === "/" ? "" : path.replace(/\/$/, "");
  return {
    openGraph: {
      type: "article",
      siteName: siteConfig.name,
      title,
      description,
      url: `${siteConfig.baseUrl}/${locale}${clean}`,
      locale: ogLocale[locale] ?? locale,
      images: [{ url: image, width: 1200, height: 630, alt: title }],
    },
    twitter: { card: "summary_large_image", title, description, images: [image] },
  };
}
