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

- [~] **R1.1a** Desk teardown → `docs/03` §H (2026-08-11). Flo · Clue · Balance done: what each leads with, the trust mechanism, and the whitespace map. **Key finding — pattern analysis is *"the one feature I would actually pay for, gated"***, so R4 is both the differentiator and the revenue mechanism (§H.3, feed into P2.10). **Ovia added** (§H.4): it is **three apps, not one account**, and its premium tier unlocks through an employer/health-plan sponsorship that has been reported since 2019 as surfacing aggregated workforce data to employers — so the only company attempting Femio's product monetises by pointing reproductive data at bosses, which turns `docs/09` invariant 6 into a positioning line. **Remaining:** Stardust (why a shallow product feels premium — site 403, store 404), Ovia's visuals, localized/Arabic store screenshots. *(absorbs **P1.28.7**)*
- [x] **R1.3a** Product screenshot added 2026-08-11 — the real cycle dashboard drawn from the same tokens (hero card, band, accent action, tab bar), because Clue and Balance both lead with one and the reference had none (`docs/03` §H.1). Markup collapsed from 4 duplicated copies to **one template rendered 4×** (623 lines deleted): the font and contrast defects had to be fixed in every copy, and five more references are coming.
- [ ] **R1.1b** *(owner, ~1 hour — not a week)* Three screen recordings per app: sign up · log a period · open cold on day 3 → `assets/research/`. This is the ~20% no scrape can capture. Mobbin (~$15/mo) substitutes for most of it.
- [DEPRECATED — approved 2026-08-09, `docs/25` §2.1] **APK decompilation** as a teardown method: legally grey under their terms, low yield against cross-platform UI, and it answers none of the questions this workstream has.
- [x] **R1.2** Visual language decided 2026-08-09 → `docs/25` §5a. Fraunces states, Inter explains, never below 22px; Arabic pairs by **weight** (no serif counterpart exists); three elevation levels with **one raised element per screen**; `--gradient-dawn` becomes the marketing signature and never appears in-app; a data-visualisation language (band · strip · stack) with **rings explicitly rejected**; botanical line-work instead of stock portraiture; the band draws in from the axis as the one motion signature.
- [x] **R1.3 APPROVED as direction** 2026-08-11 (ADR-063) → `assets/mockups/R1.3_homepage_reference.html`. Leads with a **life-stage rail** — the one claim no competitor can answer by copying a screen — then shows honesty rather than claiming it. Rendering it caught two defects a diff could not: the Arabic headline fell back to Georgia, and white copy on `--gradient-dawn` measured **2.15:1** at the amber stop. *(absorbs **P1.28.8**)*
  - [x] **R1.3b** Fixes applied 2026-08-11. The false clinician-review claim is **removed** — bylines are `PENDING` (P1.9.8), the bio is blocked on P1.9.7, so it is replaced by what is verifiable (cited, dated sources) and can be restored when P1.9.7 lands. The hero now says the app is a tracker (comprehension + SEO). Language folded into trust: 8 sections → 7. **Reversed my own recommendation to cut the 30-day strip card** — the band is about *uncertainty*, the strip is about *your pattern vs a population average*, which is exactly the opening `docs/03` §H.2 found; cutting it would have removed the strongest competitive point.
  - [x] **R1.3c** **Homepage implemented and live in the repo** 2026-08-11 → `apps/web/src/app/[locale]/(public)/page.tsx`. Seven sections, server-rendered (SEO page, not the tracker path), ~45 new keys authored in all four locales, stale `home.title`/`home.body` placeholders deleted. Catalogs spliced by brace-matching so no reformat diff. **Three things it caught:** `claims-lint` rejected the boundary copy even negated, so it now uses house wording ("not medical advice", "not a reliable way to avoid pregnancy"); axe found `--text-subtle` on `--surface-sunken` at **4.47:1** (→ P1.5.2); and the English text did not change at all until **ADR-064**. Page-weight budget for `/en` raised 68→88 KB deliberately. Gate: 8 guards, typecheck, lint, 270 unit, **63/63 e2e**.
  - [x] **R1.3d** **Verified on production** 2026-08-11: `/en` serves the new hero, anti-claim, product shot and life-stage rail; `/ar` is RTL with the Arabic hero and CTA; the crisis launcher renders Arabic (ADR-063 live); `Scaffold online` is gone, which is ADR-064 working in production. **Still owed: eyes on it at 390px in light and dark** — curl proves the copy, not the craft.
