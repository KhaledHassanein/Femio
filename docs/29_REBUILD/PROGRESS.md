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

Seven migrations (`0015`–`0021`) written and the stroke scale landed. **Applied to the
linked project** — verified 2026-08-28: `migration list --linked` shows all 21 present
in both columns, and `db push --dry-run` reports the remote up to date. Gate
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

## Phase B — The contract ✅ **CLOSED 2026-08-23**

Gate green: typecheck, 813 tests in 75 files, eslint, and all eleven guards. v1 is
byte-identical because `build.ts` was never touched — v2 is derived from its output.
**Nothing reads v2 yet**; every surface flag defaults to v1, so the app is unchanged.

Chapter [03_EXPERIENCE_ENGINE.md](03_EXPERIENCE_ENGINE.md).

- [x] B1 · v2 contract in `lib/experience/v2/types.ts` + 4 pinned invariants; **`impression` corrected to first-party `measure`** (ch.03 §2)
- [x] B2 · `SurfaceMap` — landed with B1 (home, calendar, learn, tools, insights)
- [x] B3 · `LogVocabulary` — **51 terms unified from 3 places, not expanded**; 1 intercourse term; ar wording → B14
- [x] B4 · Variables — seeds read-only, wiring validated (unknown refs, double writers, cycles), reactivity opt-in
- [x] B5 · `toV2` derivation (v1 untouched, asserted over all 9 golden cases) + per-surface flag resolution
- [x] B6 · `tools-completeness-lint` — union ↔ screen in sync both ways, no persona filter; **`ToolId` corrected (6 wrong)**

**Phase gate.** v1 output byte-identical to before. Golden fixtures extended.
`a11y` and `impression` required — a module without them does not compile.

---

## Phase C — The visible foundation  ⏳ in progress

Chapter [05_DESIGN_SYSTEM.md](05_DESIGN_SYSTEM.md), [06_SCREENS.md](06_SCREENS.md).

- [x] C1 · 49 tokens: log ×8+alt, chart ×10, confidence ×4, skin ×5 — light+dark, preset-mapped, **both guarded**; interaction states and focus ring already existed
- [x] C2 · Motion **vocabulary** — 5 durations + 7 pairings, easings de-duplicated, guarded; the confirmations/crossfade themselves land with C4–C6
- [x] C3 · 7 primitives — geometry tier-2 (30 tests) + SVG renderers; `chart-literals-lint`; **captions and RTL required by construction**
- [x] C4 · **v2 renders behind its flag.** `HomeShell` + `ModuleHost` + phase-as-ground; `module-registry-v2` as an *adapter* over v1's renderers (`ModuleId` is shared — two lists would drift until a flag flip exposed it); `useSurfaceVersion` resolving **remote → cached → compiled v1** per `0021`, 5 tests on the order; 11 module labels ×4 locales.
  **The mount went in at `ExperienceModules`, not the dashboard**, and that is the whole of C4a. `HomeShell` needs one `ModuleContext`; each of the six experience components builds its own privately, so none exists a level up. The first attempt extracted all six — a large change to v1 for a flag that is off — and was reverted. Every track already *hands* its context to `ExperienceModules`, so the branch lives at that single choke point and v1's path below it is byte-identical.
  Verified with the flag on, in en/light, en/dark and ar: **zero console errors, and 8 aria-labelled regions where v1 has 2** — the contract's promise, kept by the host rather than by fifty authors.
  **Still open:** the explain affordance (needs D3).

- [x] C5 · **Calendar is a tab, with all seven day-states and both probability tiers.** `lib/cycle/day-states.ts` is tier-2 with 9 tests; `CalendarMonth` draws it; `/calendar` joins them and is the **first consumer of `period_days` and `predictions`** — nothing read either Phase-A table before this.
  **States are a set, not an enum.** A day can be logged bleeding *and* today *and* carry other logs, and the grid draws all three. An enum would force a precedence order into the data model where nobody can see it, and the first collision would produce `todayAndPeriod`. Precedence lives in CSS instead.
  **Both tiers render as two things.** Firm ring from `predictions.likely_*`, soft dashed ring from `window_*`. Flo computes both — its string catalogue distinguishes "likely to start" from "may start" — and draws one ring. It also does not assume `likely ⊆ window`: if a model change made them disjoint, both flags stay honest.
  **RTL proven, not assumed.** The caps use `border-start-start-radius`, so the run-start cap measures **left in LTR and right in RTL** — verified against a rendered page, because ch.06 §2 names this as the thing that ships broken if nobody looks.
  Verified in en/light, ar/rtl and en/dark with seeded per-day flow: 42 cells, 4 flow-graded fills, 2 run caps, **42 of 42 cells carrying a full-sentence accessible label**, none under the 44px target, zero console errors.
