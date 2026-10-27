#!/usr/bin/env node
/**
 * Privacy tripwire (replaces the analytics-catalog guard on 2026-10-27).
 *
 * The website collects nothing and the app sends nothing. That is a product
 * promise (CLAUDE.md rule 4) and a legal position (docs/33_REBUILD_V3/03_LEGAL_PACK.md:
 * the Play Data safety answer "no data collected" holds only while nothing leaves
 * the device). A promise nobody checks drifts, so this fails the gate when:
 *
 *   1. the website's package.json gains an analytics, error-reporting, tag-manager
 *      or database client;
 *   2. website source mentions a tracking host or a third-party beacon;
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
for (const file of files) {
  const text = readFileSync(file, "utf8");
  for (const re of TRACKING_PATTERNS) {
    if (re.test(text)) fail(relative(process.cwd(), file), `mentions a tracking or data host (${re.source})`);
  }
}

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
console.log("✓ privacy tripwire: no analytics, error-reporting, ads or database client in either product; release manifest has no INTERNET permission.");
