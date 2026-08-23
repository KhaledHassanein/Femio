# 28 — Competitive Teardown & Parity Study (2026-08-23)

This is a measured teardown of three shipped Android apps, set against a measured
inventory of Femio, written to be read by whoever — human or agent — next opens a
Femio screen. It exists because `docs/26` told us our product was thin in ways an
audit of our own repo could not quantify: an audit can say a screen is plain, but
only a competitor's shipped binary can say what "not plain" costs in engineering.

The three apps were chosen because Khaled had already downloaded them, and between
them they bracket the market: the global leader, a competent mid-market single-stage
app, and an ad-monetised bottom-feeder that shows what happens when a period tracker
is built as an advertising surface. Flo is the one that matters.

## The standing rule this study serves

> Femio must be at least as good as the three apps combined, and then carry
> multiple features none of them have.

That is Khaled's rule, set on 2026-08-23, and it is a gate rather than an ambition.
Chapters 06 and 07 turn it into something checkable: a four-way matrix and a ranked
gap register. Chapter 08 covers the "and then" — the features that come out of our
own corpus, which is where we are genuinely ahead on paper and behind in shipped code.

## Chapters

| # | Chapter | What it answers |
|---|---|---|
| 01 | [Method & evidence](01_METHOD_AND_EVIDENCE.md) | How this was produced, where the evidence sits, what we may and may not do with it |
| 02 | [Flo](02_FLO.md) | The leader, torn down: experience engine, onboarding graph, design system, screens, content, monetisation, privacy |
| 03 | [Pregnancy Tracker](03_PREGNANCY_TRACKER.md) | A clean, modern, feature-rich single-stage app with no design investment |
| 04 | [GO Flo](04_GO_FLO.md) | The cautionary case, and the one thing it does better than anyone |
| 05 | [Femio, measured](05_FEMIO_CURRENT_STATE.md) | What we actually have in the repo, counted — not what the docs claim |
| 06 | [Comparison matrices](06_COMPARISON_MATRICES.md) | Four-way, by feature, IA, design system, data model, dashboards, i18n, monetisation, privacy |
| 07 | [Gap register](07_GAP_REGISTER.md) | Every parity gap, ranked, with the evidence line that proves it |
| 08 | [Differentiation](08_DIFFERENTIATION.md) | The layer beyond parity, sourced from our 73 personas and the adaptation model |
| 09 | [Build plan](09_BUILD_PLAN.md) | Sequenced work for web and Flutter, mapped to the gap register |
| 10 | [Flo, running](10_FLO_RUNNING.md) | The app on an emulator — 72 screens, the live-vs-binary divergence, the real paywall, and the owner directions that amend 07 and 08 |

## Owner directions recorded during this study (2026-08-23)

Four, all given while walking Flo on the emulator, all binding on the chapters they
touch. Chapter 10 carries the detail.

**Register.** Femio is professional and conservative. No "sex" or "anal sex" logging
categories; where the fact matters clinically it is an *intercourse* or *conception*
day, worded conservatively in all four languages. We are not a sexual-education or
sexual-wellness platform. Clinical symptoms — dyspareunia, dryness, bleeding after
intercourse, libido change as a perimenopause or medication marker — stay, under
their clinical names. Education of that kind lives in articles and short tips only.
Amends **TD-06**.

**Onboarding.** Flo's is "extensive, soliciting and boring rather than practical and
comfortable" — a pain point to kill. Good-looking, detailed, joyful, simple. No
overselling. Behave ethically. Amends **TD-09**.

**Monetisation.** Freemium — a genuinely useful free tier that shows what Femio can
do, then monetise the depth. The specific model is a later conversation.

**The Learn section.** Flo's Insights tab is the structural model for our content
surface — search, question-shaped topic chips, "most popular", category rows, bold
illustrated cards — with their subject matter excluded and our citations, clinician
names and four languages added.

## How to use this when revamping a screen

Read `02_FLO.md` for the mechanism, `06` for where we stand on that specific
surface, and `07` for the gap line that names the work. Do not read this study as
a specification to copy — it is a description of someone else's product. The
specification is `08` and `09`, which are ours.

## Status and queue

Per Khaled's direction on 2026-08-23 this study is **reference-only**: the gap
register in chapter 07 does not write lines into `07_MASTER_TODO.md`. Converting
approved gaps into queue items and a phase document is a separate, later pass.
Nothing here supersedes `03_COMPETITOR_ANALYSIS.md`, which remains the Phase-0
desk research; this is the binary-level companion to it.
