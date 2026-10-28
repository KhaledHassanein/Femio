#!/usr/bin/env node
/**
 * Wordmark guard (CLAUDE.md rule 6): the product is written "femio", in Latin letters,
 * everywhere a reader sees it, including inside Arabic prose. An Arabic transliteration
 * ("فيميو") reads as a different product and breaks the one mark the store listing,
 * the icon and the website share. This fails the gate when any user-facing text
 * carries the transliteration: the website catalogs, the app catalogs, the guides.
 *
 * Fix: write "femio". Where Arabic needs a prefix (و، ل، ب), attach it to a noun:
 * "وتطبيق femio", "لتطبيق femio".
 */
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

const TRANSLITERATION = /فيميو/g;
const files = [
  ...readdirSync("apps/web/messages").filter((f) => f.endsWith(".json")).map((f) => join("apps/web/messages", f)),
  ...readdirSync("apps/mobile/lib/l10n").filter((f) => f.endsWith(".arb")).map((f) => join("apps/mobile/lib/l10n", f)),
  ...readdirSync("docs/content/articles").filter((f) => f.endsWith(".md")).map((f) => join("docs/content/articles", f)),
  "apps/web/src/lib/crisis/crisis.json",
];

const findings = [];
for (const file of files) {
  const text = readFileSync(file, "utf8");
  const lines = text.split("\n");
  lines.forEach((line, i) => {
    if (TRANSLITERATION.test(line)) findings.push(`${file}:${i + 1}: ${line.trim().slice(0, 80)}`);
    TRANSLITERATION.lastIndex = 0;
  });
}

if (findings.length > 0) {
  console.error(`✗ Wordmark guard: ${findings.length} Arabic transliteration(s) of the wordmark; write "femio".`);
  for (const f of findings) console.error(`  ${f}`);
  process.exit(1);
}
console.log(`✓ Wordmark guard: ${files.length} files carry the Latin wordmark only.`);
