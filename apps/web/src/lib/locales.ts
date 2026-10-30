import type { Locale } from "@/i18n/routing";

/**
 * Each UI language named in itself (its autonym), with the flag shown beside it in the
 * language switcher.
 *
 * The names are not translated: a reader who cannot read the current language must still
 * find her own, so "العربية" stays Arabic on the French site and "Français" stays French
 * on the Arabic one. The switcher sets `lang` on each name so screen readers pronounce
 * it in that language.
 *
 * The flags are the owner's call (dashboard note, 2026-10-29: "language names with flags
 * for each language to be identifiable"). A flag is a recognition aid next to the name,
 * never the name itself: Arabic, French and Spanish each belong to many countries, so
 * the flag is decorative (`alt=""`) and the name carries the meaning. Files and licence:
 * apps/web/public/flags/README.md.
 */
export const LOCALE_NAMES: Record<Locale, string> = {
  en: "English",
  ar: "العربية",
  fr: "Français",
  es: "Español",
};

/** Flag file under /flags for each language (see the README there for why these four). */
export const LOCALE_FLAGS: Record<Locale, string> = {
  en: "gb",
  ar: "sa",
  fr: "fr",
  es: "es",
};
