import { getDir, isLocale, routing } from "@/i18n/routing";
import crisis from "./crisis.json";

/**
 * Crisis-safety copy resolver. The approved wording lives in `crisis.json`
 * (mirroring docs/compliance/CRISIS_RESOURCES.md). English is the only
 * human-approved locale today; ar/fr/es are marked `pending` and must render the
 * English fallback, explicitly tagged `lang="en" dir="ltr"`, until a human
 * linguistic reviewer signs them off. This is a plain function usable from both
 * server components (the /help-now page) and client components (the dialog) so
 * the crisis interface has no runtime data dependency and works offline.
 */

export type CrisisStrings = NonNullable<(typeof crisis.locales)["en"]["strings"]>;

export type CrisisContent = {
  /** Approved, key-parity strings to render. */
  strings: CrisisStrings;
  /** Language the strings are actually written in (drives the `lang` attribute). */
  lang: string;
  /** Text direction for the rendered strings (drives the `dir` attribute). */
  dir: "ltr" | "rtl";
  /** True when the requested locale is not yet approved and we fell back to English. */
  isFallback: boolean;
  /** Display name of the external directory (from approved copy). */
  directoryName: string;
};

const EN = crisis.locales.en.strings as CrisisStrings;

export function getCrisisContent(locale: string): CrisisContent {
  if (isLocale(locale)) {
    const entry = crisis.locales[locale];
    if (entry.review.status === "approved" && entry.strings != null) {
      return {
        strings: entry.strings,
        lang: locale,
        dir: getDir(locale),
        isFallback: false,
        directoryName: crisis.directoryName,
      };
    }
  }

  // Pending / unknown locale → English fallback, explicitly LTR-tagged.
  return {
    strings: EN,
    lang: routing.defaultLocale,
    dir: "ltr",
    isFallback: true,
    directoryName: crisis.directoryName,
  };
}
