# 29.07 — Sequence

Six phases. Each is a coherent unit of work with a gate; nothing in a later phase
depends on judgement from an earlier one being revisited.

**Order is not negotiable in the first two phases.** The whole diagnosis of `docs/26`
is that surface was built on foundations too thin to support it. Phase A and B are
those foundations.

**Platform, per OD-16:** the mobile-first web app first, tested in the browser. Dart
twins are written when tier 2 requires them (golden fixtures bind both), but no phase
waits on a mobile client existing.

---

## Phase A — Foundations *(nothing user-visible)*

| Work | Chapter | Why first |
|---|---|---|
| `0015` `period_days` | 02 §1 | The calendar and flow strip need per-day data |
| `0016` `symptom_logs.dimension` | 02 §2 | Mood as its own dimension; the OD-5 vocabulary needs somewhere to live |
| `0017` `vitals` kinds + `source` | 02 §3 | BBT has nowhere to live today |
| `0018` `predictions` | 02 §4 | **D2 is impossible without it** |
| `0019` `patterns` | 02 §5 | Lets D6 leave the `/patterns` route |
| `0020` `experience_documents` | 02 §6 | A contract bump needs something to migrate |
| `0021` `feature_flags` | 02 §7 | The per-screen migration depends on it |
| Numeric spacing/radius/border scale | 05 §1 | Cheapest now, while the surface is small |

**Gate.** Every migration carries RLS policies **and grants** — the `c1123e1` defect.
Backfills verified. `lib/patterns` output byte-identical on golden fixtures. Nothing
in the UI changes.

---

## Phase B — The contract

| Work | Chapter |
|---|---|
| `ExperienceConfig` v2 with the eleven-field module envelope | 03 §2 |
| `SurfaceMap` — home, calendar, learn, tools, insights | 03 §3 |
| `LogVocabulary` as a tier-1 artefact, OD-5 scope | 03 §4 |
| Variables (`writes` / `reactsTo`) | 03 §6 |
| Resolver emits v1 **and** v2; flags per surface | 03 §5 |
| `tools.featured` orders, never filters — with a lint | 03 §3 |

**Gate.** v1 documents byte-identical to what was served before. Golden fixtures
extended for v2. `a11y` and `impression` are required — a module without them fails to
compile. Still nothing user-visible.

**This is the phase that must not be skipped or partially done.** Everything after it
consumes the contract.

---

## Phase C — The visible foundation

The first phase a user notices, and the one Khaled named first.

| Work | Chapter |
|---|---|
| Colour families: per-log-category + alt, interaction states, focus ring, chart tokens, skin tones, confidence | 05 §2 |
| Motion vocabulary + logging confirmations + prediction-change + phase crossfade | 05 §3 |
| Chart primitives ×7, twice, on golden fixtures | 05 §4 |
| Dashboard on v2: phase-as-ground, served modules, explain affordance | 06 §1 |
| Calendar promoted to a tab, seven day-states, **both probability tiers** | 06 §2 |
| Log screen: search, per-day navigation, reorderable categories, severity | 06 §3 |
| Designed empty / loading / error / offline states | 05 §3, TD-16 |

**Gate.** 390×844, light and dark, Arabic RTL, screenshot as the test. Every chart has
a generated text alternative. Every prediction is tappable. Nothing is graded normal
or abnormal. No literal colours.

---

## Phase D — Depth

| Work | Chapter |
|---|---|
| Expanded vocabulary: symptoms, mood, discharge, BBT, one intercourse marker | 02 §2, 03 §4 |
| Patterns surfaced as home modules with confidence and evidence — D6 | 06 §1 |
| Prediction explanations from `basis_json` — D2 | 06 §1 |
| Search across articles, conditions, glossary, calculators | 04 §4 |
| Learn surface rebuilt with attribution on the card | 04 §4 |
| Onboarding as a document, under fifteen steps | 03 §7, 06 §6 |

