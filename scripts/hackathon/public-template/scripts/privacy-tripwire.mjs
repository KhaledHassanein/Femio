#!/usr/bin/env node
/**
 * Runs femio's privacy tripwire in the public, app-only repository (R14.3, JUDGE-7).
 *
 * Why it exists: `scripts/analytics-lint.mjs` is copied byte for byte from femio's private
 * monorepo, where it also checks the website (`apps/web`). The website is not published here,
 * so those checks can only report "cannot read apps/web". This wrapper runs the tripwire
 * unchanged, ignores findings whose path starts with `apps/web/` (and says how many), and fails
 * on every other finding: the app's checks (no analytics or ads package, no network code in
 * Dart, Firebase only in the Kotlin assistant package, the cloud call takes only a CloudPrompt,
 * no Google Search grounding, no ad-ID or personal permission) run exactly as in the monorepo.
 *
 * Usage (from the repository root): node scripts/privacy-tripwire.mjs
 */
import { spawnSync } from "node:child_process";

const run = spawnSync(process.execPath, ["scripts/analytics-lint.mjs"], { encoding: "utf8" });
if (run.error) {
  console.error(`cannot run the tripwire: ${run.error.message}`);
  process.exit(1);
}
if (run.status === 0) {
  process.stdout.write(run.stdout);
  process.exit(0);
}

const findings = run.stderr
  .split("\n")
  .map((line) => line.trim())
  .filter((line) => line.startsWith("✗ "))
  .map((line) => line.slice(2));
const website = findings.filter((f) => f.startsWith("apps/web/") || f.startsWith("apps/web:"));
const app = findings.filter((f) => !website.includes(f));

if (findings.length === 0) {
  // It failed without the usual report: never treat an unexplained failure as a pass.
  process.stderr.write(run.stderr);
  console.error("privacy tripwire FAILED without a readable report");
  process.exit(1);
}
if (app.length > 0) {
  console.error("privacy tripwire FAILED (app checks):\n");
  for (const f of app) console.error(`  ✗ ${f}`);
  process.exit(1);
}
console.log(
  `✓ privacy tripwire (app checks): passed. ${website.length} website check(s) skipped: ` +
    "the website lives in femio's private monorepo, not in this repository.",
);
