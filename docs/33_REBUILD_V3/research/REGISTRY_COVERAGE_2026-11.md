# Ask femio — trusted-source coverage, 2026-11-24/25 (R7.13, R7.14)

What this is: a measured answer to the owner's report that "many questions are not answered", and
the follow-up that closed every item the first pass left open. A fixed question set runs through the
same on-phone path as Ask femio (`safetySignal`, the "do I have X?" rule, then `searchRegistry`).
**Every number below comes from synthetic question sets written for this test, not from real use.**
femio collects no real questions.

## How it is measured

- **Main set:** `apps/mobile/test/fixtures/registry_questions.json`. 165 answerable questions in seven
  groups that follow the wedge personas. Each is in English and Egyptian/Gulf-style Arabic, and about a
  quarter are also in French and Spanish (419 runs). Ten rules questions are added: five on birth
  control and five "do I have X?". The lexicon and ranking were tuned on this set, so its score is an
  upper bound.
- **Held-out set:** `registry_questions_holdout.json`. 30 questions in English and Arabic (60 runs),
  written after tuning and never used for it. **First run: 54 of 60 strong (90%).** This is the honest
  estimate for wording the tuning had not seen. Its six misses were lexicon gaps ("ovulating",
  "vitamins", "جوزي" for husband, "exercising", "العضم" for bones, "يناموا" for sleep), and they were
  then fixed. The set is now spent and guards only against regressions. Write a fresh one before the
  next measurement.
- **Runner:** `apps/mobile/test/registry_coverage_test.dart` writes
  `build/registry_coverage.json` and `build/registry_coverage_holdout.json`. Then
  `python scripts/registry-coverage-report.py` prints the tables. The test fails in any of these
  cases:
  - main-set strong share below 95%;
  - "not covered" above 2%;
  - held-out strong share below 75%;
  - a birth-control question reaches the registry;
  - a "do I have X?" question misses the clinician notice.
- **Grades:**
  - *Strong:* a returned passage contains the stem the question is about. For three questions,
    `alsoAccept` also counts a passage the lead read and judged to answer the question without the
    stem. That is hand grading: m02 "about 5 days", e08 "weight gain", t28 "so early".
  - *Weak:* passages came back, but none of them answers the question.
  - *None:* no passage. She sees "Not covered yet" and links.
  - *Rule:* a safety rule answered first.

## Before and after (main set)

| Group | Asked | v.2 (start) | v.3 (R7.13) | v.4 (R7.14) |
|---|---|---|---|---|
| Trying to conceive and PCOS | 75 | 42 (56%) | 68 (91%) | 75 (100%) |
| Pregnancy, week by week | 91 | 24 (26%) | 81 (89%) | 91 (100%) |
| After birth and feeding | 62 | 20 (32%) | 50 (81%) | 60 (97%) |
| Periods and cycle tracking | 66 | 44 (67%) | 56 (85%) | 64 (97%) |
| First periods | 35 | 20 (57%) | 29 (83%) | 33 (94%) |
| Perimenopause and menopause | 46 | 24 (52%) | 41 (89%) | 46 (100%) |
| General wellness | 44 | 16 (36%) | 41 (93%) | 44 (100%) |
| **All, strong** | **419** | **190 (45%)** | **366 (87%)** | **413 (99%)** |
| **Not covered** | | **82** | **8** | **4** |

| Language | Asked | Start | R7.13 | R7.14 |
|---|---|---|---|---|
| English | 166 | 74 (45%) | 149 (90%) | 163 (98%) |
| Arabic | 166 | 69 (42%) | 137 (83%) | 163 (98%) |
| French | 43 | 24 (56%) | 41 (95%) | 43 (100%) |
| Spanish | 44 | 23 (52%) | 39 (89%) | 44 (100%) |

## What was added

The registry grew from 89 entries (2026-11-24.2) to 299 (2026-11-24.4).

