# 29.06 — The screens

Specifications for the surfaces the teardown showed us to be thin. Each says what is
on it, where the data comes from, and what makes it better than Flo's equivalent
rather than merely equal to it.

**Read chapters 02, 03 and 05 first.** Every screen here assumes the v2 module
envelope, the new tables and the chart primitives. Built against today's contract,
each one is work that gets redone.

---

## 1. Dashboard — OD-10, OD-13

Flo's, for reference: a pinned header with avatar, month and calendar icon; a date
strip; a large gradient hero carrying one number; three circular quick-logs; two
content rows; five tabs. **The whole background changes colour with the cycle phase**
— peach with no data, teal in the fertile window — and the date-strip numerals
recolour for the fertile days. Phase is communicated by the entire screen, not a
badge. That idea is free and we should take it.

### Composition

```
┌────────────────────────────────────────────┐
│  avatar        August 23         calendar  │   pinned
│  TODAY 23  M24  T25  W26  T27  F28  S29    │   date strip, phase-coloured
├────────────────────────────────────────────┤
│                                            │
│   PRIMARY MODULE — the served hero         │   phase-tinted ground
│   the number, the range, the confidence    │   (--phase-* crossfade)
│                              ⓘ explain     │
│                                            │
├────────────────────────────────────────────┤
│      ( log period )  ( symptoms )  ( + )   │   quickLog, max 3
├────────────────────────────────────────────┤
│   modules, in served order and emphasis    │
│   · pattern with confidence (D6)           │
│   · cycle summary — her range, no verdict  │
│   · next appointment / visit pack (D3)     │
│   · condition strip (D7)                   │
│   · for you — learn collection             │
│   · tools that suit her persona (OD-10)    │
└────────────────────────────────────────────┘
   Today · Calendar · Log · Learn · Me
```

### The rules that make it ours

**The ground colour is the phase.** `--phase-*` tokens exist; the dashboard's
background is a wash derived from the current phase and crossfades on transition
(`--motion-deliberate`). No badge, no chip. When Femio cannot place a phase, the
ground is neutral — which is itself honest information.

**Maximum three quick-logs.** Flo's discipline, and `config.home.quickLog` already
carries the set. More than three and none of them is quick.

**Every number is tappable and explains itself.** The ⓘ is not decoration: it opens
what the prediction rests on, from `predictions.basis_json` — her last N cycles, their
spread, why the window is this wide, what would narrow it. **This is D2 and it is the
thing Flo cannot do**: their explanation is a general article about menstruation, ours
is about her.

**No verdicts.** Where Flo prints ABNORMAL and IRREGULAR beside empty bars, we show
her own range with the number of cycles behind it. If there are not enough cycles, we
say that instead of grading her.

**Modules are served, ordered and emphasised by the resolver.** Nothing on this screen
is a `mode ===` branch, and nothing is hidden that is not reachable elsewhere.

**Bottom nav is five tabs and none of them is social** — OD-8. Flo spends two on
Secret Chats and Messages; we spend one on Calendar (OD-11) and one on Learn.

---

## 2. Calendar — OD-11, OD-15

Promoted from an icon to a tab. Flo's is one scrolling screen — month grid, then the
selected day's detail — which is the right structure and we take it.

### Day states

Flo has five. We need seven, and two of them are the point.

| State | Treatment |
|---|---|
| Logged period day | Filled, `--log-period`, intensity by `period_days.flow` |
| **First / last day of a run** | Bounded — a rounded cap at each end of the run so length reads without counting (**OD-15**) |
| **Predicted period — likely** | Firm ring, `--confidence-high` |
| **Predicted period — possible** | Soft ring, `--confidence-low` |
| Fertile window | A continuous band beneath the numerals, edges feathered |
| Predicted ovulation | Distinct marker within the band |
| Today | Ring plus weight, composable with any of the above |
| Has logs | A small dot under the numeral, `--log-*` coloured |

**The two probability tiers are the differentiator.** Flo computes them — its string
catalogue carries "likely to start" *and* "may start" — and renders both as one dotted
ring. We render both, differently, from `predictions.likely_*` versus
`predictions.window_*`. This beats the market leader on the surface she looks at most,
using information they already have and do not show.

**Flow intensity in the fill.** `period_days.flow` (chapter 02 §1) means a heavy day
and a spotting day look different. No competitor does this.

