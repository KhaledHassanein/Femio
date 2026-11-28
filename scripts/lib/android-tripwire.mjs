/**
 * The Android half of the privacy tripwire (R14.14, PRIV-11, SEC-16; ADR-083).
 *
 * Why it exists: the Dart checks in scripts/analytics-lint.mjs stop the app's Dart code from
 * opening a connection, but INTERNET is declared for Firebase AI Logic, so native code and
 * native libraries could talk to the network without any Dart line changing. This module
 * closes the three gaps the 2026-11-26 audit found:
 *
 *   A. network code in Kotlin or Java anywhere under apps/mobile/android, except the
 *      assistant package (the Firebase AI Logic bridge, ADR-078/079);
 *   B. Gradle: every dependency the app module declares must be on an allow-list, every
 *      plugin too, and no analytics, ads, attribution or crash-reporting coordinate may
 *      appear in any Gradle file;
 *   C. the merged manifest(s) Gradle wrote, when they exist and are newer than the sources:
 *      no ad-ID or personal permission, no ad or analytics metadata, and every component
 *      (each can use the INTERNET permission) on a reviewed allow-list.
 *
 * C needs a build. Locally it runs whenever `apps/mobile/build/app/intermediates` holds a
 * merged manifest newer than the source manifest and Gradle files; a stale one is skipped
 * with a warning. Set FEMIO_REQUIRE_MERGED_MANIFEST=1 (or pass --require-merged-manifest)
 * in a release job to make a missing or stale merged manifest a failure.
 * How to run it: docs/runbooks/TOOLS.md, "Privacy tripwire".
 */
import { existsSync, readFileSync, readdirSync, statSync } from "node:fs";
import { join, relative } from "node:path";

const ANDROID_ROOT = "apps/mobile/android";
const SKIP_DIRS = new Set(["build", ".gradle", ".cxx", ".kotlin", "captures", "intermediates", "generated"]);

const rel = (file) => relative(process.cwd(), file).replace(/\\/g, "/");

function walk(dir, keep, out = []) {
  if (!existsSync(dir)) return out;
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry);
    if (statSync(full).isDirectory()) {
      if (!SKIP_DIRS.has(entry)) walk(full, keep, out);
    } else if (keep(entry)) out.push(full);
  }
  return out;
}

