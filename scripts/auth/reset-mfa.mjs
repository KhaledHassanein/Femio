#!/usr/bin/env node
/**
 * Clear a user's two-step sign-in factors — the recovery path for a lost or
 * wiped authenticator app (P1.23.3b).
 *
 * WHY THIS EXISTS: staff routes require a second factor (ADR-023), and Supabase
 * offers no self-service factor reset. Without this, a staff member whose phone
 * died is locked out of the back office with no way back in — and "ask the other
 * admin" is not a plan while there is only one admin. Like the `staff_roles` SQL
 * bootstrap (runbook B2) and the CMS role script, first-privilege recovery has to
 * live *outside* the thing it recovers.
 *
 * It removes factors; it does not weaken anything else. The account keeps its
 * password, its roles and its data — the next sign-in simply won't ask for a code
 * until the user enrols again in Settings, which they should do immediately.
 *
 * MANUAL — run by Khaled with the SERVICE-ROLE key (never commit it):
 *   Bash:
 *     SUPABASE_SERVICE_KEY="…" EMAIL="you@example.com" node scripts/auth/reset-mfa.mjs
 *   PowerShell:
 *     $env:SUPABASE_SERVICE_KEY="…"; $env:EMAIL="you@example.com"; node scripts/auth/reset-mfa.mjs
 *
 * Add DRY_RUN=1 to list the factors without deleting anything.
 * Reads NEXT_PUBLIC_SUPABASE_URL from apps/web/.env.local.
 */
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";
import { createRequire } from "node:module";

const HERE = dirname(fileURLToPath(import.meta.url));
const WEB = join(HERE, "..", "..", "apps", "web");
const require = createRequire(join(WEB, "package.json"));
const { createClient } = require("@supabase/supabase-js");

function loadEnv() {
  const out = {};
  for (const line of readFileSync(join(WEB, ".env.local"), "utf8").split(/\r?\n/)) {
    const m = line.match(/^\s*([A-Z0-9_]+)\s*=\s*(.*)\s*$/);
    if (m) out[m[1]] = m[2].replace(/^["']|["']$/g, "");
  }
  return out;
}

const url = loadEnv().NEXT_PUBLIC_SUPABASE_URL;
const serviceKey = process.env.SUPABASE_SERVICE_KEY;
const email = process.env.EMAIL;
const dryRun = process.env.DRY_RUN === "1";

if (!url || !serviceKey || !email) {
  console.error(
    "Need NEXT_PUBLIC_SUPABASE_URL (apps/web/.env.local) + SUPABASE_SERVICE_KEY and EMAIL (env).",
  );
  process.exit(2);
}

const supabase = createClient(url, serviceKey, { auth: { persistSession: false } });

// Find the user by email (page through if needed) — same approach as set-password.mjs.
let user = null;
for (let page = 1; page <= 20 && !user; page++) {
  const { data, error } = await supabase.auth.admin.listUsers({ page, perPage: 1000 });
  if (error) {
    console.error("listUsers failed:", error.message);
    process.exit(1);
  }
  user = data.users.find((u) => (u.email || "").toLowerCase() === email.toLowerCase());
  if (data.users.length < 1000) break;
}
if (!user) {
  console.error(`No user found with email ${email}.`);
  process.exit(1);
}

const { data: factorData, error: listError } = await supabase.auth.admin.mfa.listFactors({
  userId: user.id,
});
if (listError) {
  console.error("Could not list factors:", listError.message);
  process.exit(1);
}

const factors = factorData?.factors ?? [];
if (factors.length === 0) {
  console.log(`${email} (${user.id}) has no two-step factors — nothing to reset.`);
  process.exit(0);
}

console.log(`${email} (${user.id}) has ${factors.length} factor(s):`);
for (const f of factors) {
  console.log(`  - ${f.id}  type=${f.factor_type}  status=${f.status}  created=${f.created_at}`);
}

if (dryRun) {
  console.log("\nDRY_RUN=1 — nothing deleted.");
  process.exit(0);
}

let removed = 0;
for (const f of factors) {
  const { error } = await supabase.auth.admin.mfa.deleteFactor({ id: f.id, userId: user.id });
  if (error) {
    console.error(`  ✗ failed to delete ${f.id}: ${error.message}`);
    continue;
  }
  removed++;
}

console.log(
  `\n✓ Removed ${removed}/${factors.length} factor(s) for ${email}.\n` +
    "They can sign in with their password alone right now — tell them to re-enrol in\n" +
    "Settings → Two-step sign-in immediately, since staff routes stay closed until they do.",
);
process.exit(removed === factors.length ? 0 : 1);
