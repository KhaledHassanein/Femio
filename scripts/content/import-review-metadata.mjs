#!/usr/bin/env node
/**
 * One-time carry-over (docs/33_REBUILD_V3 R3.1): the review record lived only in the
 * retired CMS. Its last export, `apps/web/src/content/snapshot/articles.json`, says
 * which of the 100 English guides a clinician reviewed and when. This writes that into
 * each guide's front matter so the Markdown files are the record from now on:
 *
 *   status: "published"            every slug the CMS had published
 *   medically_reviewed_by: <name>  where the export names a reviewer, else left as is
 *   written_by: <name>             where the export names an author
 *   last_reviewed / date_published / date_modified  from the export's dates
 *
 * Idempotent: a second run changes nothing. Usage: node scripts/content/import-review-metadata.mjs
 */
import { readdirSync, readFileSync, writeFileSync } from "node:fs";
import { join } from "node:path";

const DIR = join(process.cwd(), "docs/content/articles");
const snapshot = JSON.parse(readFileSync(join(process.cwd(), "apps/web/src/content/snapshot/articles.json"), "utf8"));
const bySlug = new Map(snapshot.en.map((a) => [a.slug, a]));

const setScalar = (text, key, value) => {
  const line = `${key}: ${value === null ? "null" : JSON.stringify(value)}`;
  const re = new RegExp(`^${key}: .*$`, "m");
  if (!re.test(text)) throw new Error(`${key} missing from front matter`);
  return text.replace(re, line);
};
const day = (iso) => (iso ? iso.slice(0, 10) : null);

let changed = 0;
for (const file of readdirSync(DIR).filter((f) => /^[^.]+\.md$/.test(f))) {
  const slug = file.replace(/\.md$/, "");
  const snap = bySlug.get(slug);
  if (!snap) continue;
  const path = join(DIR, file);
  const before = readFileSync(path, "utf8");
  let text = before;
  text = setScalar(text, "status", "published");
  if (snap.medicalReviewerProfile?.name) text = setScalar(text, "medically_reviewed_by", snap.medicalReviewerProfile.name);
  if (snap.authors?.[0]?.name) text = setScalar(text, "written_by", snap.authors[0].name);
  if (snap.medicalReviewerProfile?.name && snap.lastReviewed) text = setScalar(text, "last_reviewed", day(snap.lastReviewed));
  if (snap.firstPublishedAt ?? snap.updatedAt) text = setScalar(text, "date_published", day(snap.firstPublishedAt ?? snap.updatedAt));
  if (snap.updatedAt) text = setScalar(text, "date_modified", day(snap.updatedAt));
  if (text !== before) {
    writeFileSync(path, text);
    changed += 1;
  }
}
console.log(`review metadata carried into ${changed} guide(s)`);
