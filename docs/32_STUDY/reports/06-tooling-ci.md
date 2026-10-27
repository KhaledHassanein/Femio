# 06. Tooling, guards, CI and generators

Study area: `scripts/**`, root `package.json`, `pnpm-workspace.yaml`, `.npmrc`, `apps/web/package.json`, the `scripts` block of `apps/cms/package.json`, `apps/mobile/pubspec.yaml`, `.github/**`, both `vercel.json` files, `.gitignore`, `AGENTS.md`, `README.md`, `apps/web/README.md`, `apps/mobile/README.md`, `skills/`, `.claude/` (listed; agent files read), `.mcp.json`.
Worktree: `E:\Femio\.claude\worktrees\femio-repo-study-planning-88d7c9`, HEAD `79a0e4f`, date 2026-10-27.
Labels used below: **Checked** = I measured or ran it. **From the docs** = a comment, README or doc says so, and I did not test it. **Hypothesis** = my reading.

## 1. Purpose

This area is the machinery around the code. It holds the small scripts that enforce product rules (no clinical claims in copy, no health data sent to analytics, crisis copy kept in date, design tokens kept in sync), the test runners, the continuous integration pipeline on GitHub (CI), the two Vercel rules that skip unneeded builds, the package settings (pnpm workspace and Dependabot, the bot that opens dependency-update pull requests), the generators that copy design colours and the log vocabulary into the Flutter app, and the packaging of Femio's agent skills. The purpose is that a rule such as "Femio never diagnoses" fails a build instead of depending on memory. A **guard** here is a small Node script that scans files, prints a tick or a cross, and exits 0 or 1. The **gate** is the one local command, `pnpm gate`, that runs the checks in order (section 3). A **ratchet** is a check whose list of known exceptions may only shrink. A **golden fixture** is a shared JSON file of expected answers that both the TypeScript and the Dart maths must reproduce.

## 2. Inventory table

Status key: live = used now by the gate, CI, a deploy or the Flutter app. app-only = guards or serves the closed web tracker (ADR-070). dead = no longer reached. duplicate = a second copy of something. unknown = I cannot tell what it is for from the repo.
Line counts are from `wc -l`.

