# 33.01 — Femio v3: product scope, SWOT and medical rules register

**Owner of this page:** product owner and clinical lead (Sonnet 5.5). **Date:** 2026-10-27.
**Status:** default scope, taken under the owner's rule that every decision has a default. Khaled
moves anything at the next checkpoint. Nothing here is a lawyer's or an independent clinician's
opinion; Khaled approves the medical rules as owner and clinical reviewer
(`docs/runbooks/OWNER_ACTIONS.md`).

**Labels.** **Checked** = verified in the repo today, by me or by the 2026-10-27 study
(`docs/32_STUDY`). **Docs** = a repo document says so and I did not test it. **Hypothesis** = my
reading. **[NEEDS SOURCE]** = no citation I could follow. A *fixture* is a small JSON file of inputs
and expected answers that both the TypeScript and the Dart code must pass, so the website and the
app cannot drift apart.

**What I read:** `CLAUDE.md`, `00_PLAN.md`, `00_SYNTHESIS.md`, study reports 01, 04, 07, 08, 10, 11,
`30_REVAMP/02` §8, §10, §11 and `04_ANDROID_APP_SPEC.md`, personas C6, C1, D1, B6,
`31_RESET/02_SPEC_V1_DRAFT.md`, `compliance/PRIVATE_LAUNCH_V1.md`. **What I opened in code to
check a claim:** `apps/web/src/lib/calculators/index.ts`, the `calculators` block of `en.json`,
`apps/mobile/lib/domain/fertility.dart` and `movements.dart`, `today_screen.dart` (lines 195-212),
`onboarding_flow.dart` (lines 80-83), `app_en.arb`, the Android manifest.

---

## 1 · The wedge and the woman it serves

**The wedge.** Femio v1 is a private Android app, in Arabic and English, for women who are trying
to conceive or are pregnant, with honest depth for irregular cycles and PCOS (polycystic ovary
syndrome, a common hormone condition that makes cycles long and unpredictable). It is written by a
Cairo physician, gives ranges and never a single certain date, keeps her record on her own phone
(no account, no server), and sends her to a clinician with her facts in hand rather than trying to
be one. The first markets are Saudi Arabia and Egypt. The website is its front door: 100 cited
articles and seven calculators that end with "track this in the app". Every article and tool stays
reachable for every woman (rule 2); the wedge decides what is polished, reviewed and translated
first, not what is allowed. Decisions D1, D4, D7, D8 (Docs: `OWNER_ACTIONS.md`, ADR-070).

### Mariam, 30 — trying to conceive with PCOS (persona C6)
Cycles of 35 to 90 days, sometimes none. Diagnosed after years of "it's just stress". Ovulation
strips read positive most days. She stacks a period app, a strip reader and a notes file for her
clinic. **She needs:** to be told honestly "we cannot name a fertile window this cycle", a way to
log the signs that *confirm* ovulation afterwards (waking temperature, mucus), a seek-help message
that does not make her wait a 12-month clock, and one page to hand her doctor. **Femio must never:**
show her a glowing single day, a "late" counter, "infertile", or open with weight loss.
Source: `docs/personas/C6_ttc_pcos.md` §A, §B, §D (Docs).

### Nour, 29 — trying to conceive, then pregnant (personas C1 then D1)
Regular-ish cycles, cycle 1 to 6 of trying, hopeful, then anxious in the two-week wait. She wants
the days that matter, honestly, and a test day that is not too early. When the test is positive she
needs the same record to become a pregnancy: week and day from her dates, what to expect, which
symptoms need care *now*, a movement log from week 28 and a contraction timer late on. **Femio must
never:** call her "infertile" in month 2, tell her to "just relax", rank her baby's movements as
"normal", or tell her when to go to hospital by a number of contractions.
Source: `C1_ttc_general.md` §A, `D1_pregnancy_uncomplicated.md` §A (Docs).

### Layla, 27 — PCOS, not trying (persona B6)
Diagnosed at 23. Arabic-first. Tired of every app assuming she is trying or pregnant when a cycle
runs long. **She needs:** a cycle view with ranges and no "late", a symptom log (acne, hair, mood,
energy), fertile-window widgets off until she asks, a prompt to see her clinician when 90 days pass
without a period, and a summary for the endocrinologist (v1.1). **Femio must never:** funnel her
into a fertility or pregnancy story, or hide the rest of the library from her.
She becomes Mariam in one tap if she switches her goal to "get pregnant".
Source: `B6_pcos_not_ttc.md` §A (Docs).

---

## 2 · SWOT, 2026-10-27

Built on the October SWOT (`30_REVAMP/02` §8) and corrected by what the study found today. Blunt on
purpose. Where the October SWOT was too kind, I say so.

### Strengths
- **A practising physician is the voice.** MBBCh, Cairo, a credible Arabic clinician on ovulation,
  PCOS and pregnancy. The trust mechanism the best competitors pay for (Docs: `02` §8).
- **The safety reasoning is already in the code.** Movement log flags a change from *her own*
  pattern, the contraction timer gives no labour verdict, screeners return totals with a separate
  self-harm flag (Checked: study 01, 04). 12 shared fixtures, 68 cases; Dart passes 8 of the 12.
- **Private by construction.** The app has four dependencies, no analytics, no ads, no network code
  and no INTERNET permission in the main manifest (Checked: study 10 App. A rows 3-4). That gives
  the shortest honest Play Data safety answer and a small Egypt/Saudi legal exposure
  (Docs: `PRIVATE_LAUNCH_V1.md`).
- **100 cited articles**, 290 citations, all https, from NHS, ACOG, NICE, WHO, CDC and similar
  (Checked: study 07). 13 pass all three mechanical checks, 11 of them wedge topics.
- **Arabic and RTL are real in the interface:** four complete catalogues, natural MSA, Western
  digits, English wordmark (Checked: study 12).
- **Clean first build:** `flutter analyze` clean, 61 tests pass (Checked: study 04).

### Weaknesses
- **No users, no ratings, no retention data.** Every claim about demand is a reading of other
  companies' store pages (Docs).
