import path from "path";
import { fileURLToPath } from "url";
import { postgresAdapter } from "@payloadcms/db-postgres";
import { lexicalEditor } from "@payloadcms/richtext-lexical";
import { buildConfig } from "payload";
import sharp from "sharp";
import { Users } from "./collections/Users";
import { Media } from "./collections/Media";
import { Articles } from "./collections/Articles";
import { Conditions } from "./collections/Conditions";
import { FAQs } from "./collections/FAQs";
import { Tips } from "./collections/Tips";
import { Glossary } from "./collections/Glossary";
import { People } from "./collections/People";

const filename = fileURLToPath(import.meta.url);
const dirname = path.dirname(filename);

/**
 * True only for a database on this machine. Gates Payload's schema `push` (ADR-035).
 *
 * Fails closed on purpose: an unset, malformed or unrecognised connection string
 * returns false, so the failure mode of "we couldn't tell" is a disabled push
 * rather than an unattended schema change on somebody's production data.
 */
function isLocalDatabase(connectionString: string | undefined): boolean {
  if (!connectionString) return false;
  let host: string;
  try {
    host = new URL(connectionString).hostname.toLowerCase();
  } catch {
    return false;
  }
  return host === "localhost" || host === "127.0.0.1" || host === "::1" || host === "host.docker.internal";
}

// Femio content CMS. Localization mirrors the app locales (EN/AR/FR/ES, AR is RTL).
// Payload owns authored content in the shared Supabase Postgres (ADR — supersedes
// the sketch content/content_i18n tables from migration 0001).
export default buildConfig({
  admin: {
    user: Users.slug,
    meta: { titleSuffix: " — Femio CMS" },
  },
  editor: lexicalEditor(),
  collections: [Users, Media, Articles, Conditions, FAQs, Tips, Glossary, People],
  localization: {
    locales: [
      { label: "English", code: "en" },
      { label: "العربية", code: "ar", rtl: true },
      { label: "Français", code: "fr" },
      { label: "Español", code: "es" },
    ],
    defaultLocale: "en",
    fallback: true,
  },
  secret: process.env.PAYLOAD_SECRET || "",
  db: postgresAdapter({
    pool: {
      connectionString: process.env.DATABASE_URL || "",
      // Supabase requires TLS; node-postgres doesn't enable it from a plain
      // connection string, so set it explicitly (accept Supabase's cert).
      ssl: { rejectUnauthorized: false },

      // A small pool per instance (ADR-044, corrected ADR-046). node-postgres defaults to
      // `max: 10`, which suits a long-lived server and is wrong here: this runs as
      // serverless functions against Supabase's **session-mode** pooler, where each client
      // holds a dedicated Postgres connection for its whole life and the cap is 15 —
      // shared with the web app and any local script. Two warm CMS instances could claim
      // 20 between them, which is how the API hit `EMAXCONNSESSION` twice (ADR-040).
      //
      // **Not 1.** That was tried and took the CMS down: the reasoning ("a serverless
      // function serves one request at a time") confused requests with queries. Payload
      // issues several queries *within* one request — find alongside count, and a
      // transaction holds its connection while issuing more — so a single connection
      // deadlocks until `connectionTimeoutMillis` fires and every request 500s.
      //
      // Three leaves room for that intra-request parallelism while still capping fan-out
      // at a level several instances can share.
      //
      // Note for anyone tempted by the transaction pooler (port 6543), which would raise
      // the ceiling: it breaks Payload with prepared-statement errors and is already
      // recorded as a failed attempt in the owner runbook. Fix the demand, not the cap.
      max: 3,
      // Hand the slot back quickly — an idle connection on a 15-slot pool is a slot the
      // next function cannot have.
      idleTimeoutMillis: 10_000,
      // Fail fast instead of hanging the whole function on an exhausted pool.
      connectionTimeoutMillis: 10_000,
    },
    // Isolate ALL Payload tables in a dedicated `payload` schema. This is REQUIRED
    // on the shared DB: without it, Payload's schema push sees the app's public
    // schema-v1 tables (labs, vitals, pregnancy, …) and tries to "rename" them into
    // Payload tables — data-loss risk. With isolation, push only ever manages the
    // (initially empty) payload schema, so it cleanly creates its own tables and
    // can never touch the app's. Create the schema once: `create schema if not
    // exists payload;` (runbook C1.5).
    schemaName: "payload",
    // Schema changes ship as MIGRATIONS, never as push (ADR-029). Push took
    // production down once: the deployed code expected columns the database never
    // got, because a `hasMany` relationship needs a new table and that does not
    // apply non-interactively.
    //
    // Push is gated on the DATABASE this process is pointed at, not on NODE_ENV
    // (ADR-035). The earlier `NODE_ENV !== "production"` rule read as "push is a
    // local-development convenience where a mistake costs nothing" — but there is no
    // local database in this project: `apps/cms/.env.local` holds the PRODUCTION
    // connection string, so every local `payload run` (set-user-roles, the article
    // importer, any one-off script) had push enabled against production and would
    // silently apply whatever the working tree's collections happened to say. Keying
    // off the connection target is the honest test, because that is the thing that
    // decides what a mistake costs.
    push: isLocalDatabase(process.env.DATABASE_URL),
  }),
  sharp,
  typescript: {
    outputFile: path.resolve(dirname, "payload-types.ts"),
  },
});
