// Release smoke test: installs the signed release APK on a running emulator or phone,
// starts it from a clean install, and fails if Android reports a crash or the process
// is gone, or if Flutter never draws its first frame.
//
// Why it exists: release builds run R8 (code shrinking); debug builds and `flutter test`
// never do. On 2026-11-01 the 0.5.0+5 release build died at launch because R8 removed a
// class Google's ads SDK creates by name (WorkDatabase_Impl), and nothing before the
// owner's phone noticed. Run this after every `flutter build apk --release`, before the
// APK or bundle reaches anyone: `pnpm mobile-release-smoke` with an emulator booted.
//
// Inputs: optional path to the APK (default: the Flutter release output). Needs adb from
// the Android SDK (ANDROID_HOME, ANDROID_SDK_ROOT or %LOCALAPPDATA%\Android\Sdk).
// Output: exit 0 with the time to first frame, or exit 1 with the crash lines.
// It uninstalls com.femioapp.femio first: use it on an emulator or a test phone only,
// never on a phone that holds real records.

import { execFileSync } from "node:child_process";
import { existsSync } from "node:fs";
import { join } from "node:path";

const PACKAGE = "com.femioapp.femio";
const ACTIVITY = `${PACKAGE}/.MainActivity`;
/** Seconds to wait for the first frame on a cold start (emulators are slow). */
const FIRST_FRAME_TIMEOUT_S = 45;
const DEFAULT_APK = "apps/mobile/build/app/outputs/flutter-apk/app-release.apk";

/** Finds adb in the usual Android SDK locations; throws when there is none. */
function findAdb() {
  const roots = [process.env.ANDROID_HOME, process.env.ANDROID_SDK_ROOT,
    process.env.LOCALAPPDATA && join(process.env.LOCALAPPDATA, "Android", "Sdk")].filter(Boolean);
  for (const root of roots) {
    for (const name of ["adb.exe", "adb"]) {
      const p = join(root, "platform-tools", name);
      if (existsSync(p)) return p;
    }
  }
  throw new Error("adb not found: set ANDROID_HOME or install the Android SDK platform-tools");
}

const adb = findAdb();
/** Runs adb and returns its stdout as text; `ok` lists exit codes treated as success. */
const run = (args, { ok = [0] } = {}) => {
  try {
    return execFileSync(adb, args, { encoding: "utf8", stdio: ["ignore", "pipe", "pipe"] });
  } catch (e) {
    if (ok.includes(e.status)) return e.stdout ?? "";
    throw e;
  }
};
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

const apk = process.argv[2] ?? DEFAULT_APK;
if (!existsSync(apk)) {
  console.error(`✗ No APK at ${apk}. Build it first: cd apps/mobile && flutter build apk --release`);
  process.exit(1);
}
const devices = run(["devices"]).split("\n").slice(1).filter((l) => /\tdevice\s*$/.test(l));
if (devices.length === 0) {
  console.error("✗ No emulator or phone attached (adb devices is empty). Boot an emulator first.");
  process.exit(1);
}

run(["uninstall", PACKAGE], { ok: [0, 1, 255] }); // absent is fine
const install = run(["install", apk]);
if (!/Success/.test(install)) {
  console.error(`✗ Install failed:\n${install}`);
  process.exit(1);
}
run(["logcat", "-c"]);
run(["shell", "am", "start", "-W", "-n", ACTIVITY]);

let drawn = null;
let crash = "";
for (let s = 0; s < FIRST_FRAME_TIMEOUT_S; s += 3) {
  await sleep(3000);
  const log = run(["logcat", "-d", "-b", "main,system,crash"]);
  const fatal = log.split("\n").filter((l) =>
    /FATAL EXCEPTION|AndroidRuntime: (Process|java\.|Caused by)|Abort message|E flutter|Unhandled Exception/.test(l) &&
    (l.includes(PACKAGE) || /AndroidRuntime|flutter/.test(l)));
  if (fatal.length) { crash = fatal.slice(0, 25).join("\n"); break; }
  const m = log.match(new RegExp(`Displayed ${PACKAGE.replace(/\./g, "\\.")}/\\.MainActivity[^+]*\\+([0-9a-z]+)`));
  if (m) { drawn = m[1]; break; }
}
const alive = run(["shell", "pidof", PACKAGE], { ok: [0, 1] }).trim() !== "";

if (crash || !alive || !drawn) {
  console.error(`✗ Release smoke test FAILED (${apk})`);
  if (crash) console.error(crash);
  if (!alive) console.error("The app process is not running.");
  if (!drawn) console.error(`No first frame within ${FIRST_FRAME_TIMEOUT_S} s.`);
  process.exit(1);
}
console.log(`✓ Release smoke test: ${apk} installed clean, first frame after ${drawn}, process alive, no crash.`);
