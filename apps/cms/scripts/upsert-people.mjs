/**
 * Create or update author / medical-reviewer bios in the CMS from `docs/content/people/*.json`.
 *
 * WHY A FILE RATHER THAN THE ADMIN PANEL: a bio is the E-E-A-T evidence behind every
 * published health page (doc 15 §7/§8) — who checked this, and what qualifies them. Keeping
 * it in the repo makes a change to a reviewer's stated credentials show up in a diff and go
 * through review, which is exactly the property you want on a claim of expertise. It also
 * reuses the article importer's Markdown → Lexical converter, so a bio is written the same
 * way an article is.
 *
 * IT REFUSES TO PUBLISH A REVIEWER WITHOUT CREDENTIALS. Doc 15 §8 requires a published
 * health page to name its reviewer *with* credentials and a bio link. A bio reading only
 * "K.H." with no qualifications is weaker evidence than none, because it looks like the
 * requirement was met when it was not. Drafts with blank credentials are fine and expected —
 * publishing one is not, so `--publish` fails on it and says what is missing.
 *
 * RUN (from the repo root):
 *   pnpm --filter cms exec payload run ./scripts/upsert-people.mjs                 # dry run
 *   pnpm --filter cms exec payload run ./scripts/upsert-people.mjs -- --apply      # write as draft
 *   pnpm --filter cms exec payload run ./scripts/upsert-people.mjs -- --apply --publish
 */
import { readFileSync, readdirSync } from "node:fs";
import { dirname, resolve, join } from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";

const CMS_DIR = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const REPO_ROOT = resolve(CMS_DIR, "..", "..");
const PEOPLE_DIR = join(REPO_ROOT, "docs", "content", "people");

const { markdownToLexical } = await import(
  pathToFileURL(join(REPO_ROOT, "scripts", "lib", "markdown-to-lexical.mjs")).href
);

const argv = process.argv.slice(2);
const APPLY = argv.includes("--apply");
const PUBLISH = argv.includes("--publish");

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

const files = readdirSync(PEOPLE_DIR).filter((f) => f.endsWith(".json")).sort();
if (files.length === 0) {
  console.error(`✗ No bios in ${PEOPLE_DIR}. Refusing to report success on nothing.`);
  process.exit(1);
}

const problems = [];
const records = [];

for (const file of files) {
  const raw = JSON.parse(readFileSync(join(PEOPLE_DIR, file), "utf8"));
  const fail = (msg) => problems.push(`${file}: ${msg}`);

  if (!raw.slug || !/^[a-z0-9-]+$/.test(raw.slug)) fail(`slug ${JSON.stringify(raw.slug)} must be lowercase, hyphenated`);
  if (!raw.name?.trim()) fail("name is empty");
  if (!Array.isArray(raw.roles) || raw.roles.length === 0) fail("at least one role is required");
  for (const role of raw.roles ?? []) {
    if (!["author", "medical_reviewer"].includes(role)) fail(`unknown role ${JSON.stringify(role)}`);
  }
  if (!raw.bio?.trim()) fail("bio is empty");

  // The rule that gives this script its point.
  const isReviewer = (raw.roles ?? []).includes("medical_reviewer");
  const missingEeat = ["credentials", "affiliation"].filter((k) => !raw[k]?.trim());
  if (PUBLISH && isReviewer && missingEeat.length > 0) {
    fail(
      `cannot publish a medical reviewer with no ${missingEeat.join(" and ")} — doc 15 §8 requires a ` +
        `named reviewer WITH credentials on every published health page. Fill them in, or drop --publish ` +
        `and leave the bio as a draft.`,
    );
  }

  let body;
  try {
    body = markdownToLexical(raw.bio, { filename: file });
  } catch (err) {
    fail(err.message);
    continue;
  }

  records.push({
    file,
    slug: raw.slug,
    missingEeat,
    isReviewer,
    data: {
      name: raw.name,
      slug: raw.slug,
      roles: raw.roles,
      credentials: raw.credentials || undefined,
      jobTitle: raw.jobTitle || undefined,
      affiliation: raw.affiliation || undefined,
      bio: { root: body.root },
      sameAs: (raw.sameAs ?? []).map((s) => ({ label: s.label, url: s.url })),
      _status: PUBLISH ? "published" : "draft",
    },
  });
}

if (problems.length > 0) {
  console.error(`\n✗ Refused: ${problems.length} problem(s). Nothing was written.\n`);
  for (const p of problems) console.error(`  ${p}`);
  process.exit(1);
}

console.log(`\n${records.length} bio(s) ready (${PUBLISH ? "PUBLISHED" : "draft"}):`);
for (const r of records) {
  const warn = r.isReviewer && r.missingEeat.length > 0 ? `  ⚠ no ${r.missingEeat.join("/")} yet` : "";
  console.log(`  ${r.slug} — ${r.data.name}${warn}`);
}

if (!APPLY) {
  console.log("\nDry run — nothing written. Re-run with `--apply`.");
  process.exit(0);
}

if (!process.env.DATABASE_URL || !process.env.PAYLOAD_SECRET) {
  console.error("✗ Missing DATABASE_URL / PAYLOAD_SECRET (set them in apps/cms/.env.local).");
  process.exit(1);
}

const { getPayload } = await import("payload");
const { default: config } = await import("../src/payload.config.ts");
const payload = await getPayload({ config });

let created = 0;
let updated = 0;
for (const record of records) {
  const existing = await payload.find({
    collection: "people",
    where: { slug: { equals: record.slug } },
    limit: 1,
    depth: 0,
    overrideAccess: true,
  });

  if (existing.docs[0]) {
    await payload.update({
      collection: "people",
      id: existing.docs[0].id,
      data: record.data,
      locale: "en",
      draft: !PUBLISH,
      overrideAccess: true,
    });
    updated++;
    console.log(`  ~ people/${record.slug} — updated`);
  } else {
    await payload.create({
      collection: "people",
      data: record.data,
      locale: "en",
      draft: !PUBLISH,
      overrideAccess: true,
    });
    created++;
    console.log(`  + people/${record.slug} — created`);
  }
}

console.log(`\n✓ ${created} created, ${updated} updated, as ${PUBLISH ? "PUBLISHED" : "drafts"}.`);
if (!PUBLISH) {
  console.log("Bios are not public until published. Re-run with --publish once credentials are filled in.");
}
process.exit(0);
