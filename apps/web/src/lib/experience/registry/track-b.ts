/**
 * Track B — cycle and gynae (R2.8, ADR-061).
 *
 * Encoded from `docs/personas/B1_general_cycle_tracker.md`, `B5_irregular_absent_cycles.md`
 * and `B6_pcos_not_ttc.md`, and drawn first as
 * `assets/mockups/R1.5_cycle_dashboard_reference.html` — the module lists here and
 * the module lists there are the same lists, and `docs/25` §1 says that when they
 * disagree the reference is the bug report.
 *
 * ## Why this track matters more than its size suggests
 *
 * B1 is **the hub**. Its own spec calls it "the neutral hub… the default
 * reproductive-age state every other B/C/D/F state branches from and returns to",
 * and it is the largest audience in the product. Until this file existed the cycle
 * dashboard was `mode === "cycle"` in a screen, which is the pattern `docs/24`
 * exists to remove and the one every screen written before R2 gets rewritten for.
 *
 * ## The one rule that decides the whole file
 *
 * B1 §A is written *against* something specific: the pregnancy-funnel default.
 * *"Not TTC. Not pregnant. Not sick. She is the majority-case user that period apps
 * under-serve because they optimize the funnel toward fertility/pregnancy
 * monetization."* So this track contributes **no fertile-window module, no ovulation
 * module and no TTC framing at all** — not hidden, simply not contributed, with
 * every one of them reachable from `explore` and the library. Product rule 2 is
 * emphasis, and this is what emphasis looks like when the honest default is *less*.
 *
 * ## Two heroes, and the difference between them is a safety decision
 *
 * B1 contributes `cycle.window`: a predicted range with its confidence attached.
 * B5 and B6 contribute `cycle.variability` instead — her own cycle lengths, and,
 * when they cannot support a window, the sentence saying so.
 *
 * These are **two module ids rather than one module with a `predict: false`
 * param**, and that is deliberate for the reason `track-a.ts` gives about
 * `teen.worthMentioning`: a param is a value, and a value is one refactor away from
 * being computed wrongly. Whether Femio is willing to predict at all is the kind of
 * decision `docs/24` §5 puts in tier 1, so it is expressed as *which module the
 * record contributes* — the same shape as A1 contributing no window at all.
 */

import type { PersonaRecord } from "../types.ts";

/**
 * B1 — the general cycle tracker, and the spine of the track.
 *
 * §I's home configuration, in its order: *"Hero = cycle status + uncertainty-honest
 * next-period estimate (phase, day, range — not a single date, no 'late' counter).
 * Pinned: fast period-log button; cycle-phase insight card."*
 */