| path | lines | one-line purpose | status |
|---|---|---|---|
| `package.json` | 42 | Root scripts, including the `gate` chain, and the `engines` line (node >=20) | live |
| `pnpm-workspace.yaml` | 103 | Workspace globs, native build allow-list, security overrides, audit ignore list with review dates | live |
| `.npmrc` | 3 | Peer-dependency leniency for React 19 and Next 15 | live |
| `.gitignore` | 77 | Ignored paths: secrets, build output, `.supabase/`, `.vercel/`, screenshots, the seeded session file | live |
| `.mcp.json` | 8 | Registers the shadcn UI MCP server, pinned to 4.18.0 | live |
| `AGENTS.md` | 19 | Pointer that sends every agent to `CLAUDE.md` | live |
| `README.md` | 25 | Repo map and develop commands (lists `skills/`, `supabase/`, `apps/cms/`) | live |
| `CLAUDE.md` | 84 | Agent constitution. Only the line count was measured here; its text is in session context | live |
| `apps/web/README.md` | 41 | Web app commands, layout and conventions | app-only |
| `apps/mobile/README.md` | 23 | Flutter app: application ID, generated colours, test commands | live |
| `apps/mobile/.gitignore` | not counted | Flutter ignore rules (`.dart_tool/`, `build/`). Read with `head -30` only | live |
| `apps/web/package.json` | 54 | Web scripts (dev, build, lint, typecheck, test, e2e) and dependencies | app-only |
| `apps/cms/package.json` | 40 | CMS scripts (Payload, migrate, role and import tools) | live (until D3) |
| `apps/web/vercel.json` | 7 | Vercel "ignored build step" rule for the web project | live |
| `apps/cms/vercel.json` | 7 | Same rule for the CMS project | live |
| `apps/mobile/pubspec.yaml` | 45 | Flutter dependencies, bundled fonts, lint package | live |
| `.github/workflows/ci.yml` | 226 | CI: `verify` (web), `verify-cms`, `verify-mobile`, `content-urls` (weekly) | live |
| `.github/dependabot.yml` | 43 | Monthly grouped dependency PRs for npm and GitHub Actions. No `pub` (Flutter) entry | live |
| `.claude/settings.local.json` | 29 | Local permissions and output style. Keys read only, not content. Not tracked by git | unknown |
| `.claude/agents/femio-competitor-analyst.md` | 28 | Sonnet subagent definition: competitor benchmarking | live |
| `.claude/agents/femio-content-drafter.md` | 22 | Haiku subagent definition: content drafts with sources | live |
| `.claude/agents/femio-translator.md` | 30 | Haiku subagent definition: Arabic, French and Spanish review | live |
| `.claude/skills/femio-delegation/SKILL.md` | 73 | Rules for splitting work between models | live |
| `.claude/skills/frontend-design/` (2 files) | n/a | Generic design guidance skill | live |
| `.claude/skills/ui-ux-pro-max/` (47 files) | n/a | Local UI and UX search corpus and scripts (never run its `--persist`) | live |
| `.claude/skills/android-reverse-engineering/` (11 files) | n/a | Decompiling APKs. Not Femio work | unknown |
| `.claude/skills/build-mcp-app/` (7 files) | n/a | Building MCP widgets. Not Femio work | unknown |
| `skills/femio-*.skill` (7 files) | binary | Zip packages of the seven Femio skills. Contents match `skills/src` (checked) | duplicate |
| `skills/src/femio-*/SKILL.md` (7 files) | 30 to 47 each | Source text of the seven Femio skills | live |
| `scripts/analytics-lint.mjs` | 190 | Analytics privacy guard | live |
| `scripts/auth/reset-mfa.mjs` | 114 | Manual: clears a staff user's two-step sign-in factors (service key) | app-only |
| `scripts/auth/set-password.mjs` | 76 | Manual: sets a user's password through the admin API (service key) | app-only |
| `scripts/chart-literals-lint.mjs` | 90 | Forbids colour literals in web chart code | app-only |
| `scripts/claims-lint.mjs` | 84 | Forbids diagnose, treat, cure, prevent and contraception words in English copy | live |
| `scripts/content-import.test.mjs` | 254 | Tests the Markdown-to-CMS converter and importer refusals | live (CI only) |
| `scripts/content-lint.mjs` | 565 | Article guard: enforces the authoring brief on 107 drafts | live |
| `scripts/content-lint.test.mjs` | 575 | Breaks each content rule on purpose to prove it fires (39 rules) | live |
| `scripts/content/snapshot-cms.mjs` | 95 | Copies published CMS content into the repo (step 1 of D3) | app-only |
| `scripts/crisis-compliance.mjs` | 98 | Crisis copy: in date, review metadata present, keys match English | live |
| `scripts/db-artifacts-probe.mjs` | 106 | Checks that Supabase tables and columns exist, with the anon key | app-only |
| `scripts/design/generate-topic-art.mjs` | 66 | Writes ten SVG topic covers from the colour tokens | app-only |
| `scripts/design/tokens-parity-lint.mjs` | 202 | Every CSS token is reachable from Tailwind and redefined for dark mode | live |
| `scripts/design/tokens-to-dart.mjs` | 136 | Writes `tokens.g.dart` (Flutter colours) from the CSS. `--check` mode in gate | live |
| `scripts/dev/notifications-rls-check.mjs` | 94 | Live Supabase check of the notification tables | app-only |
| `scripts/dev/partner-sharing-check.mjs` | 242 | Live Supabase check of partner sharing, creates and deletes two accounts | app-only |
| `scripts/dev/print-check.mjs` | 252 | Playwright check that the visit report survives print | app-only |
| `scripts/dev/seed-and-shoot.mjs` | 269 | Creates a throwaway user on the live project and screenshots the web app | app-only |
| `scripts/i18n/client-namespaces-lint.mjs` | 145 | Client-side translation namespaces match what components use | live |
| `scripts/i18n/seed-ui-strings.mjs` | 80 | Manual: loads the message catalogues into the `ui_strings` table (service key) | app-only |
| `scripts/i18n/untranslated-lint.mjs` | 147 | Fails when an Arabic, French or Spanish value equals the English text | live |
| `scripts/lib/article-frontmatter.mjs` | 215 | Strict reader for the article front-matter (the block of fields at the top of each draft). Shared by the linter and importer | live |
| `scripts/lib/markdown-to-lexical.mjs` | 226 | Converts Markdown to the CMS rich-text format (Payload Lexical) | app-only |
| `scripts/mobile/sync-log-vocabulary.mjs` | 257 | Writes the Flutter log terms and labels from the web vocabulary. `--check` in gate | live |
| `scripts/native-readiness-baseline.json` | 4 | Empty exception list for the client medical-logic rule | live |
| `scripts/native-readiness-lint.mjs` | 204 | Client components must not hold medical logic. Name is out of date (see section 8) | live |
| `scripts/persona-branch-lint.mjs` | 142 | No persona-id or life-stage mode branches in components. Baseline is empty | live |
| `scripts/security/rls-audit.mjs` | 200 | Manual pre-release check of row-level security on the live database | app-only |
| `scripts/seo/sitemap-check.mjs` | 99 | Checks the deployed sitemap has articles and no excluded pages | live |
| `scripts/tier1-portability-lint.mjs` | 224 | Tier-1 and tier-2 modules have no framework, alias or clock imports | live |
| `scripts/tools-completeness-lint.mjs` | 105 | Tools screen lists every ToolId and never filters the list | app-only |
| `scripts/vercel/ignore-build.sh` | 33 | Skips a Vercel build when nothing it depends on changed | live |

Folders over 60 files are shown as folder rows above. The rest of `scripts/` is listed one file per row.

## 3. Key modules and responsibilities

**1. The gate (`package.json`, script `gate`).** One `&&` chain, so it stops at the first failure. Steps in order:
1. `typecheck`: TypeScript checks the web app with no output (`tsc --noEmit`).
2. `lint`: ESLint, through `next lint`, in the web app.
3. `test`: Vitest, in the web app. Includes the golden-fixture tests that read `fixtures/domain`.
4. `claims-lint`: forbidden clinical verbs in English copy.
5. `crisis-lint`: crisis copy is approved, in date and in key parity.
6. `analytics-lint`: no health data to analytics, autocapture and recording off, consent fails closed.
7. `content-lint`: 107 article drafts against the authoring brief.
8. `i18n-client-lint`: client translation namespaces match usage.
9. `i18n-untranslated-lint`: no whole namespace left in English.
10. `tokens-parity-lint`: CSS tokens reachable from the Tailwind preset.
11. `tokens-dart-lint`: `tokens.g.dart` matches the CSS (`--check`).
12. `mobile-vocab-lint`: Flutter vocabulary matches the web (`--check`).
13. `native-readiness-lint`: no medical logic in client components.
14. `persona-branch-lint`: no persona or mode branches.
15. `tier1-portability-lint`: tier-1 and tier-2 modules stay portable.
16. `tools-completeness-lint`: Tools screen complete and unfiltered.
17. `chart-literals-lint`: chart colours come from tokens.

