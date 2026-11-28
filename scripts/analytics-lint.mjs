#!/usr/bin/env node
/**
 * Privacy tripwire (replaces the analytics-catalog guard on 2026-10-27).
 *
 * The app sends nothing, and the website counts visits with Vercel Web Analytics only
 * (cookieless, path only; owner decision 2026-11-24, which removed Tag Manager, GA4 and
 * the Meta pixel: no tracking tool may learn which health page a visitor opened;
 * CLAUDE.md rule 4 as amended by ADR-075; legal position in
 * docs/33_REBUILD_V3/03_LEGAL_PACK.md: the Play Data safety answer "no data collected"
 * holds only while nothing leaves the device). A promise nobody checks drifts, so this
 * fails the gate when:
 *
 *   1. the website's package.json gains an analytics, error-reporting, tag-manager
 *      or database client; the one analytics package allowed is `@vercel/analytics`;
 *   2. website source mentions Google Tag Manager, GA4, a gtag config or event call,
 *      the Meta pixel (`fbq`, facebook.net) or any other tracking host, anywhere; the
 *      only analytics import is `@vercel/analytics` from `lib/analytics/`; `dataLayer`
 *      is pushed only by the AdSense consent-default snippet (`lib/ads/`); likewise the
 *      AdSense host only in `lib/ads/adsense.ts`, the unit markup only in
 *      `lib/ads/ad-unit.tsx`, and `lib/ads` imported only by the article and hub
 *      components (R6.8: no ad beside a calculator, the help page or a legal page);
 *   3. the app's pubspec.yaml gains an analytics, crash-reporting, attribution or ads
 *      package (google_mobile_ads included: the app ships no ads SDK at all, owner
 *      decision 2026-11-24), any Dart file imports one, or `lib/features/ads` exists;
 *   4. the app's own code can open a connection (http, dio, sockets): INTERNET is declared
 *      in the app's manifest only for Firebase AI Logic (ADR-079); the merged manifest must
 *      carry no ad-ID or ad-services permission (AD_ID, ACCESS_ADSERVICES_*) and no
 *      location, phone, contacts, camera, microphone or storage permission;
 *   5. native code under apps/mobile/android can reach the network outside the assistant
 *      package, the app module declares a Gradle dependency or plugin not on the reviewed
 *      list, or a current merged manifest carries ad or analytics metadata or an unreviewed
 *      component (scripts/lib/android-tripwire.mjs, R14.14).
 *
 * Adding any of these is a decision for docs/DECISIONS.md and a change to the
 * privacy policy, never a dependency bump.
 */
import { existsSync, readFileSync, readdirSync, statSync } from "node:fs";
import { join, relative } from "node:path";

import { checkAndroid } from "./lib/android-tripwire.mjs";

const findings = [];
const fail = (file, message) => findings.push(`${file}: ${message}`);

