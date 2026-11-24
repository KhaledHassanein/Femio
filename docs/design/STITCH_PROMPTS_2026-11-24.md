# Stitch prompts, round 2: every screen, every persona (2026-11-24)

What this is: the prompts Khaled pastes into Google Stitch to get mockups for all femio screens per
persona. Round 1 (9 screens) and its comparison with the app: `testing-results/2026-11-24-stitch-compare/`
and https://claude.ai/artifact/2wbNyvPh6eVLDkUUoMpvRT. Sessions turn the results into Flutter;
medical text always comes from the app's sourced content, never from the mockups. Requirements
behind these prompts: PROGRESS R8.

How to use: attach `femio_dusk_bloom_design_system.md` (round 1 export), paste **Prompt 0** once,
then Prompts 1–5 one at a time in the same project. Ask for each screen in English light, Arabic
light and Arabic dark.

---

## Prompt 0 · Context (paste first)

```
Project: femio, a private women's-health Android app (Flutter), 390×844. Use the attached Dusk Bloom design system exactly: Newsreader for titles, Plus Jakarta Sans for English UI, IBM Plex Sans Arabic for Arabic, deep plum #6B2558, rose #BF2F59 for period, sage #2F7163 for fertile/calm, amber only for low-confidence notices, red only for urgent danger. Light ground #FBF7F3, dark ground #140D14.

Every screen in three versions: English light, Arabic light (RTL), Arabic dark (RTL). Western digits 0–9 in Arabic. Number ranges and units must read correctly in RTL: "12–16 مارس", "36.4 °C" (never "16–12" or "C° 36.4"). The wordmark is always lowercase Latin "femio", also inside Arabic.

Rules that every screen must follow:
- Wellness and tracking only. Never diagnose, never "normal/abnormal", no verdict colours (do not colour one cycle green as "good"), never imply birth control.
- Predictions are ranges with a confidence label (high / medium / low) or "No confident window". Never a single date, never an "X days late" counter.
- Her records stay on her phone: no account, no cloud sync, no social features, no ads.
- No cycle rings or donuts, no photos of people, no stock violet gradients, no emoji as icons. Material Symbols Outlined.
- No Ramadan or religious content. Hijri dates may appear beside Gregorian dates as dates only.
- Use realistic placeholder content but mark medical sentences as [content from femio library] — do not invent medical advice, red-flag lists, emergency numbers or citations.

Bottom navigation (4 tabs): Today · Calendar · Log · Learn. The femio AI (Ask femio and Say it to log) is a prominent floating pill above the nav on every main tab: "Ask femio" with a sparkle icon, plus a mic for Say it.

Today screen order for every mode, top to bottom:
1. Header: wordmark, a stage chip that opens "Change stage" (e.g. "Trying to conceive · PCOS", "Pregnant · week 24"), settings icon.
2. Main dashboard blocks for the mode (hero card, then 2–4 compact blocks).
3. Quick log row (Say it to log first, then 3 chips for the mode).
4. "Tips for you" (2–3 cards, each with a source line).
5. At the very bottom, two quiet notices: the privacy note ("Your records stay on this phone") and the Help now card ("Some symptoms need urgent care → Help now").
```

## Prompt 1 · Trying to conceive (with and without PCOS) and cycle tracking

```
Design these screens for the "Trying to conceive" mode, then repeat Today and Calendar for "Tracking my cycle" (no fertile emphasis, period-first) and for "Trying to conceive · PCOS / irregular cycles":

1. Today · TTC (regular cycles): hero "Fertile window likely 12–16 March · medium confidence" with a linear cycle bar; ovulation day marked INSIDE the fertile window (e.g. likely 15 March); blocks: "Next period likely 26–30 March", "Ovulation evidence so far" (cervical fluid, ovulation test, waking temperature), "Cycle day 14 of usually 28–31".
2. Today · TTC PCOS / irregular: hero "No confident window this cycle" with the reason and what to log; blocks: "Cycle lengths so far: 29–41 days", "Ovulation tests logged: 3", "Talk to a clinician sooner" card (no verdict).
3. Calendar · cycle modes: month grid with Hijri numbers under each day (toggle). Three looks: logged period = filled rose; predicted period = rose outline (likely) or dashed outline (possible, low confidence); fertile window = sage tint band; likely ovulation day = sage ring inside the band. Show the logged period this month AND the next two predicted periods computed from her entries (the following months show predicted ranges). Today circled. Legend below. Tap a day → day sheet.
4. Day sheet (bottom sheet from Calendar or Log): period flow, spotting, cervical fluid, ovulation test, waking temperature, symptoms chips, mood, intercourse (yes/no, one plain chip), notes. Placeholders written for TTC.
5. Patterns: cycle-length history as single-colour bars with the range; symptoms by phase "seen in X of Y cycles"; temperature chart for the current cycle; button "Make a doctor-visit pack".
```

## Prompt 2 · Pregnancy

