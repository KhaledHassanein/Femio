#!/usr/bin/env node
/**
 * Reading-level guard for the English wedge guides (R3.3).
 *
 * Why it exists: the content brief asks for grade 6-8 English (femio-medical-content
 * skill), and a guide that drifts to grade 12 passes every other check while losing
 * the reader it was written for. This computes Flesch-Kincaid grade level on the
 * English Markdown of the wedge set (the slugs the app's Learn tab leads with) and
 * fails the gate when a guide is above the ceiling.
 *
 * Validation: the formula and the syllable counter are checked against reference
 * passages with published scores in scripts/content/reading-level.test.mjs. The
 * syllable counter is a heuristic (English spelling is not phonetic), so a guide
 * near the ceiling should be read, not re-worded to game the number.
 *
 *   node scripts/content/reading-level.mjs            # guard: fail above the ceiling
 *   node scripts/content/reading-level.mjs --report   # every wedge guide with its grade
 *
 * Arabic has no validated grade formula of this kind; Arabic guides are not scored.
 */
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

const ARTICLES = "docs/content/articles";

/** The wedge: trying to conceive, pregnancy, PCOS. Mirrors apps/mobile/lib/data/library.dart. */
export const WEDGE_SLUGS = [
  "trying-to-conceive-guide",
  "fertile-window-explained",
  "irregular-cycles-and-timing",
  "when-to-take-pregnancy-test",
  "age-and-fertility",
  "preconception-appointment",
  "pcos-and-fertility",
  "when-to-seek-fertility-help",
  "pregnancy-basics",
  "early-pregnancy-changes",
  "first-pregnancy-appointment",
  "pregnancy-warning-signs",
  "ramadan-fasting-pregnancy",
  "pcos-signs",
  "how-pcos-is-assessed",
  "pcos-lifestyle-and-weight",
  "pcos-insulin-resistance",
  "pcos-treatment-options-to-discuss",
  "pcos-hair-skin-and-mood",
];

/**
 * Ceiling: Flesch-Kincaid grade 9.0. The brief says grade 6-8; medical nouns
 * ("ovulation", "progesterone", "polycystic") are long by nature and push a correct
 * sentence up a grade, so the gate allows one grade of slack and the --report shows
 * where each guide really sits.
 */
export const GRADE_CEILING = 9.0;

/** Count syllables in one English word (heuristic: vowel groups with common fixes). */
export function syllables(word) {
  const w = word.toLowerCase().replace(/[^a-z]/g, "");
  if (w.length === 0) return 0;
  if (w.length <= 3) return 1;
  let s = w
    .replace(/(?:[^laeiouy]es|ed|[^laeiouy]e)$/, "") // silent endings: -es, -ed, -e (but "table" keeps -le)
    .replace(/^y/, "");
  const groups = s.match(/[aeiouy]{1,2}/g);
  let n = groups ? groups.length : 1;
  return Math.max(1, n);
}

/** Strip Markdown and front matter down to prose sentences. */
export function proseOf(markdown) {
  let body = markdown.replace(/^---[\s\S]*?---\s*/, "");
  body = body
    .replace(/```[\s\S]*?```/g, " ")
    .replace(/^\s*#+\s.*$/gm, " ") // headings are not sentences
    .replace(/^\s*\|.*$/gm, " ") // tables
    .replace(/!\[[^\]]*\]\([^)]*\)/g, " ")
    .replace(/\[([^\]]+)\]\([^)]*\)/g, "$1")
    .replace(/[*_`>#]/g, " ")
    .replace(/^\s*[-•]\s+/gm, "")
    .replace(/\s+/g, " ")
    .trim();
  return body;
}

/** Flesch-Kincaid grade level of a prose string. Returns null when there is no prose. */
export function fleschKincaidGrade(prose) {
  // The wordmark is always lowercase "femio" (CLAUDE.md rule 6), also at the start of a
  // sentence, so it opens a sentence like a capital letter does.
  const sentences = prose.split(/(?<=[.!?])\s+(?=[A-Z"“(]|femio\b)/).filter((s) => /[a-zA-Z]/.test(s));
  const words = prose.match(/[A-Za-z][A-Za-z'’-]*/g) ?? [];
  if (sentences.length === 0 || words.length === 0) return null;
  const syl = words.reduce((sum, w) => sum + syllables(w), 0);
  const grade = 0.39 * (words.length / sentences.length) + 11.8 * (syl / words.length) - 15.59;
  return { grade: Math.round(grade * 10) / 10, words: words.length, sentences: sentences.length, syllablesPerWord: Math.round((syl / words.length) * 100) / 100 };
}

function main() {
  const report = process.argv.includes("--report");
  const files = new Set(readdirSync(ARTICLES));
  const rows = [];
  const findings = [];
  for (const slug of WEDGE_SLUGS) {
    const file = `${slug}.md`;
    if (!files.has(file)) {
      findings.push(`${slug}: no English guide at ${ARTICLES}/${file}`);
      continue;
    }
    const result = fleschKincaidGrade(proseOf(readFileSync(join(ARTICLES, file), "utf8")));
    if (!result) {
      findings.push(`${slug}: no prose found`);
      continue;
    }
    rows.push({ slug, ...result });
    if (result.grade > GRADE_CEILING) findings.push(`${slug}: grade ${result.grade} is above the ceiling ${GRADE_CEILING} (${result.words} words, ${result.sentences} sentences)`);
  }
  if (report) {
    for (const r of rows.sort((a, b) => b.grade - a.grade)) console.log(`${String(r.grade).padStart(5)}  ${r.slug}  (${r.words} words, ${r.sentences} sentences, ${r.syllablesPerWord} syl/word)`);
  }
  if (findings.length > 0) {
    console.error(`✗ Reading-level guard: ${findings.length} finding(s) in the wedge set.`);
    for (const f of findings) console.error(`  ${f}`);
    console.error("\nShorten the sentences or swap a long word for a plain one; read the guide, do not tune it to the number.");
    process.exit(1);
  }
  const max = Math.max(...rows.map((r) => r.grade));
  console.log(`✓ Reading-level guard: ${rows.length} wedge guides at or below grade ${GRADE_CEILING} (highest ${max}).`);
}

if (process.argv[1] && import.meta.url.endsWith(process.argv[1].replace(/\\/g, "/").split("/").pop())) main();
