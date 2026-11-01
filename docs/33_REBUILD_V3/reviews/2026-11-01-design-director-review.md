# Design director review: the femio Android app before the closed test

**Date:** 2026-11-01. **Reviewer:** design director (Opus 5.5), at the lead's request.
**Scope:** the Flutter app (`apps/mobile`), not the website. **Status:** advice. Nothing in the code
was changed. The owner decides what goes in.

**What I read.** `CLAUDE.md`; `docs/STATE.md`; `docs/32_STUDY/reports/09-plans-architecture.md` §7
(Dusk Bloom); `docs/28_TEARDOWN/11_FINDINGS_LEDGER.md` (OD-1 to OD-16, C-1 to C-14, the Flo
findings); `docs/33_REBUILD_V3/02_DESIGN_SPEC.md`; `docs/33_REBUILD_V3/01_PRODUCT_SCOPE.md`.

**What I looked at.** All sixteen store renders in `docs/store/screenshots/{en,ar}/01–08.png`. Older
renders in `testing-results/2026-10-28-app-settings-lock/`: the Arabic dark Today, the emulator Learn
list and the emulator welcome screen. The screen code in `apps/mobile/lib/features/` (home, today, calendar,
log, learn, onboarding, settings, lock, pregnancy) and the strings in `lib/l10n/app_en.arb` and
`app_ar.arb`.

**Labels used below.**
- **Checked**: I saw it in a render or read it in the code today.
- **Teardown**: from the August teardown, where Flo was run on a device.
- **Not verified**: a claim about a competitor that nobody on this project has checked on a device.
  The teardown ran Flo, GO Flo and Pregnancy Tracker only. Clue, Natural Cycles, Ovia, Premom and
  the Arabic-market apps were never run, so this review makes no device-level claim about them.

**Limits.** I saw no dark renders of the Calendar, Log or Learn screens and no app run at 200% text
size. Those are **not verified**. The store renders come from synthetic fixtures
(`store_screenshots_test.dart`), not from real use.

---

## 1 · Where femio already beats the field

Each line names the evidence. Where a competitor was not run, the claim is limited to what
femio does.

| # | femio advantage | Evidence | Competitor position |
|---|---|---|---|
| 1 | **Arabic that is real and RTL-native.** The layout mirrors (hero band, chevrons, switches, back arrow), weeks start on Saturday, digits are Western, and the Latin **femio** sits cleanly inside Arabic sentences. | Checked: AR renders 01–08. | Flo: `supportsRtl="false"`, and its Arabic is a 40-string stub (Teardown §3.9, C-2). Clue and Premom list Arabic on the store: not verified on a device. |
| 2 | **A Hijri date under every Gregorian day,** with the Hijri month span in the header, in any language. | Checked: EN/AR render 05, `calendar_screen.dart`. | No competitor in the teardown shows Hijri. Arabic-market apps: not verified. |
| 3 | **Private by construction.** No account, records stay on the phone, the backup file is hers, and the reminder text is discreet ("femio: Open the app"). | Checked: renders 01 and 08, `reminderBody`. | Flo's consent screen names AppsFlyer, Firebase and TikTok Ad Manager (Teardown C-3). |
| 4 | **It refuses to grade her cycle.** There is no "late" counter, and the irregular note reads "never counts days late". | Checked: render 03, `irregularNote`. | Flo shows ABNORMAL/IRREGULAR verdicts after one logged period (Teardown §3.7). The teardown calls this refusal "unopposed". |
| 5 | **A named reviewer and a date on every guide,** with sources listed. | Checked: render 06, `article_screen.dart`. | Flo cites sources but names no reviewing clinician (Teardown C-4). |
| 6 | **Pregnancy safety without verdicts.** The movement log puts "contact your maternity team now" first and has no kick target. The contraction timer has no 5-1-1 rule. The red-flag card (seven sourced signs) is always on pregnancy Today. | Checked: render 04/07, `movement_log_screen.dart`, MR-29/30/31. | Kick targets and labour rules are common in pregnancy trackers (Pregnancy Tracker was decompiled, not scored here). Others: not verified. |
| 7 | **Short, honest onboarding:** five or six questions, then her Today. No selling cards, no paywall. | Checked: `onboarding_flow.dart` `_path`. | Flo has 442 steps, 90 questions, 124 selling cards and a paywall (Teardown §4, OD-6). |
| 8 | **The disclaimer sits at the point of risk.** The prediction note sits under the fertile range. | Checked: AR dark Today render. | This matches Flo (Teardown §3.10): parity, not an edge. |
| 9 | **Help now in one tap** from every tab header, with sixteen countries and official sources. | Checked: `tab_header.dart`, STATE R6.16/R6.17. | Not verified for others. |