/** Removes // and block comments so a comment that names a class is not a finding. */
function stripComments(source) {
  return source.replace(/\/\*[\s\S]*?\*\//g, "").replace(/(^|[^:])\/\/.*$/gm, "$1");
}

// ---- A. Native network code ---------------------------------------------------------------

/** The Firebase AI Logic bridge: the only native code allowed to reach the network (via the SDK). */
const NETWORK_ALLOWED_IN = /\/kotlin\/com\/femioapp\/femio\/assistant\//;
const NATIVE_NETWORK = [
  [/\bimport\s+java\.net\./, "java.net"],
  [/\bimport\s+javax\.net\./, "javax.net"],
  [/\bHttps?URLConnection\b/, "HttpURLConnection"],
  [/\.openConnection\s*\(/, "URL.openConnection"],
  [/\.openStream\s*\(/, "URL.openStream"],
  [/\bokhttp3\b|\bcom\.squareup\.okhttp\b/, "OkHttp"],
  [/\bio\.ktor\b/, "Ktor"],
  [/\bretrofit2\b/, "Retrofit"],
  [/\bcom\.android\.volley\b/, "Volley"],
  [/\borg\.chromium\.net\b|\bCronetEngine\b/, "Cronet"],
  [/\bio\.grpc\b/, "gRPC"],
  [/\b(Datagram|Server|SSL)?Socket\s*\(/, "a socket"],
  [/\b(Asynchronous)?SocketChannel\b/, "a socket channel"],
  [/\bandroid\.webkit\b|\bWebView\b/, "a WebView"],
  [/\bDownloadManager\b/, "DownloadManager"],
  [/\bandroid\.net\.http\b/, "android.net.http"],
];

function checkNativeNetwork(fail) {
  const files = walk(ANDROID_ROOT, (name) => name.endsWith(".kt") || name.endsWith(".java"));
  if (files.length === 0) fail(ANDROID_ROOT, "no Kotlin or Java source found; refusing to pass on nothing");
  for (const file of files) {
    const path = rel(file);
    if (NETWORK_ALLOWED_IN.test(path)) continue;
    const code = stripComments(readFileSync(file, "utf8"));
    for (const [re, what] of NATIVE_NETWORK) {
      if (re.test(code)) {
        fail(path, `native code can reach the network (${what}); only the assistant package (Firebase AI Logic, ADR-079) may`);
      }
    }
  }
}

// ---- B. Gradle dependencies and plugins ---------------------------------------------------

/**
 * Every library the app module may declare, with why. Adding one is a privacy decision:
 * an ADR line and a check that it opens no connection, never only an edit here.
 */
const ALLOWED_GRADLE_DEPENDENCIES = new Map([
  ["com.android.tools:desugar_jdk_libs", "java.time for reminders on old Android (R4.4); build-time only"],
  ["com.google.firebase:firebase-ai", "the assistant's Cloud boost, only behind a CloudPrompt (ADR-079)"],
  ["com.google.firebase:firebase-ai-ondevice", "Gemini Nano on the phone (ADR-078)"],
  ["com.google.firebase:firebase-appcheck-debug", "App Check debug provider, debug builds only"],
  ["com.google.firebase:firebase-appcheck-playintegrity", "App Check for the assistant's cloud calls"],
  ["androidx.core:core", "FileProvider for a document she chooses to share (R11.2)"],
  ["com.google.mlkit:translate", "on-device translation for the AI on this phone; the language file downloads on her tap (ADR-087 §6)"],
]);

/** Gradle plugins the build may apply. */
const ALLOWED_GRADLE_PLUGINS = new Set([
  "com.android.application", "dev.flutter.flutter-gradle-plugin", "dev.flutter.flutter-plugin-loader",
  "org.jetbrains.kotlin.android", "kotlin-android",
]);

/** Analytics, ads, attribution and crash-reporting SDKs, by Maven coordinate or plugin id. */
const TRACKING_GRADLE = [
  /com\.google\.android\.gms:play-services-(ads|ads-lite|ads-identifier|analytics|measurement[\w-]*|appset)\b/,
  /com\.google\.firebase:firebase-(analytics|crashlytics|perf|messaging|inappmessaging|dynamic-links|config|installations)\b/,
  /com\.google\.gms\.google-services|com\.google\.firebase\.crashlytics|com\.google\.firebase\.firebase-perf/,
  /com\.google\.android\.ump\b/, /com\.google\.ads\b/, /com\.google\.android\.gms\.ads\b/,
  /\bio\.sentry\b/, /\bcom\.bugsnag\b/, /\bcom\.facebook\./, /\bcom\.appsflyer\b/, /\bcom\.adjust\./,
  /\bio\.branch\./, /\bcom\.onesignal\b/, /\bcom\.mixpanel\b/, /\bcom\.amplitude\b/, /\bcom\.segment\.analytics\b/,
  /\bcom\.applovin\b/, /\bcom\.unity3d\.ads\b/, /\bcom\.ironsource\b/, /\bcom\.flurry\b/, /\bcom\.microsoft\.appcenter\b/,
  /\bcom\.instabug\b/, /\bcom\.newrelic\b/, /\bcom\.datadoghq\b/, /\bcom\.braze\b/, /\bcom\.clevertap\b/,
  /\bcom\.heapanalytics\b/, /\bcom\.smartlook\b/, /\bcom\.uxcam\b/,
];

const DEPENDENCY_LINE = /^\s*(implementation|api|compileOnly|runtimeOnly|debugImplementation|releaseImplementation|profileImplementation|debugApi|releaseApi|coreLibraryDesugaring|kapt|ksp|annotationProcessor|testImplementation|androidTestImplementation|debugRuntimeOnly|releaseRuntimeOnly)\b\s*\(/;
const TEST_ONLY = /^\s*(testImplementation|androidTestImplementation)\b/;

function checkGradle(fail) {
  const files = walk(ANDROID_ROOT, (name) => name.endsWith(".gradle.kts") || name.endsWith(".gradle"));
  if (files.length === 0) fail(ANDROID_ROOT, "no Gradle file found; refusing to pass on nothing");
  for (const file of files) {
    const path = rel(file);
    const lines = stripComments(readFileSync(file, "utf8")).split("\n");
    for (const raw of lines) {
      const line = raw.trim();
      if (!line) continue;
      for (const re of TRACKING_GRADLE) {
        if (re.test(line)) fail(path, `pulls an analytics, ads, attribution or crash-reporting SDK (${re.source}): ${line}`);
      }
      const plugin = line.match(/^id\s*\(\s*"([^"]+)"\s*\)/)?.[1] ?? line.match(/^apply\s*\(\s*plugin\s*=\s*"([^"]+)"/)?.[1];
      if (plugin && !ALLOWED_GRADLE_PLUGINS.has(plugin)) {
        fail(path, `applies Gradle plugin "${plugin}", which is not on the reviewed list (scripts/lib/android-tripwire.mjs)`);
      }
      if (!DEPENDENCY_LINE.test(raw)) continue;
      const coordinates = [...line.matchAll(/"([\w.-]+):([\w.-]+)(?::[^"]*)?"/g)].map((m) => `${m[1]}:${m[2]}`);
      if (coordinates.length === 0) {
        fail(path, `declares a dependency in a form the tripwire cannot read (use a literal "group:artifact:version"): ${line}`);
        continue;
      }
      if (TEST_ONLY.test(raw)) continue; // Never packaged into the app; the deny-list above still applies.
      for (const coordinate of coordinates) {
        if (!ALLOWED_GRADLE_DEPENDENCIES.has(coordinate)) {
          fail(path, `declares "${coordinate}", which is not on the reviewed dependency list (scripts/lib/android-tripwire.mjs); a new native library needs an ADR line first`);
        }
      }
    }
  }
}

// ---- C. Merged manifests ------------------------------------------------------------------

const MERGED_ROOT = "apps/mobile/build/app/intermediates";
const MERGED_DIRS = ["merged_manifest", "merged_manifests"];
/** Files that, when newer than a merged manifest, make it stale. */
const MERGE_INPUTS = [
  "apps/mobile/android/app/src/main/AndroidManifest.xml",
  "apps/mobile/android/app/build.gradle.kts",
  "apps/mobile/pubspec.lock",
];

/**
 * Component class-name prefixes a merged manifest may carry, with why. Every component can
 * use the INTERNET permission the app declares, so a new one is reviewed before it ships.
 */
const ALLOWED_COMPONENTS = [
  ["com.femioapp.femio.", "femio's own activity and widget"],
  ["io.flutter.embedding.", "the Flutter engine"],
  ["io.flutter.plugins.imagepicker.", "the camera intent's file provider (R11.2), local"],
  ["com.google.android.gms.metadata.ModuleDependencies", "a disabled, unexported declaration that asks Play services for the photo-picker module (image_picker)"],
  ["com.dexterous.flutterlocalnotifications.", "reminders scheduled on the phone (R4.4)"],
  ["androidx.core.content.FileProvider", "her chosen document to the share sheet (R11.2)"],
  ["androidx.startup.InitializationProvider", "AndroidX start-up, local"],
  ["androidx.profileinstaller.ProfileInstallReceiver", "ART start-up profile, local"],
  ["androidx.work.impl.", "WorkManager, a local job scheduler used by Google libraries"],
  ["androidx.room.MultiInstanceInvalidationService", "WorkManager's local database"],
  ["com.google.firebase.components.ComponentDiscoveryService", "Firebase AI Logic for the assistant (ADR-079)"],
  ["com.google.firebase.provider.FirebaseInitProvider", "Firebase AI Logic for the assistant (ADR-079)"],
  ["com.google.android.gms.common.api.GoogleApiActivity", "Play services error dialogs"],
  ["com.google.android.play.core.", "in-app review and update (Play)"],
  ["com.android.billingclient.api.", "Google Play Billing (femio Plus)"],
  ["com.mr.flutter.plugin.filepicker.", "the system file picker"],
  ["com.it_nomads.fluttersecurestorage.", "the Keystore vault"],
  ["com.google.mlkit.common.internal.", "ML Kit start-up for on-device Gemini Nano (ADR-078)"],
];

/**
 * Present today but not yet cleared: reported as a warning, not a failure, until the device
 * traffic capture (audit row 33, SEC-5) shows whether they send anything before consent.
 */
const UNDER_REVIEW_COMPONENTS = [
  ["com.google.android.datatransport.", "Google's telemetry transport, used by ML Kit and Firebase; settled by the traffic capture (SEC-5, row 33)"],
  ["io.flutter.plugins.urllauncher.WebViewActivity", "an in-app browser from url_launcher, pulled in by in_app_review's platform interface; femio's Dart never calls url_launcher (sources open in her browser through the assistant bridge). Drop the dependency or accept it with an ADR line"],
];

/** Merged-manifest copies Gradle writes for other tasks; checking the processing outputs is enough. */
const MERGED_FILE_ALLOWED = /\/process\w*Manifest\/AndroidManifest\.xml$/;

/** Metadata names that switch on ads, analytics or crash reporting. */
const TRACKING_METADATA = /com\.google\.android\.gms\.ads|google_analytics|firebase_analytics|firebase_crashlytics|firebase_performance|com\.facebook\.sdk|io\.sentry|appsflyer|com\.adjust|onesignal|com\.google\.android\.gms\.measurement|app_measurement/i;

function findMergedManifests() {
  const out = [];
  for (const dir of MERGED_DIRS) {
    // Started inside intermediates/, which walk() would otherwise skip by name.
    walk(join(MERGED_ROOT, dir), (name) => name === "AndroidManifest.xml", out);
  }
  return out.filter((file) => MERGED_FILE_ALLOWED.test(rel(file)));
}

function newestInput() {
  return Math.max(...MERGE_INPUTS.filter((f) => existsSync(f)).map((f) => statSync(f).mtimeMs));
}

/**
 * True when [merged] contains every component and permission the source manifest declares.
 * Gradle skips an up-to-date merge, so an input file touched without a real change leaves an
 * older merged manifest that is still current; one missing a source entry is not.
 */
function matchesSource(merged) {
  const source = readFileSync(MERGE_INPUTS[0], "utf8").replace(/<!--[\s\S]*?-->/g, "");
  for (const m of source.matchAll(/<(activity|service|receiver|provider|uses-permission)\b([^>]*)>/g)) {
    if (/tools:node="remove"/.test(m[2])) continue;
    const name = m[2].match(/android:name="([^"]+)"/)?.[1];
    if (!name) continue;
    const full = name.startsWith(".") ? `com.femioapp.femio${name}` : name;
    if (!merged.includes(`"${full}"`) && !merged.includes(`"${name}"`)) return false;
  }
  return true;
}

function checkMergedManifests(fail, warn, { requireMerged, adPermissions, personalPermissions }) {
  const manifests = existsSync(MERGED_ROOT) ? findMergedManifests() : [];
  const inputs = newestInput();
  const fresh = [];
  for (const m of manifests) {
    if (statSync(m).mtimeMs >= inputs) fresh.push(m);
    else if (matchesSource(readFileSync(m, "utf8"))) {
      fresh.push(m);
      warn(`${rel(m)}: older than its inputs but carries every source entry (Gradle kept an up-to-date merge); checked`);
    } else {
      warn(`${rel(m)}: stale (older than the manifest, build.gradle.kts or pubspec.lock and missing source entries); skipped, rebuild to check it`);
    }
  }
  if (fresh.length === 0) {
    const message = "no current merged manifest: build once (flutter build apk --debug) so the tripwire can check what the libraries add";
    if (requireMerged) fail(MERGED_ROOT, message);
    else warn(message);
    return 0;
  }
  for (const file of fresh) {
    const path = rel(file);
    const xml = readFileSync(file, "utf8");
    const pkg = xml.match(/<manifest[^>]*\bpackage="([^"]+)"/)?.[1] ?? "com.femioapp.femio";
    for (const id of adPermissions) {
      if (new RegExp(`uses-permission[^>]*android:name="${id.replace(/\./g, "\\.")}"`).test(xml)) {
        fail(path, `the MERGED manifest requests ${id}; a library added it (the app has no ads)`);
      }
    }
    for (const re of personalPermissions) {
      for (const m of xml.matchAll(/<uses-permission[^>]*android:name="([^"]+)"/g)) {
        if (re.test(m[1])) fail(path, `the MERGED manifest requests ${m[1]}, which reads the person; a library added it`);
      }
    }
    for (const m of xml.matchAll(/<meta-data[^>]*android:name="([^"]+)"/g)) {
      if (TRACKING_METADATA.test(m[1])) fail(path, `the MERGED manifest carries ad or analytics metadata "${m[1]}"`);
    }
    for (const m of xml.matchAll(/<(activity|activity-alias|service|receiver|provider)\b[^>]*?android:name="([^"]+)"/g)) {
      const name = m[2].startsWith(".") ? pkg + m[2] : m[2];
      if (ALLOWED_COMPONENTS.some(([prefix]) => name.startsWith(prefix))) continue;
      const review = UNDER_REVIEW_COMPONENTS.find(([prefix]) => name.startsWith(prefix));
      if (review) {
        warn(`${path}: ${m[1]} ${name} is under review: ${review[1]}`);
        continue;
      }
      fail(path, `the MERGED manifest adds ${m[1]} ${name}, which is not on the reviewed component list; it could use INTERNET. Check what it sends, then list it in scripts/lib/android-tripwire.mjs with the reason`);
    }
  }
  return fresh.length;
}

/**
 * Runs checks A, B and C. [fail] records a finding that fails the gate; [warn] prints one
 * that does not. Returns the number of merged manifests checked (0 when none was current).
 */
export function checkAndroid({ fail, warn, requireMerged = false, adPermissions, personalPermissions }) {
  try {
    checkNativeNetwork(fail);
  } catch (error) {
    fail(ANDROID_ROOT, `cannot scan native source: ${error.message}`);
  }
  try {
    checkGradle(fail);
  } catch (error) {
    fail(ANDROID_ROOT, `cannot read Gradle files: ${error.message}`);
  }
  try {
    return checkMergedManifests(fail, warn, { requireMerged, adPermissions, personalPermissions });
  } catch (error) {
    fail(MERGED_ROOT, `cannot read merged manifests: ${error.message}`);
    return 0;
  }
}
