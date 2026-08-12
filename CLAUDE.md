# CLAUDE.md — Femio V2 (read this first, every session)

You are working on **Femio**, a women's-health platform. This file orients you; the authoritative detail lives in `docs/`. **Read `docs/STATE.md` first** — it carries the resume prompt, the working loop and the gate — then `docs/07_MASTER_TODO.md` for the queue. What is waiting on Khaled is in `docs/runbooks/BLOCKERS.md`; what needs his eyes is in `docs/runbooks/MANUAL_TEST_PLAN.md`.

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
  STATE.md                                   # ← READ FIRST: living state, gate, traps
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
  23_STRATEGIC_REVIEW_2026-08-09.md           # what is wrong, ranked, with evidence
  24_REVAMP_PLAN.md                           # the experience engine + two-client architecture
  25_DESIGN_DIRECTION_BRIEF.md                # the design workstream (R1)
  DECISIONS.md (ADR log) · CHANGELOG.md · archive/ · phases/ · compliance/ · runbooks/
  personas/  # 73 persona specs, schema A–K each (snapshot, needs, competitors, clinical,
             # features, content, tools/alerts, EMR fields, personalization, transitions, compliance)
assets/brand/tokens/  femio.tokens.css (canonical) · .json (W3C) · .tailwind.preset.js
assets/brand/logo/    Bloom mark — femio-logo.svg (primary) + lockups + app-icon
assets/mockups/       femio_personalized_screens.html (HTML screen mockups)
references/femio_v1_archive/  # V1 Flutter, learning-only
```

## Governance (agency-grade — from the femio-docs-agency skill)
- **MASTER_TODO covenant:** every task/need gets a line the moment it's identified; nothing is silently dropped; statuses `[ ] [~] [x](+doc link,date) [BLOCKED] [DEFERRED]`. Removal only with Khaled's approval → mark `[DEPRECATED …]`, keep in place.
- **Queue vs archive (ADR-062):** `07_MASTER_TODO.md` is the live queue and every item is **one line**; completed work lives verbatim in `07_MASTER_TODO_ARCHIVE.md`. When a TODO line wants to become a paragraph, that paragraph is an ADR or an archive entry.
- **The ADR bar:** an ADR is for a decision that **cost something** or that a future session could **reverse by accident**. A commit message is for everything else.
- **Session protocol:** open → read `docs/STATE.md`, then the TODO, mark item `[~]`; during → add new tasks immediately; close → mark done with a link, update CHANGELOG if user-visible, and **update `docs/STATE.md` in place** rather than writing a new handover file.
- **Every "done" links to evidence.** Prose over bullets in docs.

## Skills (install the Femio plugin; they encode standards — use them)
`femio-engineering-standards` (all code), `femio-design-system` (any UI — but note the newer token system in docs/12 supersedes its v1 tokens), `femio-medical-content` (any health content — cited, reviewed, grade 6–8, red-flag boxes), `femio-compliance-privacy` (any data/claims — the feature review gate), `femio-i18n-workflow` (any user-facing string), `femio-seo-aso` (public pages/store), `femio-docs-agency` (docs/governance). Plus core skills: docx/pptx/xlsx/pdf.

## Current status (2026-08-09) — full picture in `docs/STATE.md`
Phase 0 + 0.5 ✅ (73 persona specs, adaptation model, brand & tokens, 454 `[NEEDS SOURCE]` flags cleared). Phase 1 MVP essentially complete and **live**: `femioapp.com` + `femio-cms.vercel.app` on Vercel over Supabase EU; 31 published articles; onboarding wizard with condition triage; cycle/TTC/pregnancy/menopause dashboards; the full pregnancy lifecycle; export/delete; offline queue; consent manager; staff MFA; k-anonymous insights.

**The three things that are actually wrong** (`docs/23`): design and UX are the named gap and have no source of truth; the persona engine is **write-only** — 73 personas resolve to 4 hardcoded modes, and Tracks A and E have no mode at all; product depth is one stage deep, with `appointments`, `fertility_logs`, `screener_results` and `vitals` existing in the schema and used by nothing.

**Deferred by owner direction, blocking nothing:** P0.12 legal (trigger is the first real user, not incorporation — so gate signup first, P0.12.5), billing, store compliance, community.

## How to work here
1. Read `docs/STATE.md`, then `docs/07_MASTER_TODO.md`; take the highest open item under **▶ NOW**; mark `[~]`.
2. Follow the relevant skill(s). Respect the 6 product rules and the architecture rule above.
3. Work in **small commits = restore points**. Conventional messages (`feat:`, `docs:`, `fix:`). Update TODO/CHANGELOG in the same change; an ADR only when it meets the bar.
4. When touching data or claims, fill the compliance review gate (fields? consent? data-map? claims language? processors? retention?).
5. Never invent medical facts/stats — cite Tier-1/2 or flag `[NEEDS SOURCE]`.
6. **Judge every UI change on a 390×844 phone viewport**, in light and dark, and in Arabic RTL. A screenshot is the test, not a nice-to-have.

Next up: **R1 design direction** (`docs/25`) → **R2 the experience engine** (`docs/24`) → **R3 life-stage depth**.
