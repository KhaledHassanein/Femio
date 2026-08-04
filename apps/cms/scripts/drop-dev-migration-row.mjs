/**
 * Remove the legacy `dev` row from `payload.payload_migrations` (ADR-030 follow-up).
 *
 * WHY: `@payloadcms/drizzle`'s `migrate()` prompts — unconditionally, with no flag to
 * suppress it — whenever that table holds a row with `batch = -1`. That row is a relic of
 * the push-mode era (ADR-018) and records no actual migration. Its only remaining effect
 * is to make `payload migrate` block on stdin, which is what cost five CMS deploys 45
 * minutes each and left production 500ing with an unapplied schema (ADR-030).
 *
 * Deleting it makes `payload migrate` non-interactive. It does **not** re-enable
 * migrate-on-deploy: that stays a deliberate manual step by owner decision.
 *
 * Safety: this touches one row in Payload's own bookkeeping table and no content. It
 * prints the table before and after, refuses if the row is not what it expects, and is a
 * no-op on a second run. `apps/cms/.env.local` holds the PRODUCTION connection string, so
 * it reports first and only writes with `--apply`.
 *
 * RUN (from the repo root):
 *   pnpm --filter cms exec payload run ./scripts/drop-dev-migration-row.mjs
 *   pnpm --filter cms exec payload run ./scripts/drop-dev-migration-row.mjs -- --apply
 */
import { readFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const CMS_DIR = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const APPLY = process.argv.includes("--apply");

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

const all = await payload.find({
  collection: "payload-migrations",
  limit: 0,
  sort: "batch",
  overrideAccess: true,
});

console.log("\npayload_migrations:");
for (const row of all.docs) {
  console.log(`  #${row.id}  batch=${String(row.batch).padStart(2)}  ${row.name}`);
}

const devRows = all.docs.filter((r) => Number(r.batch) === -1);
const realRows = all.docs.filter((r) => Number(r.batch) > 0);

if (devRows.length === 0) {
  console.log("\n✓ No `batch = -1` row — `payload migrate` is already non-interactive. Nothing to do.");
  process.exit(0);
}
// Refuse to delete the marker while it is the only record of a migration having run:
// dropping it then would make Payload try to re-apply everything from scratch.
if (realRows.length === 0) {
  console.error(
    "\n✗ Refusing: there are no real (batch > 0) migration rows, so the `dev` row is the only\n" +
      "  record that anything has been applied. Apply the migrations first.",
  );
  process.exit(1);
}
if (devRows.length !== 1 || devRows[0].name !== "dev") {
  console.error(
    `\n✗ Refusing: expected exactly one row named "dev" with batch = -1, found ` +
      `${devRows.length}: ${devRows.map((r) => JSON.stringify(r.name)).join(", ")}.\n` +
      "  Inspect by hand — this script only knows how to remove the known push-mode relic.",
  );
  process.exit(1);
}

if (!APPLY) {
  console.log(
    `\nWould delete row #${devRows[0].id} ("dev", batch = -1).\n` +
      `${realRows.length} real migration row(s) remain, so migration state is preserved.\n` +
      "Dry run — nothing written. Re-run with `--apply`.",
  );
  process.exit(0);
}

await payload.delete({
  collection: "payload-migrations",
  id: devRows[0].id,
  overrideAccess: true,
});

const after = await payload.find({
  collection: "payload-migrations",
  limit: 0,
  sort: "batch",
  overrideAccess: true,
});
console.log("\nAfter:");
for (const row of after.docs) {
  console.log(`  #${row.id}  batch=${String(row.batch).padStart(2)}  ${row.name}`);
}
console.log(
  "\n✓ Removed. `payload migrate` no longer prompts, so `pnpm --filter cms migrate` is safe\n" +
    "  in a non-interactive context. Migrations remain a deliberate manual step (owner decision).",
);
process.exit(0);
