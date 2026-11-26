#!/usr/bin/env node
/**
 * Secret deny-check for the public femio repository (R14.3, SEC-6).
 *
 * Why it exists: the public copy of the app is built from `git archive HEAD`, so untracked files
 * such as `assistant.env` or `key.properties` cannot be in it. This is the second lock: it walks
 * the exported folder and fails if any file is secret-shaped by name, or any text holds a
 * key-shaped string. It never prints a matched value: only the file, the line number and the
 * name of the rule, so the report itself cannot leak what it found.
 *
 * The exporter calls `scanForSecrets()` before it reports success. The same file ships in the
 * public repo as `scripts/secret-scan.mjs`, where CI runs it on every push, so a secret
 * committed there later fails the build too.
 *
 * Usage: node public-export-secrets.mjs <folder>   (exit 1 on any finding, 2 on bad usage)
 */
import { readdirSync, readFileSync, statSync } from "node:fs";
import { basename, join, relative } from "node:path";
import { fileURLToPath } from "node:url";

/** Folders never walked: version control and build output, which the export never contains. */
const SKIP_DIRS = new Set([".git", ".dart_tool", "build", ".gradle", "node_modules"]);

/** File names that must never be published. A name ending in `.example` is a template and passes. */
export const SECRET_FILE_RULES = [
  ["assistant or ads config", /^(assistant|ads)\.env$/],
  ["dotenv file", /^\.env(\..+)?$/],
  ["Android signing config", /^key\.properties$/],
  ["local SDK paths", /^local\.properties$/],
  ["keystore", /\.(jks|keystore|p12|pfx)$/i],
  ["private key or certificate", /\.(pem|key|der|p8)$/i],
  ["Firebase client config", /^(google-services\.json|GoogleService-Info\.plist)$/],
  ["service-account credentials", /(service[-_]?account|credentials).*\.json$/i],
  ["SSH key", /^id_(rsa|dsa|ecdsa|ed25519)(\.pub)?$/],
  ["provisioning profile", /\.mobileprovision$/i],
  ["log or crash dump (may hold environment variables)", /(\.log$|^hs_err_pid)/i],
  ["machine-specific Flutter file", /^(Generated\.xcconfig|flutter_export_environment\.sh|\.flutter-plugins(-dependencies)?)$/],
];

/**
 * Key-shaped strings. Each pattern is written so placeholders (CHANGE_ME, YOUR_KEY, xxxx) do not
 * match: a real key has length and entropy that a placeholder does not.
 */
export const SECRET_TEXT_RULES = [
  ["Google API key", /AIza[0-9A-Za-z_-]{35}/],
  ["private key block", /-----BEGIN [A-Z ]*PRIVATE KEY-----/],
  ["service-account JSON", /"type"\s*:\s*"service_account"|"private_key"\s*:\s*"-----/],
  ["Firebase Android app id", /\b1:\d{6,}:android:[0-9a-f]{8,}\b/],
  ["GitHub token", /\b(ghp|gho|ghu|ghs|ghr)_[A-Za-z0-9]{30,}\b|\bgithub_pat_[A-Za-z0-9_]{40,}\b/],
  ["Anthropic key", /\bsk-ant-[A-Za-z0-9_-]{20,}/],
  ["OpenAI-style secret key", /\bsk-(proj-)?[A-Za-z0-9]{32,}\b/],
  ["Stripe-style live key", /\b(sk|rk)_live_[0-9A-Za-z]{16,}\b/],
  ["AWS access key", /\bAKIA[0-9A-Z]{16}\b/],
  ["Slack token", /\bxox[abprs]-[0-9A-Za-z-]{10,}\b/],
  ["Supabase secret", /\bsb_secret_(?!x+\b)[A-Za-z0-9_-]{20,}\b/],
  ["JSON web token", /\beyJ[A-Za-z0-9_-]{10,}\.eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}/],
  ["signing password with a value", /\b(storePassword|keyPassword)\s*=\s*(?!CHANGE_ME\b|YOUR_|<)[^\s#]{4,}/],
  ["local Windows user path", /\b[A-Za-z]:[\\/]+Users[\\/]+[^\\/\s"']+/],
  ["private owner folder", /[\\/]_Private[\\/]/],
];

/** Extensions read as binary and skipped by the text rules (names are still checked). */
const BINARY_EXT = /\.(png|jpe?g|webp|gif|ico|ttf|otf|woff2?|zip|jar|so|a|pdf|mp4|riv|bin)$/i;

/**
 * Walks `root` and returns every finding as `{ file, line, rule }`. `line` is 0 for a file-name
 * finding. No matched text is ever returned.
 *
 * @param {string} root folder to scan
 * @returns {{file: string, line: number, rule: string}[]}
 */
export function scanForSecrets(root) {
  const findings = [];
  const walk = (dir) => {
    for (const entry of readdirSync(dir)) {
      const full = join(dir, entry);
      const st = statSync(full);
      if (st.isDirectory()) {
        if (!SKIP_DIRS.has(entry)) walk(full);
        continue;
      }
      const rel = relative(root, full).replace(/\\/g, "/");
      const name = basename(entry);
      if (!name.endsWith(".example")) {
        for (const [rule, re] of SECRET_FILE_RULES) {
          if (re.test(name)) findings.push({ file: rel, line: 0, rule });
        }
      }
      if (BINARY_EXT.test(name)) continue;
      const bytes = readFileSync(full);
      if (bytes.subarray(0, 8000).includes(0)) continue; // binary content
      const lines = bytes.toString("utf8").split("\n");
      lines.forEach((text, i) => {
        for (const [rule, re] of SECRET_TEXT_RULES) {
          if (re.test(text)) findings.push({ file: rel, line: i + 1, rule });
        }
      });
    }
  };
  walk(root);
  return findings;
}

/**
 * Formats findings for a log without their values.
 *
 * @param {{file: string, line: number, rule: string}[]} findings
 * @returns {string}
 */
export function describeFindings(findings) {
  return findings.map((f) => `  ✗ ${f.file}${f.line ? `:${f.line}` : ""}: ${f.rule} (value not shown)`).join("\n");
}

if (process.argv[1] && fileURLToPath(import.meta.url) === process.argv[1]) {
  const root = process.argv[2];
  if (!root || !statSync(root, { throwIfNoEntry: false })?.isDirectory()) {
    console.error("usage: secret-scan.mjs <folder>");
    process.exit(2);
  }
  const findings = scanForSecrets(root);
  if (findings.length > 0) {
    console.error(`secret scan FAILED: ${findings.length} finding(s)\n${describeFindings(findings)}`);
    process.exit(1);
  }
  console.log("✓ secret scan: no secret-shaped file and no key-shaped string");
}
