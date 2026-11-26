/**
 * Tests for the public export's secret deny-check (R14.3, SEC-6).
 *
 * Why it exists: a deny-check nobody has seen fail is a promise, not a check. These tests plant
 * secret-shaped files and key-shaped strings in a temporary folder and prove the scan reports
 * them by file, line and rule, never by value, and that placeholders and templates pass.
 * Fake keys are assembled at run time so this file holds no key-shaped string itself.
 *
 * Run: node --test scripts/hackathon/public-export-secrets.test.mjs
 */
import assert from "node:assert/strict";
import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { test } from "node:test";
import { describeFindings, scanForSecrets } from "./public-export-secrets.mjs";

const fakeGoogleKey = "AI" + "za" + "Sy" + "B".repeat(33);

function folder(files) {
  const dir = mkdtempSync(join(tmpdir(), "femio-secret-scan-"));
  for (const [path, text] of Object.entries(files)) {
    mkdirSync(join(dir, path, ".."), { recursive: true });
    writeFileSync(join(dir, path), text);
  }
  return dir;
}

test("secret-shaped files are refused by name", () => {
  const dir = folder({
    "apps/mobile/assistant.env": "FEMIO_FIREBASE_APP_ID=\n",
    "apps/mobile/android/key.properties": "storeFile=x\n",
    "apps/mobile/android/hs_err_pid123.log": "crash\n",
    "upload.jks": "x",
    "svc-service-account.json": "{}",
  });
  try {
    const rules = scanForSecrets(dir).filter((f) => f.line === 0).map((f) => f.rule);
    assert.ok(rules.includes("assistant or ads config"));
    assert.ok(rules.includes("Android signing config"));
    assert.ok(rules.some((r) => r.startsWith("log or crash dump")));
    assert.ok(rules.includes("keystore"));
    assert.ok(rules.includes("service-account credentials"));
  } finally {
    rmSync(dir, { recursive: true, force: true });
  }
});

test("key-shaped strings are found and their values never printed", () => {
  const dir = folder({
    "lib/config.dart": `const k = '${fakeGoogleKey}';\n`,
    "android/key.txt": "storePassword=hunter2hunter2\n",
    "notes.md": "build at C:\\Users\\someone\\femio\n",
  });
  try {
    const findings = scanForSecrets(dir);
    assert.deepEqual(findings.map((f) => f.rule).sort(), ["Google API key", "local Windows user path", "signing password with a value"]);
    const report = describeFindings(findings);
    assert.ok(!report.includes(fakeGoogleKey) && !report.includes("hunter2") && !report.includes("someone"));
    assert.match(report, /lib\/config\.dart:1: Google API key \(value not shown\)/);
  } finally {
    rmSync(dir, { recursive: true, force: true });
  }
});

test("templates and placeholders pass", () => {
  const dir = folder({
    "apps/mobile/assistant.env.example": "FEMIO_FIREBASE_API_KEY=\n",
    "android/key.properties.example": "storePassword=CHANGE_ME\nkeyPassword=CHANGE_ME\n",
    "README.md": "Copy assistant.env.example to assistant.env; sb_secret_xxxxxxxxxxxxxxxxxxxxxxxx is a placeholder.\n",
  });
  try {
    assert.deepEqual(scanForSecrets(dir), []);
  } finally {
    rmSync(dir, { recursive: true, force: true });
  }
});
