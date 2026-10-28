#!/usr/bin/env node
/**
 * Dead-module guard for the website (R0.8).
 *
 * Why it exists: the web tracker's removal (ADR-072) left 21 library modules that no
 * page, component, script or fixture runner imported, each with a green test file, so
 * they looked alive. A module nobody reaches is a rule nobody runs, and a reader of the
 * tree cannot tell it from a live one. This walks the import graph from the roots that
 * ship or run (app routes, components, i18n, middleware, scripts, the golden-fixture
 * runner, and the vocabulary generator in the root scripts folder) and fails when a
 * module under apps/web/src/lib is unreachable.
 *
 * Deleting is the fix. If a module is a deliberate twin of an app rule, bind it with a
 * fixture in fixtures/domain so the golden runner reaches it.
 */
import { existsSync, readFileSync, readdirSync, statSync } from "node:fs";
import { dirname, join, relative, resolve } from "node:path";

const WEB = "apps/web";
const SRC = `${WEB}/src`;
const norm = (p) => p.replace(/\\/g, "/");

const files = [];
const walk = (d) => {
  if (!existsSync(d)) return;
  for (const f of readdirSync(d)) {
    const p = join(d, f);
    if (statSync(p).isDirectory()) walk(p);
    else if (/\.(ts|tsx|mjs)$/.test(p)) files.push(norm(p));
  }
};
walk(SRC);
walk(`${WEB}/scripts`);
walk("scripts");

const isTest = (p) => /\.(test|spec)\.(ts|tsx)$/.test(p);
const resolveImport = (from, spec) => {
  const base = spec.startsWith("@/") ? `${SRC}/${spec.slice(2)}` : spec.startsWith(".") ? norm(resolve(dirname(from), spec)) : null;
  if (!base) return null;
  for (const c of [base, `${base}.ts`, `${base}.tsx`, `${base}.mjs`, `${base}/index.ts`, `${base}/index.tsx`]) {
    if (existsSync(c) && statSync(c).isFile()) return norm(relative(process.cwd(), c));
  }
  return null;
};

const edges = new Map();
for (const f of files) {
  const text = readFileSync(f, "utf8");
  const specs = [...text.matchAll(/from\s+["']([^"']+)["']|import\(\s*["']([^"']+)["']\s*\)|import\s+["']([^"']+)["']/g)].map((m) => m[1] ?? m[2] ?? m[3]);
  edges.set(f, specs.map((s) => resolveImport(f, s)).filter(Boolean));
}

const roots = files.filter(
  (f) => (/^apps\/web\/src\/(app|components|i18n|middleware)/.test(f) && !isTest(f)) || /^(apps\/web\/)?scripts\//.test(f) || f.endsWith("golden-fixtures.test.ts"),
);
const reached = new Set();
const stack = [...roots];
while (stack.length > 0) {
  const f = stack.pop();
  if (reached.has(f)) continue;
  reached.add(f);
  for (const e of edges.get(f) ?? []) stack.push(e);
}

const libModules = files.filter((f) => f.startsWith(`${SRC}/lib/`) && !isTest(f));
const dead = libModules.filter((f) => !reached.has(f)).sort();
if (dead.length > 0) {
  console.error(`✗ Dead-module guard: ${dead.length} module(s) under ${SRC}/lib are reached by no page, component, script or fixture runner.`);
  for (const f of dead) console.error(`  ${f}`);
  console.error("\nDelete the module (and its test), or bind it to the app with a fixture in fixtures/domain.");
  process.exit(1);
}
console.log(`✓ Dead-module guard: all ${libModules.length} web lib modules are reached from a page, component, script or fixture runner.`);
