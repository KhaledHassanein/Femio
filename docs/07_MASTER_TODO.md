# Femio V2 — MASTER TODO (the live queue)

**Restructured 2026-08-09** (ADR-062). Completed work moved verbatim to
`07_MASTER_TODO_ARCHIVE.md` — nothing was summarised and nothing was dropped. This file
answers one question: *what do I do next?*

**Covenant (unchanged, per Khaled):** every task gets a line the moment it is identified ·
no silent removal — only `[DEPRECATED — approved YYYY-MM-DD, reason]`, kept in place ·
statuses `[ ]` pending · `[~]` in progress · `[x]` done · `[BLOCKED]` · `[DEFERRED]`.
**New rule:** an item is **one line** with its detail in a doc or in the archive. When a line
wants to become a paragraph, that paragraph is an ADR or an archive entry.

**Strategy this queue implements:** `docs/23_STRATEGIC_REVIEW_2026-08-09.md` (what is wrong
and why) → `docs/24_REVAMP_PLAN.md` (the architecture) → `docs/25_DESIGN_DIRECTION_BRIEF.md`
(the design workstream). Read them before picking anything up.

---

## ▶ NOW — in this order, and do not jump the queue

1. **R1** — design direction. Nothing else visible improves until this does.
2. **R2** — the experience engine, proven on pregnancy. Every screen written before it against
   `mode ===` gets rewritten after it.
3. **R3** — life-stage depth, riding the engine.

---

## R1 — Design & UX direction (`docs/25`) — supersedes the P1.28 workstream's open half

- [ ] **R1.1** Competitor teardown at 390px: Flo · Clue · Stardust · Ovia · Balance — craft, not features; screenshots per claim; appended to `docs/03`. *(absorbs **P1.28.7**, owner-led)*
- [ ] **R1.2** Visual language decided once on the existing tokens: type in use, elevation, illustration direction, **data-visualisation language**, motion identity → recorded in `docs/25`.
- [ ] **R1.3** Reference: public homepage *(absorbs **P1.28.8**)* — today a hero over five identical link cards.
- [ ] **R1.4** Reference: onboarding / welcome wizard.
- [ ] **R1.5** Reference: cycle dashboard.
- [ ] **R1.6** Reference: pregnancy dashboard — **drawn as modules, not one fixed layout** (`docs/25` §5).
- [ ] **R1.7** Reference: menopause dashboard.
- [ ] **R1.8** Reference: track / log screen.
- [ ] **R1.9** Implement, in reference order, each matching its approved reference. Homepage ships first — it does not wait for the engine.
- [ ] **P0.11.1** Brand handoff remainder: outline text→paths, favicon `.ico`/`.png`, i-dot petal, deep-violet icon variant.
- [ ] **P1.2.1** PWA icons: PNG 192/512 + maskable + apple-touch-icon (folds into P0.11.1).
- [ ] **P1.5.2** Both-theme (dark) contrast sweep across all semantic pairs + moderate/minor axe findings. *(absorbs **P0.11.3**)*
- [ ] **P1.5.1** Common controls as each feature needs them (Select, Dialog/Sheet, Tabs, Checkbox, Switch, Tooltip, Toast, date picker) — never speculatively.
- [DEFERRED] **P0.20c** Port screens into Figma — deferred on purpose; HTML references on the real tokens do the same job with no team (`docs/25` §1).

## R2 — The experience engine (`docs/24`) — replaces the open half of P1.27

