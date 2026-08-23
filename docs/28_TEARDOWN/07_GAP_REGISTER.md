# 28.07 — Gap register

Every gap that stands between Femio and the standing rule, ranked. Each carries an
id (`TD-nn`), the evidence that proves it, and what "closed" means. **Nothing here
is in `07_MASTER_TODO.md` yet** — per Khaled's direction of 2026-08-23 this register
is reference-only until he approves it, at which point a separate pass converts the
accepted lines into queue items and a phase document.

Ranking is by *distance from the standing rule*, weighted toward Khaled's stated
priority: delightful views, dashboards, information and graphics.

Effort is a rough band: **S** ≤ 1 session, **M** 2–4, **L** 5–10, **XL** more.

---

## Tier 1 — the surface Khaled asked about

### TD-01 · There is no data-visualisation layer · XL

**Evidence.** One chart component in the entire repository
(`components/pregnancy/weight-chart.tsx`, 209 lines) and no charting library in
`apps/web/package.json`. Flo ships six native chart surfaces plus three
server-driven chart element types (`TemperatureChart`, `ScoreChart`,
`ProgressCircular`) and keeps chart colours in its design system.

**Closed when.** A charting foundation exists for both clients, with chart tokens in
`assets/brand/tokens/`, and every track has at least the charts its data supports:
cycle length and variability, symptom frequency over time, BBT, weight, glucose,
labs trend, mood trend, wellbeing score. Bespoke and token-driven, not a library's
default theme. Judged on a 390×844 viewport, light and dark, and in Arabic RTL.

**Note.** This is the largest single gap in the study and the one Khaled named
first. It should be treated as its own workstream, not a task.

---

### TD-02 · There is no motion or delight layer at all · L

**Evidence.** Zero animation assets in the repository. Flo ships roughly fifty of
its own Lottie animations, ten of which exist purely to make *logging* feel like
something happened — three flow levels, seven cervical-fluid types — plus prediction-change
animations, streak animations, an animated privacy shield in onboarding, and a
typing indicator.

**Closed when.** A defined motion vocabulary exists (the four `ease-*` tokens are the
seed), every primary logging action has a considered confirmation, state changes to
predictions are animated rather than swapped, and empty/loading/error states are
designed rather than default. Flo's device-capability gating is the model for
performance: author the animated and the still version, and choose.

---

### TD-03 · The module contract is missing accessibility and analytics · M

**Evidence.** `ModuleSpec` is `{ id, emphasis, params? }`. Flo's element envelope
carries eleven fields including `accessibility`, `impressionConfig`,
`onFirstAppearance`, `onVariableChanged`, `output`, `visibilityAnimation` and a
typed `style`.

**Closed when.** `ExperienceConfig`'s module contract carries accessibility metadata
and impression config as *required* fields, so a served module cannot ship
unlabelled or untracked, plus a typed style slot and a visibility-animation slot
that TD-02 can use. This is a contract change with a version bump and golden-fixture
updates, and it should happen before more modules are written against the current
shape.

---

### TD-04 · Two-thirds of the persona taxonomy is unwired · L

**Evidence.** 73 persona specs in `docs/personas/`; 24 ids registered in
`lib/experience/registry/`. Flo's segmentation is smaller than ours but entirely
live.

**Closed when.** Every specced persona either has a registry record or is explicitly
marked deferred with a reason. The `extends` chain in `build.ts` already makes most
of these cheap — a persona that differs from its parent by two modules is a
ten-line record.

---

### TD-05 · Pregnancy is missing nine of the eleven expected tools · L

**Evidence.** The pregnancy tracker ships kick counter, contraction timer, weight,
symptoms, appointments, birth plan, my questions, to-do, shopping list, hospital
bag, baby names. Femio has contraction timer, movement counter, weight and
appointments.

**Closed when.** Birth plan (structured, saved, exportable), questions-for-your-clinician
grouped by topic, trimester-aware to-do, hospital bag and baby names exist. "My
questions" is the highest-value of these — it feeds the clinician summary we already
have and nothing else in the market connects those two.

---

## Tier 2 — depth that the rule requires

### TD-06 · The tracking vocabulary is a third of Flo's · M

**Evidence.** ~22 symptom keys in `lib/cycle/symptoms.ts` versus Flo's 47 symptoms,
16 moods, 11 discharge types and 10 sex/libido entries.

**Closed when.** Mood is its own dimension rather than symptom keys; discharge and
cervical fluid are trackable (they are clinically meaningful for TTC and for
infection awareness); BBT is trackable; and the perimenopause and postpartum symptom
sets match what `docs/16` and the MRS already imply. Everything added must feed
`lib/patterns`.

**Amended by owner direction, 2026-08-23 — see `10_FLO_RUNNING.md` §6.** The
sexual-health scope is clinical only. A single conservative *intercourse* /
*conception* marker carrying a date, because that is all `lib/fertility` needs. No
"sex and sex drive" category, no act types, no orgasm or masturbation entries.
Painful intercourse, vaginal dryness, bleeding after intercourse and libido change
*as a symptom* stay, under clinical names. Conservative wording is part of the
requirement in Arabic, French and Spanish, not a later copy pass.

### TD-07 · No platform-health or wearable input · L

**Evidence.** Flo reads 21 Health Connect data types and holds
`READ_HEALTH_DATA_IN_BACKGROUND`, with a dedicated Oura connector and Wear OS
support. Femio accepts no external health data.

