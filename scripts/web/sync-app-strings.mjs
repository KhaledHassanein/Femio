#!/usr/bin/env node
/**
 * Copies the app's own wording into the website's demo catalog (R2.10).
 *
 * Why it exists: the website shows the app (`/app`, the home tour and demos). Every
 * sentence there that the app also says, and every privacy sentence about what Cloud
 * boost sends, must be the app's sentence word for word, in all four languages, or the
 * site starts describing a product that does not exist. So those sentences are not
 * re-typed: this script reads them from `apps/mobile/lib/l10n/app_<locale>.arb` and
 * writes them under `appDemo.app` in `apps/web/messages/<locale>.json`.
 *
 * Usage:
 *   node scripts/web/sync-app-strings.mjs          write the catalogs
 *   node scripts/web/sync-app-strings.mjs --check  fail (exit 1) if a catalog has drifted
 *
 * Fails when a listed key is missing from an ARB file, so a renamed app string breaks the
 * gate instead of leaving the website with a stale copy.
 */
import { readFileSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const ROOT = join(dirname(fileURLToPath(import.meta.url)), "..", "..");
const LOCALES = ["en", "ar", "fr", "es"];

/** The ARB keys the website quotes. Add a key here, never a copied sentence in a catalog. */
export const APP_KEYS = [
  // Today and the calendar
  "todayTitle",
  "calendarTitle",
  "predictionNote",
  "privacyLine",
  "legendPredicted",
  "legendPossible",
  "confidenceHigh",
  "confidenceMedium",
  "confidenceLowShort",
  "upcomingPeriodsTitle",
  "upcomingPeriodsWider",
  "upcomingPeriodsOnlyNext",
  // Ask femio, rules first
  "askTitle",
  "askIntro",
  "askAction",
  "askSearching",
  "askAnswerOnPhone",
  "askClinicianLine",
  "askSourcesTitle",
  "askSourceReviewed",
  "askNotCoveredHeading",
  "askNotCovered",
  "askSearchAgain",
  "safetyHeavyBleedingHeading",
  "safetyHeavyBleedingBody",
  "helpNowLauncher",
  // Say it in your words
  "sayItButton",
  "sayItTitle",
  "sayItAction",
  "sayItFound",
  "sayItAdd",
  "sayItAdded",
  "assistantPrivateNote",
  "logCramps",
  "logHeadache",
  "logFatigue",
  "logBloating",
  "logNausea",
  "logBackache",
  "logAnxious",
  // Tips
  "tipsTitle",
  "tipsChosenOnPhone",
  "tip_folicAcidBeforePregnancy",
  "tip_regularSexTakesTime",
  "tip_testingTooEarly",
  // Visit summary
  "visitTitle",
  "visitIntro",
  // Cloud boost: what may be sent and what never is
  "boostTitle",
  "boostIntro",
  "boostStageLabel",
  "boostRegularityLabel",
  "boostCategoriesLabel",
  "boostStreakLabel",
  "boostNeverHeading",
  "boostNever",
  "boostAlsoSeen",
  "boostWithdrawEffect",
];

function readArb(locale) {
  return JSON.parse(readFileSync(join(ROOT, "apps/mobile/lib/l10n", `app_${locale}.arb`), "utf8"));
}

/**
 * Returns the catalog for `locale` with `appDemo.app` set from the ARB file, keeping every
 * other key and the key order. A new `appDemo` namespace goes right after `getApp`.
 */
function synced(locale) {
  const arb = readArb(locale);
  const app = {};
  for (const key of APP_KEYS) {
    if (typeof arb[key] !== "string") {
      throw new Error(`app_${locale}.arb has no string "${key}"`);
    }
    app[key] = arb[key];
  }
  const path = join(ROOT, "apps/web/messages", `${locale}.json`);
  const before = readFileSync(path, "utf8");
  const catalog = JSON.parse(before);
  if (catalog.appDemo === undefined) {
    const next = {};
    for (const [k, v] of Object.entries(catalog)) {
      next[k] = v;
      if (k === "getApp") next.appDemo = { app };
    }
    if (next.appDemo === undefined) next.appDemo = { app };
    return { path, before, after: `${JSON.stringify(next, null, 2)}\n` };
  }
  catalog.appDemo.app = app;
  return { path, before, after: `${JSON.stringify(catalog, null, 2)}\n` };
}

const check = process.argv.includes("--check");
let drift = 0;
for (const locale of LOCALES) {
  const { path, before, after } = synced(locale);
  if (before === after) continue;
  if (check) {
    drift += 1;
    console.error(`app-strings: apps/web/messages/${locale}.json differs from the app's wording. Run node scripts/web/sync-app-strings.mjs`);
  } else {
    writeFileSync(path, after);
    console.log(`app-strings: wrote ${locale}.json`);
  }
}
if (drift > 0) process.exit(1);
if (check) console.log(`app-strings: ${APP_KEYS.length} app sentences match in ${LOCALES.length} locales`);
