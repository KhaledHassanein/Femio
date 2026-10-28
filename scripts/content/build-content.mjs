#!/usr/bin/env node
/**
 * The content pipeline (docs/33_REBUILD_V3 R3.2): one build from the repository's own
 * files to the JSON both clients read. No CMS, no database.
 *
 * Sources, in order of authority:
 *   1. `docs/content/articles/<slug>.md` and `<slug>.<locale>.md`: the authored guides
 *      (front matter + Markdown, the authoring brief's schema). A file is published
 *      when its `status` is "published".
 *   2. `apps/web/src/content/snapshot/*.json`: the last export from the retired CMS
 *      (2026-10-07). It still carries the 100 reviewed English bodies, the 5 condition
 *      hubs and the reviewer bio, so an English slug that exists in the snapshot keeps
 *      the snapshot's body until the Markdown copy is marked published AND newer
 *      (`date_modified` after the snapshot's `updatedAt`). Everything else (Arabic,
 *      French, Spanish, and English slugs the CMS never had) comes from Markdown.
 *
 * Outputs (generated; never edited by hand):
 *   packages/content/{articles,conditions,people,faqs,glossary,meta}.json  the website
 *   apps/mobile/assets/content/{en,ar,fr,es}.json                           the app
 *
 * `--check` rebuilds in memory and fails when the committed outputs differ, so the
 * gate catches a stale build the way tokens-to-dart does.
 */
