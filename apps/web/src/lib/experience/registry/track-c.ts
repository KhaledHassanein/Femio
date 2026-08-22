/**
 * Track C — trying to conceive (R2.11).
 *
 * The last track to resolve into nothing. C1, C2, C3, C6 and C8 have had resolver
 * rules since P1.27.4 and **no registry record to compose**, so every woman trying
 * to conceive fell through to the generic document — and `/fertility` (P2.1), which
 * is the whole logging surface for this track, was opened by a `mode === "ttc"`
 * button because no persona could ask for it. R2.10a added the `fertility` kind for
 * exactly this file.
 *
 * ## The line this track cannot cross
 *
 * `lib/fertility` has no `ovulationDay`, no `thermalShift` and no `isFertile`, and a
 * test asserts it never gains one: a thermal shift read from a home thermometer is a
 * clinical inference, and the feature everyone builds on top of one is "days you
 * could avoid" — the medical-device line and the contraception line in a single
 * step. So this registry surfaces **logging and awareness**, and the approved
 * sentence about what those dates are for lives with the copy, never here.
 *
 * ## C2 and C3 change emphasis, never a label
 *
 * Past her evaluation window she gets a work-up roadmap instead of a window. That is
 * a change in what is foregrounded and **not** a statement that she has infertility;
 * C2 §I is explicit, and nothing in this file names a condition she has not reported.
 */

import type { PersonaRecord } from "../types.ts";

/** C1 — the spine: trying, within her own evaluation window. */
const C1: PersonaRecord = {
  id: "C1",
  track: "C",
  home: {
    default: [
      { id: "ttc.window", emphasis: "hero" },
      { id: "ttc.logSummary", emphasis: "primary" },
      { id: "quickLog", emphasis: "primary" },
      /**
       * The cycle modules, because **a woman trying to conceive is still cycling**
       * (R3.4.1).
       *
       * C1's home was a fertile-window hero and three links, and it measured 844px
       * against 1441–3707 everywhere else — the emptiest screen Femio shipped, for
       * the highest-intent segment in the category. The cause was not a missing
       * feature: `cycle.phase`, `cycle.flowStrip` and the rest already existed and
       * Track C simply did not ask for them.
       *
       * That is product rule 2 failing in the direction it warns about. Her stage
       * is supposed to change what *leads*; here it removed surfaces she still has
       * every use for. Where she is in her cycle and what her bleeding looked like
       * are more relevant when trying to conceive, not less.
       *
       * They sit below the fertile window rather than replacing it: the window is
       * still what she opens the app for.
       */
      { id: "cycle.phase", emphasis: "primary" },
      { id: "cycle.flowStrip", emphasis: "secondary" },
      { id: "cycle.personalNormal", emphasis: "secondary" },
      { id: "library", emphasis: "secondary" },
    ],
  },
  // `fertility` is the reason R2.10a existed. `period` stays because the cycle is
  // still the spine of everything this track predicts from.
  tools: ["period", "symptom", "mood", "fertility"],
  content: {
    skin: "ttc",
    foreground: ["ttc-basics", "fertile-window", "preconception-visit", "when-to-seek-help"],
  },
  // No cadence. A daily nudge to someone trying to conceive is the product setting
  // the pace of the most anxious part of her month (`docs/09` invariant 7).
  alerts: [],
  emrView: ["cycleHistory", "fertilityLogs"],
  tone: {
    register: "warm",
    // Nothing to celebrate on a schedule, and no countdown to a test date.
    celebrationByDefault: false,
    countdown: false,
    readingLevel: "standard",
  },
};

/**
 * C2 — past twelve months, under 35. Layers on C1: her cycle tracking has not
 * stopped being useful, and what changes is what leads. The roadmap replaces the
 * window as the hero because a fertile-window card in month fourteen is the app
 * answering a question she stopped asking.
 */
const C2: PersonaRecord = {
  id: "C2",
  track: "C",
  extends: "C1",
  home: {
    default: [{ id: "ttc.workup", emphasis: "hero" }],
  },
  tools: ["period", "symptom", "mood", "fertility"],
  content: {
    skin: "ttc-workup",
    foreground: ["when-to-seek-help", "what-a-workup-involves", "ttc-basics"],
  },
  alerts: [],
  emrView: ["cycleHistory", "fertilityLogs", "monthsTrying"],
  tone: {
    register: "vigilantReassuring",
    celebrationByDefault: false,
    countdown: false,
    readingLevel: "standard",
  },
};

/**
 * C3 — past six months, 35 and over. The same shape as C2 and a separate record
 * because the window is six months rather than twelve (`evaluationWindowMonths`),
 * and because the reading differs: age-specific content that states population
 * figures without turning them into a forecast about her.
 */
const C3: PersonaRecord = {
  id: "C3",
  track: "C",
  extends: "C1",
  home: {
    default: [{ id: "ttc.workup", emphasis: "hero" }],
  },
  tools: ["period", "symptom", "mood", "fertility"],
  content: {
    skin: "ttc-workup",
    foreground: ["when-to-seek-help", "what-a-workup-involves", "age-and-fertility"],
  },
  alerts: [],
  emrView: ["cycleHistory", "fertilityLogs", "monthsTrying"],
  tone: {
    register: "vigilantReassuring",
    celebrationByDefault: false,
    countdown: false,
    readingLevel: "standard",
  },
};

/** C6 — trying with PCOS. A condition layer, exactly as D3 and D7 are. */
const C6: PersonaRecord = {
  id: "C6",
  track: "C",
  extends: "C1",
  home: {
    default: [{ id: "ttc.conditionContext", emphasis: "primary", params: { condition: "pcos" } }],
  },
  tools: ["period", "symptom", "mood", "fertility"],
  content: {
    skin: "ttc-pcos",
    foreground: ["pcos-and-conceiving", "irregular-cycles-and-timing", "ttc-basics"],
  },
  alerts: [],
  emrView: ["cycleHistory", "fertilityLogs", "conditionsCarriedForward"],
  tone: {
    register: "warm",
    celebrationByDefault: false,
    countdown: false,
    readingLevel: "standard",
  },
};

/** C8 — trying with a thyroid condition. The C-track end of the C8 → D7 → E7 arc. */
const C8: PersonaRecord = {
  id: "C8",
  track: "C",
  extends: "C1",
  home: {
    default: [
      { id: "ttc.conditionContext", emphasis: "primary", params: { condition: "thyroid" } },
      { id: "strip.thyroid", emphasis: "primary" },
    ],
  },
  tools: ["period", "symptom", "mood", "fertility", "labs", "medication"],
  content: {
    skin: "ttc-thyroid",
    foreground: ["thyroid-and-conceiving", "preconception-visit", "ttc-basics"],
  },
  // The clinician sets the schedule; the alert carries that and never a dose.
  alerts: [{ id: "thyroid.labCadence", kind: "cadence", params: { everyWeeks: 8 } }],
  emrView: ["cycleHistory", "fertilityLogs", "thyroidLabs", "medications"],
  tone: {
    register: "warm",
    celebrationByDefault: false,
    countdown: false,
    readingLevel: "standard",
  },
};

export const TRACK_C_RECORDS: readonly PersonaRecord[] = [C1, C2, C3, C6, C8];
