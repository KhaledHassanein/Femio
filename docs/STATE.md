# Femio — current state (living document)

**Last updated: 2026-11-25.** Rewrite in place; never add a dated copy. Older versions are in git
history and `docs/archive/`.

## ▶ Resume prompt

> Read `CLAUDE.md`, then this file, then `docs/33_REBUILD_V3/PROGRESS.md`. The first open item
> there is the work. The plan is `docs/33_REBUILD_V3/00_PLAN.md`; the study it rests on is
> `docs/32_STUDY/00_SYNTHESIS.md` (do not re-study). Owner items go in
> `docs/runbooks/OWNER_ACTIONS.md`, never in chat. Build one item, gate it, photograph every UI
> change (390×844, light, dark, Arabic), commit with the reasoning in the message, and update
> `PROGRESS.md` in the same commit. Khaled is the only human in every role; proceed on the default.
>
> First, run `git branch --list "wip/*"`. A branch there means the last session stopped mid-item.

## Where things stand (2026-10-28)

- **Wave 1 for the initial release 1.0.0 (2026-11-25, branch `claude/firebase-hackathon-eligibility-833c52`, not merged).** Owner: ship 1.0.0 with wave 1, the rest as updates. Done: R10.3 "What the AI can see" (04c4333), web launch SEO pass R12.4 (9450300), R8.3 Ask femio pill (eb088c7), R8.6/R8.7/R9.1 pregnancy by week (356b4a2), R8.4 stage examples (b52590f), R9.6 + R10.13 calendar explainers (e9ad86d). App gate: analyze clean, 859 tests. Never run the whole suite with `--update-goldens` and commit the result: it rewrites older dated evidence and the store images; run only the new test files. Next in order: R10.2 + R8.27 visit companion, R10.3 rest (tip "why", AI ledger), R10.7, R12.1, R10.1 rest; R8.10b blocked on a source. Owner/agent board: https://claude.ai/artifact/4BNRwtG7FspkAWsem7AwvB (`items` collection; writes need `if_version`).

- **Deploy 2026-11-25 (main 2bdbe7c).** The registry (R7.14), content revision (R3.10) and calculators (R13) branches merged on top of the website upgrade; gate green (app 735 tests, web 751 + all guards); live on femioapp.com: home, /app and the four new calculator pages return 200 in en, ar, fr and es (24 pages checked). Renumbered on merge: calculators R11→R13, MR-52..54→MR-53..55, content owner action 37→39.

