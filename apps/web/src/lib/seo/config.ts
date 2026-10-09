import { routing } from "@/i18n/routing";
import { env } from "@/lib/env";

export const siteConfig = {
  name: "Femio",
  tagline: "One private record for a woman's whole health life.",
  baseUrl: env.NEXT_PUBLIC_APP_URL.replace(/\/$/, ""),
  locales: routing.locales,
  defaultLocale: routing.defaultLocale,
} as const;

// OpenGraph locale codes per app locale.
export const ogLocale: Record<string, string> = {
  en: "en_US",
  ar: "ar_AR",
  fr: "fr_FR",
  es: "es_ES",
};

/**
 * The share card every page uses (public audit 2026-10-09: no page had an og:image,
 * so links shared to WhatsApp or X showed a bare URL). A page that sets its own
 * `openGraph` replaces the layout's object wholesale, so it spreads this back in.
 */
export const OG_IMAGES = [
  { url: "/og-femio.png", width: 1200, height: 630, alt: "femio" },
] as const;