const B1: PersonaRecord = {
  id: "B1",
  track: "B",
  home: {
    /**
     * `default`, not a phase bucket. `Phase` is Track D's vocabulary — gestational
     * age computes it — and a cycle has no equivalent. Filing these under `t1` to
     * make a lookup succeed would work and would be a lie (`types.ts`).
     */
    default: [
      { id: "cycle.window", emphasis: "hero" },
      { id: "cycle.phase", emphasis: "primary" },
      /**
       * Her own bleed history as a strip — the "shape over time" `docs/25` §5a asks
       * for and the app has never drawn. It makes no claim: taller and darker marks
       * are the days she recorded as heavier, and nothing is scored.
       */
      { id: "cycle.flowStrip", emphasis: "primary" },
      { id: "quickLog", emphasis: "primary" },
      /**
       * Her range against the typical range, and **nothing grades the difference** —
       * no in/out marker, no colour change, no tick. Same rule as the lab reference
       * range in R1.6 and the MRS's missing severity word in P2.4: the context is
       * shown because ACOG's vital-sign framing is the education, and reading her
       * position in it is a clinician's job.
       */
      { id: "cycle.personalNormal", emphasis: "secondary" },
      { id: "library", emphasis: "secondary" },
      /**
       * Hidden-but-reachable, given a surface. Every B spec repeats the principle in
       * its §I and today it is true of the router and invisible on the screen — a
       * product rule with no UI is a claim rather than a property.
       */
      { id: "explore", emphasis: "secondary" },
    ],
  },
  // §G's logs, minus the ones that are P2 depth. `labs` is entry-only in the spec
  // and unbuilt; leaving it out surfaces less and forbids nothing.
  tools: ["period", "symptom", "mood"],
  content: {
    skin: "cycle",
    /**
     * §F's modules, in §F's order, as topics rather than slugs (`reading.ts`).
     * Four of these have published articles today, so this is the first track whose
     * reading card fills from the existing library rather than waiting on a batch.
     */
    foreground: [
      "menstrual-cycle-basics",
      "how-to-track",
      "whats-normal-whats-worth-checking",
      "pms-and-the-week-before",
      "prediction-honestly",
      "your-data-your-rules",
    ],
  },
  alerts: [
    /**
     * §G: *"Period-due heads-up (range-framed…) — never 'you are N days late.'"*
     * A cadence, so the notification layer (P2.8) reads a schedule rather than a
     * countdown, and there is no alert id anywhere in this file that could render
     * one.
     */
    { id: "cycle.periodDue", kind: "cadence" },
    /**
     * §G's change-awareness prompt, as **education**. §D is explicit that a pattern
     * change *"raises content and visit-prep prominence, not a red banner"* — so the
     * kind is the safety decision here exactly as it is in `track-a.ts`, and Track B
     * contributes no `redFlag` alert at all. That is the deliberate opposite of
     * Track D, where late is the harmful direction and the warning panel sits high.
     */
    { id: "cycle.changeAwareness", kind: "education" },
    /**
     * §D and §G's missed-period awareness: *"No period for 3+ months when not
     * pregnant (educational threshold for a check-in, not a verdict)."* The number
     * lives here — in tier 1, sourced to the spec's own clinical section — rather
     * than in a screen, which is the rule `native-readiness-lint` now enforces.
     */
    { id: "cycle.longGap", kind: "education", params: { afterDays: 90 } },
  ],
  emrView: ["cycleLengthRange", "periodLength", "cycleVariability", "lastBleed"],
  tone: {
    // §A: competence and calm — "never dramatic, never nagging".
    register: "neutral",
    // There is nothing here to celebrate on a schedule, and a cycle app that
    // congratulates you on a period is the tone §A is written against.
    celebrationByDefault: false,
    // Product rule 3, and §K states it twice: never a certain date, never a "late"
    // counter for a non-TTC user.
    countdown: false,
    readingLevel: "standard",
  },
};

/**
 * B5 — irregular or absent cycles, **cause undetermined**.
 *
 * That last phrase is the persona, not a caveat. §I: *"Do you already have a
 * diagnosis or a known reason? → No / not sure ⇒ cause = undetermined ⇒ resolves to
 * B5"*, and a "yes" routes to B6 or B17 instead. Which is why the resolver gained a
 * `conditions.length === 0` signal with this record: without it B5 and B6 both
 * scored 1.0 for a woman with PCOS and irregular cycles, B5 won on rule order, and
 * **B6 was unreachable** — the fifth appearance of the trap named in
 * `track-e.ts`/E1.
 *
 * It does **not** extend B1, and that is the point of the record. B1's hero is a
 * prediction; hers is her own pattern, and inheriting a window she cannot have
 * would reintroduce the invented-window defect at a third life stage (ADR-041,
 * ADR-042, R2.5).
 */
