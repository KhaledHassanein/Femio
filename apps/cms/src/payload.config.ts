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
    },
    // Isolate ALL Payload tables in a dedicated `payload` schema. This is REQUIRED
    // on the shared DB: without it, Payload's schema push sees the app's public
    // schema-v1 tables (labs, vitals, pregnancy, …) and tries to "rename" them into
    // Payload tables — data-loss risk. With isolation, push only ever manages the
    // (initially empty) payload schema, so it cleanly creates its own tables and
    // can never touch the app's. Create the schema once: `create schema if not
    // exists payload;` (runbook C1.5).
    schemaName: "payload",
    // Schema changes ship as MIGRATIONS, never as deploy-time push (ADR-029).
    // Push took production down once: the deployed code expected columns the
    // database never got, because a `hasMany` relationship needs a new table and
    // that does not apply non-interactively. `pnpm --filter cms build` now runs
    // `payload migrate` first, so a schema change either lands with the deploy or
    // fails the deploy — never silently half-applies.
    //
    // Push stays available in local development only, where it is genuinely
    // useful and a mistake costs nothing. `PAYLOAD_DB_PUSH` is deliberately no
    // longer consulted: an env var is not a safe place for this decision.
    push: process.env.NODE_ENV !== "production",
  }),
  sharp,
  typescript: {
    outputFile: path.resolve(dirname, "payload-types.ts"),
  },
});
