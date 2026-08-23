/**
 * Femio — does the live schema actually carry what the migrations describe?
 *
 * **Why this exists.** BLOCKERS B11 found migrations recorded as applied whose
 * artifacts were not in the database, and B13 asked for the check to be run by
 * hand. `supabase migration list` reads a ledger; a ledger can be wrong. This
 * probes the artifacts themselves.
 *
 * It needs only the publishable (anon) key, which is shipped to browsers by
 * design, so it is safe to run anywhere the web app can run.
 *
 * **The signal.** PostgREST answers 200 + `[]` for a table that exists whose RLS
 * denies an anonymous reader, and 404 + `PGRST205` for a table it cannot find. An
 * empty array is therefore a pass, and the absence of an error is the assertion.
 *
 * **What it cannot check.** Anything needing a signed-in session — most notably
 * that `patterns` accepts an update to `dismissed_at` and rejects one to
 * `confidence`, which is a column-level grant that RLS alone cannot express. That
 * check lives in `runbooks/MANUAL_TEST_PLAN.md`.
 *
 * Extend the lists below whenever a migration adds a table or a column.
 */
import { readFileSync } from "node:fs";

const env = Object.fromEntries(
  readFileSync("apps/web/.env.local", "utf8")
    .split(/\r?\n/)
    .filter((l) => l.includes("=") && !l.trim().startsWith("#"))
    .map((l) => {
      const i = l.indexOf("=");
      return [l.slice(0, i).trim(), l.slice(i + 1).trim().replace(/^["']|["']$/g, "")];
    }),
);

const url = env.NEXT_PUBLIC_SUPABASE_URL;
const key = env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY;
if (!url || !key) {
  console.error("Missing NEXT_PUBLIC_SUPABASE_URL or NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY");
  process.exit(2);
}
console.log(`Probing ${new URL(url).host}\n`);

const H = { apikey: key, Authorization: `Bearer ${key}` };
let failures = 0;

/** A table exists if PostgREST does not answer "relation not found". */
async function tableExists(table, select = "*") {
  const r = await fetch(`${url}/rest/v1/${table}?select=${select}&limit=1`, { headers: H });
  const body = await r.text();
  const missing = r.status === 404 || body.includes("PGRST205") || body.includes("42P01");
  const ok = !missing;
  console.log(`${ok ? "OK  " : "MISS"}  table ${table}${select === "*" ? "" : ` (${select})`}  [${r.status}] ${ok ? "" : body.slice(0, 120)}`);
  if (!ok) failures++;
  return ok;
}

/** A column exists if selecting it does not raise "column does not exist" (42703). */
async function columnExists(table, column) {
  const r = await fetch(`${url}/rest/v1/${table}?select=${column}&limit=1`, { headers: H });
  const body = await r.text();
  const missing = body.includes("42703") || body.includes("does not exist");
  console.log(`${missing ? "MISS" : "OK  "}  column ${table}.${column}  [${r.status}] ${missing ? body.slice(0, 120) : ""}`);
  if (missing) failures++;
}

console.log("--- A1/A4/A5/A6/A7: the new tables ---");
await tableExists("period_days");
await tableExists("predictions");
await tableExists("patterns");
await tableExists("experience_documents");
await tableExists("feature_flags");

console.log("\n--- A2/A3: the new columns ---");
await columnExists("symptom_logs", "dimension");
await columnExists("vitals", "source");
await columnExists("fertility_logs", "source");

console.log("\n--- B13 check 1: feature_flags is readable signed out ---");
{
  const r = await fetch(`${url}/rest/v1/feature_flags?select=key,enabled`, { headers: H });
  const body = await r.text();
  const ok = r.status === 200;
  console.log(`${ok ? "OK  " : "FAIL"}  anon SELECT feature_flags  [${r.status}] ${body.slice(0, 160)}`);
  if (!ok) failures++;
}

console.log("\n--- B13 check 2: predictions rejects a client INSERT ---");
{
  const r = await fetch(`${url}/rest/v1/predictions`, {
    method: "POST",
    headers: { ...H, "Content-Type": "application/json", Prefer: "return=minimal" },
    body: JSON.stringify({
      profile_id: "00000000-0000-0000-0000-000000000000",
      kind: "period_start",
      confidence: 1,
      engine_version: "b13-probe",
    }),
  });
  const body = await r.text();
  const ok = r.status === 401 || r.status === 403 || body.includes("42501");
  console.log(`${ok ? "OK  " : "FAIL"}  anon INSERT predictions rejected  [${r.status}] ${body.slice(0, 160)}`);
  if (!ok) failures++;
}

console.log(`\n${failures === 0 ? "PASS — every artifact is present and the two anon checks behave." : `FAIL — ${failures} problem(s) above.`}`);
process.exit(failures === 0 ? 0 : 1);
