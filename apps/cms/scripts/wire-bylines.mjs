/**
 * Wire `authors` + `medicalReviewerProfile` on published content (P1.9.8).
 *
 * Doc 15 §8: a published health page names its author and its medical reviewer,
 * with credentials, linked to a bio. The fields have existed since P1.6.6 and the
 * page renders them (`components/cms/content-article.tsx` → `Byline`), but the
 * importer never set them — so every article has shipped with no byline at all,
 * because `Byline` correctly renders nothing rather than inventing one.
 *
 * This is the data half, and it could not run until P1.9.7 supplied real
 * credentials: pointing 30 pages at a bio reading "K.H." with no qualifications
 * would have satisfied the schema and not the requirement.
 *
 * ## What it will not do
 *
 * - **It never overwrites an existing byline.** A document that already names
 *   someone is skipped, not corrected. Attribution is not this script's to reassign.
 * - **It never publishes.** Unpublished drafts are updated as drafts; the review
 *   gate decides publication, as it always has.
 * - **It refuses a reviewer without credentials**, for the same reason
 *   `upsert-people.mjs` refuses to publish one.
 *
 * ## One read, not one per document
 *
 * The person is fetched once and reused. A loop making a network call per document
 * is what took the CMS down at 30 articles; the updates themselves are unavoidably
 * per-document, but nothing else is.
 *
 * Dry run by default. `apps/cms/.env.local` points at PRODUCTION.
 *
 * RUN (from the repo root):
 *   pnpm --filter cms exec payload run ./scripts/wire-bylines.mjs
 *   pnpm --filter cms exec payload run ./scripts/wire-bylines.mjs -- --apply
 *   …                                                             -- --apply --person=khaled-m
 */
import { readFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const CMS_DIR = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const argv = process.argv.slice(2);
const APPLY = argv.includes("--apply");
const PERSON_SLUG = argv.find((a) => a.startsWith("--person="))?.slice("--person=".length) ?? "khaled-m";
const REVIEWER_EMAIL = process.env.REVIEWER_EMAIL ?? "dr.khaled.hassanein@gmail.com";

/** Collections carrying `publishingFields`. A glossary term has no byline. */
const COLLECTIONS = ["articles", "conditions"];

/**
 * Pages that get an **author** but no medical reviewer.
 *
 * "Medically reviewed by" is a claim about health content, and `meet-femio` is not
 * health content — it is the product explaining itself. Attaching a clinician's
 * review to it would spend the credential where it means nothing and dilute it
 * where it means everything. Doc 15 §8 asks health pages to name a reviewer; it
 * does not ask an About page to.
 */
const NON_HEALTH = new Set(["meet-femio"]);

function loadEnvLocal() {
  let raw;
  try {
    raw = readFileSync(resolve(CMS_DIR, ".env.local"), "utf8");
  } catch {
    return;
  }
  for (const line of raw.split(/\r?\n/)) {
    const m = line.match(/^\s*([A-Z0-9_]+)\s*=\s*(.*)\s*$/);
    if (!m) continue;
    if (!process.env[m[1]]) process.env[m[1]] = m[2].replace(/^["']|["']$/g, "");
  }
}
loadEnvLocal();

if (!process.env.DATABASE_URL || !process.env.PAYLOAD_SECRET) {
  console.error("✗ Missing DATABASE_URL / PAYLOAD_SECRET (set them in apps/cms/.env.local).");
  process.exit(1);
}

const { getPayload } = await import("payload");
const { default: config } = await import("../src/payload.config.ts");
const payload = await getPayload({ config });

const people = await payload.find({
  collection: "people",
  where: { slug: { equals: PERSON_SLUG } },
  limit: 1,
  depth: 0,
  overrideAccess: true,
});
const person = people.docs[0];
if (!person) {
  console.error(`✗ No person with slug "${PERSON_SLUG}". Run upsert-people.mjs first.`);
  process.exit(1);
}
if (!person.credentials) {
  console.error(
    `✗ ${person.name} has blank credentials. Doc 15 §8 wants a reviewer named *with*` +
      "\n  credentials; wiring a bare name onto 30 pages would look like the requirement was met.",
  );
  process.exit(1);
}
if (person._status !== "published") {
  console.error(
    `✗ ${person.name}'s bio is ${person._status}. A byline linking to an unpublished bio is a` +
      "\n  404 on the page's own evidence — publish it first (upsert-people.mjs --apply --publish).",
  );
  process.exit(1);
}

const roles = person.roles ?? [];
const isReviewer = roles.includes("medical_reviewer");
console.log(
  `Byline: ${person.name} · ${person.credentials} (${roles.join(", ") || "no roles"})` +
    `${isReviewer ? "" : " — author only; medicalReviewerProfile will be left alone"}\n`,
);

// Act as a staff account so the collection's own access rules stay live.
const found = await payload.find({
  collection: "users",
  where: { email: { equals: REVIEWER_EMAIL } },
  limit: 1,
  overrideAccess: true,
});
const actor = found.docs[0];
if (!actor) {
  console.error(`✗ No CMS user ${REVIEWER_EMAIL}. Set REVIEWER_EMAIL, or create the account first.`);
  process.exit(1);
}

let wired = 0;
let already = 0;
const failures = [];

for (const collection of COLLECTIONS) {
  const res = await payload.find({
    collection,
    limit: 0,
    depth: 0,
    draft: true,
    locale: "en",
    overrideAccess: true,
  });

  for (const doc of res.docs) {
    const hasAuthors = Array.isArray(doc.authors) && doc.authors.length > 0;
    const hasReviewer = Boolean(doc.medicalReviewerProfile);
    const wantsReviewer = isReviewer && !NON_HEALTH.has(doc.slug);
    if (hasAuthors && (hasReviewer || !wantsReviewer)) {
      already++;
      continue;
    }

    const data = {};
    if (!hasAuthors) data.authors = [person.id];
    if (!hasReviewer && wantsReviewer) data.medicalReviewerProfile = person.id;

    if (!APPLY) {
      console.log(`  would wire ${collection}/${doc.slug} → ${Object.keys(data).join(" + ")}`);
      wired++;
      continue;
    }

    try {
      await payload.update({
        collection,
        id: doc.id,
        data,
        locale: "en",
        // A published document is updated in place: the byline belongs on the live
        // page. An unpublished one stays unpublished — `draft` follows the document
        // rather than being asserted, so this can never publish anything.
        draft: doc._status !== "published",
        overrideAccess: false,
        user: actor,
      });
      wired++;
      console.log(`  ✓ ${collection}/${doc.slug}`);
    } catch (err) {
      failures.push(`${collection}/${doc.slug}: ${err.message}`);
      console.error(`  ✗ ${collection}/${doc.slug} — ${err.message}`);
    }
  }
}

console.log(
  `\n${APPLY ? "Wired" : "Would wire"}: ${wired}` +
    `${already ? `, already attributed: ${already}` : ""}` +
    `${failures.length ? `, failed: ${failures.length}` : ""}`,
);
if (!APPLY) console.log("Dry run — nothing written. Re-run with `--apply`.");
process.exit(failures.length > 0 ? 1 : 0);
