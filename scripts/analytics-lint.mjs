#!/usr/bin/env node
/**
 * Privacy tripwire (replaces the analytics-catalog guard on 2026-10-27).
 *
 * The app sends nothing, and the website measures visits only after consent and never
 * what she typed (CLAUDE.md rule 4 as amended by ADR-075, 2026-10-28; legal position in
 * docs/33_REBUILD_V3/03_LEGAL_PACK.md: the Play Data safety answer "no data collected"
 * holds only while nothing leaves the device). A promise nobody checks drifts, so this
 * fails the gate when:
 *
 *   1. the website's package.json gains an analytics, error-reporting, tag-manager
 *      or database client (the container is loaded by a plain script, no package);
 *   2. website source mentions a tracking host or a third-party beacon anywhere but
 *      `apps/web/src/lib/consent/gtm.ts`, the one module allowed to name the Tag
 *      Manager host, or pushes to `dataLayer` anywhere but `lib/consent/events.ts`
 *      and the consent default (so every event passes the allow-list);
 *   3. the app's pubspec.yaml gains an analytics, crash-reporting or ads package;
 *   4. the app's release manifest asks for the INTERNET permission.
 *
 * Adding any of these is a decision for docs/DECISIONS.md and a change to the
 * privacy policy, never a dependency bump.
 */
import { readFileSync, readdirSync, statSync } from "node:fs";
import { join, relative } from "node:path";

const findings = [];
const fail = (file, message) => findings.push(`${file}: ${message}`);

// 1. Web dependencies.
const WEB_PKG = "apps/web/package.json";
const FORBIDDEN_WEB_PACKAGES = [
  /posthog/i, /@sentry\//i, /segment/i, /mixpanel/i, /amplitude/i, /hotjar/i, /@vercel\/analytics/i,
  /gtag/i, /google-tag/i, /firebase/i, /@supabase\//i, /plausible/i, /fathom/i, /fullstory/i,
];
try {
  const pkg = JSON.parse(readFileSync(WEB_PKG, "utf8"));
  const deps = { ...pkg.dependencies, ...pkg.devDependencies };
  for (const name of Object.keys(deps)) {
    if (FORBIDDEN_WEB_PACKAGES.some((re) => re.test(name))) {
      fail(WEB_PKG, `dependency "${name}" would send visitor data to a third party`);
    }
  }
} catch (error) {
  fail(WEB_PKG, `cannot read: ${error.message}`);
}

// 2. Web source: tracking hosts and beacons.
const WEB_SRC = "apps/web/src";
const TRACKING_PATTERNS = [
  /google-analytics\.com/i, /googletagmanager\.com/i, /connect\.facebook\.net/i, /posthog\.com/i,
  /sentry\.io/i, /hotjar\.com/i, /mixpanel\.com/i, /segment\.io/i, /navigator\.sendBeacon/,
  /supabase\.co/i,
];
// ADR-075: the Tag Manager host may appear in exactly one module, and only pushes to
// `dataLayer` that go through the allow-list in events.ts (plus the consent default,
// which pushes the denied state) are permitted. Anything else is a second tracker.
const GTM_HOST_ALLOWED_IN = new Set(["apps/web/src/lib/consent/gtm.ts", "apps/web/src/lib/consent/gtm.test.ts"]);
const DATALAYER_PUSH_ALLOWED_IN = new Set([
  "apps/web/src/lib/consent/events.ts",
  "apps/web/src/lib/consent/events.test.ts",
  "apps/web/src/lib/consent/consent-default.ts",
  "apps/web/src/lib/consent/gtm.ts",
]);
const DATALAYER_PUSH = /dataLayer(\s*\]?\s*)?\.push\s*\(|w\[l\]\.push/;
function walk(dir, out = []) {
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry);
    if (statSync(full).isDirectory()) walk(full, out);
    else if (/\.(ts|tsx|mjs|js)$/.test(entry)) out.push(full);
  }
  return out;
}
let files = [];
try {
  files = walk(WEB_SRC);
} catch {
  fail(WEB_SRC, "cannot scan the website source");
}
if (files.length === 0) fail(WEB_SRC, "no source files found; refusing to pass on nothing");
let gtmModuleSeen = false;
for (const file of files) {
  const text = readFileSync(file, "utf8");
  const rel = relative(process.cwd(), file).replace(/\\/g, "/");
  for (const re of TRACKING_PATTERNS) {
    if (!re.test(text)) continue;
    if (re.source === "googletagmanager\\.com" && GTM_HOST_ALLOWED_IN.has(rel)) {
      gtmModuleSeen = true;
      continue;
    }
    fail(rel, `mentions a tracking or data host (${re.source})`);
  }
  if (DATALAYER_PUSH.test(text) && !DATALAYER_PUSH_ALLOWED_IN.has(rel)) {
    fail(rel, "pushes to dataLayer outside lib/consent/events.ts; every event must pass the allow-list");
  }
}
if (!gtmModuleSeen) fail("apps/web/src/lib/consent/gtm.ts", "the one allowed Tag Manager module is missing; the allow-list above is stale");

// 3. App dependencies.
const PUBSPEC = "apps/mobile/pubspec.yaml";
const FORBIDDEN_DART_PACKAGES = [
  /firebase/i, /sentry/i, /crashlytics/i, /analytics/i, /admob/i, /google_mobile_ads/i, /facebook/i,
  /amplitude/i, /mixpanel/i, /posthog/i, /supabase/i, /appsflyer/i, /adjust/i, /onesignal/i,
];
try {
  const pubspec = readFileSync(PUBSPEC, "utf8");
  const depsBlock = pubspec.split(/^dependencies:/m)[1] ?? "";
  for (const line of depsBlock.split("\n")) {
    const name = line.match(/^  ([a-z_0-9]+):/)?.[1];
    if (name && FORBIDDEN_DART_PACKAGES.some((re) => re.test(name))) {
      fail(PUBSPEC, `package "${name}" would send her data off the phone`);
    }
  }
} catch (error) {
  fail(PUBSPEC, `cannot read: ${error.message}`);
}

// 4. Release manifest.
const MANIFEST = "apps/mobile/android/app/src/main/AndroidManifest.xml";
try {
  const manifest = readFileSync(MANIFEST, "utf8");
  if (/android\.permission\.INTERNET/.test(manifest)) {
    fail(MANIFEST, "the release manifest requests INTERNET; the app must not be able to send anything");
  }
} catch (error) {
  fail(MANIFEST, `cannot read: ${error.message}`);
}

if (findings.length > 0) {
  console.error("privacy tripwire FAILED:\n");
  for (const f of findings) console.error(`  ✗ ${f}`);
  console.error(`\n${findings.length} finding(s). See docs/33_REBUILD_V3/03_LEGAL_PACK.md.`);
  process.exit(1);
}
console.log("✓ privacy tripwire: no analytics, error-reporting, ads or database client in either product; the Tag Manager host and dataLayer pushes stay inside lib/consent; release manifest has no INTERNET permission.");