// 1. Web dependencies.
const WEB_PKG = "apps/web/package.json";
const FORBIDDEN_WEB_PACKAGES = [
  /posthog/i, /@sentry\//i, /segment/i, /mixpanel/i, /amplitude/i, /hotjar/i,
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
  // Owner decision 2026-11-24: no Google Tag Manager, GA4 or Meta pixel, in any form.
  /googletagmanager/i, /\bGTM-[A-Z0-9]{4,}/, /NEXT_PUBLIC_GTM/, /gtm\.js/i, /analytics\.google\.com/i,
  /gtag\s*\(\s*['"](config|event|js|set|get)['"]/, /gtag\/js/i, /['"]G-[A-Z0-9]{8,}['"]/,
  /\bfbq\b/, /facebook\.net/i, /facebook\.com\/tr/i, /fbevents/i,
];
// R6.8: the AdSense host may appear in exactly one module (plus its test), and the
// `<ins class="adsbygoogle">` markup in exactly one component, so a unit can never be
// dropped into a calculator, the help page or a legal page by accident.
const ADS_HOST_ALLOWED_IN = new Set(["apps/web/src/lib/ads/adsense.ts", "apps/web/src/lib/ads/adsense.test.ts"]);
const ADS_HOST_PATTERNS = new Set(["googlesyndication\\.com", "doubleclick\\.net", "adsbygoogle\\.js"]);
const AD_UNIT_MARKUP = /className="adsbygoogle|class="adsbygoogle|adsbygoogle\s*=\s*window\.adsbygoogle|w\.adsbygoogle/;
const AD_UNIT_ALLOWED_IN = new Set(["apps/web/src/lib/ads/ad-unit.tsx"]);
// Owner decision 2026-11-24: the only `dataLayer` writer left is the AdSense Consent Mode
// default (denied) snippet; nothing may push events. `@vercel/analytics` may be imported
// from exactly one component, which strips the query and hash before anything is sent.
const DATALAYER_PUSH_ALLOWED_IN = new Set([
  "apps/web/src/lib/ads/consent-mode-default.ts",
  "apps/web/src/lib/ads/consent-mode-default.test.ts",
]);
const VERCEL_ANALYTICS_IMPORT = /["']@vercel\/(analytics|speed-insights)/;
const VERCEL_ANALYTICS_ALLOWED_IN = new Set([
  "apps/web/src/lib/analytics/visit-measurement.tsx",
  "apps/web/src/lib/analytics/visit-measurement.test.ts",
]);
const DATALAYER_PUSH = /dataLayer(\s*\]?\s*)?\.push\s*\(|w\[l\]\.push/;
function walk(dir, out = []) {
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry);
    if (statSync(full).isDirectory()) walk(full, out);
    else if (/\.(ts|tsx|mjs|js|dart)$/.test(entry)) out.push(full);
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
let visitMeasurementSeen = false;
for (const file of files) {
  const text = readFileSync(file, "utf8");
  const rel = relative(process.cwd(), file).replace(/\\/g, "/");
  for (const re of TRACKING_PATTERNS) {
    if (!re.test(text)) continue;
    if (ADS_HOST_PATTERNS.has(re.source) && ADS_HOST_ALLOWED_IN.has(rel)) continue;
    fail(rel, `mentions a tracking or data host (${re.source})`);
  }
  if (DATALAYER_PUSH.test(text) && !DATALAYER_PUSH_ALLOWED_IN.has(rel)) {
    fail(rel, "pushes to dataLayer; only the AdSense consent-default snippet in lib/ads may (no event layer, 2026-11-24)");
  }
  if (VERCEL_ANALYTICS_IMPORT.test(text)) {
    if (VERCEL_ANALYTICS_ALLOWED_IN.has(rel)) visitMeasurementSeen = true;
    else fail(rel, "imports @vercel/analytics outside lib/analytics/visit-measurement.tsx");
  }
  if (AD_UNIT_MARKUP.test(text) && !AD_UNIT_ALLOWED_IN.has(rel)) {
    fail(rel, "renders an ad unit outside lib/ads/ad-unit.tsx; placements are decided in lib/ads/placements.ts");
  }
}
if (!visitMeasurementSeen) fail("apps/web/src/lib/analytics/visit-measurement.tsx", "the one allowed analytics module is missing; the allow-list above is stale");
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
// Owner decision 2026-11-24 (reverses ADR-076): the app ships no ads SDK, Google's included.
// Ads, mediation, analytics, crash reporting and attribution packages are all forbidden
// because each adds a second party that sees device identifiers or app events.
const FORBIDDEN_DART_PACKAGES = [
  /mobile_ads/i, /^ads?$/i, /_ads?$/i, /^ads?_/i, /adsense/i, /attribution/i, /branch/i, /adservices/i,
  /firebase/i, /sentry/i, /crashlytics/i, /analytics/i, /admob/i, /mediation/i, /applovin/i, /unity_ads/i,
  /ironsource/i, /facebook/i, /amplitude/i, /mixpanel/i, /posthog/i, /supabase/i, /appsflyer/i, /adjust/i,
  /onesignal/i, /^http$/i, /^dio$/i, /web_socket/i,
];
try {
  const pubspec = readFileSync(PUBSPEC, "utf8");
  const depsBlock = pubspec.split(/^dependencies:/m)[1] ?? "";
  for (const line of depsBlock.split("\n")) {
    const name = line.match(/^  ([a-z_0-9]+):/)?.[1];
    if (!name) continue;
    if (FORBIDDEN_DART_PACKAGES.some((re) => re.test(name))) {
      fail(PUBSPEC, `package "${name}" would send her data off the phone`);
    }
  }
} catch (error) {
  fail(PUBSPEC, `cannot read: ${error.message}`);
}

// 3b. The app's own code never opens a connection. With INTERNET in the manifest for
// Firebase AI Logic, this is what keeps "her record never leaves the phone" checkable: no HTTP
// client, no socket, no WebSocket anywhere under lib/. (dart:io is allowed: files and the keystore.)
const APP_LIB = "apps/mobile/lib";
const NETWORK_CODE = [/\bHttpClient\b/, /\bSocket\.connect\b/, /\bRawSocket\b/, /\bWebSocket\b/, /package:http\//, /package:dio\//, /\bNetworkImage\(/, /\bImage\.network\(/];
// Any import of an ads, analytics or attribution package, by name, whatever pubspec says.
const TRACKING_IMPORT_DART = /package:(google_mobile_ads|[a-z_0-9]*(admob|mobile_ads|analytics|crashlytics|sentry|attribution|appsflyer|adjust|mixpanel|amplitude|posthog|onesignal|applovin|unity_ads|ironsource)[a-z_0-9]*)\//;
try {
  if (existsSync("apps/mobile/lib/features/ads")) {
    fail("apps/mobile/lib/features/ads", "the ads feature folder exists; the app ships no ads (owner decision 2026-11-24)");
  }
  for (const file of walk(APP_LIB).filter((f) => f.endsWith(".dart"))) {
    const text = readFileSync(file, "utf8");
    const rel = relative(process.cwd(), file).replace(/\\/g, "/");
    for (const re of NETWORK_CODE) {
      if (re.test(text)) fail(rel, `opens a network connection of its own (${re.source}); the app's Dart code must not talk to the network`);
    }
    if (TRACKING_IMPORT_DART.test(text)) {
      fail(rel, "imports an ads, analytics or attribution package; the app ships none (owner decision 2026-11-24)");
    }
  }
} catch (error) {
  fail(APP_LIB, `cannot scan: ${error.message}`);
}

// 3c. The assistant (ADR-078): model calls live in Kotlin only, under one package, and only
// Firebase AI Logic and App Check may be added to Gradle; analytics, Crashlytics, messaging
// and the rest of Firebase stay out. Dart reaches the bridge only through
// lib/data/assistant_channel.dart, whose cloud-capable call takes only a CloudPrompt (ADR-079).
// A CloudPrompt is built only in cloud_prompt.dart, only from a CloudSafeText question or a
// PseudonymisedProfile, and no Google Search grounding tool may be wired in anywhere.
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
    const kt = readFileSync(file, "utf8");
    if (/import com\.google\.firebase\./.test(kt) && !FIREBASE_KOTLIN_ALLOWED.test(rel)) {
      fail(rel, "uses Firebase outside the assistant package (ADR-078 §5)");
    }
    if (/googleSearch|GoogleSearch/.test(kt)) {
      fail(rel, "wires Google Search grounding; answers come only from the bundled registry (ADR-079)");
    }
    // Every model call sends either the prompt Dart passed (a PrivatePrompt or a CloudPrompt) or
    // the fixed "Check Cloud boost" sentence, and only that check may run ONLY_IN_CLOUD (ADR-085).
    // ADR-087: the one exception is `request`, the page picture plus the prompt Dart passed,
    // and only inside privateImage, which must run ONLY_ON_DEVICE (no cloud fallback).
    const imageCall = kt.match(/private suspend fun privateImage\([\s\S]*?\r?\n    }\r?\n/)?.[0] ?? "";
    // The call may go through the onDevice helper (Nano 4 preview, then stable), but only if
    // that helper builds every model with the mode it was given and never names another mode.
    const helper = kt.match(/private suspend fun onDevice\([\s\S]*?\r?\n    }\r?\n/)?.[0] ?? "";
    const helperForwards = helper !== "" && !/InferenceMode\.(PREFER_ON_DEVICE|ONLY_IN_CLOUD|PREFER_IN_CLOUD)/.test(helper)
      && (helper.match(/model\(/g) ?? []).length === (helper.match(/model\(mode,/g) ?? []).length;
    const onPhone = /model\(InferenceMode\.ONLY_ON_DEVICE/.test(imageCall) || (helperForwards && /onDevice\(InferenceMode\.ONLY_ON_DEVICE/.test(imageCall));
    const imageOk = /generateContent\(request\)/.test(imageCall) && onPhone && !/PREFER_ON_DEVICE|ONLY_IN_CLOUD|PREFER_IN_CLOUD/.test(imageCall);
    const requestCalls = (kt.match(/generateContent\(request\)/g) ?? []).length;
    if (requestCalls > 0 && (!imageOk || requestCalls !== 1)) {
      fail(rel, "a document picture may be sent only by privateImage, ONLY_ON_DEVICE (ADR-087)");
    }
    for (const m of kt.matchAll(/generateContent\(([^)]*)\)/g)) {
      if (!["prompt", "CLOUD_CHECK_PROMPT", ...(imageOk ? ["request"] : [])].includes(m[1].trim())) {
        fail(rel, `a model call sends "${m[1].trim()}"; only the prompt from Dart or CLOUD_CHECK_PROMPT may be sent (ADR-079, ADR-085)`);
      }
    }
    const cloudOnly = (kt.match(/InferenceMode\.ONLY_IN_CLOUD/g) ?? []).length;
    const checks = (kt.match(/generateContent\(CLOUD_CHECK_PROMPT\)/g) ?? []).length;
    if (cloudOnly > checks) {
      fail(rel, "runs ONLY_IN_CLOUD for something other than the fixed Cloud boost check (ADR-085)");
    }
    if (/CLOUD_CHECK_PROMPT\s*=/.test(kt) && !/const val CLOUD_CHECK_PROMPT = "Reply with the single word OK\."/.test(kt)) {
      fail(rel, "the Cloud boost check sentence changed; it must stay the fixed sentence with nothing about her (ADR-085)");
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
  if (!/runHybrid\(CloudPrompt /.test(readFileSync(ASSISTANT_CHANNEL_DART, "utf8"))) {
    fail(ASSISTANT_CHANNEL_DART, "the cloud-capable call no longer requires a CloudPrompt (ADR-079)");
  }
  const CLOUD_PROMPT = "apps/mobile/lib/domain/assistant/cloud_prompt.dart";
  const cp = readFileSync(CLOUD_PROMPT, "utf8");
  const factories = [...cp.matchAll(/factory CloudPrompt\.(\w+)\(([^,)]+)/g)].map((m) => `${m[1]}(${m[2].trim().split(/\s+/)[0]}`);
  const allowed = new Set(["answer(CloudSafeText", "tips(PseudonymisedProfile"]);
  if (factories.length !== 2 || factories.some((f) => !allowed.has(f))) {
    fail(CLOUD_PROMPT, `CloudPrompt may be built only from CloudSafeText or PseudonymisedProfile; found ${factories.join(", ") || "none"} (ADR-079)`);
  }
  if (/CloudPrompt\s*\(|const CloudPrompt\.(?!_\()/.test(cp.replace(/const CloudPrompt\._\(/, ""))) {
    fail(CLOUD_PROMPT, "CloudPrompt has a public constructor (ADR-079)");
  }
  for (const file of walk(APP_LIB).filter((f) => f.endsWith(".dart"))) {
    const rel = relative(process.cwd(), file).replace(/\\/g, "/");
    if (rel !== CLOUD_PROMPT && /CloudPrompt\._\(/.test(readFileSync(file, "utf8"))) {
      fail(rel, "builds a CloudPrompt outside cloud_prompt.dart (ADR-079)");
    }
  }
  // The companion boundary (ADR-081): one gateway calls the model; the on-phone call takes
  // only a PrivatePrompt; only the prompt files call the prompt builders.
  const GATEWAY = "apps/mobile/lib/data/assistant_gateway.dart";
  const PRIVATE_PROMPT = "apps/mobile/lib/domain/assistant/private_prompt.dart";
  const PROMPT_FILES = new Set([
    "apps/mobile/lib/domain/assistant/prompts.dart", PRIVATE_PROMPT, CLOUD_PROMPT,
  ]);
  if (!/runPrivate\(PrivatePrompt /.test(readFileSync(ASSISTANT_CHANNEL_DART, "utf8"))) {
    fail(ASSISTANT_CHANNEL_DART, "the on-phone call no longer requires a PrivatePrompt (ADR-081)");
  }
  for (const file of walk(APP_LIB).filter((f) => f.endsWith(".dart"))) {
    const rel = relative(process.cwd(), file).replace(/\\/g, "/");
    const src = readFileSync(file, "utf8");
    if (rel !== GATEWAY && /\.run(Private|Hybrid)\(/.test(src)) {
      fail(rel, "calls the model directly; only lib/data/assistant_gateway.dart may (ADR-081)");
    }
    if (rel !== PRIVATE_PROMPT && /PrivatePrompt\._\(/.test(src)) {
      fail(rel, "builds a PrivatePrompt outside private_prompt.dart (ADR-081)");
    }
    if (!PROMPT_FILES.has(rel) && /\b(answerPrompt|extractionPrompt|tipsPrompt|visitQuestionsPrompt)\(/.test(src)) {
      fail(rel, "builds a model prompt in a screen; prompts are made only by PrivatePrompt or CloudPrompt (ADR-081)");
    }
  }
} catch (error) {
  fail(ASSISTANT_CHANNEL_DART, `cannot read: ${error.message}`);
}

// 4. Source manifest: INTERNET is declared here only for Firebase AI Logic (ADR-079); the ad-ID
// and ad-services permissions must be explicitly removed; nothing may read the person.
const MANIFEST = "apps/mobile/android/app/src/main/AndroidManifest.xml";
const AD_PERMISSIONS = [
  "com.google.android.gms.permission.AD_ID", "android.permission.ACCESS_ADSERVICES_AD_ID",
  "android.permission.ACCESS_ADSERVICES_TOPICS", "android.permission.ACCESS_ADSERVICES_ATTRIBUTION",
];
const PERSONAL_PERMISSIONS = [
  /ACCESS_FINE_LOCATION/, /ACCESS_COARSE_LOCATION/, /ACCESS_BACKGROUND_LOCATION/, /READ_PHONE_STATE/, /READ_CONTACTS/,
  /CAMERA/, /RECORD_AUDIO/, /READ_SMS/, /READ_CALL_LOG/, /GET_ACCOUNTS/, /BLUETOOTH_SCAN/, /ACTIVITY_RECOGNITION/,
  // Documents (R11.2, ADR-082 §2) arrive only through the system picker and camera intent.
  /READ_EXTERNAL_STORAGE/, /WRITE_EXTERNAL_STORAGE/, /MANAGE_EXTERNAL_STORAGE/, /READ_MEDIA_/,
];

// RECORD_AUDIO has one allowed use: the mic on Ask femio and Say it, where Android's on-device
// recognizer turns speech into text on the phone (ADR-086). It is allowed only while all of
// this holds; otherwise it counts as a personal permission like the rest.
const SPEECH_DIR = "apps/mobile/android/app/src/main/kotlin/com/femioapp/femio/speech";
const ANDROID_SRC = "apps/mobile/android/app/src/main";
function speechProblems() {
  const problems = [];
  const speechFile = join(SPEECH_DIR, "SpeechChannel.kt");
  if (!existsSync(speechFile)) return ["the speech package is missing"];
  const speech = readFileSync(speechFile, "utf8");
  if (!/SpeechRecognizer\.createOnDeviceSpeechRecognizer\(/.test(speech)) problems.push("the speech package does not use the on-device recognizer");
  const native = [];
  (function walkNative(dir) {
    for (const entry of readdirSync(dir)) {
      const full = join(dir, entry);
      if (statSync(full).isDirectory()) walkNative(full);
      else if (/\.(kt|java)$/.test(entry)) native.push(full);
    }
  })(ANDROID_SRC);
  for (const file of native) {
    const code = readFileSync(file, "utf8").replace(/\/\/.*$/gm, "");
    const path = relative(".", file).replaceAll("\\", "/");
    if (/createSpeechRecognizer\(|ACTION_RECOGNIZE_SPEECH[^\n]*startActivity|RecognizerIntent\.ACTION_WEB_SEARCH/.test(code)) {
      problems.push(`${path} can use a recognizer that may send audio to a server`);
    }
    if (/\bAudioRecord\b|\bMediaRecorder\b/.test(code)) problems.push(`${path} records audio`);
    if (/RECORD_AUDIO/.test(code) && !path.startsWith(SPEECH_DIR)) problems.push(`${path} uses the microphone outside the speech package`);
    // Gemini Nano speech (ADR-088): only in the speech package, only from the live
    // microphone, and never a download started from femio's code.
    if (/com\.google\.mlkit\.genai\.speechrecognition/.test(code)) {
      if (!path.startsWith(SPEECH_DIR)) problems.push(`${path} uses Gemini Nano speech outside the speech package`);
      if (/AudioSource\.from(File|Uri|Pfd)\(/.test(code)) problems.push(`${path} transcribes audio other than the live microphone`);
      if (/\.download\(/.test(code)) problems.push(`${path} starts a speech model download`);
    }
  }
  return problems;
}
const speechIssues = speechProblems();
for (const issue of speechIssues) {
  if (existsSync(MANIFEST) && /RECORD_AUDIO/.test(readFileSync(MANIFEST, "utf8"))) {
    fail(MANIFEST, `RECORD_AUDIO is allowed only for on-device speech to text (ADR-086): ${issue}`);
  }
}
// On-device translation (ADR-087 §6): ML Kit Translate lives only in the translate package,
// and a language file downloads only from its "download" method, which Dart calls on her tap.
const TRANSLATE_DIR = "apps/mobile/android/app/src/main/kotlin/com/femioapp/femio/translate";
(function translateChecks() {
  (function walk(dir) {
    for (const entry of readdirSync(dir)) {
      const full = join(dir, entry);
      if (statSync(full).isDirectory()) { walk(full); continue; }
      if (!/\.(kt|java)$/.test(entry)) continue;
      const path = relative(".", full).replaceAll("\\", "/");
      const code = readFileSync(full, "utf8").replace(/\/\/.*$/gm, "");
      if (/com\.google\.mlkit\.nl\.translate/.test(code) && !path.startsWith(TRANSLATE_DIR)) {
        fail(path, "ML Kit translation is allowed only in the translate package (ADR-087)");
      }
      if (path.startsWith(TRANSLATE_DIR) && (code.match(/RemoteModelManager\.getInstance\(\)\.download\(/g) ?? []).length > 1) {
        fail(path, "the language file may be downloaded from one place only, the download method (ADR-087)");
      }
    }
  })(ANDROID_SRC);
  const dart = "apps/mobile/lib";
  (function walkDart(dir) {
    for (const entry of readdirSync(dir)) {
      const full = join(dir, entry);
      if (statSync(full).isDirectory()) { walkDart(full); continue; }
      if (!entry.endsWith(".dart")) continue;
      const path = relative(".", full).replaceAll("\\", "/");
      const code = readFileSync(full, "utf8");
      if (/\.download\(\s*_lang\s*\)|translator\??\.download\(/.test(code) && !path.endsWith("features/assistant/translation_tile.dart")) {
        fail(path, "only the Assistant settings row may download a language file, on her tap (ADR-087)");
      }
    }
  })(dart);
})();
const REVIEWED_PERSONAL = speechIssues.length === 0 ? PERSONAL_PERMISSIONS.filter((re) => re.source !== "RECORD_AUDIO") : PERSONAL_PERMISSIONS;
try {
  const manifest = readFileSync(MANIFEST, "utf8");
  const requested = manifest.split("\n").filter((line) => !/tools:node="remove"/.test(line)).join("\n");
  for (const id of AD_PERMISSIONS) {
    if (!new RegExp(`${id}"[^>]*tools:node="remove"`).test(manifest)) {
      fail(MANIFEST, `does not remove ${id} with tools:node="remove"; the app has no ads`);
    }
  }
  for (const re of REVIEWED_PERSONAL) {
    if (re.test(requested)) fail(MANIFEST, `requests a permission that reads the person (${re.source})`);
  }
} catch (error) {
  fail(MANIFEST, `cannot read: ${error.message}`);
}

// 4b. Android native code, Gradle and the merged manifests (R14.14, PRIV-11, SEC-16): no
// network code outside the assistant package, only reviewed Gradle dependencies and plugins,
// and, when a current build exists, no ad-ID or personal permission, no ad or analytics
// metadata and only reviewed components in what the libraries add. INTERNET is expected:
// Firebase AI Logic, ADR-079. Details and how to run the merged-manifest part:
// scripts/lib/android-tripwire.mjs and docs/runbooks/TOOLS.md.
const warnings = [];
const mergedChecked = checkAndroid({
  fail,
  warn: (message) => warnings.push(message),
  requireMerged: process.env.FEMIO_REQUIRE_MERGED_MANIFEST === "1" || process.argv.includes("--require-merged-manifest"),
  adPermissions: AD_PERMISSIONS,
  personalPermissions: REVIEWED_PERSONAL,
});
for (const w of warnings) console.warn(`  ⚠ ${w}`);

if (findings.length > 0) {
  console.error("privacy tripwire FAILED:\n");
  for (const f of findings) console.error(`  ✗ ${f}`);
  console.error(`\n${findings.length} finding(s). See docs/33_REBUILD_V3/03_LEGAL_PACK.md.`);
  process.exit(1);
}
console.log(`✓ privacy tripwire: no analytics, error-reporting or database client in either product; website: no Tag Manager, GA4 or Meta pixel, Vercel Web Analytics (cookieless, path only) the only measurement, AdSense host inside lib/ads only, ad units only in the article and hub; app: no ads, analytics or attribution package and no ad-ID permission (source and merged manifest), no network code of its own, Firebase AI Logic only inside the Kotlin assistant behind CloudPrompt (CloudSafeText or PseudonymisedProfile only) plus one fixed check sentence, no search grounding, no personal permission except the microphone for on-device speech to text (ADR-086); native: no network code outside the assistant package, only reviewed Gradle dependencies and plugins, merged manifest ${mergedChecked > 0 ? `checked (${mergedChecked} file(s): permissions, ad/analytics metadata, reviewed components)` : "not checked (no current build)"}.`);
