#!/usr/bin/env node
/**
 * Untranslated-copy guard for the app's catalogs (R4.11), the ARB twin of
 * scripts/i18n/untranslated-lint.mjs.
 *
 * `flutter gen-l10n` only checks that every key exists; a key whose Arabic value is
 * still the English sentence passes every build and reaches the phone as English
 * inside a right-to-left screen. So this compares VALUES against app_en.arb. A value
 * identical to English is either a genuine cognate ("Constipation" in French, "kg",
 * the wordmark) or an untranslated string, and only a person can tell: the cognates
 * are listed here by key, and anything new fails. Adding a line is a decision.
 */
import { readFileSync } from "node:fs";

const DIR = "apps/mobile/lib/l10n";
const LOCALES = ["ar", "fr", "es"];

/** Keys whose value legitimately equals English in that locale. Reviewed 2026-10-28. */
const ALLOWED = {
  "*": [
    "appTitle", // the wordmark is always the Latin "femio" (CLAUDE.md rule 6)
    "reminderTitle", // the notification title is only the wordmark
    "rangeValue", // two placeholders and a dash; nothing to translate
    "calendarDayLabel", // two placeholders and a comma
    // "Cloud boost" is a feature name kept in Latin script, like Gemini Nano (ADR-079).
    "askBoostHeading", "assistantCloudTitle", "boostTitle",
  ],
  ar: [],
  fr: [
    "logIrritable", "logConstipation", "logFatigue", "logSpotting", "legendSpotting", "weightUnitKg", "weightUnitLb", "settingsDates", "learnSources", "helpNowSource",
    "toolDueMethodConception", // R13: "Conception" is the French word too
    // Help now (R6.17): country names and service names spelt the same in French.
    "helpNowCountry_canada", "helpNowCountry_france", "helpNowCountry_oman", "helpNowCountry_qatar", "helpNowNumber_fr_3919", "helpNowNumber_ma_police",
    // Assistant (R7.3): the same word in French.
    "askSourcesTitle", "assistantSettingsTitle",
  ],
  es: ["logIrritable", "weightUnitKg", "weightUnitLb", "enterPin", "helpNowCountry_kuwait"],
};

const read = (locale) => JSON.parse(readFileSync(`${DIR}/app_${locale}.arb`, "utf8"));
const english = read("en");
const keys = Object.keys(english).filter((k) => !k.startsWith("@"));

const findings = [];
for (const locale of LOCALES) {
  const target = read(locale);
  const allowed = new Set([...ALLOWED["*"], ...(ALLOWED[locale] ?? [])]);
  for (const key of keys) {
    if (!(key in target)) findings.push(`${locale}: ${key} is missing`);
    else if (typeof target[key] === "string" && target[key].trim() === "") findings.push(`${locale}: ${key} is empty`);
    else if (target[key] === english[key] && !allowed.has(key)) findings.push(`${locale}: ${key} is still English: ${JSON.stringify(english[key])}`);
  }
  // A locale-specific cognate that stops equalling English is a stale allowlist line.
  for (const key of ALLOWED[locale] ?? []) {
    if (key in target && target[key] !== english[key]) findings.push(`${locale}: ${key} is allowlisted as a cognate but no longer equals English; remove it from ALLOWED`);
  }
}

if (findings.length > 0) {
  console.error(`✗ App untranslated-copy guard: ${findings.length} finding(s).`);
  for (const f of findings) console.error(`  ${f}`);
  console.error("\nTranslate the string, or, if it is a genuine cognate, add the key to ALLOWED in this file with the locale it applies to.");
  process.exit(1);
}
console.log(`✓ App untranslated-copy guard: ${keys.length} keys × ${LOCALES.length} locales, none missing, none left in English.`);
