#!/usr/bin/env node
/**
 * Femio claims-language guard (medical-device scope guardrail — docs/13 §7, docs/14 §10).
 * Fails CI if user-facing copy uses clinical claim verbs that would push Femio out of
 * "wellness/education/tracking" and into SaMD scope. v1 scans the English UI message
 * catalogs lexically (EN is master); extend to CMS content in P1.6.
 *
 * If a flagged word is genuinely fine in context, rephrase (preferred) or add a reviewed
 * exception here with a comment — never silence the whole check.
 */
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

const MESSAGES_DIR = "apps/web/messages";
const SCAN_LOCALES = ["en"]; // master locale; translations follow EN meaning.

// Whole-word, case-insensitive. These mirror doc 13 §7's forbidden intents.
const BANNED = [
  /\bdiagnos(e|es|ing|is|tic)\b/i,
  /\bcures?\b/i,
  /\bcuring\b/i,
  /\btreats?\b/i,
  /\btreating\b/i,
  /\btreatment\b/i,
  /\bprevents?\b/i,
  /\bpreventing\b/i,
  /\bcontracept(ion|ive|ives)?\b/i,
  /\bbirth control\b/i,
];

/** Collect [keyPath, value] for every string leaf. */
function walk(obj, prefix, out) {
  for (const [k, v] of Object.entries(obj)) {
    const path = prefix ? `${prefix}.${k}` : k;
    if (typeof v === "string") out.push([path, v]);
    else if (v && typeof v === "object") walk(v, path, out);
  }
}

const findings = [];
for (const locale of SCAN_LOCALES) {
  let raw;
  try {
    raw = readFileSync(join(MESSAGES_DIR, `${locale}.json`), "utf8");
  } catch {
    continue;
  }
  const leaves = [];
  walk(JSON.parse(raw), "", leaves);
  for (const [path, value] of leaves) {
    for (const pattern of BANNED) {
      const m = value.match(pattern);
      if (m) findings.push({ locale, path, term: m[0], value });
    }
  }
}

if (findings.length > 0) {
  console.error("✗ Claims-language guard: forbidden clinical claim(s) in user-facing copy.\n");
  for (const f of findings) {
    console.error(`  [${f.locale}] ${f.path}: "${f.term}"  →  ${JSON.stringify(f.value)}`);
  }
  console.error(
    "\nFemio is wellness/education/tracking only — never diagnose/treat/prevent/contracept.",
  );
  console.error("Rephrase (e.g. 'screening, discuss with your clinician'), then re-run.");
  process.exit(1);
}

console.log("✓ Claims-language guard: no forbidden clinical claims in UI copy.");
