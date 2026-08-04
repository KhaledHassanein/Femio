/**
 * Run pending Payload migrations — but only during a real deployment.
 *
 * WHY THIS GUARD EXISTS: the obvious version of this is
 * `"build": "payload migrate && next build"`, and it is a trap. `apps/cms/.env.local`
 * holds the **production** connection string (there is no staging database), so
 * that build script would migrate production every time anyone ran a local build
 * to check that the app compiles. I nearly did exactly that.
 *
 * So the decision of *when* to migrate lives here, in code, rather than in a
 * Vercel dashboard setting that can silently drift:
 *   - Vercel deploy (`VERCEL=1`)  → migrate, and fail the build if it fails.
 *     A deploy that can't apply its schema must not ship: that is precisely the
 *     failure mode of ADR-029, where code shipped ahead of its columns.
 *   - Anywhere else (local, GitHub CI) → skip. CI builds the CMS against a
 *     placeholder DATABASE_URL and must never touch a real database.
 */
import { spawnSync } from "node:child_process";

// PRODUCTION deployments only. Two reasons, and the second matters more:
//   1. Preview builds may have no DATABASE_URL, and failing them helps nobody —
//      that is what broke the femio-cms preview deploys on 2026-08-03.
//   2. Preview and production share ONE database. A preview build running
//      migrations would mutate the live schema from a branch that may never
//      merge — a worse outage than the one this script exists to prevent. So
//      `VERCEL_ENV === "production"` is a safety boundary, not a convenience.
if (process.env.VERCEL_ENV !== "production") {
  console.log(
    `[migrate-on-deploy] VERCEL_ENV=${process.env.VERCEL_ENV ?? "(unset)"} — skipping migrations.` +
      "\n  They run on production deploys only. Locally:  pnpm --filter cms migrate",
  );
  process.exit(0);
}

if (!process.env.DATABASE_URL) {
  console.error("[migrate-on-deploy] production deploy without DATABASE_URL — refusing to build.");
  process.exit(1);
}

console.log("[migrate-on-deploy] applying pending migrations…");
const result = spawnSync("payload", ["migrate"], { stdio: "inherit", shell: true });
process.exit(result.status ?? 1);
