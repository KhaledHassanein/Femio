# Manual test plan — what only a human can check

**Companion to `OWNER_MANUAL_TASKS.md`, and deliberately separate from it.** That file is
credentials, keys and one-off configuration — things only the owner *can* do. This file is
things only a human can *judge*: whether a screen looks right, whether Arabic reads naturally,
whether a flow feels like a product.

**Why it exists.** Every automated gate in this repo passes on every commit — 11 guards, 436
unit tests, 63 end-to-end. None of them can tell you the homepage looks generic, that a
translation is grammatically correct but tonally wrong, or that a control is out of thumb reach.
`docs/22` §10 states the rule this file operationalises: *a screenshot is the test, not a
nice-to-have.*

**How to use it.** Work the **▶ After the latest changes** section first — it is short and
tracks what actually shipped. The regression sweep below is for before a beta or a release, not
for every session.

**Unseen as of 2026-08-16: T8, T10, T11, T12, T13, T14.** Six screens shipped that day and
nobody has looked at any of them. **T11 and T12 want you as a clinician rather than as an owner** —
charting must not read as contraception, and the MRS must not read as a grade. Those two are
the ones I would not ship to an outside tester unread.

**Standing conditions for every check:** a real phone if possible, otherwise a browser at
**390×844**. Each screen in **light and dark**, and in **English and Arabic**. Arabic is a
first-class market, not a locale toggle.

---

## ▶ After the latest changes (2026-08-16)

### T1 · The new homepage (R1.3)
`femioapp.com/en`, then `/ar`.

- [ ] The hero reads as a product, not a brochure. You can tell what Femio *is* within two seconds.
- [ ] The **life-stage rail** — six stages with a coloured spine — is legible at 390px and the dots line up with the text.
- [ ] The **product screenshot** under it looks like the real app, not a placeholder.
- [ ] The three "honest by design" cards: the prediction band has **soft, fading edges** (not hard ones), and the 30-day strip reads as a pattern.
- [ ] **Arabic:** the headline is in IBM Plex Sans Arabic, *not* a serif. If it looks like Georgia, the font pairing regressed.
- [ ] **Arabic:** nothing is mirrored wrongly — the chevrons on the library rows point left, the rail spine is on the right.
- [ ] Dark mode: the hero gradient still has white text you can read comfortably.

**Known gap I could not check:** I verified the copy with `curl`; I have never seen this page
composited. Everything above is genuinely your call.

### T2 · Arabic crisis copy (P1.26.2, ADR-063) — safety-critical
`/ar`, tap **تحتاجين مساعدة الآن؟**

- [ ] The dialog is **entirely in Arabic**. If any English appears, the fallback did not clear.
- [ ] `immediateLead` — the routing sentence — says plainly: contact emergency services where you are, or go to the nearest emergency department.
- [ ] **No phone number anywhere.** The global-only posture is deliberate (P1.26.1).
- [ ] No promise about cost, confidentiality, hours, language or dispatch. If the Arabic implies any of those, it is wrong and must be corrected.
- [ ] Repeat for `/fr` and `/es`.

The English fallback that used to render in these locales is **gone**. You are the recorded
reviewer; a correction is an edit to `apps/web/src/lib/crisis/crisis.json` plus a new
`reviewDate`, not a blocked release.

### T3 · Set and re-answer your persona (P1.27.3, R2.6) — the new feature
Settings → **Your Femio experience**.

- [ ] Pick a stage, press apply. The badge on the dashboard changes.
- [ ] **"Re-answer the questions"** opens, and is **pre-filled** with what you selected at signup. An empty list means the pre-fill broke.
- [ ] The note says plainly that this replaces your condition answers **and nothing else**.
- [ ] Deselect everything, save. Then re-open — it should be empty, i.e. the correction stuck.

### T4 · The experience engine on screen (R2.3) — the proof it works
Settings → stage = **Pregnancy**, then set a due date on the dashboard.

- [ ] Re-answer → tick **Thyroid condition** → save. The dashboard should now show a **Thyroid** panel under the week card.
- [ ] Re-answer → untick thyroid, tick **Gestational diabetes (found in this pregnancy)** → save. The thyroid panel is replaced by a **Glucose** panel.
- [ ] Tick **Diabetes (before this pregnancy)** instead → you should still get glucose, but this is D4 rather than D3. *(The visible difference between D3 and D4 arrives with R3 — for now the check is that neither crashes and the strip appears.)*
- [ ] Both strips show an **empty state** with no invented numbers. Correct — the labs and glucose surfaces are Phase 2.
- [ ] The **warning-signs panel stays high** on the screen in every combination, never pushed to the bottom.

If the strip never appears: the persona did not resolve. Tell me and I will look — that is a bug,
not a config problem.

### T5 · Pregnancy essentials still work
- [ ] Set a due date → weeks + days match what your notes would say.
- [ ] The term band draws **37–42 weeks** with today inside it. It must **not** fill toward the due date.
- [ ] Movement log saves (migration `0007` is applied). There is **no target and no pass mark** — that is deliberate (ADR-049).
- [ ] Logging an **emergency-tier** symptom interrupts with guidance to contact care, and still saves the entry.

