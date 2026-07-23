import { defineRouting } from "next-intl/routing";

/**
 * Femio ships four first-class locales (docs/14 §7). Arabic is RTL-native.
 * Locale-prefixed routes (/en, /ar, /fr, /es) for SEO + hreflang.
 */
export const routing = defineRouting({
  locales: ["en", "ar", "fr", "es"],
  defaultLocale: "en",
  localePrefix: "always",
});

export type Locale = (typeof routing.locales)[number];

/** Type guard: is this string one of our supported locales? */
export function isLocale(value: string | undefined): value is Locale {
  return value != null && (routing.locales as readonly string[]).includes(value);
}

/** Right-to-left locales. Layout direction is derived from this, never hardcoded. */
export const rtlLocales: readonly Locale[] = ["ar"];

export function getDir(locale: Locale): "rtl" | "ltr" {
  return rtlLocales.includes(locale) ? "rtl" : "ltr";
}