- [ ] **R2.1** Persona registry for **Track D** (D1, D2, D3, D4, D7) encoded from each spec's §E/§F/§G/§I. Data only. *(un-defers **P0.23**)*
- [ ] **R2.2** `buildExperienceConfig` as a pure, tested function in the web app — `Resolution` + registry → `ExperienceConfig`. No behaviour change yet.
- [ ] **R2.3** Render the pregnancy dashboard from the config via a module registry. **Acceptance: D3 and D4 visibly differ and D7 shows a thyroid strip, with no new `if`.**
- [ ] **R2.4** Move tier 1 (`resolvePersona` + `buildExperienceConfig`) to a Supabase Edge Function; split tier 2 out behind **shared golden JSON fixtures** run by both TS and (later) Dart; client caches the document for offline.
- [ ] **R2.5** Roll the registry across the remaining tracks, **including A (adolescent) and E (postpartum), which have no mode today**.
- [ ] **P1.27.4a** Derive `PersonaSignals` from live data and write the resolution back on log events + an `adaptation_events` row. *(the remaining half of P1.27.4; lands inside R2.4)*
- [ ] **P1.27.3** Re-run the whole wizard from Settings in an edit mode that pre-fills and never re-creates the account (`docs/09` §4).
- [ ] **P1.27.5** Z1 progressive personalization: score, then **offer** the nearest persona — never force; blend below threshold.
- [ ] **P1.27.6** Composable modifiers + the universal transition graph (`docs/09` §6–§8) firing automatically. D3/D4 must never be conflated.
- [ ] **R2.6** Fix the two disagreeing writers of `persona_state`: Settings' `switchMode` overwrites `persona_id` with the track default and leaves the resolver's `confidence`/`modifiers` stale (`docs/23` §3.1).
- [ ] **R2.7** Repoint `native-readiness-lint` from "no server reads in the tracker" to **"no medical decision logic in a client component"** (ADR-060). Watch it fail before trusting it.
- [DEPRECATED — approved 2026-08-09, ADR-060] **ADR-048 packaging split** (`packages/tracker`, `apps/native`): a shared React screen package earns nothing once the client is Flutter.

## R3 — Life-stage depth, riding the engine

- [ ] **P2.2.2** Pregnancy week-by-week — **blocked on reviewed CMS content**; build the surface only once approved week entries exist. Do not hand-write it.
- [ ] **P2.2.3** Contraction timer, weight chart, **appointment tracking** (the `appointments` table has been unused since v1), checklists.
- [ ] **P2.3** Postpartum mode — **does not exist today**; Track E has no mode. Recovery tracker, EPDS, feeding/sleep.
- [ ] **P2.1** TTC toolkit: BBT chart, OPK log, cervical mucus → the unused `fertility_logs` table.
- [ ] **P2.4** Menopause depth: 34-symptom set, MRS score, HRT log, CBT-informed program v1.
- [ ] **P2.7** Validated screeners (PHQ-9, GAD-7, DRSP, PBAC) → the unused `screener_results` table; clinician-discussion framing; **P1.26.3** wires a self-harm-affirmative response to `useCrisisHelp().open()`.
- [ ] **P1.13d** Pregnancy remainder: appointments + week-by-week context (both above).
- [ ] **P1.14.1** Full 100+ symptom taxonomy, DB/CMS-driven (open set + custom already prove the schema).
- [ ] **P1.27.8** Wizard Q3–Q6 (TTC duration, postpartum, menopause branches) — Q1/Q2 shipped 2026-08-07; the rest is what takes persona coverage from 15 toward ~57.
- [ ] **P1.12.3** Post-onboarding landing — resolve with the engine rather than a redirect.

## R4 — Retention: patterns and reasons to return

- [ ] **P2.5** Pattern engine (timing / severity / co-occurrence, confidence-scored) — **the stated differentiator, not built**.
- [ ] **P2.8** Notifications (web push + email digests) with discreet mode — the first real reason to return between sessions.
- [ ] **P2.6** Doctor-visit prep + report export (builds on the existing `/summary`).

## R5 — Flutter clients (ADR-060) — replaces the Capacitor plan

- [ ] **R5.1** Flutter Android client over the tier-1 endpoint; tier-2 logic in Dart against the shared fixtures; UI from the R1 references.
- [ ] **R5.2** Auth on device (Supabase session without cookies/middleware) — the substance of **P4.0.5**, now a Flutter question rather than a `capacitor://` one.
- [ ] **R5.3** Native shell: splash, icons, push (FCM/APNs), biometric app-lock. *(replaces **P4.1**)*
- [ ] **P4.3** Store compliance (Apple 5.1.3 health, Play health declaration, privacy labels).
- [ ] **P4.4** ASO package per locale. · [ ] **P4.5** Store launches + review-response playbook. · [ ] **P4.2** IAP parity with web billing.
- [ ] **R5.4** iOS client, after Android is real.

## R6 — Real users, then the company

