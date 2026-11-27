# 28.08 — Beyond parity

Chapter 07 is the price of entry. This chapter is the rest of the standing rule —
*and then carry multiple features none of them have* — and per Khaled's direction of
2026-08-23 it is sourced from our own corpus rather than from more teardowns.

The corpus is real and it is large: 73 persona specs across seven tracks
(A ×6 adolescent, B ×19 cycle and gynae, C ×16 TTC and fertility, D ×17 pregnancy
and postpartum, E ×7 menopause, F ×6 cross-cutting, X ×2), the adaptation model in
`docs/09`, the condition library IA in `docs/16`, 69 ADRs, and a content pipeline
with citations and clinician bylines. None of the three apps has anything comparable
behind it.

The discipline this chapter imposes on itself: **a differentiator is only a
differentiator if it is a thing a user can see and use.** "We have 73 persona specs"
is not a feature. What those specs make possible is.

---

## D1 · The record that does not restart — made visible

**What we have that they do not.** Product rule 5: one record spans puberty to
menopause, and a state change re-layers content over an unchanged core. Flo's
equivalent is a goal switcher between five tracks; the pregnancy tracker has one
stage and ends. Nobody else can answer "what were my cycles like before the
pregnancy?" or "how does this perimenopausal pattern compare to my twenties?"

**The feature.** A **life timeline** — one continuous view of the whole record, with
stages as bands rather than as separate apps, and the ability to compare any two
periods of your own life. Flo has a `TimelineActivity`, but it is a feed of recent
events, not a life.

**Why it wins.** It is the only feature in this document that is *impossible* for a
single-stage competitor and *expensive* for Flo, because their data model is
organised around the current track. Ours already is not: 27 tables, one `profiles`
row, additive layers.

**Depends on:** TD-01 (charts).

---

## D2 · Confidence you can interrogate

**What we have that they do not.** Flo already ships two-tier prediction language —
"likely to start" versus "may start" (chapter 02 §7). So honesty is not our edge.
But Flo's model has nowhere to put *why*, and ours does: `cycle.variability` is a
distinct module from `cycle.window` precisely so that the app can show her own cycle
lengths and, when they cannot support a window, say so.

**The feature.** Every prediction is tappable and explains itself: here are your last
N cycles, here is the spread, here is why the window is this wide, here is what
would narrow it. And when Femio will not predict, it says which fact is missing
rather than showing a blank.

**Why it wins.** It converts our one genuinely uncomfortable product constraint —
refusing to give a single certain date — from a limitation into the most trustworthy
screen in the category.

**Depends on:** TD-01, TD-03.

---

## D3 · The clinician bridge

**What we have that they do not.** Validated screeners (EPDS, MRS, mood), a
`screener_results` table, `conditions_flagged`, `labs`, `meds_supplements`,
appointments, an export path, and a summary surface. No competitor in this study has
a single validated instrument or any clinician-facing output — and per chapter 10
§2, Flo is already *selling* this idea in its onboarding funnel without any of it
built.

**The feature.** A **visit pack**: pick an upcoming appointment, and Femio assembles
the questions you saved, the patterns the engine found with their confidence, your
screener scores with their bands and interpretation, your medications, your recent
labs, and your cycle summary — as one page you can hand over or send ahead. The
pregnancy tracker's "my questions" (chapter 03 §4) is the missing input half; we
already have the output half.

**Why it wins.** It is the feature that makes Femio a health record rather than a
tracker, it is squarely inside product rule 1 (it never diagnoses, it prepares a
conversation), and it is the one thing a clinician would tell a patient to use.

**Depends on:** TD-05 (my questions), TD-01.

---

## D4 · Arabic and RTL as a product, not a translation

**What we have that they do not.** Chapter 06 §K: no competitor in this study ships a
real Arabic translation, and Flo's Android app declares `supportsRtl="false"`. We
have 1,836 keys at four-language parity, a dedicated `font-ar` token, RTL-native
component conventions in `docs/22`, and a translator workflow at
`admin/translations`.

**The feature.** Not "the app in Arabic" — that is TD-08 and it is parity work
against ourselves. The differentiator is **content and clinical framing authored for
these markets**: the conditions library reflecting regional prevalence, content that
handles Ramadan fasting with cycle and pregnancy, culturally-aware framing of sexual
and reproductive health that neither ignores it nor imports a Western default, and
a privacy posture that understands shared devices and family visibility.

**Why it wins.** It is unopposed, it compounds (every article is an asset), and it is
the reason a woman in Cairo, Riyadh or Dubai would choose us over Flo specifically.

**Depends on:** TD-08. This is the highest-leverage item in the whole study.

---

