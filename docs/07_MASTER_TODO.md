# Femio V2 — MASTER TODO (single source of truth)
**Governance rules (per Khaled):**
1. Every step/phase/requirement — current or future — gets a line here the moment it's identified.
2. **No skipping.** Items may be re-prioritized/re-ordered, never silently dropped.
3. Removal only with Khaled's explicit approval → item stays, marked `[DEPRECATED — approved YYYY-MM-DD, reason]`.
4. Every completed item links to its documentation (we work agency-grade: every phase produces numbered docs in `/docs`).
5. Statuses: `[ ]` pending · `[~]` in progress · `[x]` done (+doc link) · `[DEPRECATED]` · `[BLOCKED: reason]`.

---
## PHASE 0 — Foundation & Governance
- [x] P0.1 Archive V1 Flutter project as learning-only reference (→ references/femio_v1_archive/) — 2026-07-16
- [x] P0.2 V1 lessons-learned document (→ 01_V1_LESSONS_LEARNED.md) — 2026-07-16
- [x] P0.3 Market & user research (→ 02_MARKET_USER_RESEARCH.md) — 2026-07-16
- [x] P0.4 Competitor analysis (→ 03_COMPETITOR_ANALYSIS.md) — 2026-07-16
- [x] P0.5 Medical data-source catalog (→ 04_MEDICAL_DATA_SOURCES.md) — 2026-07-16
- [x] P0.6 Product strategy & phased plan (→ 05_PRODUCT_STRATEGY_PLAN.md) — 2026-07-16
- [x] P0.7 Tech stack + accounts checklist (→ 06_TECH_STACK_SKILLS_CHECKLIST.md) — 2026-07-16
- [x] P0.8 Khaled review & sign-off on strategy/stack (GATE) — approved 2026-07-16
- [x] P0.9 Create the 7 Femio Claude skills — .skill packages delivered 2026-07-16 (install pending Khaled)
- [~] P0.10 Open Phase-0/1 accounts (GitHub, Vercel, Supabase EU, domain, PostHog, Sentry, Resend, DeepL, Search Console)
  - [x] P0.10.1 Local git repo initialized at E:\Femio (main; first commit f2b52fa, 130 files) — 2026-07-16
  - [x] P0.10.2 GitHub account + remote + first push — 2026-07-23: remote `origin` → github.com/KhaledHassanein/Femio, `main` pushed + upstream tracking set. Pre-push safety: no secrets tracked, `.gitignore` covers env/keys/Office-lock/build artifacts. (Repo should be kept **private** — legal/compliance drafts + product IP.)
- [x] P0.11 Brand identity & design tokens — 2026-07-16: premium two-tier token system (CSS canonical + JSON + Tailwind preset), palette/typography (incl. Arabic), logo concept, AA-verified (contrast audit + fixes), visual showcase (→ 12_BRAND_DESIGN_TOKENS.md, assets/brand/, ADR-006)
  - [~] P0.11.1 Logo: "Bloom" direction chosen; full lockup set produced (horizontal/stacked/mark-only/mono/app-icon + clearspace/min-size board). Wordmark is **always English "femio"** (no Arabic transliteration — decided 2026-07-16). Remaining: outline text→paths, favicon .ico/.png exports, i-dot-as-petal refinement, deep-violet icon variant — final brand handoff
  - [ ] P0.11.2 Trademark clearance for "Femio" with counsel — preliminary web scan found no direct femtech "Femio" collision; formal USPTO/EUIPO/WIPO search → P0.12 legal
  - [ ] P0.11.3 Automated both-theme contrast sign-off across all semantic pairs → now tracked as P1.5.2 (with axe-core in CI, P1.22)
