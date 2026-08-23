# 29 — Build progress

The checkpoint ledger for `docs/29_REBUILD/07_SEQUENCE.md`. **Update it in the same
commit as the work**, so an interrupted session can resume from this file alone.

**Resuming?** Read the last `[~]` line, or the first `[ ]` under the earliest phase
with open items. Then read that phase's chapter. Nothing here is a summary of the
plan — it is only what has and has not been done.

Status marks follow the MASTER_TODO covenant: `[ ]` open · `[~]` in progress ·
`[x]` done with commit · `[BLOCKED]` · `[DEFERRED]`.

---

## Phase A — Foundations ✅ **CLOSED 2026-08-23** (`69a72cb`)

Seven migrations (`0015`–`0021`) written and the stroke scale landed. **Not yet applied
to any database** — running them is an owner task, see `runbooks/BLOCKERS.md`. Gate
green: typecheck, 756 tests in 70 files, eslint, token parity.

Three of the plan's asserted gaps turned out not to exist (C-8, C-9 in the teardown
ledger). Chapters 02 §3 and 05 §1–2 are corrected in place.

Chapter [02_DATA_MODEL.md](02_DATA_MODEL.md), [05_DESIGN_SYSTEM.md](05_DESIGN_SYSTEM.md) §1.

- [x] A1 · `0015_period_days.sql` — per-day flow, backfilled from `cycles`
- [x] A2 · `0016_log_dimensions.sql` — `symptom_logs.dimension`, mood backfilled
- [x] A3 · `0017_log_provenance.sql` — `source` on `vitals` + `fertility_logs`; **BBT/discharge/intercourse already existed** (chapter 02 §3 corrected)
- [x] A4 · `0018_predictions.sql` — prediction with basis, two tiers, outcome
- [x] A5 · `0019_patterns.sql` — persisted findings with evidence and dismissal
- [x] A6 · `0020_experience_documents.sql` — served documents, per contract version
- [x] A7 · `0021_feature_flags.sql` — remote config with supplier order
- [x] A8 · `--stroke-*` width scale + preset + parity lint; **spacing/radius needed no migration** (chapter 05 §1 corrected)

**Phase gate.** Every migration has RLS policies (grants inherit from `0014`'s
`alter default privileges`). Backfills verified. `lib/patterns` byte-identical on
golden fixtures. Nothing in the UI changes.

---

## Phase B — The contract

Chapter [03_EXPERIENCE_ENGINE.md](03_EXPERIENCE_ENGINE.md).

- [ ] B1 · `ExperienceConfig` v2 types — the eleven-field module envelope
- [ ] B2 · `SurfaceMap` — home, calendar, learn, tools, insights
- [ ] B3 · `LogVocabulary` as a tier-1 artefact (OD-5 scope)
- [ ] B4 · Variables — `writes` / `reactsTo`
- [ ] B5 · Resolver emits v1 **and** v2; per-surface flags
- [ ] B6 · `tools.featured` orders never filters — with a lint

**Phase gate.** v1 output byte-identical to before. Golden fixtures extended.
`a11y` and `impression` required — a module without them does not compile.

---

## Phase C — The visible foundation

Chapter [05_DESIGN_SYSTEM.md](05_DESIGN_SYSTEM.md), [06_SCREENS.md](06_SCREENS.md).

- [ ] C1 · Colour families: per-log-category + alt, interaction states, focus ring, chart, skin tones, confidence
- [ ] C2 · Motion vocabulary + logging confirmation + prediction change + phase crossfade
- [ ] C3 · Chart primitives ×7 (web), golden fixtures
- [ ] C4 · Dashboard on v2 — phase-as-ground, served modules, explain affordance
- [ ] C5 · Calendar promoted to a tab — seven day-states, **both probability tiers**
- [ ] C6 · Log screen — search, per-day navigation, reorderable categories, severity
- [ ] C7 · Designed empty / loading / error / offline states

---

## Phase D — Depth

- [ ] D1 · Expanded vocabulary (symptom, mood, discharge, BBT, one intercourse marker)
- [ ] D2 · Patterns as home modules with confidence and evidence
- [ ] D3 · Prediction explanations from `basis_json`
- [ ] D4 · Search across articles, conditions, glossary, calculators
- [ ] D5 · Learn surface rebuilt, attribution on the card
- [ ] D6 · Onboarding as a document, under fifteen steps

---

## Phase E — Clinician bridge and taxonomy

- [ ] E1 · My questions
- [ ] E2 · The visit pack
- [ ] E3 · Remaining pregnancy tools
- [ ] E4 · Wire the remaining personas + lint
- [ ] E5 · Condition-awareness end to end
- [ ] E6 · Teen posture
- [ ] E7 · The difficult transitions
- [ ] E8 · Privacy ledger

---

## Phase F — Content (runs from A onward)

- [ ] F1 · `content_locale` with per-locale review state
- [ ] F2 · Arabic for the 31 live articles — **needs a named Arabic-competent reviewer**
- [ ] F3 · Region-authored content
- [ ] F4 · Weekly pregnancy content restructured
- [ ] F5 · French and Spanish

---

## Phase G — Mobile (after the web app is right)

- [ ] G1 · Flutter clients on the served documents
- [ ] G2 · Health Connect / HealthKit
- [ ] G3 · Home-screen widget
- [ ] G4 · Dart chart primitives

---

## Session log

Newest first. One line per checkpoint, with the commit.

| When | What | Commit |
|---|---|---|
| 2026-08-23 | **Phase A closed** — gate green: typecheck, 756 tests, eslint, token parity | `69a72cb` |
| 2026-08-23 | **A8** `--stroke-*` widths; corrected ch.05 — spacing fine, focus ring already existed | `69a72cb` |
| 2026-08-23 | **A6+A7** `experience_documents` + `feature_flags` with an audit trigger | `b46d12e` |
| 2026-08-23 | **A5** `patterns` — evidence, confidence, dismissal; column-level grant | `854a741` |
| 2026-08-23 | **A4** `predictions` — basis, two tiers, outcome; tier-1 write only | `70f3c6e` |
| 2026-08-23 | **A3** provenance on measured values; corrected ch.02 §3 — BBT, discharge and the intercourse marker already exist | `f1d80b9` |
| 2026-08-23 | **A2** `symptom_logs.dimension` — mood its own dimension, 9 keys backfilled | `46bd13e` |
| 2026-08-23 | **A1** `period_days` — per-day flow, backfilled, RLS, idempotent | `5ca727b` |
| 2026-08-23 | Plan written, phases opened, nothing built yet | `de2cb28` |
