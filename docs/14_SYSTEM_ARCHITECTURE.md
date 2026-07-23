# Femio V2 — System Architecture (P1.1)
Prepared: 2026-07-16 · Status: living · Gateway for Phase 1 build (P1.2–P1.25)
Derived from: `09_MASTER_ADAPTATION_MODEL.md` (state model), the 73 persona specs' EMR fields, `05_PRODUCT_STRATEGY_PLAN.md`, `13_LEGAL_COMPLIANCE.md`.

## 1. Principles
Web-first **PWA**; **one account, constant EMR + additive persona layers**; **privacy-by-design** (RLS, no health data to SDKs, anonymous mode, EU region); **uncertainty-honest** predictions; **i18n-native** (EN/AR/FR/ES, RTL); **wellness-only** (no diagnosis/medical-device). Same backend later serves Capacitor mobile (Phase 4).

## 2. High-level topology
```
 ┌─────────────── Client (PWA) ───────────────┐
 │ Next.js 15 App Router · React · Tailwind    │
 │ (femio tokens) · shadcn/ui · next-intl RTL  │
 │ IndexedDB offline queue · service worker    │
 └───────┬───────────────────────┬─────────────┘
         │ Supabase JS (RLS)     │ ISR/SSG content
 ┌───────▼─────────┐    ┌────────▼─────────┐
 │ Supabase (EU)   │    │ Payload CMS      │  ← condition library, articles,
 │ Postgres + RLS  │    │ (per-locale, +   │     tips, screeners (draft→
 │ Auth (email/    │    │ medical-review   │     medical review→publish)
 │ OAuth/anon)     │    │ workflow)        │
 │ Storage · Edge  │    └──────────────────┘
 │ Functions (RPC) │
 └───────┬─────────┘
   ┌─────▼──────┐  PostHog EU (pseudonymous, health-field-free) · Sentry · Resend (email) · DeepL (translation drafts)
```
Adaptation resolver + predictions run **server-side** (Postgres functions / Edge Functions) so logic is one place and health data never leaves trusted infra.

## 3. Data model (schema v1 — ERD sketch)
Two-tier mirror of the adaptation model: a **constant core** every user has, plus **persona-layer** tables switched on additively. All health tables are **row-owned** (RLS §4). Anonymous mode uses a `device_key` instead of an auth user.

### 3.1 Identity & account
- `profiles` — `id (pk, = auth.uid or device-linked)`, `account_type ('anon'|'registered')`, `device_key (nullable)`, `dob`/`age_band`, `locale`, `rtl_pref`, `discreet_mode`, `theme`, `created_at`. (No name/PII required.)
- `consent_records` — `id`, `profile_id fk`, `purpose ('core'|'insights'|'research'|'ads_contextual')`, `granted bool`, `version`, `granted_at`, `revoked_at`. **Health processing blocked until a `core` consent row exists.**
- `auth` — Supabase managed (email magic-link / OAuth / anonymous).

### 3.2 Constant EMR core (shared across all personas)
- `cycles` — `id`, `profile_id`, `period_start`, `period_end`, `flow`, derived `cycle_length`. 
- `symptom_logs` — `id`, `profile_id`, `logged_at`, `type`, `severity`, `value_json`, `note`. (mood/energy/sleep/pain/etc. via `type`.)
- `meds_supplements` — `id`, `profile_id`, `name`, `schedule_json`, `active`.
- `conditions_flagged` — `id`, `profile_id`, `condition_code`, `source ('self'|'screener')`, `non_diagnostic bool default true`.
- `screener_results` — `id`, `profile_id`, `tool ('EPDS'|'PHQ9'|'DRSP'|'MRS'|…)`, `score`, `subscores_json`, `taken_at`, `non_diagnostic true`. (Q10/self-harm handling in app logic → crisis routing.)
- `content_history` — `id`, `profile_id`, `content_id`, `viewed_at`.