| Publisher | Kind | R7.13 | R7.14 |
|---|---|---|---|
| Office on Women's Health | passage | 95 | 4 |
| CDC | passage | 27 | 3 |
| NICHD | passage | 10 | 2 |
| NIA, NIMH | passage | 10, 9 | — |
| MedlinePlus (health topics and Genetics; never `/ency/`) | passage | 8 | 3 |
| NIDDK, NIH ODS, NCI | passage | 2, 2, — | —, —, 1 |
| NHS, Saudi MOH (Arabic), ACOG, RCOG, WHO | link | 21, 4, 3, 3, 3 | — |

- **Verbatim check:** every passage was compared with its live page. Most were fetched with Python.
  CDC and ODS block scripts, so those were fetched in a real browser. Every passage matches.
- **Merge validation:** `scripts/registry-merge.py` refuses a whole merge if any entry has a wrong
  publisher, an `/ency/` link, a length outside 12–90 words, contraception wording, or a duplicate.
- **Drops in review:**
  - R7.13 dropped 12: duplicates, US-only 911/988/season items and weak passages.
  - R7.14 dropped 6: three duplicates of existing entries, two passages already contained in
    existing ones (MedlinePlus miscarriage, CDC "enough milk"), and an ACS-guideline sentence about
    starting screening at 25 (US-specific).
- **Section titles:** seven entries now carry their section heading in the title. One example is
  "Stages of pregnancy — Third trimester (week 29–week 40)"; the heading was read on the page.
- **12-week passage:** it now starts with the page's own "At 12 weeks:" lead-in. That lead-in
  immediately precedes the passage on the page, so the text is still verbatim.

## Code changes

- **"Do I have X?"** (`diagnosis.dart`, MR-51): a question with a cue such as "do I have", "هل عندي",
  "est-ce que j'ai" or "¿tengo", that also names a condition, shows the fixed sentence "Only a
  clinician can tell…" before the passages. The search still runs.
  - Questions like "Do I have to…" and "Why do I have…" are excluded.
  - All 12 diagnosis runs get the notice, and no answerable question does.
  - Screenshots: `testing-results/2026-11-24-r7-assistant/{en_light,ar_dark,ar_light}_ask_diagnosis.png`.
- **False alarms** (`safety.dart`, MR-50 note):
  - In pregnancy, "blood type", "blood test" and "فصيلة الدم" are no longer read as bleeding. "Blood"
    on its own still is.
  - After birth, a lone "نزيف" in a question about how long bleeding lasts, or whether it is normal,
    is not a warning.
  - "عندي نزيف" (I'm bleeding), "نزيف جامد" (heavy bleeding) and "soaking a pad every hour" still are.
    "Pad every hour" was added in four languages.
- **Ranking:**
  - A passage that names her topic in its own text or section heading gains a point.
  - Two-digit numbers count as rare words.
  - A link in her language ranks first.
  - Ties go to the more focused entry.
- **Lexicon:** about 75 new topics across both passes. Examples are IUI, the three trimesters,
  caffeine, milk storage, perimenopause, genitourinary syndrome, mammogram, ultrasound and chemical
  pregnancy.

## Unanswered by design (no allowed source)

| Question | What she sees |
|---|---|
| Hair loss after birth (e19) | "Not covered yet" and NHS after-birth links. No federal page has the text. The only one is MedlinePlus `/ency/`, which is copyrighted. NHS "Hair loss" does not mention birth. |
| Adenomyosis (m12) | "Not covered yet" and the NHS adenomyosis link. No federal page found; the OWH page returns 404. |
| Talking to a daughter about her first period (f08) | MedlinePlus puberty passages, plus the NHS "Starting your periods" link, which has the parent advice. |

These would need femio's own reviewed summary. Under ADR-079, Ask femio shows only verbatim public
sources, so they stay link-only on purpose.

## Re-run

```
cd apps/mobile && flutter test test/registry_coverage_test.dart
cd ../.. && python scripts/registry-coverage-report.py
```