- [~] P0.12 Legal: entity decision, privacy policy (health-specific), terms, DPIA, cookie consent plan — foundation + drafts done 2026-07-16 (→ 13_LEGAL_COMPLIANCE.md); finalization needs counsel/DPO
  - [ ] P0.12.1 → COUNSEL: entity + DPO + EU/local representatives + registrations; finalize Privacy Policy, ToS, DPIA; per-jurisdiction minor-consent ages + verifiable parental consent; international-transfer mechanism; liability/governing-law
  - [x] P0.12.2 Create compliance skeletons: docs/compliance/DATA_MAP.md, DPIA.md, PROCESSOR_REGISTER.md, BREACH_RUNBOOK.md — 2026-07-23 (with P1.3 schema): DATA_MAP populated per-field from schema v1; DPIA/processor-register/breach-runbook skeletons flagged for DPO/counsel to finalize.
- [x] P0.13 Decision log started (docs/DECISIONS.md) + documentation standard adopted — 2026-07-16
- [x] P0.14 Main project folder established at E:\Femio (docs/, references/, skills/, app/, assets/) — 2026-07-16

## PHASE 0.5 — Persona Research & Adaptive-UX Design (informs P1.5, P1.12, P1.13)
- [x] P0.15 Persona taxonomy (~70 personas across 6 life-stage tracks + Z1 Other/Custom fallback) & adaptive-UX plan (→ 08_PERSONA_TAXONOMY_AND_ADAPTIVE_UX.md) — 2026-07-16
- [x] P0.16 Per-persona research + spec schema (A–K standard) defined (→ within 08_...) — 2026-07-16
- [x] P0.17 Persona deep-research Wave 1 — spine: A2, B6, C1, D1, E1, F1 (→ docs/personas/) — 2026-07-16
- [x] P0.18 Persona deep-research Wave 2 — high-value: A1, C2, C4, C5, C8, D3, D4, D5, D6, D7 (→ docs/personas/) — 2026-07-16
- [x] P0.19 Master adaptation model + state machine (invariants, state object, wizard logic, Z1 resolver, universal events, transition graph, C8→D7 flagship) (→ 09_MASTER_ADAPTATION_MODEL.md, femio_state_machine.mermaid) — 2026-07-16
- [~] P0.20 Figma UX flows — welcome wizard, personalized home per spine persona, C8→D7 dynamic transition
  - [x] P0.20a Holistic flow charts (FigJam): master adaptation state map, welcome-wizard decision tree, C8→D7 flagship transition (→ 10_FIGMA_UX_FLOWS.md) — 2026-07-16
  - [x] P0.20b High-fidelity screen mockups — HTML route chosen (Khaled 2026-07-16): welcome wizard, personalized homes (A2/B6/C1/D1/F1), C8→D7 adaptive transition, Arabic RTL — on Femio design tokens (→ assets/mockups/femio_personalized_screens.html) — 2026-07-16
  - [ ] P0.20c Port validated screens into Figma once a Full seat is added (design-system source of truth + dev handoff) — deferred with P0.11/P1.5
- [x] P0.21 Persona deep-research Wave 3 — COMPLETE 2026-07-16: all 73 personas specced (A 6/6, B 19/19, C 16/16, D 17/17, E 7/7, F 6/6, X 2/2; 23,602 lines; final validation 73/73 pass, 0 anomalies) (→ docs/personas/)
  - [x] P0.21a Conception cohort remainder — C3, C6, C7, C9, C10, C11, C12, C13, C14, C15, C16 — 2026-07-16 (Track C now 16/16 complete; C13/C15/C16 verified complete despite agent session-limit cutoffs — files written before cutoff, 11/11 sections each)
  - [x] P0.21b Pregnancy remainder — D2, D8, D9, D10, D11, D12, D13, D14, D15, D16, D17 — 2026-07-16 (Track D now 17/17 complete; D15/D16 verified complete despite agent session-limit cutoffs; all 38 specs pass integrity: 11/11 sections + Sources, no truncation/dupes)
  - [x] P0.21c Cycle & gynae (Track B) — B1, B2, B3, B4, B5, B7, B8, B9, B10, B11, B12, B13, B14, B15, B16, B17, B18, B19 — 2026-07-16 (Track B now 19/19 complete; ran in 4 verified batches; B12–B16 re-run after a session-limit loss with no files created — no overwrites; all 56 specs pass integrity)
  - [x] P0.21d Adolescent / postpartum / menopause / cross-cutting — A3, A4, A5, A6, E2, E3, E4, E5, E6, E7, F2, F3, F4, F5, F6, X1, X2 — 2026-07-16 (all verified; Tracks A/E/F/X now complete)
