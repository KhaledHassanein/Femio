import type { Locale } from "@/i18n/routing";

/**
 * Each UI language named in itself (its autonym), for the language switcher.
 *
 * These are not translated: a reader who cannot read the current language must still
 * find her own, so "العربية" stays Arabic on the French site and "Français" stays French
 * on the Arabic one. The switcher sets `lang` on each name so screen readers pronounce
 * it in that language. No flags, by design: a flag names a country, and Arabic, French
 * and Spanish each belong to many.
 */
export const LOCALE_NAMES: Record<Locale, string> = {
  en: "English",
  ar: "العربية",
  fr: "Français",
  es: "Español",
};
