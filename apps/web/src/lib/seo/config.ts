import { routing } from "@/i18n/routing";
import { env } from "@/lib/env";

export const siteConfig = {
  name: "Femio",
  tagline: "One account for a woman's whole health life.",
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
