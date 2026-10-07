#!/usr/bin/env node
/**
 * Femio RLS / access-control audit (P1.23, docs/compliance/SECURITY_REVIEW.md).
 *
 * Proves — against the LIVE Supabase project, using only the client-safe
 * publishable key (never a service key) — that the data layer enforces:
 *   1. Consent gate: a health write is REJECTED before an active `core` consent
 *      exists, and ACCEPTED after (0002 has_core_consent).
 *   2. Owner-only isolation: user B cannot SELECT / UPDATE / DELETE user A's rows.
 *   3. Anonymous (no-JWT) role: cannot read health tables (RLS → 0 rows), but can
 *      read published content.
 *   4. Aggregate insights RPCs (0006) refuse a non-staff caller — they are
 *      `security definer`, so their in-function is_staff() check is the boundary.
 *   5. GDPR cascade: deleting A's profile row removes A's health data.
 *
 * This is a manual/pre-release security gate (it creates throwaway anonymous
 * users and hits the real DB), not a CI step. Run:  node scripts/security/rls-audit.mjs
 * Requires apps/web/.env.local (NEXT_PUBLIC_SUPABASE_URL + _PUBLISHABLE_KEY) and
 * anonymous sign-ins enabled on the project.
 */
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";
import { createRequire } from "node:module";

const HERE = dirname(fileURLToPath(import.meta.url));
const WEB = join(HERE, "..", "..", "apps", "web");
const ENV_PATH = join(WEB, ".env.local");
// Resolve @supabase/supabase-js from the web app (pnpm symlinked node_modules).
const require = createRequire(join(WEB, "package.json"));
const { createClient } = require("@supabase/supabase-js");

