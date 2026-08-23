# 29.01 — Principles and constraints

Everything in chapters 02–07 inherits from this page. Nothing here is new; it is
gathered so that a decision downstream can be checked against one list.

## 1. The six product rules (unchanged, `CLAUDE.md`)

1. **Wellness, education and tracking only.** Never diagnose, treat, prevent disease,
   or act as contraception. Screeners say "screening — discuss with your clinician".
2. **Personalise, never restrict.** Emphasis and tone adapt per persona; every
   article and tool stays reachable.
3. **Uncertainty-honest predictions.** Ranges and confidence, never a single certain
   date, never a "late" counter in irregular modes.
4. **Privacy by design.** No ad or analytics SDK touches health data. Explicit
   granular consent, export and delete, EU hosting.
5. **Constant EMR, additive layers.** One record spans life; a state change
   re-layers content over an unchanged core.
6. **Arabic and RTL are first-class.** The wordmark stays English "femio".

The teardown gave rules 1 and 4 concrete illustrations worth keeping: Petal labels a
day **"Safe Period"** (a contraceptive claim on a home screen) and asks a period
tracker's users for their **contacts**. Both belong in `docs/13`.

## 2. The architecture rule (unchanged, ADR-060/061, `docs/24`)

The backend owns decisions; the clients render them. Anything medical — thresholds,
red-flag sets, persona rules, alert cadences, screener scoring — lives in tier 1
(Supabase Edge Function) or tier 2 (twin TS/Dart implementations bound by shared
golden fixtures), never inline in a screen. Personas reach the UI as a versioned
`ExperienceConfig` rendered through a module registry, never as a `mode ===` branch.

**What the teardown adds.** Flo runs native and served implementations of the same
screen side by side behind a flag, migrating one screen at a time. `docs/24` framed
our equivalent as a rewrite with a flag day. It is not: adopt the per-screen
migration, and the flag mechanism becomes a prerequisite rather than a nicety
(chapter 03 §5).

## 3. Owner directions that constrain design

The full set is `docs/28_TEARDOWN/11_FINDINGS_LEDGER.md` §1. These are the ones that
change what gets built:

**Register (OD-5).** Professional and conservative. No "sex" or "anal sex" logging
categories. Where the fact matters clinically it is an **intercourse** or
**conception** day, worded conservatively in all four languages. Femio is not a
sexual-education or sexual-wellness platform; that material lives in articles and
short tips. Clinical symptoms stay under clinical names — dyspareunia, vaginal
dryness, bleeding after intercourse, libido change as a perimenopause or medication
marker.

**Onboarding (OD-6).** Joyful but simple, short, good-looking, no overselling,
ethical. Flo's 57-screen funnel is the anti-pattern.

**Not building (OD-8, OD-9).** No messaging, no chat, in any form. The AI assistant
is post-V1.

**Dashboard (OD-10).** Fewer items than Flo, far more than we have today.
Personalised per persona, with every tool still reachable in its original place.

**Calendar (OD-11, OD-15).** More prominent than Flo's. Every period day marked with
its first and last distinguished; the fertile window as a band; expected ovulation
distinct; the two probability tiers rendered, not collapsed.

**Learn (OD-12).** Flo's Insights tab structurally — search, question-shaped topic
chips, most-popular row, category rows, illustrated cards — with our citations,
clinician names and four languages, and none of their subject matter.

**Monetisation (OD-7).** Freemium. A free tier useful enough to show what Femio does.
Model TBD; nothing in this plan may assume a paywall position.

**Build order (OD-16).** The mobile-first web app first, tested in the browser. iOS
and Android after. Flutter-only items stay Flutter-only but nothing waits on them.

## 4. What we are competing on, precisely

The teardown narrowed this. Corrections C-4 through C-7 removed four things we thought
were ours. What is left is defensible and should be stated the same way everywhere:

| We claimed | What survives |
|---|---|
| Only we cite sources | **Attributed and dated clinical review by a named person**, on every article, in four languages. Flo cites; it names nobody. |
| Only we analyse what is logged | **Every finding carries a confidence score and the evidence behind it**, and we refuse to grade her cycle against a population band. |
| We are uncertainty-honest | **We explain the confidence.** Flo hedges ("likely", "on or around") and cannot say why. |
| We have more charts | **Nobody in the category has a data-visualisation layer.** Flo's cycle history is a row of dots. This is open ground. |

Unopposed outright: **Arabic and RTL**, the **life-spanning record**, **validated
screeners**, and **verifiable privacy**.

Not winnable soon, and not to be chased: **content volume** (Flo claims 1,000+
articles to our 105 authored / 31 live) and **community scale** (which OD-8 removes
anyway).

## 5. The failure this plan exists to prevent

`docs/26` measured a product thinner than its own documentation. The cause was not
laziness; it was ordering. Screens were built against a three-field module contract,
against a persona registry two-thirds unwired, with no chart foundation and no motion
vocabulary — so each screen could only be as good as the layer under it, and that
layer was thin.

**Therefore: no screen work begins before chapter 03's contract lands.** A screen
built on the current `ModuleSpec` is a screen that gets rewritten, and this is the
third document to say so.

## 6. Definition of done (inherited, extended)

From `docs/27`, unchanged: every item is judged on a **390×844 phone viewport, in
light and dark, and in Arabic RTL**, with a screenshot as the test.

Added by this plan:

- Every served module ships with its **accessibility metadata and impression config
  populated** — they are required fields, not optional ones (chapter 03).
- Every prediction shown to a user is **tappable and explains what it rests on**
  (chapter 06 §2).
- Every new user-facing string exists in **four languages** at merge, not later.
- Nothing labels a cycle, a symptom or a day **normal or abnormal**.
