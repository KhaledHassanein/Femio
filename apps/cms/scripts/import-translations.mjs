/**
 * Markdown → Payload importer for **translations** (R3.8).
 *
 * WHY A SECOND IMPORTER: `import-articles.mjs` writes the English locale and hard-fails
 * on anything else — deliberately, because writing a translation is a different
 * operation with different rules. It creates documents; this one only ever fills in a
 * language on a document that already exists.
 *
 * ## Approval is inherited, and the schema already does it
 *
 * `review_status`, `_status`, `medical_reviewer_id` and `last_reviewed` live on the
 * **parent** `articles` row. Only `title`, `excerpt` and `body` live in
 * `articles_locales`. So writing an Arabic row into an approved, published article
 * makes that translation live immediately, inheriting the approval — no override, no
 * flag, nothing to grant. Owner direction, 2026-08-30.
 *
 * What follows from that is the one rule this importer does enforce: **it refuses to
 * create a parent.** If the English article does not exist, the translation has nothing
 * to inherit approval *from*, and creating one here would mint an unreviewed article
 * that is live in one language and absent in the source. Translations attach; they
 * never originate.
 *
 * ## What the reader is told
 *
 * The clinician reviewed the English. The article page says exactly that on a
 * translated page — "reviewed in English by X" — rather than implying a named person
 * read a language they may not speak. See `content-article.tsx`.
 *
 * RUN (from the repo root; reads apps/cms/.env.local for DATABASE_URL + PAYLOAD_SECRET):
 *   pnpm content-import-translations                     # dry run — reports what it would write
 *   pnpm content-import-translations -- --apply
 *   pnpm content-import-translations -- --apply --locale=ar
 *   pnpm content-import-translations -- --apply --only=endometriosis-signs
 *
 * Files are `docs/content/articles/<slug>.<locale>.md`. NOTE: apps/cms/.env.local holds
 * the PRODUCTION connection string, which is why dry run is the default.
 */
