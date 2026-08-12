# Manual test plan — what only a human can check

**Companion to `OWNER_MANUAL_TASKS.md`, and deliberately separate from it.** That file is
credentials, keys and one-off configuration — things only the owner *can* do. This file is
things only a human can *judge*: whether a screen looks right, whether Arabic reads naturally,
whether a flow feels like a product.

**Why it exists.** Every automated gate in this repo passes on every commit — 10 guards, 331
unit tests, 63 end-to-end. None of them can tell you the homepage looks generic, that a
translation is grammatically correct but tonally wrong, or that a control is out of thumb reach.
`docs/22` §10 states the rule this file operationalises: *a screenshot is the test, not a
nice-to-have.*

**How to use it.** Work the **▶ After the latest changes** section first — it is short and
tracks what actually shipped. The regression sweep below is for before a beta or a release, not
for every session.

**Standing conditions for every check:** a real phone if possible, otherwise a browser at
**390×844**. Each screen in **light and dark**, and in **English and Arabic**. Arabic is a
first-class market, not a locale toggle.

---

## ▶ After the latest changes (2026-08-12)

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