- [x] P0.22 Consolidated [NEEDS SOURCE] reviewer checklist — 2026-07-16: 454 flags across 73 specs organized into 6 cross-cutting review groups + per-persona appendix, priority-tiered (safety-critical → accuracy → integrity/legal) (→ 11_NEEDS_SOURCE_CHECKLIST.md). Ready for medical reviewer + compliance sign-off; gate before Phase-1 content freeze.
  - [ ] P0.22.1 Clear the 454 [NEEDS SOURCE] flags — checklist HANDED to medical reviewer/compliance 2026-07-16; **Khaled to return to this later**. Priority order per doc 11 (safety-critical → accuracy → integrity/legal). Blocks Phase-1 content freeze (P1.9). [DEFERRED — revisit]
- [~] P0.22a **RETURN-TO-LATER (Khaled):** work the [NEEDS SOURCE] checklist — reviewer TRACKER + brief now produced (→ docs/compliance/NEEDS_SOURCE_TRACKER.xlsx, NEEDS_SOURCE_REVIEW_BRIEF.md): 432 flags, categorized + priority-tiered, owner-split (clinician vs research/compliance), live progress Summary tab. Route to medical reviewer + compliance; clear SAFETY-CRITICAL (180) first → accuracy (163) → integrity/legal (89). Hard gate before ANY persona content goes user-facing (blocks P1.9). Handed off 2026-07-16.
  - [~] P0.22a.1 Review pass 1 (reviewer Mohamed K., 2026-07-23): 8 canonical safety-governance docs authored under docs/compliance/ (CRISIS_RESOURCES, MENTAL_HEALTH_SCREENERS, CONTRACEPTION_SAFETY, FERTILITY_AWARENESS_SAFETY, MENSTRUAL_SAFETY_THRESHOLDS, PREGNANCY_BP_SAFETY, ENDOMETRIOSIS_CONTENT_SAFETY, REPRODUCTIVE_TREATMENT_SAFETY); 43 persona specs re-pointed to these single sources; tracker updated. Remaining flags per tracker Summary tab. (Full gate still open until all cleared.)
- [ ] P0.23 Machine-readable persona spec export (YAML/JSON per persona) — DEFERRED per Khaled 2026-07-16 (markdown-first for now); revisit before engineering handoff
- [x] P0.24 Khaled review & sign-off on persona set + adaptation model (GATE) — approved 2026-07-16 (proceed to Wave 3)

## PHASE 1 — Public site + Core cycle web app (MVP)
### 1A Architecture & scaffolding
- [x] P1.1 System architecture doc (ERD, RLS policy map, API surface, i18n schema) — 2026-07-16 (→ 14_SYSTEM_ARCHITECTURE.md, ADR-007): constant-core + additive-layer schema from the 73 specs' EMR fields, owner-only RLS, server-side adaptation resolver + predictions, i18n schema. Gateway to P1.2 (best first Claude Code task).
- [x] P1.2 Monorepo scaffold: Next.js 15 + TS + Tailwind + shadcn/ui + next-intl (EN/AR/FR/ES, RTL) + PWA manifest/service worker — 2026-07-23 (Claude Code, → apps/web/, ADR-008, ADR-009). pnpm-workspace monorepo (`apps/web`, `@femio/tokens` package keeps `assets/` canonical); Next.js 15 App Router + TS strict (`noUncheckedIndexedAccess`); Tailwind **v3** pinned to consume `femio.tailwind.preset.js`; next-intl locale-prefixed routes (/en /ar /fr /es) with RTL verified (`<html dir="rtl">` for ar); shadcn/ui set up + token-wired `Button`; PWA manifest + Serwist service worker; typed env (zod); Vitest + first util tests. Verified: lint + typecheck + build + test all pass; all 4 locales prerender.
  - [ ] P1.2.1 PWA icons are SVG-only for now; add PNG 192/512 + maskable + iOS apple-touch-icon — folds into P0.11.1 brand handoff (favicon/app-icon exports).
  - [ ] P1.2.2 Localized `not-found` + `global-error` (app/[locale]/not-found.tsx) — the scaffold uses `[locale]` as the root layout; add friendly localized error/404 surfaces at P1.5.
  - [ ] P1.2.3 Component testing stack (jsdom + Testing-Library) for React components — util tests run in node now; add at P1.5. Playwright e2e (incl. RTL snapshots) stays at P1.4/P1.22.
