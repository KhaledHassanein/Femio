#!/usr/bin/env node
/**
 * Tier-1 / tier-2 portability guard (R2.4, ADR-060).
 *
 * `docs/24` §1 puts every medical decision in tier 1 — a Supabase Edge Function
 * running Deno — and the offline maths in tier 2, which will exist twice, once in
 * TypeScript and once in Dart. Both only work if these modules stay **portable**:
 * no framework, no data layer, no path aliases Deno cannot resolve.
 *
 * That property is invisible. Nothing breaks in the web app when someone adds
 * `import { createClient } from "@/lib/supabase/client"` to the resolver — it keeps
 * working perfectly, right up until the day it has to run somewhere else, and then
 * the cost is a rewrite rather than a fix. So it is checked here instead of
 * remembered.
 *
 * A file on this list may import: other listed files, and nothing else.
 */

import { readFileSync } from "node:fs";
import { join } from "node:path";

const ROOT = process.cwd();
const SRC = join(ROOT, "apps", "web", "src");

/**
 * The portable set. Every entry is either a decision (tier 1) or offline maths
 * that a Dart twin will have to reproduce (tier 2).
 */
const PORTABLE = [
  // tier 1 — decisions
  "lib/experience/types.ts",
  "lib/experience/build.ts",
  "lib/experience/layers.ts",
  "lib/experience/registry/index.ts",
  "lib/experience/registry/track-a.ts",
  "lib/experience/registry/track-d.ts",
  "lib/experience/registry/track-e.ts",
  "lib/persona/resolver.ts",
  "lib/persona/signals.ts",
  "lib/persona/signals-from-rows.ts",
  "lib/persona/age.ts",
  "lib/persona/modes.ts",
  "lib/persona/conditions.ts",
  "lib/persona/followup.ts",
  "lib/persona/transitions.ts",
  // tier 2 — offline maths, bound by the golden fixtures
  "lib/experience/phase.ts",
  "lib/cycle/predict.ts",
  "lib/pregnancy/index.ts",
  "lib/calculators/dates.ts",
];

const RULES = [
  {
    id: "path-alias",
    // Deno resolves relative specifiers, not tsconfig paths.
    test: (t) => /from\s+["']@\//.test(t),
    why: 'imports via the "@/" alias, which Deno and Dart cannot resolve — use a relative path',
  },
  {
    id: "extensionless-import",
    /**
     * Deno resolves relative specifiers literally: no extension inference, no
     * directory/index lookup. `import ... from "./types"` and `from "../pregnancy"`
     * both work perfectly in the web app and both fail at deploy time.
     *
     * Added after the first real `supabase functions deploy` failed on exactly
     * this — five `failed to read file` warnings and an `EISDIR` from the
     * directory import. The guard existed and did not cover it, which is the
     * whole reason this rule is written down rather than remembered.
     */
    test: (t) =>
      [...t.matchAll(/from\s+["'](\.[^"']*)["']/g)].some(([, spec]) => !spec.endsWith(".ts")),
    why: 'has a relative import without an explicit ".ts" — Deno cannot resolve it',
  },
  {
    id: "framework",
    test: (t) => /from\s+["'](react|react-dom|next|next\/[^"']*|next-intl[^"']*)["']/.test(t),
    why: "imports a framework — tier 1 must run with no renderer",
  },
  {
    id: "data-layer",
    test: (t) => /from\s+["'](@supabase\/[^"']+|@\/lib\/supabase\/[^"']+|\.{1,2}\/supabase\/[^"']+)["']/.test(t),
    why: "imports the data layer — tier 1 receives signals, it does not fetch them",
  },
  {
    id: "client-directive",
    test: (t) => /^\s*["']use (client|server)["']/m.test(t),
    why: 'carries a "use client"/"use server" directive, which is a Next concept',
  },
  {
    id: "ambient-clock",
    /**
     * `dates.ts` owns the single clock accessor — `todayISO()` — and that is the
     * point of it. Everywhere else, a bare `new Date()` makes the answer depend on
     * *when the code ran*, which breaks determinism and makes a golden fixture
     * impossible to write.
     */
    test: (t) => /new Date\(\s*\)/.test(t),
    skip: (rel) => rel === "lib/calculators/dates.ts",
    why: "reads an ambient clock — inject the date so the output stays deterministic",
  },
  {
    id: "hidden-clock",
    /**
     * Calling `todayISO()` inside a computation is the subtler version of the same
     * bug: the function still looks pure and its result still changes at midnight.
     * As a **default parameter** it is fine — the caller can always inject, and the
     * fixtures do.
     */
    test: (t) =>
      /todayISO\(\)/.test(t.replace(/=\s*todayISO\(\)/g, "").replace(/import[^;]+;/g, "")),
    skip: (rel) => rel === "lib/calculators/dates.ts",
    why: "calls todayISO() inside a computation — make it an injectable default parameter",
  },
];

const findings = [];
for (const rel of PORTABLE) {
  let text;
  try {
    text = readFileSync(join(SRC, rel), "utf8");
  } catch {
    findings.push({ rel, id: "missing", why: "listed as portable but the file does not exist" });
    continue;
  }
  for (const rule of RULES) {
    if (rule.skip?.(rel)) continue;
    if (rule.test(text)) findings.push({ rel, id: rule.id, why: rule.why });
  }
}

// A guard that checks nothing must fail, not pass (the P1.4.3 lesson).
if (PORTABLE.length === 0) {
  console.error("✗ tier-1 portability guard: the portable set is empty, which cannot be right.");
  process.exit(1);
}

if (findings.length === 0) {
  console.log(
    `✓ Tier-1 portability guard: ${PORTABLE.length} module(s) stay framework-free, data-free and alias-free.`,
  );
  process.exit(0);
}

for (const f of findings) console.error(`  [${f.id}] ${f.rel} — ${f.why}`);
console.error(
  "\n✗ Tier-1 portability guard failed. These modules must lift into a Deno Edge Function and be" +
    "\n  mirrored in Dart unchanged (docs/24 §1). Keep the dependency out, or move the file off the list.",
);
process.exit(1);