**Where femio does not yet win** (and the teardown says it must, OD-14):
- **Calendar detail (OD-15).** Flo's calendar is the floor, and femio is at it, not above it.
- **The dashboard repaint by stage (OD-10, OD-13).** Today changes its words by goal, not its whole
  screen.
- **The Learn structure (OD-12).**
- **Any data visualisation beyond the temperature chart.** The teardown calls a real chart layer
  "unopposed" ground.

The recommendations below are about closing these gaps.

---

## 2 · Before the closed test (only broken, confusing or trust-damaging)

Six items, all small. A closed test can start the day they land. Each one changes or replaces a
store screenshot, so re-render `docs/store/screenshots/` afterwards.

### B1 · Remove the pregnancy countdown and the "days past your due date" counter
- **Screen / file:** Today, pregnancy goal. `lib/features/today/pregnancy_hero.dart` (the
  `pregDaysToGo` / `pregOverdue` line); strings `pregDaysToGo` and `pregOverdue` in all four ARBs.
- **What she sees today:** "125 days to go", and after her due date "N days past your due date". The
  first is in the store screenshot 04 in both languages (Checked).
- **Change:** delete the line. Rewrite the term sentence as the spec states it: "Due around 10 Feb ·
  most babies arrive between 20 Jan and 24 Feb" (§2.7, §4). Re-render screenshot 04.
- **Why:**
  - MR-02 says no "X days overdue" anywhere, in any mode.
  - Rejected pattern 3 forbids a bar or count toward the due date (`02_DESIGN_SPEC.md` §1, §4:
    "The 'N days to go / overdue' counter goes").
  - Persona D1 is anxious; a counter past the due date is the "late" counter in pregnancy clothes.
- **Effort:** S. **When:** BEFORE.

### B2 · Put Help now on the lock screen
- **Screen / file:** Lock. `lib/features/lock/lock_screen.dart`.
- **What she sees today:** a PIN field and a "forgot your PIN" line. No route to help (Checked). A
  woman in crisis with the lock on cannot reach Help now without her PIN.
- **Change:** add a text button "Help now" under the PIN field. It opens `HelpNowScreen` without
  unlocking and without showing any record.
- **Why:**
  - MR-38: "always reachable and never gated".
  - The design spec, §4 "Help now… and **the lock screen** (it never sits behind app lock)", and the
    §7 checklist item "including the app lock screen".
- **Effort:** S. **When:** BEFORE.

### B3 · Give the irregular or PCOS woman who is trying to conceive a real Today (the wedge's first screen)
- **Screen / file:** Today, trying-to-conceive goal. `lib/features/today/period_hero.dart`: when
  `predictNextPeriod` returns null it returns early, before the trying-to-conceive branch.
- **What she sees today:** in onboarding, Mariam (persona C6) answers "irregular" or "not sure"
  about her cycle length. Her cycle length is then null, she has one logged start, and the
  prediction is null. Today then shows the eyebrow "YOUR NEXT PERIOD" over the headline "Log your
  next period": the same words twice, and nothing for trying to conceive. Missing:
  - the "No confident window this cycle" sentence (MR-06);
  - the "talk to a clinician now" line (MR-14);
  - the test-timing advice;
  - the temperature chart (the tool that confirms ovulation afterwards).

  This is store screenshot 03 (Checked), under the headline "Irregular cycles or PCOS?".
- **Change:** when the goal is trying to conceive, draw the trying-to-conceive branch even with no
  prediction:
  - the hero with `noConfidentWindowTitle` and `noConfidentWindowBody`;
  - `seeClinicianIrregular` when she marked her cycles irregular (MR-14);
  - `testTimingGeneral`. Let `TestTimingCard` take a nullable prediction.
  - the temperature-chart card.

  For the period goal, change the eyebrow so it does not repeat the headline. Every string already
  exists in all four languages.
