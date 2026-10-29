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
 *      and the consent default (so every event passes the allow-list); likewise the
 *      AdSense host only in `lib/ads/adsense.ts`, the unit markup only in
 *      `lib/ads/ad-unit.tsx`, and `lib/ads` imported only by the article and hub
 *      components (R6.8: no ad beside a calculator, the help page or a legal page);
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
  /supabase\.co/i, /googlesyndication\.com/i, /doubleclick\.net/i, /adsbygoogle\.js/i,
];
// R6.8: the AdSense host may appear in exactly one module (plus its test), and the
// `<ins class="adsbygoogle">` markup in exactly one component, so a unit can never be
// dropped into a calculator, the help page or a legal page by accident.
const ADS_HOST_ALLOWED_IN = new Set(["apps/web/src/lib/ads/adsense.ts", "apps/web/src/lib/ads/adsense.test.ts"]);
const ADS_HOST_PATTERNS = new Set(["googlesyndication\\.com", "doubleclick\\.net", "adsbygoogle\\.js"]);
const AD_UNIT_MARKUP = /className="adsbygoogle|class="adsbygoogle|adsbygoogle\s*=\s*window\.adsbygoogle|w\.adsbygoogle/;
const AD_UNIT_ALLOWED_IN = new Set(["apps/web/src/lib/ads/ad-unit.tsx"]);
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
    if (ADS_HOST_PATTERNS.has(re.source) && ADS_HOST_ALLOWED_IN.has(rel)) continue;
    fail(rel, `mentions a tracking or data host (${re.source})`);
  }
  if (DATALAYER_PUSH.test(text) && !DATALAYER_PUSH_ALLOWED_IN.has(rel)) {
    fail(rel, "pushes to dataLayer outside lib/consent/events.ts; every event must pass the allow-list");
  }
  if (AD_UNIT_MARKUP.test(text) && !AD_UNIT_ALLOWED_IN.has(rel)) {
    fail(rel, "renders an ad unit outside lib/ads/ad-unit.tsx; placements are decided in lib/ads/placements.ts");
  }
}
if (!gtmModuleSeen) fail("apps/web/src/lib/consent/gtm.ts", "the one allowed Tag Manager module is missing; the allow-list above is stale");
// 2b. Ads reach the browser only through the content components (02_MONETIZATION.md
// §1.1): calculators, help-now, legal pages, the home page and the root layout never
// import the ads module, so the rule "no ad beside a tool or a crisis line" is checked,
// not remembered.
const ADS_IMPORT = /from \s*["']@\/lib\/ads\//;
const ADS_IMPORT_ALLOWED_IN = new Set([
  "apps/web/src/components/cms/content-article.tsx",
  "apps/web/src/components/cms/content-hub.tsx",
  "apps/web/src/components/learn/learn-hub.tsx",
  "apps/web/src/app/ads.txt/route.ts",
]);
for (const file of files) {
  const rel = relative(process.cwd(), file).replace(/\\/g, "/");
  if (rel.startsWith("apps/web/src/lib/ads/")) continue;
  if (ADS_IMPORT.test(readFileSync(file, "utf8")) && !ADS_IMPORT_ALLOWED_IN.has(rel)) {
    fail(rel, "imports lib/ads; only the article and hub components may carry an ad placement");
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
  // A `tools:node="remove"` line names the permission in order to strip it (R6.9).
  const requested = manifest.split("\n").filter((line) => !/tools:node="remove"/.test(line)).join("\n");
  if (/android\.permission\.INTERNET/.test(requested)) {
    fail(MANIFEST, "the release manifest requests INTERNET; the app must not be able to send anything");
  }
} catch (error) {
  fail(MANIFEST, `cannot read: ${error.message}`);
}

// 4b. The merged release manifest, when a release build exists locally. The source
// manifest cannot show what a library adds: the Play Billing library (R6.9 spike,
// 2026-10-29) pulls in Google's `transport-backend-cct` telemetry, which declares
// INTERNET and ACCESS_NETWORK_STATE; the source manifest removes both with
// `tools:node="remove"`, and this check proves the removal held in the real build.
const MERGED = "apps/mobile/build/app/intermediates/merged_manifests/release/processReleaseManifest/AndroidManifest.xml";
try {
  const merged = readFileSync(MERGED, "utf8");
  if (/android\.permission\.INTERNET/.test(merged)) {
    fail(MERGED, "the MERGED release manifest requests INTERNET: a library added it; see the manifest-merger report");
  }
} catch {
  // No local release build; the source check above still ran.
}

if (findings.length > 0) {
  console.error("privacy tripwire FAILED:\n");
  for (const f of findings) console.error(`  ✗ ${f}`);
  console.error(`\n${findings.length} finding(s). See docs/33_REBUILD_V3/03_LEGAL_PACK.md.`);
  process.exit(1);
}
console.log("✓ privacy tripwire: no analytics, error-reporting, ads or database client in either product; Tag Manager and AdSense hosts stay inside lib/consent and lib/ads, ad units only in the article and hub; release manifest (source and merged, when built) has no INTERNET permission.");
