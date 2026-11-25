#!/usr/bin/env node
/**
 * Exports the public, app-only copy of femio for #BuildHybridAI (ADR-078 §7).
 *
 * Why it exists: the hackathon needs a public repository under an open-source licence, but the
 * monorepo (website, growth plans, legal drafts, owner runbooks) stays private. This copies only
 * what builds and tests the Android app, keeping the monorepo's relative paths so the golden
 * fixtures test still finds `fixtures/domain/`, and refuses to copy any secret.
 *
 * Usage: node scripts/hackathon/export-public-app.mjs <empty target folder>
 * The licence file itself is added by GitHub when the repository is created with
 * `gh repo create --license apache-2.0`, so the full Apache-2.0 text is GitHub's own copy.
 */
import { cpSync, existsSync, mkdirSync, readdirSync, statSync, writeFileSync } from "node:fs";
import { basename, join, relative } from "node:path";

const target = process.argv[2];
if (!target) {
  console.error("usage: export-public-app.mjs <empty target folder>");
  process.exit(2);
}
if (existsSync(target) && readdirSync(target).length > 0) {
  console.error(`refusing: ${target} is not empty`);
  process.exit(2);
}

/** Folders and files that never leave the private repo: build output, local config, secrets. */
const SKIP_DIRS = new Set(["build", ".dart_tool", ".gradle", ".idea", ".kotlin", "Pods", ".symlinks", "ephemeral"]);
const SKIP_FILES = [/^ads\.env$/, /^assistant\.env$/, /^key\.properties$/, /^local\.properties$/, /\.jks$/, /\.keystore$/, /^\.env/, /google-services\.json$/];

const copied = [];
function copyTree(from, to) {
  mkdirSync(to, { recursive: true });
  for (const entry of readdirSync(from)) {
    const src = join(from, entry);
    const dst = join(to, entry);
    if (statSync(src).isDirectory()) {
      if (!SKIP_DIRS.has(entry)) copyTree(src, dst);
    } else if (!SKIP_FILES.some((re) => re.test(entry)) || entry.endsWith(".example")) {
      cpSync(src, dst);
      copied.push(relative(target, dst));
    }
  }
}

copyTree("apps/mobile", join(target, "apps/mobile"));
copyTree("fixtures/domain", join(target, "fixtures/domain"));

const leaked = copied.filter((f) => SKIP_FILES.some((re) => re.test(basename(f))) && !f.endsWith(".example"));
if (leaked.length > 0) {
  console.error(`refusing: secret-shaped files copied: ${leaked.join(", ")}`);
  process.exit(1);
}

writeFileSync(
  join(target, "README.md"),
  `# femio: AI-assisted women's health and wellness (Android)

femio is a private period, fertility, pregnancy and menopause companion. Her record lives only on
her phone: no account, no server, no analytics. This repository is the Android app, entered in
Google's #BuildHybridAI hackathon. Licence: Apache-2.0.

## Hybrid AI, drawn on one line

| Runs on the phone (Gemini Nano, \`ONLY_ON_DEVICE\`) | May use the cloud (\`ONLY_IN_CLOUD\`, Google Search grounding) |
|---|---|
| "Say it in your words": a sentence becomes log entries | "Ask femio": a general health question she approves |
| Visit summary: orders the doctor questions from her log | Answers shown only when a source is on a trusted list (WHO, NHS, CDC, ACOG...) |
| Rewrites a personal question as a general one | Every source and Google's search suggestions shown |

- Safety rules run before any model, in four languages: danger signs open help, and femio never
  advises on birth control (\`lib/domain/assistant/safety.dart\`).
- The only door to the cloud is the \`CloudSafeText\` type, made only by
  \`lib/domain/assistant/redaction.dart\`.
- Firebase lives in Kotlin only (\`android/app/src/main/kotlin/com/femioapp/femio/assistant/\`),
  with App Check (debug provider in debug builds, Play Integrity in release).
- Without Gemini Nano or without Firebase config, every feature still works on rules.

## Build

1. Flutter 3.47 or later, Android SDK, JDK 17.
2. Copy \`apps/mobile/assistant.env.example\` to \`apps/mobile/assistant.env\` and fill in your
   Firebase project's Android app ids (Firebase AI Logic enabled, Gemini Developer API).
3. \`cd apps/mobile && flutter test && flutter run\`. In debug builds, register the App Check
   debug token printed in logcat in the Firebase console.
`,
);
console.log(`exported ${copied.length} files to ${target}`);
