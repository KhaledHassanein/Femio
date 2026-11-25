# Content revision and translation check (R3.10, 2026-11-24/25)

Why this file exists: the record of what the R3.10 pass changed in femio's user-facing text,
what it deliberately left alone, and what still needs a source or the owner's clinical call.
The commits carry the line-by-line detail; this is the index a later session or the owner
starts from.

## Method

- **English first.** Four read-only reviewers (Sonnet) read every published English guide (109)
  and every English UI string (app ARB, website catalogue, assistant catalogue) against
  `CLAUDE.md`, `docs/compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`,
  `CONTRACEPTION_SAFETY.md` and the screener rules. They returned 214 findings as tables; the
  lead checked each row against the file and its sources and applied 175 of them (115 in the guides, 60 in the strings).
  A rule sweep (`wordmark`, `Ramadan`, `Arabic-first`, `safe day`, diagnosis verbs, certainty
  words) ran over the same text by script.
- **Then the translations.** One `femio-translator` per language (Arabic, French, Spanish)
  translated every changed English string and passage, translated the rewritten "Meet femio"
  guide, and checked every existing UI string against the English. The lead reviewed each
  table before applying it.
- **Rule for safety tiers:** a sign was never moved to a lower tier without the owner. Where
  two pages disagreed, the stricter page was kept and the gap is listed below.

## What the translations covered (commits `d99b669`, `b052dde`, `ab31a58`)

Each of Arabic, French and Spanish received the same set; no key was added, renamed or removed.

- **UI strings**: every changed English website string (about 60) and app string (about 22),
  plus the assistant tips and visit questions, which live in
  `docs/content/assistant/catalogue.json` and are generated into the ARB files.
- **Meet femio**: the rewritten guide, body and frontmatter.
- **Week guides 4-40**: the Seek care now box (37 per language): the harm-thoughts sign with
  the help-now link, and the straight-away movement sentence where the English has it.
- **Other guides**: the 108 changed English passages, reviewed per language and applied as
  308 exact-text edits across 164 files, plus the frontmatter of weeks 11, 12, 24 and 37.
- **Two FAQ fixes in all four languages** found while checking the translations: week 40 no
  longer says "most women give birth in the week either side of" the due date (no source), and
  afterpains no longer gives a mechanism for stronger cramps after a second birth.
- **Arabic**: Western digits, wordmark "femio" in Latin, existing ICU plural forms kept. The
  `many` form was not added where the catalogue lacks it (ICU falls back to `other`, which reads
  correctly for these strings).

Flagged by the translators and left as they are: the fertility-tests FAQ answers "Yes" (so does
the English); Spanish week 39 mixes "fecha probable" and "fecha prevista"; French week 32 "Le
conseil de cette semaine" still counts from the first day of the period; French week 31 reads
stiffly; track-perimenopause says "femio shows a range" (a product claim to check against the
app).

## Changes that alter medical meaning (owner to read)

See commit `d83c7c1` (guides) and `114b2a2` (strings) for the full list. In short:

1. Week guides 4-40, Seek care now box: adds thoughts of harming yourself or the baby (with the
   help-now link); reduced movements = "straight away" in weeks 18, 23-40 (NHS, MR-29). Weeks
   30 and 33-38 also listed movements in a "same day" sentence above the box; movements were
   taken out of that sentence in all four languages so the page gives one instruction.
2. After birth: soaking a pad in an hour or an egg-size clot = emergency care
   (bleeding-after-birth, postpartum-recovery-first-six-weeks; CDC Hear Her).
3. newborn-warning-signs box adds temperature under 36C and a changed cry.
4. choosing-period-products: toxic shock signs = urgent help straight away.
5. contraception-after-birth: LAM criteria follow CDC wording; emergency contraception is
   time-sensitive. preconception-appointment: WHO folic acid timing added with its source.
