#!/usr/bin/env node
/**
 * Exports the public, app-only copy of femio for #BuildHybridAI (ADR-078 §7, R14.3).
 *
 * Why it exists: the hackathon needs a public repository under an open-source licence, but the
 * monorepo (website, growth plans, legal drafts, owner runbooks) stays private. This writes only
 * what builds and tests the Android app, keeping the monorepo's relative paths so the golden
 * fixtures test still finds `fixtures/domain/`.
 *
 * Safety (SEC-6): every file comes from `git archive HEAD`, so only committed files can be
 * exported; untracked or ignored files (`assistant.env`, `key.properties`, crash logs, local
 * build files) cannot reach the copy whatever the working tree holds. A second lock,
 * `public-export-secrets.mjs`, then scans the result for secret-shaped names and key-shaped
 * strings and deletes nothing: it fails the export, naming file and rule but never the value.
 *
 * What it writes into the empty target folder:
 *   - apps/mobile/ and fixtures/domain/ as committed at HEAD;
 *   - scripts/analytics-lint.mjs (the privacy tripwire, byte for byte from HEAD), its wrapper
 *     and the secret scan, plus a GitHub Actions workflow running them with flutter analyze/test;
 *   - README.md, LICENSE (Apache-2.0, GitHub's copy) and apps/mobile/dart_test.yaml from
 *     scripts/hackathon/public-template/ at HEAD;
 *   - HISTORY.md, generated from `git log` (JUDGE-14);
 *   - the tag `screenshots` on each test file that compares a screenshot golden, because the
 *     goldens stay in the monorepo (JUDGE-6). Nothing else in the app is changed.
 *
 * Usage: node scripts/hackathon/export-public-app.mjs <empty target folder>
 * Owner steps to publish: docs/hackathon/RELEASE_STEPS.md.
 */
import { execFileSync } from "node:child_process";
import { chmodSync, existsSync, mkdirSync, readdirSync, readFileSync, writeFileSync } from "node:fs";
import { dirname, join, resolve, sep } from "node:path";
import { describeFindings, scanForSecrets } from "./public-export-secrets.mjs";

/** Where each archived path lands in the export. Order matters: the first matching prefix wins. */
const PATH_MAP = [
  ["scripts/hackathon/public-template/", ""],
  ["scripts/hackathon/public-export-secrets.mjs", "scripts/secret-scan.mjs"],
  ["scripts/analytics-lint.mjs", "scripts/analytics-lint.mjs"],
  // The native half of the tripwire (Kotlin, Gradle, merged manifests); analytics-lint imports it.
  ["scripts/lib/android-tripwire.mjs", "scripts/lib/android-tripwire.mjs"],
  ["apps/mobile/", "apps/mobile/"],
  ["fixtures/domain/", "fixtures/domain/"],
];
const ARCHIVE_PATHS = [
  "apps/mobile",
  "fixtures/domain",
  "scripts/analytics-lint.mjs",
  "scripts/lib/android-tripwire.mjs",
  "scripts/hackathon/public-export-secrets.mjs",
  "scripts/hackathon/public-template",
];

/** The hackathon submission period opened on this date (rules §4); HISTORY.md starts here. */
const PERIOD_START = "2026-11-11";

/** Tag added to screenshot test files; `apps/mobile/dart_test.yaml` marks it as skipped. */
const SCREENSHOT_TAG = "@Tags(['screenshots'])";

const git = (...args) => execFileSync("git", args, { maxBuffer: 256 * 1024 * 1024 });

/**
 * Reads a POSIX tar stream (as written by `git archive`) and returns its regular files.
 * Handles pax headers for long paths; refuses links, so nothing can point outside the target.
 *
 * @param {Buffer} tar the archive bytes
 * @returns {{path: string, mode: number, data: Buffer}[]}
 */
function readTar(tar) {
  const files = [];
  let pending = {};
  for (let at = 0; at + 512 <= tar.length; ) {
    const head = tar.subarray(at, at + 512);
    if (head.every((b) => b === 0)) break;
    const field = (from, len) => head.subarray(from, from + len).toString("utf8").replace(/\0.*$/s, "");
    const size = parseInt(field(124, 12).trim() || "0", 8);
    const type = String.fromCharCode(head[156] || 48);
    const prefix = field(345, 155);
    let path = pending.path ?? (prefix ? `${prefix}/${field(0, 100)}` : field(0, 100));
    const mode = parseInt(field(100, 8).trim() || "644", 8);
    const body = tar.subarray(at + 512, at + 512 + size);
    at += 512 + Math.ceil(size / 512) * 512;
    if (type === "x") {
      const m = body.toString("utf8").match(/^\d+ path=(.*)$/m);
      pending = m ? { path: m[1] } : {};
      continue;
    }
    pending = {};
    if (type === "g" || type === "5") continue; // global header (commit id), directory
    if (type !== "0") throw new Error(`refusing: ${path} is not a regular file (tar type ${type})`);
    path = path.replace(/\\/g, "/");
    if (path.startsWith("/") || path.split("/").includes("..")) throw new Error(`refusing: unsafe path ${path}`);
    files.push({ path, mode, data: Buffer.from(body) });
  }
  return files;
}