### 3.3 Persona-layer tables (additive; presence gated by state)
- `labs` — `profile_id`, `test_type ('TSH'|'AMH'|'HbA1c'|'ferritin'|…)`, `value`, `unit`, `taken_at`, `source_note`. **Entry-only; never interpreted as diagnosis.**
- `vitals` — `profile_id`, `type ('BP_sys'|'BP_dia'|'glucose'|'weight'|'temp_bbt'|…)`, `value`, `unit`, `measured_at`.
- `fertility_logs` — `profile_id`, `bbt`, `opk_result`, `cm_type`, `intercourse bool`, `hpt_result`, `dpo`, `logged_at`.
- `pregnancy` — `profile_id`, `edd`, `gestational_age`, `modifiers_json` (GDM/thyroid/HTN/…), `status`.
- `appointments` — `profile_id`, `clinician`, `type`, `datetime`, `prep_json`, `results_due`.
- `key_dates` — `profile_id`, `label`, `date`, `display_pref` (for loss anniversaries etc.).
- `partner_links` — `profile_id (owner)`, `partner_profile_id`, `scope_json`, `consent_ts`, `revoked_at`. (Scoped, revocable, silent-revoke — X2 spec.)

### 3.4 Adaptation state (the "brain" persisted)
- `persona_state` — `profile_id (pk)`, `track ('A'..'F'|'Z')`, `persona_id`, `modifiers text[]`, `emotional_context text[]`, `flags_json` (minor_tier, ttc_intent, pregnant, high_risk, gentle_mode…), `clock_json` (edd/gyn_age/postpartum_week/ttc_start/last_bleed), `confidence`, `updated_at`.
- `adaptation_events` — append-only log: `profile_id`, `event_type ('positive_test'|'loss'|'mood_high'|'red_flag'|'diagnosis'|'toggle'|…)`, `payload_json`, `from_state`, `to_state`, `created_at`. (Audit + reversibility.)

### 3.5 Content & i18n
- `content` — `id`, `type ('article'|'condition'|'faq'|'tip'|'screener')`, `slug`, `status ('draft'|'in_review'|'published')`, `medical_reviewer`, `last_reviewed`, `next_review_due`, `sources_json`, `disclaimer_type`. (Authored in Payload; mirrored/queried per-locale.)
- `content_i18n` — `content_id`, `locale`, `title`, `body`, `reading_level_ok`, `reviewer_signed`, `hreflang`. **A locale row missing reviewer sign-off cannot publish.**
- `ui_strings` — `key`, `locale`, `value`, `status ('machine'|'human_reviewed')`, `icu` (ICU MessageFormat) — the translation-portal source (P1.19).

### 3.6 Commerce/roles (later phases, stub now)
- `subscriptions` — `profile_id`, `tier ('free'|'pro'|'ai')`, `provider`, `status`, `renews_at`.
- `staff_roles` — `user_id`, `role ('admin'|'editor'|'medical_reviewer'|'translator'|'support')`.
- `audit_log` — admin/data-access trail.

## 4. RLS policy map (Postgres Row-Level Security — non-negotiable)
Default **deny**; enable RLS on every table. Patterns:
- **Owner-only health data** (cycles, symptom_logs, labs, vitals, fertility_logs, pregnancy, screener_results, meds, conditions_flagged, persona_state, adaptation_events, appointments, key_dates, consent_records):
  `USING (profile_id = auth.uid())` for select/insert/update/delete; anonymous rows keyed by `device_key` claim.
- **Partner scoped read** (via `partner_links`): a partner may read **only** fields allowed by `scope_json`, enforced through security-definer RPCs that return derived/curated data — **never** raw health rows; the "never-shareable" class (intercourse, hpt, mood, screeners) is excluded at the function level.
- **Content**: `content`/`content_i18n` public **read** where `status='published'`; write restricted to `staff_roles` (editor/reviewer) via RLS + Payload.
- **Staff**: role-gated policies; `audit_log` append-only, admin-read.
- **Consent gate**: a Postgres trigger/policy blocks inserts into health tables unless a valid `core` consent row exists for the profile.

