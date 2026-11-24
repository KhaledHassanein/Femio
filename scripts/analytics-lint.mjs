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
 *   3. the app's pubspec.yaml gains an analytics, crash-reporting or ads-mediation
 *      package; the one ads package allowed is Google's `google_mobile_ads` (ADR-076);
 *   4. the app's own code can open a connection (http, dio, sockets): INTERNET exists in
 *      the release manifest only because the ads SDK declares it, and only while that
 *      SDK is in pubspec; the merged manifest must carry no location, phone, contacts,
 *      camera or microphone permission.
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
  "apps/web/src/app/app-ads.txt/route.ts",
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
// ADR-076 (2026-10-29): Google's own ads SDK is the one ads package allowed; mediation
// adapters, analytics, crash reporting and attribution SDKs stay forbidden because each
// adds a second party that sees device identifiers or app events.
const ADS_SDK_PACKAGE = "google_mobile_ads";
const FORBIDDEN_DART_PACKAGES = [
  /firebase/i, /sentry/i, /crashlytics/i, /analytics/i, /admob/i, /mediation/i, /applovin/i, /unity_ads/i,
  /ironsource/i, /facebook/i, /amplitude/i, /mixpanel/i, /posthog/i, /supabase/i, /appsflyer/i, /adjust/i,
  /onesignal/i, /^http$/i, /^dio$/i, /web_socket/i,
];
let adsSdkInPubspec = false;
try {
  const pubspec = readFileSync(PUBSPEC, "utf8");
  const depsBlock = pubspec.split(/^dependencies:/m)[1] ?? "";
  for (const line of depsBlock.split("\n")) {
    const name = line.match(/^  ([a-z_0-9]+):/)?.[1];
    if (!name) continue;
    if (name === ADS_SDK_PACKAGE) { adsSdkInPubspec = true; continue; }
    if (FORBIDDEN_DART_PACKAGES.some((re) => re.test(name))) {
      fail(PUBSPEC, `package "${name}" would send her data off the phone`);
    }
  }
} catch (error) {
  fail(PUBSPEC, `cannot read: ${error.message}`);
}

