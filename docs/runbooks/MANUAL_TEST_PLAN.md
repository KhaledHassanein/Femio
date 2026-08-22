# Manual test plan — what only a human can check

**Companion to `OWNER_MANUAL_TASKS.md`, and deliberately separate from it.** That file is
credentials, keys and one-off configuration — things only the owner *can* do. This file is
things only a human can *judge*: whether a screen looks right, whether Arabic reads naturally,
whether a flow feels like a product.

**Why it exists.** Every automated gate in this repo passes on every commit — 11 guards, 525
unit tests, 63 end-to-end. None of them can tell you the homepage looks generic, that a
translation is grammatically correct but tonally wrong, or that a control is out of thumb reach.
`docs/22` §10 states the rule this file operationalises: *a screenshot is the test, not a
nice-to-have.*

**How to use it.** Work the **▶ After the latest changes** section first — it is short and
tracks what actually shipped. The regression sweep below is for before a beta or a release, not
for every session.

**Unseen as of 2026-08-17: T8, T10–T24.** Seventeen items are waiting and nobody has looked at
any of them. **T23 is the cheapest** — three HTML files, no server, and approving them is the one
thing standing between the design references and building against them (`docs/25` §1). **T24 is
the one I most want a clinician on**: ten guides written for nine- to seventeen-year-olds, where
the expensive failure is a condition named as a possibility and the guard cannot see it. **T22 is the one that blocks other work** — fourteen postpartum drafts
waiting on your review gate, and publishing them is what fills the postpartum reading card.
**T21 is the one I most want read** — the three sentences a woman sees
after a pregnancy ends, including a stillbirth. **T16 is the one I would want read first** — it is the only screen in Femio that
acts on an answer. Migration `0008` is applied, so T15 is testable. **T11 and T12 want you as a clinician rather than as an owner** —
charting must not read as contraception, and the MRS must not read as a grade. Those two are
the ones I would not ship to an outside tester unread.

**Standing conditions for every check:** a real phone if possible, otherwise a browser at
**390×844**. Each screen in **light and dark**, and in **English and Arabic**. Arabic is a
first-class market, not a locale toggle.

---

## ▶ After the latest changes (2026-08-16)

### T26 · Partner sharing (Phase 4.5) — the copy is the safety feature here
**Settings → Sharing with a partner**, or the Tools tab. Needs **two accounts**: use a private
window for the second one.

The machine has already proved the hard parts — a withheld category is absent from the payload
rather than empty, a revoked share returns byte-identical JSON to a stranger's, an unknown age is
refused. What no test can judge is whether the screen *reads* as safe to a woman who has a reason
to be careful. That is this check.

- [ ] Tick only **when your next period is expected**. Create the code, redeem it on the second
      account, and open **Shared with you**. Confirm with your own eyes that the page contains
      **no trace of the six things you did not share** — no "hidden", no empty section, no greyed
      row, no "1 of 7". It should read like an app that only ever had this one feature. *This is
      the single most important thing on this list, and it is invisible to every automated check.*
- [ ] Read the "some things can never be shared" paragraph. Could she point at it and say to
      someone, truthfully, *"the app doesn't offer that"*? If it reads like a Femio policy rather
      than a fact about the product, it is not doing its job.
- [ ] Tap **Stop sharing**. It goes immediately, with no "are you sure". Confirm nothing on the
      second account announces it — reload and it is simply empty. Then decide whether one tap is
      right: a mis-tap costs her a new invite, and a confirmation step costs her the seconds
      someone reading over her shoulder needs.
- [ ] Read the seven category labels and their notes. They are the sentences she will be argued
      with about. **Arabic especially** — the whole namespace is new and unread.
- [ ] Check there is genuinely no "share everything" control anywhere on the screen, and decide
      whether you still agree with that after seeing it. Seven taps is the friction; the friction
      is the feature.
- [ ] At 390×844, light and dark, English and Arabic.

### T27 · The visit report as an actual PDF (R3.1c.4)
**Settings → Doctor-visit summary → Print**, then "Save as PDF".

