/**
 * Track A — puberty and adolescence (R2.5c, ADR-061).
 *
 * Encoded from `docs/personas/A1_premenarche_puberty.md` and
 * `A2_teen_newly_menstruating.md`. Track A was the **last track with no mode**: the
 * resolver has been able to answer A2 since ADR-057, and nothing could render it,
 * so a 13-year-old fell through to `general` — an adult cycle screen with adult
 * framing, which is the audience these two specs are most explicit about not being.
 *
 * ## The one line that governs this whole file
 *
 * A2 §A: *"Teen mode changes **data handling, ads, and social exposure**, not
 * **knowledge access**."* That is product rule 2 in its sharpest form, and it is
 * why there is nothing in these records that hides anything. The protection half
 * already exists and lives at the **write path** (`lib/persona/minor.ts`, R2.5b):
 * under-18 and unknown are treated as a minor, and `analytics` and `research`
 * consent cannot be written even if a UI offered them. Nothing here needs to — or
 * is able to — take anything away.
 *
 * ## Why A1 and A2 differ on exactly one thing
 *
 * A1 has not started menstruating. A1 §I: *"**No cycle predictions** shown (she
 * isn't cycling) — deliberately hidden until A2."* So A1 contributes no
 * `teen.window`, and that absence is the whole clinical difference between the two
 * records. Predicting a first period from no data would be the worst version of the
 * "invented window" defect that ADR-041/042 and R2.5 each fixed at a different life
 * stage — worse, because it would be aimed at a child anxious about exactly that.
 *
 * A2 gets a window, and it is a **wide** one with its reason said out loud. A2 §D:
 * irregular cycles are expected for the first ~1–3 years because early cycles are
 * often anovulatory. A2 §B records the failure mode in her own voice — *"It said my
 * period would come Tuesday and it didn't — is the app broken, or am I broken?"* —
 * so the reason travels with the range rather than being available on a help page.
 *
 * ## Track A has no phase, and does not pretend to
 *
 * `Phase` is Track D's vocabulary: gestational age computes it. Track A has no
 * equivalent, so both records file their modules under `default` (`../types.ts`).
 * Filing them under `t1` to make a lookup succeed would have worked and been a lie.
 */

import type { PersonaRecord } from "../types.ts";

/**
 * A1 — before the first period.
 *
 * The spine of the track, and the gentler of the two. Reassurance leads because the
 * research in §B says reassurance *is* the clinical-adjacent value here: literacy
 * lowers menstruation-related stress and raises self-efficacy.
 */
const A1: PersonaRecord = {
  id: "A1",
  track: "A",
  home: {
    default: [
      { id: "teen.reassurance", emphasis: "hero", params: { set: "premenarche" } },
      { id: "teen.body", emphasis: "primary" },
      { id: "teen.readiness", emphasis: "primary" },
      // Surfaced, not required. She is not cycling, so logging is offered as
      // "changes I've noticed" rather than as a tracker with a gap in it.
      { id: "quickLog", emphasis: "secondary" },
      { id: "teen.privacy", emphasis: "secondary" },
      { id: "library", emphasis: "secondary" },
    ],
  },
  // No `period` tool: there is nothing to log yet, and offering it would ask a
  // ten-year-old to explain an absence. It returns with A2, and the library keeps
  // every article about it reachable meanwhile.
  tools: ["symptom", "mood"],
  content: {
    skin: "puberty",
    foreground: ["whats-changing", "what-is-a-period", "first-period-plan", "myth-busting"],
  },
  alerts: [
    /**
     * A1 §D's "let's ask a doctor together" thresholds — early signs before 8, no
     * signs by 13. Carried as an education alert, never a warning: the spec is
     * emphatic that this must be *"reassurance-first, never alarming, never
     * diagnostic"*, and the same copy shouted at a child is a different product.
     */
    { id: "teen.growingUp", kind: "education" },
  ],
  emrView: ["ageBand", "changesNoticed"],
  tone: {
    register: "warm",
    // Nothing to celebrate on a schedule. A1 §I asks for warm and reassuring, and
    // a milestone cadence aimed at a child's body would be the app deciding when
    // she should be excited about it.
    celebrationByDefault: false,
    countdown: false,
    readingLevel: "gentle",
  },
};

/**
 * A2 — newly menstruating, roughly 12–15.
 *
 * Layers on A1 rather than replacing it: the puberty content still applies, and
 * §J's transition into A2 is a first period logged, not a different person. What is
 * *added* is the window and period logging.
 */
const A2: PersonaRecord = {
  id: "A2",
  track: "A",
  extends: "A1",
  home: {
    default: [
      /**
       * The window takes the hero, and reassurance sits directly beneath it.
       *
       * A2 §I orders it the other way — reassurance card, then predictor. The
       * inversion is deliberate and worth arguing with: she opens the app to find
       * out when it is coming, and a reassurance card between her and the answer is
       * the flatness `docs/25` §5a rejects. The reassurance is not lost, it is
       * *inside* the window — a range with "cycles jump around at first, which is
       * why this is a range" under it says both things at once and buries neither.
       */
      { id: "teen.window", emphasis: "hero" },
      { id: "teen.reassurance", emphasis: "primary", params: { set: "newlyMenstruating" } },
      /**
       * A module *and* an alert, the way D1 carries both `pregnancy.warningSigns`
       * and the `pregnancy.redFlags` alert: the module is the panel on her home,
       * the alert is the record notifications will read (P2.8). Deliberately **not**
       * the `pregnancy.warningSigns` module Track E reuses — that renders the danger
       * surface, and the entire design of this one is that it is not a danger
       * surface. Reusing the id would have made the safety decision a `params`
       * value.
       */
      { id: "teen.worthMentioning", emphasis: "primary" },
      { id: "quickLog", emphasis: "primary" },
      { id: "teen.body", emphasis: "secondary" },
      { id: "teen.privacy", emphasis: "secondary" },
      { id: "library", emphasis: "secondary" },
    ],
  },
  tools: ["period", "symptom", "mood"],
  content: {
    skin: "teen-cycle",
    foreground: [
      "youre-normal",
      "menstrual-cycle-basics",
      "using-period-products",
      "school-day",
      "tracking-without-stress",
    ],
  },
  alerts: [
    /**
     * A2 §D's screening thresholds, as **education**, never as a red flag: gaps
     * beyond ~90 days, soaking through more often than every 1–2 hours, pain that
     * misses school. §G is explicit — *"no alarms, no diagnosis, no 'you might have
     * X'"* — and §D adds the caution that matters most here: **never suggest PCOS
     * to a newly menstruating teen from irregularity alone**, because irregularity
     * is developmentally expected for 1–3 years. A `redFlag` alert kind would render
     * as the danger panel pregnancy uses, so the kind is the safety decision.
     */
    { id: "teen.worthMentioning", kind: "education" },
  ],
  emrView: ["ageBand", "menarche", "cycleRegularity", "longestGap"],
  tone: {
    register: "warm",
    celebrationByDefault: false,
    countdown: false,
    // Plain and grown-up, not simplified: A2 §B is explicit that she wants straight
    // answers and reads being talked down to as being locked out.
    readingLevel: "standard",
  },
};

export const TRACK_A_RECORDS: readonly PersonaRecord[] = [A1, A2];