- [ ] **P0.12.5** **Cheap, do first:** gate signup (invite code / allowlist / "private beta" notice) so "we are only testing" stays true. Signup is open on a live domain today.
- [ ] **P1.24** Beta with 20–50 real users including Arabic speakers + a feedback log. **The single highest-information action available.**
- [ ] **P1.29** *(gate)* Human review of the AR/FR/ES life-stage copy — 122 keys; the pregnancy red-flag box, `pregnancySymptoms` urgency tiers and `thoughtsOfHarm` are **safety copy** and need a human before outside testers.
- [ ] **P1.26.2** *(gate)* Human linguistic review of ar/fr/es crisis copy → enables localized rendering; EN fallback ships until then.
- [ ] **P1.26.1** *(gate, Khaled)* DPO + medical sign-off on the crisis global-only posture; then optionally set the directory URL. · [~] **P1.26.1a** ThroughLine confirmation email drafted, awaiting send.
- [ ] **P1.25** Public launch + launch documentation pack.
- [ ] **P2.10** Billing (Stripe/Paddle) + Pro gating + "free forever" list. · [ ] **P2.11** Contextual, non-health-targeted ads + affiliates on free tier.

## Legal — deferred by owner direction, blocks nothing (see archive for the full reasoning)

- [DEFERRED] **P0.12** Entity, DPO, EU rep, registrations. Everything pre-gathered in `docs/compliance/P0_12_LEGAL_INTAKE_FORM.md`. **The trigger is the first real user, not incorporation** — hence P0.12.5 above.
- [ ] **P0.12.1** → counsel: entity/DPO/reps; finalize Privacy, ToS, DPIA; per-jurisdiction minor ages; transfer mechanism.
- [ ] **P0.12.4** → then Claude: replace draft `/privacy` + `/terms` copy, drop the banner, flip to indexable, add to sitemap (`legal.spec.ts` asserts the current state and must change with it).
- [ ] **P0.12.3** → DPO/medical: sign off the crisis global-only posture (with P1.26.1).
- [ ] **P0.11.2** Trademark clearance for "Femio" (USPTO/EUIPO/WIPO) with counsel.
- [ ] **P1.12.2** Finalize consent wording with counsel — current copy is a faithful placeholder.
- [ ] **P1.9b.3c** Public `/contact` page — needs the entity + DPO addresses, so it lands with P0.12.4.

## Owner / manual actions — nobody else can do these

- [ ] **P1.9.7** *(blocks P1.9.8)* Supply `credentials` + `affiliation` for the reviewer bio, then `upsert-people --apply --publish`. The script refuses to publish a `medical_reviewer` without them, deliberately.
- [ ] **P1.9.8** Wire `authors` + `medicalReviewerProfile` on the 30 imported drafts — every byline still reads `PENDING`.
- [ ] **P1.9.6** Backfill `meet-femio`'s sources + SEO fields — the one published article with neither, and the most likely first landing page.
- [ ] **P1.11.GSC** Verify the domain in Search Console + submit `/sitemap.xml` (live sitemap now carries 99 URLs).
- [ ] **P1.20.APPLY** Create the PostHog **EU** project, sign the DPA, add to the processor register, set the key + host. Until then the event layer is a verified no-op.
- [ ] **P1.20.3.APPLY** Apply `0006_insights_aggregates.sql` (functions only) → `/admin/insights` works and the rls-audit checks stop reporting `[SKIPPED]`.
- [ ] **P1.19.3** Re-seed `ui_strings` so the portal covers the newest screens (live DB 293 keys vs 698 in the catalogs).
- [ ] **P1.23.4** Verify Supabase project settings (JWT expiry, storage bucket visibility).
- [ ] **P1.4.2** Remaining: set the Sentry DSN (EU) in Vercel. Vercel previews + envs are live.
- [ ] **STATUS?** **P1.6.APPLY** and **P0.10** look complete from the evidence (CMS live with an admin account; GitHub remote pushed) but were never closed. Confirm and close, or say what is missing.

## Phase 1 remainder — real, not urgent

