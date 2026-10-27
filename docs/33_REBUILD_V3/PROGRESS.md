# 33 — v3 progress

The checkpoint ledger for `00_PLAN.md` §2. **Update it in the same commit as the work.**
Marks: `[ ]` open · `[~]` in progress · `[x]` done (commit) · `[BLOCKED]` · `[DEFERRED]`.
Every "done" names its evidence: a test count, a screenshot folder, a deployed URL.

## R0 · Foundation

- [x] R0.1 · Twelve-area study, merged knowledge graph (1,066 nodes) with an offline viewer, synthesis, plan (`98ff819`)
- [x] R0.2 · `.gitattributes` LF on every OS; the two generator guards pass on Windows (`25c1377`)
- [x] R0.3 · `CLAUDE.md` rewritten for v3; `AGENTS.md`, `README.md`; tool notes to `docs/runbooks/TOOLS.md`; superseded plans bannered (`afe8988`)
- [x] R0.4 · Role packs: product scope + medical rules register, design spec, legal pack, growth pack (`401c26f`)
- [x] R0.5 · The closed web tracker, Supabase, Payload, Sentry, PostHog and the service worker removed; privacy tripwire replaces the analytics guard; CI without the CMS job and the live-database run; old tracker URLs redirect to `/app` (`fdbbc1f`). Evidence: `pnpm gate` green (502 tests), `flutter test` 61 passing, `pnpm build` with three env vars
- [ ] R0.6 · `docs/STATE.md` rewritten in place for v3; DECISIONS gets ADR-072 (v3 direction: tracker deleted, no database, calendar calculators)
- [ ] R0.7 · Trim the 44 dead message namespaces once the app's ARB strings own their copy (today the vocabulary generator still reads six of them)

## R1 · Brand surface

- [ ] R1.1 · `scripts/brand/generate-icons.mjs`: favicon.ico (16/32/48), PNG 16/32, apple-touch-icon 180, android-chrome 192/512 + maskable, Android adaptive icon layers and splash, from `assets/brand/logo/femio-app-icon-dusk.svg`
- [ ] R1.2 · Logo wordmark and lockups recoloured to plum-600; the violet `icon.svg` and `public/icons/app-icon.svg` replaced; `manifest.webmanifest` back with Dusk colours and the PNG set
- [ ] R1.3 · OG image 1200×630 per locale (`scripts/brand/render-og.mjs`) wired into `openGraph.images`
- [ ] R1.4 · Tokens JSON regenerated from the CSS; Tailwind preset font names fixed; Dart gets type, space and radius tokens
- [ ] R1.5 · iOS app icon set from the Dusk source (kept dormant)

## R2 · Web teaser

- [x] R2.1 · **Calculators rebuilt on an interactive calendar** (02_DESIGN_SPEC §2): tap the day, the result draws on the same grid; Saturday-first and Hijri labels in Arabic (Umm al-Qura, display only); steppers that never clamp; "no confident window" outside 21–35 days (MR-06/08); the mandated fertility sentence and strip line under every window (MR-15/16); term-window bar that never fills (MR-24); red-flag box under the pregnancy week (MR-29); WAI-ARIA grid with one tab stop and visual-direction arrow keys; local "today" (MR-11). Evidence: `testing-results/2026-10-27-calendar-calculators/` (7 calculators × en/ar × light/dark), 516 unit tests, 57 e2e
- [ ] R2.2 · Month strip for the pregnancy calculators (a jump without a dropdown, §2.3) and the `multi` mode's "tap the first day of each period" month stack from the earliest start
- [ ] R2.3 · Article template: real red-flag boxes (danger alert for "Seek care now:" quotes), hand-off card at the end, honest reviewer labels (name only where the owner reviewed; "editorially checked, clinician review pending" elsewhere); fix the three strings that claim every guide is reviewed
- [ ] R2.4 · Legal pages from `03_LEGAL_PACK.md` (EN + AR; FR/ES from EN), indexable; help-now with the sourced Egypt and Saudi numbers
- [ ] R2.5 · Home and Learn hub copy for the wedge (Arabic-first messages from `04_GROWTH_PACK.md` §1); the `/app` page says what ships
- [ ] R2.6 · Static export (`output: "export"`) or confirm the static build on Vercel; Lighthouse ≥ 95 mobile; sitemap/OG/JSON-LD per `04` §6
- [ ] R2.7 · Keyboard and screen-reader pass on the calendar with a real screen reader (NVDA) recorded in `testing-results/`

