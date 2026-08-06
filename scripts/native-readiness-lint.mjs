#!/usr/bin/env node
/**
 * Femio native-readiness guard (P4.0, docs/21_MOBILE_BUILD_TARGET_2026-08-06.md).
 *
 * The rule it defends: **the tracker must stay buildable without a server.**
 * The P4.0 Step 1 spike proved `output: "export"` works for the app half — but it
 * also proved the failure is quiet. Middleware does not error under export; it is
 * silently disabled, taking locale routing and Supabase session refresh with it.
 * So "the native build still works" is exactly the kind of property that rots
 * without anyone noticing, and Phase 2 is about to add most of the app.
 *
 * Written as a **ratchet** over a baseline of known violations, because when it was
 * added the tracker broke all four rules. P4.0.3 cleared them all, so the baseline is
 * now empty and it behaves as a plain gate — any violation fails. The ratchet
 * machinery stays: it costs nothing while the list is empty, and it is what lets a
 * future exception be recorded deliberately rather than by deleting a rule.
 * The guard fails on:
 *   - a NEW violation (drift — Phase 2 code that would have to be rewritten), and
 *   - a STALE baseline entry (a file that no longer violates but is still listed),
 *     so the list can only shrink and can never quietly over-claim.
 *
 * Checks, all scoped to routes that must ship in a device bundle:
 *   1. No `@/lib/supabase/server` — there is no server to read from.
 *   2. No `export const dynamic = "force-dynamic"` — export rejects it outright.
 *   3. No Server Actions (`"use server"`) — unsupported by static export.
 *   4. No `searchParams` page props — a dynamic API; use `useSearchParams`.
 *
 * `generateMetadata` + `next-intl/server` are deliberately NOT flagged: metadata
 * resolves at build time and exports fine. A guard that cries wolf gets deleted.
 *
 * To clear an entry: fix the file, then remove its line from the baseline. Never
 * add to the baseline to make the build pass — that is the drift this prevents.
 */
import { readFileSync, readdirSync, statSync, existsSync } from "node:fs";
import { join } from "node:path";

const BASELINE_FILE = "scripts/native-readiness-baseline.json";

/** Routes that must exist in a device bundle. Staff/admin tooling is excluded by
 *  build target — it is not shipped to phones — as is the public content site. */
const SCOPE = [
  "apps/web/src/app/[locale]/(app)",
  "apps/web/src/app/[locale]/sign-in",
  "apps/web/src/app/[locale]/welcome",
  "apps/web/src/app/[locale]/reset-password",
  "apps/web/src/app/[locale]/help-now",
];
const EXCLUDE = ["apps/web/src/app/[locale]/(app)/admin"];

const RULES = [
  {
    id: "server-supabase",
    test: (t) => /from\s+["']@\/lib\/supabase\/server["']/.test(t),
    why: "reads Supabase server-side; a device bundle has no server",
  },
  {
    id: "force-dynamic",
    test: (t) => /export\s+const\s+dynamic\s*=\s*["']force-dynamic["']/.test(t),
    why: '`force-dynamic` cannot be statically exported',
  },
  {
    id: "server-action",
    test: (t) => /^\s*["']use server["']/m.test(t),
    why: "Server Actions are unsupported by static export",
  },
  {
    id: "search-params",
    test: (t) => /searchParams\s*:/.test(t) || /await\s+searchParams/.test(t),
    why: "`searchParams` is a dynamic API; use `useSearchParams` + Suspense",
  },
];

const norm = (p) => p.replaceAll("\\", "/");

function walk(dir, out = []) {
  if (!existsSync(dir)) return out;
  for (const entry of readdirSync(dir)) {
    const p = join(dir, entry);
    if (statSync(p).isDirectory()) walk(p, out);
    else if (/\.tsx?$/.test(p) && !/\.test\.tsx?$/.test(p)) out.push(norm(p));
  }
  return out;
}

const files = SCOPE.flatMap((d) => walk(d)).filter(
  (f) => !EXCLUDE.some((x) => f.startsWith(norm(x))),
);

if (files.length === 0) {
  console.error("native-readiness: scanned 0 files — the scope paths are wrong.");
  process.exit(1);
}

const found = new Set();
for (const file of files) {
  const text = readFileSync(file, "utf8");
  for (const rule of RULES) if (rule.test(text)) found.add(`${file}::${rule.id}`);
}

let baseline;
try {
  baseline = new Set(JSON.parse(readFileSync(BASELINE_FILE, "utf8")).violations);
} catch {
  console.error(`native-readiness: cannot read ${BASELINE_FILE}.`);
  process.exit(1);
}

const added = [...found].filter((v) => !baseline.has(v)).sort();
const stale = [...baseline].filter((v) => !found.has(v)).sort();
const why = (id) => RULES.find((r) => r.id === id).why;

if (added.length > 0) {
  console.error("\nnative-readiness FAILED — new server-only code in the tracker path:\n");
  for (const v of added) {
    const [file, rule] = v.split("::");
    console.error(`  ${file}\n    ${rule}: ${why(rule)}`);
  }
  console.error(
    "\nThis code cannot ship to iOS/Android (P4.0). Fix it, or if it genuinely",
    "\nbelongs only on the web, move it out of the tracker path.\n",
  );
}

if (stale.length > 0) {
  console.error("\nnative-readiness FAILED — baseline is stale; these no longer violate:\n");
  for (const v of stale) console.error(`  ${v}`);
  console.error(`\nRemove them from ${BASELINE_FILE} — the list must only shrink.\n`);
}

if (added.length > 0 || stale.length > 0) process.exit(1);

console.log(
  found.size === 0
    ? `native-readiness OK — ${files.length} files scanned, the tracker path is server-free.`
    : `native-readiness OK — ${files.length} files scanned, ` +
      `${found.size} baselined violation(s), no drift.`,
);