const B5: PersonaRecord = {
  id: "B5",
  track: "B",
  home: {
    default: [
      /**
       * §I: *"Hero = cycle-length range + pattern view with an uncertainty-first
       * next-window estimate (band, not date). No 'late' counter. When
       * unpredictable: honest 'can't predict this one' state."*
       *
       * The honest absence takes the hero at full size rather than being demoted to
       * a note under a card. R1.5 argues why: for a woman with 90-day gaps, "we are
       * not going to guess this one" *is* the answer she came for, and putting it in
       * grey small print teaches that uncertainty is a failure state.
       */
      { id: "cycle.variability", emphasis: "hero" },
      { id: "cycle.changeAwareness", emphasis: "primary" },
      { id: "visitPrep", emphasis: "primary" },
      { id: "quickLog", emphasis: "primary" },
      { id: "cycle.flowStrip", emphasis: "secondary" },
      { id: "library", emphasis: "secondary" },
      { id: "explore", emphasis: "secondary" },
    ],
  },
  tools: ["period", "symptom", "mood"],
  content: {
    skin: "irregular-cycles",
    /**
     * §I's "causes-differential explorer" is content, not a component: it is the
     * reading list, ordered so the possibilities she is likely to be searching for
     * are reachable. What it must never do is *name one as hers* — §I is explicit
     * that a signal cluster produces an **offer** ("want education tailored to
     * that?"), never a verdict, and below threshold it blends and commits to
     * nothing.
     */
    foreground: [
      "irregular-cycles-explained",
      "menstrual-cycle-basics",
      "whats-normal-whats-worth-checking",
      "when-a-gap-is-worth-checking",
      "prediction-honestly",
    ],
  },
  alerts: [
    { id: "cycle.changeAwareness", kind: "education" },
    // §I: repeated 90+ day gaps raise the awareness prompt and visit-prep
    // prominence. Same id and same threshold as B1 — merged by id rather than
    // double-counted (`docs/09` §8 rule 1) — because the number does not change
    // with the persona.
    { id: "cycle.longGap", kind: "education", params: { afterDays: 90 } },
  ],
  emrView: ["cycleLengthRange", "cycleVariability", "longestGap", "lastBleed"],
  tone: {
    register: "neutral",
    celebrationByDefault: false,
    countdown: false,
    readingLevel: "standard",
  },
};

/**
 * B6 — PCOS, not trying to conceive.
 *
 * Layers on B5 rather than on B1, because her cycle experience is B5's: §I asks for
 * the same range-and-pattern hero with the same uncertainty-honest framing. What B6
 * *adds* is the library she needs and the record fields a clinician asks about.
 *
 * **It adds no screener and no assessment.** §I tunes "content depth and screener
 * prominence" by whether she is diagnosed, suspected or exploring; Femio holds what
 * she told us and points at the assessment article, and the resolver gates this
 * persona on the `pcos` code **she selected** — never on a symptom pattern, which
 * would be Femio inferring the diagnosis it is not allowed to make (product rule 1,
 * and the same reasoning that gates E3 on her statement rather than on an EPDS
 * total, ADR-065).
 */
const B6: PersonaRecord = {
  id: "B6",
  track: "B",
  extends: "B5",
  home: {
    default: [
      // Nothing new structurally, and that is the honest answer: §I's home is B5's
      // home with different cards behind it. Visit-prep is raised because §I pins
      // it, and `mergeModules` upgrades emphasis rather than duplicating the module.
      { id: "visitPrep", emphasis: "primary" },
    ],
  },
  tools: ["period", "symptom", "mood"],
  content: {
    skin: "pcos",
    // Every one of these has a published article, so B6's reading card fills
    // completely from the existing library on the day this record ships.
    foreground: [
      "pcos-explained",
      "pcos-signs",
      "how-pcos-is-assessed",
      "menstrual-cycle-basics",
      "whats-normal-whats-worth-checking",
    ],
  },
  alerts: [
    /**
     * §I: repeated 90+ day amenorrhea raises endometrial-awareness content and
     * visit-prep prompts, *educational*. Kept as its own id rather than folded into
     * `cycle.longGap` so the copy can differ — the reason to mention a long gap to a
     * clinician is not the same conversation for her — while the threshold stays one
     * definition on the inherited alert.
     */
    { id: "pcos.education", kind: "education" },
  ],
  emrView: ["pcosStatus"],
  tone: {
    register: "neutral",
    celebrationByDefault: false,
    countdown: false,
    readingLevel: "standard",
  },
};

/**
 * B2, B3, B4 and B7–B19 are **not here, and the reason is the signal rather than
 * the record**.
 *
 * `resolver.ts` has no rule for any of them: B2 needs a prospective two-cycle mood
 * record, B3 a pain severity scale, B4 a bleeding quantifier (PBAC, queued in
 * P2.7), and B7–B9 a diagnosis code nothing currently writes. Adding a
 * `PersonaRecord` a resolver can never return would be a row that looks like
 * coverage and produces nothing — the write-only shape `docs/23` §3.1 opened this
 * workstream with.
 *
 * They are drawn in `assets/mockups/R1.5_cycle_dashboard_reference.html` anyway,
 * because the reference's job was to test whether the module boundaries survive a
 * *different hero* — B2's is a control and B4's is a count — and that question is
 * answered before the signal exists.
 */
export const TRACK_B_RECORDS: readonly PersonaRecord[] = [B1, B5, B6];