- **Website shows the app as it stands (R2.10, 2026-11-25).** Merged into `main` with the hackathon branch (b09bf3f, owner's go-ahead) and live on femioapp.com since 2026-11-25 (dpl_8U7STc8dKH3SCBcLnX7s6wYbkvJp). `/app` and home gain a tour of real app screens, three demos on synthetic data (next periods, Say it, Ask femio) and "what can leave this phone"; app sentences are synced from the ARB (`app-strings-lint` in the gate). Until owner action 31 (enable Vercel Web Analytics) is done, pages log a 404 for the analytics script.

- **Content revision (R3.10, 2026-11-25).** Merged 2026-11-25 from `claude/content-revision-i18n-9938ae`. Every guide and UI string revised in English (plain words, wellness-only, femio wordmark, Ramadan guide withdrawn, stricter safety boxes) and carried into AR/FR/ES; no catalogue keys changed. Record and the owner's clinical list: `docs/33_REBUILD_V3/research/CONTENT_REVISION_2026-11.md` (owner action 39).

- **Calculators and mini tools (R13, 2026-11-25).** Merged 2026-11-25 from `claude/calculators-mini-tools-8afeee`. Website: due date by every method (last period with cycle length, conception, IVF day 3/5, dating scan), a pregnancy week-by-week calendar, the IOM weight-gain range and a session-only contraction timer. App: the first three under Learn > Calculators, saving nothing. New rules MR-53 (scan dating), MR-54 (calendar), MR-55 (IOM 2009) with shared fixtures `due-date`, `pregnancy-calendar`, `weight-gain` and scan cases in `edd-from`. Not built, with reasons: PROGRESS R13.0. Open for the owner: a no-score "PCOS visit checklist" (D-04 bars a screener).

- **Persona feature review (2026-11-24).** Market researcher + business development + lead synthesis in `docs/33_REBUILD_V3/research/PERSONA_FEATURES_2026-11.md` (owner page https://claude.ai/artifact/6debjUMkBygKcNuQntDW8T). 23 accepted features are `R8.1`–`R8.23` in PROGRESS (waves A/B/C; wave A = the owner's ten requests); R8.24 = the femio Plus decision (feeds R7.12). Key finding: the 37 week-by-week pregnancy guides already exist in four languages with fixed sections, so the weekly view is assembly. No code changed.

- **Ask femio coverage (R7.13–R7.14, 2026-11-24/25).** Registry 89 → 299 entries, every passage checked word for word; on a synthetic set of 419 questions strong answers went 45% → 99%, "not covered" 82 → 4. "Do I have X?" gets a fixed clinician sentence first (MR-52). Report: `docs/33_REBUILD_V3/research/REGISTRY_COVERAGE_2026-11.md`. Nothing open; three topics have no allowed source (listed there).

- **Privacy hardening (ADR-080, 2026-11-24).** No ads in the app (AdMob removed, ad-ID permissions removed); no GTM/GA4/Meta on the website (Vercel Web Analytics instead; AdSense stays after consent); Cloud boost ships opt-in with per-purpose explicit consent and a dated, versioned receipt; privacy policy and consumer health data policy rewritten ×4; review and DPIA in `docs/compliance/PRIVACY_REVIEW_2026-11-24.md`. Owner actions 29–36 (lawyer review before the Play release).

- **Hybrid AI assistant for #BuildHybridAI (ADR-078, 2026-11-24; deadline 2026-11-30).** Merged into `main` 2026-11-25 (cabfd26) and live on the website. Built: domain core (`lib/domain/assistant/`), Kotlin bridge to Firebase AI Logic with App Check, Say it / Ask femio / Visit summary / Settings → Assistant in four languages, tripwire rules, public export script, Devpost texts. **ADR-079 (2026-11-24):** Ask femio answers only from a bundled trusted-source registry (offline, cited, "not covered" when no passage); Google Search grounding removed; Cloud boost is opt-in with a consent screen and sends only a `CloudPrompt`; personal tips and persona visit questions come from a reviewed catalogue; red flags MR-49/MR-50. 630 tests, gate green, debug APK builds. Owner guide: `docs/hackathon/OWNER_GUIDE.html`. Persona gaps: R7.9. Positioning is now "AI-assisted women's health & wellness" across life stages (ADR-078 §8, R7.7). **Not yet run against real Firebase or Gemini Nano:** owner actions 23–28 first.

- **Sign-off pass 2026-10-30 (ADR-077).** All 121 guides are published and name Dr. Khaled M. as reviewer; no `[NEEDS SOURCE]` remains; the legal pages name the sole proprietorship and register number. Owner actions 3, 7 and 9 are closed. **Library parity 2026-10-30:** 110 guides in each of EN, AR, FR and ES, plus the five condition pages and the author bio in all four; glossary and FAQ pages are still hidden (R3.9). Live on femioapp.com since 2026-10-30 (`73cb541`, checked: register number on `/en/privacy`, reviewer line and no "review pending" on five sampled guides).

- **Direction (ADR-072, 2026-10-27).** The private Android app (`apps/mobile`) is the product; the
  website (`apps/web`) is a static front door with calendar calculators and the guides. The web
  tracker, Supabase, Payload, Sentry, PostHog and the service worker are **deleted from the tree**;
  the website needs three public env vars and makes no network call of its own.
- **Merged to `main` and deployed 2026-10-28** (owner's go-ahead): `femioapp.com` serves the v3
  site (deployment `dpl_DXjSKZgmrjRp7wP4nNwpF2xJfqND`, commit `0965a65`). The `femio-cms` Vercel
  project now fails every build because `apps/cms` is gone; deleting it is owner action #4.
- **The main checkout at `E:\Femio` holds uncommitted edits** to the Android build script,
  manifest and `MainActivity.kt` that are not from this work. Look before touching them.
- **Done in v3 so far:** study + knowledge graph; constitution refresh; tracker removal; privacy
  tripwire; calendar calculators (R2.1); article template + legal pages + help-now numbers
  (R2.3, R2.4); wedge copy, calculator SEO and FAQ schema (R2.2, R2.5); Dusk icon set, OG images,
  Android adaptive icon and splash (R1.1–R1.3); the repo-native content pipeline, ten Arabic guides
  and four PCOS guides (R3.1, R3.2, R3.4, R3.5 part); Flutter refactor (R4.10); sealed record,
  backup, PIN lock, Settings, no-backup rules, release signing from a key outside git (R4.1–R4.3,
  R4.11 partly); local reminders (R4.4); Learn tab with the guides offline (R4.5); fertile window
  and seek-help clock as domain rules with shared fixtures (R4.6 part, R4.7); Help now in the app
  (R4.8); Hijri dates from a generated ICU table, ADR-073 (R4.9); every medical rule out of the
  screens with twin fixtures (R4.6); the mobile gate with vocabulary, untranslated-copy, claims
  and crisis guards (R4.11); the live-site audit with Lighthouse and the SEO fixes it found
  (R2.6); the reading-level guard over the wedge guides (R3.3); the paste-ready Play listing and
  data-safety answers in `docs/store/` (R5.1, R5.2); the calculator pages prerendered and the Arabic UI
  font preloaded (R2.6 closed); the keyboard pass on the calendar automated (R2.7, NVDA left to the
  owner); 32 dead message namespaces and 21 orphan web libs deleted with a dead-module guard (R0.7,
  R0.8); the pregnancy warning signs on their own sourced screen and the 18+ gate as a domain rule
  with the D-01 question (R4.8 closed); **every Arabic link on the live site fixed** (R2.8, ADR-074:
  the i18n config had returned `ar-u-nu-latn` as the locale since 2026-08-22). Ledger:
  `docs/33_REBUILD_V3/PROGRESS.md`. **Growth operations opened** (R6, `docs/34_GROWTH_OPS/`): the
  post-launch agent team, measurement and consent design, ads + premium strategy, owner guide A–J,
  competitor benchmark, interactive owner checklist; **ADR-075 accepted 2026-10-28**: the consent
  defaults + Tag Manager loader + closed event list are built (`apps/web/src/lib/consent/`) and
  render nothing until the owner sets `NEXT_PUBLIC_GTM_ID` in Vercel (owner guide parts C–E);
  the routines R1–R7 exist as files (`docs/34_GROWTH_OPS/routines/`). Live on femioapp.com since
  2026-10-30 (`0442199`, deployment `dpl_48oj2B9yzdPb6LUFqWaW2bM2RHdF`): the pregnancy red-flag
  sentence with seven signs (R4.14), help-now with sixteen countries and official sources (R6.16),
  the Tag Manager container fix, flags in the switcher and the global positioning copy (R6.15b), on
  top of the sign-off pass and library parity; measurement and ads stay off until the ids are set.
  The app (R6.17 help screen, R4.14 card) ships with the next app build.
  **Dashboard audit 2026-11-01 (R6.18):** every ticked step on the go-live dashboard was checked and the
  checked ones archived (db field `verified`); the Play listing exists in four languages, the sixteen store
  screenshots render from the real screens (`store_screenshots_test.dart`); main is at `0d2bf25`
  (deployment `dpl_A4VaNqccj2yWUPKGN3SjLh6HKJur`, no visible site change), the release candidate built and signed with the upload key (0.5.0+5; APK `apps/mobile/build/app/outputs/flutter-apk/app-release.apk`, bundle `…/bundle/release/app-release.aab`, Google test ads since `ads.env` is absent). Waiting on the
  owner: install the candidate, NVDA notes, Tag Manager re-import, the feedback form link, the routines go-ahead.
  **Go-live pass 2026-10-29:** AdSense is built behind `NEXT_PUBLIC_ADSENSE_CLIENT` + three slot ids
  (`apps/web/src/lib/ads/`, units filled only after `ad_storage` is granted, `/ads.txt`); the CSP now
  opens the Google/Meta/AdSense hosts only when the ids are set (before this fix the deployed CSP
  would have blocked the Tag Manager loader the day the id was set); the Play Billing spike proved
  the app can carry `in_app_purchase` without INTERNET (two `tools:node="remove"` lines; tripwire
  reads the merged manifest). **ADR-076 accepted the same evening: ads inside the app too** (his
  line: her health data never leaves the phone; the ads SDK may). R6.13 puts AdMob banners on
  the Learn index and article screens only, non-personalised, with `femio Plus` removing them;
  the tripwire now checks "no network code of our own, SDK only under `lib/features/ads/`, no
  personal permission" instead of "no INTERNET"; the privacy notice, Data safety answers and
  listing say what the SDK sends. The owner's whole go-live path is the dashboard
  (https://claude.ai/artifact/V3exHDJpZasUkRoWuameDp, source in `docs/34_GROWTH_OPS/dashboard/`):
  68 steps in 9 phases, a "needs from you" queue sessions append to (`requests.json`), a log.
- **Open before a release candidate:** R4.12 needs the owner's keystore (owner action 2); the NVDA
  listening session (owner action 8); R3.5 rest (only the three owner decisions of owner action 9 and the
  clinician sign-off remain; the editor's 99 rows are applied); owner action 10 (a source for bleeding and reduced movements on the
  red-flag list, or leave them off). Lighthouse run 3 (2026-10-28, before the links fix): home 93,
  calculator 97, article 100, English home 96; SEO 100 on all four.
- **Health:** `pnpm gate` green (689 web unit tests + 22 guards, 24 e2e); `flutter analyze` clean, 507 Dart tests. Flutter 3.47.8
  on this PC (upgraded 2026-10-27). Debug APK on the Android 16 emulator: Arabic onboarding → Today →
  Learn → article → Help now walked by hand 2026-10-28 (`testing-results/2026-10-28-app-settings-lock/`);
  the 18th-birthday question and the warning-signs screen at 390×844 in both themes and languages
  (`testing-results/2026-10-28-r48-age-redflags/`, rendered by `test/r48_screenshots_test.dart`).
- **Supabase project** is still restricted (402) and still exists; the repo no longer references
  it. Pausing it and deleting the CMS Vercel project are owner actions.
- **Content:** `docs/content/articles/*.md` is the source (103 EN, 10 AR, 4 PCOS); the build writes
  `packages/content` for the web and `apps/mobile/assets/content/<locale>.json` for the app.
  The PCOS treatment guide waits for the clinician (owner action #7).
- **Wordmark:** Latin `femio` everywhere, also inside Arabic prose; `scripts/wordmark-lint.mjs`
  fails the gate on the transliteration.

## The working loop

1. **Take** the first open item in `docs/33_REBUILD_V3/PROGRESS.md`. Mark it `[~]`.
2. **Build** the whole item, including all four UI locales and its tests.
3. **Gate:** `pnpm gate` for the web; `cd apps/mobile && flutter analyze && flutter test` for the
   app. When a guard fails, fix the code, never the rule.
4. **Verify** the way the change can actually fail: a rendered page at 390×844 (the shoot scripts
   under `apps/web/scripts/`), `flutter test --update-goldens test/screens_test.dart` for app
   screens, the deployed site for anything that only breaks in production.
5. **Record** the line in `PROGRESS.md` and this file in place. An ADR only when the decision
   cost something or could be reversed by accident.
6. **Commit** with explicit paths (never `git add -A`).
7. **Next item.**

**Stopped mid-item?** Commit the dirty tree to `wip/<item-id>` with a `wip:` message saying what
is built, what is not, and the next action. Never commit ungated work to `main`.

## Environment traps that have each cost real time

- **Editing an ARB file by hand leaves the vocabulary guard red.** `scripts/mobile/sync-log-vocabulary.mjs`
  writes 136 keys into `apps/mobile/lib/l10n/app_*.arb` and its `--check` compares whole files,
  formatting included. After any ARB edit: run the sync script (it normalises the file), then
  `flutter gen-l10n`, then `pnpm mobile-vocab-lint`. Same after any edit to the web catalogs it reads.
- **Line endings are LF everywhere** (`.gitattributes`). If a generator guard fails with no
  visible diff, that is the first thing to check.
- **`pnpm install` can hang silently on this PC** (two instances were found stuck for an hour).
  Kill `pnpm.mjs` node processes and re-run with `--reporter=append-only`.
- **Measurement goes through `lib/consent/events.ts` or not at all.** The tripwire fails any
  other `dataLayer.push` and any other file naming the Tag Manager host; every event and
  parameter is on the allow-list in that file, and values that look like dates or prose are
  refused. Never pass a calendar day, a cycle length or a result to `track()`.
- **A commit that touches only `docs/content` + `packages/content` must still deploy.** Vercel's
  ignored-build step (`apps/web/vercel.json`) lists the paths the site depends on; `packages` was
  missing until 2026-10-28 and a content release was silently skipped. Check the deployment state,
  not just the push.
- **Never run `pnpm build` while a server is on :3000**; they share `apps/web/.next`. Check the
  port first (`netstat -ano | grep :3000`). Playwright under `CI=1` starts its own `next start`
  and fails if the port is taken; without `CI` it reuses what is there.
- **A full-page screenshot places `position: fixed` elements at the initial viewport origin**, so
  the crisis lifebuoy appears to overlap mid-page content. Artifact, not defect.
- **Arabic number ranges reverse under bidi** ("20 – 15"): wrap the dash in left-to-right marks
  (`use-calculator-format.ts`). Any new "a – b" string with digits needs the same.
- **The i18n config locale must be a route (`ar`, never `ar-u-nu-latn`).** next-intl 4 builds every
  `Link` href from it; the formatting tag broke every Arabic link for two months (ADR-074). Western
  digits are pinned by `numbering.test.ts`, not by the locale. Still branch on the language part.
- **A Tailwind utility with no theme entry emits nothing**, silently (`border-divider` did). Check
  the preset map before anything else.
- **The i18n catalogs are JSON parsed by every guard**; re-serialising with 2-space indent is
  safe, but `apps/mobile/lib/l10n/*.arb` must keep `@key` metadata beside placeholder strings.
- **Bash heredocs with nested quotes fail on this machine.** Write a script file and run it.
- **flutter_secure_storage 11 and file_picker 13 changed their APIs** (no
  `encryptedSharedPreferences`; static `FilePicker.pickFiles`/`saveFile`; `readAsBytes()`). Read
  the pub cache at `E:\pub_cache\hosted\pub.dev\<pkg>` rather than memory.
- **A medical constant in a client component fails `native-readiness-lint`**, even a trimester
  boundary. Constants live in `lib/calculators` and are imported.
- **The screens golden test is slow** (fonts, 50+ captures): run it in the background with a
  long timeout; it writes `apps/mobile/test/screenshots/` (ignored).

## Verification honesty

Guards have caught real errors in this project's own work, repeatedly, including in this rebuild
(the native-readiness guard on the term bar; the vocabulary guard on a catalog edit). **Watch a new
guard fail before trusting it.** When a guard fails, fix the code; do not narrow the rule. Say
whether a number comes from a synthetic fixture or from real use.