- [~] **R1.4** Onboarding reference built 2026-08-11 → `assets/mockups/R1.4_onboarding_reference.html` (4 steps EN light + the triage step in dark/AR/AR-dark). Kills "Welcome to Femio"; one question per screen; progress becomes four dots, not a labelled bar; triage chips grouped with **"None of these apply" as a visible button**, since skipping must look as legitimate as answering. **The last step shows the experience rather than a summary — that preview is `ExperienceConfig.home` rendered, which makes onboarding the natural first consumer of the R2 engine.** First botanical line-work drawn (`docs/25` §5a). **APPROVED as direction 2026-08-11** (ADR-063).
  - [ ] **R1.4a** Move the payoff step **before** the account step — she is likelier to create an account after seeing what she gets. Verify in `lib/onboarding/complete.ts` first: consent must be written before `conditions_flagged` (health data, RLS-gated), though the wizard already submits everything at the end, so screen order should be independent of write order.
  - [ ] **R1.4b** **Implementation waits for R2.** The payoff preview hardcodes cycle mode — showing "your next period, as a window" to someone who chose pregnancy is the exact bug ADR-041 fixed. It ships reading the real `ExperienceConfig`, which makes onboarding the engine's first consumer.
  - [ ] **R1.4c** Localisation call for the owner: PCOS and PMDD were translated fully into Arabic in the reference; MENA users often use the English abbreviations. Reviewer's call, not mine.
- [ ] **R1.5** Reference: cycle dashboard.
- [x] **R1.6** **Pregnancy dashboard reference built** 2026-08-12 → `assets/mockups/R1.6_pregnancy_dashboard_reference.html`. Drawn as **modules, not a screen** (`docs/25` §5): a 14-module inventory each rendered alone, then four assembled personas (D1, D3, D7, D7+prior-loss) **driven by the module lists `buildExperienceConfig` actually emits**, so the reference and the engine cannot disagree. Decisions recorded: a clinical strip is a row of facts with the lab's own reference range and **never a verdict** (no pass/fail, no colour-coded "in range"); the term band draws 37–42w and never fills toward the EDD; warning signs sit high because in pregnancy late is the harmful direction. **Building it exposed an engine defect** — strips were appended below the quick-log instead of sitting under the hero; fixed with a test in R2.2. **Awaiting owner approval.**
- [ ] **R1.7** Reference: menopause dashboard.
- [ ] **R1.8** Reference: track / log screen.
- [ ] **R1.9** Implement, in reference order, each matching its approved reference. Homepage ships first — it does not wait for the engine.
- [ ] **P0.11.1** Brand handoff remainder: outline text→paths, favicon `.ico`/`.png`, i-dot petal, deep-violet icon variant.
- [ ] **P1.2.1** PWA icons: PNG 192/512 + maskable + apple-touch-icon (folds into P0.11.1).
- [ ] **P1.5.2** Both-theme (dark) contrast sweep across all semantic pairs + moderate/minor axe findings. *(absorbs **P0.11.3**)* **First known case, measured 2026-08-11:** `--text-subtle` on `--surface-sunken` is **4.47:1** — it was verified against `--bg` (4.81) and never against a sunken section, so any subtle text inside one fails AA. Worked around on the homepage with `--text-muted` (4.73); the token pairing still needs deciding.
- [ ] **P1.5.1** Common controls as each feature needs them (Select, Dialog/Sheet, Tabs, Checkbox, Switch, Tooltip, Toast, date picker) — never speculatively.
- [DEFERRED] **P0.20c** Port screens into Figma — deferred on purpose; HTML references on the real tokens do the same job with no team (`docs/25` §1).

## R2 — The experience engine (`docs/24`) — replaces the open half of P1.27