- **Why:**
  - Product rule 3; D-02; MR-06; MR-14.
  - The scope (§1) says Mariam "needs: to be told honestly 'we cannot name a fertile window this
    cycle', a way to log the signs that confirm ovulation afterwards…".
  - This is the wedge persona's first screen, and today it says nothing to her.
- **Effort:** S–M. **When:** BEFORE.

### B4 · Make "You can change this any time" true, or remove it
- **Screen / file:** Onboarding goal step (`goalSub` in four ARBs). Settings
  (`lib/features/settings/settings_screen.dart`) has no row for goal, cycle length, period length or
  due date. `Profile.goal` is written only in `onboarding_flow.dart` (Checked).
- **What she sees today:** a promise that she can change her goal later. But the only way to move
  from trying to conceive to pregnant is **Delete everything**, which wipes her record.
- **Change (recommended, M):** add a Settings section "My details" with these rows: goal, cycle
  length plus "irregular / PCOS", period length and due date. The goal row reruns only that goal's
  questions from `onboarding_flow.dart` and saves over the same `Profile` with `copyWith`, so her logs
  stay.
- **Minimum (S), if M does not fit this week:** change `goalSub` to "You can start again from
  Settings" and list this as a known gap in the tester note.
- **Why:**
  - Product rule 5: one constant record, a stage change re-layers the experience and never deletes.
  - Scope A-12: Settings must include goal, due date, cycle and period length.
  - Design spec §4, "My details… editable at last".
  - A false promise in the second screen of the app damages trust. Testers will try to switch modes
    to see pregnancy.
- **Effort:** M (or S for the minimum). **When:** BEFORE.

### B5 · Add Undo to "My period started today"
- **Screen / file:** Today. `lib/features/today/today_screen.dart` (the `FilledButton.icon`
  that writes `DayLog(flow: 'medium')`).
- **What she sees today:** one tap writes a period for today and moves every prediction. The
  snackbar says "Logged. Your prediction is updated." and offers no undo (Checked). A mis-tap is
  easy: the button is the largest control on the screen.
- **Change:** add a `SnackBarAction` "Undo" that restores the previous `DayLog` for that day (or
  removes it), plus one new string in four ARBs. Spec §4 asks for more: open the day's flow chips
  instead of writing "medium" blindly. That can come after the test.
- **Why:**
  - Material 3 snackbar guidance: offer an undo action for an immediate, consequential change.
  - Android core app quality: no unrecoverable state from a single tap.
  - Report 04 #10, cited in `02_DESIGN_SPEC.md` §4.
- **Effort:** S. **When:** BEFORE.