// 3b. The app's own code never opens a connection. With INTERNET in the manifest for the
// ads SDK, this is what keeps "her record never leaves the phone" checkable: no HTTP client,
// no socket, no WebSocket anywhere under lib/. (dart:io is allowed: files and the keystore.)
const APP_LIB = "apps/mobile/lib";
const NETWORK_CODE = [/\bHttpClient\b/, /\bSocket\.connect\b/, /\bRawSocket\b/, /\bWebSocket\b/, /package:http\//, /package:dio\//, /\bNetworkImage\(/, /\bImage\.network\(/];
const ADS_IMPORT_DART = /package:google_mobile_ads\//;
const ADS_IMPORT_DART_ALLOWED_IN = [/^apps\/mobile\/lib\/features\/ads\//];
try {
  for (const file of walk(APP_LIB).filter((f) => f.endsWith(".dart"))) {
    const text = readFileSync(file, "utf8");
    const rel = relative(process.cwd(), file).replace(/\\/g, "/");
    for (const re of NETWORK_CODE) {
      if (re.test(text)) fail(rel, `opens a network connection of its own (${re.source}); only the ads SDK may talk to the network`);
    }
    if (ADS_IMPORT_DART.test(text) && !ADS_IMPORT_DART_ALLOWED_IN.some((re) => re.test(rel))) {
      fail(rel, "imports the ads SDK outside lib/features/ads/; ad surfaces are decided in lib/domain/ads_policy.dart");
    }
  }
} catch (error) {
  fail(APP_LIB, `cannot scan: ${error.message}`);
}

// 3c. The assistant (ADR-078): model calls live in Kotlin only, under one package, and only
// Firebase AI Logic and App Check may be added to Gradle; analytics, Crashlytics, messaging
// and the rest of Firebase stay out. Dart reaches the bridge only through
// lib/data/assistant_channel.dart, which takes a CloudSafeText for anything bound for the cloud.
const GRADLE = "apps/mobile/android/app/build.gradle.kts";
const ALLOWED_FIREBASE = /com\.google\.firebase:firebase-(ai|ai-ondevice|appcheck-debug|appcheck-playintegrity):/;
try {
  for (const line of readFileSync(GRADLE, "utf8").split("\n")) {
    if (/^\s*\/\//.test(line)) continue;
    if (/com\.google\.firebase:/.test(line) && !ALLOWED_FIREBASE.test(line)) {
      fail(GRADLE, `adds a Firebase library outside AI Logic and App Check: ${line.trim()}`);
    }
    if (/google-services|crashlytics|firebase-analytics|firebase-messaging/i.test(line)) {
      fail(GRADLE, `adds a tracking or messaging plugin: ${line.trim()}`);
    }
  }
} catch (error) {
  fail(GRADLE, `cannot read: ${error.message}`);
}
const KOTLIN_SRC = "apps/mobile/android/app/src";
const FIREBASE_KOTLIN_ALLOWED = /\/kotlin\/com\/femioapp\/femio\/assistant\//;
try {
  const kotlinFiles = [];
  (function walkKt(dir) {
    for (const entry of readdirSync(dir)) {
      const full = join(dir, entry);
      if (statSync(full).isDirectory()) walkKt(full);
      else if (entry.endsWith(".kt")) kotlinFiles.push(full);
    }
  })(KOTLIN_SRC);
  for (const file of kotlinFiles) {
    const rel = relative(process.cwd(), file).replace(/\\/g, "/");
    if (/import com\.google\.firebase\./.test(readFileSync(file, "utf8")) && !FIREBASE_KOTLIN_ALLOWED.test(rel)) {
      fail(rel, "uses Firebase outside the assistant package (ADR-078 §5)");
    }
  }
} catch (error) {
  fail(KOTLIN_SRC, `cannot scan: ${error.message}`);
}
const ASSISTANT_CHANNEL_DART = "apps/mobile/lib/data/assistant_channel.dart";
try {
  for (const file of walk(APP_LIB).filter((f) => f.endsWith(".dart"))) {
    const rel = relative(process.cwd(), file).replace(/\\/g, "/");
    if (/com\.femioapp\.femio\/assistant/.test(readFileSync(file, "utf8")) && rel !== ASSISTANT_CHANNEL_DART) {
      fail(rel, "names the assistant channel; only lib/data/assistant_channel.dart may (ADR-078 §5)");
    }
  }
  if (!/askGrounded\(CloudSafeText /.test(readFileSync(ASSISTANT_CHANNEL_DART, "utf8"))) {
    fail(ASSISTANT_CHANNEL_DART, "the cloud call no longer requires a CloudSafeText (ADR-078 §3)");
  }
} catch (error) {
  fail(ASSISTANT_CHANNEL_DART, `cannot read: ${error.message}`);
}

// 4. Source manifest: the app itself never asks for INTERNET (the ads SDK's manifest does,
// and only while the SDK is in pubspec), and never for anything that reads the person.
const MANIFEST = "apps/mobile/android/app/src/main/AndroidManifest.xml";
const PERSONAL_PERMISSIONS = [
  /ACCESS_FINE_LOCATION/, /ACCESS_COARSE_LOCATION/, /ACCESS_BACKGROUND_LOCATION/, /READ_PHONE_STATE/, /READ_CONTACTS/,
  /CAMERA/, /RECORD_AUDIO/, /READ_SMS/, /READ_CALL_LOG/, /GET_ACCOUNTS/, /BLUETOOTH_SCAN/, /ACTIVITY_RECOGNITION/,
];
try {
  const manifest = readFileSync(MANIFEST, "utf8");
  const requested = manifest.split("\n").filter((line) => !/tools:node="remove"/.test(line)).join("\n");
  if (/android\.permission\.INTERNET/.test(requested)) {
    fail(MANIFEST, "the app's own manifest requests INTERNET; only the ads SDK may declare it (ADR-076)");
  }
  for (const re of PERSONAL_PERMISSIONS) {
    if (re.test(requested)) fail(MANIFEST, `requests a permission that reads the person (${re.source})`);
  }
} catch (error) {
  fail(MANIFEST, `cannot read: ${error.message}`);
}

// 4b. The merged release manifest, when a release build exists locally: what the libraries
// add. INTERNET and ACCESS_NETWORK_STATE are expected from the ads SDK (ADR-076) and
// forbidden without it; the personal permissions above are forbidden from any library.
const MERGED = "apps/mobile/build/app/intermediates/merged_manifests/release/processReleaseManifest/AndroidManifest.xml";
try {
  const merged = readFileSync(MERGED, "utf8");
  if (!adsSdkInPubspec && /android\.permission\.INTERNET/.test(merged)) {
    fail(MERGED, "the MERGED release manifest requests INTERNET without the ads SDK: a library added it; see the manifest-merger report");
  }
  for (const re of PERSONAL_PERMISSIONS) {
    if (re.test(merged)) fail(MERGED, `the MERGED release manifest requests a permission that reads the person (${re.source}); a library added it`);
  }
} catch {
  // No local release build; the source checks above still ran.
}

if (findings.length > 0) {
  console.error("privacy tripwire FAILED:\n");
  for (const f of findings) console.error(`  ✗ ${f}`);
  console.error(`\n${findings.length} finding(s). See docs/33_REBUILD_V3/03_LEGAL_PACK.md.`);
  process.exit(1);
}
console.log(`✓ privacy tripwire: no analytics, error-reporting or database client in either product; website: Tag Manager and AdSense hosts inside lib/consent and lib/ads only, ad units only in the article and hub; app: ${adsSdkInPubspec ? "Google's ads SDK only, imported only under lib/features/ads/" : "no ads SDK"}, no network code of its own, Firebase AI Logic only inside the Kotlin assistant behind CloudSafeText, no personal permission (source and merged manifest, when built).`);