### T6 · Postpartum mode (R2.5) — newly reachable
Settings → **Your Femio experience** → **After birth**.

- [ ] The dashboard badge says "After birth" and there is **no next-period estimate anywhere**. That absence is the point — if you see a predicted window, that is the bug this shipped to fix.
- [ ] The note under the screen explains *why* there is no prediction, rather than leaving the gap to be interpreted.
- [ ] The hero asks how you are doing and **does not congratulate you**. The mode alone does not tell Femio whether a baby came home.
- [ ] The postpartum red-flag panel is present and high on the screen, and carries **no phone number**.
- [ ] Re-answer the questions in this mode: the conditions offered are the postpartum set (gestational diabetes, hypertension, pre-eclampsia, anaemia, mood, previous loss), not the pregnancy one.
- [ ] Repeat the whole check in Arabic. This copy is new and unreviewed.

**The grief path, if you can face testing it:** tick **A previous loss** and save. The tone
should change — gentler heading, nothing celebratory, no check-in cadence. If anything on that
screen reads as upbeat, tell me; that is the failure mode E6 exists to prevent.


### T7 · Age and the minor tier (R2.5b)
`/welcome` on a fresh browser profile.

- [ ] Step 1 now asks **roughly how old are you**, as bands. It is skippable, and it never asks for a date of birth.
- [ ] Pick **13–15**. A note appears saying nothing goes to analytics or research partners, **and that nothing in the app is hidden from you**. Both halves matter.
- [ ] Finish onboarding, then Settings → Your privacy choices: turning **analytics** on should refuse. Turning it *off* must always work — the gate protects her, it does not trap a permission she wants removed.
- [ ] Pick **25–34** instead on a second account: analytics is offerable as before.
- [ ] Check the Arabic and French copy for the age note. It is new.

**Why this matters more than it looks:** before this, nothing in Femio asked for age, so
`profiles.age_band` was never written and the resolver rules for A2, F1 and F2 — all of which
require an age band — could never fire at all.

### T8 · Teen mode (R2.5c) — the last track to become reachable
`/welcome` on a fresh browser profile, or Settings → **Your Femio experience** → **Teen**.

- [ ] **"I'm a teenager" is the first option** on the life-stage step, and it does not read as a children's product. A2's specs are blunt about this: pink-flowers-only infantilising UI is on her list of things that break trust, and so is being talked down to.
- [ ] Pick it with age band **13–15** and log two periods. The hero is a **window**, and the line under it says *why* it is a range rather than a date. That sentence is the whole feature — a teen whose prediction misses concludes the app is broken or she is.
- [ ] The "worth saying out loud" panel is **info-coloured, not red**. If it renders as a danger alert, that is the failure this design exists to prevent: adolescent irregularity is developmentally normal and must never be presented as a finding.
- [ ] **The word PCOS appears nowhere**, including in the conditions step. It is deliberately not offered to a teen.
- [ ] Nothing is locked. The reading card should say plainly that the whole library is open to her, and the link should work.
- [ ] Now try it with **no periods logged**: you should get the gentler A1 screen with **no window at all**, not a window saying "we need more data". She is not cycling; there is nothing to estimate.
- [ ] Repeat in Arabic. This copy is new and unreviewed, and A2 §B notes that menstruation carries more stigma pressure in Arabic-first markets — tone matters more here than anywhere else in the app.

### T10 · Appointments (P2.2.3) — a table that has been empty since v1
Settings → **Appointments**, or the card on the pregnancy dashboard.

- [ ] Add one with only a name and no date. It should save, and appear **first** under "Coming up" — it is the one still needing a date, not the one to bury.
- [ ] Add one with a date, a clinician and two questions on separate lines. The questions render as a list. That list is the feature; the date is the easy part.
- [ ] Set "told to expect results by" to a date in the past. An **info** notice appears asking whether it is worth chasing. If it reads as urgent or clinical, tell me — a result runs late for a dozen ordinary reasons and Femio must not invent significance out of a calendar.
- [ ] Confirm there is **nowhere to type what the result was**. That absence is deliberate and permanent.
- [ ] Switch to cycle or menopause mode: Settings still reaches Appointments. It is not a pregnancy feature.
- [ ] Arabic: the date and time format, and whether the list reads naturally right-to-left.

### T11 · Charting (P2.1) — safety-critical wording
Settings → **Charting**, or the button on the TTC dashboard.

- [ ] The notice at the top says plainly that charting is **not a reliable way to avoid pregnancy**. Read it as a clinician: if it could be misread as contraception, tell me — that sentence is the whole medical-device boundary for this screen.
- [ ] Log three waking temperatures on different days. A chart appears. Confirm it is **only dots and an axis** — no line joining them, no marker for a shift, no shaded "fertile" band, no colour that means anything.
- [ ] Type `365` in the temperature field. It should refuse as a typo. Type `34.0` — it should accept, because the guard is for typos and must never become a comment on her temperature.
- [ ] Log an ovulation test result. The wording should make clear you are recording **what the test said**, not asking Femio to read it.
- [ ] Arabic: the OPK and mucus vocabulary. These are terms with real regional variation and I chose them from the literature, not from usage.

