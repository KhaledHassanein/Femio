#!/usr/bin/env node
/**
 * Persona-branch guard (R2.7-in-spirit, ADR-061).
 *
 * The revamp's whole claim is that **personas reach the screen as data, not as
 * branches**. `docs/23` §3.1 found the opposite: 73 personas collapsed into four
 * hardcoded modes, and adding persona #6 meant editing a React component.
 *
 * So this fails the build when a component compares against a persona id or a
 * life-stage mode literal. If a screen needs to look different for D3 than for D7,
 * the difference belongs in `lib/experience/registry/*` — where it is a row of data
 * that a Flutter client can read too — never in JSX.
 *
 * Deliberately narrow: it guards `components/experience/**` completely, and guards
 * *persona-id* comparisons everywhere under `components/`. The older `mode ===`
 * branches in `dashboard-screen.tsx` are grandfathered by an explicit baseline, so
 * the number can only shrink. They go when R2.5 rolls the registry across the
 * remaining tracks.
 */

import { readdirSync, readFileSync, statSync } from "node:fs";
import { join, relative, sep } from "node:path";

const ROOT = process.cwd();
const COMPONENTS = join(ROOT, "apps", "web", "src", "components");

/**
 * Files still allowed to branch on `mode`, with the reason. This is a ratchet:
 * a file may leave the list, never join it without a deliberate edit here.
 */
const MODE_BASELINE = new Set([
  // Still here, and now for a narrower reason than before (R3.1.6).
  //
  // The `mode ===` branch that mattered — the generic prediction hero — is gone: it
  // was load-bearing only because `Z1`, the fallback persona, had no registry record
  // at all, and `track-z.ts` now serves it one. What remains are the four
  // life-stage *mounts* (teen, pregnancy, postpartum, menopause), which choose a
  // component rather than vary a layout, and moving those is a separate refactor
  // with its own risk.
  //
  // The ratchet still only shrinks: this entry leaves the list when those four
  // mounts become registry rows, and nothing may join it without editing this file.
  "components/dashboard/dashboard-screen.tsx",
]);

/**
 * Comments are documentation, not behaviour.
 *
 * The first run of this guard failed on `module-registry.tsx` — whose doc comment
 * *describes* the `mode === "pregnancy"` pattern it exists to replace. A guard that
 * trips on its own explanation is a guard people learn to work around, so strings
 * and code are what get tested.
 */
function stripComments(text) {
  return text.replace(/\/\*[\s\S]*?\*\//g, "").replace(/(^|[^:])\/\/.*$/gm, "$1");
}

const RULES = [
  {
    id: "persona-id-branch",
    // `personaId === "D3"`, `persona_id !== 'F1'`, `case "D7":` on a persona switch
    test: (t) => /persona_?[Ii]d\s*[!=]==?\s*["'][A-Z]\d/.test(t),
    why: "compares against a persona id — that belongs in the registry, as data",
    appliesTo: () => true,
  },
  {
    id: "mode-branch",
    test: (t) =>
      /\bmode\s*[!=]==?\s*["'](cycle|ttc|pregnancy|postpartum|menopause|general)["']/.test(t),
    why: "branches on a life-stage mode — render `ExperienceConfig.home.modules` instead",
    appliesTo: (rel) => !MODE_BASELINE.has(rel),
  },
];

function walk(dir, out = []) {
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry);
    if (statSync(full).isDirectory()) walk(full, out);
    else if (/\.(tsx|ts)$/.test(entry) && !/\.test\.tsx?$/.test(entry)) out.push(full);
  }
  return out;
}

let files;
try {
  files = walk(COMPONENTS);
} catch {
  console.error("✗ persona-branch guard: components directory not found — run from the repo root.");
  process.exit(1);
}

// A guard that scans nothing must fail, not pass (the P1.4.3 lesson).
if (files.length === 0) {
  console.error("✗ persona-branch guard: scanned 0 files, which cannot be right.");
  process.exit(1);
}

const findings = [];
for (const file of files) {
  const rel = relative(ROOT, file).split(sep).join("/").replace("apps/web/src/", "");
  const text = stripComments(readFileSync(file, "utf8"));
  for (const rule of RULES) {
    if (!rule.appliesTo(rel)) continue;
    if (rule.test(text)) findings.push({ rel, id: rule.id, why: rule.why });
  }
}

// A stale baseline entry over-claims just as badly as a missing rule does.
const stale = [...MODE_BASELINE].filter((rel) => {
  const full = join(ROOT, "apps", "web", "src", rel);
  try {
    return !RULES[1].test(stripComments(readFileSync(full, "utf8")));
  } catch {
    return true;
  }
});

if (findings.length === 0 && stale.length === 0) {
  console.log(
    `✓ Persona-branch guard: ${files.length} component(s) scanned, personas stay data (${MODE_BASELINE.size} legacy mode-branch file(s) baselined).`,
  );
  process.exit(0);
}

for (const f of findings) console.error(`  [${f.id}] ${f.rel} — ${f.why}`);
for (const rel of stale) {
  console.error(`  [stale-baseline] ${rel} no longer branches on mode — remove it from the list.`);
}
console.error(
  "\n✗ Persona-branch guard failed. Personalization is data (lib/experience/registry), never a branch in JSX.",
);
process.exit(1);