- [x] **R2.1** **Track D registry landed** 2026-08-11 → `apps/web/src/lib/experience/{types.ts,registry/track-d.ts}`. Data only; nothing consumes it yet. **What five specs actually showed: it is not 73 configurations, it is one spine plus layers.** D1 is the spine and gestational age computes everything; D3/D4/D7 each say the D1 experience "remains completely intact and foregrounded" and their tools are *added*, so they `extends: "D1"` and contribute strips; D2 is an **emotional layer** that stacks on any of them — clinical wins the hero, anxiety-aware tone stays armed. The contract cannot express restriction (no `hidden`/`blocked`/`available`, `tools` means *surfaced*) and a test walks the real objects to prove it. 8 structural tests incl. D3≠D4 where it clinically matters. *(un-defers **P0.23**)*
- [x] **R2.2** **`buildExperienceConfig` landed** 2026-08-11 → `lib/experience/build.ts`. Pure, dependency-free, clock injected, so it lifts into an Edge Function unchanged. Composition rules each traced to a spec line: layers add and never remove · one hero survives · alerts union by id · **tone folds toward the most protective option and cannot be switched back** · an unknown persona degrades to the generic document rather than throwing. **Found and fixed the flagship bug:** an emotional layer was taking the hero, so pregnancy + thyroid + prior loss produced a milestone card instead of the pregnancy timeline `docs/09` §8 rule 2 specifies — a woman with thyroid disease in a pregnancy after loss would have lost the answer she opened the app for. Caught because a test's *name* disagreed with its own assertion; the fix was watched failing before being trusted. 12 tests.
- [x] **R2.3** **The pregnancy dashboard renders from the config** 2026-08-12 → `components/experience/{module-registry,pregnancy-experience,clinical-strip}.tsx`, `lib/experience/phase.ts`. `persona_id`, `modifiers` and `emotional_context` — written since onboarding and **read by nothing** (`docs/23` §3.1) — now decide what she sees. `PregnancyPanel` split so the hero, red-flag panel and reading list are modules the engine orders; the pre-conditions (ended pregnancy, no due date) stay outside it, because they are reasons there is no dashboard rather than modules. `ClinicalStrip` has no `status`/`inRange`/`severity` prop **by construction** — a strip is facts plus the lab's own range, never a verdict (D7 §G). Unimplemented module ids are **listed and asserted**, not silently skipped. **Acceptance met: D3, D4 and D7 differ from data alone — there is no `personaId ===` anywhere, enforced by a new guard.**
- [x] **R2.7 (early)** **`persona-branch-lint` shipped** 2026-08-12 → `scripts/persona-branch-lint.mjs`, in CI. Fails on any persona-id comparison in `components/`, and on `mode ===` outside a one-file baseline that can only shrink. Watched failing in both directions; it caught **two flaws in itself** on first run — it matched its own doc comment (now strips comments) and three baselined files turned out not to branch at all (baseline measured, not guessed). *(This is the spirit of R2.7; repointing `native-readiness-lint` itself still waits for R2.4.)*
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
- [x] **P1.29** **Approved 2026-08-11** (ADR-063, owner direction). The 122 AR/FR/ES life-stage keys ship; the owner — a clinician and Arabic speaker — reviews them **in the running app during testing**, and a correction is an edit, not a blocked release.
- [x] **P1.26.2** **ar/fr/es crisis copy authored and approved 2026-08-11** (ADR-063). Not what the queue implied: the translations **did not exist** (`strings: null` ×3), so this was writing them. Translated sentence for sentence from the medically-reviewed English, no added promises, **no phone numbers**, `{directory}` preserved, key parity across four locales. **The EN fallback was the prior safe state and this replaces it** — read the ten Arabic strings in the app.
- [x] **P1.26.1** Global-only crisis posture (no country phone packs) **signed off by the owner as clinician**, 2026-08-11 (ADR-063). DPIA §5 note stands; a DPO can revisit before public launch without a code change. · [~] **P1.26.1a** ThroughLine email still an owner action; their terms place no restriction on a plain inbound link, so the link is permitted meanwhile. `NEXT_PUBLIC_CRISIS_DIRECTORY_URL` stays unset.
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
