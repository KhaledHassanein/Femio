# 25 — Design direction brief (workstream R1)

**Status:** open workstream, started 2026-08-09. This is the brief for the gap the owner named
himself: *"the design is from first look AI generated and user experience sucks."* He is right,
and `docs/23` §3.3 explains why — **no one has ever designed a Femio screen.** They have been
assembled from primitives, one ADR at a time, with no reference to approve against.

This document is the corrective. It defines what gets designed, what "good" means, and the one
process rule that prevents the drift recurring.

---

## 1. The process rule

> **A screen is designed and approved before it is implemented.**

Not a wireframe, not a prose description in an ADR — a rendered reference, at 390×844, in light
and dark, in English and Arabic RTL, that Khaled looks at and approves. Implementation then
matches the reference. When a reference and the code disagree, the reference is the bug report.

This is the one rule that would have prevented the current state, and it costs one extra step
per screen.

**Where references live:** `assets/mockups/` on the real tokens
(`assets/brand/tokens/femio.tokens.css`), so a reference cannot specify a colour, radius or
spacing that the product cannot build. The existing `femio_personalized_screens.html` from Phase
0.5 is the precedent and the starting point — it is a year of decisions out of date and gets
replaced, not extended.

Figma (P0.20c) stays deferred. It buys handoff fidelity for a team; there is no team. HTML on
the real tokens buys the same fidelity and is directly comparable to the running app.

---

## 2. Step 1 — an honest competitor teardown

`docs/03_COMPETITOR_ANALYSIS.md` compares features. It says nothing about **craft**, which is
what the owner's verdict is about. This step fills that gap and must be done first, because
"make it look better" is not a brief.

**Method.** Install the apps on a phone, use them as a user for a week of logging, and capture
screens. Not marketing pages — the actual daily surfaces.

**Who, and what to look for:**

| App | The specific question |
|---|---|
| **Flo** | How does the home screen answer "what do I need to know today?" in under two seconds, and what does it use besides text to do it? |
| **Clue** | How does a science-first product stay warm? Their restraint is closest to Femio's honest-uncertainty posture. |
| **Stardust** | Why does a shallow product feel premium? This is pure visual craft and Femio has none of it. |
| **Ovia** | Lifecycle continuity — how does the UI *change* between fertility, pregnancy and parenting? This is Femio's core claim and Ovia is the only one attempting it. |
| **Balance** | The menopause surface, in a category that is Femio's fastest-growing opening. |

**Deliverable:** a teardown section appended to `docs/03`, organised by *what Femio must match*
and *what Femio must beat*, each claim carrying a screenshot. Explicitly answer: what do they do
with illustration, motion, data visualisation, empty states, and first-run — the five things
Femio currently has nothing of.

---

## 3. Step 2 — the screen set to design

Six references, in this order. Each is designed, approved, then built.

1. **Public homepage.** The first impression, and today it is a hero sentence over five
   identical link cards — a sitemap with a headline. It must show the product, say who it is
   for, and give a reason to trust it before it lists sections. This is also the SEO landing
   page, so it carries a real constraint: it must stay fast and server-rendered.
2. **Onboarding / the welcome wizard.** The moment Femio's whole promise is made. Today it is
   a life-stage question, a condition multi-select, consent and a confirm. It should feel like
   being *asked about*, not *filled in*.
3. **The cycle dashboard.** The daily screen for the largest group.
4. **The pregnancy dashboard.** The stage with the highest engagement in the category, and the
   one R2 uses to prove the experience engine — so it is designed with **modules**, not as one
   fixed layout (see §5).
5. **The menopause dashboard.** The category opening, and the hardest tone problem: it reports
   a count and refuses a conclusion, which must read as respect rather than as evasion.
6. **Track / log.** The most-repeated interaction in the product. Every second it costs is paid
   daily.

Not in this set, deliberately: settings, admin, the content pages. They inherit the language the
six establish.

---

## 4. What "good" means here — the acceptance criteria

A reference is not approved until all of these hold. They are testable, which is the point.

**Judged on a phone.** 390×844 first, always. Desktop is a widened phone, not a separate design.
Mobile is the destination (`docs/24`).

**Both themes, both directions.** Light and dark, English and Arabic RTL, in the same review.
Arabic is a first-class market, not a locale toggle — a layout that only works in LTR is not
finished.

**One answer per screen.** Each screen leads with the single thing she opened the app for, in
the largest thing on it. Everything else is subordinate. The current failure mode is cards of
equal visual weight, which makes the reader do the ranking.

**Something other than text carries meaning.** Femio's entire data visualisation today is a 2px
band. A cycle, a pregnancy and a menopause transition are all fundamentally *shapes over time*
and none of them is drawn. This is the largest single craft gap.

**Empty and first-run states are designed, not defaulted.** A new user sees the app at its
emptiest, and that is currently when it looks least finished.

**Motion has an identity.** Tokens exist (`duration-fast|base|slow`, `ease-standard|spring`) and
are barely used. Reduced motion is enforced globally, so this is safe to invest in.

**It survives the guards.** WCAG 2.2 AA including 44px targets and visible focus; both-theme
contrast; no colour-only encoding; `tokens-parity-lint` clean. These are not a design tax — the
axe run has already caught two real contrast failures that a human review missed.

**It sounds like Femio.** Honest about uncertainty, warm without being saccharine, never
diagnostic, and never celebratory where `emotionalContext` carries `prior_loss`. Tone is a
design surface, and the persona specs write it per persona.

---

## 5. The constraint that makes this durable

**Design in modules, not in screens.**

R2 (`docs/24`) turns the dashboard into an ordered list of modules chosen by the experience
engine — `ExperienceConfig.home.modules`. A pixel-perfect pregnancy dashboard designed as one
fixed composition would be undone by the first persona that reorders it.

So each reference is delivered as: **a module inventory** (hero, quick-log row, panels, strips,
alert blocks), each drawn on its own with its states, **plus** two or three assembled examples
showing them in different orders and emphases — for instance D1 versus D7, which differ by a
thyroid strip and nothing else.

That is also the honest test of the engine's design: if a module cannot be drawn independently
and dropped into a different position, the module boundary is wrong, and it is much cheaper to
learn that in a reference than in React.

---

## 6. Sequence and tracking

Tracked as R1 in `07_MASTER_TODO.md`. Expect several sessions; the teardown alone is one.

1. R1.1 Competitor teardown → appended to `docs/03`.
2. R1.2 Visual language: type scale in use, elevation, illustration direction, data-visualisation
   language, motion identity — decided once, on the existing tokens, and recorded here.
3. R1.3–R1.8 The six references, designed and approved one at a time.
4. R1.9+ Implementation, in the same order, each matching its approved reference.

**The homepage does not wait for the rest.** It is the first thing a stranger sees, it is
independent of the experience engine, and it is currently the weakest artefact in the project.
It ships as soon as R1.1 and R1.2 are done.
