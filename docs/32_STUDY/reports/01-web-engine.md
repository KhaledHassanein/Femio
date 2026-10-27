# 01 — Web medical / decision engine (`apps/web/src/lib/*` + fixtures + Edge Function)

Method: I read every non-test source file in the 18 folders listed in the brief, `golden-fixtures.test.ts`, all 12 files in `fixtures/domain/` (cases counted and sampled, not read case-by-case), `supabase/functions/experience/index.ts`, the Dart golden test, the first ~60 lines of `scripts/tier1-portability-lint.mjs`, and the head of `components/experience/module-registry.tsx`. I read test files only by name and `describe`/`it` titles (resolver tests in full outline); I did not execute anything (no `vitest`, no `flutter test`), so "tests pass" is **not verified** here. "Checked" = I read it in the code; "From the docs" = a code comment or STATE.md claims it; "Hypothesis" = my reading.

---

## 1. Purpose in one paragraph

This is the part of Femio that decides things. It turns what a woman has recorded (period dates, conditions she ticked, pregnancy row, symptom counts, onboarding answers) into (a) a **persona** — one of 23 life-stage rules out of ~73 specified (Checked: 23 `PERSONA_RULES`, 23 registry records plus Z1), (b) an **`ExperienceConfig`** document — which home modules, loggers, alerts and tone to show — and (c) the plain arithmetic behind the trackers: cycle prediction as a range plus confidence, gestational age and due dates, contraction timing, fetal-movement comparison, BBT and weight charts, appointments, screener scoring (EPDS, PHQ-9, GAD-7, MRS), postpartum follow-up windows, and cycle-pattern findings. The design rule (ADR-060/061, per the code comments) is "the backend owns decisions, clients render them": decisions are pure TypeScript with no React/Supabase so they can run in a Supabase Edge Function (tier 1) and be re-written in Dart (tier 2), bound together by shared JSON "golden fixtures". Product rules 1–3 are baked into the types (no `hidden`/`locked` field exists; no "late" counter; windows not dates; no screener bands).

---

## 2. Inventory table