## 5. API surface
Prefer **Supabase client + RLS** for CRUD; use **Edge Functions / Postgres RPCs** for logic that must be trusted/atomic:
- `rpc.resolve_state(profile_id)` → recomputes `persona_state` + returns **home config** (hero, ordered modules, tools, content skin, alerts) per doc 09. Called on load + after each logging event.
- `rpc.apply_event(profile_id, event)` → universal-event handler (positive_test, loss, mood_high, red_flag…) → writes `adaptation_events`, updates state, returns new config. Loss = instant reminder suppression.
- `rpc.predict_cycle(profile_id)` → **range + confidence** (never single date); irregular/PCOS/peri mode widens/º disables; no "late" counter.
- `rpc.export_data(profile_id)` → JSON + PDF (GDPR). `rpc.delete_account(profile_id)` → cascade incl. backups schedule.
- `rpc.record_consent(...)`, `content` fetch by `(slug, locale)` with published+reviewed guard.
- Next.js **route handlers** for auth callbacks, webhooks (billing later), sitemap/SEO, and SSR/ISR content pages.

## 6. Adaptation engine (server-side)
Implements doc 09: state object → five outputs (home config, tools, content skin, alerts, EMR view). Universal events defined once; persona-specific transitions from each spec's §J encoded as data (a `transition_rules` table or config) so the ~73 personas plug in without bespoke code. Invariants enforced centrally: personalize-never-restrict (config controls emphasis, never access), constant-EMR (never delete on transition — archive/flag), explicit-confirmation (mode switches require user opt-in), no-diagnosis (screener/threshold outputs are routing/education).

## 7. i18n architecture
`next-intl` with locale-prefixed routes (`/en`, `/ar`, `/fr`, `/es`); **RTL** via logical CSS props + `dir` from `rtl_pref`/locale. UI strings in `ui_strings` (ICU) surfaced through the translation portal (machine draft → human review). Content translated per-locale in `content_i18n` with medical-reviewer sign-off per locale. `hreflang` + per-locale sitemaps for SEO. **Brand logo stays English** in all locales.

## 8. Predictions (uncertainty-honest)
Compute a **window + confidence band** from the user's own cycle history variability; render soft/dotted (`--prediction-band`); in irregular/PCOS/peri states show trend + "expected" copy, **no "late" counter**, **no** "safe day"/contraception framing. Never presented as certain (brand rule + medical-device guardrail).

## 9. Privacy & security architecture
EU-region Supabase; encryption in transit/at rest; **no health data to PostHog/ads SDKs** (pseudonymous, health-field-free events only — documented schema); consent-gated health writes; anonymous mode (device-keyed) upgradeable without data loss; export/delete pipelines; breach runbook; SDK allowlist reviewed quarterly. Every new field → data map in the same PR (CI check) — ties to `13_LEGAL_COMPLIANCE.md`.

## 10. Environments, CI/CD, non-functional
- Envs: dev / staging / prod; Vercel previews per PR.
- CI (P1.4): lint, typecheck, unit, Playwright e2e **incl. RTL snapshots**, a11y (axe), **data-map check**, **claims-language lint** (flag diagnose/treat/prevent/contraception), Lighthouse/CWV budget.
- Non-functional: mobile-first 360→1440; WCAG 2.2 AA (tokens already AA-verified); offline logging via IndexedDB sync queue; Core Web Vitals budget; designed empty/loading/error states.

## 11. Build order (Phase 1) & open decisions
Order: **P1.2 scaffold** → P1.3 Supabase schema+RLS+auth → P1.4 CI → P1.5 design-system components → P1.6–P1.11 content/SEO → P1.12–P1.17 tracker PWA → P1.18–P1.21 admin → P1.22–P1.25 QA/launch.
Open → decide during build: transition rules as DB table vs typed config; Payload vs Supabase as content source-of-truth (doc assumes Payload authors, Postgres serves); prediction algorithm v1 (simple variability model) vs later pattern engine; anonymous→registered merge strategy specifics. Log each as an ADR when decided.
```
