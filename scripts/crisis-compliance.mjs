#!/usr/bin/env node
/**
 * Femio crisis-safety compliance guard (docs/compliance/CRISIS_RESOURCES.md, ADR-013).
 *
 * The crisis interface is a safety-critical surface: stale or unreviewed wording
 * must never ship. This guard fails CI on:
 *   1. Expired approved copy — any approved locale whose `nextReview` date has
 *      passed (English deadline: 2027-07-23).
 *   2. Approved locales missing review metadata (reviewer / reviewDate / nextReview)
 *      or their `strings` block.
 *   3. Translation-key mismatches — an approved locale whose `strings` keys are not
 *      an exact parity match with English (the master).
 *   4. Country help numbers (lib/crisis/country-numbers.ts) older than 12 months, or
 *      a number listed without its source URL.
 *
 * Locales marked `pending` are expected to have no `strings` (they render the
 * English fallback at runtime) and are only checked for a valid status value.
 */
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";

const HERE = dirname(fileURLToPath(import.meta.url));
const CRISIS_JSON = join(HERE, "..", "apps", "web", "src", "lib", "crisis", "crisis.json");
const MASTER_LOCALE = "en";
const DATE_RE = /^\d{4}-\d{2}-\d{2}$/;

const errors = [];

const crisis = JSON.parse(readFileSync(CRISIS_JSON, "utf8"));
const locales = crisis.locales ?? {};

const master = locales[MASTER_LOCALE];
if (!master || !master.strings) {
  errors.push(`Master locale "${MASTER_LOCALE}" is missing or has no strings.`);
}
const masterKeys = master?.strings ? Object.keys(master.strings).sort() : [];

// Compare against the start of today (UTC) so an expiry "today" is still valid.
const today = new Date();
today.setUTCHours(0, 0, 0, 0);

for (const [locale, entry] of Object.entries(locales)) {
  const review = entry?.review ?? {};
  const status = review.status;

  if (status !== "approved" && status !== "pending") {
    errors.push(`[${locale}] review.status must be "approved" or "pending" (got ${JSON.stringify(status)}).`);
    continue;
  }

  if (status === "pending") {
    if (entry.strings != null) {
      errors.push(`[${locale}] is "pending" but ships strings — pending locales must fall back to English (set strings: null).`);
    }
    continue;
  }

  // status === "approved"
  for (const field of ["reviewer", "reviewDate", "nextReview"]) {
    if (!review[field]) errors.push(`[${locale}] approved copy is missing review.${field}.`);
  }
  if (review.reviewDate && !DATE_RE.test(review.reviewDate)) {
    errors.push(`[${locale}] review.reviewDate must be YYYY-MM-DD (got ${JSON.stringify(review.reviewDate)}).`);
  }
  if (review.nextReview) {
    if (!DATE_RE.test(review.nextReview)) {
      errors.push(`[${locale}] review.nextReview must be YYYY-MM-DD (got ${JSON.stringify(review.nextReview)}).`);
    } else if (new Date(`${review.nextReview}T00:00:00Z`) < today) {
      errors.push(`[${locale}] approved crisis copy EXPIRED on ${review.nextReview} — re-verify wording, accessibility and directory terms, then set a new date.`);
    }
  }

  if (!entry.strings) {
    errors.push(`[${locale}] is "approved" but has no strings.`);
    continue;
  }

  // Key parity with the master locale.
  const keys = Object.keys(entry.strings).sort();
  const missing = masterKeys.filter((k) => !keys.includes(k));
  const extra = keys.filter((k) => !masterKeys.includes(k));
  if (locale !== MASTER_LOCALE && (missing.length || extra.length)) {
    errors.push(
      `[${locale}] string keys do not match ${MASTER_LOCALE}` +
        (missing.length ? ` — missing: ${missing.join(", ")}` : "") +
        (extra.length ? ` — unexpected: ${extra.join(", ")}` : "") +
        ".",
    );
  }
}

// 4. Country numbers (apps/web/src/lib/crisis/country-numbers.ts): every number is
// re-checked at its source within 12 months, as CRISIS_RESOURCES.md requires, and the
// file carries a source URL for each number it lists.
const COUNTRY_NUMBERS_TS = join(HERE, "..", "apps", "web", "src", "lib", "crisis", "country-numbers.ts");
const MAX_AGE_DAYS = 365;
{
  const src = readFileSync(COUNTRY_NUMBERS_TS, "utf8");
  const checked = src.match(/COUNTRY_NUMBERS_CHECKED\s*=\s*"(\d{4}-\d{2}-\d{2})"/)?.[1];
  if (!checked) {
    errors.push("[country-numbers] COUNTRY_NUMBERS_CHECKED (YYYY-MM-DD) is missing.");
  } else {
    const ageDays = (today.getTime() - new Date(`${checked}T00:00:00Z`).getTime()) / 86_400_000;
    if (ageDays > MAX_AGE_DAYS) {
      errors.push(`[country-numbers] numbers last checked ${checked}, over ${MAX_AGE_DAYS} days ago — re-verify each at its source, then update COUNTRY_NUMBERS_CHECKED.`);
    }
  }
  const numbers = (src.match(/number:\s*"/g) ?? []).length;
  const sources = (src.match(/sourceUrl:\s*"https:/g) ?? []).length;
  if (numbers !== sources) {
    errors.push(`[country-numbers] ${numbers} number(s) but ${sources} sourceUrl(s) — every number needs the page it was read on.`);
  }
}

// The app's catalogs carry the same approved sentences, verbatim (R4.8). A drift here
// would be an unreviewed crisis sentence on a phone.
const ARB_KEYS = { immediateLead: "helpNowImmediateLead", stayWithSomeone: "helpNowStayWithSomeone", worriedBody: "helpNowWorriedBody", immediateHeading: "helpNowImmediateHeading", worriedHeading: "helpNowWorriedHeading" };
for (const [locale, entry] of Object.entries(locales)) {
  const arbPath = join(HERE, "..", "apps", "mobile", "lib", "l10n", `app_${locale}.arb`);
  let arb;
  try {
    arb = JSON.parse(readFileSync(arbPath, "utf8"));
  } catch {
    errors.push(`${locale}: app catalog ${arbPath} missing or unreadable`);
    continue;
  }
  for (const [crisisKey, arbKey] of Object.entries(ARB_KEYS)) {
    if (arb[arbKey] !== entry.strings[crisisKey]) errors.push(`${locale}: app string ${arbKey} is not the approved sentence from crisis.json (${crisisKey})`);
  }
}

if (errors.length > 0) {
  console.error("✗ Crisis-safety compliance guard failed:\n");
  for (const e of errors) console.error(`  ${e}`);
  console.error("\nSee docs/compliance/CRISIS_RESOURCES.md. Do not ship crisis copy that is expired or unreviewed.");
  process.exit(1);
}

console.log("✓ Crisis-safety compliance guard: approved copy in date, metadata complete, keys in parity, country numbers sourced and in date, app strings verbatim.");