/** Maps an archived path to its place in the export, or null when it is not exported. */
function exportPath(path) {
  for (const [from, to] of PATH_MAP) {
    if (path === from || (from.endsWith("/") && path.startsWith(from))) return to + path.slice(from.length);
  }
  return null;
}

/**
 * Adds the `screenshots` tag to a test file that compares a golden, so `dart_test.yaml` can
 * skip it. Returns the file unchanged when it compares none.
 */
function tagScreenshotTest(path, text) {
  if (!path.startsWith("apps/mobile/test/") || !text.includes("matchesGoldenFile(")) return text;
  if (/^library\b/m.test(text) || text.includes(SCREENSHOT_TAG)) {
    throw new Error(`cannot tag ${path}: it already has a library directive; tag it by hand`);
  }
  const firstImport = text.search(/^import /m);
  if (firstImport < 0) throw new Error(`cannot tag ${path}: no import line`);
  return `${text.slice(0, firstImport)}${SCREENSHOT_TAG}\nlibrary;\n\n${text.slice(firstImport)}`;
}

/** HISTORY.md: the app commits of the submission period, read from git, so it cannot drift. */
function historyFile(commit) {
  const log = git("log", `--since=${PERIOD_START}`, "--date=short", "--format=%h%x09%ad%x09%s", "--no-merges", "HEAD", "--", "apps/mobile")
    .toString("utf8")
    .trim()
    .split("\n")
    .filter(Boolean)
    .map((line) => line.split("\t"));
  const first = git("log", "--reverse", "--date=short", "--format=%h%x09%ad", "HEAD", "--", "apps/mobile")
    .toString("utf8")
    .split("\n")[0]
    .split("\t");
  const rows = log.map(([hash, date, subject]) => `| ${date} | \`${hash}\` | ${subject.replace(/\|/g, "\\|")} |`);
  return `# History of this export

This repository is a one-commit export of femio's private monorepo, made from commit
\`${commit.slice(0, 7)}\` by \`scripts/hackathon/export-public-app.mjs\`. The table below is generated
from that monorepo's \`git log\`: every non-merge commit that changed \`apps/mobile\` since the
#BuildHybridAI submission period opened on ${PERIOD_START}, newest first (${rows.length} commits).
The app's first commit was \`${first[0]}\` on ${first[1]}; the full history is available on request.

| Date | Commit | Change |
|---|---|---|
${rows.join("\n")}
`;
}

function main() {
  const target = process.argv[2];
  if (!target) {
    console.error("usage: export-public-app.mjs <empty target folder>");
    process.exit(2);
  }
  const root = git("rev-parse", "--show-toplevel").toString("utf8").trim();
  const out = resolve(target);
  if (out === resolve(root) || out.startsWith(resolve(root) + sep)) {
    console.error("refusing: the target must be outside the monorepo");
    process.exit(2);
  }
  if (existsSync(out) && readdirSync(out).length > 0) {
    console.error(`refusing: ${out} is not empty`);
    process.exit(2);
  }
  process.chdir(root);
  const commit = git("rev-parse", "HEAD").toString("utf8").trim();
  const dirty = git("status", "--porcelain", "--", ...ARCHIVE_PATHS).toString("utf8").trim();
  if (dirty) console.warn("note: uncommitted changes in exported paths are NOT exported (HEAD only)");

  const files = readTar(git("archive", "--format=tar", "HEAD", "--", ...ARCHIVE_PATHS));
  let tagged = 0;
  let written = 0;
  for (const file of files) {
    const dest = exportPath(file.path);
    if (dest === null) continue;
    let data = file.data;
    if (dest.endsWith(".dart")) {
      const text = data.toString("utf8");
      const next = tagScreenshotTest(dest, text);
      if (next !== text) {
        tagged++;
        data = Buffer.from(next, "utf8");
      }
    }
    const full = join(out, dest);
    mkdirSync(dirname(full), { recursive: true });
    writeFileSync(full, data);
    if (file.mode & 0o111) chmodSync(full, 0o755);
    written++;
  }
  writeFileSync(join(out, "HISTORY.md"), historyFile(commit));
  written++;

  for (const must of ["README.md", "LICENSE", "apps/mobile/pubspec.yaml", "scripts/analytics-lint.mjs", ".github/workflows/ci.yml"]) {
    if (!existsSync(join(out, must))) {
      console.error(`refusing: ${must} is missing from the export (is it committed?)`);
      process.exit(1);
    }
  }
  // Every tripwire file must be byte-identical to HEAD; a missing import made the public CI
  // red on 27 Nov (JUDGE-N2-1), so the list covers what analytics-lint imports.
  for (const file of ["scripts/analytics-lint.mjs", "scripts/lib/android-tripwire.mjs"]) {
    const path = join(out, file);
    if (!existsSync(path) || !readFileSync(path).equals(git("show", `HEAD:${file}`))) {
      console.error(`refusing: the exported tripwire file ${file} is missing or differs from HEAD`);
      process.exit(1);
    }
  }

  const findings = scanForSecrets(out);
  if (findings.length > 0) {
    console.error(`refusing: secret scan found ${findings.length} problem(s); the export folder must not be published.\n${describeFindings(findings)}`);
    process.exit(1);
  }
  console.log(`exported ${written} files from ${commit.slice(0, 7)} to ${out}`);
  console.log(`tagged ${tagged} screenshot test file(s) as skipped; secret scan clean`);
}

main();
