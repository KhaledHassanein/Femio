# Ask femio — trusted-source coverage, 2026-11-24 (R7.13)

What this is: a measured answer to the owner's report that "many questions are not answered". A fixed
question set runs through the same on-phone path as Ask femio (`safetySignal`, then `searchRegistry`),
before and after widening the registry. **Every number below comes from a synthetic question set
written for this test, not from real use.** Real questions will differ; re-run after launch with
anonymised real wording if the owner ever collects it (femio collects none today).

## How it is measured

- **Question set:** `apps/mobile/test/fixtures/registry_questions.json`, 165 answerable questions in
  seven groups that follow the wedge personas, each in English and Egyptian/Gulf-style Arabic, about a
  quarter also in French and Spanish (419 runs), plus 10 rules questions (five birth-control, five
  "do I have X?").
- **Runner:** `apps/mobile/test/registry_coverage_test.dart` writes `apps/mobile/build/registry_coverage.json`;
  `python scripts/registry-coverage-report.py` prints the tables. The test fails if strong falls below
  85% or "no passage" rises above 8%, or if any birth-control question reaches the registry.
- **Grades:** *strong* = a returned passage contains the stem the question is about (hand-written per
  question, e.g. `mastitis`, `folic`); *weak* = passages came back, none contains the stem (often a
  near miss, sometimes a grading artefact); *none* = no passage, she sees "Not covered yet" and links;
  *rule* = a safety rule answered first.

## Before and after

Registry 2026-11-24.2 (89 entries) → 2026-11-24.3 (286 entries: 163 passages and 34 links added).

| Group | Asked | Strong before | Strong after | None before | None after |
|---|---|---|---|---|---|
| Trying to conceive and PCOS | 75 | 42 (56%) | 68 (91%) | 8 | 0 |
| Pregnancy, week by week | 91 | 24 (26%) | 81 (89%) | 27 | 2 |
| After birth and feeding | 62 | 20 (32%) | 50 (81%) | 18 | 2 |
| Periods and cycle tracking | 66 | 44 (67%) | 56 (85%) | 10 | 2 |
| First periods | 35 | 20 (57%) | 29 (83%) | 2 | 0 |
| Perimenopause and menopause | 46 | 24 (52%) | 41 (89%) | 5 | 2 |
| General wellness | 44 | 16 (36%) | 41 (93%) | 12 | 0 |
| **All** | **419** | **190 (45%)** | **366 (87%)** | **82** | **8** |

| Language | Asked | Strong before | Strong after |
|---|---|---|---|
| English | 166 | 74 (45%) | 149 (90%) |
| Arabic | 166 | 69 (42%) | 137 (83%) |
| French | 43 | 24 (56%) | 41 (95%) |
| Spanish | 44 | 23 (52%) | 39 (89%) |

About a third of the gain came from the lexicon alone (190 → 256 strong before any new passage).

## What was added

| Publisher | Kind | Added |
|---|---|---|
| Office on Women's Health | passage | 95 |
| CDC | passage | 27 |
| NICHD | passage | 10 |
| NIA | passage | 10 |
| NIMH | passage | 9 |
| MedlinePlus (NLM, health-topic pages only; `/ency/` is A.D.A.M. and banned) | passage | 8 |
| NIDDK, NIH ODS | passage | 2 + 2 |
| NHS | link | 21 |
| Saudi MOH (Arabic) | link | 4 |
| ACOG, RCOG, WHO | link | 3 + 3 + 3 |

- **Verbatim check:** every new passage was compared with its live page (Python fetch; CDC and ODS
  refuse scripts, so those were checked by `fetch` in a real browser). All match after whitespace and
  quote folding. Each entry carries its URL, publisher, reviewed date (2026-11-24), language and the
  licence note; `scripts/registry-merge.py` refuses a whole merge on any wrong publisher, `/ency/`
  link, passage outside 12–90 words, contraception wording or duplicate.
- **Dropped in review (12):** five duplicates; four US-only items (911, the 988 line, a US-only RSV
  season, a TSS passage that also names a diaphragm); three weak passages (a pointer to a table, a
  single-study news release, a passage opening with an unexplained "This").
- **Code:** topic table split into `topic_table.dart` (~60 new topics); `SourceEntry.lang` (missing =
  `en`); a link in her language ranks first; ties go to the entry with fewer topics she did not ask
  about; up to +2 for uncommon words (5+ letters) shared with the entry. New public-domain publishers:
  NIA, NIMH, NHLBI, NIH ODS, NIAMS; Saudi MOH is link-only (ADR-079 addendum 2026-11-24).

## Still not answered well (synthetic set)

| Question | Why | What would fix it |
|---|---|---|
| Cholestasis of pregnancy (p29) | No passage from an allowed publisher added | NHS/RCOG links are there; a reviewed femio summary, or a NICHD page if one appears |
| Hair loss after birth (e19) | No passage from an allowed publisher added | Same |
| Adenomyosis (m12) | No passage from an allowed publisher added | Same |
| Pap test after menopause (n16) | No passage added in this pass | A CDC or NCI cervical-screening passage |
| Chemical pregnancy (t28), caffeine and fertility (t23), IUI (t20) | No allowed source in plain words | Link-only RCOG/NHS, or femio's own reviewed summary |
| Talking to a daughter about her first period (f08), athletes (f12) | NHS link only; passages are near misses | — |
| Late period (m03), healthy diet (w10) | Ranking: broad questions pull PCOS or nutrition passages first | Tune in R7.10 |
| p03, e11, m02 | Grading artefacts: the right passage is returned but says "third trimester" / "breast infection" / "about 5 days" | None needed |

## Safety findings (not changed here)

1. **"Do I have X?" questions are not stopped by a rule.** r06–r10 reach the registry; only the model
   prompt forbids a verdict, and with no model she sees passages, not a verdict. Worth a dedicated
   diagnosis rule (fixed wording: "only a clinician can tell; here is what the sources say") — a
   follow-up, not invented here.
2. **Two Arabic false alarms, both on the safe side:** "فصيلة الدم سالب في الحمل" (Rh-negative) opens the
   pregnancy warning because of "دم"; "النزيف بعد الولادة بيستمر قد ايه" (how long does bleeding last
   after birth) opens the postpartum warning because "نزيف" is in the heavy-bleeding list. Left as is:
   a false alarm is cheaper than a missed one; tune with the clinician review (R7.10).
3. Birth-control questions: 16/16 runs stopped by the rule. Three Egyptian phrasings ("اتجنب الحمل",
   "امنع الحمل", "منع حمل") and two FR/ES phrasings were missing before and are now in `safety.dart`.

## Re-run

```
cd apps/mobile && flutter test test/registry_coverage_test.dart
cd ../.. && python scripts/registry-coverage-report.py
```
