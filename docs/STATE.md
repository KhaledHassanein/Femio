# Femio — current state (living document)

**Last updated: 2026-11-27.** Rewrite in place; never add a dated copy. Older versions are in git
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

- **Re-score fixes of 27 Nov (R14.24).** Fable's re-score of eca4eaa: Security 8, Privacy 8, Launch 6, Stages 6.5 (loss 5), AI showcase 6, Polish 7, Devpost 7.5 if Stage One passes. Its six lead-verified findings are fixed (one-step withdrawal from Cloud boost, honest seal and App Check wording, unticked save box, no pregnancy-test prompt after a loss, loss path from Change, judge text naming the current UI and the check call; tripwire covers the check). Still open, owner-only: Lab 0 code from the real phone, Stage One (public repo, APK link, video, submission). Chrome web companion: feasibility given (Option C, 18-28 h), waiting for the owner's choice.

- **Owner requests of 27 Nov built (R14.21–R14.23, ADR-085).** One AI wizard for the AI and Cloud boost with a confirmation and dated, SHA-256-sealed receipts on her phone ("My AI choices", shareable); "Check Cloud boost" names why the cloud call fails (logcat `femio-ai`); Delete needs a ticked acknowledgement; stage moves without reset ("I'm pregnant", "My pregnancy has ended" per MR-35, breastfeeding layer, stage row on Today); "+" offers Ask or Log with a save-to-record prompt; premium icon and dark language page. Owner's real phone: Gemini Nano "not ready" is expected on that model (AICore Nano runs only on supported devices); Cloud boost failure reason comes from the new check. Main 85bbe8e live on femioapp.com (dpl_36gE7fcLoL1uYH4m9w8pFxTsfoht READY); signed `E:/femio-builds/femio-1.0.0.aab` (63.2 MB) and `femio-1.0.0-test.apk` (63.8 MB) built from it: upload key 66:71:…:0B:01, Firebase ids present (dex counts), release smoke green on the emulator (first frame 6.5 s). Owner page Lab 0 = the Cloud boost check. Next: owner runs Lab 0 on the new APK and reports the code.