**Gate.** Every new term exists in four languages at merge. The intercourse marker's
wording is reviewed for register in all four — OD-5. Patterns state their evidence and
can be dismissed.

---

## Phase E — The clinician bridge and the taxonomy

| Work | Chapter |
|---|---|
| My questions | 06 §5 |
| **The visit pack — D3** | 06 §5 |
| Remaining pregnancy tools: birth plan, to-do, hospital bag, baby names | 06 §5 |
| Wire the remaining personas; lint on spec-without-record | 03 §8 |
| Condition-awareness end to end — D7 | 06 §1 |
| Teen posture — D8 | 08 (teardown) |
| The difficult transitions — D9 | 08 (teardown) |
| Privacy ledger — D5 | 06 §7 |

**Gate.** Every specced persona registered or explicitly deferred with a reason. The
visit pack separates recorded from computed and interprets nothing.

---

## Phase F — Content, running throughout

Not last. **Start it in Phase A and run it continuously**, because it is the
highest-leverage item in the study and it is authoring and clinical-review work that
does not block on engineering.

| Work | Chapter |
|---|---|
| `content_locale` with per-locale review state | 04 §2 |
| Arabic: the 31 live articles first, named reviewer required | 04 §3 |
| Region-authored content: prevalence, Ramadan, conservative SRH framing | 04 §3 |
| Weekly pregnancy content restructured into three registers | 04 §6 |
| French and Spanish after Arabic | 04 §3 |

**Gate.** No locale publishes without its own named clinical reviewer and review date.

---

## Phase G — Mobile *(after the web app is right — OD-16)*

Flutter clients rendering the same served documents. Health Connect and HealthKit —
TD-07, the largest category of user data we currently refuse. Home-screen widget —
TD-15. The Dart twins of the chart primitives, already fixture-bound from Phase C.

---

## Dependencies, as a picture

```
A (schema + flags + scales)
└── B (contract v2)
    ├── C (tokens, motion, charts, dashboard, calendar, log)
    │   └── D (vocabulary, patterns, explanations, search, onboarding)
    │       └── E (visit pack, personas, conditions, teen, privacy)
    └── G (mobile — also needs C's fixtures)

F (content) ──── runs from A onward, blocks nothing, blocked by nothing
```

---

## Definition of done

Inherited from `docs/27` and extended in chapter 01 §6:

- 390×844 phone viewport, light **and** dark, **and** Arabic RTL. A screenshot is the
  test.
- Every served module ships with `a11y` and `impression` populated.
- Every prediction shown is tappable and explains what it rests on.
- Every new user-facing string exists in four languages at merge.
- Nothing labels a cycle, symptom or day normal or abnormal.
- Charts: token colours only, RTL-correct, text alternative generated from the data,
  honest at low n.

---

## What we retire

**`docs/27_REVAMP_PLAN_2026-08.md`** — superseded by this document. Mark it, leave it
in place per the covenant, do not work from it.

**The v1 `ExperienceConfig` path** — deleted one release after the last surface flips
(chapter 03 §5).

**`cycles.flow`** — deprecated by `period_days`, kept and commented, not dropped.

**Nothing else.** The three-source resolution, the tier-1/tier-2 split, the golden
fixtures, `persona_state`'s emphasis-only guarantee, the consent and audit
apparatus, and the i18n workflow are the parts of Femio that beat every app in the
study. This plan builds on them; it does not touch them.

---

## The measure

At the end of Phase E, the question from OD-14 should be answerable line by line
against `docs/28_TEARDOWN/06_COMPARISON_MATRICES.md`: **is Femio at least as good as
the three combined, and does it carry features none of them have?**

Six of the eleven matrices currently go against us. Phases C and D turn the design,
dashboards and vocabulary rows. Phase E turns personalisation and the clinician
bridge. Phase F turns content. Phase G turns integrations.

The rows that were already ours — life stages, data model, localisation, privacy,
clinical trust — are the ones to protect while doing it.
