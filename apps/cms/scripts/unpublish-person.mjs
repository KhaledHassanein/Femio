/**
 * Take a person bio off the public site.
 *
 * `upsert-people.mjs --apply` (without `--publish`) does **not** do this, which is
 * the trap it exists for: passing `draft: true` to Payload saves a *new draft
 * version* and leaves the published version serving. A bio stayed public after the
 * script cheerfully reported "as drafts" — found on 2026-08-12 while removing a
 * duplicate reviewer record.
 *
 * Unpublishing is `_status: "draft"` written to the **published** version, i.e.
 * `draft: false`. Different flag, opposite meaning.
 *
 *   pnpm --filter cms exec payload run ./scripts/unpublish-person.mjs -- <slug>
 */
const slug = process.argv.slice(2).find((a) => !a.startsWith("-"));
if (!slug) {
  console.error("✗ Usage: unpublish-person.mjs -- <slug>");
  process.exit(1);
}

if (!process.env.DATABASE_URL || !process.env.PAYLOAD_SECRET) {
  console.error("✗ Missing DATABASE_URL / PAYLOAD_SECRET (set them in apps/cms/.env.local).");
  process.exit(1);
}

const { getPayload } = await import("payload");
const { default: config } = await import("../src/payload.config.ts");
const payload = await getPayload({ config });

const found = await payload.find({
  collection: "people",
  where: { slug: { equals: slug } },
  limit: 1,
  draft: true,
  overrideAccess: true,
});

const doc = found.docs[0];
if (!doc) {
  console.error(`✗ No person with slug ${JSON.stringify(slug)}.`);
  process.exit(1);
}

await payload.update({
  collection: "people",
  id: doc.id,
  // `draft: false` writes to the live version — that is what makes this an
  // unpublish rather than another draft revision.
  draft: false,
  data: { _status: "draft" },
  overrideAccess: true,
});

console.log(`✓ ${slug} (${doc.name}) is no longer public. The record and its history remain.`);
process.exit(0);