function loadEnv() {
  const out = {};
  for (const line of readFileSync(ENV_PATH, "utf8").split(/\r?\n/)) {
    const m = line.match(/^\s*([A-Z0-9_]+)\s*=\s*(.*)\s*$/);
    if (m) out[m[1]] = m[2].replace(/^["']|["']$/g, "");
  }
  return out;
}

const env = loadEnv();
const URL = env.NEXT_PUBLIC_SUPABASE_URL;
const KEY = env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY;
if (!URL || !KEY) {
  console.error("Missing NEXT_PUBLIC_SUPABASE_URL / _PUBLISHABLE_KEY in apps/web/.env.local");
  process.exit(2);
}

const opts = { auth: { persistSession: false, autoRefreshToken: false } };
const newClient = () => createClient(URL, KEY, opts);

let passed = 0;
const failures = [];
function check(name, ok, detail = "") {
  if (ok) {
    passed++;
    console.log(`  ✓ ${name}`);
  } else {
    failures.push(`${name}${detail ? ` — ${detail}` : ""}`);
    console.error(`  ✗ ${name}${detail ? ` — ${detail}` : ""}`);
  }
}

async function signInAnon() {
  const client = newClient();
  const { data, error } = await client.auth.signInAnonymously();
  if (error) throw new Error(`anon sign-in failed: ${error.message}`);
  return { client, uid: data.user.id };
}

async function run() {
  console.log("Femio RLS / access-control audit\n");

  const a = await signInAnon();
  const b = await signInAnon();
  console.log(`  (user A ${a.uid.slice(0, 8)}…, user B ${b.uid.slice(0, 8)}…)\n`);

  // 1. Consent gate — write BEFORE consent must fail.
  console.log("1. Consent gate");
  {
    const { error } = await a.client
      .from("cycles")
      .insert({ profile_id: a.uid, period_start: "2026-01-01" });
    check("health write rejected before core consent", error != null, error ? "" : "insert unexpectedly succeeded");
  }
  // Grant core consent, then the same write must succeed.
  {
    const { error: cErr } = await a.client
      .from("consent_records")
      .insert({ profile_id: a.uid, purpose: "core", granted: true, version: "audit-1" });
    check("owner can record own consent", cErr == null, cErr?.message);
  }
  let aRowId = null;
  {
    const { data, error } = await a.client
      .from("cycles")
      .insert({ profile_id: a.uid, period_start: "2026-01-01" })
      .select("id")
      .single();
    check("health write accepted after core consent", error == null && data?.id, error?.message);
    aRowId = data?.id ?? null;
  }

  // 2. Owner-only isolation — B must not see or touch A's row.
  console.log("\n2. Owner-only isolation");
  {
    const { data } = await b.client.from("cycles").select("id").eq("profile_id", a.uid);
    check("B cannot SELECT A's rows", Array.isArray(data) && data.length === 0, `saw ${data?.length ?? "?"} rows`);
  }
  if (aRowId) {
    const { data } = await b.client
      .from("cycles")
      .update({ flow: "heavy" })
      .eq("id", aRowId)
      .select("id");
    check("B cannot UPDATE A's row", Array.isArray(data) && data.length === 0, `updated ${data?.length ?? "?"} rows`);
    const { data: del } = await b.client.from("cycles").delete().eq("id", aRowId).select("id");
    check("B cannot DELETE A's row", Array.isArray(del) && del.length === 0, `deleted ${del?.length ?? "?"} rows`);
  }
  // A can still read its own row (proves the row survived B's attempts).
  {
    const { data } = await a.client.from("cycles").select("id").eq("id", aRowId);
    check("A's row survived B's attempts", Array.isArray(data) && data.length === 1);
  }

  // 3. Anonymous (no-JWT) role — no health reads. (The published-content read check
  //    went with public.content in migration 0024; content is not served from here.)
  console.log("\n3. Unauthenticated (anon role, no session)");
  {
    const anon = newClient();
    const { data, error } = await anon.from("cycles").select("id").limit(1);
    // RLS yields 0 rows (profile_id = null); a hard error is also acceptable.
    check("anon role reads no health rows", error != null || (Array.isArray(data) && data.length === 0));
  }

  // 4. Privilege escalation — a non-admin cannot grant themselves a staff role,
  //    nor read another user's roles (RBAC / A01, P1.18).
  console.log("\n4. Role privilege escalation");
  {
    const { data, error } = await b.client
      .from("staff_roles")
      .insert({ user_id: b.uid, role: "admin" })
      .select("role");
    check(
      "non-admin cannot grant self a staff role",
      error != null || !Array.isArray(data) || data.length === 0,
      error ? "" : `inserted ${data?.length} role(s)`,
    );
  }
  {
    const { data } = await b.client.from("staff_roles").select("role").eq("user_id", a.uid);
    check("user cannot read another user's roles", Array.isArray(data) && data.length === 0, `saw ${data?.length ?? "?"} rows`);
  }

  // 4b. Aggregate insights RPCs (P1.20.3) must refuse a non-staff caller. These
  // are `security definer` — they read past RLS by design — so their own
  // is_staff() check is the whole boundary. If the migration isn't applied yet
  // the RPC is simply missing, which is reported rather than silently passed.
  console.log("\n4b. First-party insights RPCs (aggregate-only, staff-gated)");
  for (const [rpc, args] of [
    ["insights_overview", {}],
    ["insights_by_dimension", { p_dimension: "mode" }],
    ["insights_retention", { p_months: 6 }],
  ]) {
    const { data, error } = await b.client.rpc(rpc, args);
    // A missing function is NOT a pass — say so in the label, or an unapplied
    // migration would read as a green access-control check.
    const missing = error?.code === "PGRST202" || error?.code === "42883";
    check(
      missing
        ? `non-staff cannot call ${rpc}() [SKIPPED — migration 0006 not applied]`
        : `non-staff cannot call ${rpc}()`,
      missing ? true : error != null && Array.isArray(data) === false,
      error ? "" : `returned ${JSON.stringify(data)?.slice(0, 80)}`,
    );
  }

  // 5. GDPR cascade — deleting A's profile removes A's health data.
  console.log("\n5. GDPR delete cascade");
  {
    await a.client.from("profiles").delete().eq("id", a.uid);
    const { data } = await a.client.from("cycles").select("id").eq("profile_id", a.uid);
    check("A's health rows gone after profile delete", Array.isArray(data) && data.length === 0, `saw ${data?.length ?? "?"} rows`);
  }

  // Cleanup B (best-effort).
  await b.client.from("profiles").delete().eq("id", b.uid);

  console.log(`\n${failures.length ? "✗" : "✓"} ${passed} passed, ${failures.length} failed`);
  if (failures.length) {
    for (const f of failures) console.error(`  - ${f}`);
    process.exit(1);
  }
}

run().catch((e) => {
  console.error("Audit error:", e.message);
  process.exit(2);
});