What it does not run: `build`, the end-to-end tests, `audit`, `content-lint:test`, `content-import:test`, and anything Flutter. Gate on the Flutter side is therefore absent. **Checked** (`package.json`).

**2. CI `verify` job (`ci.yml`).** Installs with the frozen lockfile, runs `pnpm audit --audit-level high`, then 10 of the gate's 14 lints (all except `tokens-dart-lint`, `mobile-vocab-lint`, `tools-completeness-lint`, `chart-literals-lint`), then `lint`, `typecheck`, `test`, `build`, and Playwright end-to-end tests. The end-to-end run uses the Supabase secrets if present, otherwise a database-free subset. **Checked** (`ci.yml`).

**3. CI `verify-cms` and `verify-mobile`.** `verify-cms` typechecks and builds the CMS and runs `content-import:test` with placeholder environment values. `verify-mobile` runs `flutter pub get`, `flutter analyze` and `flutter test` in `apps/mobile` on Flutter 3.47.5. **Checked** (`ci.yml`).

**4. CI `content-urls` (weekly and on demand).** Resolves every source URL in the drafts (`content-lint:urls`) and checks the deployed sitemap. Kept off the pull-request path on purpose. **From the docs** (`ci.yml` comments). Not run here: it needs the network.

**5. `content-lint.mjs` and `lib/article-frontmatter.mjs`.** The main content guard. The front-matter reader is strict on purpose: it throws with a line number on anything outside the small schema, and the importer uses the same reader so the two cannot disagree. Checks: required keys, fixed values (status draft, byline "PENDING"), slug and canonical URL, length of meta fields, two or more sources with at least one Tier-1, internal links that resolve to real routes, answer-first opening, the "When to see a doctor" section, the red-flag box for emergency topics, claim verbs, the approved fertile-window sentence, no phone numbers, crisis routing, and uniqueness across the set. **Checked** (ran it: 107 drafts pass).

**6. `claims-lint.mjs`.** Whole-word match for diagnose, treat, cure, prevent and contraception in `apps/web/messages/en.json`. It refuses to pass on an empty scan. It reads English only (`SCAN_LOCALES = ["en"]`). **Checked.**

