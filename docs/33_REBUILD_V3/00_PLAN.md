# 33 — Femio v3: the rebuild plan (opened 2026-10-27)

**Status: active. This supersedes `docs/30_REVAMP/03_REVAMP_PLAN.md` §5 and `docs/31_RESET/02_SPEC_V1_DRAFT.md`.**
It rests on the study in `docs/32_STUDY/00_SYNTHESIS.md`. The owner's direction of 2026-10-27:
*take over professionally, clean everything from the database to the favicon, keep the content,
not the UI, document everything, no review gates block the build, local storage only, the website
is a teaser with calculators and articles that rank and send women to the app.*

## 0 · The team and who signs what

| Role | Model | Owns in this plan |
|---|---|---|
| Chief of staff, full-stack and Flutter engineer | Fable 5.1 (lead session) | The plan, every merge, every architecture call, all code |
| Product owner + clinical lead | Sonnet 5.5 | `01_PRODUCT_SCOPE.md`: scope lock, SWOT, medical rules register |
| Product designer | Opus 5.5 | `02_DESIGN_SPEC.md`: Dusk Bloom v3 for web + app, the calendar calculator, icon set |
| Privacy and legal counsel | Sonnet 5.5 | `03_LEGAL_PACK.md`: policy, terms, Play answers, regulatory note, crisis numbers |
| Growth (SEO, ASO, Arabic social) | Opus 5.5 | `04_GROWTH_PACK.md`: keyword map, store listing, first 100 women |
| Clinician reviewers | Opus 5.5 | Review notes on wedge articles (`docs/content/reviews/`) |
| Arabic medical editor | Sonnet 5.5 | Arabic string and article passes (`delegated/`) |
| QA and release | Sonnet 5.5 | `05_RELEASE_RUNBOOK.md` and the A-to-Z launch guide |
| UX researcher | Fable 5.1 | After the soft launch |

The lead reviews every delegated output before it lands; nothing medical, architectural or legal
is merged on a subagent's word alone.

## 1 · What v3 is

Two deliverables, one content source, zero servers that hold a woman's data:

1. **`apps/mobile`** — the private Android app (Flutter). Encrypted record on the phone, user-saved
   backup, app lock, local reminders, the reviewed library inside the app (EN + AR), TTC → pregnancy
   tools with PCOS awareness, Hijri secondary dates. Google Play.
2. **`apps/web`** — a static teaser (Next.js, static export, Vercel, no database): home, Learn hub,
   100 articles (EN; AR as reviewed), 5 condition hubs, 7 calculators with an **interactive
   calendar** as the input, `/app`, legal pages, help-now, search from a static index. Every page
   sends the woman to the app for the full product.
3. **`packages/content`** — one build step from `docs/content/articles/*.md` (frontmatter carries
   reviewer, status, locale) to the JSON both apps read.

Gone: the closed web tracker, Supabase at runtime, Payload, the CMS Vercel project, PostHog, the
web PWA/service worker, the `ui_strings` portal.

## 2 · Phases and sequence

| Phase | Work | Done when |
|---|---|---|
| **R0 · Foundation** (lead) | Study committed; plan; docs that contradict fixed (`CLAUDE.md`, STATE, README); `.gitattributes` LF; gate split web/mobile; Flutter in CI | `pnpm gate` and `flutter test` green on main; one direction in every doc |
| **R1 · Brand surface** (lead + designer) | Dusk logo set, favicon set (ico, 16/32, 180, 192/512 maskable), OG image, Android adaptive icon + splash, manifest colours from tokens; tokens JSON regenerated from CSS; Tailwind preset fonts fixed; Dart gets type/space/radius tokens | Every icon on every surface is Dusk; `tokens-dart-lint` passes on Windows |
| **R2 · Web teaser** (lead) | Delete the tracker (routes, components, libs, namespaces, e2e); env without Supabase; `ui_strings` overlay removed; calculators rebuilt on an interactive calendar (tap a day → the window draws on the same calendar; trimester bar; Hijri label in AR); article template with real red-flag boxes; legal pages from `03`; sitemap/OG/JSON-LD; static export; Lighthouse ≥ 95 mobile | Zero network calls to Supabase (checked with the e2e guard); screenshots 390×844 EN/AR light/dark |
| **R3 · Content pipeline** (lead + reviewers + Arabic editor) | Reviewer metadata into frontmatter; build script → JSON; reading-level check in the gate; the wedge set reviewed (TTC 11, pregnancy 4, PCOS 4 + new PCOS depth); Arabic for the wedge's top set | Both apps read `packages/content`; CMS and Supabase retired (report 05 §10.2) |
| **R4 · App v1** (lead) | Encrypted store + migrations + quarantine; backup export/import; app lock; local reminders; Settings; Learn tab from the content package; crisis route; wellness disclaimer and the mandated fertility sentence; Hijri; confirm-before-reset; split the three big files; medical rules out of screens into `domain/` with fixtures; release signing; `allowBackup=false`; CI for Flutter | 61 → ~150 tests; release AAB on the owner's phone |
| **R5 · Launch** (lead + QA + growth) | Play listing AR/EN, Data safety and Health declaration, closed test with 12 testers, A-to-Z guide, ASO pack, first-100-women plan | Guide delivered; store listing text final; owner has the APK |

## 3 · Dates (default; the owner moves them)

Release candidate 9 Nov 2026 → closed test 11–25 Nov → soft launch the week of 30 Nov (D5).
What moves it: the release candidate slipping, or the closed test starting late. Google's
production-access review time is `[NEEDS CHECK]`.

## 4 · Rules the rebuild keeps (unchanged)

The six product rules in `CLAUDE.md`; the safety thresholds in `docs/compliance/*` (registered in
`01_PRODUCT_SCOPE.md` §4); Dusk Bloom (`docs/32_STUDY/reports/09-plans-architecture.md` §7); the
rejected patterns (no rings, no single date, no late counter, no verdicts, no photos of people, no
Arabic-Indic digits, no transliterated wordmark); the twin-logic discipline (same fixtures in TS and
Dart); never `git add -A`; small Conventional Commits; every "done" links evidence.

## 5 · What is explicitly out until after the soft launch

iOS, billing, partner sharing, cloud sync, AI chat, community, menopause and postpartum tools
beyond articles, a second language beyond EN + AR for new content (FR/ES stay for the UI only).
