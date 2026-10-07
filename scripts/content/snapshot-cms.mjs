/**
 * Snapshot the CMS's published content into the repository (D3, step 1).
 *
 * Why: the public site used to ask Payload for content on every render, and Payload
 * reads Supabase Postgres. Supabase bills that traffic as egress. On the free plan
 * (5 GB/month) the library reads alone exhausted the quota, and on 2026-10-06 the
 * project was restricted (every API request answered 402). Served from these files,
 * a page view (bot or human) costs the database nothing.
 *
 * Publishing stays the same for the owner: approve and publish in the CMS. Then run
 *   node scripts/content/snapshot-cms.mjs
 * and commit apps/web/src/content/snapshot/. Vercel redeploys with the new content.
 *
 * Only PUBLISHED documents are ever returned to an unauthenticated caller (CMS
 * access rules), so this cannot leak a draft. Translations are stored only where
 * they really exist (fallback-locale=none), mirroring `translatedSlugs`.
 */
import { mkdirSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const CMS = (process.env.CMS_URL || "https://femio-cms.vercel.app").replace(/\/$/, "");
const LOCALES = ["en", "ar", "fr", "es"];
const OUT = join(dirname(fileURLToPath(import.meta.url)), "../../apps/web/src/content/snapshot");

async function get(path) {
  const res = await fetch(`${CMS}${path}`);
  if (!res.ok) throw new Error(`${res.status} ${path}`);
  return res.json();
}

/** A person as a byline: the only fields an article page shows. */
function byline(p) {
  if (!p || typeof p !== "object") return null;
  return { slug: p.slug, name: p.name, credentials: p.credentials ?? null, jobTitle: p.jobTitle ?? null };
}

const KEEP = [
  "id", "title", "slug", "excerpt", "summary", "body", "question", "answer", "term", "definition",
  "disclaimerType", "sources", "lastReviewed", "updatedAt", "firstPublishedAt", "seo",
];
function trim(doc) {
  const out = {};
  for (const k of KEEP) if (doc[k] !== undefined) out[k] = doc[k];
  if (Array.isArray(out.sources)) out.sources = out.sources.map(({ title, url, tier }) => ({ title, url: url ?? null, tier: tier ?? null }));
  out.authors = (doc.authors ?? []).map(byline).filter(Boolean);
  out.medicalReviewerProfile = byline(doc.medicalReviewerProfile);
  return out;
}

async function collection(name) {
  const byLocale = {};
  for (const locale of LOCALES) {
    const fallback = locale === "en" ? "" : "&fallback-locale=none";
    const data = await get(`/api/${name}?locale=${locale}${fallback}&depth=1&limit=500&sort=-updatedAt`);
    // A doc with no title in this locale exists but is untranslated: not stored.
    byLocale[locale] = data.docs.filter((d) => d.title || d.question || d.term).map(trim);
  }
  return byLocale;
}

async function people() {
  const byLocale = {};
  for (const locale of LOCALES) {
    const fallback = locale === "en" ? "" : "&fallback-locale=none";
    const data = await get(`/api/people?locale=${locale}${fallback}&depth=0&limit=200&sort=name`);
    byLocale[locale] = data.docs
      .filter((p) => p.name)
      .map(({ id, name, slug, roles, credentials, jobTitle, affiliation, bio, sameAs, updatedAt }) => ({
        id, name, slug, roles, credentials, jobTitle, affiliation, bio, updatedAt,
        sameAs: (sameAs ?? []).map(({ label, url }) => ({ label, url })),
      }));
  }
  return byLocale;
}

mkdirSync(OUT, { recursive: true });
const summary = {};
for (const name of ["articles", "conditions", "faqs", "glossary"]) {
  let data;
  try {
    data = await collection(name);
  } catch (e) {
    // A collection the CMS does not expose (404) is stored empty, not fatal.
    console.warn(`  ${name}: ${e.message}, stored empty`);
    data = Object.fromEntries(LOCALES.map((l) => [l, []]));
  }
  writeFileSync(join(OUT, `${name}.json`), JSON.stringify(data) + "\n");
  summary[name] = Object.fromEntries(LOCALES.map((l) => [l, data[l].length]));
}
const ppl = await people();
writeFileSync(join(OUT, "people.json"), JSON.stringify(ppl) + "\n");
summary.people = Object.fromEntries(LOCALES.map((l) => [l, ppl[l].length]));
writeFileSync(join(OUT, "meta.json"), JSON.stringify({ takenAt: new Date().toISOString(), source: CMS, summary }, null, 2) + "\n");
console.log(JSON.stringify(summary));
