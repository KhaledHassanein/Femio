# CLAUDE.md — Femio V2 (read this first, every session)

You are working on **Femio**, a web-first women's-health platform. This file orients you; the authoritative detail lives in `docs/`. Read `docs/07_MASTER_TODO.md` to see status and pick the next task.

## What Femio is
One account for a woman's **whole health life** — puberty → cycles → conditions → TTC/IVF → pregnancy → postpartum → perimenopause → menopause — with referenced medical content, honest predictions, and verifiable privacy. Web-first (SEO), 4 languages (EN/AR/FR/ES, RTL-native), later wrapped to Android/iOS on the same backend. Positioning & strategy: `docs/00_EXECUTIVE_SUMMARY.md`, `docs/05_PRODUCT_STRATEGY_PLAN.md`.

## Non-negotiable product rules (these gate every feature)
1. **Wellness / education / tracking ONLY.** Never diagnose, treat, prevent disease, or act as contraception. This keeps Femio out of medical-device (FDA SaMD / EU MDR) scope. Screeners = "screening, discuss with your clinician."
2. **Personalize, never restrict.** UI adapts emphasis/tone/tools per persona; every article & tool stays reachable. (Teen mode gates only ads/social/data, never knowledge.)
3. **Uncertainty-honest predictions.** Ranges + confidence, never a single certain date, never a "late" counter in irregular modes.
4. **Privacy-by-design.** Health data = special category. No ad/analytics-SDK access to health data; explicit granular consent; export/delete; EU hosting. GDPR + Saudi/UAE PDPL + Egypt 151/2020.
5. **Constant EMR, additive layers.** One record spans life; a state change re-layers content/home/alerts over an unchanged core — never rebuilds or deletes.
6. **Arabic/RTL is first-class** for UI & content — but the **brand logo wordmark is always English "femio"** (never transliterated).

## Tech stack (decided — see docs/DECISIONS.md)
Next.js 15 + TypeScript + Tailwind + shadcn/ui + next-intl (EN/AR/FR/ES, RTL) + PWA. Supabase (Postgres + RLS + auth, EU region). Payload CMS for content. Capacitor wrap for mobile in Phase 4. Headless Shopify for store (Phase 3). Design tokens already built — wire Tailwind to `assets/brand/tokens/femio.tailwind.preset.js` and import `assets/brand/tokens/femio.tokens.css` globally.

## Repo map
```
docs/
  00_EXECUTIVE_SUMMARY … 06_TECH_STACK      # Phase-0 strategy pack
  07_MASTER_TODO.md                          # SINGLE SOURCE OF TRUTH for tasks
  08_PERSONA_TAXONOMY_AND_ADAPTIVE_UX.md     # ~73 personas taxonomy + Z1 fallback
  09_MASTER_ADAPTATION_MODEL.md              # the "brain": wizard→resolver→state, transitions
  10_FIGMA_UX_FLOWS.md                        # FigJam board links
  11_NEEDS_SOURCE_CHECKLIST.md               # 454 medical-review flags (P0.22, DEFERRED)
  12_BRAND_DESIGN_TOKENS.md                   # brand + token system spec
  13_LEGAL_COMPLIANCE.md                      # (P0.12) legal foundation
  14_SYSTEM_ARCHITECTURE.md                   # (P1.1) ERD/RLS/API/i18n — build gateway
  DECISIONS.md (ADR log) · CHANGELOG.md · phases/ · compliance/ · runbooks/
  personas/  # 73 persona specs, schema A–K each (snapshot, needs, competitors, clinical,
             # features, content, tools/alerts, EMR fields, personalization, transitions, compliance)
assets/brand/tokens/  femio.tokens.css (canonical) · .json (W3C) · .tailwind.preset.js
assets/brand/logo/    Bloom mark — femio-logo.svg (primary) + lockups + app-icon
assets/mockups/       femio_personalized_screens.html (HTML screen mockups)
references/femio_v1_archive/  # V1 Flutter, learning-only
```

## Governance (agency-grade — from the femio-docs-agency skill)
- **MASTER_TODO covenant:** every task/need gets a line the moment it's identified; nothing is silently dropped; statuses `[ ] [~] [x](+doc link,date) [BLOCKED] [DEFERRED]`. Removal only with Khaled's approval → mark `[DEPRECATED …]`, keep in place.
- **Session protocol:** open → read TODO, mark item `[~]`; during → log decisions as one-paragraph ADRs in DECISIONS.md, add new tasks immediately; close → mark done with doc link, update CHANGELOG if user-visible.
- **Every "done" links to evidence.** Prose over bullets in docs.

## Skills (install the Femio plugin; they encode standards — use them)
`femio-engineering-standards` (all code), `femio-design-system` (any UI — but note the newer token system in docs/12 supersedes its v1 tokens), `femio-medical-content` (any health content — cited, reviewed, grade 6–8, red-flag boxes), `femio-compliance-privacy` (any data/claims — the feature review gate), `femio-i18n-workflow` (any user-facing string), `femio-seo-aso` (public pages/store), `femio-docs-agency` (docs/governance). Plus core skills: docx/pptx/xlsx/pdf.

## Current status (2026-07-16)
Phase 0 (strategy, skills) ✅ · Phase 0.5 (73 persona specs, adaptation model, Figma flows, mockups, reviewer checklist) ✅ · Brand & design tokens + Bloom logo ✅ · Local git repo on `main` ✅ (remote/push pending Khaled's GitHub — P0.10.2).
**Deferred, owned by Khaled:** P0.22 — medical reviewer must clear the 454 `[NEEDS SOURCE]` flags before ANY persona content goes user-facing (hard gate at P1.9).

## How to work here
1. Read `docs/07_MASTER_TODO.md`; take the lowest open item in the current phase; mark `[~]`.
2. Follow the relevant skill(s). Respect the 6 product rules above.
3. Work in **small commits = restore points**. Conventional messages (`feat:`, `docs:`, `fix:`). Update DECISIONS/CHANGELOG/TODO in the same change.
4. When touching data or claims, fill the compliance review gate (fields? consent? data-map? claims language? processors? retention?).
5. Never invent medical facts/stats — cite Tier-1/2 or flag `[NEEDS SOURCE]`.

Next up: **P0.12 legal** (done here) → **P1.1 architecture** (done here) → **P1.2 scaffold the monorepo** (the natural first Claude Code coding task).