Status key: **live** = pure logic in use by the deployed web product; **app-only** = tied to the closed web tracker (Supabase client, auth session, browser storage, feature-flag hooks); **duplicate**/**dead** as stated. Test files are grouped at the end of each folder (name `*.test.ts`).

### `lib/experience/` (28 source + test files)

| path | lines | purpose | status |
|---|---|---|---|
| experience/types.ts | 295 | The `ExperienceConfig` v1 contract: `ModuleId` union (~60 ids), `PersonaRecord`, `AlertSpec`, `Tone`; deliberately cannot express restriction | live |
| experience/build.ts | 334 | `buildExperienceConfig`: resolution + phase + registry → document (layer merge, hero rule, alert union, tone fold) | live |
| experience/layers.ts | 39 | Emotional context → layer persona by track (`D: prior_loss→D2`, `E: prior_loss→E6`) | live |
| experience/phase.ts | 55 | EDD/status → `t1|t2|t3|postpartum|null`; Track E is always `postpartum` | live |
| experience/client.ts | 146 | Loads the document: Edge Function → localStorage cache (24 h) → local compute fallback | app-only |
| experience/reading.ts | 318 | Topic id → CMS article slug maps; week-aware pregnancy slug; list of topics with no article yet | app-only (needs the CMS article set) |
| experience/registry/index.ts | 39 | `PERSONA_RECORDS` = all tracks concatenated | live |
| experience/registry/track-a.ts | 180 | A1, A2 (teen) records | live |
| experience/registry/track-b.ts | 306 | B1, B5, B6 (cycle/gynae) records | live |
| experience/registry/track-c.ts | 188 | C1, C2, C3, C6, C8 (TTC) records | live |
| experience/registry/track-d.ts | 274 | D1, D2, D3, D4, D7 (pregnancy) records | live |
| experience/registry/track-e.ts | 404 | E1, E2, E3, E4, E6, E7 (postpartum) records | live |
| experience/registry/track-f.ts | 261 | F1, F2 (perimenopause/menopause) records | live |
| experience/registry/track-z.ts | 90 | Z1 fallback record | live |
| experience/v2/types.ts | 279 | `ExperienceConfigV2` served-UI contract (routes, sheets, a11y, variables, collections) | app-only (flag-gated, default off) |
| experience/v2/upgrade.ts | 153 | Derives v2 from v1 (pure) | app-only |
| experience/v2/flags.ts | 90 | Which contract version a surface reads; remote→cached→compiled default | app-only |
| experience/v2/use-surface-version.ts | 157 | React hook that fetches the flag from Supabase | app-only |
| experience/v2/variables.ts | 207 | Read-only seeded variables + wiring validation for v2 modules | app-only |
| experience/v2/vocabulary.ts | 259 | Canonical log vocabulary (51 terms: symptom, mood, discharge, intercourse, vital) with clinical names, life stages | live (used by log screen + mirrored by `log_vocabulary.g.dart`) |
| experience/v2/log-write.ts | 178 | Dimension → table/column mapping for logged terms | app-only (Supabase table shape) |
| experience/v2/log-search.ts | 136 | Label search + category ordering for the log screen | live |
| experience/v2/ground.ts | 73 | Cycle phase → ground-colour token name | live |
| experience tests | — | `build.test` (204), `client.test` (122), `reading.test` (205), `log-kinds.test` (56), `quick-log-reachable.test` (62), `track-{a,b,c,e,f,z}-reachability.test` (178/260/137/171/260/57), `registry/track-d.test` (123), `v2/*.test` (flags 87, ground 60, log-search 101, log-write 89, types 92, upgrade 150, use-surface-version 42, variables 191, vocabulary 131) | — |

### `lib/persona/` (18 files)

| path | lines | purpose | status |
|---|---|---|---|
| persona/resolver.ts | 805 | Rule table + scoring + Z1 fallback + `resolveForStatedTrack`; all persona thresholds | live |
| persona/signals.ts | 124 | `PersonaSignals` type, `EMPTY_SIGNALS`, `signalCoverage` | live |
| persona/signals-from-rows.ts | 234 | Pure rows → signals (regularity, days since period, pregnancy end, D3/D4 split, post-menopausal bleed) | live |
| persona/signals-from-db.ts | 109 | The six Supabase queries feeding the above | app-only |
| persona/state.ts | 297 | `persona_state` read/write, `switchMode`, `reanswerTriage`, mode↔track maps, `showsCyclePredictions` | app-only |
| persona/transitions.ts | 157 | Universal transition suggestions (positive test, birth, loss, ended, postpartum passed) | live |
| persona/conditions.ts | 167 | 24 condition codes, which stage offers which, `buildConditionRows` | live |
| persona/followup.ts | 86 | Onboarding follow-up bands (TTC duration, birth recency) → months/weeks lower bound | live |
| persona/minor.ts | 65 | `isMinor`, blocked consent purposes for minors | live |
| persona/age.ts | 25 | `AGE_BANDS` | live |
| persona/modes.ts | 31 | `PERSONA_MODES` | live |
| persona tests | — | `resolver` 231, `signals-from-rows` 71, `signals-from-db` 111, `state` 97, `transitions` 123, `offer` 146, `conditions` 66, `minor` 43 | — |

### `lib/cycle/` (9 source)

| path | lines | purpose | status |
|---|---|---|---|
| cycle/predict.ts | 362 | `predictNextPeriod` (window + confidence + evidence), `bleedStarts`, `daysUntilPredicted` (no caller, by design) | live; **Dart twin exists** |
| cycle/phases.ts | 148 | `phaseOnDay`, `cycleSegments` (ovulatory window 16–10 days before next period) | live |
| cycle/variability.ts | 78 | `observedRange` (shortest–longest, needs ≥3 intervals) | live |
| cycle/symptom-patterns.ts | 130 | Symptom timing across ≥3 complete cycles | live |
| cycle/cycle-report.ts | 113 | Last completed cycle summary for visit report | live |
| cycle/day-states.ts | 152 | Per-day calendar flags (period, predicted, fertile…) | live |
| cycle/calendar.ts | 97 | Month grid builder | live |
| cycle/symptoms.ts | 146 | `SYMPTOM_GROUPS` (45 terms) | live (partly superseded by `v2/vocabulary.ts`) |
| cycle/insights.ts | 22 | `currentCycleDay`, `topSymptoms` | live |
| cycle tests | — | one `.test.ts` per file (69/81/136/41/99/333/91/143/52) | — |

### Other folders

| path | lines | purpose | status |
|---|---|---|---|
| pregnancy/index.ts | 108 | `pregnancyProgress`, `trimesterFor`, EDD from LMP/conception/transfer, `isPlausibleEdd` | live; Dart twin |
| pregnancy/movements.ts | 122 | Movement session vs her own median (`SLOWER_RATIO` 1.5, min 3 sessions) | live; Dart twin |
| pregnancy/symptoms.ts | 109 | Pregnancy symptom set + emergency / same-day urgency tiers | live |
| pregnancy tests | — | `pregnancy.test` 96, `movements.test` 111, `symptoms.test` 78 | — |
| fertility/index.ts | 154 | BBT plausibility, OPK/CM types, `bbtChart` geometry (no shift detection) | live; Dart twin |
| patterns/confidence.ts | 83 | Coverage-based `low|medium|high`, floor of 3 cycles | live |
| patterns/cycles.ts | 59 | Place an entry in a complete cycle | live |
| patterns/co-occurrence.ts | 128 | Same-day symptom pairs across cycles | live |
| patterns/severity.ts | 140 | Recent vs earlier mean severity (`higher|lower|steady`) | live |
| patterns/rows.ts | 158 | Findings → `patterns` table rows (i18n keys only) | app-only (table shape) |
| patterns/recompute.ts | 60 | Browser call to the `patterns` Edge Function, 1/day throttle | app-only |
| patterns tests | — | `index.test` 162, `rows.test` 138 | — |
| screeners/epds.ts | 158 | EPDS scoring, reverse items, item-10 flag, no cut-offs | live |
| screeners/mood.ts | 139 | PHQ-9 + GAD-7 scoring, PHQ-9 item-9 flag | live |
| screeners/mrs.ts | 130 | MRS 11 items 0–4, three subscales, no bands | live |
| screeners tests | — | `epds` 139, `mood` 114, `mrs` 101 | — |
| insights/k-anon.ts | 54 | `K = 10` suppression on the staff insights dashboard | app-only |
| insights/queries.ts | 98 | Server RPC calls for aggregate insights | app-only |
| insights tests | — | `k-anon.test` 73 | — |
| followup/index.ts | 121 | Postpartum glucose (day 28–84) and BP (day 0–10) windows | live |
| followup tests | — | `followup.test` 111 | — |
| onboarding/complete.ts | 198 | Anonymous sign-in, consent rows, conditions, `persona_state` upsert | app-only |
| calculators/index.ts | 177 | EDD from LMP (cycle-adjusted), fertile window, gestational age, BMI, cycle stats, period forecast, pregnancy-test timing | live (public site calculators) |
| calculators/dates.ts | 27 | ISO date helpers, `todayISO()` (UTC) | live |
| calculators tests | — | `calculators.test` 166 | — |
| contractions/index.ts | 129 | Duration/interval/rolling average, no labour verdict | live; Dart twin |
| appointments/index.ts | 118 | Split/next/awaiting-results/prep parsing | live; Dart twin |
| menopause/index.ts | 153 | 12-month count, 34-symptom list, `cycleVariability` | live |
| medications/index.ts | 128 | Medication shape, current/stopped split, row mapping | app-only (row mapping) |
| charts/geometry.ts | 368 | Chart geometry (RTL-aware scales, bands, rings) | live (no Dart twin read) |
| vitals/weight.ts | 111 | Weight chart geometry, no target band | live; Dart twin |
| crisis/content.ts | 53 | Locale → approved crisis copy, EN fallback | live |
| crisis/crisis.json | 86 | The only copy store in the area (4 locales, review metadata) | live |
| crisis/directory.ts | 24 | Locks the outbound link to `findahelpline.com` over HTTPS | live |
| misc tests | — | `fertility` 145, `contractions` 122, `appointments` 124, `menopause` 89, `medications` 151, `charts/geometry` 210, `vitals/weight` 99, `crisis/directory` 29, `golden-fixtures.test.ts` 158 | — |

Fixtures: `fixtures/domain/*.json`, 12 files, 68 cases in total (appointments 2, bbt-chart 3, contractions 5, cycle-prediction 7, edd-from 5, experience-config 9, gestational-age 4, movement-pattern 5, persona-resolution 8, phase 8, signals-from-rows 8, weight-chart 4), 69 KB.
Edge Function: `supabase/functions/experience/index.ts`, 172 lines, live (but deployed by hand — see §8).

No file here is dead in the sense of unreferenced, with two exceptions noted in §8 (`daysUntilPredicted`, `monthsRemaining`).

---

## 3. Key modules and responsibilities

### 3.1 The persona resolver — `persona/resolver.ts`
**Inputs:** `PersonaSignals` (age band, cycle regularity, days since last period, `ttcIntent`, `ttcMonths`, pregnancy status/outcome, weeks since pregnancy end, conditions, symptom counts, D3-vs-D4 flag, prior loss, post-menopausal bleed). **Output:** `Resolution { personaId, track, modifiers, emotionalContext, confidence, runnerUp }`. **Callers:** `signals → resolveForStatedTrack` in the Edge Function, `experience/client.ts`, `persona/state.ts`, `onboarding/complete.ts`.

How it works (Checked):
- Each `PersonaRule` has hard `requires` gates (fail = score 0) and weighted `signals`. Score = matched weight / total weight.
- Ranked by score; ties broken by rule order (stable sort), asserted by a test.
- `confidence = top × (0.5 + 0.5 × signalCoverage)`. Coverage is the share of six broadly-applicable facts known (age band, regularity, average length, pregnancy status, any condition, any symptom).
- `confidence < 0.6` → answer **Z1** (generic) with the winner kept as `runnerUp` so the UI can *offer*, never apply.
- Two top candidates on **different tracks** within 0.08 → also Z1. Same-track near-ties do not collapse (so pregnancy + thyroid + loss is a pregnancy hero, not a shrug).
- `resolveForStatedTrack`: if she told us her stage, her track wins; within it the runner-up in that track, else the track's base persona (A2, B1, C1, D1, E1, F1, Z1), is used and the offer is cleared.
- **Modifiers** (stacked layers) = every condition code + `pregnancy_after_loss` + `irregular_cycles`. **Emotional context** = `prior_loss`, and `waiting` (TTC and >35 days since last period).

Rule roster (Checked): A1, A2; B1, B5, B6; C1, C2, C3, C6, C8; D1, D2, D3, D4, D7; E1, E3, E4, E2, E7, E6; F1, F2. Most gates are mutually exclusive by design: D3/D4 by `diabetesRecordedBeforePregnancy`; C1/C2/C3 by evaluation window; E-track personas gated against `loss` outcome and `priorLoss` so only E6 can fire after a loss.

### 3.2 `ExperienceConfig` and the builder — `experience/types.ts`, `experience/build.ts`
**The document (Checked, `types.ts:~230–295`):** `version`, `resolvedAt`, `track`, `personaId`, `modifiers`, `emotionalContext`, `confidence`, `offer` (Z1's "tailor Femio for X?"; only from Z, only ≥ 0.4, only for a named track), `transition` (a suggested move, e.g. birth), `phase`, `home { modules[], quickLog[] }`, `tools`, `content { skin, foreground[] }`, `alerts[]`, `emrView[]`, `tone`.
**Builder rules (Checked, `build.ts`):**
1. Walk `extends` to get the layer chain base-first (D3/D4/D7 extend D1; D2 is an `emotionalLayer`).
2. Per layer, take the phase bucket (`t1|t2|t3|postpartum|preconception`) or `home.default`, and merge modules **by id** — a matching id keeps its position and takes the higher emphasis with shallow-merged params; new ones are inserted right after the hero.
3. Exactly one hero survives (the last declared); earlier heroes are demoted to `primary`, never removed; the winner moves to position 0.
4. Emotional layers (from `emotionalLayersFor`) join with their hero demoted — D2's tone and loss-suppression ride along, but the clinical hero keeps the screen.
5. Alerts are unioned by id. Tone folds toward the protective option: `celebrationByDefault` and `countdown` are AND-ed; register takes the higher rank; reading level sticks at `gentle`.
6. Unknown persona → neutral empty document (never throws).
Nothing can be removed: there is no subtract path, and the type has no restriction field.

### 3.3 The module registry (two things share the name)
- **Data registry:** `experience/registry/track-*.ts` — 24 `PersonaRecord`s: per-phase module lists with emphasis and params, tools (`LogKind[]`), content skin and foreground topics, alerts, EMR fields, tone.
- **Renderer registry:** `components/experience/module-registry.tsx` (277 lines, outside my area, head read only) maps each `ModuleId` string to a React node supplied by the screen; unimplemented ids are listed in an `UNIMPLEMENTED` set and a test asserts the union covers every id the registry can emit. This part is app-only.

### 3.4 Cycle prediction — `cycle/predict.ts`
**Input:** dates of period starts (and optional stated cycle length). **Output:** `CyclePrediction { averageLength, basis: stated|observed, predictedStart, windowStart, windowEnd, confidence, irregular, learning, evidence{cyclesUsed, spread, margin, recentWindow, rule} }`. Always a window, never a date. Details in §6.

### 3.5 Gestational age / EDD — `pregnancy/index.ts` (+ `calculators/index.ts`)
`pregnancyProgress(edd, today)` counts days against the due date a clinician gave: `totalDays = 280 − daysUntilDue`; weeks/days = floor/mod 7; trimester by day cut-offs; `termStart = EDD − 21` (37w0d); `overdue` once past EDD; returns null outside 0–315 days. EDD builders: LMP +280; conception +266; IVF transfer +266 − embryo age (3 or 5 days) — the last cites ACOG CO 700 in a comment. `calculators/index.ts` is a *second* implementation for the public calculators (LMP-based, cycle-length-adjusted, term window 37–42 weeks).

### 3.6 Screeners — `screeners/*`
Scoring only, **no bands or labels on purpose**. EPDS: 10 items 0–3, items `ableToLaugh` and `lookedForward` reverse-scored, item 10 > 0 sets `selfHarmItemPositive` regardless of total (client must open crisis route). PHQ-9: 9 items; item 9 (`betterOffDead`) flag. GAD-7: 7 items, flag always false. MRS: 11 items 0–4 in three subscales. Each returns total, `answered`, `complete`, and a DB row builder.

### 3.7 Patterns engine — `patterns/*` + `cycle/symptom-patterns.ts`
Three finding kinds (timing, co-occurrence, severity trend), all measured per **complete cycle**, each with a coverage-based confidence band and "nothing" below 3 cycles. Written to a `patterns` table by the `patterns` Edge Function via `rows.ts`; the browser can only ask for a recompute.

### 3.8 Experience delivery — `experience/client.ts` and the Edge Function
See §4.

### 3.9 Others worth naming
`persona/signals-from-rows.ts` (single source for "what the record says", fixes a previous browser/server drift on `ttcIntent`), `persona/transitions.ts` (suggestions only, five rules, first match wins), `followup/index.ts` (windows as data), `pregnancy/symptoms.ts` (urgency tiers that mirror the warning-signs article), `experience/v2/vocabulary.ts` (51-term log vocabulary, Dart mirror generated as `log_vocabulary.g.dart`).

---

## 4. Data flow

**Tier-1 path (Checked, `supabase/functions/experience/index.ts`):**
1. Browser (`experience/client.ts`) calls `supabase.functions.invoke("experience", { today })` with the user's JWT.
2. The function requires an `Authorization` header, builds a Supabase client with the **caller's JWT and the anon key** (no service role — RLS stays the boundary), and runs six queries: `profiles.age_band`, `cycles.period_start`, `conditions_flagged`, latest `pregnancy` row (status, edd, created/updated/ended_on), last 200 `symptom_logs.type`, `persona_state` (track, flags_json).
3. It calls the same modules as the browser: `signalsFromRows` → `resolveForStatedTrack` → `phaseForTrack` → `emotionalLayersFor` → `buildExperienceConfig`, then returns JSON with `Cache-Control: private, no-store` and wildcard CORS. It writes nothing. `today` comes from the caller (validated `YYYY-MM-DD`), so gestational age uses her date, not the server's.
4. The client caches the document in `localStorage` (`femio.experience.v1.<userId>`, 24 h, version-checked, cleared on sign-out) and falls back to `computeLocally` (same modules, same queries via `signals-from-db.ts`) if the function is undeployed or offline. Resolution is persisted separately by `switchMode` / `completeOnboarding` into `persona_state`, plus an `adaptation_events` audit row.
5. Tier-1 modules are imported by the Deno function straight from `apps/web/src` by relative `.ts` path; `scripts/tier1-portability-lint.mjs` enforces "no `@/` alias, explicit `.ts`, no framework/Supabase imports, no ambient clock" on a hand-listed set of ~43 files (36 listed plus the 7 registry files).

**External services touched by this area:** Supabase (Postgres via RLS, Auth anonymous sign-in, Edge Functions `experience` and `patterns`, RPCs `insights_*`), browser `localStorage`, the CMS (article slug availability via `/api/reading`, read in `reading.ts` comments, not in this folder). No Vercel/Sentry/PostHog/fonts/CDN call is made from these folders (Checked by reading; analytics lives elsewhere and `minor.ts` only gates its consent purposes).

**What leaves the device:** every tier-1 input is a row she wrote; the resolved document (which includes `modifiers` = her conditions) is health data cached in `localStorage`.

---

## 5. Dependencies

- **Inside the area:** everything depends on `calculators/dates.ts` (`diffDays`, `addDays`, `isValidISODate`); `cycle/predict.ts` is imported by `persona/signals-from-rows.ts`, `cycle/*`, `patterns/cycles.ts`; `pregnancy/index.ts` by `experience/phase.ts`; `persona/resolver.ts` by `experience/build.ts`, `layers.ts`, `v2/*`.
- **Imports from elsewhere:** `@/lib/supabase/client` (`signals-from-db`, `state`, `client`, `use-surface-version`, `recompute`, `complete`), `@/lib/supabase/server` (`insights/queries`), `@/lib/consent/purposes` and `@/i18n/routing` (`complete`, `crisis/content`).
- **Imported by:** (counts of files in `app/` + `components/` that import each folder, Checked by grep) calculators 26, cycle 18, experience 17, persona 9, pregnancy 5, crisis 4, patterns 3, screeners 3, insights 2, appointments 2, and 1 each for fertility, followup, onboarding, contractions, menopause, medications, charts, vitals. Plus `supabase/functions/experience` and `patterns`, the Dart golden test (by fixture only), and `docs`-level lint scripts.
- **Dart side:** `apps/mobile/lib/domain/*.dart` (8 files, 870 lines) re-implement `predict`, `pregnancy`, `contractions`, `movements`, `bbt`, `weight`, `appointments`, `dates` and `day_marks` (Checked by file listing and golden test).

---

## 6. Medical thresholds — every one, and where it lives

All are **Checked** in the cited file. Where a source is cited in a code comment I mark it "per comment"; I did not verify any external source (see §10).

### Cycle and prediction (tier 2)
| Threshold | Value | File |
|---|---|---|
| Stated cycle length accepted | 21–35 days | `cycle/predict.ts` (`predictNextPeriod`) |
| Stated-baseline window half-width | ±4 days | `predict.ts` `STATED_MARGIN_DAYS` |
| Two dates are the same bleed if within | ≤10 days | `predict.ts` `SAME_BLEED_WITHIN_DAYS` |
| Recent cycles used for the average | last 6 usable | `predict.ts` (local `RECENT_CYCLES`) |
| Interval too long to be a cycle | >90 days (excluded from average only; still counted in spread/irregular) | `predict.ts:263` |
| Window half-width | `max(2, ceil(spread/2))` where spread = longest − shortest of **all** intervals | `predict.ts` |
| `learning` | fewer than 2 intervals | `predict.ts` |
| `irregular` | not learning and spread > 9 days | `predict.ts` |
| Confidence | high: ≥6 intervals and spread ≤4; medium: ≥3 and spread ≤9; else low | `predict.ts` |
| Stated-basis prediction | always `low`, `learning: true` | `predict.ts` |
| Ovulatory window | 16 to 10 days before next period (per comment, NHS "10–16 days before") | `cycle/phases.ts` |
| Minimum cycle for a phase estimate | 21 days | `phases.ts` `MIN_ESTIMABLE_CYCLE` |
| Default bleed length | 5 days | `phases.ts` |
| Observed range needs | ≥3 intervals, each ≤90 days | `cycle/variability.ts` |
| Symptom timing pattern needs | ≥3 cycles | `cycle/symptom-patterns.ts` |
| No-recent-bleed ("absent") | >90 days since last period | `persona/signals-from-rows.ts` `ABSENT_AFTER_DAYS` |
| Bleed after long gap | gap ≥365 days between two starts | `signals-from-rows.ts` |
| Alert "long gap" | 90 days | `registry/track-b.ts:139,220`, `track-z.ts:75` |
| Menopause 12-month convention | 12 calendar months | `menopause/index.ts` `MENOPAUSE_MONTHS` |
| Menopause trend window / irregular | last 6 intervals; spread > 9 | `menopause/index.ts` `cycleVariability` |
| Public cycle-length calculator "regular" | spread ≤ 7 | `calculators/index.ts:98` (**different from 9**, see §8) |
| Public calculator cycle bounds | 20–45 days | `calculators/index.ts` |
| Public fertile window | ovulation = next period − 14; window −5 to +1 | `calculators/index.ts` (**different from phases.ts**, see §8) |
| Public period length bounds | 2–10 days | `calculators/index.ts` |
| Pregnancy test timing | from expected period; ≥21 days after unprotected sex (per comment, NHS) | `calculators/index.ts` |
| BMI categories | <18.5, <25, <30, else (WHO adult, per comment) | `calculators/index.ts` |

### Pregnancy
| Threshold | Value | File |
|---|---|---|
| Gestation | 280 days (duplicated: `pregnancy/index.ts:18` exported, `calculators/index.ts:7` private) | both |
| EDD from conception | +266; from IVF transfer +266 − 3/5 days | `pregnancy/index.ts` |
| Trimester cut-offs | day <98 → 1, <196 → 2, else 3 (i.e. 14w0d, 28w0d) | `pregnancy/index.ts` `trimesterFor`; weeks version `calculators/index.ts` `trimesterOf` |
| Term start | EDD − 21 days (37w0d) | `pregnancy/index.ts` |
| Public term window | 259–294 days from LMP (37–42 weeks) | `calculators/index.ts` |
| Plausible gestation | 0–315 days (progress); 0–320 days (calculator `gestationalAge`) | `pregnancy/index.ts`, `calculators/index.ts` |
| Plausible EDD | ≤280 days ahead, ≥35 days past | `pregnancy/index.ts` `isPlausibleEdd` |
| Movement comparison | ≥3 finished sessions; "slower" = latest minutes-per-movement ≥ 1.5× her median of prior sessions | `pregnancy/movements.ts` |
| Contraction average window | last 5 | `contractions/index.ts` |
| Registry week params | movement primer week 28; movement surfaced from 28; contractions surfaced from 36; thyroiditis primer week 34 | `registry/track-d.ts` |
| Pregnancy urgency tiers | 9 emergency keys, 10 same-day keys (lists, not numbers) | `pregnancy/symptoms.ts` |
| Weight plausibility | 25–300 kg, 55–660 lb; chart needs ≥2 points | `vitals/weight.ts` |
| BBT plausibility | 34–40 °C, 93–104 °F; chart needs ≥3 points; axis padding 0.4 °C / 0.7 °F | `fertility/index.ts` |

### Persona resolver
| Threshold | Value | File |
|---|---|---|
| Commit vs generic | confidence ≥ 0.6 | `resolver.ts` `CONFIDENCE_THRESHOLD` |
| Offer worth showing | ≥ 0.4 | `resolver.ts` `OFFER_THRESHOLD` |
| Cross-track tie → Z1 | top-two within 0.08 | `resolver.ts` `AMBIGUITY_MARGIN` |
| TTC evaluation window | 12 months; 6 months if age band 35–44 or 45–54 (ACOG/NICE/ASRM, per comment) | `resolver.ts` `evaluationWindowMonths` |
| TTC answer bands (lower bound used) | 0, 6, 12, 24 months | `persona/followup.ts` |
| Birth-recency bands (lower bound) | 0, 6, 13, 26, 52 weeks | `persona/followup.ts` |
| E1 postpartum general | ≤26 weeks since end | `resolver.ts` |
| E2/E3/E4/E7 | ≤52 weeks | `resolver.ts` |
| Transition "postpartum passed" | >26 weeks → offer Track B | `persona/transitions.ts` `POSTPARTUM_WEEKS` |
| B5 gap signal | >45 days since last period | `resolver.ts` |
| F1 "still within the year" | <365 days | `resolver.ts` |
| F2 | ≥365 days or a recorded post-menopausal bleed | `resolver.ts` |
| Symptom signal | ≥2 logs of that type (default) | `resolver.ts` `symptom()` |
| "Waiting" emotional context | TTC intent and >35 days since last period | `resolver.ts` |
| Minor | age bands `under_13`, `13_15`, `16_17`; unknown age is treated as minor | `persona/minor.ts` |

### Screeners and follow-up
| Threshold | Value | File |
|---|---|---|
| EPDS | 10 items, 0–3; items 1–2 reverse; item 10 > 0 → crisis flag; **no cut-off applied** | `screeners/epds.ts` |
| PHQ-9 / GAD-7 | 9 / 7 items, 0–3; PHQ-9 item 9 > 0 → flag; **no bands** | `screeners/mood.ts` |
| MRS | 11 items, 0–4, subscales; **no bands** | `screeners/mrs.ts` |
| Postpartum glucose test window | day 28–84 after birth | `followup/index.ts` |
| Postpartum BP window | day 0–10 after birth | `followup/index.ts` |
| Registry follow-up params | GDM OGTT 6 weeks after birth; BP weekly; diabetes hypo watch day 1; mood check-in every 2 weeks; thyroid labs every 4 weeks (D7) or 8 (C8, E7) | `registry/track-d.ts`, `track-e.ts`, `track-c.ts` |
| Menopause twelve-month education alert | 365 days | `registry/track-f.ts:122` |

### Patterns and others
| Threshold | Value | File |
|---|---|---|
| Pattern floor | ≥3 cycles (also 3 in `symptom-patterns.ts`, `recompute.ts`, `variability.ts`) | `patterns/confidence.ts` `MIN_CYCLES` |
| Pattern bands | high: coverage ≥0.8 and ≥5 cycles; medium ≥0.5; else low | `patterns/confidence.ts`; **repeated numerically** in `patterns/rows.ts:153–154` |
| Co-occurrence | ≥3 shared days | `patterns/co-occurrence.ts` |
| Severity trend | last 3 complete cycles vs earlier; shift ≥0.5 on 0–4 scale to count as higher/lower | `patterns/severity.ts` |
| Stored confidence for severity | band midpoints 0.35 / 0.65 / 0.9 | `patterns/rows.ts` |
| Insights k-anonymity | k = 10 | `insights/k-anon.ts` (mirror of SQL `insights_k()`) |
| Experience cache | 24 h | `experience/client.ts` |
| Pattern recompute throttle | 24 h | `patterns/recompute.ts` |
| Crisis copy review | EN approved 2026-07-23, next review 2027-07-23; AR/FR/ES approved 2026-08-11 by the owner (ADR-063), next 2027-08-11 | `crisis/crisis.json` |

---

## 7. How the golden fixtures bind TS to Dart

**Mechanism (Checked).** `fixtures/domain/*.json` hold `{ cases: [{ input, expected }] }`, hand-written (comments say never generated from the implementation). Two runners read the *same files*:
- TS: `apps/web/src/lib/golden-fixtures.test.ts` maps each fixture name to an adapter lambda and asserts `expect(run(input)).toEqual(expected)`. A first test asserts the set of runners equals the set of files on disk, so an unrun fixture fails the suite.
- Dart: `apps/mobile/test/golden_fixtures_test.dart` does the same with its own adapters, with a test that every file is either run or named in `notYetPorted`.

**Coverage (Checked).** 12 fixtures / 68 cases. Dart runs 8: `cycle-prediction`, `bbt-chart`, `contractions`, `movement-pattern`, `weight-chart`, `appointments`, `edd-from`, `gestational-age`. Dart explicitly defers 4: `phase`, `persona-resolution`, `signals-from-rows`, `experience-config` (comment: "ports it when Today does", `docs/30_REVAMP/04_ANDROID_APP_SPEC.md`). So the persona resolver, signals derivation, phase and experience builder exist **only in TS**.

**What is not bound at all (Checked by absence):** no fixtures for screeners (EPDS/PHQ-9/GAD-7/MRS), cycle phases, pattern engine, follow-up windows, menopause arithmetic, medication logic, chart geometry (`charts/geometry.ts`), pregnancy urgency tiers, `calculators/*`, or `transitions`. The code comments describe several of these as "tier 2, a Dart twin will reproduce it" (`patterns/*`, `charts/geometry.ts`, `cycle/phases.ts`) — that is a plan, not a binding.

**Weak spots (Hypothesis):** fixture rounding is done in the runners (`r4`), so float behaviour across languages is only pinned to 4 decimals; cycle-prediction has 7 cases covering regular, irregular, 1-start, empty, stated, and consecutive-day collapse, but none for the 90-day-gap exclusion, the >6-cycle recent window, or a `usable.length === 0` fallback with stated length — the exact branches that were added late (R3.1.9/R3.1.10). I did not diff the Dart implementation line by line; it declares the same constants (`_statedMarginDays` 4, `_sameBleedWithinDays` 10, `_recentCycles` 6, `_maxPlausibleCycleDays` 90, `spread > 9`, same confidence cut-offs).

---

## 8. Strings and i18n

- **User-facing prose in this area lives in two places only:** `crisis/crisis.json` (EN approved + AR/FR/ES, with reviewer, dates, and a CI guard `scripts/crisis-compliance.mjs` for expiry and key parity) and, by key, in the next-intl catalogues elsewhere. Everything else is a key: `labelKey: "symptoms.items.<k>"` (`v2/vocabulary.ts:71`), `summary_key: "patterns.timing.summary"` (`patterns/rows.ts`), alert ids like `pregnancy.redFlags`, module ids, transition ids.
- **No hard-coded user-facing sentences found** in the non-test source of the 18 folders (Checked by reading; I did not run a lint). English clinical names exist (`clinicalName: "dysmenorrhoea"`, `"mastalgia"`) for the clinician report, not for the UI.
- **Locale-aware bits:** `cycle/calendar.ts` `weekStartForLocale` (`ar` → Saturday). `charts/geometry.ts` takes `direction: "ltr"|"rtl"` and `flipX` is the one place the axis inverts. Dates are all ISO `YYYY-MM-DD` strings; formatting is left to the UI.
- **Exception to watch:** `contractions/index.ts` `formatDuration` returns `m:ss` (locale-independent by design, comment says so); Arabic-Indic digits would be a UI call.

---

## 9. Tests

**Present (names read; not executed):** 57 test files totalling about 7,000 lines inside the 18 folders (plus `golden-fixtures.test.ts`) — every folder except `onboarding`, `insights/queries`, `patterns/recompute`, `persona/followup` (indirectly via other tests), `experience/layers`, `crisis/content`, `crisis.json` and `persona/signals.ts` has at least one test. Strong points:
- Resolver: invariants (always resolves; no restriction fields; offer vs commit; ambiguity), D3/D4 mutual exclusion "by construction", pregnancy gating, modifier stacking, determinism, rule-id uniqueness.
- **Reachability tests** (`track-{a,b,c,e,f,z}-reachability.test.ts`, ~1,060 lines): for each persona, build signals, resolve, build the document, assert the intended modules appear. This is the guard against "persona exists but cannot be reached".
- `build.test` (hero rule, layering, tone fold), `reading.test` (every foregrounded topic is mapped, listed as missing, or week-aware), `quick-log-reachable`, `log-kinds`.
- Golden fixtures (68 cases) plus per-file tests for every tier-2 module.

**Untested or thinly tested (Checked by file list):**
- `onboarding/complete.ts` (198 lines of consent + persona write) — no test.
- `insights/queries.ts`, `patterns/recompute.ts`, `crisis/content.ts` (locale fallback logic) — no direct test; `crisis/directory.test.ts` covers only the URL guard.
- `experience/layers.ts` — no direct test (exercised through the `experience-config` fixture and reachability tests).
- `persona/signals.ts` `signalCoverage` — indirect only.
- Screeners are tested (`epds.test`, `mood.test`, `mrs.test`, 354 lines) but have **no cross-language fixture**.
- Reachability tests use symptom keys (`hotFlushes`, `troubleSleeping`) that the logger never writes — see §10 smell 1; the tests therefore pass while the live path is broken.

---

## 10. Smells, risks, dead code

1. **Likely live bug — F1 symptom signals can never fire from real logs.** `persona/resolver.ts:605–606` and `:644` match symptom types `hotFlushes` and `troubleSleeping`. The logging vocabulary stores `hotFlashes` (`cycle/symptoms.ts:49`, `experience/v2/vocabulary.ts:140`, `menopause/index.ts:46`) and `insomnia` (`cycle/symptoms.ts:60`). Grep found `hotFlushes`/`troubleSleeping` only in the resolver, tests and MRS item names. Effect (Hypothesis): F1 loses up to 3 of 12 weight points and F2 loses 1 of 7; a perimenopausal woman is more likely to land on Z1 than F1. The reachability test (`track-f-reachability.test.ts:52`) hides it by using the same wrong keys. Verify with a real log before fixing.
2. **Two ovulation definitions.** `cycle/phases.ts` (window 16 to 10 days before the next period) versus `calculators/index.ts` `fertileWindow` (ovulation = next period − 14, window −5…+1). The public site and the app can show different "fertile" dates for the same woman. Pick one, cite it, bind it with a fixture.
3. **Two "irregular" thresholds.** Prediction/menopause use spread > 9 days; `calculators/index.ts:98` `cycleStats.regular` uses spread ≤ 7. A cycle with spread 8 or 9 is "not regular" on the calculator and "regular" in the tracker.
4. **Two EDD calculators.** `calculators.estimateDueDate` (LMP, adjusted for cycle length, 20–45) vs `pregnancy.eddFromLmp` (LMP + 280, no adjustment). Only the latter is in the Dart fixtures. Also `GESTATION_DAYS` duplicated (`pregnancy/index.ts:18`, `calculators/index.ts:7`), two trimester functions (`trimesterFor` in days, `trimesterOf` in weeks), and two plausibility caps (315 vs 320).
5. **UTC "today" in a UTC+2/+3 market.** `calculators/dates.ts:25` `todayISO()` is `new Date().toISOString().slice(0,10)` (UTC date). In Cairo/Riyadh between 00:00 and 02:00/03:00 local time it returns yesterday; the Edge Function falls back to the same UTC date (`index.ts:92`) when the client sends nothing. Gestational week and "days since last period" can be off by one at night. Git log shows the mobile app already had to fix "picked dates land a day early east of UTC" (79a0e4f), so the web side of this is probably still open (Hypothesis: not checked against the UI date picker).
6. **Magic numbers repeated.** `MAX_PLAUSIBLE_CYCLE_DAYS = 90` appears in `predict.ts:263` (function-local), `variability.ts:56`, the visit summary (outside area), and `ABSENT_AFTER_DAYS = 90` in `signals-from-rows.ts:31`. `bandFor` in `patterns/rows.ts:153–154` repeats 0.8 / 5 / 0.5 from `confidence.ts` instead of importing them.
7. **Dead-by-design code.** `daysUntilPredicted` (`predict.ts`) has no caller on purpose (kept as a hostile contract). `SinceLastPeriod.monthsRemaining` (`menopause/index.ts:93,119`) is computed but unused, while `experience/types.ts` says nothing in Track F may draw progress toward twelve months; delete the field to match the stated rule.
8. **Portability guard is incomplete.** `tier1-portability-lint.mjs` lists ~43 files by hand (36 listed plus the 7 registry files). Not listed but meant to be tier 2: `screeners/*`, `contractions`, `appointments`, `fertility`, `vitals/weight`, `followup`, `pregnancy/movements`, `pregnancy/symptoms`, `persona/minor`, `medications`. Alias imports exist today in `cycle/calendar.ts:1`, `cycle/insights.ts:1`, `menopause/index.ts:1`; `calculators/index.ts:1` has an extensionless `./dates` — all would break in Deno/Dart-style resolution (none is imported by the Edge Function today).
9. **Edge Function deploy is manual and silent.** STATE.md warns that registry edits do nothing until `supabase functions deploy experience` runs and that a Track Z change shipped without it. The browser fallback hides the lag (same code, different version). Not relevant if the Edge Function is dropped.
10. **Documents carry conditions.** `ExperienceConfig.modifiers` = her condition codes, cached in `localStorage` in clear (`client.ts`). Fine in the old model; in a private-on-device model it is just local state.
11. **Large rule file.** `resolver.ts` 805 lines (the repo's own 300-line guideline); `track-e.ts` 404; `reading.ts` 318 mixes a mapping, a to-do list, and logic (week slug).
12. **`Phase` includes `"preconception"`** (`types.ts`) but `phaseFor` never returns it; only a fixture and D4 use it. Minor dead vocabulary.
13. **v2 contract is infrastructure ahead of use.** `v2/types.ts` header says "Nothing reads v2 yet" (Checked in comment); STATE.md mentions a v2 log screen behind a flag. Compiled default is v1 everywhere. Without a server, a served-UI contract has no purpose (judgement).

---

## 11. Keep / rebuild / delete verdict

Judged against: private Android app (Flutter, data on the phone, no accounts, no Supabase at runtime); website as static teaser (articles, calculators, SEO); wedge = Arabic-first TTC → pregnancy with PCOS depth, Saudi + Egypt.

### Port or keep for the Flutter app (pure logic, high value)
| Module | Verdict | Reason |
|---|---|---|
| `cycle/predict.ts` | **Keep (already ported)** | Core of the wedge; Dart twin exists and passes the fixture. Add fixtures for the 90-day, >6-cycle and usable-empty branches. |
| `cycle/phases.ts`, `variability.ts`, `symptom-patterns.ts`, `day-states.ts`, `cycle-report.ts` | **Port** (phases + variability first) | Needed for calendar and the visit summary; no fixtures yet — write them first. Resolve the ovulation-window conflict (smell 2) before porting. |
| `pregnancy/index.ts`, `movements.ts`, `symptoms.ts` | **Keep / port symptoms** | Pregnancy is half the wedge. `symptoms.ts` urgency tiers are safety-critical and mirror the warning-signs article; no Dart twin yet. |
| `contractions`, `appointments`, `fertility` (BBT), `vitals/weight` | **Keep (ported)** | Already in Dart with fixtures. |
| `followup/index.ts`, `menopause/index.ts` (arithmetic), `medications` (shape) | **Port later** | Small, pure; follow-up only matters post-pregnancy. Drop `monthsRemaining` and the row mappers. |
| `screeners/*` | **Port with fixtures — high priority** | Postpartum and general mood are in scope; item-10 / item-9 crisis flag is a safety rule. Currently no cross-language fixture. Keep "no bands" rule. |
| `crisis/crisis.json` + `crisis/content.ts` + `directory.ts` | **Keep** (content asset) | Reviewed copy in 4 locales; reuse as Flutter asset; keep the expiry guard idea. |
| `patterns/*` (engine only: confidence, cycles, co-occurrence, severity) | **Port later / optional** | Valuable for PCOS depth; needs ≥3 cycles and fixtures. Drop `rows.ts`/`recompute.ts` (table + Edge Function). |
| `charts/geometry.ts` | **Rebuild natively** | Flutter draws its own; keep the rules (no target bands, RTL flip, padding) not the code. |
| `persona/resolver.ts`, `signals.ts`, `signals-from-rows.ts`, `conditions.ts`, `followup.ts`, `transitions.ts` | **Keep, trimmed, run on-device** | Hypothesis: for the wedge you need C1/C2/C3/C6, D1/D2/D3/D4/D7, B5/B6, E1/E6, Z1; defer A and F tracks. Fixtures for it already exist and are "notYetPorted" — porting them is mostly writing Dart adapters, but first fix smell 1 and decide whether 23 rules are too many for a first release. Persona *choice* may be simpler if the user states her stage (already the rule in `resolveForStatedTrack`). |
| `experience/build.ts`, `types.ts`, `layers.ts`, `phase.ts` + registry records for the kept personas | **Keep as a local resolver; simplify** | The layering/hero/tone rules encode real product rules. Without a server it is a local function, not a "document" — consider whether Flutter needs ExperienceConfig at all or just a small `HomePlan` per persona (Hypothesis). |

### Keep for the static website / calculators
| Module | Verdict |
|---|---|
| `calculators/index.ts`, `calculators/dates.ts` | **Keep (TS)** for the teaser calculators; reconcile with the app on EDD method, ovulation window, "regular" threshold and gestational cap, and cite each source. Fix extensionless import if shared. |
| `pregnancy/index.ts` (EDD maths) | **Keep**; make the public due-date calculator use the same function the app does. |
| `crisis/*` | **Keep** if the site ships a "help now" page. |

### Tied to the closed web tracker (do not carry over)
| Module | Verdict | Reason |
|---|---|---|
| `persona/state.ts`, `persona/signals-from-db.ts`, `onboarding/complete.ts` | **Delete / replace** | Supabase auth, `persona_state`, consent rows, anonymous sign-in. Replace with local storage; keep the questions (conditions, TTC months, birth recency). |
| `experience/client.ts`, `supabase/functions/experience/index.ts`, `supabase/functions/patterns/index.ts` | **Delete** | Server delivery + cache + fallback. The pure modules they call are the asset, not these. |
| `experience/v2/*` except `vocabulary.ts`, `log-search.ts`, `ground.ts` | **Delete / park** | Served-UI contract, flags, variables, upgrade path — all presuppose a server. Keep `vocabulary.ts` (51-term log list; already generated into Dart) and `log-search.ts`. |
| `experience/reading.ts` | **Rebuild** | Topic→CMS-slug map belongs with the content pipeline, not the engine. |
| `insights/*` | **Delete** | Staff aggregate dashboard over server RPCs; incompatible with a no-accounts product. |
| `patterns/rows.ts`, `patterns/recompute.ts`, `medications` row mappers, `v2/log-write.ts` | **Delete** | Table and RPC shapes. |
| `persona/minor.ts` | **Keep the idea** | Still relevant for analytics/consent gating in the app; trivial to port. |

---

## 12. Open questions

1. Is `hotFlushes` / `troubleSleeping` (resolver) versus `hotFlashes` / `insomnia` (logger) really a mismatch in production data? Needs one real log row from a perimenopause test account, or a look at `symptom_logs.type` values (I only grepped code).
2. Which ovulation/fertile-window rule does the owner want as *the* rule (10–16 days before next period, or next − 14 ± fixed window), and which source is cited? Both need a clinician-reviewed sentence.
3. Does the Flutter v1 need the full persona resolver, or does she simply choose a stage and a few conditions (the `resolveForStatedTrack` path)? The answer decides whether the 4 deferred fixtures are ported or retired.
4. Is the `experience` Edge Function currently deployed and used in production? STATE.md says deployment is a manual owner task; I did not check the live project.
5. Is the web `todayISO()` UTC date a live problem for Egypt/Saudi users near midnight? Needs a test in the UI with a +02:00 clock.
6. Which of the 24 persona records are actually reachable by real users today (as opposed to by tests)? Reachability tests use synthetic signals; no real-use numbers were available to me (**synthetic fixture** evidence only).
7. Should the EPDS/PHQ-9/GAD-7 clinician reviewer sign-off be recorded in repo (it is for crisis copy, not for screener wording)? I could not find it in the code; `[NEEDS SOURCE]` for the item wordings' licences, I only saw citations in comments.
8. Fixture cases for prediction: should the late-added branches (90-day gap, six-cycle window, usable-empty fallback) get fixtures before the Dart app relies on them?
