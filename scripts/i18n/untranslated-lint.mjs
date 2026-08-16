#!/usr/bin/env node
/**
 * Femio untranslated-copy guard (P1.29).
 *
 * Three whole namespaces — `pregnancy`, `menopause` and `pregnancySymptoms`, 122 keys —
 * shipped from P1.13b/c/d with the English text copied into ar/fr/es. Nothing failed:
 * key parity was perfect, every screen rendered, and the build was green. What an
 * Arabic reader actually got was English inside a `dir="rtl"` container, which bidi
 * reorders into nonsense — "weeks, 0 days 27", "2026/11/Due date: 06". It survived
 * months because a missing translation looks exactly like a present one to every check
 * that only compares key sets.
 *
 * So this guard compares VALUES. A string identical to English in another locale is
 * either a genuine cognate ("Constipation" in French) or an untranslated one, and the
 * difference cannot be computed — so the cognates are listed here by key and anything
 * new fails. An allowlist that must be edited deliberately is the point: adding a line
 * is a decision someone makes, copying a namespace is an accident.
 */
import { readFileSync } from "node:fs";
import { join } from "node:path";

const MESSAGES_DIR = "apps/web/messages";
const BASE = "en";
const LOCALES = ["ar", "fr", "es"];

/**
 * Keys whose value legitimately matches English in the given locale: brand names,
 * shared symbols, and words French/Spanish spell the same way. Reviewed 2026-08-07.
 */
const ALLOWED = {
  "*": ["meta.title", "home.eyebrow", "footer.rights", "calculators.ovulation.rangeValue"],
  ar: [],
  fr: [
    "home.chips.accent",
    "home.chips.fertile",
    "gallery.sections.badges",
    "symptoms.items.constipation",
    "symptoms.items.spotting",
    "symptoms.items.irritable",
    "symptoms.items.fatigue",
    "dashboard.modeLabel.cycle",
    // Same reason as dashboard.modeLabel.cycle: "Cycle" is the French word too.
    "home.shot.app.mode",
    "visitSummary.cycleHeading",
    "visitSummary.colDate",
    // "Note" is the French word, spelled identically.
    "medications.form.note",
    "learn.sources",
    "experience.modes.cycle.label",
    "insights.dimensions.persona.title",
    "pregnancySymptoms.items.constipation",
  ],
  es: [
    // Spelled identically in Spanish.
    "onboarding.triage.conditions.endometriosis",
    "gallery.phases.menstrual",
    "calculators.bmi.unitImperial",
    "symptoms.items.irritable",
    "dashboard.modeLabel.general",
    "insights.dimensions.persona.title",
  ],
};

function flatten(value, prefix = "", out = new Map()) {
  for (const [key, child] of Object.entries(value)) {
    const path = prefix ? `${prefix}.${key}` : key;
    if (typeof child === "string") out.set(path, child);
    else if (child && typeof child === "object") flatten(child, path, out);
  }
  return out;
}

/**
 * Values too short or symbol-only to judge: "OK", "{days}", "—". Comparing those
 * produces noise, not findings.
 */
function comparable(value) {
  return value.trim().length > 3 && /\p{L}{4,}/u.test(value);
}

const read = (locale) =>
  flatten(JSON.parse(readFileSync(join(MESSAGES_DIR, `${locale}.json`), "utf8")));

const base = read(BASE);
// A guard that finds nothing to scan must fail, not pass (same rule as claims-lint).
if (base.size === 0) {
  console.error(`untranslated-lint: no strings found in ${MESSAGES_DIR}/${BASE}.json.`);
  process.exit(1);
}

const findings = [];
let compared = 0;

for (const locale of LOCALES) {
  const allowed = new Set([...ALLOWED["*"], ...(ALLOWED[locale] ?? [])]);
  const target = read(locale);
  for (const [key, english] of base) {
    if (!comparable(english)) continue;
    compared += 1;
    if (target.get(key) === english && !allowed.has(key)) {
      findings.push({ locale, key, english });
    }
  }
}

if (findings.length > 0) {
  const byNamespace = new Map();
  for (const f of findings) {
    const ns = `${f.locale}:${f.key.split(".")[0]}`;
    byNamespace.set(ns, (byNamespace.get(ns) ?? 0) + 1);
  }
  console.error(
    `untranslated-lint: ${findings.length} string(s) are still the English text.\n` +
      "Translate them, or — if the word is genuinely identical in that language — add\n" +
      "the key to ALLOWED in this file with the locale it applies to.\n",
  );
  for (const [ns, count] of [...byNamespace].sort((a, b) => b[1] - a[1])) {
    console.error(`  ${ns}: ${count}`);
  }
  console.error("");
  for (const f of findings.slice(0, 25)) {
    console.error(`  ${f.locale}  ${f.key}  =  ${JSON.stringify(f.english.slice(0, 60))}`);
  }
  if (findings.length > 25) console.error(`  … and ${findings.length - 25} more`);
  process.exit(1);
}

console.log(
  `✓ Untranslated-copy guard: ${compared} comparisons across ${LOCALES.length} locale(s), ` +
    "no namespace left in English.",
);
