#!/usr/bin/env node
/**
 * Seed `ui_strings` from the local JSON catalogs (P1.19). Populates the
 * translation-portal source of truth: English is the master (status
 * `human_reviewed`), AR/FR/ES are first-draft (status `machine`) pending human
 * review in the portal. Idempotent upsert on (key, locale).
 *
 * MANUAL — run by Khaled with a SERVICE-ROLE key (writes bypass RLS):
 *   SUPABASE_SERVICE_KEY=<service_role_key> node scripts/i18n/seed-ui-strings.mjs
 * Reads NEXT_PUBLIC_SUPABASE_URL from apps/web/.env.local. Never commit the
 * service key. After seeding, the app still serves JSON until a row is approved
 * (loader serves only status='human_reviewed'); EN rows are approved on seed, so
 * they overlay identically to JSON (no visible change).
 */
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";
import { createRequire } from "node:module";

const HERE = dirname(fileURLToPath(import.meta.url));
const WEB = join(HERE, "..", "..", "apps", "web");
const require = createRequire(join(WEB, "package.json"));
const { createClient } = require("@supabase/supabase-js");

const LOCALES = ["en", "ar", "fr", "es"];
const MASTER = "en";

function loadEnv() {
  const out = {};
  for (const line of readFileSync(join(WEB, ".env.local"), "utf8").split(/\r?\n/)) {
    const m = line.match(/^\s*([A-Z0-9_]+)\s*=\s*(.*)\s*$/);
    if (m) out[m[1]] = m[2].replace(/^["']|["']$/g, "");
  }
  return out;
}

function flatten(obj, prefix, out) {
  for (const [k, v] of Object.entries(obj)) {
    const key = prefix ? `${prefix}.${k}` : k;
    if (typeof v === "string") out[key] = v;
    else if (v && typeof v === "object") flatten(v, key, out);
  }
  return out;
}

const url = loadEnv().NEXT_PUBLIC_SUPABASE_URL;
const serviceKey = process.env.SUPABASE_SERVICE_KEY;
if (!url || !serviceKey) {
  console.error("Need NEXT_PUBLIC_SUPABASE_URL (apps/web/.env.local) + SUPABASE_SERVICE_KEY (env).");
  process.exit(2);
}

const supabase = createClient(url, serviceKey, { auth: { persistSession: false } });

const rows = [];
for (const locale of LOCALES) {
  const json = JSON.parse(readFileSync(join(WEB, "messages", `${locale}.json`), "utf8"));
  const flat = flatten(json, "", {});
  for (const [key, value] of Object.entries(flat)) {
    rows.push({
      key,
      locale,
      value,
      status: locale === MASTER ? "human_reviewed" : "machine",
      icu: /\{.*\}/.test(value),
    });
  }
}

console.log(`Upserting ${rows.length} ui_strings rows across ${LOCALES.length} locales…`);
// Chunk to stay within request limits.
for (let i = 0; i < rows.length; i += 500) {
  const chunk = rows.slice(i, i + 500);
  const { error } = await supabase.from("ui_strings").upsert(chunk, { onConflict: "key,locale" });
  if (error) {
    console.error("Upsert failed:", error.message);
    process.exit(1);
  }
}
console.log("✓ Seeded ui_strings. EN = human_reviewed (live-overlaid); AR/FR/ES = machine (await portal review).");
