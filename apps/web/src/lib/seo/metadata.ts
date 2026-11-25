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
export function socialMetadata(
  locale: string,
  path: string,
  title: string,
  description: string,
  type: "article" | "website" = "article",
): Pick<Metadata, "openGraph" | "twitter"> {
  const image = `/og/${locale}.png`;
  const clean = path === "/" ? "" : path.replace(/\/$/, "");
  return {
    openGraph: {
      type,
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

/** Longest meta description Google shows in full; beyond this it truncates or rewrites. */
export const META_DESCRIPTION_MAX = 160;
/** Longest title that fits a results page before an ellipsis, wordmark suffix included. */
export const TITLE_MAX = 60;

/**
 * A search description of at most `max` characters taken from longer page copy.
 * It cuts at the last full sentence that fits (so the snippet reads as finished text),
 * and falls back to the last whole word plus an ellipsis when no sentence is short enough.
 * Text already short enough is returned unchanged.
 */
export function fitDescription(text: string, max = META_DESCRIPTION_MAX): string {
  const clean = text.replace(/\s+/g, " ").trim();
  if (clean.length <= max) return clean;
  const head = clean.slice(0, max);
  // Sentence enders in Latin and Arabic script ("." "!" "?" "؟").
  const ends = [...head.matchAll(/[.!?؟](?=\s|$)/g)];
  const lastEnd = ends.length > 0 ? (ends[ends.length - 1]!.index ?? -1) : -1;
  if (lastEnd >= 60) return head.slice(0, lastEnd + 1);
  const room = clean.slice(0, max - 1);
  const lastSpace = room.lastIndexOf(" ");
  return `${(lastSpace > 40 ? room.slice(0, lastSpace) : room).replace(/[\s,;:.،-]+$/, "")}…`;
}

/**
 * The page title for the root layout's `%s — femio` template. When the suffixed title
 * would pass `TITLE_MAX` the wordmark is dropped for that page (`absolute`), so the
 * words that describe the page are never the ones cut off in results.
 */
export function fitTitle(title: string): NonNullable<Metadata["title"]> {
  return `${title} — ${siteConfig.name}`.length > TITLE_MAX ? { absolute: title } : title;
}

/**
 * Full metadata for a page with its own title and description: fitted title and
 * description, self-referencing canonical + hreflang, and its own Open Graph and
 * Twitter blocks. Without the last one a page inherits the home page's `og:title`,
 * `og:url` and `og:description` from the layout, so a shared link to /about
 * previews as the home page (found in the 2026-11 SEO audit).
 */
export function pageMetadata(args: {
  locale: string;
  /** Locale-less path, e.g. "/about". */
  path: string;
  title: string;
  description: string;
  available?: readonly string[];
}): Metadata {
  const description = fitDescription(args.description);
  return {
    title: fitTitle(args.title),
    description,
    alternates: localizedAlternates(args.locale, args.path, args.available),
    ...socialMetadata(args.locale, args.path, args.title, description, "website"),
  };
}