### B6 · Fix two over-certain sentences on the trying-to-conceive screen
- **Screen / file:** Today (trying to conceive) and the test-timing card. Strings
  `predictionOvulation` ("Likely ovulation: {date}") and `testTimingBody` ("…a home pregnancy test
  is reliable from that day") in four ARBs.
- **What she sees today:** a lone ovulation date under the honest range (AR dark render: "الإباضة
  المرجّحة: 24 سبتمبر"), and a promise that a test is "reliable" from a named day (Checked).
- **Change:**
  - "Ovulation likely **around** {date}" (spec §2.5: "its words always say 'around'").
  - "…a home test is **most** reliable from that day; testing earlier can give a negative result even
    if you are pregnant."
  - The Arabic is the owner's wording (D-10).
- **Why:**
  - Product rule 3, MR-01 and MR-21 ("never an accuracy promise").
  - The store headline for screenshot 02 is "Your fertile days as an honest range, not one day". The
    hero must not contradict the store.
- **Effort:** S (strings only). **When:** BEFORE.

---

## 3 · After the closed test, ranked

The ranking weighs the wedge's daily use, the owner's binding directions, and what no competitor
has.

### A1 · Rebuild the Calendar to the shared vocabulary (beat Flo on OD-15)
- **Screen / file:** Calendar. `lib/features/calendar/calendar_screen.dart`. The spec's widget is
  `lib/widgets/calendar/` (§2.16, not built).
- **What she sees today:** every day is a separate circle (Checked, renders 02 and 05).
  - Today and likely ovulation are drawn as **rings**; the ovulation ring is the heaviest mark on the
    grid.
  - Predicted period days are saffron rings.
  - The first and last day of a period are not distinguished.
  - The week starts on Sunday in English (`MaterialLocalizations.firstDayOfWeekIndex`), and the
    Arabic weekday headers are single ambiguous letters (`narrowWeekdays`).
  - Tapping a future day does nothing.
  - **The TalkBack label is only the date:** "15 October 2026" with no "period", "fertile" or
    "estimate" (`Semantics(label: …)`).
- **Change:** follow `02_DESIGN_SPEC.md` §2.3–§2.5 and §2.16:
  - **Bands**, not circles: the period as a solid run with rounded ends, the fertile window with
    soft fading edges, the predicted period as a rose dotted band.
  - Ovulation as an 8 px still saffron dot. Today as bold digits plus a 16×3 bar.
  - `WEEK_START_BY_LANGUAGE` (Monday for en/fr/es, Saturday for ar) and `short` Arabic weekday names.
  - A future-day tap opens a sheet explaining the estimate on that day.
  - The day's marks inside the TalkBack label.
- **Ship order:** the TalkBack labels in the first patch (S), the rest as one item (L).
- **Why:**
  - OD-15, whose worked example in the ledger §7 lists exactly these beats over Flo.
  - Rejected pattern 1 (rings, "including 'today' rings").
  - WCAG 2.2 SC 1.3.1 and 1.4.1 (status must not be colour alone; the spec §7 checklist says "every
    mark has a word in its label").
  - Nobody in the teardown shows logged symptoms on the grid; femio's dot already does.
- **Effort:** L (the labels alone: S). **When:** AFTER (labels in the first patch).

### A2 · The first-prediction moment and the onboarding the spec describes
- **Screen / file:** `lib/features/onboarding/onboarding_flow.dart` and its steps.
- **What she sees today:** the last answer drops her straight onto Today.
  - The last-period step uses Material's `CalendarDatePicker` (`widgets.dart` `DateCard`), not
    femio's calendar.
  - Period length is its own screen.
  - There is no "I have PCOS" choice, no reminders step, and no wellness line (MR-40) at onboarding.
- **Change (spec §4):**
  - Fold period length into the last-period calendar (tap the start, then tap the end).
  - Add an "I have PCOS" chip beside "Irregular / not sure" that sets a My-health flag. It is a
    flag only, never a questionnaire.
  - Add a reminders step: all off, discreet text on.
  - End on the full-screen aurora **first estimate** (the range draws in, then breathes; reduced
    motion shows the final frame). For irregular cycles it shows the next-period range and the
    MR-06 sentence.
- **Why:**
  - OD-6: "joyful but simple", no overselling.
  - The design spec names this as one of the four motion moments.
  - It is the moment a woman decides the app understood her, and Flo puts a paywall there.
- **Effort:** M. **When:** AFTER.

### A3 · Today as a stage dashboard (OD-10, OD-13)
- **Screen / file:** `lib/features/today/today_screen.dart`, `period_hero.dart`, `hero_meters.dart`.
- **What she sees today:**
  - On trying to conceive, the two main actions sit below the hero, the note, the test-timing card
    and the temperature chart, so they are often below the fold.
  - The first-run privacy card sits *above* the hero as a second raised surface.
  - The hero band has no labels, so she cannot tell what the dot and the saffron segment mean.
  - The pregnancy bar shows trimesters but not the 37–42 week term window (§2.7).
- **Change:**
  - Put the actions directly under the hero.
  - Add a "This cycle" card (ovulation-test and temperature summary, MR-16 line) and one "For you"
    guide card chosen by goal.
  - Make the privacy notice a slim dismissible line under the header.
  - Put tiny "today" and "next period" captions under the band.
  - Draw the term window on the pregnancy bar.
- **Why:**
  - OD-10: "fewer items than Flo, far more than Femio has today".
  - OD-13, the owner's thesis that the screen should change with her stage.
  - Design principle 6: one raised element per screen.
- **Effort:** M. **When:** AFTER.

### A4 · The Log screen ordered for her goal, with the ovulation-strip truth
- **Screen / file:** Log. `lib/features/log/log_screen.dart`.
- **What she sees today:** the sections run Period, Mood, Symptoms (about 45 chips), Discharge,
  Ovulation test, Temperature, More. Mariam scrolls past every mood and symptom chip each morning to
  reach her strip and her temperature. There is no save feedback, and no MR-16 line anywhere in the
  app (`grep surge` finds nothing in `app_en.arb`; Checked).
- **Change:**
  - Order the sections by goal, as spec §4 states. For trying to conceive: flow, ovulation test,
    temperature, discharge, intercourse, mood, symptoms.
  - Under the ovulation test, add MR-16: "A positive strip shows a hormone surge. It does not prove
    you ovulated."
  - Add a small spring check on each save.
  - Let a tap on the date open the calendar in a sheet (report 04 #14).
- **Why:**
  - Persona C6 in scope §1; MR-16 (2023 International PCOS Guideline, as cited in C6 §D).
  - Material 3 guidance: confirm an immediate save.
- **Effort:** S–M. **When:** AFTER. MR-16 is a register rule, so ship it in the first patch.

### A5 · Learn shaped like the best content tab (OD-12), on femio's terms
- **Screen / file:** `lib/features/learn/learn_screen.dart`, `article_screen.dart`.
- **What she sees today:**
  - A flat list of about 110 cards behind one search field, wedge first (Checked:
    `library.dart` sort; emulator render).
  - The article shows the review date as ISO ("2026-08-04").
  - Sources show raw URLs. In Arabic they break under bidi ("…https://www.nhs.uk/…f").
  - Copying a link needs a long press that nothing announces.
  - The app bar says "Learn" instead of the guide's context, and uses the stock Material style.
- **Change:**
  - "For you" (three guides by goal and stage), "Start here", topic rows with the 12 covers from
    spec §6, a pregnancy-weeks row, and question-shaped chips.
  - Format the review date for her locale.
  - Show sources as title plus domain, with a visible "Copy link" button, the URL isolated LTR.
- **Why:**
  - OD-12, which follows Flo's Insights *structure* with femio's citations, named reviewer and four
    languages.
  - Material 3 (no hidden gestures).
  - WCAG 2.2 SC 2.5.1.
- **Effort:** M–L. **When:** AFTER.

### Also after, in rough order
| # | Item | File | Why | Effort |
|---|---|---|---|---|
| 6 | **"I had my baby" and "My pregnancy ended"** paths: they stop reminders, keep her data, and show a kind screen. **These are v1 scope (A-07, D-13, D-14), so build them before the soft launch on 30 Nov, not just "after".** | `pregnancy_hero.dart`, new screen | MR-35; D-14: "a reminder that continues after a loss is the one failure we cannot afford" | M |
| 7 | **Tools tab** (five destinations, spec §4): "For you now", the seven calculators in-app on the femio calendar, "Other stages" open. Today the pregnancy tools are reachable only from pregnancy Today, and there are no in-app calculators. | `home/home_shell.dart` | Rule 2; OD-8 ("calculators… no competitor has any") | M |
| 8 | One app-bar style everywhere: Settings shows the stock M3 tinted bar, while the Calendar header has no gear. | `settings_screen.dart`, `article_screen.dart`, `tab_header.dart` | Consistency (Material 3 top app bar, Dusk Bloom headers) | S |
| 9 | Pregnancy tool rows cut their descriptions mid-word ("a chan…", "the nu…", store render 07). Write one-line subtitles. | `pregnancy_tools.dart`, ARBs | Polish; it shows in the store render | S |
| 10 | Light haptic on each movement tap, so she can count without looking. | `movement_log_screen.dart` | Android haptics guidance | S |
| 11 | Before production ads, block the sensitive ad categories in AdMob (dating, gambling and so on) for a pregnancy and fertility audience. This is an owner action in the AdMob console, not code. | owner | ADR-076 trust line | S |
| 12 | Settings: an Appearance switch (system / light / dark), and "My health" (PCOS, irregular). | `settings_screen.dart` | Spec §4 Settings; A-05 | S–M |

---

## 4 · What I did not recommend, and why
- **No ovulation "peak day" star, no cycle-score ring, no "late by N days".** These are product rules
  3 and 4 and the rejected patterns. They are things competitors do that femio refuses on purpose.
- **No cloud sync and no partner sharing in v1.** Product rule 4. Sharing only ever starts as a file
  she exports herself (the v1.1 doctor-visit summary).
- **No chat or assistant.** OD-8 and OD-9.
