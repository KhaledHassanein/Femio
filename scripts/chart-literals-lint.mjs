#!/usr/bin/env node
/**
 * Femio chart-colour guard (RB-C3, `docs/29_REBUILD/05` §4).
 *
 * Every chart colour must come from a token. A chart that hard-codes `#7C3AED` is a
 * chart that ignores dark mode, cannot be re-themed, and will not match the log
 * category it is drawing — and none of that produces an error. It produces a chart
 * that looks fine to whoever wrote it, on the theme they happened to be using.
 *
 * This is the same failure shape as `--radius-round` shipping unmapped: nothing
 * breaks, the screen is simply wrong, and only a screenshot in the other theme
 * reveals it.
 *
 * ## What it checks
 *
 * No colour literal — hex, `rgb(`, `hsl(`, or a bare CSS colour name in a `fill` or
 * `stroke` — anywhere under `components/charts/` or `lib/charts/`. Colour arrives as
 * `var(--chart-*)`, `var(--log-*)` or `var(--confidence-*)`, or it does not arrive.
 *
 * `currentColor` and `none` are allowed: both inherit or disable rather than
 * asserting a colour, which is exactly the behaviour a token-driven chart wants.
 */
import { readdirSync, readFileSync, statSync } from "node:fs";
import { join } from "node:path";

const ROOTS = ["apps/web/src/components/charts", "apps/web/src/lib/charts"];

/** Hex, rgb()/rgba(), hsl()/hsla(), and named colours used as a paint value. */
const LITERAL = /#[0-9a-f]{3,8}\b|\brgba?\(|\bhsla?\(/gi;
const NAMED_PAINT =
  /\b(?:fill|stroke|color|background(?:Color)?)\s*[:=]\s*["'{]?\s*(red|blue|green|black|white|grey|gray|orange|purple|pink|teal|yellow|violet)\b/gi;

const ALLOWED_SUBSTRINGS = ["currentColor", "none", "transparent"];

function walk(dir) {
  let out = [];
  let entries;
  try {
    entries = readdirSync(dir);
  } catch {
    return out;
  }
  for (const e of entries) {
    const full = join(dir, e);
    if (statSync(full).isDirectory()) out = out.concat(walk(full));
    else if (/\.(ts|tsx)$/.test(e)) out.push(full);
  }
  return out;
}

const problems = [];

for (const root of ROOTS) {
  for (const file of walk(root)) {
    const src = readFileSync(file, "utf8");
    src.split(/\r?\n/).forEach((line, i) => {
      // A line documenting the rule is not breaking it.
      const isComment = /^\s*(\*|\/\/|\/\*)/.test(line);
      if (isComment) return;
      if (ALLOWED_SUBSTRINGS.some((a) => line.includes(a)) && !LITERAL.test(line)) return;

      LITERAL.lastIndex = 0;
      const hex = LITERAL.exec(line);
      if (hex) {
        problems.push({ file, line: i + 1, found: hex[0], text: line.trim() });
        return;
      }
      NAMED_PAINT.lastIndex = 0;
      const named = NAMED_PAINT.exec(line);
      if (named) problems.push({ file, line: i + 1, found: named[1], text: line.trim() });
    });
  }
}

if (problems.length > 0) {
  console.error(`✗ Chart-colour guard: ${problems.length} colour literal(s) in chart code.\n`);
  for (const p of problems) {
    console.error(`  ${p.file}:${p.line}  "${p.found}"`);
    console.error(`      ${p.text.slice(0, 100)}`);
  }
  console.error(
    "\n  Chart colour comes from a token: var(--chart-*), var(--log-*), var(--confidence-*).\n" +
      "  A hard-coded colour ignores dark mode and cannot match the category it draws,\n" +
      "  and nothing errors — the chart just looks wrong in the theme you did not check.\n",
  );
  process.exit(1);
}

const scanned = ROOTS.flatMap((r) => walk(r)).length;
console.log(`✓ Chart-colour guard: ${scanned} chart file(s) scanned, every colour comes from a token.`);
