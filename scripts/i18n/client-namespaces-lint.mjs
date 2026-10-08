#!/usr/bin/env node
/**
 * Femio client-i18n guard (P1.11.2).
 *
 * The layout ships only the namespaces in `apps/web/src/i18n/client-namespaces.ts` to the
 * browser, which cut ~19 KB from every page. The risk that buys is specific and nasty: add a
 * `useTranslations("newThing")` to a client component, forget the list, and nothing fails —
 * not the build, not typecheck, not a server-rendered test. It fails when a real person
 * loads the page and next-intl throws for a missing message. This guard turns that into a
 * CI failure instead.
 *
 * It checks both directions, because both are wrong:
 *   - used but not listed   → runtime error in the browser
 *   - listed but not used   → dead weight shipped to every page, which is what we just fixed
 *
 * Same ratchet pattern as the other guards: fails loudly, and refuses to report a pass when
 * it found nothing to scan.
 */
import { readFileSync, readdirSync, statSync } from "node:fs";
import { join, extname } from "node:path";

const SRC_DIR = "apps/web/src";
const LIST_FILE = "apps/web/src/i18n/client-namespaces.ts";

function walk(dir, out = []) {
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry);
    if (entry === "node_modules" || entry === ".next") continue;
    if (statSync(full).isDirectory()) walk(full, out);
    else if ([".ts", ".tsx"].includes(extname(entry))) out.push(full);
  }
  return out;
}

let files = [];
try {
  files = walk(SRC_DIR);
} catch {
  /* handled below */
}

if (files.length === 0) {
  console.error(
    `✗ Client-i18n guard: no sources found under "${SRC_DIR}".\n` +
      "Run it from the repo root (`pnpm i18n-client-lint`). Refusing to report a pass on nothing.",
  );
  process.exit(1);
}

// The declared lists. Since P2.3 the payload is split in two — a public set shipped
// by the root layout and an app set added by the `(app)` route-group layout — so the
// guard reads both and checks usage against their union. Reading only the first
// match would silently under-report and let a missing namespace reach a browser.
let declared;
try {
  const source = readFileSync(LIST_FILE, "utf8");
  const names = new Set();
  let found = 0;
  const LISTS = [
    "PUBLIC_CLIENT_NAMESPACES",
    "APP_CLIENT_NAMESPACES",
    "CALCULATOR_CLIENT_NAMESPACES",
    "AUTH_CLIENT_NAMESPACES",
  ];
  for (const listName of LISTS) {
    const block = source.match(new RegExp(`${listName}\\s*=\\s*\\[([\\s\\S]*?)\\]`));
    if (!block) continue;
    found += 1;
    for (const m of block[1].matchAll(/"([^"]+)"/g)) names.add(m[1]);
  }
  if (found !== LISTS.length) {
    throw new Error(
      `expected all of ${LISTS.join(", ")} — ` +
        `found ${found}. If the lists were renamed or merged, update this guard in the ` +
        "same change rather than letting it check a subset.",
    );
  }
  declared = names;
} catch (err) {
  console.error(`✗ Client-i18n guard: cannot read ${LIST_FILE} — ${err.message}`);
  process.exit(1);
}

// Every namespace reached by the client hook. `useTranslations` is next-intl's
// client-capable hook; `getTranslations` (next-intl/server) renders on the server and
// needs nothing in the browser, so it is deliberately not counted.
const used = new Map(); // namespace -> [files]
const dynamic = [];

/**
 * Drop comments before scanning. Without this the guard flags its own documentation —
 * and, worse, would count a commented-out hook as a live one. `://` is spared so URLs
 * inside strings survive.
 */
function stripComments(source) {
  return source.replace(/\/\*[\s\S]*?\*\//g, " ").replace(/(^|[^:])\/\/.*$/gm, "$1");
}

for (const file of files) {
  if (file.replace(/\\/g, "/") === LIST_FILE) continue; // the list is not a consumer
  const source = stripComments(readFileSync(file, "utf8"));
  for (const m of source.matchAll(/useTranslations\(\s*("([^"]*)")?\s*\)/g)) {
    if (m[2] === undefined) {
      dynamic.push(`${file}: useTranslations() with no literal namespace`);
      continue;
    }
    const top = m[2].split(".")[0];
    if (!used.has(top)) used.set(top, []);
    used.get(top).push(file);
  }
  if (/\buseMessages\s*\(/.test(source)) {
    dynamic.push(`${file}: useMessages() reads the whole catalog, which this optimisation removes`);
  }
}

const problems = [];
for (const [namespace, owners] of used) {
  if (!declared.has(namespace)) {
    problems.push(
      `"${namespace}" is used by a client component but is NOT in CLIENT_NAMESPACES — it will be ` +
        `missing in the browser at runtime.\n      ${[...new Set(owners)].slice(0, 4).join("\n      ")}`,
    );
  }
}
for (const namespace of declared) {
  if (!used.has(namespace)) {
    problems.push(
      `"${namespace}" is in CLIENT_NAMESPACES but no client component uses it — it is shipped to ` +
        `every page for nothing. Remove it.`,
    );
  }
}
problems.push(...dynamic);

if (problems.length > 0) {
  console.error(`✗ Client-i18n guard: ${problems.length} problem(s).\n`);
  for (const p of problems) console.error(`  • ${p}`);
  console.error(`\nFix by editing ${LIST_FILE} (or the component), then re-run.`);
  process.exit(1);
}

console.log(
  `✓ Client-i18n guard: ${declared.size} namespace(s) shipped to the browser, ` +
    `all used, none missing (scanned ${files.length} files).`,
);
