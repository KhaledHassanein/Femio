/**
 * Binds the website's privacy wording to what the code does (R14.2, R14.14; PRIV-1,
 * PRIV-10, PRIV-11d).
 *
 * Why it exists: the 2026-11-26 privacy audit found a promise wider than the code. The
 * policies said femio removes names from a Cloud boost question, while
 * `apps/mobile/lib/domain/assistant/redaction.dart` strips only digits, e-mail addresses
 * and links. The tripwire checks code, not wording, so the sentence passed every gate.
 * These checks keep the four catalogues on the true wording and in the same shape, so a
 * locale cannot drift back to an old sentence or lose a disclosure the others carry.
 */
import { describe, expect, it } from "vitest";

import arMessages from "../../../messages/ar.json";
import enMessages from "../../../messages/en.json";
import esMessages from "../../../messages/es.json";
import frMessages from "../../../messages/fr.json";

const CATALOGS = { en: enMessages, ar: arMessages, fr: frMessages, es: esMessages } as const;
type Locale = keyof typeof CATALOGS;

/** Every privacy-relevant text the site shows, flattened to one string per locale. */
function privacyText(locale: Locale): string {
  const m = CATALOGS[locale];
  return JSON.stringify([m.privacy, m.healthData, m.appDemo.privacy]);
}

/**
 * The old claim in each language: "removes numbers, dates, names and contacts". Any of
 * these coming back means a catalogue again promises name removal the code does not do.
 */
const FALSE_REDACTION: Record<Locale, readonly string[]> = {
  en: ["dates, names and contacts", "names and contacts removed"],
  ar: ["والأسماء وبيانات الاتصال"],
  fr: ["les noms et les coordonnées", "dates, noms et coordonnées"],
  es: ["fechas, nombres y contactos", "fechas, nombres ni contactos"],
};

/** What the code really strips, as each catalogue names it. */
const TRUE_REDACTION: Record<Locale, readonly string[]> = {
  en: ["numbers, e-mail addresses and links"],
  ar: ["الأرقام وعناوين البريد الإلكتروني والروابط"],
  fr: ["les adresses e-mail et les liens"],
  es: ["direcciones de correo"],
};

describe("privacy wording matches the code", () => {
  for (const locale of Object.keys(CATALOGS) as Locale[]) {
    it(`${locale}: never claims that names are removed from a Cloud boost question`, () => {
      const text = privacyText(locale);
      for (const phrase of FALSE_REDACTION[locale]) expect(text).not.toContain(phrase);
      for (const phrase of TRUE_REDACTION[locale]) expect(text).toContain(phrase);
    });

    it(`${locale}: names the one cookie the site sets (next-intl's NEXT_LOCALE)`, () => {
      expect(JSON.stringify(CATALOGS[locale].privacy)).toContain("NEXT_LOCALE");
    });
  }
});

describe("the four policies have the same shape", () => {
  const shape = (value: unknown): unknown =>
    Array.isArray(value)
      ? value.map(shape)
      : value !== null && typeof value === "object"
        ? Object.fromEntries(Object.entries(value).map(([k, v]) => [k, shape(v)]))
        : typeof value;

  for (const ns of ["privacy", "healthData", "terms"] as const) {
    it(`${ns}: every locale has the same sections and items as English`, () => {
      const english = shape(enMessages[ns]);
      for (const locale of ["ar", "fr", "es"] as const) expect(shape(CATALOGS[locale][ns])).toEqual(english);
    });
  }

  it("what-can-leave cards: every locale has the same cards as English", () => {
    const keys = Object.keys(enMessages.appDemo.privacy.items);
    expect(keys).toContain("share");
    for (const locale of ["ar", "fr", "es"] as const) {
      expect(Object.keys(CATALOGS[locale].appDemo.privacy.items)).toEqual(keys);
    }
  });
});
