// Release smoke test: installs the R8-minified release APK on an Android emulator, starts it
// from a clean install, and fails if Android reports a crash, the process is gone, or Flutter
// never draws its first frame.
//
// Why it exists: release builds run R8 (code shrinking); debug builds and `flutter test` never
// do, so a class R8 strips only shows up on a phone. On 2026-11-01 the 0.5.0+5 release died at
// launch that way (WorkDatabase_Impl, pulled in by an ads SDK since removed) and nothing before
// the owner's phone noticed. This is the only check that runs the minified build. Ported
// 2026-11-27 from commit 0475223 (R14.15), now emulator-only and optional:
//   - an emulator already attached: it runs there;
//   - none attached but an AVD exists: it boots the first AVD headless, runs, and shuts it down;
//   - no AVD, no adb or no release APK: it prints "not verified" and exits 0.
// It is deliberately NOT in `pnpm gate` (it needs a release build and minutes of emulator time).
//
// Usage: `pnpm mobile-release-smoke [path/to/app-release.apk]`
// Output: exit 0 with the time to first frame, or with "not verified"; exit 1 with the crash.
// It uninstalls com.femioapp.femio first, so it refuses a physical phone (which may hold her
// real records) unless `--allow-phone` is passed.

import { execFileSync, spawn } from "node:child_process";
import { existsSync } from "node:fs";
import { join } from "node:path";

const PACKAGE = "com.femioapp.femio";
const ACTIVITY = `${PACKAGE}/.MainActivity`;
/** Seconds to wait for the first frame on a cold start (emulators are slow). */
const FIRST_FRAME_TIMEOUT_S = 60;
/** Seconds to wait for a headless AVD to finish booting. */
const BOOT_TIMEOUT_S = 240;
const DEFAULT_APK = "apps/mobile/build/app/outputs/flutter-apk/app-release.apk";

const args = process.argv.slice(2);
const allowPhone = args.includes("--allow-phone");
const apk = args.find((a) => !a.startsWith("--")) ?? DEFAULT_APK;

/** Prints why the check could not run and exits 0: an unverified check is not a failure. */
function notVerified(reason) {
  console.log(`- Release smoke test not verified: ${reason}`);
  process.exit(0);
}

/** Returns the Android SDK root, or null when none is installed. */
function sdkRoot() {
  const roots = [process.env.ANDROID_HOME, process.env.ANDROID_SDK_ROOT,
    process.env.LOCALAPPDATA && join(process.env.LOCALAPPDATA, "Android", "Sdk")].filter(Boolean);
  return roots.find((r) => existsSync(join(r, "platform-tools"))) ?? null;
}

/** Finds a tool inside the SDK (`adb`, `emulator`); null when absent. */
function sdkTool(root, dir, name) {
  for (const file of [`${name}.exe`, name]) {
    const p = join(root, dir, file);
    if (existsSync(p)) return p;
  }
  return null;
}

const root = sdkRoot();
if (!root) notVerified("no Android SDK found (ANDROID_HOME, ANDROID_SDK_ROOT or %LOCALAPPDATA%\\Android\\Sdk)");
const adb = sdkTool(root, "platform-tools", "adb");
if (!adb) notVerified("adb is not installed in the Android SDK");
if (!existsSync(apk)) notVerified(`no release APK at ${apk} (cd apps/mobile && flutter build apk --release)`);

/** Runs adb and returns stdout; `ok` lists exit codes treated as success. */
const run = (cmdArgs, { ok = [0], serial } = {}) => {
  const full = serial ? ["-s", serial, ...cmdArgs] : cmdArgs;
  try {
    return execFileSync(adb, full, { encoding: "utf8", stdio: ["ignore", "pipe", "pipe"] });
  } catch (e) {
    if (ok.includes(e.status)) return e.stdout ?? "";
    throw e;
  }
};
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const attached = () => run(["devices"]).split("\n").slice(1)
  .map((l) => l.match(/^(\S+)\tdevice\s*$/)?.[1]).filter(Boolean);

let serial = attached().find((s) => s.startsWith("emulator-"));
let booted = null;
if (!serial && allowPhone) serial = attached()[0];
if (!serial) {
  const emulator = sdkTool(root, "emulator", "emulator");
  const avds = emulator
    ? execFileSync(emulator, ["-list-avds"], { encoding: "utf8" }).split(/\r?\n/).map((s) => s.trim()).filter(Boolean)
    : [];
  if (avds.length === 0) notVerified("no emulator attached and no AVD to boot");
  console.log(`… booting AVD ${avds[0]} headless (this takes a few minutes)`);
  booted = spawn(emulator, ["-avd", avds[0], "-no-window", "-no-audio", "-no-snapshot-save", "-no-boot-anim"],
    { stdio: "ignore", detached: false });
  for (let s = 0; s < BOOT_TIMEOUT_S && !serial; s += 5) {
    await sleep(5000);
    const emu = attached().find((d) => d.startsWith("emulator-"));
    if (emu && run(["shell", "getprop", "sys.boot_completed"], { serial: emu, ok: [0, 1] }).trim() === "1") serial = emu;
  }
  if (!serial) { booted.kill(); notVerified(`AVD ${avds[0]} did not finish booting within ${BOOT_TIMEOUT_S} s`); }
}

/** Shuts down an AVD this script booted; leaves one the developer started alone. */
const finish = (code) => {
  if (booted) { run(["emu", "kill"], { serial, ok: [0, 1] }); booted.kill(); }
  process.exit(code);
};

run(["uninstall", PACKAGE], { serial, ok: [0, 1, 255] }); // absent is fine
const install = run(["install", apk], { serial });
if (!/Success/.test(install)) { console.error(`✗ Install failed:\n${install}`); finish(1); }
run(["logcat", "-c"], { serial });
run(["shell", "am", "start", "-W", "-n", ACTIVITY], { serial });

let drawn = null;
let crash = "";
for (let s = 0; s < FIRST_FRAME_TIMEOUT_S; s += 3) {
  await sleep(3000);
  const log = run(["logcat", "-d", "-b", "main,system,crash"], { serial });
  const fatal = log.split("\n").filter((l) =>
    /FATAL EXCEPTION|AndroidRuntime: (Process|java\.|Caused by)|Abort message|E flutter|Unhandled Exception/.test(l) &&
    (l.includes(PACKAGE) || /AndroidRuntime|flutter/.test(l)));
  if (fatal.length) { crash = fatal.slice(0, 25).join("\n"); break; }
  const m = log.match(new RegExp(`Displayed ${PACKAGE.replace(/\./g, "\\.")}/\\.MainActivity[^+]*\\+([0-9a-z]+)`));
  if (m) { drawn = m[1]; break; }
}
const alive = run(["shell", "pidof", PACKAGE], { serial, ok: [0, 1] }).trim() !== "";

if (crash || !alive || !drawn) {
  console.error(`✗ Release smoke test FAILED on ${serial} (${apk})`);
  if (crash) console.error(crash);
  if (!alive) console.error("The app process is not running.");
  if (!drawn) console.error(`No first frame within ${FIRST_FRAME_TIMEOUT_S} s.`);
  finish(1);
}
console.log(`✓ Release smoke test on ${serial}: ${apk} installed clean, first frame after ${drawn}, process alive, no crash.`);
finish(0);