import { existsSync, mkdirSync, readdirSync, readFileSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import { parseArticle } from "../lib/article-frontmatter.mjs";
import { markdownToLexical } from "../lib/markdown-to-lexical.mjs";

const ROOT = process.cwd();
const ARTICLES_DIR = join(ROOT, "docs/content/articles");
const SNAPSHOT_DIR = join(ROOT, "apps/web/src/content/snapshot");
const WEB_OUT = join(ROOT, "packages/content");
const APP_OUT = join(ROOT, "apps/mobile/assets/content");
const LOCALES = ["en", "ar", "fr", "es"];
const CHECK = process.argv.includes("--check");

const readJson = (file) => JSON.parse(readFileSync(file, "utf8"));
const snapshot = Object.fromEntries(["articles", "conditions", "people", "faqs", "glossary", "meta"].map((n) => [n, readJson(join(SNAPSHOT_DIR, `${n}.json`))]));

/** The one reviewer bio the CMS held; the byline shape pages already render. */
const PEOPLE = Object.fromEntries((snapshot.people.en ?? []).map((p) => [p.name, { slug: p.slug, name: p.name, credentials: p.credentials, jobTitle: p.jobTitle }]));

/** Reads every Markdown guide, keyed by locale then slug. */
function readMarkdown() {
  const byLocale = Object.fromEntries(LOCALES.map((l) => [l, new Map()]));
  for (const file of readdirSync(ARTICLES_DIR).filter((f) => f.endsWith(".md")).sort()) {
    const text = readFileSync(join(ARTICLES_DIR, file), "utf8");
    const { frontMatter: fm, body } = parseArticle(text, file);
    const locale = fm.locale ?? "en";
    if (!LOCALES.includes(locale)) throw new Error(`${file}: unknown locale ${locale}`);
    byLocale[locale].set(fm.slug, { fm, body, file });
  }
  return byLocale;
}

/** A Markdown guide as the website's ContentDoc. */
function toDoc(entry, id) {
  const { fm, body, file } = entry;
  const reviewer = fm.medically_reviewed_by && fm.medically_reviewed_by !== "PENDING" ? (PEOPLE[fm.medically_reviewed_by] ?? { slug: slugify(fm.medically_reviewed_by), name: fm.medically_reviewed_by }) : null;
  const author = fm.written_by && fm.written_by !== "PENDING" ? (PEOPLE[fm.written_by] ?? { slug: slugify(fm.written_by), name: fm.written_by }) : null;
  return {
    id,
    title: fm.title,
    slug: fm.slug,
    excerpt: fm.excerpt,
    body: markdownToLexical(stripLeadingH1(body), { filename: file }),
    disclaimerType: fm.disclaimer_type ?? "general",
    sources: (fm.sources ?? []).map((s) => ({ title: s.title, url: s.url ?? null, tier: s.tier ?? null })),
    lastReviewed: fm.last_reviewed ?? null,
    updatedAt: fm.date_modified ?? fm.date_published ?? null,
    firstPublishedAt: fm.date_published ?? null,
    seo: {
      // The page template appends the wordmark; a meta title that already ends in
      // "| Femio" would render as "… | Femio — femio" (56 guides did, 2026-10-28).
      seoTitle: stripSiteSuffix(fm.meta_title),
      metaDescription: fm.meta_description ?? null,
      canonicalOverride: null,
      noIndex: fm.status !== "published",
      socialTitle: fm.open_graph_title ?? null,
      socialDescription: fm.open_graph_description ?? null,
      socialImage: null,
    },
    authors: author ? [author] : [],
    medicalReviewerProfile: reviewer,
  };
}

const slugify = (s) => s.toLowerCase().replace(/[^a-z0-9؀-ۿ]+/g, "-").replace(/^-|-$/g, "");

/** The body's H1 repeats the title; the page renders the title itself. */
/** Drop a trailing site name ("| Femio", "— femio") from an authored meta title. */
function stripSiteSuffix(title) {
  if (!title) return null;
  return title.replace(/\s*[|—–-]\s*femio\s*$/i, "").trim() || null;
}

function stripLeadingH1(body) {
  return body.replace(/^\s*#\s+[^\n]+\n/, "");
}

function build() {
  const md = readMarkdown();
  const articles = {};
  const appArticles = {};
  let nextId = 10000;
  for (const locale of LOCALES) {
    const fromSnapshot = new Map((snapshot.articles[locale] ?? []).map((a) => [a.slug, a]));
    const out = [];
    const seen = new Set();
    for (const [slug, entry] of md[locale]) {
      if (entry.fm.status !== "published") continue;
      const snap = fromSnapshot.get(slug);
      const markdownIsNewer = snap && entry.fm.date_modified && snap.updatedAt && entry.fm.date_modified > snap.updatedAt.slice(0, 10);
      if (snap && !markdownIsNewer) {
        out.push(snap);
      } else {
        out.push(toDoc(entry, snap?.id ?? nextId++));
      }
      seen.add(slug);
    }
    for (const [slug, snap] of fromSnapshot) if (!seen.has(slug)) out.push(snap);
    out.sort((a, b) => a.slug.localeCompare(b.slug));
    for (const a of out) if (a.seo) a.seo.seoTitle = stripSiteSuffix(a.seo.seoTitle);
    articles[locale] = out;
    appArticles[locale] = out.map((a) => ({
      slug: a.slug,
      title: a.title,
      excerpt: a.excerpt,
      body: a.body,
      sources: a.sources,
      reviewer: a.medicalReviewerProfile?.name ?? null,
      lastReviewed: a.lastReviewed,
      disclaimerType: a.disclaimerType,
    }));
  }
  const counts = Object.fromEntries(LOCALES.map((l) => [l, articles[l].length]));
  const meta = {
    builtFrom: { snapshotTakenAt: snapshot.meta.takenAt, markdownDir: "docs/content/articles" },
    summary: { ...snapshot.meta.summary, articles: counts },
  };
  // The snapshot's condition hubs carried the same authored suffix.
  for (const list of Object.values(snapshot.conditions ?? {})) for (const c of list ?? []) if (c?.seo) c.seo.seoTitle = stripSiteSuffix(c.seo.seoTitle);
  return { articles, conditions: snapshot.conditions, people: snapshot.people, faqs: snapshot.faqs, glossary: snapshot.glossary, meta, appArticles };
}

const serialize = (value) => JSON.stringify(value, null, 1) + "\n";

function writeOrCheck(file, content) {
  if (CHECK) {
    const current = existsSync(file) ? readFileSync(file, "utf8") : "";
    if (current !== content) return false;
    return true;
  }
  mkdirSync(join(file, ".."), { recursive: true });
  writeFileSync(file, content);
  return true;
}

const built = build();
const results = [];
for (const name of ["articles", "conditions", "people", "faqs", "glossary", "meta"]) {
  results.push([`packages/content/${name}.json`, writeOrCheck(join(WEB_OUT, `${name}.json`), serialize(built[name]))]);
}
for (const locale of LOCALES) {
  results.push([`apps/mobile/assets/content/${locale}.json`, writeOrCheck(join(APP_OUT, `${locale}.json`), serialize(built.appArticles[locale]))]);
}
const stale = results.filter(([, ok]) => !ok).map(([f]) => f);
if (CHECK && stale.length) {
  console.error("✗ Built content is stale; run `pnpm content:build` and commit:\n  " + stale.join("\n  "));
  process.exit(1);
}
console.log(`${CHECK ? "✓ Built content is current" : "built content"}: articles ${LOCALES.map((l) => `${l} ${built.articles[l].length}`).join(", ")}`);