## R3 · Content pipeline

- [ ] R3.1 · Reviewer, status and locale into `docs/content/articles/*.md` frontmatter from the snapshot's 25 names; a guard that fails a published article without them
- [ ] R3.2 · `packages/content`: build script Markdown → JSON for both apps; the website reads it instead of `src/content/snapshot`
- [ ] R3.3 · Reading-level check (validated Flesch-Kincaid) in the gate for the wedge set
- [ ] R3.4 · PCOS depth set (lifestyle, insulin resistance, treatment options to discuss, hair and skin) drafted by the content drafter, reviewed by the clinician reviewer (Opus), cited
- [ ] R3.5 · Arabic for the wedge's top set (Ramadan set + the ten most-asked TTC/pregnancy questions): drafts, Arabic medical editor pass, owner "publish"
- [ ] R3.6 · Supabase project paused and the CMS Vercel project deleted (owner action in `OWNER_ACTIONS.md`; the repo no longer references either)

## R4 · App v1

- [ ] R4.1 · Encrypted store (AES-GCM, key in Android Keystore), schema version read and migrated, corruption quarantine, serialised writes; `FemioStore` interface kept
- [ ] R4.2 · Backup export/import (a file she saves herself) and app lock; `allowBackup=false` + `dataExtractionRules`
- [ ] R4.3 · Settings (language, Hijri, lock, backup, reminders, delete with confirmation); confirm before "Start over"
- [ ] R4.4 · Local reminders (notifications package pinned); the onboarding reminders step
- [ ] R4.5 · Learn tab from `packages/content` (EN + AR), Lexical/Markdown renderer with red-flag boxes
- [ ] R4.6 · Tools tab; medical rules out of `today_screen.dart` into `domain/` with fixtures (seek-help clock MR-13/14, test timing, week-36 ordering)
- [ ] R4.7 · Fertile window per MR-06/07/08 in Dart (shared fixture with the web's `fertileWindow`); the app calendar's marks aligned to the web vocabulary (rose dotted next period, saffron ovulation dot)
- [ ] R4.8 · Crisis entry (header), wellness disclaimer, the mandated fertility sentence, the sourced red-flag list (MR-29), under-18 by full birth date
- [ ] R4.9 · Hijri secondary dates (Umm al-Qura package pinned, bound to `fixtures/domain/hijri.json`)
- [ ] R4.10 · Split onboarding (589 lines), Today (478) and Log (317); file headers and docstrings; spacing/radius tokens
- [ ] R4.11 · Release signing (key outside git), App Bundle build; Flutter in the root gate (`pnpm gate:mobile`) and the claims/untranslated guards over the ARB files
- [ ] R4.12 · Release candidate on the owner's phone (owner action 1)

## R5 · Launch

- [ ] R5.1 · Play listing AR/EN from `04_GROWTH_PACK.md` §4, feature-gated lines removed for what did not ship
- [ ] R5.2 · Data safety and Health apps declaration answers from `03_LEGAL_PACK.md` §4
- [ ] R5.3 · A-to-Z launch guide (user-guide skill, offline HTML + Markdown) and the ASO pack delivered
- [ ] R5.4 · Closed test (12 testers × 14 days); fix round; production access
- [ ] R5.5 · Soft launch, first-100-women plan running

## Session log

| When | What | Commit |
|---|---|---|
| 2026-10-27 | Study, plan, constitution, tracker removal, calendar calculators | see above |