## D5 · Verifiable privacy

**What we have that they do not.** Rule 4 forbids ad and analytics SDK access to
health data outright. Chapter 04 shows what the alternative looks like at its worst,
and chapter 02 §13 shows that even the leader runs AppsFlyer attribution with a
consent dialog titled "Your body, your data". We have `consent_records`, an
`audit_log`, RBAC, k-anonymous insights, per-recipient named sharing consent
(ADR-069), export and delete.

**The feature.** A **privacy page that shows rather than promises**: every third
party that has ever touched anything (there are none for health data), every consent
you have given with the date and the exact scope, every share you have made and to
whom by name, every export, and a one-tap revoke on each. Flo made privacy an
animated onboarding moment; we can make it a permanent, checkable surface.

**Why it wins.** Post-*Dobbs*, privacy is the category's most-discussed attribute and
the least-verifiable one. We are the only ones who could pass an audit of this
screen. Anonymous mode (Flo's version) is a *feature*; a standing account of who
touched your data is a *position*.

---

## D6 · Patterns that mean something

**What we have that they do not.** `lib/patterns` (410 lines) does timing,
co-occurrence and severity with confidence scoring, and publishes the evidence
behind each finding ("together in 4 of 6 cycles").

**Corrected by chapter 10 §6c:** this originally claimed Flo analyses nothing. It
has a symptom-pattern feature and claims its insights are "verified by medical
experts"; its depth is unverified because a one-cycle account did not populate it.
So the differentiator is not *that* we analyse — it is that every finding carries a
confidence score and the evidence it rests on, and that we refuse to grade her
cycle against a population band the way Flo's ABNORMAL / IRREGULAR card does.

**The feature.** Surface it. Right now the pattern engine has a route
(`/patterns`) and no presence anywhere else. Patterns should arrive as home modules
with the confidence attached, feed the visit pack (D3), and drive "this is new for
you" awareness — which is what `cycle.changeAwareness` and `menopause.marker` were
designed for.

**Why it wins.** It is the payoff for logging. Every tracker asks women to log; only
this one tells them something back that they could not have worked out themselves.

**Depends on:** TD-01, TD-06 (a richer vocabulary makes better patterns).

---

## D7 · Condition-aware from the first screen

**What we have that they do not.** Flo asks about PCOS, fibroids, BV, endometriosis,
yeast infections and UTI once, in onboarding, as six branching tags (chapter 02 §3).
We have 19 track-B personas and a conditions library with its own IA (`docs/16`).

**The feature.** A condition, once recorded, changes what the app is for the whole
time you have it: which modules appear, which content is skinned in, which patterns
are watched, which screeners are offered, which red flags are live — and it never
restricts anything (rule 2). A woman with PCOS and hypothyroidism gets a home screen
neither Flo nor any single-condition app can assemble.

**Why it wins.** This is what the 73 personas were *for*. TD-04 is the parity work;
this is the payoff.

---

## D8 · Teen mode that gates the right things

**What we have that they do not.** Track A, six personas, and rule 2's specific
carve-out: teen mode gates ads, social and data — never knowledge. Flo's adolescent
handling is age cohorts inside an adult product with a community and a paywall.

**The feature.** A genuinely separate posture for under-18s: no community, no
advertising by construction, minimal data, parental-visibility controls that are
honest about what they do and do not show, and the *full* content library — including
the parts about sex, contraception and pain that a teenager most needs and is most
often denied.

**Why it wins.** It is a defensible market nobody serves well, it is the right thing
to do, and it is a compliance asset rather than a liability in every jurisdiction in
`docs/13`.

---

## D9 · Loss, and the stages nobody builds for

**What we have that they do not.** The persona set includes miscarriage and loss
awareness (`support.lossAware`), gynae cancer survivorship, hypothalamic amenorrhoea,
menstrual migraine, REDs in teen athletes, coming off contraception. Flo's pregnancy
track has a `PregnancyFinishActivity` and a `BabyBornActivity` and treats the
unhappy path as a state to exit.

**The feature.** The transitions that hurt are designed, not defaulted:
pregnancy that ends, a treatment cycle that fails, a diagnosis that arrives. `offer`
and `transition` in `ExperienceConfig` already never auto-apply — which is exactly
the right mechanic for this — and `tone` already exists in the contract.

**Why it wins.** It is where trackers are most often cruel, and where users tell each
other about the app that was not.

---

## The shortlist

If only three of these ship, they should be **D4** (Arabic content as a product),
**D3** (the visit pack) and **D2** (interrogable confidence). Between them they use
every asset we have that the competition does not, they are all inside product rule
1, and none of them requires a feature the three apps could copy quickly.