`scripts/dev/print-check.mjs` now measures this in light and dark and writes the PDFs. What it
cannot judge is whether the printed page is a document a clinician would accept.

- [ ] Print it **from dark mode**. That is where a failure would be: the print stylesheet forces a
      white page, and dark-theme text colours on white paper is how this breaks silently.
- [ ] Confirm the **derived** section — the dashed box — is still clearly separated from what you
      logged. A clinician has to tell an estimate from an observation at a glance; if the two blur
      on paper, the report launders a prediction into a medical record.
- [ ] Check nothing important lands across a page break.

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

### T15 · Contraction timer and weight (P2.2.3)
Pregnancy mode, third trimester (set a due date within ~4 weeks).

- [ ] **Contractions.** The "call your maternity unit" panel is **above** the timer and present before, during and after. If it ever moves below, or appears only after some number is reached, that is the bug this design exists to prevent.
- [ ] Time three or four. You get an average duration and an average gap, and **nothing else** — no "this looks like labour", no colour change, no 5-1-1 verdict. Femio times; the midwife reads.
- [ ] Start one and leave the page. Come back: the timer should not be counting up from hours ago.
- [ ] **Weight.** Add two readings. The chart is dots on an axis with **no target line and no shaded range**. If you see a band, tell me immediately — that is an assessment of a woman's body drawn as a background colour, in a period that is high-risk for disordered eating.
- [ ] Enter `650` kg. It should refuse as a typo. Enter `25` and `300` — both must be accepted, because the guard is for typos and must never become a comment on her weight.
- [ ] Switch to lb for the newest entry: the axis and the change figure should follow, converting the older kg entries.

### T16 · The postpartum mood check — EPDS (P2.7, P1.26.3) — the most safety-critical screen in the app
Settings → **After birth**, then the mood check under the hero.

**Read this one as a clinician.** It is the only screen in Femio that acts on an answer.

- [ ] The postpartum screen has a **hero card** again. If it does, R2.5 shipped without one for four days and this is the fix; if it does not, tell me immediately.
- [ ] Read the ten items against the published EPDS in English, then in Arabic, French and Spanish. The instrument is not mine; the wording of these translations is.
- [ ] Check the **two reverse-scored items** (laughing, looking forward). Picking “as much as I always could” must be the *least* symptomatic answer. If the chips look inverted, the score is wrong in the direction that under-reports.
- [ ] **Item 10.** Answer it above “never”. The crisis dialog must open **immediately on the tap** — not on save, not after a score appears. A panel should also stay on the screen behind it, so closing the dialog does not remove the route.
- [ ] Do that with every other answer at “never” (total 1). It must still open. A low total must never suppress it.
- [ ] Then set item 10 back to “never”: the panel goes, and the dialog does not reopen when you touch other answers.
- [ ] Confirm there is **no band and no label** anywhere — no “probable depression”, no colour grading the total.
- [ ] Saving is a separate button and clearly optional. She must be able to take the help without leaving a record.
- [ ] Arabic especially: this is the highest-risk translation in the app after the crisis copy itself.

### T17 · The personalization offer (P1.27.5)
A fresh account, skipping the life-stage question at signup ("Not sure yet").

- [ ] With **nothing logged**, there should be **no offer at all**. If Femio suggests a life stage to someone who has told it nothing, that is the failure this shipped with a threshold to prevent.
- [ ] Now give it something thin — an age band of 13–15, or a couple of logged periods. An offer appears, naming a **life stage** ("Teen", "Cycle"), never a persona code.
- [ ] It says it is reversible **before** the buttons, not after.
- [ ] Press **No thanks**. It goes, and it stays gone on reload.
- [ ] On a second account, press **Yes, tailor it**. The badge and the screen change, and Settings → Your Femio experience can put it straight back.
- [ ] Sign out and in as someone else on the same browser: the first woman's dismissal must not follow her.

### T18 · PHQ-9 and GAD-7 (P2.7)
Settings → **Mood questionnaires**. In any mode.