- **"Arabic first" is true only of the interface.** Zero Arabic articles, zero Arabic FAQs or
  glossary entries; the translation run produced nothing that passed its safety gate (Checked:
  study 07). The October SWOT said "not yet at parity"; the honest word is *absent*.
- **The record is a plaintext JSON file** with no backup, no lock, no encryption, debug signing, and
  `allowBackup` not set, so Android may copy it to her Google Drive (Checked: study 04; the manifest
  has no `allowBackup`). Today the sentence "Stored on this phone only" is not guaranteed.
- **The legal and safety copy is wrong or missing.** Privacy and terms describe accounts, teens and
  cloud storage; the app has no crisis route, no wellness disclaimer and not the mandated sentence
  "not a method of birth control"; no Egypt or Saudi crisis number exists in the repo; three UI
  strings say every guide is clinician-reviewed, false for 75 of 100 (Checked: study 07, 10).
- **One reviewer who is also the author.** 25 articles name "Dr. Khaled M."; the threshold files
  name "Mohamed K."; nobody independent has reviewed anything (Checked: study 07, 10).
- **The wedge's depth is not built.** Four PCOS articles, none on lifestyle, insulin resistance,
  treatment options a clinician may discuss, hirsutism or acne; the app still draws the fertile
  window "14 days before the next period" for irregular and PCOS cycles (Checked: `fertility.dart`,
  `today_screen.dart`; study 04 Q5).
- **The maths disagrees with itself:** three fertile-window rules, two "irregular" thresholds, two
  due-date functions (Checked: study 01 §10; section 4 below).
- **One person, 1 to 3 hours a day, five weeks to a soft launch** (Docs: global instructions).

### Opportunities
- **Flo's Saudi store listing does not list Arabic** (Checked on the listing by the 2026-10-08
  benchmark). Nobody ran Flo in Arabic on a device, and Clue and Premom do list Arabic, so "no
  competitor has Arabic" is wrong; "no clinician-led, referenced Arabic product" is the claim we
  can defend (Docs: study 08 C-12). Hypothesis: the gap is real and short-lived.
- **Honest irregular-cycle and PCOS handling** answers the documented complaint that generic
  predictors give false-confident windows (Docs: `C6` §C, `02` §3). The Gulf PCOS prevalence of
  18.8% quoted in the docs comes from low-quality evidence [NEEDS SOURCE before public use].
- **The Arabic calculator search results are dominated by ad-funded apps** (Docs: benchmark P1-9).
  Seven fast calculators with an interactive calendar and Hijri output are a channel we control.
- **Verifiable privacy** while other trackers have had public data-sharing findings (Docs: `C6` §C
  names the 2021 FTC action against Flo) and Egypt and Saudi Arabia are starting to enforce.
- **Egypt's 1.9 million births a year** (Docs: CAPMAS via press, `02`) and the owner's own clinical
  network for the first 100 women.
- **Ramadan** is an annual, predictable moment for a clinician's voice on fasting in pregnancy
  and with PCOS; the date in 2027 is [NEEDS CHECK], expected February.

### Threats
- **Flo adds Arabic.** Hypothesis: possible without an app update if strings are server-side
  (Docs: `28` ledger). Our defence is depth and a clinician's voice, not translation.
- **Egypt's data-protection licensing is due to be enforced from 31 Oct 2026**, and whether it
  reaches an app that holds no records is unresolved; the owner has chosen to proceed without
  counsel and carries that risk (Docs: `OWNER_ACTIONS.md`, `PRIVATE_LAUNCH_V1.md` §2, §6).
- **Google Play's gate:** a new personal developer account needs 12 testers for 14 days before
  production; the Health apps declaration can be rejected; review time is [NEEDS CHECK].
- **A wrong red-flag line.** The pregnancy red-flag and movement copy in the app has no source in
  the docs and differs from the sourced list (Checked: study 10 H8; section 4 MR-29). One unsafe
  line in a pregnancy app outweighs every other risk on this page.
- **Losing a phone loses a record.** A private-by-design app without backup turns one broken phone
  into a one-star review and, worse, a lost pregnancy history.
- **Medical-device creep:** any hint of "predicts ovulation" or "tells you if you have PCOS"
  without the hedges below invites regulators; the mandated sentence is missing today.
- **Single point of failure:** the owner is controller, author, reviewer, tester-finder and
  publisher at once (Docs: `OWNER_ACTIONS.md`).

---

## 3 · Scope lock for v1 (soft launch, week of 30 Nov 2026)

**Dates (default, from `00_PLAN.md` §3):** release candidate 9 Nov; closed test 11-25 Nov
(12 testers, 14 days); soft launch the week of 30 Nov to 50-100 women in Egypt and Saudi Arabia.
It slips if the release candidate slips or the test starts late.

**The rule.** Nothing outside the tables below is built before the soft launch. A new idea becomes
one line in the v1.1 list. **Rule 2 stays:** all 100 articles, all 5 condition hubs and all 7
calculators remain reachable by everyone, in the app's Learn tab and on the website. "Only the
wedge is polished" means: wedge articles are reviewed, in Arabic and carry a reviewer name; other
articles are reachable, labelled honestly (D-07), and not promoted.

*Exists today* is from study 04 §9 ("missing versus spec") unless marked.

### 3.1 The app