6. irregular-cycles-and-timing: seek-help timing aligned to 12 months, or 6 from about 35.
7. Term: week 37 "term" (not "not early"); week 40 no longer says week 41 is not late.
8. Overstatements removed: lungs at 27 and 36 weeks, brain at 33 weeks, hCG doubling at
   week 9, "a blood test settles it", "points towards anxiety".
9. Newborn vaccines: hepatitis B is in the 8-week combined vaccine for every baby (UK).
10. Assistant tips matched to the sentence their source actually says (migraine, ICP itching,
    irregular periods with other signs, cervical screening interval, testing too early).
11. App and website: "Term from {date}" (the date is 37+0); "not a way to avoid pregnancy".

## Left as they are, for the owner's decision

- **The fertile-window sentence.** Guides use the authoring brief's approved sentence ("They are
  estimates, not a reliable way to avoid pregnancy."); `HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`
  asks for "Predictions are estimates, not guarantees, and are not a method of birth control."
  The content guard enforces the first. Pick one; a session then changes 14 guides × 4 and the
  guard.
- **pregnancy-basics** sends any bleeding beyond spotting, fluid leaking, fever and reduced
  movement to immediate care; **pregnancy-warning-signs** tiers several of these as same-day.
  The stricter page was kept. The week guides' boxes also keep fever, fluid leaking and sudden
  swelling under emergency care.
- **Week 28** calls sudden swelling an emergency; weeks 16 and 25 say same-day advice.
- **Extra food in pregnancy:** week 14 cites ACOG (a few hundred calories from the second
  trimester), week 24 the NHS (none until the third). Both are attributed; they differ.
- **Tier changes already applied in the English, to confirm:** week 39 follows the NHS by
  saying the nine signs need a call to the maternity unit straight away (it said "emergency");
  week 25 says any one of the signs needs urgent advice (it said "together an emergency");
  postpartum-recovery splits bleeding into emergency (a pad soaked in an hour, an egg-size clot)
  and same-day advice (a plum-size clot, sudden heavier bleeding).
- **Crisis copy (`helpNowImmediateLead`)** could lead with "If you are in immediate danger";
  not changed without clinical sign-off. **The Cloud boost consent text** was not touched (a
  change needs a consent-version bump). **BMI labels** ("Healthy range", "Obese") are WHO
  category names; left to the calculators branch.

## Claims still needing a source ([NEEDS SOURCE] list)

No published guide carries the marker (the content guard forbids it); these are the claims
that stay in the text unverified, or were hedged instead of sourced:

1. bleeding-after-birth: a clot "larger than a plum" as the urgent-advice threshold.
2. periods-after-birth: when to seek care if periods have not returned (now "a few months",
   "several months"; the earlier 3- and 6-month numbers had no listed source).
3. periods-after-birth and when-breastfeeding-is-not-working: six to twelve weeks for periods
   to return without breastfeeding.
4. pregnancy-week-25: 34.6cm at week 25 after 30cm at week 24 (NHS figure; looks like a jump).
5. pregnancy-week-32: "around 450g a week" (whose weight is not clear; check the NHS page).
6. pregnancy-week-34: side sleeping "helps blood flow to the placenta" (the reason given).
7. pregnancy-week-20: the whooping cough answer to "is it safe" says "recommended" only.
8. heavy-periods: "every hour" (ACOG) vs "every hour or two" on three teen and period pages.
9. Assistant catalogue: 13 visit questions exist only in the app strings, with no catalogue
   entry, source or review date (cycleSpread, ttcTests, ovulation, folicAcid, painfulPeriods,
   heavyPeriods, moodCycle, skinHair, tiredness, menopause, pregnancyNext,
   pregnancyMovements, anythingElse).

## Found but out of scope (follow-ups)

- Web namespaces nothing renders (`teen`, `postpartum`, `menopause`, `patterns`, `vitals`,
  `symptoms`, parts of `track`): still contain v2 copy (sign-in, sync, "Check your
  connection"). Delete them with the dead-module approach of R0.7.
- `docs/runbooks/OWNER_ACTIONS.md` "Decisions already made" still says "Arabic first".