- [ ] Read both instruments against the published wording, in four languages. The nine PHQ-9 items and seven GAD-7 items are the standard ones; the translations are mine.
- [ ] **PHQ-9 item 9** ("better off dead, or of hurting yourself"). Answer it above "not at all" with everything else at "not at all" — total 1. The crisis dialog must open **on the tap**, and a panel must stay behind it. Exactly the T16 behaviour, on a different screen.
- [ ] Fill GAD-7 entirely at "nearly every day" — total 21. Nothing should open, because GAD-7 has no self-harm item. If anything fires, the wrong instrument's rule is being applied.
- [ ] No band, no "moderate", no colour on either total.
- [ ] Both are reachable in **cycle, TTC, pregnancy and menopause** modes, not just one.

### T19 · The stage question at signup (P1.27.8)
`/welcome` on a fresh browser profile.

- [ ] Pick **Trying to conceive**. A "how long have you been trying?" question appears on the same step as the conditions, in bands. Pick **1 to 2 years**, finish, and check the dashboard is not simply the fertile-window screen — she is past her evaluation window and Femio should read differently.
- [ ] Repeat with age **35–44** and **6 to 12 months**: the shorter clock applies from 35, so that should behave like the two-year answer above, not like the under-35 six-month one. This is the one clinical judgement in the feature and it is yours to check.
- [ ] Pick **I recently gave birth**. A "roughly when did you give birth?" question appears. Answer it, finish, and confirm the postpartum screen appears — **without** Femio ever having seen a pregnancy. That is the common case and it did not work before.
- [ ] Skip the question in both flows. Nothing should be assumed: you stay in the general TTC or postpartum experience rather than being promoted.
- [ ] Now switch mode in Settings and switch back. Your answer must survive — it used to be erased.
- [ ] Read both questions and their notes in Arabic, French and Spanish.

### T20 · The transitions (P1.27.6) — read the loss one as a clinician
Any mode.

- [ ] In **TTC** mode, set a due date (which records a pregnancy). Back on the dashboard, Femio should *offer* to move you to Pregnancy — not do it. Accept: the screen changes and Settings can put it back.
- [ ] In **Pregnancy** mode, end the pregnancy. Femio should offer to move to After birth, **gently, with no urgency, and no celebration or condolence in the copy**. Read that sentence carefully — it is the one place in the app where a transition could land badly, and my judgement here is not a substitute for yours.
- [ ] Press **No thanks** on it. It goes and stays gone.
- [ ] Then, without changing anything else, check that a *different* suggestion can still appear later — dismissals are per suggestion, not blanket.
- [ ] Switch to **Cycle** mode with an old ended pregnancy in your record. Femio must say **nothing**. Raising a pregnancy that ended two years ago, unprompted, is the failure this rule exists to prevent.
- [ ] Arabic, for all three messages.

### T21 · What happens after a pregnancy ends (P2.3) — the most sensitive copy in the app
Pregnancy mode, then **end the pregnancy** three separate times on three accounts.

**Read all three sentences as a clinician and as a person. This is the one I most want your eyes on.**

- [ ] **A live birth.** The offer is warm and says congratulations once, without exclamation, and mentions recovery and feeding. Accept it: you should land on the **feeding** view — a lactation hero plus a per-breast symptom log — with the recovery content still there beneath it, not replaced.
- [ ] **A loss.** The offer must contain **nothing cheerful, nothing hurried, and no countdown**. It should say her record is safe, that Femio can move when she wants, and stop. Check specifically that **no feeding content appears anywhere** after accepting — that is the single worst thing this track could do.
- [ ] **Ended, without saying which.** The sentence must assume **neither**. No congratulations, no condolence. She gets recovery, and nothing about feeding.
- [ ] In all three: nothing switches on its own. Every one is an offer with a **No thanks**.
- [ ] Read all three in Arabic. Loss is private and often stigmatised in MENA — E6's own spec says so — and the Arabic sentence carries more weight here than the English one.

