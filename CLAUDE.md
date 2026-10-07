# CLAUDE.md — Femio V2 (read this first, every session)

You are working on **Femio**, a women's-health platform. **The live workstream is the 2026-10 revamp: `docs/30_REVAMP/`** (read `00_README.md`, one page). **Read `docs/STATE.md` first.** It is short and carries the resume prompt, the working loop, the gate and the environment traps. Then read `docs/30_REVAMP/PROGRESS.md`; the first open line is the work. Everything that needs Khaled (decisions, keys, legal, reviews) is in **one file: `docs/runbooks/OWNER_ACTIONS.md`**.

## What Femio is
One account for a woman's **whole health life** — puberty → cycles → conditions → TTC/IVF → pregnancy → postpartum → perimenopause → menopause — with referenced medical content, honest predictions, and verifiable privacy. 4 languages (EN/AR/FR/ES, RTL-native). **Mobile is the destination; web is also a real product** — Android via **Flutter**, then iOS, over the same backend (ADR-060). The public content site and CMS are *support functions*: they bring people to the app. Positioning & strategy: `docs/00_EXECUTIVE_SUMMARY.md`, `docs/05_PRODUCT_STRATEGY_PLAN.md`.

## Non-negotiable product rules (these gate every feature)
1. **Wellness / education / tracking ONLY.** Never diagnose, treat, prevent disease, or act as contraception. This keeps Femio out of medical-device (FDA SaMD / EU MDR) scope. Screeners = "screening, discuss with your clinician."
2. **Personalize, never restrict.** UI adapts emphasis/tone/tools per persona; every article & tool stays reachable. (Teen mode gates only ads/social/data, never knowledge.)
3. **Uncertainty-honest predictions.** Ranges + confidence, never a single certain date, never a "late" counter in irregular modes.
4. **Privacy-by-design.** Health data = special category. No ad/analytics-SDK access to health data; explicit granular consent; export/delete; EU hosting. GDPR + Saudi/UAE PDPL + Egypt 151/2020.
5. **Constant EMR, additive layers.** One record spans life; a state change re-layers content/home/alerts over an unchanged core — never rebuilds or deletes.
6. **Arabic/RTL is first-class** for UI & content — but the **brand logo wordmark is always English "femio"** (never transliterated).

## Tech stack (decided — see docs/DECISIONS.md)
Next.js 15 + TypeScript + Tailwind + shadcn/ui + next-intl (EN/AR/FR/ES, RTL) + PWA. Supabase (Postgres + RLS + auth, EU region). Payload CMS for content. **Flutter for Android/iOS (ADR-060 — supersedes the Capacitor plan).** Headless Shopify for store (Phase 3). Design tokens already built — wire Tailwind to `assets/brand/tokens/femio.tailwind.preset.js` and import `assets/brand/tokens/femio.tokens.css` globally.

## The architecture rule that governs new code (ADR-060/061, `docs/24`)
**The backend owns decisions; the clients render them.** Anything medical — thresholds, red-flag sets, persona rules, alert cadences, screener scoring — lives in tier 1 (Supabase Edge Function) or tier 2 (twin TS/Dart implementations bound by shared golden fixtures), **never inline in a screen**. Personas reach the UI as a versioned `ExperienceConfig` document rendered through a module registry — **never as a `mode ===` branch**. Every screen written the old way before R2 is a screen that gets rewritten after it.