```
Design the pregnancy mode. Nothing about periods, ovulation or fertile windows appears anywhere in this mode (no period legend, no ovulation fields, no cycle placeholders).

1. Today · pregnancy: hero "Week 24 · day 3" (week number large), "Due date around 10 March · a scan may change this", progress bar across 40 weeks with trimester ticks; blocks: "This week for you" (2 lines), "This week for baby" (size comparison by a plain object, no photo, 2 lines), "Next appointment · 18 March" with her own questions as a checklist, "Movements today: 10 · counted 9:40".
2. Calendar · pregnancy: month grid where the current pregnancy week is a highlighted row band labelled "Week 24", today circled; week numbers in the margin for every row; the pregnancy week turns over on the same weekday as her last period started (e.g. every Saturday) — show that weekday's column subtly marked; appointments as plum dots; due date as a ring with "around". Legend: Appointment, Logged something, Due date (estimate). Hijri numbers under days (toggle).
3. This week (detail page opened from the hero or the calendar week band): tabs "For you" · "For baby" · "What to expect" · "Questions for your visit"; each tab 3–5 short sections with a source line [content from femio library]; next/previous week arrows; "Week 24 of 40".
4. Pregnancy tools: movement counter, contraction timer (start/stop, intervals table, no verdicts), weight log with a chart and no "ideal" line, appointments list.
5. Day sheet · pregnancy: symptoms (nausea, back pain, swelling, heartburn, sleep), movements, weight, blood pressure if she has a home monitor (just values, no judgement), notes. Placeholders written for pregnancy.
```

## Prompt 3 · Postpartum and perimenopause

```
Design Today and Calendar for two more modes, same layout rules (femio's tracker is for women 18 and over, so there is no teen mode):
1. Postpartum: hero "Baby is 6 weeks · you are 6 weeks after birth"; blocks: feeding log summary (times, sides, bottle), sleep, mood check-in "How are you, really?" with gentle wording, bleeding (lochia) log, "Periods may return — log the first one when it comes". Calendar shows feeding/sleep dots and the 6-week check; no fertile window until her first period is logged.
2. Perimenopause: hero "Cycle lengths lately: 24–52 days"; blocks: hot flushes and sleep tracker, mood, "Bring this to your doctor" summary. Calendar with period ranges and a symptom heat strip (single colour scale, no verdicts).
```

## Prompt 4 · The femio AI: prominent, then consent, then on

```
Design the AI flow. The AI should feel like the main way to use femio, inviting and calm:
1. On Today: a large "Ask femio" card near the top of Tips for you ("Ask anything about your cycle, pregnancy or health — answers come from trusted sources, with citations") plus the floating Ask femio pill and mic.
2. First tap → "Meet femio's assistant" intro sheet: what it does (answers from a trusted library, turns your words into log entries, suggests questions for your doctor), what it never does (diagnose, decide treatment, contraception advice), and that on supported phones it runs entirely on the phone.
3. Consent screen (GDPR-grade, explicit, granular): title "Your choice about the assistant"; sections Who processes it, What is used, Where, How long, Your rights (withdraw any time, see your consent record), link "Read the privacy policy"; separate unticked checkboxes per purpose: "Answer my questions from the femio library on this phone", "Turn what I say or type into log entries on this phone", and an optional, clearly separated "Cloud boost (only on phones without on-phone AI): send a general question I approve, or four broad facts, to Google" with its own details. Buttons "I agree" (enabled only after a box is ticked) and "Not now", equal weight.
4. Consent receipt: "You agreed on 24 Nov 2026, 10:42 · version 1 · Questions on this phone, Log from words"; "Turn off" button.
5. Settings → Assistant: switches per purpose mirroring the consent, the receipt, "Download on-phone model" status, and "Delete my consent record".
6. Ask femio conversation: one question at a time, answer with numbered citations [1] [2] and a sources list with publisher and reviewed date; a diagnosis refusal card that offers "Prepare a doctor-visit pack"; urgent-symptom card that routes to Help now.
7. Say it to log: bottom sheet over Today; text box with mic; detected chips with detail and × ("Cramps · morning"), "+ Add entry", button "Save 2 entries to my phone".
```

## Prompt 5 · Everything else

```
Design the remaining screens, same rules, three versions each:
1. Onboarding: language (4 languages) → "Where are you right now?" stage choice with one-line promise per stage → stage details (last period date via a tap calendar, never a date field; or due date / baby's birth date) → "Has your 18th birthday passed?" check → privacy promise "Your records never leave this phone" → optional app lock (PIN/biometric) → Today. Step counter "Step 2 of 5", "On this phone only" badge.
2. Change stage sheet (from the header chip): all stages, current one ticked, "Your records stay; only what you see changes".
3. Learn: index with search, stage-relevant guides first, condition hubs (PCOS, endometriosis, thyroid in pregnancy…), article page with sources and reviewed date.
4. Doctor-visit pack: a one-page document look (wordmark, "Prepared 14 March 2026 · last 6 cycles", numbered sections from her logs, her questions), button "Share" (system share sheet, not a specific app), "Copy text".
5. Help now: urgent signs [content from femio library] and country cards with big call buttons [numbers from femio], location never used.
6. Settings: language, Hijri dates, app lock, backup (passphrase-sealed file she saves), restore, assistant (see Prompt 4), privacy policy, delete everything on this phone (with a confirm sheet).
7. Lock screen and backup/restore screens.
8. Empty states for Today, Calendar and Patterns in each mode (first day, nothing logged yet).
```