- [x] P1.3 Supabase: schema v1 (users, profiles, cycles, symptoms, vitals, content, translations), RLS, auth (email/OAuth/anonymous mode) — 2026-07-23 (Claude Code, project wnthtqtcajkhskdygbgo; ADR-010, ADR-011). Migrations applied to remote (23 tables + RLS verified) and anonymous sign-ins enabled (auth/settings anonymous_users=true, verified). OAuth providers deferred to when needed (email + anonymous cover MVP onboarding P1.12).
  - [x] P1.3a SSR Supabase clients + auth-session middleware + typed env (publishable key in gitignored .env.local) — credentials verified vs live project (auth/settings 200) — 2026-07-23
  - [x] P1.3b Schema v1 migration — 23 tables, constant core + persona layers + adaptation + content/i18n + roles (→ supabase/migrations/0001_schema_v1.sql) — 2026-07-23
  - [x] P1.3c RLS migration — owner-only + consent gate + staff/content policies + auth triggers + native anonymous mode (→ supabase/migrations/0002_rls_policies.sql) — 2026-07-23
  - [x] P1.3.APPLY.migrations — 0001+0002 applied to remote by Khaled; **verified 2026-07-23** (Claude Code): all 23 tables present (REST 200 for content/ui_strings/cycles/profiles/persona_state/consent_records), RLS active.
  - [x] P1.3.APPLY.anon — Anonymous sign-ins enabled by Khaled; **verified 2026-07-23** (auth/settings `anonymous_users=true`).