## Repo map
```
docs/
  STATE.md                                   # ← READ FIRST: short living state, gate, traps
  30_REVAMP/                                 # ← THE PLAN: audit, market research, revamp plan, PROGRESS
  00_EXECUTIVE_SUMMARY … 06_TECH_STACK      # Phase-0 strategy pack
  07_MASTER_TODO.md                          # the live queue (one line per item)
  07_MASTER_TODO_ARCHIVE.md                  # completed work, verbatim — search by ID
  08_PERSONA_TAXONOMY_AND_ADAPTIVE_UX.md     # ~73 personas taxonomy + Z1 fallback
  09_MASTER_ADAPTATION_MODEL.md              # the "brain": wizard→resolver→state, transitions
  10_FIGMA_UX_FLOWS.md                        # FigJam board links
  11_NEEDS_SOURCE_CHECKLIST.md               # 454 medical-review flags (P0.22, DEFERRED)
  12_BRAND_DESIGN_TOKENS.md                   # brand + token system spec
  13_LEGAL_COMPLIANCE.md                      # (P0.12) legal foundation
  14_SYSTEM_ARCHITECTURE.md                   # (P1.1) ERD/RLS/API/i18n — build gateway
  22_APP_UI_ARCHITECTURE.md                   # tracker-screen conventions — read before any UI
  24_REVAMP_PLAN.md                           # the experience engine + two-client architecture (still binding)
  28_TEARDOWN/ · 29_REBUILD/                  # competitive evidence + screen/data specs (reference)
  DECISIONS.md (ADR log) · CHANGELOG.md · compliance/ · runbooks/OWNER_ACTIONS.md
  archive/                                   # superseded plans (23,25,26,27), old STATE, old runbooks
  personas/  # 73 persona specs, schema A–K each (snapshot, needs, competitors, clinical,
             # features, content, tools/alerts, EMR fields, personalization, transitions, compliance)
assets/brand/tokens/  femio.tokens.css (canonical) · .json (W3C) · .tailwind.preset.js
assets/brand/logo/    Bloom mark — femio-logo.svg (primary) + lockups + app-icon
assets/mockups/       femio_personalized_screens.html (HTML screen mockups)
# references/femio_v1_archive/ (V1 Flutter) was removed from the tree 2026-10-07; it is in git history.
```

## Governance (agency-grade — from the femio-docs-agency skill)
- **MASTER_TODO covenant:** every task/need gets a line the moment it's identified; nothing is silently dropped; statuses `[ ] [~] [x](+doc link,date) [BLOCKED] [DEFERRED]`. Removal only with Khaled's approval → mark `[DEPRECATED …]`, keep in place.
- **Queue vs archive (ADR-062):** `07_MASTER_TODO.md` is the live queue and every item is **one line**; completed work lives verbatim in `07_MASTER_TODO_ARCHIVE.md`. When a TODO line wants to become a paragraph, that paragraph is an ADR or an archive entry.
- **The ADR bar:** an ADR is for a decision that **cost something** or that a future session could **reverse by accident**. A commit message is for everything else.
- **Session protocol:** open → read `docs/STATE.md`, then the TODO, mark item `[~]`; during → add new tasks immediately; close → mark done with a link, update CHANGELOG if user-visible, and **update `docs/STATE.md` in place** rather than writing a new handover file.
- **Cut off mid-item?** Commit the dirty tree to `wip/<item-id>` with a `wip:` message, never to `main` — `main`'s one guarantee is that everything on it passed the gate. Full rule, including how to resume, in `docs/STATE.md`. Check `git branch --list "wip/*"` at the start of every session.
- **Every "done" links to evidence.** Prose over bullets in docs.

## Skills (install the Femio plugin; they encode standards — use them)
`femio-engineering-standards` (all code), `femio-design-system` (any UI — but note the newer token system in docs/12 supersedes its v1 tokens), `femio-medical-content` (any health content — cited, reviewed, grade 6–8, red-flag boxes), `femio-compliance-privacy` (any data/claims — the feature review gate), `femio-i18n-workflow` (any user-facing string), `femio-seo-aso` (public pages/store), `femio-docs-agency` (docs/governance). Plus core skills: docx/pptx/xlsx/pdf.