### T22 · The fourteen postpartum guides (P2.3c) — you are the review gate
`femio-cms.vercel.app/admin` → Articles. Fourteen new drafts, none public.

**This is the one that cannot be automated away.** `content-lint` checked structure, sourcing,
claim verbs, links and metadata; none of that is medicine. Nothing goes live until you set
`reviewStatus: approved` and publish, article by article.

- [ ] Read each draft as a clinician. The four I would read first: **postpartum warning signs** (the escalation lists), **your mood after birth** (the crisis routing and the intrusive-thoughts section), **when breastfeeding is not working** (guilt, and the mastitis timing), and **contraception after birth** (the lactational-amenorrhoea paragraph, which is the one place the brief's contraception ban and clinical accuracy pull against each other).
- [ ] Check the **red-flag boxes** name what you would name, in the order you would name it.
- [ ] Check nothing reads as triage — no article should tell a woman a symptom is or is not serious.
- [ ] Approve and publish the ones you are happy with. **The dashboard reading card fills itself in** as you publish: no deploy, no code change. Publish one and reload a postpartum dashboard to see it appear.
- [ ] Anything you want changed, say so and it is an edit, not a re-draft.

### T24 · The ten teen guides (P2.13) — you are the review gate, and this set is the one to read hardest
`femio-cms.vercel.app/admin` → Articles. Ten new drafts, none public.

**Why this set more than the postpartum fourteen.** The failure that matters here is invisible
to `content-lint`: a condition named as a possibility in front of a thirteen-year-old. A2 §D is
explicit that irregular cycles are developmentally expected for two to three years after a first
period and that a diagnosis should generally not be made in that window, so the word PCOS on one
of these pages would plant a label a clinician would not.

- [ ] Read each draft as a clinician. **The three I would read first: `is-my-period-normal`**
      (the reassurance article, and the one carrying the "is the app broken or am I broken"
      answer), **`period-pain-in-teens`** (where the line between ordinary cramps and an
      appointment is drawn), and **`when-to-tell-an-adult`** (the safeguarding paragraph and the
      15 / three-years / no-signs-by-13 thresholds).
- [ ] **Two named things, and both are deliberate — tell me if either is wrong.** *Toxic shock
      syndrome* is named in the tampon sections, because the FDA and NHS both name it as the
      reason to follow the packet instructions. *Dysmenorrhea* appears only inside an ACOG page
      title in a citation, never in prose.
- [ ] Check the red-flag boxes on articles 5, 7 and 10 name what you would name, in your order.
- [ ] Check the tampon paragraph in `choosing-period-products`. It says guidance differs between
      countries and refuses to pick one, which is honest but may not be how you want it phrased.
- [ ] Check nothing reads as withheld. The rule for this set is that teen mode gates ads, data
      and social exposure — never knowledge — and every article answers before it routes.
- [ ] Approve and publish the ones you are happy with. **The teen dashboard's reading card fills
      itself in** as you publish, with no deploy: A2 foregrounds seven topics and shows the first
      four that are live.

### T25 · The thirty-seven week-by-week entries (P2.2.2) — you are the review gate, and the risk is one sentence type
`femio-cms.vercel.app/admin` → Articles. Thirty-seven new drafts, `pregnancy-week-4` … `pregnancy-week-40`, none public.

**What the whole set turns on.** Not accuracy of the fun — the fun is approved — but whether any
sentence reads as a measurement of *her* baby. *"Around week 12 the NHS gives a measurement of
5.4cm, about the size of a plum"* is a population illustration; *"your baby is the size of a
plum"* is a verdict handed to a woman whose scan measured small. Every figure in the set is
attributed and hedged, and the full argument plus the five places I was least sure is in
`docs/content/HANDOVER_WEEK_BY_WEEK_RETURN.md` Part 4. **Read that part before the articles.**

- [ ] Read these six first, in this order: **week 24** (viability, and the week the movement line
      enters the red-flag box), **week 40** (the due date as an estimate, term as 37–42 weeks, and
      how the 41/42-week induction offer is described), **week 28** (repeat bloods, anti-D,
      glucose screening and RSV — the busiest week, and three of those differ UK vs US), **weeks
      25 and 35** (the two pre-eclampsia pages, each drawing a line a reader could take the wrong
      half of), and **week 4** (the only entry with no previous week, read by someone frightened
      rather than curious).
- [ ] **The section heading `## Your baby this week` is the most possessive string in the set**
      and it came from the brief. If you want it changed, say so — all 37 change together.
- [ ] Check the movement wording. It appears in the red-flag box from **week 23** and says *any
      reduction in her usual pattern*, routed to the maternity service. **There is no count
      anywhere in the set**, deliberately. Tell me if you want one; I will argue against it.
- [ ] Check the three red-flag variants are where you would put them: shoulder-tip pain in weeks
      **4–12**, fluid leaking from **13**, movement from **23**, pain below the ribs from **35**.
- [ ] **No fetal weight appears anywhere.** The NHS week pages do not give per-week weights and
      every table that does traces back to app blogs. If you want weights, they need a source you
      are willing to stand behind.
- [ ] Check the care sections. Each names a guideline body and says schedules differ between
      countries; none presents a schedule as Femio's. Week 28 and week 33 are the two where a UK
      reader and a US reader are told genuinely different things.
- [ ] Approve and publish the ones you are happy with. **The pregnancy dashboard reading card
      fills itself in** as you publish, and from this item on it is **week-aware**: a woman at 14
      weeks sees `pregnancy-week-14` at the top of her card, and at 31 weeks she sees
      `pregnancy-week-31`. No deploy, no code change.
- [ ] On a 390×844 phone, open the pregnancy dashboard and check the reading card at two
      different gestations (change the due date in Settings). Light, dark, and Arabic RTL — the
      card heading and the pending line are translated, the article titles are not, because the
      set is English only.
### T23 · The three new design references (R1.5, R1.7, R1.8) — approve or send back
Open each file directly in a browser; they need no server. Zoom to 100% and look at the phones
as phones.

- `assets/mockups/R1.5_cycle_dashboard_reference.html` — the cycle dashboard
- `assets/mockups/R1.7_menopause_dashboard_reference.html` — menopause
- `assets/mockups/R1.8_track_screen_reference.html` — track / log

**This is `docs/25` §1's one process rule**: a screen is designed and approved before it is
implemented, and when the reference and the code disagree the reference is the bug report. So
approving these is what unblocks R1.9, and it is worth an hour rather than a glance.

- [ ] **The R1.5 question, and it is the biggest one in the set:** B2's hero is a *control*
      (today's mood, logged from the hero) and B4's is a *count*, where B1's is a prediction.
      Is a per-persona hero right, or should every cycle persona keep the window and differ
      below it? Everything else in that file follows from the answer.
- [ ] **R1.5 · the irregular hero.** B5 gets a full-size hero that says Femio will not guess,
      with a dotted band. Does that read as honest, or as broken? It is the sentence a woman
      with 90-day gaps sees every day.
- [ ] **R1.7 · the count with no conclusion.** F2's hero says "2 years and 5 months since your
      last period" and never "postmenopausal". Read it as a clinician: does the refusal read as
      respect or as evasion? That is the brief for the whole screen.
- [ ] **R1.7 · F4 in Arabic, dark.** Induced menopause is the tonal sibling of E6, and the
      Arabic is the paragraph I am least sure of in this set.
- [ ] **R1.7 · the MRS card.** A number, her own past totals, and no word. Does it look
      finished without a severity label?
- [ ] **R1.8 · one open logger, the rest collapsed.** Today every logger is expanded. Is the
      collapse right, and is the right one open per mode (period for cycle, movement for
      pregnancy, symptoms for menopause)?
- [ ] **R1.8 · the pregnancy screen.** The maternity-contact panel sits above the movement
      counter. Confirm that ordering is what you would want at 2am.
- [ ] Anything you want changed is an edit to the reference, not a re-draft — say which file
      and which module.

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