- **Re-score and gap fixes (2026-11-27, main 45893c4, live).** Six roles re-scored main 3a92a90: security 8, privacy 8, launch 6, stages 6, AI showcase 6, polish 7, Devpost 7.4 only if Stage One passes (`docs/33_REBUILD_V3/audit-2026-11-27-rescore/00-RESCORE.md`). Fixed the same day (PROGRESS R14.20): the signed builds lacked the Firebase ids (rebuilt; Gradle now refuses such a release), the second-pregnancy-after-birth view (CLIN-N2-1), web "Obese" band, health-data recipients and dates, the exporter's tripwire file. Final signed `E:/femio-builds/femio-1.0.0.aab` and `femio-1.0.0-test.apk` built from 45893c4: Firebase ids present (dex counts), upload key 66:71:…:0B:01, smoke green. 56 superseded docs moved to `docs/archive/2026-11/`. **The one owner page is https://claude.ai/artifact/VENwUASzWVAY6oxQiLQFuD** (scores, gaps, Labs 1–7); earlier pages are archive only. Next buildable: rest of R14.20. Owner: Labs 1–3 before 30 Nov 2 pm PT.
- **R14 app lane finished (2026-11-27, owner delegation of 27 Nov).** Done on the hackathon branch and merged with the audit lane: R14.6/R14.6a (AI visible, assistant intro ends onboarding, "+" label baseline), R14.9 (MR-15 sentence wherever a window shows), R14.10 (change stage in Settings), R14.11/R14.12 (clinical P1/P2), R14.18 ("Report this answer" for Play's AI-content policy), R14.19 (Help now on the lock, failed saves shown). Gate: app 1406 tests + analyze clean, `pnpm gate` 0, analytics-lint 0. Merged to main (fad1994) and live on femioapp.com; signed `E:/femio-builds/femio-1.0.0.aab` and `femio-1.0.0-test.apk` built and smoke-tested on an emulator. Next is the owner's upload to the closed test. Owner-only: rows 42 (App Check verdict settings), 43 (phone proof), 46 (movement log), store upload.
- **R14 finishing, judge-audit lane (2026-11-27, owner delegation of 27 Nov).** Branch `claude/judge-audit-bd6d27`, merged into the hackathon branch by that session: R14.2 truth pass, R14.3 public exporter (`docs/hackathon/RELEASE_STEPS.md`), R14.5 video script + Devpost text, R14.13 security (ADR-083, ADR-084), R14.14 wording + tripwire, web parts of R14.4/R14.6. Gates: app 1227 tests, web 783. Open risk: App Check enforcement may refuse Cloud boost on a sideloaded APK (row 42, not verified). Nothing on a real phone yet (R14.1).
- **Judge-style audit and finishing plan (2026-11-26, PROGRESS R14).** Six role reviews at fb45488 in `docs/33_REBUILD_V3/audit-2026-11-26/` (start with `00-FINISHING-PLAN.md`); owner page https://claude.ai/artifact/8SMwHnsBwjoZzULuTAZQXj. Tier 0 before the 30 Nov deadline: prove the AI on a real phone (nothing has run on real Nano or Firebase), fix three false sentences (redaction does not remove names; "no network code" before 11 Nov; the exporter README), fix the public-repo exporter, a judge install path, video from the real phone. Owner's calendar report reproduced: logging a second period drops the stated length (R14.8 waits on owner row 40). Owner rows 40-45.

- **Wave 2 started (2026-11-26, same branch).** Done: the calendar shows the whole cycle (R8.10c, MR-57), a "+" in the bottom bar (R8.29), My health record with schema v3 (R11.0/R11.1, ADR-082), day note (R9.8), CSV export (R9.10), home-screen widget (R9.11, neutral by default). Then R11.2 documents (6b4f3b5) and R11.6 medicines with reminders (takes over R9.4). Then R8.30 store screenshots with the new bar (bef353b) and R8.5+R10.4 patterns (MR-58, MR-59; "Ask my patterns" is R10.4a). Then R8.8 signs by cycle day (no shift is ever marked). Then R8.19 after-birth view (MR-60: the healing bleed stays out of the period list; tools read `Profile.cycleStarts`). Then R8.20 perimenopause (MR-61: ranges while periods come, a caution for any bleeding after a year without one, monthly counts, medicines in the visit summary). Then R14.7 + R14.8 calendar fixes (owner report: only the past period showed): stated length kept until 3 starts (owner ruling 2026-11-26), 36-45 earns a range (MR-03), "irregular" = one range, no past range, empty-state reasons with "add my length", legend only what is drawn, next-month link (`domain/forecast.dart`, `test/r14_calendar_test.dart`). The R14 plan (merged from `claude/judge-audit-bd6d27`, 2026-11-27) is the live queue. Next: R10.5+R10.6, R8.14 loss path. Text she types is isolated with `domain/bidi_text.dart` so ranges never turn around in Arabic.

- **Wave 1 for the initial release 1.0.0 is built (2026-11-25, branch `claude/firebase-hackathon-eligibility-833c52`, not merged).** Owner: ship 1.0.0 with wave 1, the rest as updates. Done: R10.1 boundary closed (693ff35, ADR-081 addendum), R10.2 visit companion, R10.3 transparency and AI ledger, R10.7 Say it over several days (agent branch, merged 1e4fdec), R8.27 signs card (61eadb5) and counted save, R12.1 notification consent (agent branch, merged; remote push deferred), R12.2/R12.3 rating and update prompts, R12.4 SEO, store screenshot 8 = Ask femio, tester kit `docs/store/testers/tester-kit.html`. App gate: analyze clean, 990 tests. Agent worktrees fork from an older commit (4136d24), so merge their branches here and re-render their shots on the merged code. Never run the whole suite (or any older dated test) with `--update-goldens`: run only the new test file. Left for release: the signed .aab (owner's upload key, R4.12), owner actions on the board, then R5.4 closed test. Wave 2 starts at R11.0. Owner/agent board: https://claude.ai/artifact/4BNRwtG7FspkAWsem7AwvB (`items` collection; writes need `if_version`).

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