Also installed in-repo (not part of the Femio plugin): **`ui-ux-pro-max`** at `.claude/skills/ui-ux-pro-max/` — a searchable local UI/UX corpus (styles, palettes, font pairings, 119 UX guidelines, per-stack rules for `nextjs` and `flutter`, both of ours). Query it with `python .claude/skills/ui-ux-pro-max/scripts/search.py "<query>" --domain ux|--stack nextjs` from the repo root; Python 3 only, no deps, no network. Useful for R1 (`docs/25`) as a checklist and a second opinion — accessibility, contrast, focus, interaction. **It does not outrank Femio's own system:** our tokens are `assets/brand/tokens/` per `docs/12`, and screen conventions are `docs/22`. Never run its `--design-system --persist` generator against this repo — it writes a competing token set. Its colour/typography suggestions are input to a decision, never the decision.

The **shadcn MCP** is wired in `.mcp.json`, pinned to `shadcn@4.18.0` rather than `@latest` — `add` is a destructive verb here and its behaviour should not change under us on a CLI release. The CLI is deliberately **not** a devDependency: it is a dev-time tool that never ships, and adding it would drag an untriaged tree past the `allowBuilds` gate in `pnpm-workspace.yaml` for no runtime benefit. (Public MIT registry, no account, no code leaves the repo.) It is pinned to `--cwd apps/web` because that is where `components.json` lives — the CLI's default cwd is the repo root, where it finds no project. Use it to *read* the registry and to add primitives we do not have yet. **Never let it `add` over an existing `apps/web/src/components/ui/*` file.** Ours have diverged on purpose: `button.tsx` carries Femio semantic tokens (`bg-primary-solid`, not upstream `bg-primary`), a 44px default height for the WCAG 2.2 AA touch target, and `motion-safe:active:scale-[0.98]` press feedback from P1.28.6. Upstream would silently revert all three. Anything pulled in fresh still needs the token pass and the logical-property pass (`docs/22`) before it ships.

## Current status (2026-10-07) — full picture in `docs/STATE.md`
Live: `femioapp.com` + `femio-cms.vercel.app` on Vercel over Supabase EU. **100 published, clinician-bylined articles**, 5 condition hubs, 5 calculators, Postgres full-text search; the app has onboarding, cycle/TTC/pregnancy/postpartum/teen/menopause experiences, calendar, log, patterns, visit summary, partner sharing, export/delete, offline. Gate green, 940 tests, audit clean.

**The 2026-10 agency revamp (`docs/30_REVAMP/`)** found the engine strong and the product generic, with no launch date. The plan: **one wedge** (Arabic-first TTC → pregnancy, with PCOS depth, Saudi + Egypt), **a new design language** ("Dusk Bloom": the stock Tailwind violet retired), **content published from the repo** (Payload retired, D3), web first, then **Google Play via TWA**, then Flutter. Phases 0–5 in `03_REVAMP_PLAN.md` §5.

**Deferred by owner direction:** AI chat (OD-9), messaging/community (OD-8), billing until retention data. **Legal (P0.12) is now a launch condition** (Egypt PDPL licensing from 2026-10-31): `OWNER_ACTIONS.md` §A.

## How to work here
1. Read `docs/STATE.md`, then `docs/30_REVAMP/PROGRESS.md`; take the first open item; mark `[~]`. (`docs/07_MASTER_TODO.md` keeps its covenant as the historical queue; new work is sequenced in PROGRESS.)
2. Follow the relevant skill(s). Respect the 6 product rules and the architecture rule above.
3. Work in **small commits = restore points**. Conventional messages (`feat:`, `docs:`, `fix:`). Update TODO/CHANGELOG in the same change; an ADR only when it meets the bar.
4. When touching data or claims, fill the compliance review gate (fields? consent? data-map? claims language? processors? retention?).
5. Never invent medical facts/stats — cite Tier-1/2 or flag `[NEEDS SOURCE]`.
6. **Judge every UI change on a 390×844 phone viewport**, in light and dark, and in Arabic RTL. A screenshot is the test, not a nice-to-have.

Next up: **Phase 1 of `docs/30_REVAMP` — the Dusk Bloom design language**, then the public site (Phase 2) and the wedge app (Phase 3).
