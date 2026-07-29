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
  collections: [Users, Media, Articles, Conditions, FAQs, Tips, Glossary],
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
    // Payload creates its own tables (users, media, articles, conditions, faqs,
    // tips, glossary, payload_*) in the default `public` schema. None collide with
    // the app's schema-v1 tables (the app has no public.users; it uses auth.users
    // + profiles), so they coexist safely on the shared DB. (A dedicated schema was
    // tried but non-public schemas need extra privileges on Supabase — not worth it.)
    // Auto-create/sync schema on boot: on in dev; in production opt-in via
    // PAYLOAD_DB_PUSH=true for the first deploy (no local migration step), remove after.
    push: process.env.PAYLOAD_DB_PUSH === "true" || process.env.NODE_ENV !== "production",
  }),
  sharp,
  typescript: {
    outputFile: path.resolve(dirname, "payload-types.ts"),
  },
});
