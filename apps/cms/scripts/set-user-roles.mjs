/**
 * Bootstrap / repair a CMS staff account's roles (and optionally its password).
 *
 * WHY THIS EXISTS: Payload's "create first user" flow bypasses the `create: isAdmin`
 * access rule but still applies the `roles` field default (`["editor"]`), and `roles`
 * is `access: { update: isAdminField }` — admin-only. So the very first account can
 * end up an editor with **no admin anywhere in the system**, and nothing inside the
 * admin panel can promote it: an editor cannot publish (the review gate requires
 * admin|medical_reviewer) or manage users. This script is the out-of-band bootstrap,
 * the CMS counterpart of the `staff_roles` SQL bootstrap in runbook B2.
 *
 * It goes through Payload's Local API with `overrideAccess`, so hooks, validation and
 * password hashing all behave exactly as they do in the admin panel — no hand-written
 * SQL against Payload's tables.
 *
 * RUN (from the repo root; reads apps/cms/.env.local for DATABASE_URL + PAYLOAD_SECRET):
 *   pnpm --filter cms exec cross-env EMAIL=you@example.com ROLES=admin,editor payload run ./scripts/set-user-roles.mjs
 * or simply:
 *   EMAIL=you@example.com ROLES=admin,editor pnpm --filter cms set-roles     # bash
 *   $env:EMAIL="you@example.com"; $env:ROLES="admin,editor"; pnpm --filter cms set-roles   # PowerShell
 *
 * Optional: NEW_PASSWORD=… also resets that user's password (useful if it was lost —
 * Payload has no email transport configured, so the forgot-password flow can't help).
 * Never commit a password or paste one into chat.
 */
import { readFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const CMS_DIR = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const VALID_ROLES = ["admin", "editor", "medical_reviewer", "translator"];

// Load apps/cms/.env.local ourselves: the Payload CLI doesn't read Next's .env.local,
// and payload.config.ts reads process.env at import time (hence the dynamic import).
function loadEnvLocal() {
  let raw;
  try {
    raw = readFileSync(resolve(CMS_DIR, ".env.local"), "utf8");
  } catch {
    return; // rely on the ambient environment (e.g. CI or an exported var)
  }
  for (const line of raw.split(/\r?\n/)) {
    const m = line.match(/^\s*([A-Z0-9_]+)\s*=\s*(.*)\s*$/);
    if (!m) continue;
    const value = m[2].replace(/^["']|["']$/g, "");
    if (!process.env[m[1]]) process.env[m[1]] = value;
  }
}

loadEnvLocal();

const email = process.env.EMAIL;
const roles = (process.env.ROLES ?? "")
  .split(",")
  .map((r) => r.trim())
  .filter(Boolean);
const newPassword = process.env.NEW_PASSWORD;

if (!email || roles.length === 0) {
  console.error("Need EMAIL and ROLES, e.g. EMAIL=you@example.com ROLES=admin,editor");
  process.exit(1);
}
const unknown = roles.filter((r) => !VALID_ROLES.includes(r));
if (unknown.length > 0) {
  console.error(`Unknown role(s): ${unknown.join(", ")}. Valid: ${VALID_ROLES.join(", ")}`);
  process.exit(1);
}
if (!process.env.DATABASE_URL || !process.env.PAYLOAD_SECRET) {
  console.error("Missing DATABASE_URL / PAYLOAD_SECRET (set them in apps/cms/.env.local).");
  process.exit(1);
}

const { getPayload } = await import("payload");
const { default: config } = await import("../src/payload.config.ts");
const payload = await getPayload({ config });

const found = await payload.find({
  collection: "users",
  where: { email: { equals: email } },
  limit: 1,
  overrideAccess: true,
});
const user = found.docs[0];
if (!user) {
  console.error(`No CMS user with email ${email}. Create it in /admin first.`);
  process.exit(1);
}

console.log(`user #${user.id} ${user.email}`);
console.log(`  roles before: ${JSON.stringify(user.roles ?? [])}`);

const updated = await payload.update({
  collection: "users",
  id: user.id,
  data: { roles, ...(newPassword ? { password: newPassword } : {}) },
  overrideAccess: true,
});

console.log(`  roles after:  ${JSON.stringify(updated.roles ?? [])}`);
if (newPassword) console.log("  password: reset");
console.log("\nDone. Sign in at <cms-url>/admin — an admin can publish and manage users.");
process.exit(0);