| ID | Feature | Done when | Exists today |
|---|---|---|---|
| A-01 | Onboarding | Under a minute; goal, birth year, last period, lengths, an "irregular" option; ends on her first prediction; reminders step; all four goal paths tested | Partial: 11 steps built; reminders step missing; 18+ gate needs the D-01 fix |
| A-02 | Today, Calendar, Log | Ranges and a confidence word, never one date; fact and estimate drawn differently; any entry shows a dot | Yes (Calendar and Log kept as they are) |
| A-03 | Fertile-window rules | MR-06/07/08 in one domain function with a fixture; irregular or still-learning cycles show "no confident window" | No: still "14 days before the period" |
| A-04 | TTC toolkit | Ovulation calendar, strip (LH) log with the "a positive is a surge, not proof" line, waking temperature chart, mucus log, test timing, trying-time nudge from a domain function | Yes; the nudge logic sits inside `today_screen.dart` (move it) |
| A-05 | PCOS awareness | A "My health" switch (PCOS, irregular cycles) changes the window rule and the seek-help message; links to the PCOS articles; no questionnaire | No: the profile has no conditions field |
| A-06 | Pregnancy core | Due date four ways (known date, last period, conception, IVF transfer); week and day; trimester; red-flag card (MR-29); movement log from week 28; contraction timer from week 36; appointments; weight log | Yes, except week-by-week content |
| A-07 | Pregnancy ended | "I had my baby" and "My pregnancy has ended" both stop reminders at once, keep her data, and show a kind, plain screen with next steps; her own words for loss | No: "had my baby" lands on a near-empty screen |
| A-08 | Encrypted local record | AES-GCM file, key in the Android Keystore, one write at a time, a corrupt file is moved aside and never overwritten, schema version and migrations | No: plain JSON, silent overwrite |
| A-09 | Backup and restore | She saves one file wherever she chooses; import on a new phone; a nudge after the first week of entries, then monthly; restore tested | No |
| A-10 | App lock | Phone PIN or biometric through the system; off by default, offered once; locks on leaving the app | No |
| A-11 | Local reminders | Period range, fertile days (only when not "no confident window"), weekly pregnancy update, appointments; local notifications only | No (P3.8) |
| A-12 | Settings | Language, goal, due date, cycle and period length, My health, reminders, lock, backup, delete everything (with confirm), About (disclaimer, version, reviewers) | No: the UI promises "change any time" with no screen |
| A-13 | Learn tab | All articles from `packages/content`, EN plus the reviewed Arabic set, search, red-flag boxes styled as danger, reviewer line per D-07 | No |
| A-14 | "Need help now?" | Reachable from Today and Settings, never gated; global fallback text verbatim (MR-38); country numbers once verified (legal pack `03`) | No |
| A-15 | Disclaimers | Wellness sentence (MR-40) at onboarding and in About; mandated fertility sentence (MR-15) on every fertile-window or ovulation surface; endometriosis footer on that content (MR-42) | No: all absent |
| A-16 | Hijri alongside Gregorian | Secondary label in Arabic on calendar, due date and appointments (MR-45); stored Gregorian; Western digits | No |
| A-17 | Confirm before destroying | "Start over" and "Delete everything" ask once, say what is lost, and offer a backup first | No: wipes with no prompt |
| A-18 | Release hardening | Real release key outside git; `allowBackup=false` plus data-extraction rules (D-03); no INTERNET permission in release; App Bundle; no crash or analytics SDK (D-06) | No: debug signing, `allowBackup` unset |
| A-19 | Rules out of screens | Every rule in section 4 marked "F" lives in `lib/domain/` with named constants and a fixture; the three files over 300 lines are split | Partial: the Dart domain is good; rules still sit inline in screens |
| A-20 | Arabic pass | The owner reads every Arabic string once: 9 gendered forms, one diagnostic word, the "ماء الرأس" lay term (dropped until reviewed), wordmark in Latin | No |

### 3.2 The website (static teaser, no database)

| ID | Feature | Done when | Exists today |
|---|---|---|---|
| W-01 | Home, Learn hub, 100 articles, 5 hubs, search | Static export; wedge order TTC, pregnancy, weeks, the rest; every page ends with the app call to action | Yes (live), with the closed tracker still in the tree |
| W-02 | Seven calculators on an interactive calendar | Tap a day, the result draws on that calendar; ranges; section 5 rules; Hijri label in Arabic | No: native date input, display-only calendar (Checked: synthesis §5) |
| W-03 | Article template | Reviewer line per D-07, last-reviewed date, citations, "Seek care now" box styled as danger (the renderer does not do this today) | Partial |
| W-04 | Legal pages and help-now | Rewritten for the on-device product (legal pack `03`); 18+ wording; the mandated sentence; a crisis page with the same fallback text | No: drafts describe the cloud product |
| W-05 | `/app` | Play link or "coming soon", plain statement of what stays on the phone | Partial |
| W-06 | Arabic wedge set | Ten articles read by the owner in Arabic, chosen in D-09 | No: zero Arabic articles |

### 3.3 Content for launch (defaults)

- **English:** the 11 TTC, 4 pregnancy and 4 PCOS articles read and named by the owner. Six pass
  every mechanical check today; the rest need a reading-level pass (Checked: study 07 §9).
- **Arabic (D-09):** the ten most-asked wedge questions, each read by the owner. Fifty is not
  reachable in five weeks.
- **Not before launch:** the 37 week-by-week articles reviewed (nine first: weeks 4, 11, 12, 18, 24,
  25, 28, 35, 40), the new PCOS depth articles, the Ramadan hub.

### 3.4 v1.1 (after the soft launch; in this order)

