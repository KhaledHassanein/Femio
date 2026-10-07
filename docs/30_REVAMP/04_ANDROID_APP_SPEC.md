# 04 — The Android app: what v1 is, and how it starts

Written 2026-10-07 after the owner's direction (D7 + D8 in `OWNER_ACTIONS.md`): the website
becomes the content, tools and app-promotion site; the web beta closes; **the product is
the Android app**, private by design (health records on the phone), with iOS as a stated
later step. This replaces Phase 3's web-app plan. The engine thinking (personas as data,
uncertainty-honest predictions, rules outside screens) carries over unchanged.

## 1 · The owner's critique of the old wizard, and why it was right

The web wizard (`apps/web/src/components/onboarding/onboarding-wizard.tsx`) was built
around the persona resolver rather than around her:

- The first choice offered was **"I'm a teenager"**, and **"Skip — I'm not sure"** sat
  beside the goals, so the first screen looked like it was about edge cases.
- **Age came as eight bands including "Under 13"** on the same screen, optional, with no
  answer treated as a minor.
- **Step 2 asked which conditions "your clinician is watching"**: PCOS, endometriosis,
  adenomyosis, pre-eclampsia… before Femio had shown her anything. No mainstream tracker
  opens with a diagnosis list.
- **Her last period, the one thing every tracker needs, came after all that**, and the
  first screen after setup had no prediction and no tool to use.

## 2 · What competitors do (rechecked 2026-10-07)

Flo's help centre and independent reviews describe the same core in every mainstream app:
**goal → birth year → last period → cycle length → period length**, most questions
skippable, a pregnancy branch that asks the week (or computes it from the due date, last
period or conception date), and a prediction on the first screen. Flo's long version
(~70 screens, ~7 minutes per a published design critique; 442 steps in its onboarding
graph per our teardown, `docs/28_TEARDOWN/02_FLO.md` §3) wraps that core in teaching cards
and paywalls; reviewers cite the length as the main complaint, and the same complaint is
made of Stardust. Clue's setup is described as under two minutes. **The core is the
standard; the length is the mistake.** Femio takes the core, keeps it under a minute, and
puts its differentiators (honest ranges, Arabic-first, privacy) into how it answers.

Flo's website lists ten calculators: ovulation, period, menstrual cycle, pregnancy test,
implantation, hCG, pregnancy weeks-to-months, due date, IVF/FET due date, and due date by
ultrasound. These are the searches that bring women to a period app.

## 3 · Onboarding v1 (Android): five questions, under a minute

Nothing is preselected on any screen. Every question after the goal has "Not sure" or
"Skip", and a skipped answer is shown honestly later ("using a typical 28 days until you
log a period") rather than assumed silently.

| # | Screen | Answers | Notes |
|---|---|---|---|
| 0 | **Welcome** | Language (العربية · English · Français · Español), "Get started" | One line of promise: *Your records stay on this phone.* Wordmark always "femio" |
| 1 | **What brings you to femio?** | Track my period · Get pregnant · I'm pregnant · Perimenopause & menopause | One tap, then next. "I recently gave birth" lives inside *I'm pregnant* (step 3b). No teen, no "not sure" here: anyone can change goal in one tap later |
| 2 | **What year were you born?** | Year wheel | Under 18 → the tracker is 18+ at launch (D7); she is pointed to the articles and the website, which stay open to everyone (rule 2) |
| 3a | *Period / Get pregnant:* **When did your last period start?** | Calendar · "I don't remember" | |
| 3a | **How many days does your period usually last?** | Stepper (default shown, not chosen) · Not sure | |
| 3a | **How long is your cycle usually?** | Stepper · Not sure · **My cycles are irregular** | Irregular switches predictions to wider ranges and no "late" counter (rule 3) |
| 3a | *Get pregnant only:* **How long have you been trying?** | Just starting · Under 6 months · 6–12 months · Over a year | Drives the "talk to a clinician" nudge at 12 months (6 if 35+) |
| 3b | *I'm pregnant:* **How should we work out your due date?** | I know my due date · First day of last period · Conception date · IVF transfer date · I've had my baby | Shows the week straight away; "had my baby" → postpartum |
| 3c | *Menopause:* **When was your last period?** | Calendar · Over a year ago · Not sure | |
| 4 | **Reminders?** | "Remind me 2 days before my period" (or the fertile window, or a weekly pregnancy update) · Not now | Asked in context, local notifications only |
| 5 | **Your first prediction** | — | Her next period / fertile window / pregnancy week, as a range with a confidence word. This is the payoff: value on the first screen, not a blank dashboard |

**Conditions are not asked in onboarding.** PCOS, endometriosis, thyroid and the rest
are offered later, where they help: a card on Today after a few days ("Living with PCOS?
Femio can tailor what it shows you"), in Settings → My health, and on each condition hub.
Femio's PCOS depth (D1) is reached by choice, not by questionnaire.

## 4 · The tools, by goal (v1 must-haves first)

| Goal | On Today | In Tools |
|---|---|---|
| Track my period | Next period range, cycle day, phase band, log button | Period calendar, symptom & mood log, cycle history and length chart, period calculator, doctor-visit summary |
| Get pregnant | Fertile window + ovulation estimate (range), "best days" band | Ovulation calendar, LH/ovulation test log, BBT chart, cervical-mucus log, pregnancy-test timing, trying-time tracker |
| I'm pregnant | Week & day, baby's size this week, due date | Week-by-week, due date calculator, kick counter, contraction timer, appointment list, weight log, hospital-bag checklist |
| After birth | Weeks since birth, recovery tips | Bleeding & recovery log, feeding log (later), mood check (EPDS screener, "screening, discuss with your clinician") |
| Menopause | Months since last period, symptoms this week | Symptom tracker (hot flushes, sleep, mood), MRS screener, visit summary |

Every one runs on the phone. Every prediction is a range with a confidence statement;
nothing is presented as contraception.

## 5 · Architecture (v1)

- **Flutter**, Android first (ADR-060), iOS from the same code later.
- **Local store**: SQLite (encrypted at rest with a key in the Android Keystore), behind a
  `Store` interface so a sync implementation can be added later without touching screens.
- **Rules as data, shared with the web calculators**: cycle and pregnancy maths, persona
  rules and thresholds keep the tier-2 pattern, one specification and golden fixtures run
  by both the TypeScript (website calculators) and Dart (app) implementations.
- **Content**: the article snapshot ships with the app, refreshed on release (no CMS read).
- **No account, no analytics SDK, no ads SDK.** Crash reporting without user content.
- **Backup**: an export file she saves where she chooses; import on a new phone.

## 6 · The website's job (D8)

Articles, condition hubs, glossary, calculators (Flo's top set, with visual results), and
a single call to action: **get the Android app**, iOS coming. No sign-in, no tracker, no
health data on the web. The calculators are the bridge: each result ends with "track
this automatically in the app".
