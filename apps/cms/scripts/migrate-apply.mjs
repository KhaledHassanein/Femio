/**
 * Apply pending Payload migrations non-interactively.
 *
 * WHY THIS EXISTS — the "45-minute hang" was never a hang.
 *
 * Every CMS deploy from 33ec508 onwards sat until Vercel's 45-minute build timeout,
 * and `pnpm --filter cms migrate` appeared to hang locally too, so commit 685d25f took
 * the migrate step out of the build on the theory that `payload migrate` does not
 * complete in this setup. It completes in under two seconds. What it was doing was
 * waiting on an interactive prompt:
 *
 *     It looks like you've run Payload in dev mode, meaning you've dynamically pushed
 *     changes to your database. If you'd like to run migrations, data loss will occur.
 *     Would you like to proceed? » (y/N)
 *
 * In a build there is no one to answer, so it waits forever. The trigger is a row in
 * `payload.payload_migrations` with `batch = -1` — the `dev` row left behind by the
 * push-mode era (ADR-018). `@payloadcms/drizzle`'s `migrate()` prompts unconditionally
 * whenever that row exists; there is no flag to suppress it. (`--force-accept-warning`
 * looks like the answer and is not: Payload's CLI only forwards it to `migrate:create`
 * and `migrate:fresh`, never to plain `migrate`.)
 *
 * So this wrapper answers the prompt. That is safe **for this repo's migrations, not in
 * general**: the warning is about dev-push drift, and the standing rule from ADR-029 is
 * that a migration is read before it is applied. `up()` in both current migrations is
 * purely additive — the baseline is an intentional no-op and the publishing-fields
 * migration only CREATEs and ADDs, with every DROP confined to `down()`. Read the SQL
 * before running this, the same way migration 0006 was verified.
 *
 * The permanent fix is to delete the `batch = -1` row once nothing depends on it, after
 * which plain `payload migrate` is non-interactive and safe to put back in a deploy.
 * That is an owner decision on production data, so it is a recommendation, not a step
 * this script takes.
 *
 * RUN (from the repo root — reads apps/cms/.env.local, which holds the PRODUCTION URL):
 *   pnpm --filter cms migrate:apply
 */
import { spawn } from "node:child_process";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const CMS_DIR = resolve(dirname(fileURLToPath(import.meta.url)), "..");

console.log(
  "Applying pending Payload migrations.\n" +
    "Payload will warn about dev-push drift and ask to proceed; this wrapper answers yes.\n" +
    "Only run it once you have read the migrations' `up()` — see the note at the top of this file.\n",
);

const child = spawn("pnpm", ["exec", "payload", "migrate"], {
  cwd: CMS_DIR,
  stdio: ["pipe", "inherit", "inherit"],
  shell: process.platform === "win32",
});

child.stdin.write("y\n");
child.stdin.end();

child.on("exit", (code) => {
  if (code === 0) {
    console.log(
      "\nDone. Now verify against the deployed API, not just the build — the CMS build\n" +
        "never connects to the database, so green builds prove nothing about the schema (ADR-029):\n" +
        '  curl -s -o /dev/null -w "%{http_code}\\n" https://femio-cms.vercel.app/api/articles?limit=1',
    );
  }
  process.exit(code ?? 1);
});
