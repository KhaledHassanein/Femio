# 29.05 — Design system

Current state: 144 tokens in one CSS file, a Tailwind preset, and a W3C JSON export.
Two things in it beat Flo outright — a dedicated Arabic typeface token (`font-ar`) and
cycle-phase tokens. Several families they have, we do not.

Flo's system is nine typed token files across phone, Compose and Wear, on **stock
Roboto**. Their identity is carried entirely by colour, illustration and motion. That
is the most useful single fact in this chapter: **type is not where the money goes.**

---

## 1. Scale decisions, made now

Flo is visibly mid-migration from a multiplier scale (`spacing1x … spacing40x`) to a
numeric one (`spacing050 … spacing4000`), carrying both in the same binary. They are
paying to move off the multiplier scale.

**Adopt the numeric scale now.** `--space-050` through `--space-4000`, the same for
radius and border. If our current `space-*` naming is multiplier-shaped, rename it in
one pass while the surface is small — it is a cheaper migration today than it will
ever be again.

Add a **border scale**, which we lack entirely: `--border-0`, `--border-050`,
`--border-100`, `--border-200`, `--border-300`.

Extend radius with **`--radius-full`**, because pill shapes recur across chips,
buttons and the calendar and a magic `9999px` will otherwise appear in twelve files.

---

## 2. The colour families to add

Ours has colour ramps, semantic surface/text/accent/border/state, five phase tokens,
gradients, shadows. Flo's has five families we lack, and each solves a real problem.

**Per-log-category colour, with an alternate.** Flo assigns a colour to every tracked
category and gives each one an `...Alternate` for a different surface. Ours, aligned
to chapter 02's dimensions:

```
--log-period, --log-symptom, --log-mood, --log-discharge,
--log-intercourse, --log-vital, --log-medication, --log-appointment
+ --log-*-alt for each
```

This is what stops a symptom looking one way on the calendar, another on the panel
and a third in a chart. It is the single highest-value addition here.

**Interaction states as tokens.** `--button-*-hover`, `--button-*-pressed`. Today
these are opacity guesses at call sites, which is why press feedback varies.

**A named focus ring.** `--border-focus`. Flo has `borderFocus`; we have nothing, and
a keyboard user on the web app currently gets the browser default over our own
colours. This is an accessibility defect, not a polish item.

**Chart tokens.** `--chart-1` … `--chart-6` for categorical series, plus
`--chart-inactive`, `--chart-grid`, `--chart-axis`, `--chart-annotation`. Chapter
06's charts cannot be token-driven without them, and Flo keeps chart colours in its
design system for exactly this reason.

**Illustration skin tones.** `--skin-1` … `--skin-5`. Flo tokenises five.
`docs/12` has talked about inclusive illustration and never made it a token, so
every illustration commissioned so far has made its own decision.

**Confidence tokens.** Ours alone, and needed by D2 and OD-15:
`--confidence-high`, `--confidence-medium`, `--confidence-low`. The two-tier
probability calendar and every prediction affordance read from these, so "likely" and
"may" look the same everywhere they appear.

---

## 3. Motion — TD-02, from zero

The repository contains **no animation assets**. Flo ships ~50 Lottie files, ten of
which exist only to make *logging* feel like something happened.

**The vocabulary.** Four `--ease-*` tokens exist; add durations —
`--motion-instant` (100ms), `--motion-quick` (200ms), `--motion-standard` (320ms),
`--motion-deliberate` (500ms) — and pair each with an easing so a component chooses
one token, not two.

**Where motion is required**, in priority order:

1. **Logging confirmation.** Every primary log action gets a considered response.
   This is where Flo spent most and it is why logging feels good there.
2. **Prediction change.** When a window shifts, it animates rather than swapping —
   Flo has `anim_cycle_day_prediction_update` for precisely this, and a silent swap
   reads as a glitch.
3. **Phase transition.** The dashboard's ground colour crossfades when she moves
   between phases (chapter 06 §1).
4. **Empty, loading and error states.** Designed, not default.

**What we do not do:** streak animations or gamified reward loops. Flo has
`streak_bolt` and `streak_unfreeze`; our changelog is already explicit that Femio
never sends streaks and never counts the days she did not log. Motion may celebrate
an action; it may never score her.

**Format.** Lottie for illustrative motion, CSS/Compose transitions for state.
Rive only if a case appears that Lottie cannot serve — Flo fetches Rive at runtime
and we have no such need.

**Performance.** Flo authors two versions of animated onboarding beats and routes by
device capability. Our equivalent is simpler and already half-built: respect
`prefers-reduced-motion` everywhere, and let `feature_flags` disable the heavy layer
for low-end devices.

---

## 4. The chart foundation — TD-01

The largest gap and, after the teardown, the clearest opportunity: **nobody in the
category has a data-visualisation layer.** Flo's cycle history is a legend and a row
of dots; its Insights tab has no chart at all.

**Build, don't adopt.** No charting library. Flo draws its own; the pregnancy tracker
uses Compose canvas. A library brings a theme we would spend longer overriding than
writing, and it will not respect our tokens, our RTL rules or our confidence
semantics.

**The primitives**, each implemented twice (web and Dart) against shared golden
fixtures, per the tier-2 rule:

| Primitive | Used by |
|---|---|
| `DotStrip` | Cycle history, flow strip — Flo's one good idea, and it works at any width |
| `RangeBand` | Fertile window, prediction window with soft edges |
| `TimeSeries` | BBT, weight, glucose, mood trend |
| `Histogram` | Cycle-length distribution, symptom frequency by cycle day |
| `RingProgress` | Cycle position, screener score bands |
| `Sparkline` | Inline, inside home modules |
| `ConfidenceBand` | **Ours alone** — a prediction rendered with its uncertainty visible |

**Rules every chart obeys.**

- **Colours from `--chart-*`.** No literals.
- **RTL-aware.** Time runs right-to-left in Arabic. An axis that does not flip is a
  bug, and it is the kind that ships because nobody tested it.
- **Accessible by construction.** Every chart has a text alternative generated from
  the same data — not an aria-label bolted on. A chart is a `figure` with a
  `figcaption` a screen reader can actually use.
- **Honest at low n.** Below the threshold that supports a claim, the chart says so
  instead of drawing a confident line through two points. This is the discipline Flo
  fails when it prints ABNORMAL beside an empty bar.
- **No verdicts.** Bands are described, never graded. Nothing is labelled normal or
  abnormal (chapter 01 §6).

**Tier boundary.** Bands, thresholds and confidence are computed in tier 1 and
delivered in module params. The chart primitives receive numbers and draw them. No
renderer decides what counts as a band — that is the medical-logic line and it is the
same line ADR-061 draws.

---

## 5. Dark mode and RTL

Both exist and both need re-examining once the families above land. Flo authors dark
mode as its own resource set rather than inverting; our tokens should do the same for
the new families rather than deriving them.

RTL: `docs/22`'s logical-property conventions cover layout. Charts, the calendar grid
and the dot strip need explicit direction handling, because they encode *time* in
space and time does not mirror the way a margin does. **A right-to-left month grid
changes which edge is the start of a period run** — which is exactly the detail
OD-15 asks us to get right.

---

## 6. What this does not include

Illustration commissioning, brand photography and the visual direction itself are
`docs/25`'s remaining steps, now unblocked by the teardown. This chapter specifies the
*system* those assets plug into.

One direction from the teardown worth carrying into that work: Flo's identity is
colour, illustration and motion on a system font. If we are choosing where to spend a
limited budget, it is illustration and motion — not typography, and not more tokens
than the families above.
