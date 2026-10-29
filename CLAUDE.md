# CLAUDE.md — Femio v3 (read this first, every session)

You are working on **Femio**, a women's-health product by a Cairo physician. **Read `docs/STATE.md`
first** (short: where we are, the loop, the traps). **The live plan is `docs/33_REBUILD_V3/00_PLAN.md`**;
its ledger is `docs/33_REBUILD_V3/PROGRESS.md` and **the first open line there is the work.** The
study the plan rests on is `docs/32_STUDY/00_SYNTHESIS.md`. Anything only Khaled can do is in one
file: `docs/runbooks/OWNER_ACTIONS.md`. Khaled is the only human in every role; sessions do everything
else and proceed on the recommended default.

## What Femio is (decided 2026-10-07, confirmed 2026-10-27)

1. **A private Android app** (`apps/mobile`, Flutter): her records live **only on her phone**, no
   accounts, no server, no analytics SDK. She saves her own backup file. Google Play, then iOS later.
2. **A website that is the app's front door** (`apps/web`, Next.js, static, no database): 100 cited
   articles, 5 condition hubs, 7 calculators with an interactive calendar, legal pages, help-now.
   Every page sends her to the app for the full product.
3. **One content source** (`docs/content/articles/*.md` → `packages/content` JSON) read by both.

**Wedge:** Arabic-first, **trying to conceive → pregnancy**, with **PCOS** depth, **Saudi Arabia +
Egypt**. Four UI languages (EN/AR/FR/ES, RTL-native); new content ships EN + AR. The long-term
ambition (one record for her whole health life) stays the direction, not the launch scope.

## Non-negotiable product rules (these gate every feature)
1. **Wellness / education / tracking ONLY.** Never diagnose, treat, prevent disease, or act as a way
   to avoid pregnancy. This keeps Femio outside medical-device scope. Screeners = "a screen, discuss
   with your clinician."
2. **Personalise, never restrict.** The experience adapts emphasis and tools; every article and tool
   stays reachable.
3. **Uncertainty-honest predictions.** Ranges + confidence, never a single certain date, never a
   "late" counter in irregular modes, "no confident window" when cycles vary too much.
4. **Privacy by design.** Health data never leaves the phone. The website measures visits only
   after consent and never what she typed (ADR-075). The app has no analytics and no network
   code of its own; its only ads are Google's banners on the guide screens, non-personalised,
   fed nothing about her (ADR-076), and femio Plus removes them.
5. **One constant record, additive layers.** A life-stage change re-layers the experience over an
   unchanged record; never rebuilds or deletes.
6. **Arabic and RTL are first-class.** Western digits in Arabic (ADR-069); Hijri shown beside
   Gregorian where dates appear (stored Gregorian); the wordmark is always the Latin **femio**, also
   inside Arabic prose.

## The architecture rule (ADR-070)
**The specification owns decisions; the clients run it.** Every medical threshold, wording rule and
prediction rule lives in `docs/33_REBUILD_V3/01_PRODUCT_SCOPE.md` §4 (the medical rules register)
and in code **only** under `apps/mobile/lib/domain/` and `apps/web/src/lib/`, bound by the shared
golden fixtures in `fixtures/domain/`. **Never inline a threshold in a screen.** A golden-fixture
failure is the system working: read what changed and edit the fixture by hand.

## Tech stack
Flutter 3.47+ (Android first) · Next.js 15 + TypeScript strict + Tailwind + next-intl, static export
on Vercel · design tokens in `assets/brand/tokens/femio.tokens.css` (canonical) generated into the
Tailwind preset, the JSON mirror and `apps/mobile/lib/theme/tokens.g.dart` · pnpm 11 workspace ·
no database, no CMS, no analytics SDK. Payments later: Google Play Billing (an Egyptian seller
cannot use Stripe or LemonSqueezy). Design language: **Dusk Bloom** (reference:
`docs/32_STUDY/reports/09-plans-architecture.md` §7; rejected patterns in §7.8: no rings, no single
date, no late counter, no verdicts, no photos of people, no stock violet).