**Logged symptoms visible on the grid.** A dot under the numeral turns the month from
a forecast into a record. None of the three apps does it.

**RTL.** The grid mirrors, and so does the *meaning* of a run's ends — the first day
of a period is on the right in Arabic. This is the specific thing that ships broken
if nobody looks.

### Day detail, below the grid

Selected date, cycle day, phase; what she logged that day, editable in place; the
prediction for that day with its ⓘ; the served `calendar.modules` from
`SurfaceMap`.

---

## 3. Log

Flo's `SymptomsPanel` is the best logging screen in the study and its mechanics are
tone-neutral: a date navigator so any day is loggable without leaving; **search across
every trackable**; categories the user can **reorder and hide**; one card per
category; pill chips with bespoke icons, tinted per category.

Take all of it. Then diverge on two things.

**The dimensions are ours** (chapter 02 §2): symptom, mood, discharge, intercourse,
vital. Mood is its own section, not scattered among symptoms. The intercourse
dimension holds **one conservative marker** — OD-5 — not a category of act types.

**Severity is first-class.** `severity` 0–4 already exists and `lib/patterns` uses it
for trend. Flo logs presence only, which is why its patterns cannot say anything got
more intense. Ours can, and the logging UI has to collect it without making every log
a two-step chore — a long-press or a second tap on an already-selected chip.

**Confirmation is designed** (chapter 05 §3). This is where Flo spent its motion
budget and it is why logging feels good there.

---

## 4. Learn

Specified in chapter 04 §4. The one thing to restate: **attribution on the card**, not
only inside the article. A Femio card carries a clinician's name and a review date; a
Flo card carries neither. That is the difference visible at a glance, and it is the
whole strategy in one component.

---

## 5. Tools, and the visit pack

**Tools shows everything, always.** `tools.featured` orders; it never filters
(chapter 03 §3). Femio already has a Tools tab built for exactly this reason.

Additions from TD-05, in value order:

**My questions.** Questions she saves for her next appointment, grouped by topic. The
pregnancy tracker has it; Flo does not. It is small, and it is the missing *input*
half of the visit pack.

**The visit pack — D3.** The feature that makes Femio a health record rather than a
tracker. Choose an appointment; Femio assembles her saved questions, the patterns
with their confidence and evidence, screener scores with bands and interpretation,
medications, recent labs, and her cycle summary — as one page to hand over or send
ahead.

Constraints, because this one sits closest to the medical-device line: it **prepares a
conversation and never interprets**. Every number carries its provenance and every
pattern its confidence. It separates what she recorded from what Femio computed — the
existing doctor-visit summary already does this and the rule holds. And it is
export-first: PDF and print, in her language.

Flo sells this idea in its onboarding — *"Get symptom checkups in just 2 minutes, not
years"*, *"Help your doctor to help you"* — with none of the apparatus behind it. We
have the apparatus and no story. **Build it, then say so.**

Then the rest of TD-05: birth plan (structured, saved, exportable), trimester-aware
to-do, hospital bag, baby names.

---

## 6. Onboarding

Chapter 03 §7 specifies the document. The screen rules:

One question per step. A reason-for-asking subtitle on every question — Flo does this
consistently and it is why their questions do not feel like a form. "I don't know" as
a real answer. Normal ranges as helper text where one exists, which Petal does and Flo
does not. A recovery step when she cannot remember a date. A pre-permission primer
before any OS dialog.

**Under fifteen steps to a working dashboard.** No social proof, no donation cards, no
commitment ritual, no paywall at the end — OD-6.

**The refusal path is designed.** Z1 is a destination with its own artwork, not an
error state. Flo gives "none of the above" its own animation; ours should be better,
because for us it is a persona rather than a dead end.

---

## 7. Privacy — D5

A surface no competitor has: every consent with its date and exact scope, every share
and to whom by name, every export, and a one-tap revoke on each. `consent_records`,
`partner_links` and `audit_log` already hold the data.

Flo made privacy an animated onboarding moment and its Anonymous Mode is a genuine
feature. Ours is a **standing, checkable account** of who touched her data — a
position rather than a feature, and the only screen in this category that could pass
an audit.

---

## 8. What we are not building

No messaging, no chat, no community, no assistant before V1 — OD-8, OD-9.

The two nav slots Flo spends on social, we spend on Calendar and Learn. The
calculators — five, and no competitor in this study has any — stay on Tools and in
Learn as entry points.
