#!/usr/bin/env node
/**
 * Set (or reset) a user's password directly via the Supabase Admin API — no email
 * round-trip. Useful to bootstrap a staff/admin password for an account that was
 * created passwordlessly (onboarding links an email but never sets a password).
 *
 * MANUAL — run by Khaled with the SERVICE-ROLE key (never commit it):
 *   Bash:
 *     SUPABASE_SERVICE_KEY="…" EMAIL="you@example.com" NEW_PASSWORD="a-strong-password" \
 *       node scripts/auth/set-password.mjs
 *   PowerShell:
 *     $env:SUPABASE_SERVICE_KEY="…"; $env:EMAIL="you@example.com"; $env:NEW_PASSWORD="a-strong-password"; `
 *       node scripts/auth/set-password.mjs
 *
 * Reads NEXT_PUBLIC_SUPABASE_URL from apps/web/.env.local. Pick a strong password.
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
const password = process.env.NEW_PASSWORD;

if (!url || !serviceKey || !email || !password) {
  console.error("Need NEXT_PUBLIC_SUPABASE_URL (.env.local) + SUPABASE_SERVICE_KEY, EMAIL, NEW_PASSWORD (env).");
  process.exit(2);
}
if (password.length < 8) {
  console.error("Choose a password of at least 8 characters.");
  process.exit(2);
}

const supabase = createClient(url, serviceKey, { auth: { persistSession: false } });

// Find the user by email (page through if needed).
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

const { error } = await supabase.auth.admin.updateUserById(user.id, {
  password,
  email_confirm: true,
});
if (error) {
  console.error("Failed to set password:", error.message);
  process.exit(1);
}
console.log(`✓ Password set for ${email} (${user.id}). You can now sign in with email + password.`);
