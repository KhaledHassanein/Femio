# Google Play listing — English (default listing)

Paste-ready for the initial release, version 1.0.0 (build 1). Limits: title 30, short description 80,
full description 4,000 (Play Console Help, [store listing](https://support.google.com/googleplay/android-developer/answer/9859152)).
Counts are Unicode code points, re-measured on 2026-11-25 and guarded by `pnpm store-lint`
(`scripts/store/listing-check.mjs`). Keyword placement: `aso-keywords.md`.
Facts checked against ADR-079/080, `apps/mobile/lib/data/play_store.dart` and the ARB strings.

## App title (28 / 30)

```
femio: Ovulation & Pregnancy
```

## Short description (71 / 80)

```
Period, ovulation & pregnancy tracker. Your records stay on your phone.
```

## Full description (3492 / 4,000)

```
femio is a private tracker for your period, ovulation, trying to conceive and pregnancy. See your next period and fertile window as an honest range, then follow your pregnancy week by week. Your records stay on your phone: no account, no ads, no analytics.

WHY FEMIO
• Private by design. No account, no sign-up, no ads and no analytics. Your log is stored encrypted on your phone, behind an app lock you choose. You decide when to save a backup file, and where.
• Honest predictions. femio shows your next period and fertile window as a range with a confidence level, never one "certain" date. If your cycles are irregular or you have PCOS, there is no "late" counter and no false precision.
• An assistant that respects your privacy. Ask femio answers your questions from trusted sources, with citations. Say it turns "bad cramps and so tired" into a log entry you confirm. For you suggests tips, and visit questions help you prepare for the doctor. It all runs on your phone where your phone supports Gemini Nano, and femio's own word list is used otherwise.
• Written by a physician, with sources. The library in the app explains ovulation, PCOS, early pregnancy and every week of pregnancy, and each article lists its sources.
• Everything stays open to you. femio adapts its home screen to where you are (period tracking, trying to conceive, pregnant or PCOS), and every article and tool stays one tap away.
• One record that grows with you. When you move from trying to pregnant, femio adds pregnancy to the same record. Nothing is deleted.
• English, Arabic, French and Spanish, with right-to-left layout and Hijri dates beside Gregorian.

TRYING TO CONCEIVE
• Period and ovulation tracking on a calendar
• Your fertile window as a range, updated from your own cycles
• Log symptoms, ovulation tests and cervical mucus
• Clear guidance on when to talk to a doctor

PCOS AND IRREGULAR CYCLES
• A mode built for long or unpredictable cycles
• Track what matters to your doctor: cycle length, skin, hair and weight
• Sourced articles on PCOS and fertility

PREGNANCY
• Due date, pregnancy week and trimester
• A week-by-week guide from week 4 to week 40
• Due date calculator, pregnancy calendar and weight-gain range that save nothing
• Baby-movement log and contraction timer that never give a verdict and point you to care when something needs checking
• Your appointments and the questions you want to ask, kept on your phone

PRIVATE BY DESIGN
• Optional reminders that only say "femio: Open the app"
• App lock and encrypted storage on your phone
• Backup and restore from a file you save yourself
• Delete everything in one step
• Cloud boost is off unless you turn it on. Only for phones without on-phone AI, and only if you agree, it sends a general question you approve (numbers, dates and names removed first) or four broad facts, to Google's AI. Never your log, notes or dates.
• Google Play handles the occasional rating request and app updates. femio sends nothing of yours for either.

IMPORTANT
femio is for education and tracking. It is not a medical device and does not diagnose, treat, cure or prevent any medical condition. Predictions are estimates, not guarantees, and are not a method of birth control. Always talk to your doctor or midwife about your health. If you have heavy bleeding, severe pain or fewer baby movements, seek medical care right away.

femio is made by KM Digital Labs, founded by a physician in Cairo. Questions or feedback: info@femioapp.com.
```

## Screenshot captions (top third, Dusk Bloom tokens, real screens with synthetic data, no photos of people)

| # | Screen | Caption |
|---|---|---|
| 1 | Lock screen / "Private by design" card | Your records stay on your phone |
| 2 | Calendar with the fertile range | Your fertile days as an honest range |
| 3 | Today in irregular mode | Irregular cycles or PCOS? No "late" counter |
| 4 | Pregnancy week card | Your pregnancy, week by week |
| 5 | Calendar with Hijri on | Your calendar, with Hijri dates beside each day |
| 6 | Learn: an article with its sources | Physician-written guides, with sources |
| 7 | Today: the pregnancy tools list (movement log, contraction timer) | Movement log and contraction timer, no verdicts |
| 8 | Settings: lock and backup | App lock, and a backup you keep |
| 9 (new, to shoot) | Ask femio answer with sources | Ask femio: answers with sources |

Play allows at most 8 phone screenshots: row 9 replaces row 8 (see `graphics-brief.md`).

## Feature graphic (1024×500)

Wordmark **femio** at the start, one line: "Your records stay on your phone." Text inside the central safe area.
