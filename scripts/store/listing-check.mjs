#!/usr/bin/env node
/**
 * Store-listing guard: the Play listing files in docs/store are what gets pasted into
 * the Console, so they are checked like code. Fails when a field is over Google's
 * limit (title 30, short description 80, full description 4,000), when a ship-gate
 * mark (†) is still in the text, when the wordmark is transliterated, or when the
 * full description lacks the non-device disclaimer Google requires of health apps.
 */
import { readFileSync } from "node:fs";

const LIMITS = { title: 30, short: 80, full: 4000 };
const FILES = {
  en: { path: "docs/store/play-listing.en.md", disclaimer: "not a medical device and does not diagnose, treat, cure or prevent" },
  ar: { path: "docs/store/play-listing.ar.md", disclaimer: "ليس جهازًا طبيًا" },
};

const findings = [];
for (const [locale, { path, disclaimer }] of Object.entries(FILES)) {
  const text = readFileSync(path, "utf8");
  const blocks = [...text.matchAll(/```\n([\s\S]*?)\n```/g)].map((m) => m[1]);
  if (blocks.length < 3) {
    findings.push(`${locale}: expected title, short and full description code blocks, found ${blocks.length}`);
    continue;
  }
  const [title, short, full] = blocks;
  const over = (name, value, limit) => {
    if ([...value].length > limit) findings.push(`${locale}: ${name} is ${[...value].length} characters, limit ${limit}`);
  };
  over("title", title, LIMITS.title);
  over("short description", short, LIMITS.short);
  over("full description", full, LIMITS.full);
  if (/†/.test(text)) findings.push(`${locale}: a ship-gate mark (†) is still in the file`);
  if (/فيميو/.test(text)) findings.push(`${locale}: the wordmark is transliterated; write "femio"`);
  if (!full.includes(disclaimer)) findings.push(`${locale}: the full description lacks the non-device disclaimer`);
  if (/\b(free|best|#1|clinically proven|doctor approved)\b/i.test(title + short)) findings.push(`${locale}: ranking or claim words in the title or short description`);
}

if (findings.length > 0) {
  console.error(`✗ Store-listing guard: ${findings.length} finding(s).`);
  for (const f of findings) console.error(`  ${f}`);
  process.exit(1);
}
console.log("✓ Store-listing guard: EN and AR listings within Play's limits, no gate marks, wordmark Latin, disclaimer present.");