- [~] P1.4 CI/CD: GitHub Actions (lint, typecheck, test, preview), Sentry, envs (dev/stage/prod) — 2026-07-23 (Claude Code): CI workflow live (→ .github/workflows/ci.yml — install/claims-lint/lint/typecheck/test/build, all steps verified locally) + claims-language guard (→ scripts/claims-lint.mjs). Remaining: Sentry + Vercel previews (P1.4.2, Khaled's accounts).
  - [ ] P1.4.1 Migrate lint off `next lint` (deprecated, removed in Next 16) → ESLint flat-config CLI (`npx @next/codemod next-lint-to-eslint-cli .`) as part of CI setup.
  - [~] P1.4.2 (Khaled): connect repo to Vercel (EU region) for PR preview deploys + set env vars (dev/stage/prod); add Sentry project + DSN (then wire the SDK, health-field scrubbed). 2026-07-23: **Vercel live + verified** at https://femio-web.vercel.app (fra1/EU) — / → 307 /en, /en+/ar 200, /ar dir=rtl, manifest 200; fixed the pnpm build-scripts install failure (allowBuilds, 229eb30) and the NEXT_PUBLIC env-at-build-time 500 (env vars set + clean rebuild). Remaining: Sentry project + DSN → wire SDK.
- [x] P1.5 Design system implementation (tokens, components, empty/loading/error patterns, WCAG 2.2 AA, RTL-verified) — 2026-07-23 (Claude Code, → apps/web/src/components/): foundation delivered — real theme switching (next-themes → [data-theme]); components Button/Card/Badge/Alert(+red-flag)/Input/Textarea/Label/Separator/Skeleton; empty/loading/error state patterns; component gallery at /[locale]/components. Verified tokens-only, both themes, RTL (/ar/components prerenders dir=rtl with Arabic copy), 44px touch targets, visible focus ring, skeletons-not-spinners. Build/lint/typecheck/claims-lint pass.
  - [ ] P1.5.1 Common controls built per-feature at P1.12+ (Select, Dialog/Sheet, Tabs, Checkbox, Switch, RadioGroup, Tooltip, Toast, date/calendar) — not speculative now.
  - [ ] P1.5.2 Automated both-theme contrast sign-off across all semantic pairs (folds in P0.11.3) + axe-core a11y checks in CI (with P1.22).
### 1B Content & SEO engine
- [x] P1.6 Payload CMS installed; content models (article, condition, FAQ, tip, glossary) with per-locale fields + review workflow (draft→medical review→publish) — code complete 2026-07-23 (Claude Code, → apps/cms/, ADR-012). Payload 3.86 separate app on shared Supabase Postgres; 5 content collections + Users/Media via a shared factory; localization EN/AR/FR/ES (AR RTL); data-layer review gate; E-E-A-T fields; CI builds the CMS. Verified: types + typecheck + build pass. Live run pending Khaled (below).
  - [ ] P1.6.APPLY (Khaled): set apps/cms DATABASE_URL (Supabase session pooler) + PAYLOAD_SECRET → create schema (dev auto-push or `payload migrate`) → create first admin user → deploy as a second Vercel project (Root = apps/cms, EU) (→ docs/runbooks/cms_setup.md).
  - [ ] P1.6.1 Drop the superseded `content`/`content_i18n` tables from schema v1 in a later migration (Payload is now the content source of truth; keep `ui_strings`).
  - [ ] P1.6.2 Wire apps/web to read published content from the Payload REST/GraphQL API (lands with P1.8 IA / P1.9 articles).
- [x] P1.7 Editorial policy + medical review process published (E-E-A-T) — 2026-07-23 (Claude Code, → 15_EDITORIAL_MEDICAL_REVIEW_POLICY.md): editorial principles, sourcing (Tier-1/2, ≥2), grade 6–8, page contract, the software-enforced draft→review→publish process (matches the P1.6 CMS gate), per-locale reviewer sign-off, bylines/E-E-A-T, disclaimers, ad-independence, corrections, 12-month re-review. Doubles as the source for public /editorial-policy + /medical-review pages (built in P1.9–P1.11).
- [x] P1.8 Condition library IA (A–Z taxonomy: cycles, PCOS, endo, PMDD, fibroids, AUB, infections, contraception, TTC, IVF, pregnancy, postpartum, perimenopause, menopause, teens) — 2026-07-23 (Claude Code, → 16_CONDITION_LIBRARY_IA.md): 8-category life-stage taxonomy + full A–Z index mapped to all 73 personas; page types → CMS collections; locale-prefixed URL + hreflang + localized-slug scheme; pillar→cluster + content↔tool cross-linking; schema.org per page type; 3-wave launch prioritization feeding P1.9; coverage governance.
- [ ] P1.9 First 60 EN articles written from Tier-1/2 sources (cited, reviewed) + priority-30 AR + hreflang
- [x] P1.10 Calculators v1 (due date, ovulation window, gestational age, BMI, cycle-length) — public, no login — 2026-07-23 (Claude Code, → apps/web/src/lib/calculators/, /[locale]/calculators/). Pure tested calc functions (16 table-driven tests: cycle adjustment, irregular cycles, WHO BMI boundaries, invalid dates) + 5 interactive tools + hub on the design system; locale-aware date/number formatting; full i18n EN/AR/FR/ES. Uncertainty-honest (windows not points); fertile-window framed as conception awareness (never contraception — passes claims guard). Verified: 20 tests, build, claims-lint pass; /ar prerenders RTL.
- [x] P1.11 Technical SEO: schema.org MedicalWebPage/FAQ, sitemaps per locale, Core Web Vitals budget, Search Console verified — code complete 2026-07-23 (Claude Code, → 17_TECHNICAL_SEO.md, apps/web/src/lib/seo/): metadataBase + self-referencing canonical + full hreflang cluster (en/ar/fr/es + x-default), title template, OG/Twitter, JSON-LD (WebSite/Organization on home, WebApplication on calculators; MedicalWebPage/FAQ/Article builders ready for P1.9), per-locale sitemap.xml with hreflang + robots.txt, GSC verification via env. Verified in built HTML. CWV posture set (SSG + self-hosted fonts + minimal client JS).
  - [ ] P1.11.GSC (Khaled): verify domain in Google Search Console (set NEXT_PUBLIC_GOOGLE_SITE_VERIFICATION in Vercel or DNS) + submit /sitemap.xml; point a custom domain at Vercel and update NEXT_PUBLIC_APP_URL (currently femio-web.vercel.app).
  - [ ] P1.11.1 Content-page schema (MedicalWebPage/FAQ/Article/DefinedTerm) + dynamic sitemap from CMS — with P1.9. CWV/Lighthouse budget + axe in CI — with P1.5.2/P1.22.
### 1C Tracker web app (PWA)
- [x] P1.12 Onboarding: 4 life-stage modes + privacy-first account options — 2026-07-23 (Claude Code, → apps/web/src/components/onboarding/, lib/onboarding/). Welcome wizard at /[locale]/welcome (mode → privacy/consent → confirm), home CTA links to it; native anonymous sign-in + granular consent (core required + optional insights/research) written BEFORE persona_state, initial persona_state per mode, optional email linked to anon account. **Verified end-to-end on the live DB**: consent gate blocks health writes pre-consent, owner-only RLS holds. Full i18n EN/AR/FR/ES.
  - [ ] P1.12.1 Full email/OAuth sign-in + return flow (magic-link callback route, session on return) — v1 links email to the anon account via updateUser (confirmation email); dedicated auth pages land with P1.18 (roles) or a focused auth pass.
  - [ ] P1.12.2 Finalize consent wording with counsel (P0.12) — current copy is a faithful placeholder of the doc-13 granular-consent structure.
  - [ ] P1.12.3 Post-onboarding home/dashboard (currently redirects to the placeholder home) — lands with P1.13–P1.15.
- [x] P1.13 Cycle tracking: calendar, flow, predictions v1 **with uncertainty ranges + irregular-cycle mode** — 2026-07-23 (Claude Code, → apps/web/src/lib/cycle/, /[locale]/track). Auth-gated tracker: log period starts (RLS-owned, consent-gated), history list, and **predictions v1** — a soft dashed WINDOW + confidence, widening + no "late" counter in irregular mode (docs/09 invariant 5). 8 table-driven prediction tests. Full i18n. Prediction logic verified; DB read/write path verified live (P1.12b script).
  - [ ] P1.13.1 Visual month calendar grid (v1 is a date picker + history list) + flow intensity (light/medium/heavy) on log — cycles.flow column exists; add the UI.
  - [ ] P1.13.2 Predicted fertile/ovulation window on the tracker (calculators cover the standalone tool) + phase colouring.
- [x] P1.14 Symptom/mood logging (100+ symptoms, severity, custom) — 2026-07-23 (Claude Code, → apps/web/src/components/cycle/log-symptoms.tsx): curated symptom/mood taxonomy (mood/body/other) with multi-select chips, optional intensity (mild→severe), and a note → symptom_logs (owner-scoped, consent-gated); recent symptoms shown on /track. Full i18n. Verified live (consent gate + RLS). 
  - [ ] P1.14.1 Expand to the full 100+ symptom taxonomy (DB/CMS-driven) + per-symptom severity + custom user-defined symptoms (schema already accepts any type; note field carries custom text).
- [ ] P1.15 Dashboard per mode; insights v1
- [ ] P1.16 Data export (JSON/PDF) + delete-account (GDPR)
- [ ] P1.17 Offline-capable logging (PWA IndexedDB sync queue)
### 1D Admin portal v1
- [ ] P1.18 Roles/permissions (admin, editor, medical reviewer, translator, support)
- [ ] P1.19 Translation portal: all UI strings in DB, per-locale status board, DeepL draft + human approve, in-context preview
- [ ] P1.20 Anonymized analytics dashboard (PostHog embed: age bands, mode, condition tags, retention, funnels)
- [ ] P1.21 Comment/moderation queue + customer-service inbox v1
### 1E QA & launch
- [ ] P1.22 Test suite (unit + Playwright e2e incl. RTL snapshots); accessibility audit
- [ ] P1.23 Security review (RLS audit, OWASP top-10 pass), rate limiting
- [ ] P1.24 Beta with 20–50 real users incl. Arabic speakers; feedback log
- [ ] P1.25 Public launch + launch documentation pack

## PHASE 2 — Life-stage expansion & revenue
- [ ] P2.1 TTC toolkit (BBT chart, OPK log, CM, fertile insights)
- [ ] P2.2 Pregnancy mode (week-by-week from CMS, kick counter, contraction timer, checklists, weight chart)
- [ ] P2.3 Postpartum mode (recovery tracker, EPDS screener, feeding/sleep logs)
- [ ] P2.4 Menopause mode (34-symptom tracker, MRS score, HRT log, CBT-informed program v1)
- [ ] P2.5 Pattern engine (timing/severity/co-occurrence, confidence-scored)
- [ ] P2.6 Doctor visit prep + PDF report export
- [ ] P2.7 Validated screeners suite (PHQ-9, GAD-7, DRSP/PMDD, PBAC) with clinician-discussion framing
- [ ] P2.8 Notifications (web push + email digests) with discreet mode
- [ ] P2.9 Community/forum v1 (moderated, anonymous handles) + admin moderation tools
- [ ] P2.10 Stripe/Paddle billing + Pro tier gating + paywall pages; publish "free forever" list
- [ ] P2.11 Contextual (non-health-targeted) ads + affiliate integration on free tier
- [ ] P2.12 Content scale: 200+ articles EN, 100+ AR, 60+ FR/ES

## PHASE 3 — Depth: IVF, programs, store, wearables, AI
- [ ] P3.1 IVF module (protocol calendars, injection reminders, appointments/results log, cost tracker, education path)
- [ ] P3.2 Condition programs (PCOS program, endo pain toolkit, menopause CBT full)
- [ ] P3.3 Shopify headless store integration (Storefront API, Shopify Markets per country) + admin deep-links
- [ ] P3.4 Wearable/API integrations (Apple Health/Health Connect via Phase-4 apps; Oura/Fitbit cloud APIs earlier)
- [ ] P3.5 AI tier pilot (guardrailed, citation-only health companion; separate subscription) + safety evals
- [ ] P3.6 Partner mode (shared views with consent)

## PHASE 4 — Mobile apps (Android + iOS)
- [ ] P4.1 Capacitor wrap, native shell (splash, icons, push via FCM/APNs, biometric app-lock)
- [ ] P4.2 RevenueCat IAP parity with web billing
- [ ] P4.3 Store compliance (Apple 5.1.3 health, Play health declaration, privacy nutrition labels)
- [ ] P4.4 ASO package per locale (titles, keywords, screenshots) via femio-seo-aso skill
- [ ] P4.5 Store launches + review-response playbook

## PHASE 5 — Scale
- [ ] P5.1 B2B2C (employers/insurers/clinics) exploration
- [ ] P5.2 Additional locales (UR, ID, TR, HI candidates by analytics)
- [ ] P5.3 Telehealth/clinic partnership pilots (MENA women-doctor demand)
- [ ] P5.4 Native performance pass or selective native rebuild — only if data demands

## CONTINUOUS (every phase)
- [ ] C.1 Update this file with every newly discovered task (no exceptions)
- [ ] C.2 Documentation per phase (agency standard, docs/ numbered)
- [ ] C.3 Medical content review cycle (12-month re-review SLA)
- [ ] C.4 Privacy/compliance review on every new data field
- [ ] C.5 Weekly analytics review → reprioritization proposals to Khaled
