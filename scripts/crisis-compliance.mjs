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

if (errors.length > 0) {
  console.error("✗ Crisis-safety compliance guard failed:\n");
  for (const e of errors) console.error(`  ${e}`);
  console.error("\nSee docs/compliance/CRISIS_RESOURCES.md. Do not ship crisis copy that is expired or unreviewed.");
  process.exit(1);
}

console.log("✓ Crisis-safety compliance guard: approved copy in date, metadata complete, keys in parity.");