- [x] C6 · **Log screen — one surface over four tables, behind `experience.v2.log`.** `lib/experience/v2/log-search.ts` (search, reorder, hide) and `log-write.ts` (which table each dimension lands in) are tier-2 with 21 tests between them; `SeverityChip` collects the 0–4 level Flo never asks for. **First writer `public.vitals` has ever had** — CLAUDE.md listed it as unused since schema v1 (`0001`). Mounted at `/track` rather than a second `/log` route, so there is never a question which logging screen is real; the flag defaults off, so production is unchanged until it is flipped. Two shapes are forced by the schema and are deliberate: cervical mucus is single-select (`fertility_logs.cm_type` is one column) and vitals get numeric fields rather than chips (a chip cannot hold a measurement). **Rendered and looked at before being called done** — which found four defects a green gate could not: `inset-inline-start-3` is not a Tailwind utility, so the search icon emitted no positioning and sat on its own placeholder; `sticky bottom-0` parked the save bar under the tab bar and the crisis launcher, fixed with `--content-clearance`; bidi reordered `°C` to `C°` after Arabic text; and `steps: "count"` printed "Steps (count)" in four locales. `seed-and-shoot.mjs` gained `--route`, `--flags` (seeding the client's cached flag source, the only way to see a screen before it ships) and **a viewport-bottom shot** — `fullPage` expands the viewport, so a bottom-anchored control is invisible in exactly the screenshot taken to check it.
- [x] C7 · **Designed empty / loading / error / offline states — and the two defects that made the offline one unreachable.** `ScreenError` now asks `useOnline()` and swaps in offline copy at `warning` weight rather than `danger`, which fixes all seven callers at once — losing signal is ordinary, and a retry that cannot succeed is worse than none. New shared `states` namespace, native in four locales. **Two screens rendered a failed or in-flight read as an empty record**: `next-appointment-card` and `weight-chart` both said *you have nothing* while the fetch was still running, with the entry form directly above reading as confirmation. `summary-screen`'s hand-rolled skeleton and error were longhand copies of the shared patterns — which is how a screen quietly stops inheriting fixes, and is exactly why it had missed the offline distinction. **Then the offline shoot found the severe one: `AuthGate` treated an unreachable auth server as *signed out* and redirected a signed-in woman to onboarding**, so her account looked gone and no offline state in the app was reachable behind it. `getSession()` reads storage with no network call, so the three cases separate cleanly: no stored session → anon; stored session and server unreachable → show the app; stored session and server says no → anon. Safe because RLS is the boundary, not this component. **And behind that, a second one:** supabase-js retries with backoff, so on a dead connection the promise never settled and the screen held its skeleton forever — a loading state that can never end is a hang wearing the right colours. Every read now races a 15s deadline. 15 guard tests; the offline state photographed at 390×844 in Arabic RTL.

---

## Phase D — Depth

- [x] D1 · **Expanded vocabulary — built during C6 and closed here rather than re-done.** `lib/experience/v2/vocabulary.ts` carries 45 existing symptom/mood terms, 5 cervical-mucus terms, the single intercourse marker (OD-5 — a date and nothing else, not a taxonomy of acts) and 9 vitals, typed by dimension with `severityScale` per term, 14 tests. C6's log screen is what made them reachable. **BBT is deliberately absent**: it lives in `fertility_logs.bbt` (migration `0017`) and duplicating it here would create two sources of truth for one measurement — the spec line names BBT, and the honest reading of it is *BBT is trackable*, which it already was.
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
| 2026-08-23 | **C4 (part)** v2 home shell, module host, phase-as-ground, 851 tests | _pending_ |
| 2026-08-23 | **C3** seven chart primitives, geometry split for the Dart twin, 843 tests | `665182b` |
| 2026-08-23 | **C2** motion vocabulary; durations get CSS vars at last; build-verified | `2f15438` |
| 2026-08-23 | **C1** colour families + a dark-parity guard that caught its own bug | `4991fdb` |
| 2026-08-23 | **Phase B closed** — B5 derivation + surface flags, 813 tests | `fa29c24` |
| 2026-08-23 | **B6** tools lint, `ToolId` aligned to the real screen | `cfd0f66` |
| 2026-08-23 | `pnpm gate` added after a masked exit code | `94228c1` |
| 2026-08-23 | **B4** variables — seeds read-only, cycle detection, 791 tests | `33a2dda` |
| 2026-08-23 | **B3** `LogVocabulary` unified (60 terms), i18n ×4, tier-1 guarded, 777 tests | `7855924` |
| 2026-08-23 | **B1+B2** v2 contract + SurfaceMap, 763 tests | `8a513a5` |
| 2026-08-23 | **B13 closed** — migrations applied *and artifacts probed*; `pnpm db-artifacts-probe` added | `727dba5` |
| 2026-08-23 | **Phase A closed** — gate green: typecheck, 756 tests, eslint, token parity | `69a72cb` |
| 2026-08-23 | **A8** `--stroke-*` widths; corrected ch.05 — spacing fine, focus ring already existed | `69a72cb` |
| 2026-08-23 | **A6+A7** `experience_documents` + `feature_flags` with an audit trigger | `b46d12e` |
| 2026-08-23 | **A5** `patterns` — evidence, confidence, dismissal; column-level grant | `854a741` |
| 2026-08-23 | **A4** `predictions` — basis, two tiers, outcome; tier-1 write only | `70f3c6e` |
| 2026-08-23 | **A3** provenance on measured values; corrected ch.02 §3 — BBT, discharge and the intercourse marker already exist | `f1d80b9` |
| 2026-08-23 | **A2** `symptom_logs.dimension` — mood its own dimension, 9 keys backfilled | `46bd13e` |
| 2026-08-23 | **A1** `period_days` — per-day flow, backfilled, RLS, idempotent | `5ca727b` |
| 2026-08-23 | Plan written, phases opened, nothing built yet | `de2cb28` |