## Repo map
```
CLAUDE.md · AGENTS.md (pointer) · README.md
docs/STATE.md                 ← READ FIRST
docs/33_REBUILD_V3/           ← THE PLAN: 00_PLAN, 01_PRODUCT_SCOPE, 02_DESIGN_SPEC, 03_LEGAL_PACK,
                                 04_GROWTH_PACK, 05_RELEASE_RUNBOOK, PROGRESS
docs/32_STUDY/                ← the study: 12 reports, knowledge graph (graph/index.html), synthesis
docs/30_REVAMP/ docs/31_RESET/ ← superseded plans, kept for the record (04_ANDROID_APP_SPEC still useful)
docs/compliance/              ← safety thresholds and wording rules (binding), legal intake
docs/content/articles/        ← the content source (Markdown + frontmatter)
docs/personas/                ← 73 persona specs (C6, C1, D1, B6 define the wedge)
docs/DECISIONS.md · CHANGELOG.md · 07_MASTER_TODO.md (historical queue) · runbooks/OWNER_ACTIONS.md
apps/mobile/                  ← the product (Flutter)
apps/web/                     ← the teaser site (Next.js)
packages/content/             ← built JSON content (generated; do not edit by hand)
fixtures/domain/              ← golden fixtures shared by TS and Dart
assets/brand/                 ← tokens, logo, icon sources
scripts/                      ← guards, generators (see docs/runbooks/TOOLS.md)
```

## Governance
- **Every task gets a line** in `docs/33_REBUILD_V3/PROGRESS.md` the moment it is identified;
  statuses `[ ] [~] [x](commit) [BLOCKED] [DEFERRED]`; nothing is silently dropped.
- **An ADR** (`docs/DECISIONS.md`) is for a decision that cost something or that a future session
  could reverse by accident. A commit message is for everything else.
- **Session protocol:** open → `docs/STATE.md`, then PROGRESS, mark `[~]`; during → add new tasks
  at once; close → mark done with evidence, CHANGELOG if user-visible, update `STATE.md` in place.
- **Stopped mid-item?** Commit to `wip/<item-id>` with a `wip:` message, never to `main`. Check
  `git branch --list "wip/*"` at the start of every session.
- **Every "done" links evidence**: a test run, a screenshot at 390×844 (light, dark, Arabic), or a
  deployed URL. Say whether a number is from a synthetic fixture or real use.
- Commit messages end with `Co-Authored-By:` naming the model that did the work. Stage files by
  name, never `git add -A`.

## Skills and delegation
Generic: `project-governance`, `engineering-standards`, `localization`, `user-guide`. Femio:
`femio-engineering-standards`, `femio-design-system` (tokens in `docs/12` are superseded by the
CSS), `femio-medical-content`, `femio-compliance-privacy`, `femio-i18n-workflow`, `femio-seo-aso`,
`femio-docs-agency`, `femio-delegation`. Delegation: Haiku for inventories, translation QA and
drafts; Sonnet for product, legal, QA and complex reads; Opus for design, clinical review, growth.
The lead reviews every output; medical logic, architecture, merges and releases are never delegated.
Tool notes (shadcn MCP, ui-ux-pro-max corpus): `docs/runbooks/TOOLS.md`.

## How to work here
1. `docs/STATE.md` → `docs/33_REBUILD_V3/PROGRESS.md` → first open item → `[~]`.
2. Build the whole item: all four UI locales, tests, the gate (`pnpm gate` for web; `flutter analyze
   && flutter test` for the app).
3. Verify the way it can actually fail (a rendered page, an injected fault, the deployed site).
4. Judge every UI change at **390×844**, light and dark, in Arabic. The screenshot is the test.
5. Small commits = restore points. Update PROGRESS in the same commit.
6. Never invent medical facts: cite Tier-1/2 or flag `[NEEDS SOURCE]`.