### T12 · The Menopause Rating Scale (P2.4) — safety-critical, and yours as a clinician
Settings → Your Femio experience → **Menopause**, then scroll to the questionnaire.

- [ ] Read the eleven items against the published MRS. I transcribed them into plain English and then into three other languages; the wording is mine and the instrument is not.
- [ ] Answer a few and check the result block: a **total, three subscores, and the number of items answered**. Confirm there is **no band, no severity word, and no colour that grades it**. That absence is the whole compliance position for this screen.
- [ ] Answer all eleven at "very severe" — total 44. Nothing on screen should change tone. If anything reads as alarming or reassuring, tell me: Femio must not have an opinion about this number.
- [ ] Leave some blank. It should say the total is not comparable to a full one.
- [ ] Save it, then check the visit summary and the data export pick it up.
- [ ] Arabic: this is clinical vocabulary in four languages and it is the highest-risk translation in the app after the crisis copy.

### T13 · The bigger symptom list (P2.4)
Track → the symptom chips, in any mode.

- [ ] The list is now 45 items rather than 26, and **every one of them is offered in every mode** — check from cycle mode that night sweats and vaginal dryness are there. The menopause set decides what is emphasised, never what exists.
- [ ] Read the nineteen new labels in Arabic, French and Spanish. Several are awkward to say in any language (burning mouth, electric-shock sensations, body-odour change) and the test is whether they read as something a person would tick rather than as a translation.
- [ ] Nothing in the list is a **diagnosis** — no osteoporosis, no allergies, no depression-as-a-condition. If you see one, tell me: that is the line between logging what you notice and being invited to diagnose yourself.
- [ ] The chips still fit a 390px screen at 45 items without the section becoming a wall.

### T14 · Medicines and supplements (P2.4)
Settings → **Medicines and supplements**.

- [ ] Add something with a dose. Confirm Femio says **nothing at all** about the number — no range, no warning, no "that looks high". If any field comments on a dose, that is the line this screen exists not to cross.
- [ ] Look for a streak, a "missed" count or an adherence percentage. There should be none. If a days-on number appears, check it counts from the date you typed, not from anything you did or did not do.
- [ ] Press **I've stopped this**. The entry must move to "Stopped" and stay readable, not vanish.
- [ ] The note at the top should make both absences explicit rather than leaving you to notice a missing field.
- [ ] Arabic: medicine names are often written in English or Franco-Arabic. Check the field accepts either without complaint.

### T9 · The duplicate log button (found in R2.5c)
Any of pregnancy, postpartum, or teen.

- [ ] There is now **one** full-width "Log" button per dashboard. Since R2.3 those screens rendered their own and then the dashboard's, stacked. Confirm none of the three modes lost the button entirely — that is the way the fix could be wrong.

---

## Regression sweep — before a beta or a release

Not every session. This is the "has anything quietly broken" pass.

### R1 · Onboarding, end to end
- [ ] `/welcome` on a fresh browser profile. Complete it without an email.
- [ ] The condition step offers a set that matches the stage you picked.
- [ ] Landing on the dashboard, the mode badge matches your answer.
- [ ] Repeat in Arabic. The whole flow, not a spot check.

### R2 · Daily logging
- [ ] Log a period with flow; it appears on the calendar with the right intensity.
- [ ] Log symptoms with per-symptom severity, plus one custom symptom.
- [ ] Back-date an entry using the day strip — it saves to **that** day, not today.
- [ ] After saving, the "recently logged" list updates **without a page reload**.

### R3 · Offline
- [ ] Turn on airplane mode. Log a period and a symptom — both should accept.
- [ ] Reconnect. Both appear in the record within a few seconds.
- [ ] The crisis dialog **still opens offline** (its copy is bundled, not fetched).

### R4 · Your data
- [ ] Settings → export. The file contains what you logged.
- [ ] `/summary` prints cleanly (Ctrl+P) and carries the "not a medical record" line.
- [ ] Consent toggles persist across a reload.
- [ ] *(Optional, destructive — use a throwaway account)* delete the account and confirm the data is gone.

### R5 · Accessibility, by hand
Automated axe covers contrast and roles; these are the ones it cannot see.

- [ ] Keyboard only: tab through onboarding and the tracker. Focus is always visible, and never trapped.
- [ ] With a screen reader, the life-stage picker announces "option 2 of 5", not "button, pressed".
- [ ] Turn on **reduce motion** in your OS. Nothing animates; buttons still respond to a press.
- [ ] Every tap target is comfortable one-handed. If you have to look at the screen to hit it, it is too small.

---

## What to send me when something is wrong

A screenshot beats a description, and **which locale and theme** matters more than it sounds —
most defects in this project's history were locale- or theme-specific and invisible otherwise.
If it is a behaviour rather than a look, the sequence that produced it is enough; I do not need
console output unless I ask.