**7. `crisis-compliance.mjs`.** Reads `apps/web/src/lib/crisis/crisis.json`. Approved locales need a reviewer, review date and next-review date, and the same keys as English. The English deadline is 2027-07-23 (from the script's comment). Pending locales must ship no strings. **Checked** (passes; not expired today).

**8. `tokens-parity-lint.mjs` and `tokens-to-dart.mjs`.** The first checks that every colour, radius, shadow, motion and z-index token is mapped into the Tailwind preset and redefined for dark mode. The second resolves CSS `var()` chains and writes Flutter `Color(0x...)` values. Both read `assets/brand/tokens/femio.tokens.css`. **Checked** (parity passes: 77 tokens across 11 families; the Dart check fails on line endings, see section 8).

**9. `mobile/sync-log-vocabulary.mjs`.** Imports `LOG_TERMS` from the web's `vocabulary.ts` and writes Flutter's `log_vocabulary.g.dart`, `log_labels.g.dart` and the `log*`/`flow*`/`opk*` entries of the four ARB translation files (51 terms). Needs Node 22.6 or newer for `--experimental-strip-types`. **Checked** (the content matches; the check fails only on line endings).

**10. `i18n/client-namespaces-lint.mjs` and `i18n/untranslated-lint.mjs`.** The first makes sure every translation namespace a client component uses is shipped to the browser, and that no shipped namespace is unused. The second compares values, not keys: an Arabic, French or Spanish string identical to the English is a failure unless listed in `ALLOWED`. **Checked** (49 namespaces all used; 4,935 comparisons pass).

**11. `native-readiness-lint.mjs` and `persona-branch-lint.mjs`.** The first scans client components (91 found) for four shapes of medical decision: calling tier-1 functions, module-level thresholds, day arithmetic, screener scoring. The second blocks `personaId === "D3"` and `mode === "pregnancy"` style branches under `components/` (118 files scanned). Both pass. **Checked.**

**12. `tier1-portability-lint.mjs`.** For 44 listed modules: no `@/` alias, no framework import, no data-layer import, no `"use client"`, no ambient `new Date()`, no hidden `todayISO()` call. Relative imports must end in `.ts` because Deno (the Supabase Edge Function runtime) does not guess extensions. **Checked** (passes).

**13. `sitemap-check.mjs`.** Fetches `https://femioapp.com/sitemap.xml` and fails if there are no article URLs, no condition URLs, untranslated locale URLs, excluded pages (`/help-now`, `/privacy`, `/terms`) or duplicates. It exists because a 200 response with no articles was cached for an hour in production (comment, P1.6.18). **From the docs.** Not run here: it needs the network.

**14. `vercel/ignore-build.sh`.** Referenced by both `vercel.json` files. Skips a build for Dependabot branches, and skips when `git diff` shows nothing under the listed paths since the last deployment. It builds when there is no previous deployment, which is the safe default. **Checked** (read); behaviour not run.

**15. `pnpm-workspace.yaml`.** The `allowBuilds` list records one decision per native build script (for example `sharp: true`, `@sentry/cli: false`). `overrides` pins patched transitive packages for named advisories. `auditConfig.ignoreGhsas` lists accepted advisories with reasons and review dates. **Checked.**

## 4. Data flow

**Enters the repo area from:**
- Authored files: article drafts (`docs/content/articles/`, 107 files), message catalogues (`apps/web/messages/*.json`), design tokens (`assets/brand/tokens/`), the web vocabulary and types (`apps/web/src/lib/experience/v2/`), crisis copy (`apps/web/src/lib/crisis/crisis.json`), analytics catalogue (`apps/web/src/lib/analytics/`).
- Live services, read by scripts: the Supabase project (anon key in `.env.local` for the `db-artifacts-probe`, `rls-audit`, `dev/*` checks), the CMS at `femio-cms.vercel.app` (read by `snapshot-cms.mjs`), `femioapp.com` (read by `sitemap-check.mjs`), the source URLs in the drafts (read by `content-lint --check-urls`).
- Git history and environment: Vercel passes `VERCEL_GIT_PREVIOUS_SHA` and the branch name to `ignore-build.sh`. CI passes secrets `E2E_SUPABASE_URL` and `E2E_SUPABASE_PUBLISHABLE_KEY` (**Checked**, the only two `secrets.` references in `ci.yml`).

**Stored or written:**
- Generated files in the repo: `apps/mobile/lib/theme/tokens.g.dart`, `apps/mobile/lib/domain/log_vocabulary.g.dart`, `apps/mobile/lib/l10n/log_labels.g.dart`, the four `app_*.arb` files, `apps/web/public/art/*.svg`, `apps/web/src/content/snapshot/`.
- Live Supabase: `reset-mfa.mjs` and `set-password.mjs` change auth users; `seed-ui-strings.mjs` writes the `ui_strings` table; `dev/seed-and-shoot.mjs` and `dev/partner-sharing-check.mjs` create and delete throwaway users and write rows; the end-to-end tests in CI do the same on the live project with a throwaway anonymous user (**From the docs**, `ci.yml`).
- Local only: `.seeded-state.json` (ignored by git), screenshots (ignored), `tmp/`.

**Leaves toward:**
- GitHub Actions (CI logs, check results), Vercel (build or skip decisions), the npm registry (installs), Playwright browser downloads (in CI), Dependabot (pull requests on npm and GitHub Actions).
- Nothing in this area sends health data to a third party at runtime. The analytics guard exists to keep that true for the web app.

**External services named in this area:** GitHub (CI, Dependabot), Vercel (two projects, web and CMS, both in region `dub1`), Supabase (live project, EU region per CLAUDE.md, **From the docs**), `femio-cms.vercel.app` (Payload CMS), `femioapp.com` (public site), the npm registry, Playwright's browser CDN. Not used here: Sentry upload (its build step is disabled in `allowBuilds`), PostHog (only referenced by the analytics guard), Google Fonts (not referenced in this area).

## 5. Dependencies

**What this area reads from elsewhere in the repo (**Checked** by reading the scripts):**
- `apps/web/messages/en.json`, `ar.json`, `fr.json`, `es.json`: claims, untranslated, mobile vocabulary.
- `apps/web/src/lib/crisis/crisis.json`: crisis guard.
- `apps/web/src/lib/analytics/events.ts`, `transport.ts`, `consent.ts`: analytics guard.
- `apps/web/src/lib/experience/v2/types.ts`, `vocabulary.ts`: tools guard, tier-1 guard, mobile vocabulary sync (which imports `vocabulary.ts` directly).
- `apps/web/src/lib/experience/registry/` and listed modules: tier-1 guard.
- `apps/web/src/components/**`: native-readiness and persona guards. `apps/web/src/components/charts` and `lib/charts`: chart guard.
- `apps/web/src/components/tools/tools-screen.tsx`: tools guard.
- `apps/web/src/i18n/client-namespaces.ts`: client namespace guard.
- `apps/web/src/app/[locale]/` route tree: content-lint decides which internal links resolve (`content-lint.mjs:30`).
- `assets/brand/tokens/femio.tokens.css` and `femio.tailwind.preset.js`: token guards and the Dart generator.
- `fixtures/domain/*.json`: read by `apps/web/src/lib/golden-fixtures.test.ts:43` and `apps/web/src/lib/experience/v2/upgrade.test.ts:23`, and by `apps/mobile/test/golden_fixtures_test.dart`. (**Checked.** The script list does not read these fixtures; the tests do.)
- `docs/content/articles/` and the brief `docs/content/CODEX_AUTHORING_BRIEF.md`: content-lint.
- `apps/cms/scripts/import-articles.mjs`: called by `content-import.test.mjs` through `pnpm --filter cms exec payload run`.
- `apps/web/.env.local`: read by the Supabase scripts (these need a real local file and network).

**What imports or calls this area:**
- `package.json` scripts and the `gate` chain: everything in section 3.
- `.github/workflows/ci.yml`: 10 of the gate's 14 lints plus `content-lint:test`, `content-import:test`, `content-lint:urls`, `sitemap-check`.
- `apps/web/vercel.json` and `apps/cms/vercel.json`: `ignore-build.sh`.
- `scripts/lib/article-frontmatter.mjs`: imported by `content-lint.mjs` and, per its header, by the CMS importer (**From the docs**; not opened in `apps/cms`).
- `scripts/lib/markdown-to-lexical.mjs`: imported by `content-import.test.mjs`.
- `apps/mobile/lib/theme/tokens.g.dart` and the vocabulary files: produced here, consumed by Flutter.
- Dependencies in the workspace: the Supabase scripts resolve `@supabase/supabase-js` from `apps/web/package.json` via `createRequire` (`rls-audit.mjs:30`, `reset-mfa.mjs:33`, `set-password.mjs:24`, `seed-ui-strings.mjs:22`). If the web app's dependencies are removed, these break.

## 6. Strings and i18n

- **User-facing strings in this area:** none. Script output is developer-facing English.
- **Language coverage of the guards:** `claims-lint.mjs:15` scans English only (`SCAN_LOCALES = ["en"]`). Arabic, French and Spanish medical wording is not scanned for forbidden claims. That is a real gap, because the forbidden-claim rule applies to every language. **Checked.**
- **Hard-coded translated labels in a guard:** `content-lint.mjs:47-52` holds the two required headings in four languages, copied from the authoring brief. If the brief changes, the lint has to change too.
- **Hand-kept exception lists:** `untranslated-lint.mjs:30-78` (`ALLOWED`) lists the words that are legitimately the same in English (for example "Articles" in French). This is by design (the file says so), but it grows by hand.
- **Flutter strings:** `mobile/sync-log-vocabulary.mjs` copies log labels into the four ARB files (`apps/mobile/lib/l10n/app_*.arb`). The untranslated guard reads only `apps/web/messages`, so the Flutter ARB files are never value-checked for English left in place. **Checked.**

## 7. Tests

**Tests that belong to this area:**
- `scripts/content-lint.test.mjs` (575 lines). Builds a valid article, then breaks one rule at a time and requires the linter to fail. It covers the 39 rules. **Checked:** the self-test passes, printing `all 39 rules fire when broken, and stay quiet when not`.
- `scripts/content-import.test.mjs` (254 lines). Sixteen result lines of converter checks (structure, lists, links, bold, and refusal of tables, code fences, images, raw HTML, a second H1, empty input). **Checked:** exit 0, 16 result lines, all ticks. It is slow locally (about 2.5 minutes), because the importer cases shell out to `pnpm` and Payload. I did not confirm that each importer case is among the 16 lines.
- `scripts/design/`, `scripts/i18n/`, `scripts/mobile/`, `scripts/persona-branch-lint.mjs` and the other guards have no test of their own. Each file says its rule was watched failing once (the persona guard's header, for example), but no committed test proves that.

**Tests this area runs but does not own:**
- Web: 91 `*.test.ts(x)` files and 20 Playwright specs under `apps/web/e2e/`. Not read.
- Flutter: four files in `apps/mobile/test/` (`dates_test.dart`, `day_marks_test.dart`, `golden_fixtures_test.dart`, `screens_test.dart`), 487 lines together. Not run here (no Flutter toolchain checked).

**What I ran in this study (all read-only; nothing written to the repo):**

| check | result |
|---|---|
| claims-lint | pass |
| crisis-compliance | pass |
| analytics-lint | pass |
| chart-literals-lint | pass (3 chart files) |
| i18n client-namespaces | pass (49 namespaces, 398 files) |
| i18n untranslated | pass (4,935 comparisons) |
| tokens-parity-lint | pass (77 tokens) |
| tokens-to-dart `--check` | **fail: line endings** (see section 8). The generated content is identical once CR characters are removed (**Checked** by diff) |
| mobile-vocab `--check` | **fail: line endings**. Passes (51 terms) once CR characters are removed, run from a scratch copy (**Checked**) |
| native-readiness | pass (91 components) |
| persona-branch | pass (118 files) |
| tier-1 portability | pass (44 modules) |
| tools-completeness | pass (10 tools) |
| content-lint (107 drafts) | pass |
| content-lint self-test | pass (39 rules) |
| content-import self-test | exit 0, 16 result lines, slow |

**Not run:** `typecheck`, `lint`, `test` (Vitest), `build`, Playwright e2e, `audit` (network), `sitemap-check` (network), `content-lint --check-urls` (network), `rls-audit`, `db-artifacts-probe` and the `dev/*` checks (need live Supabase), Flutter `analyze` and `test`. These are recorded as **not verified**, not as passing.

**Untested tooling:** `ignore-build.sh` (no test), `sitemap-check.mjs` (needs production), `claims-lint.mjs` (its header says the scan must not pass on nothing, but there is no test that proves it), `analytics-lint.mjs` (no mutation test), `crisis-compliance.mjs` (no mutation test), `tokens-to-dart.mjs` (only the gate), `sync-log-vocabulary.mjs` (only the gate).

## 8. Smells, risks, dead code

Ordered by how much they matter.

1. **The gate fails on this Windows checkout, and the cause is line endings, not content.** `git config core.autocrlf` is `true`. Git stores these files with LF (checked in the blob), but the working tree has CRLF, and the generators write LF. The `--check` modes compare raw text, so they report stale. Affected: `scripts/design/tokens-to-dart.mjs:120-131` (compare at line 125) and `scripts/mobile/sync-log-vocabulary.mjs:234-244` (compare at line 241). **Checked.** CI on Linux would not see this, which is why it has not been noticed there. Fix: normalise `\r\n` to `\n` before comparing in both checks, and add a `.gitattributes` file that forces LF for `*.g.dart`, `*.arb` and `assets/brand/tokens/*`.
2. **CI does not run four of the gate's lints:** `tokens-dart-lint`, `mobile-vocab-lint`, `tools-completeness-lint`, `chart-literals-lint` (compare `package.json` gate with `ci.yml` verify job). **Checked.** A change that breaks the Flutter colour or vocabulary sync can pass CI. The gate catches it only if someone runs it.
3. **The gate has no Flutter step at all.** `pnpm gate` runs nothing on `apps/mobile`. Flutter's checks live only in CI (`verify-mobile`). **Checked.**
4. **An accepted advisory's review date has passed.** `pnpm-workspace.yaml` (auditConfig, first ignored entry) accepts `GHSA-w3rx-r6r6-pgpr` and `GHSA-5p2g-fcmc-qvqq` (image-size parsers that can hang) with the comment "Re-check for 2.0.3 by 2026-09-07 — this is a short date on purpose." Today is 2026-10-27. The entry still silences the audit. **Checked** (date comparison). The header also says the file was reviewed 2026-08-04 with a re-check by 2026-11-04.
5. **The Flutter pubspec makes claims its files do not keep.** `apps/mobile/pubspec.yaml` header says "Pinned exactly, and only versions at least two weeks old (the same release-age rule the web workspace enforces in pnpm-workspace.yaml)." But `flutter_lints: ^6.0.0` and `intl: any` are not exact, and `pnpm-workspace.yaml` and `.npmrc` contain no release-age setting (grep for `minimumReleaseAge` and similar: none). **Checked.**
6. **Dependabot does not watch Flutter.** `.github/dependabot.yml` has entries for `npm` and `github-actions` only; no `pub` ecosystem (grep count 0). **Checked.** Flutter packages get no update pull requests and no security alerts from this file.
7. **CI runs end-to-end tests against the live Supabase project.** `ci.yml` (end-to-end comment) says the product specs "run, against a throwaway anonymous user on the real project." Whether the throwaway users are deleted afterwards is not visible in the repo. **Not verified.**
8. **The sync script needs a newer Node than the repo declares.** `package.json:8` says `"node": ">=20"`, but `--experimental-strip-types` (used by the mobile vocabulary script in the gate) needs Node 22.6 or newer. CI's `verify` job uses Node 22, so CI is fine. **Checked** (the flag in the gate line, `package.json`). Node 20 would fail.
9. **Duplicated env loader.** The same `loadEnv()` function is written four times: `scripts/auth/reset-mfa.mjs:36-43`, `scripts/auth/set-password.mjs:27-34`, `scripts/i18n/seed-ui-strings.mjs:28-35`, `scripts/security/rls-audit.mjs:33-40`. The project rules say "no second copy of the same logic". **Checked.**
10. **`native-readiness-lint.mjs` has the wrong name.** The file's own header says it checks "client-component medical-logic" (R2.7). The CI step is called "Native readiness guard" (`ci.yml`). The name refers to a rule that was replaced in ADR-060. The code is right, the name misleads anyone reading CI.
11. **`persona-branch-lint.mjs:119-126`.** The stale-baseline check reads `RULES[1]` by array index. It works today only because the baseline is empty, so the check never runs. **Checked** (read).
12. **Content lint is welded to the web route tree.** `content-lint.mjs:30` points `APP_DIR` at `apps/web/src/app/[locale]`. A route rename in the web app breaks the content check, and the reverse is also true. **Checked.**
13. **Duplicated brief wording.** `content-lint.mjs:47-52` and `:117-120` repeat the brief's headings and fixed sentences. Two sources of truth for the same words (the brief and the lint). **Checked.**
14. **Forbidden-claim scan covers English only.** `claims-lint.mjs:15`. **Checked.**
15. **Unused import.** `claims-lint.mjs:11` imports `readdirSync` and never uses it. **Checked** (one occurrence in the file).
16. **Production URLs as defaults.** `snapshot-cms.mjs:22` defaults to `https://femio-cms.vercel.app`; `sitemap-check.mjs:18` defaults to `https://femioapp.com`. Harmless today, but a silent run against production is easy to start. **Checked.**
17. **Sensitive values on the command line.** `scripts/auth/set-password.mjs:7-13` documents `NEW_PASSWORD="…"` typed inline in the shell. Shell history keeps that. **Hypothesis** (low severity; the owner is the only user).
18. **Dead path in two configs.** `apps/web/vercel.json:3` and `pnpm-workspace.yaml` (`packages/*`) refer to a `packages/` folder that does not exist. Harmless in `git diff`, but misleading. **Checked** (no `packages/` folder in the worktree).
19. **Leftover file.** `.claude/skills/android-reverse-engineering/scripts/decompile.sh.orig` is tracked by git. **Checked** (`git ls-files`).
20. **Skill zips have no builder.** `skills/femio-*.skill` are copied by hand. Nothing in `scripts/`, `package.json` or `.github` builds them (grep). They match `skills/src` today (**Checked** by unzipping and comparing), so the drift risk is for the next edit.
21. **Action pins are tags, not commit SHAs.** `ci.yml` uses `actions/checkout@v7`, `actions/setup-node@v7`, `pnpm/action-setup@v6`, `subosito/flutter-action@v2`. I could not check that these tags exist from this sandbox. **Hypothesis / not verified.** Tags can be moved; a pinned commit SHA cannot.
22. **The gate chain stops at the first failure.** `package.json` `gate` uses `&&`, so a failure at step 1 hides steps 2 to 17. Acceptable, but the output does not say which steps were skipped. **Checked** (design).
23. **Minor, cosmetic.** `tokens-parity-lint.mjs:186-200` builds messages from multi-line template strings with raw newlines; the output is ugly but correct.
24. **The shebang on `sync-log-vocabulary.mjs:1`** is `#!/usr/bin/env node --experimental-strip-types`. Most systems ignore everything after the first word of a shebang, so the flag is lost if the file is run directly. It works because the gate calls `node --experimental-strip-types` itself. **Hypothesis.**
25. **Outside Femio's scope, inside the repo.** `.claude/skills/android-reverse-engineering/` and `.claude/skills/build-mcp-app/` are generic skills, not Femio work. **Hypothesis** from their names and contents.
26. **Stale ignore pattern.** `.gitignore` mentions `.agents/`, a mirror that does not exist in this worktree. **Checked** (`.agents` absent). Harmless.

## 9. Keep / rebuild / delete verdict

Two directions are judged. **(a)** A static teaser: articles, calculators and SEO pages, no accounts, no database at runtime, which sends people to the app. **(b)** The private Flutter app: records on the phone, no network, no accounts. Verdicts are **keep**, **adapt** or **delete**.

### 9.1 Per script

| script | (a) teaser | (b) Flutter | reason |
|---|---|---|---|
| `analytics-lint.mjs` | adapt: keep as a tripwire that fails on any analytics SDK | adapt: fail on any analytics, crash or ad package in `pubspec.yaml`, and on `INTERNET` in the release manifest | the most important privacy guard; the rule stays, its target changes |
| `auth/reset-mfa.mjs` | delete | delete | staff sign-in recovery; no accounts in v1 |
| `auth/set-password.mjs` | delete | delete | same |
| `chart-literals-lint.mjs` | delete | adapt: check Dart chart widgets for colour literals if charts exist | web chart code only |
| `claims-lint.mjs` | keep; extend to ar, fr, es | adapt: scan `app_*.arb` files | the wording rule applies in every language; the Flutter copy is not scanned today |
| `content-import.test.mjs` | delete (with Payload) | delete | converter for the CMS being retired (D3) |
| `content-lint.mjs` | keep; re-point routes from the web tree to the teaser's routes | delete | the teaser's main safety net for articles |
| `content-lint.test.mjs` | keep with the linter | delete | self-test for the linter |
| `content/snapshot-cms.mjs` | delete after the D3 cutover | delete | copies from the CMS being retired |
| `crisis-compliance.mjs` | keep if the teaser has a help page (content-lint routes to it); otherwise delete | adapt: applies if crisis copy reaches the app; the copy source moves to ARB | expiry and review checks matter for safety copy |
| `db-artifacts-probe.mjs` | delete | delete | checks Supabase tables; no Supabase in either direction |
| `design/generate-topic-art.mjs` | keep if the teaser uses SVG covers; adapt token names | delete | teaser artwork |
| `design/tokens-parity-lint.mjs` | keep only if Tailwind stays; otherwise delete | delete | Tailwind-only check |
| `design/tokens-to-dart.mjs` | keep only if the CSS still feeds the teaser | keep; fix the line-ending comparison | the Flutter colour source |
| `dev/notifications-rls-check.mjs` | delete | delete | live Supabase check |
| `dev/partner-sharing-check.mjs` | delete | delete | live Supabase check that creates and deletes accounts |
| `dev/print-check.mjs` | delete | delete | print of the web visit report |
| `dev/seed-and-shoot.mjs` | delete | delete | screenshots come from Flutter goldens (`flutter test --update-goldens`) |
| `i18n/client-namespaces-lint.mjs` | delete if the teaser has no client-side translation; keep if next-intl stays | delete | only relevant to client-side next-intl |
| `i18n/seed-ui-strings.mjs` | delete | delete | loads a Supabase table for a translation portal |
| `i18n/untranslated-lint.mjs` | keep; re-point at the teaser's catalogue | adapt: compare `app_*.arb` values to `app_en.arb` | the only check that catches English left in Arabic; applies to both |
| `lib/article-frontmatter.mjs` | keep | delete | shared reader for article drafts |
| `lib/markdown-to-lexical.mjs` | delete | delete | Payload-specific rich-text output |
| `mobile/sync-log-vocabulary.mjs` | delete (no Flutter in the teaser) | keep; move the source out of `apps/web` (see open question 8); fix the line-ending comparison; add to CI | keeps the app and the website's vocabulary identical |
| `native-readiness-baseline.json` | delete with its lint | keep only if the Dart port needs it | empty list |
| `native-readiness-lint.mjs` | delete | adapt: port to Dart; scan `lib/` for threshold tables in widgets. Rename it | the rule (no medical logic in screens) still matters |
| `persona-branch-lint.mjs` | delete | delete | no persona branching in v1; revisit if personas return |
| `security/rls-audit.mjs` | delete | delete | tests row-level security on the live database |
| `seo/sitemap-check.mjs` | keep; weekly; point at the teaser's domain | delete | caught a real outage; the teaser is the one that has a sitemap |
| `tier1-portability-lint.mjs` | delete (no Edge Functions in the teaser) | adapt: its idea (the same maths in both languages, bound by golden fixtures) is carried by the fixtures tests; drop the TypeScript-only rules | portability guard for the tier-1 Edge Functions |
| `tools-completeness-lint.mjs` | delete | delete unless a Tools screen survives in Flutter; then port | web-only screen |
| `vercel/ignore-build.sh` | keep; drop `../../packages` | delete | saves build minutes on the teaser |

### 9.2 Per configuration file and workflow

| item | verdict (a) | verdict (b) | reason |
|---|---|---|---|
| root `package.json` `gate` | adapt: keep typecheck, lint, test, claims, content, crisis (if kept), analytics, sitemap in a separate job | adapt: add `flutter analyze`, `flutter test`, the two `--check` steps; a Flutter gate needs its own script | the gate should match the real product |
| `pnpm-workspace.yaml` | keep; review the expired image-size date (section 8, item 4) | delete with the web app (Flutter does not use pnpm) | the allow-list and overrides are the teaser's supply-chain controls |
| `.npmrc` | keep | delete | goes with pnpm |
| `.gitignore` | keep | keep (Flutter ignores already live in `apps/mobile/.gitignore`) | secrets and build output |
| `.mcp.json` (shadcn) | keep only if the teaser stays on shadcn | delete | UI tool for the Next app |
| `.github/workflows/ci.yml` `verify` | adapt: remove the live-Supabase end-to-end run; add the four missing lints; keep audit, build, content-lint self-test | n/a | |
| `ci.yml` `verify-cms` | delete with Payload | n/a | |
| `ci.yml` `verify-mobile` | n/a | keep; add the token and vocabulary checks | the only Flutter check in CI |
| `ci.yml` `content-urls` | keep | n/a | weekly link rot check |
| `.github/dependabot.yml` | keep | adapt: add a `pub` ecosystem entry | Flutter currently gets nothing |
| `apps/web/vercel.json`, `apps/cms/vercel.json` | web: keep; cms: delete with Payload | n/a | |
| `apps/cms/package.json` | delete with Payload | n/a | |
| `apps/mobile/pubspec.yaml` | n/a | adapt: make the pins exact as the header claims, or fix the header | section 8, item 5 |
| `apps/web/README.md` | adapt for the teaser | n/a | |
| `apps/mobile/README.md` | n/a | keep; accurate | |
| `README.md`, `AGENTS.md` | adapt: remove `supabase/` and `apps/cms/` from the repo map once retired | adapt the same way | |
| `skills/src/*/SKILL.md` | keep | keep | |
| `skills/*.skill` | delete, or add a builder script | same | duplicates with no builder |
| `.claude/agents/*` (3) | keep | keep | translator and drafter serve the copy in both directions |
| `.claude/skills/femio-delegation` | keep | keep | |
| `.claude/skills/ui-ux-pro-max` | keep; never run `--persist` (the file says so) | keep | local design corpus |
| `.claude/skills/frontend-design` | keep | keep | |
| `.claude/skills/android-reverse-engineering`, `build-mcp-app` | owner decides | owner decides | not Femio work (section 8, item 25) |
| `.claude/settings.local.json` | leave alone | leave alone | local, not tracked |

### 9.3 Which guards still matter

**(a) Static teaser with no accounts.** Keep, because they guard the main risks (wrong medical wording, unsafe crisis copy, dead or empty sitemap, wrong copy in a language): `claims-lint` (all four languages), `content-lint` and its self-test, `untranslated-lint`, `crisis-compliance` (if a help page stays), `sitemap-check` (weekly), `analytics-lint` as a tripwire (the teaser should send nothing), `ignore-build.sh`, the audit, Dependabot, and the typecheck, lint, test and build steps. Add: an accessibility check (the web dependencies already include `@axe-core/playwright`) and a full link check (`content-lint --check-urls` already exists; it only runs weekly). Drop: everything about accounts, Supabase, the CMS, Edge Functions, tier-1 and tier-2 maths, personas, tools, and charts.

**(b) Flutter private app.** The guards that matter are the ones on the product's real logic and copy: `tokens-to-dart` (colours), `sync-log-vocabulary` (log terms and labels), the golden-fixture tests on both sides (the maths twins), `flutter analyze` and `flutter test`, the claims rule applied to `app_*.arb`, the value check applied to the ARB files, and a privacy check that fails if the release manifest requests `INTERNET` or if `pubspec.yaml` gains an analytics, crash or ad package. **Checked** today: the release `AndroidManifest.xml` has no `uses-permission` at all, and `INTERNET` appears only in the debug and profile manifests (the usual Flutter setup). That is good, and worth turning into a guard. Nothing in the gate covers Flutter yet (section 8, item 3).

## 10. Open questions

1. **One gate or two?** Should `pnpm gate` also run the Flutter checks, or should there be a separate `flutter` command? Owner decision.
2. **Line endings on Windows.** Confirm `git config --global core.autocrlf` is `true` on the owner's machine. If so, the fix in section 8, item 1 (normalise in the checks and add `.gitattributes`) is needed before `pnpm gate` can be green here.
3. **Should the four gate-only lints run in CI?** I assume yes (tokens-dart, mobile-vocab, tools, chart). Confirm.
4. **Does the CI end-to-end run clean up its throwaway users on the live project?** Not visible in the repo. Check the Supabase project's user list or the test's teardown.
5. **When is Supabase switched off?** This decides whether about ten scripts (`rls-audit`, `db-artifacts-probe`, the three `dev` checks, `set-password`, `reset-mfa`, `seed-ui-strings`) are deleted now or kept until the switch.
6. **When is the Payload CMS retired (D3)?** `snapshot-cms.mjs`, `content-import.test.mjs`, the `verify-cms` job and the CMS `package.json` depend on it.
7. **Does the teaser stay on Next.js?** This decides whether `client-namespaces-lint`, `tokens-parity-lint`, `.mcp.json` and the shadcn setup stay.
8. **Where should the Flutter log vocabulary's source live?** It is `apps/web/src/lib/experience/v2/vocabulary.ts`. If the website's app code is closed or removed, the source needs a new home (a plain JSON file both sides read would be the usual answer).
9. **Accepted advisories.** The image-size exception's review date passed on 2026-09-07. Renew it, or find a fix?
10. **The `.skill` zip files.** Who installs them? Should there be a builder, or should the zips go?
11. **The two non-Femio skills** (`android-reverse-engineering`, `build-mcp-app`). Keep them in this repo?
12. **Should a guard enforce that the release manifest never gains `INTERNET`?** Checked to be true today.
13. **Pin the GitHub Actions to commit SHAs?** I could not verify the tags exist from this sandbox.
14. **Not verified here:** `pnpm audit` results, the web typecheck, lint, Vitest and build, the Playwright run, and `flutter analyze` and `flutter test`. These should be run once on a machine with network access and the toolchains installed.
