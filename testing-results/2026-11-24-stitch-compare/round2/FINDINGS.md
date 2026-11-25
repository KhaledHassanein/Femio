# Stitch round 2: findings (2026-11-24)

What this is: the lead's review of the owner's second Stitch export (99 screens = 33 screens × EN
light, AR light, AR dark; `Downloads/stitch2_femio_women_s_health_app`). It decides what the app
adopts, fixes or rejects, mapped to PROGRESS R8. Contact sheets: `s_today.jpg`, `s_cal.jpg`,
`s_ai.jpg`, `s_ar.jpg`. Visible text of every screen: `texts.json`.

## Checks run (synthetic: mockups, not the app)

- Rule scan over all 99 screen texts:
  - no "late" counter, no "normal/abnormal", no Ramadan, no WhatsApp, no emoji;
  - "diagnose" appears only inside the refusal wording;
  - no period, ovulation or fertile words on any pregnancy screen.
- Text contrast (WCAG 2.1 AA: 4.5:1 normal, 3:1 large), `../contrast-audit.mjs`: **0 failures in 99 screens**. Every text colour was parsed, so this is not a parser miss.
- Not checked: non-text contrast (3:1 outlines, dashed "possible" circles), focus order, screen-reader labels. Those are checked in the Flutter build.

## Adopt (into the R8 lines named)

| What | Line |
|---|---|
| Today layout in all four modes: hero → 2–4 blocks → quick log (Say it first) → Tips for you → privacy note and Help now at the bottom; floating "Ask femio" pill with a mic above the nav | R8.2, R8.3 |
| TTC hero: 7-day strip, fertile days tinted, likely ovulation day ringed **inside** the window, a confidence chip | R8.9, R8.5 |
| Cycle calendar: logged = filled rose, likely = rose outline, possible = dashed; "Predicted periods" card listing the next ranges with their confidence | R8.10 |
| Pregnancy Today: "Week 24 · day 3", due date "around … · a scan may change this", 40-week bar with trimester ticks, For you / For baby blocks, next appointment with her questions as a checklist, movements today | R8.6 |
| Pregnancy calendar: week-number column, current week as a band labelled "Current week", turnover weekday marked, due date as a ring "around" | R8.6, R8.7 |
| This week page: tabs For you · For baby · What to expect · Questions for your visit, previous/next week, "Week 24 of 40" | R8.6 |
| Pregnancy tools: movement counter, contraction timer with an intervals table and no verdicts, weight log with no "ideal" line, appointments | R8.16 |
| AI: intro sheet (what it does / never does), granular consent with nothing ticked and Cloud boost set apart, chat with numbered sources, "femio can't diagnose" card with "Prepare a doctor-visit pack", Help now strip, Say it sheet with chips and "Save 2 entries to my phone" | R8.3, R8.27 |
| Postpartum Today ("Baby is 6 weeks · you are 6 weeks after birth", "How are you, really?", lochia log) and Perimenopause Today (cycle lengths lately as a range, hot flushes, "Bring this to your doctor") | R8.19, R8.20 |
| Patterns: cycle lengths as single-colour bars with the range, symptoms by phase "seen in 4 of 6 cycles", waking-temperature line | R8.5 |

## Fix when building

1. **One pregnancy week function.** The mockup's Today says "due around 10 March" while its calendar says "around 2 July" for the same week 24. Both must come from the domain function and a golden fixture (R8.7).
2. **Week rows must start on her turnover weekday.** The band runs Sunday–Saturday while the label says the week turns over on Saturdays. In pregnancy mode, start the grid on her turnover weekday so that one row is exactly one pregnancy week.
3. **Arabic Patterns:** the axis labels "Day 1 / Day 7 / Day 14" are left in English, and the range reads "31–28" (reversed). Isolate number ranges with the bidi rule we already use.
4. **Hijri dates in the mockups are invented.** 10 March 2026 falls in Ramadan 1447, not "20 Shawwal"; the app computes Hijri itself.
5. **Touch targets.** The chips are about 32 px high. Keep the look, but pad the hit area to 48 dp (Material); WCAG 2.2's minimum is 24 px.
6. **Disabled "I agree"** must still be readable (3:1), and enabled "Not now" and "I agree" keep equal weight (EDPB 05/2020).
7. **Cloud boost row** must name the four bands, not just say "four broad facts" (ADR-080).

## Reject or hold

- A baby feeding log (postpartum "6 feeds · 2 bottles"). R8.25 defers it. It stays deferred unless the owner moves it up, because the owner's own prompt asked for it. Raised in the combined plan.
- Any mockup medical sentence. All of it is `[content from femio library]`; the text comes from the reviewed guides only.
