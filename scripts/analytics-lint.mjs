#!/usr/bin/env node
/**
 * Femio analytics compliance guard (docs/13 §5/§6, docs/compliance/DATA_MAP.md).
 *
 * The rule it defends: **no health data reaches a third-party analytics SDK,
 * ever.** The unit tests already prove the runtime guard rejects unsafe payloads,
 * but tests only cover the schema as it stands today. This lint is the ratchet —
 * it fails CI when the *source* drifts in a direction that would widen what can
 * leave the browser, including in ways a passing test suite wouldn't notice.
 *
 * Checks:
 *   1. The event catalog contains no health-shaped property key or value.
 *   2. No free-form value types (z.string(), template literals, `string` typed
 *      props) creep into the catalog — closed enums are the whole guarantee.
 *   3. Autocapture and session recording are never enabled, since either would
 *      bypass the catalog entirely by scraping the DOM.
 *   4. Nothing in the app tracks the crisis surface (ADR-013).
 *
 * If a flagged term is genuinely fine, narrow the check with a comment — never
 * delete a rule to make the build pass.
 */
import { readFileSync, readdirSync, statSync } from "node:fs";
import { join, relative } from "node:path";

const EVENTS_FILE = "apps/web/src/lib/analytics/events.ts";
const ANALYTICS_DIR = "apps/web/src/lib/analytics";
const APP_SRC = "apps/web/src";

const findings = [];
const fail = (file, message) => findings.push(`${file}: ${message}`);

// ---------------------------------------------------------------------------
// 1 + 2. The event catalog must stay a closed, health-free enum schema.
// ---------------------------------------------------------------------------
let events;
try {
  events = readFileSync(EVENTS_FILE, "utf8");
} catch {
  fail(EVENTS_FILE, "missing — the analytics event catalog must exist");
}

if (events) {
  // Strip comments so the explanatory prose (which necessarily names the health
  // fields we exclude, e.g. "a symptom name") isn't mistaken for schema.
  const code = events
    .replace(/\/\*[\s\S]*?\*\//g, "")
    .replace(/^[ \t]*\/\/.*$/gm, "");

  // Health stems, prefix-matched against *tokens*. Tokenizing (rather than using
  // \b on the raw source) is essential: an underscore is a word character, so
  // /\bcondition\b/ does not match `condition_tag` — the exact leak this check
  // exists to catch. Mirrors `tokenize` in lib/analytics/guard.ts.
  const HEALTH = [
    "symptom", "cycle", "menstrual", "ovulation", "fertile", "fertility",
    "pregnan", "gestation", "postpartum", "menopaus", "conceive", "contracept",
    "mood", "depress", "anxiety", "epds", "phq", "screener", "diagnos",
    "condition", "persona", "medication", "dosage", "bmi", "bbt", "suicide",
    "birthdate", "birthday",
  ];
  const tokens = new Set(
    code
      .replace(/([a-z0-9])([A-Z])/g, "$1 $2")
      .split(/[^a-zA-Z0-9]+/)
      .filter(Boolean)
      .map((token) => token.toLowerCase()),
  );
  for (const stem of HEALTH) {
    const hit = [...tokens].find((token) => token.startsWith(stem));
    if (hit) {
      fail(EVENTS_FILE, `event catalog mentions health-shaped term "${hit}" — see docs/13 §5`);
    }
  }
  // "age" needs the token-equality treatment: as a prefix it fires on the
  // legitimate `language`/`page` tokens the catalog contains.
  for (const exact of ["age", "ages", "band", "lab", "labs", "dob"]) {
    if (tokens.has(exact)) {
      fail(EVENTS_FILE, `event catalog mentions health-shaped term "${exact}" — see docs/13 §5`);
    }
  }

  // Free-form value types would defeat the closed-enum guarantee.
  for (const [pattern, why] of [
    [/z\s*\.\s*string\s*\(/, "zod free-form string in the catalog"],
    [/:\s*string(\s*[;,)\]}]|$)/m, "a `string`-typed property (must be a closed enum)"],
    [/\$\{/, "a template literal (values must be literal enum members)"],
    // `: number` only — NOT the `(typeof X)[number]` tuple-indexing idiom, which
    // is how the enum member types are derived and is entirely safe.
    [/:\s*number(\s*[;,)\]}]|$)/m, "a numeric property (a number can encode a date or lab value)"],
    [/\bz\s*\.\s*number\s*\(/, "a zod numeric property"],
  ]) {
    if (pattern.test(code)) fail(EVENTS_FILE, `${why} — every value must come from a listed enum`);
  }
}

// ---------------------------------------------------------------------------
// 3. Autocapture / session recording must never be switched on.
// ---------------------------------------------------------------------------
function walkFiles(dir, out = []) {
  for (const entry of readdirSync(dir)) {
    const path = join(dir, entry);
    if (statSync(path).isDirectory()) {
      if (entry === "node_modules" || entry === ".next") continue;
      walkFiles(path, out);
    } else if (/\.(ts|tsx|mjs|js)$/.test(entry)) {
      out.push(path);
    }
  }
  return out;
}

let appFiles = [];
try {
  appFiles = walkFiles(APP_SRC);
} catch {
  fail(APP_SRC, "missing — cannot scan the app source");
}

for (const file of appFiles) {
  const src = readFileSync(file, "utf8");
  const code = src.replace(/\/\*[\s\S]*?\*\//g, "").replace(/^[ \t]*\/\/.*$/gm, "");
  const rel = relative(".", file).replace(/\\/g, "/");

  if (/autocapture\s*:\s*true/.test(code)) {
    fail(rel, "autocapture: true — would scrape DOM text (symptom labels, article titles)");
  }
  if (/disable_session_recording\s*:\s*false/.test(code) || /session_recording\s*:\s*\{/.test(code)) {
    fail(rel, "session recording enabled — would capture health fields on screen");
  }
  // 4. The crisis surface must never be measured.
  if (/\btrack\s*\(\s*["'`][^"'`]*crisis/i.test(code) || /\bcapture\s*\(\s*["'`][^"'`]*crisis/i.test(code)) {
    fail(rel, "tracks the crisis surface — forbidden by ADR-013 / CRISIS_RESOURCES");
  }
}

// ---------------------------------------------------------------------------
// Consent gating must remain opt-in and fail-closed.
// ---------------------------------------------------------------------------
try {
  const consent = readFileSync(join(ANALYTICS_DIR, "consent.ts"), "utf8");
  if (!/return false/.test(consent)) {
    fail(`${ANALYTICS_DIR}/consent.ts`, "must fail closed (return false) when consent is absent");
  }
  if (/purpose\s*=\s*["']insights["']/.test(consent)) {
    fail(
      `${ANALYTICS_DIR}/consent.ts`,
      "gates analytics on the 'insights' purpose — that is first-party pattern " +
        "processing, not permission to send events to a third party",
    );
  }
} catch {
  fail(`${ANALYTICS_DIR}/consent.ts`, "missing — analytics must be consent-gated");
}

if (findings.length > 0) {
  console.error("analytics-lint FAILED:\n");
  for (const finding of findings) console.error(`  ✗ ${finding}`);
  console.error(`\n${findings.length} finding(s). See docs/19_ANALYTICS_EVENT_SCHEMA.md.`);
  process.exit(1);
}

console.log("analytics-lint OK — event catalog is closed, health-free, and consent-gated.");
