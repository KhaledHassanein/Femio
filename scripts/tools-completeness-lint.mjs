#!/usr/bin/env node
/**
 * Femio tools-completeness guard (RB-B6, `docs/29_REBUILD/03` §3).
 *
 * Product rule 2 is "personalize, never restrict". The dashboard decides what
 * *leads*; the Tools screen is the promise that nothing was taken away. Its own
 * header says so: it does not filter by persona, does not reorder by track, and
 * does not hide a tool because Femio thinks she will not want it.
 *
 * `SurfaceMap.tools.featured` is the one place a persona touches that screen, and
 * it **orders** — it never filters. That sentence is a comment, and a comment
 * cannot fail CI, so this is the check.
 *
 * ## What it verifies
 *
 * **1. `ToolId` and the Tools screen agree, in both directions.** A tool the union
 * does not know cannot be ordered by a served document; a tool the screen has
 * dropped cannot be found by anyone. The first draft of `ToolId` was written from
 * memory and was wrong in six places — three invented, three missing — which is
 * exactly the drift this catches.
 *
 * **2. Nothing filters the tool list.** A `.filter(` or a `mode ===` inside the
 * Tools screen is the mechanism by which "personalise" quietly becomes "restrict".
 * It is the same failure `persona-branch-lint` guards elsewhere, applied to the one
 * screen where hiding anything is forbidden outright.
 *
 * The failure mode this prevents is silent: a filtered Tools screen looks correct.
 * Nothing is broken, nothing errors, and a woman simply never finds the calculator
 * we decided a pregnant user would not want.
 */
import { readFileSync } from "node:fs";

const TYPES = "apps/web/src/lib/experience/v2/types.ts";
const SCREEN = "apps/web/src/components/tools/tools-screen.tsx";

const types = readFileSync(TYPES, "utf8");
const screen = readFileSync(SCREEN, "utf8");

/* ---- 1. the union ------------------------------------------------- */

const unionBlock = types.match(/export type ToolId =([\s\S]*?);/);
if (!unionBlock) {
  console.error(`✗ Could not find the ToolId union in ${TYPES}.`);
  process.exit(1);
}
const declared = new Set([...unionBlock[1].matchAll(/"([a-z-]+)"/g)].map((m) => m[1]));

/* ---- 2. the screen ------------------------------------------------ */

/** `{ href: "/summary", key: "summary", Icon: FileText }` → `summary`. */
const onScreen = new Set([...screen.matchAll(/key:\s*"([a-z-]+)"/g)].map((m) => m[1]));

const problems = [];

for (const id of declared) {
  if (!onScreen.has(id)) {
    problems.push(
      `ToolId declares "${id}" but ${SCREEN} does not list it. ` +
        `A served document could order a tool she cannot reach.`,
    );
  }
}
for (const id of onScreen) {
  if (!declared.has(id)) {
    problems.push(
      `${SCREEN} lists "${id}" but ToolId does not declare it. ` +
        `That tool can never be featured, because the contract cannot name it.`,
    );
  }
}

/* ---- 3. nothing filters ------------------------------------------- */

/**
 * Only the tool arrays matter. A `.filter(` elsewhere in the file — on a string,
 * on translations — is not the failure. The lists are `RECORD` and `TOOLS`.
 */
for (const listName of ["RECORD", "TOOLS"]) {
  const uses = [...screen.matchAll(new RegExp(`\\b${listName}\\b[^\\n]*`, "g"))].map((m) => m[0]);
  for (const use of uses) {
    if (/\.filter\(|\.slice\(|mode\s*===|persona\s*===|track\s*===/.test(use)) {
      problems.push(
        `${SCREEN}: \`${listName}\` is filtered or sliced — "${use.trim()}". ` +
          `The Tools screen shows everything, in every persona. That is product rule 2.`,
      );
    }
  }
}

/* ---- report ------------------------------------------------------- */

if (problems.length > 0) {
  console.error("✗ Tools-completeness guard failed:\n");
  for (const p of problems) console.error(`  • ${p}`);
  console.error(
    "\n  `SurfaceMap.tools.featured` orders the Tools screen; it never filters it.\n" +
      "  A persona decides what leads, never what exists.\n",
  );
  process.exit(1);
}

console.log(
  `✓ Tools-completeness guard: ${declared.size} tool(s) declared and listed, ` +
    `none filtered by persona.`,
);
