/**
 * Markdown → Payload importer for the authored article drafts (P1.9.2).
 *
 * WHY THIS EXISTS: there was no way to get `docs/content/articles/*.md` into the CMS.
 * The alternative was a person pasting 60 articles into the admin panel by hand, which
 * loses exactly the fields P1.6.6 added columns for — sources, SEO title/description,
 * disclaimer type, the author and reviewer relationships. Those are the fields that
 * make a health page trustworthy, and they are the ones a copy-paste silently drops.
 *
 * THE IMPORTER REFUSES MALFORMED INPUT. It re-validates every field it is about to
 * write and aborts the whole run on the first problem, so the authoring brief's schema
 * behaves like a specification rather than a suggestion. It also runs the content guard
 * as a pre-flight; `--skip-lint` exists for the case where a known stylistic finding is
 * still being corrected, and it says so loudly rather than passing quietly.
 *
 * EVERYTHING IMPORTS AS A DRAFT. `_status` and `reviewStatus` are both forced to
 * "draft" and nothing here can set them otherwise: publication is a clinician's decision
 * behind the CMS review gate (`hooks/review-gate.ts`), and an importer that could
 * publish would be a way around it. `written_by`/`medically_reviewed_by` are "PENDING"
 * in every draft, so the authorship relationships are deliberately left unset rather
 * than guessed — an invented byline on health content is worse than a missing one.
 *
 * RUN (from the repo root; reads apps/cms/.env.local for DATABASE_URL + PAYLOAD_SECRET):
 *   pnpm content-import                # dry run — reports what it would write
 *   pnpm content-import -- --apply     # actually write
 *   pnpm content-import -- --apply --only=pcos,endometriosis
 *
 * NOTE: apps/cms/.env.local holds the PRODUCTION connection string. A dry run touches
 * nothing; `--apply` writes to whatever DATABASE_URL points at. That is why dry run is
 * the default and `--apply` must be typed.
 */
import { readFileSync, readdirSync } from "node:fs";
import { dirname, resolve, join } from "node:path";
import { fileURLToPath } from "node:url";
import { execFileSync } from "node:child_process";
import { pathToFileURL } from "node:url";

const CMS_DIR = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const REPO_ROOT = resolve(CMS_DIR, "..", "..");

const { parseArticle, REQUIRED_KEYS, FrontMatterError } = await import(
  pathToFileURL(join(REPO_ROOT, "scripts", "lib", "article-frontmatter.mjs")).href
);
const { markdownToLexical, MarkdownError } = await import(
  pathToFileURL(join(REPO_ROOT, "scripts", "lib", "markdown-to-lexical.mjs")).href
);

const argv = process.argv.slice(2);
const has = (flag) => argv.includes(flag);
const APPLY = has("--apply");
const SKIP_LINT = has("--skip-lint");
const ONLY = argv.find((a) => a.startsWith("--only="))?.slice("--only=".length).split(",").filter(Boolean);
// `--dir` lets the refusal paths be tested against deliberately-broken fixtures
// (scripts/content-import.test.mjs). An importer whose validation has never been
// seen to reject anything is just an optimistic writer.
const ARTICLES_DIR =
  argv.find((a) => a.startsWith("--dir="))?.slice("--dir=".length) ??
  join(REPO_ROOT, "docs", "content", "articles");

/* ------------------------------------------------------------------ *
 * Env (same loader as set-user-roles.mjs — the Payload CLI does not
 * read Next's .env.local, and payload.config.ts reads process.env at
 * import time).
 * ------------------------------------------------------------------ */
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

/* ------------------------------------------------------------------ *
 * Pre-flight: the content guard
 * ------------------------------------------------------------------ */
if (SKIP_LINT) {
  console.warn(
    "⚠ --skip-lint: importing WITHOUT the content guard. Only do this for a finding you\n" +
      "  have already triaged; the guard is what keeps unsourced or mis-framed copy out of the CMS.\n",
  );
} else {
  try {
    execFileSync(process.execPath, ["scripts/content-lint.mjs"], {
      cwd: REPO_ROOT,
      stdio: "inherit",
    });
  } catch {
    console.error(
      "\n✗ Import aborted: the content guard reports findings (above).\n" +
        "  Fix the drafts, or re-run with --skip-lint if you have triaged them deliberately.",
    );
    process.exit(1);
  }
}

/* ------------------------------------------------------------------ *
 * Read + validate every draft before writing anything.
 * An import that fails halfway leaves the CMS in a state nobody chose,
 * so validation is a separate pass over the whole set first.
 * ------------------------------------------------------------------ */
const problems = [];
const records = [];

let files = readdirSync(ARTICLES_DIR).filter((f) => f.endsWith(".md")).sort();
if (ONLY) files = files.filter((f) => ONLY.includes(f.replace(/\.md$/, "")));
if (files.length === 0) {
  console.error(`✗ No drafts matched in ${ARTICLES_DIR}. Refusing to report success on nothing.`);
  process.exit(1);
}