import { readdirSync, readFileSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";

const HERE = dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = join(HERE, "..", "..", "..");
const ARTICLES_DIR = join(REPO_ROOT, "docs", "content", "articles");

const { markdownToLexical, MarkdownError } = await import(
  pathToFileURL(join(REPO_ROOT, "scripts", "lib", "markdown-to-lexical.mjs")).href
);
const { parseArticle, FrontMatterError } = await import(
  pathToFileURL(join(REPO_ROOT, "scripts", "lib", "article-frontmatter.mjs")).href
);

/** Locales this importer will write. `en` is `import-articles.mjs`'s job. */
const TARGET_LOCALES = ["ar", "fr", "es"];

const args = process.argv.slice(2);
const APPLY = args.includes("--apply");
const arg = (name) => args.find((a) => a.startsWith(`--${name}=`))?.split("=")[1] ?? null;
const ONLY_LOCALE = arg("locale");
const ONLY_SLUGS = arg("only")?.split(",").map((s) => s.trim()).filter(Boolean) ?? null;

if (ONLY_LOCALE && !TARGET_LOCALES.includes(ONLY_LOCALE)) {
  console.error(`✗ --locale=${ONLY_LOCALE} is not one of ${TARGET_LOCALES.join(", ")}`);
  process.exit(1);
}

/* ---- 1. collect and validate ---------------------------------------- */

const files = readdirSync(ARTICLES_DIR).filter((f) => /\.[a-z]{2}\.md$/.test(f));
const problems = [];
const records = [];

for (const file of files) {
  const match = /^(.+)\.([a-z]{2})\.md$/.exec(file);
  const [, slug, locale] = match;

  if (!TARGET_LOCALES.includes(locale)) {
    problems.push(`${file}: locale "${locale}" is not one of ${TARGET_LOCALES.join(", ")}`);
    continue;
  }
  if (ONLY_LOCALE && locale !== ONLY_LOCALE) continue;
  if (ONLY_SLUGS && !ONLY_SLUGS.includes(slug)) continue;

  let fm;
  let body;
  try {
    ({ frontMatter: fm, body } = parseArticle(readFileSync(join(ARTICLES_DIR, file), "utf8"), file));
  } catch (err) {
    if (err instanceof FrontMatterError) {
      problems.push(`${file}: ${err.message}`);
      continue;
    }
    throw err;
  }

  const fail = (msg) => problems.push(`${file}: ${msg}`);

  // The filename is the authority for both, and the frontmatter must agree. A
  // mismatch here writes the right text into the wrong language or the wrong
  // article, and neither is visible afterwards without reading every page.
  if (fm.locale !== locale) fail(`frontmatter locale ${JSON.stringify(fm.locale)} ≠ filename "${locale}"`);
  if (fm.slug !== slug) fail(`frontmatter slug ${JSON.stringify(fm.slug)} ≠ filename "${slug}"`);
  if (typeof fm.title !== "string" || fm.title.trim() === "") fail("title is empty");
  if (typeof fm.excerpt !== "string" || fm.excerpt.trim() === "") fail("excerpt is empty");

  // A translated file that is still English is the failure mode nobody notices: it
  // imports cleanly, renders, and quietly claims a language it is not in.
  if (locale === "ar" && !/[؀-ۿ]/.test(`${fm.title} ${body}`)) {
    fail("marked as Arabic but contains no Arabic script — untranslated file?");
  }

  let converted;
  try {
    converted = markdownToLexical(body, { filename: file });
  } catch (err) {
    if (err instanceof MarkdownError) {
      fail(err.message);
      continue;
    }
    throw err;
  }

  records.push({
    file,
    slug,
    locale,
    collection: "articles",
    data: { title: fm.title, excerpt: fm.excerpt, body: { root: converted.root } },
  });
}

if (problems.length > 0) {
  console.error(`✗ ${problems.length} problem(s); nothing was written:\n`);
  for (const p of problems) console.error(`  • ${p}`);
  process.exit(1);
}

if (records.length === 0) {
  console.log("No translation files matched. Expected `docs/content/articles/<slug>.<locale>.md`.");
  process.exit(0);
}

console.log(`${records.length} translation file(s) ready.`);
if (!APPLY) {
  for (const r of records) console.log(`  → would write ${r.collection}/${r.slug} [${r.locale}]`);
  console.log("\nDry run. Re-run with --apply to write.");
  process.exit(0);
}

/* ---- 2. write ------------------------------------------------------- */

const { getPayload } = await import("payload");
const { default: config } = await import("../src/payload.config.ts");
const payload = await getPayload({ config });

let written = 0;
let skipped = 0;

for (const record of records) {
  const existing = await payload.find({
    collection: record.collection,
    where: { slug: { equals: record.slug } },
    limit: 1,
    depth: 0,
    locale: "en",
    overrideAccess: true,
  });

  const doc = existing.docs[0];
  if (!doc) {
    // See the header: translations attach, they never originate.
    console.log(`  ! ${record.slug} [${record.locale}] — skipped, no English article to attach to`);
    skipped++;
    continue;
  }

  await payload.update({
    collection: record.collection,
    id: doc.id,
    data: record.data,
    locale: record.locale,
    // **No `draft: true`.** On a published article this writes the language into the
    // live document, which is the whole point — the translation inherits the parent's
    // approval because approval is not a localised field. On an article still in
    // draft it stays a draft, which is also correct: it goes live when the English
    // does, together.
    overrideAccess: true,
  });

  written++;
  console.log(`  + ${record.slug} [${record.locale}] — written (${doc.reviewStatus}/${doc._status})`);
}

console.log(`\n✓ ${written} translation(s) written, ${skipped} skipped.`);
if (skipped > 0) {
  console.log("Skipped files have no English article yet. Import that first, then re-run.");
}
process.exit(0);