- [ ] **P1.9** Articles beyond the first 31: the Wave-B remainder of the 60 EN + priority-30 AR + hreflang. Small batches between app work only.
- [ ] **P1.21** Comment/moderation queue + customer-service inbox v1. · [ ] **P2.9** Community/forum v1 (moderated, anonymous handles).
- [ ] **P1.22** Test suite remainder: RTL **visual** snapshots, `@live` flows in CI (needs an ephemeral/seeded DB decision), dark-theme a11y.
- [ ] **P1.11.1** Content-page schema remainder: `DefinedTerm` on Glossary, and a real **Lighthouse/CWV budget for LCP and CLS** — the byte budget cannot see either. (FAQPage landed as P1.6.14; the CMS sitemap landed as P1.6.18.)
- [ ] **P1.12.1** Sign-in remainder: full happy-path e2e needs an email inbox and Google credentials; the Google button stays behind `NEXT_PUBLIC_ENABLE_GOOGLE_AUTH` until the provider is configured.
- [ ] **P1.23** Security remainder: independent pen-test + sign-off, confirm at-rest encryption, breach alerting. · [ ] **P1.23.3c** Consider passkeys/WebAuthn alongside TOTP.
- [ ] **P1.23.2b** Restore static rendering on `/learn/[slug]`, `/conditions/[slug]`, `/authors/[slug]` — blocked on making the not-found pass locale-free.
- [ ] **P1.4.1** Migrate lint off `next lint` (removed in Next 16) → ESLint flat-config CLI. · [ ] **P1.4.3b** Sentry source-map upload for readable traces.
- [ ] **P1.2.3** Component testing stack (jsdom + Testing-Library) — util tests run in node today.
- [ ] **P1.18** RBAC remainder: the admin-portal pages that consume it. · [ ] **P1.19** Translation portal remainder. · [ ] **P1.19.1** DeepL machine-draft prefill + in-context preview.
- [ ] **P1.20** Analytics remainder: the dashboard on top of the first-party aggregates.
- [ ] **P1.9b.3d** `/{locale}/admin` returns **404** (verified live) — add a staff landing page behind `requireStaff`. · [ ] **P1.9b.3e** Consider `cms.femioapp.com` for the CMS.
- [ ] **P1.9b.3b** Author/reviewer bio pages remainder: real bios, bylines wired, portrait rendering (`images.remotePatterns`).
- [ ] **P0.22a.3** Close the two residual "verify before public claims" caveats on competitor/market material (B10 §Sources, C16 §C) — needed only before public comparison copy.
- [x] **P1.11.2** i18n client payload trimmed — done 2026-08-05 (ADR-037). *The archive carries this ID twice, once open; that duplicate is resolved here.*

## CMS & content engine — support function, small batches only (`docs/23` §6)

- [ ] **P1.6.7** Publication-gate hardening (needs a `health` vs `marketing` content-category split first).
- [ ] **P1.6.8** Answer-first content model: `summary`, `relatedFAQs`, `category` + topics, curated related articles/tools, generated ToC.
- [ ] **P1.6.10** Editor experience: draft preview, scheduled publish — **the gate must re-run at fire time**, not at schedule time.
- [ ] **P1.6.11** Content QA in CI: link validation, alt text, heading order, duplicate H1, empty excerpt, reading time.
- [ ] **P1.6.12** Surface review expiry — a page can display "clinician reviewed" indefinitely past `nextReviewDue` today.
- [ ] **P1.6.13** Media pipeline for social images (`remotePatterns`, required localized alt, 1200×630).
- [ ] **P1.6.1** Drop the superseded `content`/`content_i18n` tables (Payload is the source of truth; keep `ui_strings`).
- [ ] **P1.9.9** `shortBio` on People — a schema change; only worth it if the byline design wants a summary line.
- [ ] **P2.12** Content scale: 200+ EN, 100+ AR, 60+ FR/ES.

## Phase 3 & 5 — later, unchanged

- [ ] **P3.1** IVF module · [ ] **P3.2** Condition programs · [ ] **P3.3** Shopify headless store · [ ] **P3.4** Wearables (Health Connect / HealthKit arrive with R5) · [ ] **P3.5** Guardrailed AI tier + safety evals · [ ] **P3.6** Partner mode (the unused `partner_links` table)
- [ ] **P5.1** B2B2C exploration · [ ] **P5.2** Additional locales (UR, ID, TR, HI) · [ ] **P5.3** Telehealth/clinic pilots (MENA) · [ ] **P5.4** Native performance pass — only if data demands

## CONTINUOUS

- [ ] **C.1** Every newly discovered task gets a line here, immediately. No exceptions.
- [ ] **C.2** Documentation per phase (agency standard, numbered `docs/`) — **now under the ADR-062 bar**: an ADR for a decision that cost something or could be reversed by accident; a commit message for everything else.
- [ ] **C.3** Medical content review cycle (12-month re-review SLA).
- [ ] **C.4** Privacy/compliance review on every new data field.
- [ ] **C.5** Weekly analytics review → reprioritization proposals to Khaled.

---

**Everything completed before 2026-08-09 lives in `07_MASTER_TODO_ARCHIVE.md`, verbatim.**
Search it by ID for the reasoning behind any closed item.