**Closed when.** The Flutter client reads Health Connect on Android and HealthKit on
iOS for at least menstruation, BBT, weight, sleep, steps and heart rate, under
explicit granular consent, written into the existing `vitals` and `symptom_logs`
tables. This is the largest category of user data we currently refuse.

### TD-08 · Content is English-only · L

**Evidence.** All 105 articles in `docs/content/articles/` are `locale: "en"`. The
UI is at four-language parity (1,836 keys × 4); the medical content is not.

**Closed when.** The published set exists in Arabic at minimum, with the same
citation and review standard, and the CMS models locale as a first-class dimension
with review state per locale. **An Arabic-first product whose medical content is
English is not an Arabic-first product**, and this gap undercuts our single
strongest differentiator.

### TD-09 · Onboarding is a form, not a narrative · M

**Evidence.** Flo's onboarding is 442 steps in which 124 are teaching or reassuring
cards against 90 questions, with 21 contextual notification-permission moments and
nine illustrated goal choices. Femio's wizard is a coded sequence of questions.

**Closed when.** Onboarding is a data document with the shape Flo uses — steps,
conditional transitions with tag conditions, precomputed progress — and the ratio of
"we tell you something" to "you tell us something" is deliberately chosen rather
than incidental.

**Amended by owner direction, 2026-08-23 — see `10_FLO_RUNNING.md` §2.** Walking
Flo's 57-screen flow end to end, the owner's verdict was that it is soliciting and
boring rather than comfortable. So: keep the answer-then-respond rhythm, the
reason-for-asking subtitle on every question, "I don't know" as a first-class
answer, the recovery screen when she cannot remember a date, and the pre-permission
primer. Reject the social-proof stat cards, the donation cards, the commitment
ritual, the three-layer goal interrogation and the paywall as terminus. Target:
good-looking, joyful, simple, short, no overselling — she reaches a working
dashboard, and Femio earns the rest later.

### TD-10 · No remote config, experiments or kill switches · L

**Evidence.** Flo has 149 feature-flag classes with a supplier chain
(remote → local → default) and dependencies between features, plus `core.experiments`
and `core.targetconfig`, and ships concurrent experiment arms in production.

**Closed when.** Medical thresholds, red-flag sets, alert cadences and feature
availability can be changed without an app-store release, with a documented
supplier order and an audit trail. For a product whose tier-1 decisions are medical,
this is a safety mechanism before it is a growth mechanism.

---

## Tier 3 — breadth

### TD-11 · No community, and no decision about whether we want one · M to XL

Flo has groups, comments, replies, an expert blog, bookmarks and a full social
profile with an avatar constructor. `docs/STATE.md` lists community as deferred by
owner direction. **Closed when** the deferral is either confirmed with a stated
reason in the strategy doc or converted into a scoped plan — the gap register should
not carry an open item the owner has already closed.

### TD-12 · No assistant surface · L

Flo's assistant is positioned as a consumer of tracked data ("Log your signs and
symptoms to get the chats that are most relevant to you") with a one-line disclaimer.
**Closed when** we decide whether an assistant is compatible with product rule 1 at
all — a wellness assistant that never diagnoses is possible, and our cited content
corpus plus the pattern engine is a better substrate for one than Flo has. This is a
strategy decision, not an engineering one, and it belongs in `docs/05`.

### TD-13 · Design tokens are a palette, not a system · M

**Evidence.** 144 tokens in one CSS file against Flo's nine typed token classes.
Missing: per-event-category colours with an alternate variant, button hover/pressed
states, a named focus-ring colour, chart active/inactive pairs, illustration skin
tones, avatar backgrounds, a radius scale beyond `radius-*`, and a border scale.

**Closed when.** Those families exist in `assets/brand/tokens/`, and `docs/12` is
updated. Note the migration lesson from Flo: pick the numeric scale
(`space-050/100/200`) now rather than a multiplier scale, because they are visibly
paying to migrate off theirs.

### TD-14 · No richer content formats · M

Flo has video, a stories format, a vertical feed, search, and a `Deck` element.
Femio has articles. **Closed when** at least search exists across our own corpus —
we have 105 articles, a glossary and a conditions library and no way to search them,
which is the cheapest item in this tier and probably belongs in tier 2.

### TD-15 · No home-screen widget · S to M

Flo ships a configurable pregnancy widget. Cheap on Flutter, high daily-visibility
value, and it suits a life-stage product better than it suits a period tracker.

### TD-16 · Charts and predictions have no offline story in the UI · S

Flo ships designed copy for degraded predictions: *"Flo is offline. Connect to the
internet to refresh and restore your cycle predictions. Tap to refresh."* We have an
offline queue but no equivalent honesty in the interface.

---

## Two gaps that run the other way

Recorded so chapter 08 can build on them.

**Flo's uncertainty language is already good.** "Your period is likely to start on
this day" versus "may start on this day", a two-tier probability band on the
calendar with a learn-more link on every legend entry, and consistently
non-contraceptive fertility phrasing. Our product rule 3 is not a differentiator on
its own — it is table stakes we have not yet met in the interface. What we can beat
them on is showing *why* the confidence is what it is, which their model has no
place for and our `cycle.variability` module does.

**Nobody has clinical trust.** No competitor in this study has citations, a named
clinician byline, an editorial policy, a medical-review page, or a validated
screening instrument. Flo's assistant disclaims itself in one line. This is the
widest open field in the market and we already stand in it — badly signposted.