1. Mood check with EPDS (Edinburgh Postnatal Depression Scale), validated Arabic version (D-04).
2. Doctor-visit summary: one page for the OB and the endocrinologist, shared by her from the phone.
3. PCOS depth: four new articles (lifestyle, insulin resistance, treatment options a clinician may
   discuss, hirsutism and acne) and ovulation-confirmation entries (mid-luteal progesterone result
   in the lab's own units, PdG monitor result), never labelled by Femio.
4. Ramadan hub (fasting in pregnancy and with PCOS; red-flag box; no rulings), ahead of Ramadan 2027.
5. Week-by-week pregnancy content, baby size, hospital-bag list, ultrasound dating that overrides
   other methods when a clinician gave it.
6. Postpartum recovery and bleeding log; breastfeeding basics.
7. Opt-in crash reports without content (D-06); encrypted cloud backup.
8. Blood-pressure log, using only the fixed reference text of `PREGNANCY_BP_SAFETY.md`.
9. Menopause tools (symptom log, MRS), partner view, FR and ES content, iOS, billing, teen mode.
   AI chat and community stay deferred by owner direction (OD-8, OD-9).

---

## 4 · Medical rules register

Everything the code and copy must carry. **Where it lives:** **F** = domain function with a shared
fixture (TS and Dart); **S** = keyed string in every locale; **U** = UI rule (screen test or
checklist); **L** = lint or build guard; **C** = content rule (article template or content lint).
**Today:** Yes / Partial / No / Conflict (two versions disagree), then Checked or Docs. Every
number is a prompt to talk to a clinician, never a diagnosis. Sources are as cited by the
`docs/compliance/*` files or by a comment in the engine; I did not re-verify external sources.

### 4.1 Cycles, prediction and the fertile window

| ID | Rule | Exact number or sentence | Source | Lives | Today |
|---|---|---|---|---|---|
| MR-01 | Every prediction is a range with a confidence word, never one certain date | Product rule 3. A stated cycle length gives low confidence and `learning` | Rule 3; `predict.ts` | F, U | Partial: Today and the period calculator yes; the ovulation calculator also prints one "likely ovulation" day (Checked) |
| MR-02 | No "late" counter, no "X days overdue", anywhere, in any mode | Forbidden as a counter: late, overdue, missed | Rule 3; B6 spec §E | U, L | Yes by design (`daysUntilPredicted` has no caller) |
| MR-03 | A stated cycle length is accepted from 21 to 35 days, window plus or minus 4 days | 21-35; 4 | `predict.ts` constants | F | Yes (Checked: study 01) |
| MR-04 | "Irregular" means the spread (longest minus shortest of all intervals) is more than 9 days. Window half-width is the larger of 2 and half the spread. Confidence is high with 6 or more intervals and spread 4 or less, medium with 3 or more and spread 9 or less | spread above 9; max(2, ceil(spread/2)); 6/4 and 3/9 | Engine comments. The clinical anchor (FIGO 2018 normal variation of 7-9 days) is Hypothesis [NEEDS SOURCE] | F | Yes in the tracker; Conflict with the calculator (MR-09) |
| MR-05 | Intervals over 90 days are left out of the average but still count toward the spread | 90 days | `predict.ts` | F | Yes |
| MR-06 | When cycles are irregular or still being learned, show **"no confident window this cycle"** with how to confirm ovulation afterwards, and no fertile day | EN default: "Your cycles vary too much to name a fertile window this cycle. Here is how to tell afterwards whether you ovulated." Arabic by the owner | C6 §E P0-1 (Docs); owner brief 2026-10-27 | F, S, U | No: the app draws 14 days before the period (Checked: `fertility.dart`) |
| MR-07 | When cycles are not irregular: ovulation is estimated 14 days before the next period; the fertile window is the 6 days ending on ovulation day | Ovulation day -14; window days -19 to -14 from the next period (6 days) | `FERTILITY_AWARENESS_SAFETY.md` ("the 6 days ending on ovulation day"); the 14-day luteal phase is the engine's choice | F | Conflict: three versions. `calculators/index.ts` and `fertility.dart` use -5 to +1 (7 days); `phases.ts` uses 16 to 10 days before the period |
| MR-08 | A cycle length outside 21-35 days gets the MR-06 sentence instead of a window | 21-35 (same as MR-03) | Default D-02 | F | No: the calculator clamps 20-45 and always shows a window |
| MR-09 | One threshold for "regular", everywhere: a spread of 9 days or less (the tracker's) | 9 | Default D-02 | F | Conflict: the calculator uses 7 (Checked: `index.ts:98`) |
| MR-10 | No period for 90 days: calm prompt, **pregnancy first**, then a clinician. Reference points kept in articles: over 3 months after regular cycles, over 6 months after irregular cycles (ASRM 2024); suspected energy-related amenorrhea: cycles over 45 days or no period for 3 months (Endocrine Society 2017) | 90 days (engine) | `MENSTRUAL_SAFETY_THRESHOLDS.md`; resolver `ABSENT_AFTER_DAYS` | F, S | Web only (dead with the tracker); app No |
| MR-11 | Dates are local calendar dates stored as `YYYY-MM-DD`; "today" is the device's local date, never UTC | Cairo and Riyadh are UTC+2/+3: after midnight local but before 02:00/03:00 UTC, "today" is wrong by a day | Study 01 §10.5; app fix `79a0e4f` | F | App fixed; web `todayISO()` still UTC (Hypothesis: not tested in the UI) |
| MR-12 | Phase estimates need a cycle of at least 21 days; default bleed length 5 days | 21; 5 | `phases.ts` | F | Yes |

### 4.2 Trying to conceive

| ID | Rule | Exact number or sentence | Source | Lives | Today |
|---|---|---|---|---|---|
| MR-13 | Seek-help clock: evaluation after **12 months** of trying if under 35, **6 months** if 35 or over; the 40-plus copy adds "you do not have to wait" | 12 / 6 months | `FERTILITY_AWARENESS_SAFETY.md` (ACOG, ASRM, NHS) | F, S | Partial: logic sits inside `today_screen.dart` lines 199-200 with no fixture (Checked); the web resolver has it |
| MR-14 | With PCOS, irregular or absent cycles, or any known cause: **no clock**; calm evaluation-prep from day one; never the word "infertile" | EN default: "Because your cycles are irregular, it is reasonable to talk to a clinician now rather than wait a year." | C6 §D (ASRM, ACOG); `FERTILITY_AWARENESS_SAFETY.md` ("at once if there is a known cause") | F, S | No |
| MR-15 | **Mandated fertility sentence**, on every surface that shows a fertile window, an ovulation day or window-based advice, in every locale, and in the terms and the store listing | "Predictions are estimates, not guarantees, and are not a method of birth control." | `ENDOMETRIOSIS_CONTENT_SAFETY.md` (required on fertility prediction surfaces) | S, U, L | No: absent from the app and web catalogues (Checked: study 10 H6). The ovulation calculator carries a different, shorter line |
| MR-16 | A positive ovulation strip is a surge, not proof of ovulation; with PCOS strips can read positive for much of the cycle; pair a strip with a second sign (temperature or mucus) | EN default: "A positive strip shows a hormone surge. It does not prove you ovulated." | 2023 International PCOS Guideline (C6 §D) | S, U | Hypothesis: not in the app copy (not verified) |
| MR-17 | Waking temperature confirms ovulation afterwards and never predicts; plausible readings 34-40 °C (93-104 °F); a chart needs 3 or more points | 34-40; 3 | `bbt.dart`; `FERTILITY_AWARENESS_SAFETY.md` | F | Yes |
| MR-18 | Progesterone and hormone-monitor results (v1.1): store with the lab's units and range; Femio never says whether ovulation happened; never "day 21"; no 3 or 10 ng/mL cut-offs | n/a | C6 §D, resolved source rule | F, C | n/a (v1.1) |
| MR-19 | Timing advice: intercourse every 1-2 days in the window gives the highest rates, 2-3 times a week nearly as good; no pressure, no "one missed day loses the cycle". The act is worded by the conservative register (OD-5) in every language | n/a | `FERTILITY_AWARENESS_SAFETY.md`; OD-5 | S, L | Partial |
| MR-20 | Banned emotional lines | "just relax", "stress is stopping you", "it will happen when you stop trying" | `FERTILITY_AWARENESS_SAFETY.md` | L | No lint |
| MR-21 | Pregnancy test: from the first day of a missed period; if the period date is unknown, at least 21 days after unprotected sex; never a "97-99% accurate" promise; testing earlier can give a false negative | 21 days | NHS, "Doing a pregnancy test" (code comment) | F, S | Yes (web calculator, Checked); the app's test timing exists |
| MR-22 | Folic acid: 400 micrograms daily from when trying until 12 weeks; higher doses only on a clinician's direction | 400 mcg; 12 weeks | WHO, via `FERTILITY_AWARENESS_SAFETY.md` and `CONTRACEPTION_SAFETY.md` | C, S | In 4 articles; not in the app (Hypothesis) |

### 4.3 Pregnancy

| ID | Rule | Exact number or sentence | Source | Lives | Today |
|---|---|---|---|---|---|
| MR-23 | Pregnancy length 280 days from the last period; from conception +266; from IVF transfer +266 minus 3 days (day-3 embryo) or 5 days (day-5). One function for the app and the website, with an optional cycle-length adjustment that defaults to 28 | 280; 266; 3/5 | `pregnancy/index.ts`; `edd-from.json` | F | Conflict: the website calculator adjusts for cycle length, the fixture function does not; the 280 constant is declared twice |
| MR-24 | Every due date carries the estimate note and the term window 37w0d to 42w0d | "These dates are estimates based on the due date you entered. Your clinician may adjust it after a scan." | `app_en.arb` `pregEstimateNote` (Checked) | S | App yes; the web calculator's note differs |
| MR-25 | Trimesters change at 14w0d and 28w0d; term starts at 37w0d | 98 / 196 days; 259 | ACOG (code comment) | F | Yes (two functions; unify) |
| MR-26 | A gestation outside the plausible range is refused with "check the date", not computed | 0-315 days (tracker), 0-320 (calculator); due date up to 280 days ahead and 35 past | `pregnancy/index.ts` | F | Conflict (315 vs 320); take 315 |
| MR-27 | Dating by ultrasound overrides other methods when a clinician gave it | n/a | Benchmark P0-3 | F | n/a (v1.1) |
| MR-28 | Weight log: no pass or fail, no target unless the IOM range is shown as guidance; plausible 25-300 kg (55-660 lb); a chart needs 2 points | 25-300 kg | D1 spec §E; `weight.dart` | F, U | Log yes; no bands |
| MR-29 | **Pregnancy red-flag card.** The sourced symptom list is: severe headache, vision changes, upper-abdominal pain, swelling of the face or hands, difficulty breathing (ACOG, CDC Hear Her). Bleeding and reduced movements are standard additions, **sourced 2026-10-30 (owner's go-ahead)**: NHS, "Vaginal bleeding in pregnancy" (https://www.nhs.uk/pregnancy/common-symptoms/vaginal-bleeding/) and NHS, "Your baby's movements" (https://www.nhs.uk/pregnancy/keeping-well/your-babys-movements/), both read 2026-10-30; **on the card on web and app since 2026-10-30 (R4.14)**, so the sentence names seven signs. Fallback line, verbatim | "Seek immediate medical care now. Contact your maternity unit or local emergency services. If you cannot reach them, go to the nearest emergency department." | `PREGNANCY_BP_SAFETY.md` | S, U | Yes (2026-10-28): the Today card and its own screen (`lib/features/help/red_flags_screen.dart`) say the website's sourced sentence verbatim (`pregRedFlagsBody` is copied from `calculators.rules.redFlag` by the vocabulary sync, which fails the gate on drift); the unsourced list is gone from the web catalogues. Bleeding and reduced movements still await a source |
| MR-30 | Movement log: "There is no normal number of movements." Only a change from her own pattern matters. Flag only after at least 3 finished sessions, when her latest minutes per movement are 1.5 times her median or more. A flag says "contact your maternity team now"; **no result ever says "normal" or "reassuring"**. Surfaced from week 28 | 3 sessions; 1.5x | `movements.dart` (`minSessionsForPattern`, `slowerRatio`). The 1.5x is a design heuristic "biased to prompt a call", **not a guideline figure** | F, S | Yes; the copy has no source in the docs (study 10 H8) |
| MR-31 | Contraction timer records times and gives **no labour verdict** and no "5-1-1" rule. Averages over the last 5. Surfaced from week 36 | EN: "You do not need to reach a certain number first. Call if you are worried, if your waters break, if there is bleeding, or if the baby is moving less than usual." | `contractions.dart`; `app_en.arb` (Checked) | F, S | Yes; the Arabic lay term for waters is dropped until reviewed |
| MR-32 | Blood-pressure reference text only, never applied to a reading (v1.1): 140/90 mmHg hypertension in pregnancy, 160/110 severe, 135/85 NICE treatment target; postpartum check by 7-10 days (72 hours if severe) | as written | NICE NG133, ACOG (in `PREGNANCY_BP_SAFETY.md`) | C | n/a (no BP feature) |
| MR-33 | Aspirin, cabergoline, letrozole, clomifene, metformin, inositol, progesterone: educational only, "what guidelines describe", clinician routing, **never a dose, never a start or stop date**. Single exception: folic acid 400 mcg (MR-22) | no mg or mcg anywhere else | `HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`; `REPRODUCTIVE_TREATMENT_SAFETY.md`; C6 §D | C, L | No lint |
| MR-34 | PCOS in pregnancy: capture PCOS status; mention an early glucose test (before pregnancy, at the first visit, at 24-28 weeks) as a question for her clinician | 24-28 weeks | 2023 PCOS guideline (C6 §D) | C, S | No |
| MR-35 | Loss and ending: use her own term; stop all reminders at once; no pregnancy-week card; keep her data | n/a | `REPRODUCTIVE_TREATMENT_SAFETY.md`; D1 spec | U, S | No (A-07) |

### 4.4 Mood, crisis, claims and display

| ID | Rule | Exact number or sentence | Source | Lives | Today |
|---|---|---|---|---|---|
| MR-36 | **No screener in v1.** EPDS in v1.1: the full unmodified 10 items in a validated Arabic version; name, source and date shown; show the score **without a label** and route to a clinician; any positive answer on item 10 (self-harm) triggers the urgent route whatever the total. Study 01 describes "items 1-2 reverse"; the published EPDS reverse-scores items 3 and 5-10 (Hypothesis: my reading; verify against the instrument before porting) | n/a | `MENTAL_HEALTH_SCREENERS.md` | F, S | TS has it; Dart none; scoring to verify |
| MR-37 | GAD-7 has no self-harm item, so it never alone triggers an emergency route; PHQ-9 item 9 is the self-harm item; no screener for under-18s | n/a | `MENTAL_HEALTH_SCREENERS.md` | F | n/a (v1.1+) |
| MR-38 | "Need help now?" is always reachable and never gated by a questionnaire. Emergency and support services are drawn apart; no US or UK number as global; no promise of cost, confidentiality, hours or language | Global fallback, verbatim: "If you may act on thoughts of harming yourself or someone else, or you are in immediate danger, contact the emergency services available where you are now or go to the nearest emergency department. You can also use Find A Helpline to find a crisis service for your country. If you can, stay with someone you trust while you get help." | `CRISIS_RESOURCES.md`; `crisis.json` (EN approved 2026-07-23, AR 2026-08-11) | S, U | Web yes; app **No** |
| MR-39 | A country's emergency and crisis numbers appear only after a session reads them on an official page (government, national health service or the operator's own site; never social media, never from memory) and records that page beside the number; sixteen countries since 2026-10-30 (R6.16) | n/a | `CRISIS_RESOURCES.md`; study 10 H9 | S | No (legal pack `03`) |
| MR-40 | **Wellness disclaimer** at onboarding, in About and under every health tool. Play's prescribed wording is [NEEDS CHECK] | Proposed EN: "Femio is for wellness, learning and tracking. It does not diagnose, treat or replace your doctor. In an emergency, contact your local emergency services." | Intended-use paragraph of `HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md` | S, U | No |
| MR-41 | Banned in copy, in every locale and in the ARB files: safe day, infertile day, "cannot get pregnant today", cure, reverse, detox, "safe for you", diagnose, treat, prevent, contraception, birth control. **Exact-string exceptions:** the MR-15 sentence, the MR-40 sentence, the MR-42 footer | list | `claims-lint.mjs`; `HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md` | L | Conflict: the lint scans English web only, and would reject the mandated sentence because it contains "birth control" |
| MR-42 | Endometriosis footer on all endometriosis content. No stage or Endometriosis Fertility Index probabilities | "Femio helps you track symptoms and prepare for a clinician conversation. It does not diagnose, stage, treat, or manage endometriosis." | `ENDOMETRIOSIS_CONTENT_SAFETY.md` | S, C | No |
| MR-43 | Red-flag box: any article with emergency symptoms opens a block "Seek care now:" styled as danger; every wedge article has one (the `pcos` pillar does not today) | exact opener | `content-lint`; study 07 | C, U | 77 of 100 have one; the renderer does not style it as danger |
| MR-44 | Reviewer claims: never write "reviewed by a clinician" in a string; a byline names the person or says what was done (D-07) | exact | Study 07 §8 | S, L | No: three strings claim it for all guides |
| MR-45 | Hijri: the stored value is always Gregorian ISO; Hijri is computed for display as a second label (Arabic locales), Western digits 0-9 in every locale, never an input-only format; add "may differ by a day from the local announcement". Which calendar variant: Q4 | n/a | P3.10 (Docs); rule 6 and P3.1 (Western digits) | F, U | No Hijri code |
| MR-46 | Content-only rules, kept in article lint and templates: contraception (no missed-pill decision tree; DMPA return can take up to about 1 year; combined hormonal methods are CDC category 4 for migraine with aura, stated as fact, never "safe" or "unsafe"; LAM needs all three criteria); heavy bleeding (no PBAC cut-offs; seek-care signs: over 7 days, a product every hour for several hours, clots about 2.5 cm or larger); no kcal or body-fat cut-offs in sport; bone wording "a clinician may consider bone-health assessment"; no AMH, FSH or follicle-count cut-offs; POI never declared from one result; OHSS urgent signs listed, never graded | as listed | `CONTRACEPTION_SAFETY.md`, `MENSTRUAL_SAFETY_THRESHOLDS.md`, `FERTILITY_AWARENESS_SAFETY.md`, `REPRODUCTIVE_TREATMENT_SAFETY.md` | C, L | Docs ready; no guard |
| MR-47 | Conservative register (OD-5): no sexual-wellness category or logging; clinical symptoms keep clinical names; no photos of people | n/a | OD-5, ADR-028 | U, C | Yes (Docs) |
| MR-48 | Under 18: the tracker is 18+; birth year alone is not enough (D-01); all guides stay open to everyone | 18 | D7; `PRIVATE_LAUNCH_V1.md` §3 | F, U | Yes (2026-10-28): `lib/domain/age_gate.dart` with `fixtures/domain/age-gate.json` (web twin `lib/age/gate.ts`); 19+ years passes, exactly 18 asks the D-01 question, under 18 sees the notice |
| MR-49 | Heavy bleeding with dizziness (Ask femio, Say it): show ACOG's sentence word for word with Help now; never claim dizziness alone is an emergency | ACOG: "If you are changing pads or tampons every hour for more than 2 hours in a row, and you also have chest pain, have shortness of breath, and are lightheaded or dizzy, seek emergency medical care right away." | ACOG FAQ "Abnormal Uterine Bleeding" (read 2026-11-24); NHS "Heavy periods" has no urgent wording | S, U | Yes (2026-11-24, ADR-079): `safety.dart` `heavyBleeding`, `safetyHeavyBleedingBody` ×4 |
| MR-50 | After birth: CDC Hear Her urgent maternal warning signs (heavy bleeding or large clots, fever, a headache that won't go away, vision changes, a swollen leg, severe belly pain, thoughts of harming yourself or the baby) open Help now for 365 days after the recorded birth | "get medical care immediately"; up to a year after delivery | CDC Hear Her, Urgent Maternal Warning Signs (2023-12-15) | S, U | Yes (2026-11-24, ADR-079): `safetySignalFor`, `postpartumWarningDays = 365` |
| MR-51 | The calendar shows the next three periods after her entries, each a range with a confidence word; only the next one when cycles are irregular or still being learned | Period k starts k average lengths after her last start; half-width ceil(margin x sqrt(k)); confidence one level lower per later period, never below low; low-confidence ranges drawn dashed ("possible") | Owner 2026-11-24 (R8.10). The sqrt(k) widening is the engine's choice from statistics (the spread of a sum of k cycle lengths), not a clinical source | F, U | Yes (`upcoming-periods.json`, 2026-11-24) |
| MR-52 | "Do I have X?" (Ask femio): when she asks whether she has a condition, a fixed sentence comes first: femio can't tell; a doctor can, after talking with her and, if needed, an examination or tests; then the sourced passages. Never a yes or no | Product rule 1 (never diagnose); no medical fact, so no source needed | Owner 2026-11-24 ("close all") | S | Yes (2026-11-25, R7.14): `diagnosis.dart` `asksForDiagnosis`, `askDiagnosisHeading`/`askDiagnosisBody` ×4 |

---

## 5 · The seven website calculators

Shared rules for all seven: the input is the interactive calendar (tap a day); results are ranges
drawn on the same calendar; no account, no email, no data sent anywhere; the result is never
gated; "today" is the device's local date (MR-11); Western digits; in Arabic, a Hijri secondary
label (MR-45); the existing disclaimer line stays; the **hand-off line** closes every result:
*"Track this automatically in the Femio app."* with the Play link (Android only, stated plainly).
A calculator never says *diagnose, treat, prevent, safe day, infertile, late, normal for you*.

| Calculator | May say | Must not say | Specific rules |
|---|---|---|---|
| Due date | A due date with the 37w0d to 42w0d window ("most babies arrive between ..."); the estimate note (MR-24); IVF transfer date as an input (the shared function already exists) | A single day as certain; "your baby will arrive on"; a cycle length outside 20-45 silently clamped | One function shared with the app (MR-23); the result adds "Your clinician may adjust it after a scan" |
| Ovulation | A fertile window as a range, **only when** MR-08 passes; otherwise the MR-06 sentence | "Safe days"; "you cannot get pregnant on"; one glowing "most likely day"; "not a reliable way to avoid pregnancy" (replace with MR-15) | The MR-15 sentence under the result, always; a strip-and-temperature line (MR-16); the sooner-help line when the cycle is outside 21-35 (MR-14) |
| Pregnancy week | Weeks and days, trimester, a trimester bar | Whether the pregnancy is "on track", "viable" or "normal"; any size or weight verdict | Refuse implausible dates with "check the date" (MR-26); the red-flag box under the result (MR-29) |
| BMI | A number and the WHO adult band name; "a general adult screen with limits" | Weight-loss advice; "healthy" as a verdict on a person; use in pregnancy; PCOS or diabetes statements | Note: not for use in pregnancy or for athletes; no data stored; band names follow WHO wording, not slang |
| Cycle length | Average, shortest, longest, and "your cycles vary by more than 9 days" when so (MR-09) | "Abnormal"; "irregular cycle disorder"; "you may have PCOS" | When varying or outside 21-35: "Cycles that vary a lot are common and have many causes. If this is usual for you, mention it to a clinician." Link the PCOS and irregular-cycle articles, never a screener |
| Period | The next three periods as ranges that widen with each cycle (already built) | One date; "late"; "overdue"; "expected on" without the range | If her start has passed: "If your period has not started and you could be pregnant, a test is the first step" (MR-10, MR-21) |
| Pregnancy test | The NHS rule: from the first day of a missed period, or 21 days after unprotected sex when the date is unknown (MR-21); a source line | "Positive" or "negative" interpretations; accuracy percentages; any earlier "you can test from" date | The wording of the sex-date input follows OD-5 in each language; the owner words the Arabic |

---

## 6 · Decisions taken by default

Each stands until the owner changes it. Format: decision, reason, what it costs.

| ID | Decision | Reason | Cost |
|---|---|---|---|
| D-01 | **Under 18:** the tracker is for 18 and over. A birth-year difference of 19 or more passes; at exactly 18 she answers one yes/no ("Has your 18th birthday passed?"); below 18 she sees the "tracker is for adults" screen and every guide stays open. No month of birth collected | The year-only check lets some 17-year-olds in (Checked); one extra tap in one case is cheaper than collecting a date of birth. Teen mode needs guardian flows and a legal answer we are not buying (`02` §11.2) | A 17-year-old who needs a tracker gets articles only |
| D-02 | **Irregular or PCOS fertile window:** show **"no confident window this cycle"** instead of a day when the spread is over 9 days, when fewer than 2 cycles are logged, when she marks cycles irregular or PCOS, or when the cycle is outside 21-35. Otherwise ovulation at 14 days before the next period and a 6-day window (MR-07). One function, one fixture, used by the app and all calculators | A confident wrong day sends Mariam to time intercourse on days she may not ovulate; it is the persona's loudest complaint and rule 3 (C6 §A, §C) | Her Today card is less satisfying; the confirmation tools and a clear next step make up for it |
| D-03 | **Google Drive auto-backup: blocked** (`allowBackup=false` plus data-extraction rules that exclude everything). The only copy is the file she saves herself | "Your records never leave this phone" must be true; Android backs up app files to Google by default (Hypothesis: confirm on a test device). Study 04 Q1 recommended the same | Lost phone, no file, lost record. Mitigation: the backup nudge and honest copy |
| D-04 | **Screener in v1: none.** EPDS comes in v1.1 with a validated Arabic version, its licence and attribution confirmed, and the item-10 route working | No validated Arabic instrument is confirmed; no attribution text exists in the code (Checked: study 10 M8); a screener adds a crisis-route duty (MR-36) that v1 meets with the help route alone | No postpartum mood check at launch; the articles and the help route stay |
| D-05 | **Analytics: none** in the app, and none on the website beyond the host's own aggregate page counts (no events, no identifiers) | Nothing to consent to, nothing to register; the Data safety answer stays "no data collected" (Docs: S6, `PRIVATE_LAUNCH_V1.md` §3) | We learn from testers and conversation, not dashboards |
| D-06 | **Crash reporting: none in v1;** opt-in, content-free reports later (v1.1) | An SDK means a network permission and a declared data type; the closed test and Play Console's own vitals cover the first 100 women (Hypothesis: confirm what vitals show without an SDK) | A crash we do not hear about |
| D-07 | **Reviewer bylines:** name only the person who actually reviewed. For articles the owner has read: "Reviewed by Dr Khaled Hassanein", with the date he signs. For the rest: "Editorially checked against cited sources. Clinician review pending." Fix the three false UI strings now. Never write "reviewed by a clinician" in general | 25 of 100 name a reviewer and today's strings claim all 100 (Checked). Trust, health-claims law and Play review all punish the false version | The library looks less finished; honest labels fix that over time |
| D-08 | **Wordmark in Arabic prose:** always the Latin **femio**, also inside Arabic sentences; never the transliteration | Rule 6 extended; settles the 86-versus-44 split in the catalogues (Checked: study 12) | A small script mix in Arabic lines; set it with a bidi isolate so it reads cleanly |
| D-09 | **Arabic for launch:** ten articles read by the owner: `fertile-window-explained`, `pcos-and-fertility`, `when-to-seek-fertility-help`, `when-to-take-pregnancy-test`, `preconception-appointment`, `early-pregnancy-changes`, `first-pregnancy-appointment`, `pregnancy-warning-signs`, the `pcos` pillar, `irregular-cycles-and-timing` | The first eight pass every mechanical check (Checked: study 07); the last two cover the wedge's depth. Fifty is not reachable in five weeks | Most of the library is English-only inside the Arabic app; the app says so |
| D-10 | **Strings the owner words in Arabic** before the release candidate: MR-06, MR-14, MR-15, MR-16, MR-29, MR-40, MR-42 and the sex-date label in the pregnancy-test calculator | The medical meaning must be his; a session drafts, he edits | An evening of his time |
| D-11 | **Seek-help clock** as MR-13/14: 12 and 6 months by age; no clock with PCOS, irregular cycles or a known cause | Matches the guideline sources in the compliance files and Mariam's need | Slightly more clinician referrals from irregular-cycle users, which is the point |
| D-12 | **App lock** is offered once after the first entry and stays off until she turns it on; it uses the phone's own PIN or biometric | A forced lock loses users who forget the code; offering it once serves privacy-sensitive women | Women who never turn it on get device security only |
| D-13 | **Postpartum in v1:** "I had my baby" is a state with a gentle screen, a short article list and a return to cycle tracking. No tools | The wedge ends at birth; the screen must not be empty (study 04 Q7) | Postpartum women get articles only until v1.1 |
| D-14 | **Pregnancy-ended path** (A-07) ships in v1 even though loss tools do not | A reminder that continues after a loss is the one failure we cannot afford | One small screen and a state change |

---

## 7 · Open questions for the owner (five)

1. **The fertile-window rule (clinical).** Confirm MR-07 and D-02: ovulation 14 days before the next
   period, a window of 6 days ending on ovulation day, "no confident window" if the spread is over
   9 days or the cycle is outside 21-35. Three versions exist today; I need one signed rule before
   the domain fixture is written. Default if you do not answer: MR-07 as written.
2. **Egypt and Saudi emergency and crisis numbers.** You know them better than any document; give
   me the source you trust for each, so the legal pack can print them. Default: the global
   fallback text only (MR-38).
3. **Arabic register and two terms.** Formal MSA throughout, or lighter Egyptian or Gulf on Today
   and onboarding? And the phrase for "waters break" on the contraction screen. Default: formal
   MSA, lay term dropped.
4. **Which Hijri calendar:** the Umm al-Qura calendar used in Saudi Arabia, or an astronomical
   calculation (Egypt announces religious dates by moon sighting)? Default: one civil calculation
   for both, labelled approximate. [NEEDS SOURCE for both calendars]
5. **Re-sign the threshold files under your name.** The compliance threshold files name "Mohamed K."
   as reviewer (July 2026); under your rule you are the clinical reviewer. Read section 4 once,
   then say "approved" so I can change the reviewer line and date in `docs/compliance/*`. Default:
   they stay as drafted and the app ships the register as written here.