for (const file of files) {
  const raw = readFileSync(join(ARTICLES_DIR, file), "utf8");
  let fm;
  let body;
  try {
    ({ frontMatter: fm, body } = parseArticle(raw, file));
  } catch (err) {
    if (err instanceof FrontMatterError) {
      problems.push(`${file}: ${err.message}`);
      continue;
    }
    throw err;
  }

  const fail = (msg) => problems.push(`${file}: ${msg}`);

  for (const key of REQUIRED_KEYS) {
    if (!(key in fm)) fail(`missing required key \`${key}\``);
  }
  if (fm.locale !== "en") fail(`locale must be "en" (this importer writes the English locale)`);
  if (fm.status !== "draft") fail(`status is ${JSON.stringify(fm.status)}; only drafts may be imported`);
  for (const key of ["written_by", "medically_reviewed_by"]) {
    if (fm[key] !== "PENDING") {
      fail(
        `${key} is ${JSON.stringify(fm[key])}, not "PENDING". This importer will not create a byline ` +
          `from a Markdown string — link a People record in the CMS instead.`,
      );
    }
  }
  if (typeof fm.title !== "string" || fm.title.trim() === "") fail("title is empty");
  if (typeof fm.slug !== "string" || !/^[a-z0-9-]+$/.test(fm.slug ?? "")) {
    fail(`slug ${JSON.stringify(fm.slug)} must be lowercase, hyphenated`);
  }
  if (fm.slug !== file.replace(/\.md$/, "")) fail(`slug does not match filename`);

  // The canonical URL decides which collection the record belongs to (brief §6).
  const canonical = String(fm.canonical_url ?? "");
  const m = canonical.match(/^https:\/\/femioapp\.com\/en\/(learn|conditions)\/([a-z0-9-]+)$/);
  if (!m) {
    fail(`canonical_url ${JSON.stringify(canonical)} must be https://femioapp.com/en/{learn|conditions}/{slug}`);
    continue;
  }
  if (m[2] !== fm.slug) fail(`canonical_url slug "${m[2]}" disagrees with slug "${fm.slug}"`);
  const collection = m[1] === "conditions" ? "conditions" : "articles";

  const sources = Array.isArray(fm.sources) ? fm.sources : [];
  if (sources.length < 2) fail(`only ${sources.length} source(s); at least two are required`);
  for (const [i, s] of sources.entries()) {
    if (!s.title) fail(`sources[${i}] has no title`);
    if (!s.url) fail(`sources[${i}] has no url`);
    if (!["1", "2", "3"].includes(String(s.tier))) {
      fail(`sources[${i}].tier ${JSON.stringify(s.tier)} is not a tier the CMS accepts (1, 2 or 3)`);
    }
  }

  const DISCLAIMERS = ["general", "screening", "emergency", "none"];
  if (!DISCLAIMERS.includes(fm.disclaimer_type)) {
    fail(`disclaimer_type ${JSON.stringify(fm.disclaimer_type)} is not one of ${DISCLAIMERS.join(", ")}`);
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
  if (converted.h1 && converted.h1 !== fm.title) {
    fail(`the body's H1 (${JSON.stringify(converted.h1)}) differs from \`title\` — one of them is wrong`);
  }

  records.push({
    file,
    collection,
    slug: fm.slug,
    data: {
      title: fm.title,
      slug: fm.slug,
      // `articles` calls it excerpt, `conditions` calls it summary.
      [collection === "conditions" ? "summary" : "excerpt"]: fm.excerpt,
      body: { root: converted.root },
      seo: {
        seoTitle: fm.meta_title,
        metaDescription: fm.meta_description,
        socialTitle: fm.open_graph_title,
        socialDescription: fm.open_graph_description,
        // Drafts must not be indexed; `robots_while_draft` says so and the CMS
        // enforces it through this flag until a reviewer publishes.
        noIndex: String(fm.robots_while_draft ?? "").includes("noindex"),
      },
      readingLevelOk: fm.reading_level_ok === true,
      disclaimerType: fm.disclaimer_type,
      sources: sources.map((s) => ({ title: s.title, url: s.url, tier: String(s.tier) })),
      // Not negotiable — see the header comment.
      reviewStatus: "draft",
      _status: "draft",
    },
  });
}

if (problems.length > 0) {
  console.error(`\n✗ Import refused: ${problems.length} problem(s). Nothing was written.\n`);
  for (const p of problems) console.error(`  ${p}`);
  console.error(
    "\nThe importer validates every field it would write. Fix the drafts and re-run —\n" +
      "importing partial or guessed data into health content is worse than not importing.",
  );
  process.exit(1);
}

console.log(`\n${records.length} draft(s) validated and ready:`);
const byCollection = new Map();
for (const r of records) byCollection.set(r.collection, (byCollection.get(r.collection) ?? 0) + 1);
for (const [c, n] of byCollection) console.log(`  ${c}: ${n}`);

if (!APPLY) {
  console.log(
    "\nDry run — nothing written. Re-run with `--apply` to import.\n" +
      "Every record imports with reviewStatus=draft and _status=draft; publication stays\n" +
      "behind the CMS review gate, which only a medical reviewer can pass.",
  );
  process.exit(0);
}

/* ------------------------------------------------------------------ *
 * Write, through the Local API so hooks, validation and versioning
 * behave exactly as they do in the admin panel.
 * ------------------------------------------------------------------ */
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
    collection: record.collection,
    where: { slug: { equals: record.slug } },
    limit: 1,
    depth: 0,
    overrideAccess: true,
  });

  if (existing.docs[0]) {
    const doc = existing.docs[0];
    // Never walk back over something a reviewer has already worked on.
    if (doc._status === "published" || doc.reviewStatus === "approved") {
      console.log(`  = ${record.collection}/${record.slug} — skipped (${doc.reviewStatus}/${doc._status}); a reviewer owns this now`);
      continue;
    }
    await payload.update({
      collection: record.collection,
      id: doc.id,
      data: record.data,
      locale: "en",
      draft: true,
      overrideAccess: true,
    });
    updated++;
    console.log(`  ~ ${record.collection}/${record.slug} — updated`);
  } else {
    await payload.create({
      collection: record.collection,
      data: record.data,
      locale: "en",
      draft: true,
      overrideAccess: true,
    });
    created++;
    console.log(`  + ${record.collection}/${record.slug} — created`);
  }
}

console.log(`\n✓ Imported: ${created} created, ${updated} updated, all as drafts.`);
console.log("Nothing is public. A medical reviewer approves and publishes in /admin.");
process.exit(0);
