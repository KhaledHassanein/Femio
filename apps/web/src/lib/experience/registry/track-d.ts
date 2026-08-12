/**
 * Track D — pregnancy. The first persona registry (R2.1, ADR-061).
 *
 * Encoded from each spec's §E/§F/§G/§I in `docs/personas/`. **Data only**: nothing
 * consumes this yet, which is deliberate — R2.2 builds `buildExperienceConfig` on
 * top of it and R2.3 renders the pregnancy dashboard from the result. The
 * acceptance test for the whole engine lives there: *D3 and D4 must visibly differ,
 * and D7 must show a thyroid strip, with no new `if` statement.*
 *
 * ## What reading five specs actually showed
 *
 * The shape the specs describe is not "73 configurations". It is **one spine plus
 * layers**, and every Track-D spec says so in its own words:
 *
 * - **D1 is the spine**, and gestational age computes everything: *"GA computes
 *   everything: the 'This week' card, which trimester hub is featured, which tools
 *   are surfaced."*
 * - **D3, D4 and D7 are clinical layers on that spine.** Each says the D1
 *   experience *"remains completely intact and foregrounded"* and its own tools are
 *   *added*. So they `extends: "D1"` and contribute strips.
 * - **D2 is an emotional layer, not a clinical one.** Its §I: *"D2 is an emotional
 *   layer that stacks on any D-track clinical persona… most-acute-clinical emphasis
 *   wins the hero's clinical strip, but tone stays anxiety-aware and the
 *   loss-suppression net stays armed."* That is `emotionalLayer: true`.
 * - **All five repeat "nothing is locked."** Which is why the contract cannot
 *   express restriction at all (see `../types.ts`).
 *
 * That is the finding that makes the engine tractable: layered records compose, so
 * the remaining personas are additions to a table rather than branches in a screen.
 */

import type { PersonaRecord } from "../types.ts";

/** D1 — uncomplicated pregnancy. The spine every other D persona layers onto. */
const D1: PersonaRecord = {
  id: "D1",
  track: "D",
  home: {
    // Deliberately no `hero` here: the hero is chosen at build time from the phase
    // and the most-acute layer, so a base record asserting one would fight D2.
    t1: [
      { id: "pregnancy.week", emphasis: "hero" },
      { id: "pregnancy.screeningPrep", emphasis: "primary" },
      { id: "pregnancy.appointments", emphasis: "primary" },
      { id: "pregnancy.warningSigns", emphasis: "primary" },
      { id: "quickLog", emphasis: "primary" },
    ],
    t2: [
      { id: "pregnancy.week", emphasis: "hero" },
      { id: "pregnancy.appointments", emphasis: "primary" },
      { id: "pregnancy.weight", emphasis: "primary" },
      { id: "pregnancy.warningSigns", emphasis: "primary" },
      { id: "quickLog", emphasis: "primary" },
    ],
    t3: [
      { id: "pregnancy.week", emphasis: "hero" },
      // "kick counter surfaced (~28 wk)" — surfaced, not unlocked. It is reachable
      // from the tools menu at any gestation with a "usually used later" note.
      { id: "pregnancy.movement", emphasis: "primary", params: { fromWeek: 28 } },
      { id: "pregnancy.contractions", emphasis: "secondary", params: { fromWeek: 36 } },
      { id: "pregnancy.birthPrep", emphasis: "primary" },
      { id: "pregnancy.warningSigns", emphasis: "primary" },
      { id: "quickLog", emphasis: "primary" },
    ],
  },
  tools: ["symptom", "weight", "movement", "contractions", "appointment", "mood"],
  content: {
    skin: "pregnancy",
    foreground: ["week-by-week", "appointments-and-tests", "warning-signs", "nutrition"],
  },
  alerts: [
    { id: "pregnancy.redFlags", kind: "redFlag" },
    { id: "pregnancy.movementPrimer", kind: "milestone", params: { week: 28 } },
  ],
  emrView: ["edd", "gestationalAge", "appointments", "weight"],
  tone: { register: "warm", celebrationByDefault: true, countdown: false, readingLevel: "standard" },
};

/**
 * D2 — pregnancy after loss.
 *
 * The hero is **not** the week card. Its §I is explicit: *"Hero = next milestone,
 * leading with 'however you feel is okay' — not a fruit card or day counter."*
 * Development content is opt-in, and `celebrationByDefault` is false because the
 * spec says celebration and countdown are off unless she turns them on.
 */
const D2: PersonaRecord = {
  id: "D2",
  track: "D",
  extends: "D1",
  emotionalLayer: true,
  home: {
    t1: [
      { id: "pregnancy.milestone", emphasis: "hero" },
      { id: "support.checkIn", emphasis: "primary" },
      { id: "support.reassurance", emphasis: "primary" },
      // Demoted, not removed — she can opt back into development content.
      { id: "pregnancy.week", emphasis: "secondary", params: { optIn: true } },
    ],
    t2: [
      { id: "pregnancy.milestone", emphasis: "hero" },
      { id: "support.checkIn", emphasis: "primary" },
      { id: "pregnancy.week", emphasis: "secondary", params: { optIn: true } },
    ],
    t3: [
      { id: "pregnancy.milestone", emphasis: "hero" },
      { id: "pregnancy.movement", emphasis: "primary", params: { anxietyAware: true } },
      { id: "support.lossAware", emphasis: "primary" },
      { id: "pregnancy.warningSigns", emphasis: "primary" },
    ],
  },
  tools: ["mood"],
  content: {
    skin: "pregnancy-after-loss",
    foreground: ["milestone-at-a-time", "however-you-feel", "scan-literacy"],
  },
  // Loss-suppression is "armed at all times" (§I) — it is a standing rule, not a
  // scheduled nudge, so it carries no cadence.
  alerts: [{ id: "loss.suppression", kind: "education" }],
  emrView: ["priorLossCount", "lastLossGestation"],
  tone: {
    register: "anxietyAware",
    celebrationByDefault: false,
    countdown: false,
    readingLevel: "gentle",
  },
};

/**
 * D3 — gestational diabetes.
 *
 * D3 and D4 are separated by **when diabetes was recorded**, never by scoring luck
 * — `docs/09` §8 rule 3 says conflating them is the error to design against,
 * because one resolves postpartum into a single OGTT and the other is lifelong.
 * The resolver already gates on `diabetesRecordedBeforePregnancy`; the registry
 * keeps them distinct downstream by giving them different postpartum bridges.
 */
const D3: PersonaRecord = {
  id: "D3",
  track: "D",
  extends: "D1",
  home: {
    t2: [
      { id: "strip.glucose", emphasis: "primary" },
      { id: "pregnancy.appointments", emphasis: "primary" },
    ],
    t3: [
      { id: "strip.glucose", emphasis: "primary" },
      { id: "strip.medication", emphasis: "secondary", params: { whenRecorded: "insulin" } },
    ],
    // "GDM tools quiet down; the postpartum-OGTT bridge card appears (→ E4)."
    postpartum: [{ id: "strip.glucose", emphasis: "secondary", params: { bridge: "ogtt" } }],
  },
  tools: ["glucose", "medication"],
  content: {
    skin: "pregnancy-gdm",
    foreground: ["just-diagnosed", "understanding-your-numbers", "carbs", "gdm-delivery"],
  },
  alerts: [
    { id: "gdm.logCadence", kind: "cadence" },
    { id: "gdm.postpartumOgtt", kind: "milestone", params: { weeksAfterBirth: 6 } },
  ],
  emrView: ["glucoseReadings", "gdmDiagnosedAt"],
  // "reassurance + anti-self-blame tone dialed up" (§I).
  tone: { register: "warm", celebrationByDefault: true, countdown: false, readingLevel: "gentle" },
};

/** D4 — pre-existing diabetes. Lifelong, so it starts before and continues after. */
const D4: PersonaRecord = {
  id: "D4",
  track: "D",
  extends: "D1",
  home: {
    // D4 is the only Track-D persona with a preconception phase: "no conception
    // gate, purely supportive" (§I).
    preconception: [
      { id: "strip.glucose", emphasis: "hero" },
      { id: "strip.labs", emphasis: "primary", params: { set: "hba1c" } },
      { id: "strip.medication", emphasis: "primary" },
    ],
    t1: [
      { id: "strip.glucose", emphasis: "primary" },
      { id: "support.reassurance", emphasis: "primary" },
    ],
    t2: [
      { id: "strip.glucose", emphasis: "primary" },
      { id: "strip.labs", emphasis: "secondary", params: { set: "hba1c" } },
      { id: "strip.devices", emphasis: "secondary" },
      { id: "pregnancy.appointments", emphasis: "primary", params: { dense: true } },
    ],
    t3: [
      { id: "strip.glucose", emphasis: "primary" },
      { id: "strip.devices", emphasis: "secondary" },
    ],
    // "Tools stay reachable (diabetes doesn't end)" — the distinction from D3.
    postpartum: [
      { id: "strip.glucose", emphasis: "primary", params: { watch: "hypo" } },
      { id: "strip.medication", emphasis: "primary" },
    ],
  },
  tools: ["glucose", "medication", "labs"],
  content: {
    skin: "pregnancy-diabetes",
    foreground: ["planning-with-diabetes", "tighter-targets", "hypo-safety", "devices-in-labour"],
  },
  alerts: [
    { id: "diabetes.logCadence", kind: "cadence" },
    { id: "diabetes.medicationReview", kind: "education" },
    { id: "diabetes.postpartumHypo", kind: "milestone", params: { daysAfterBirth: 1 } },
  ],
  emrView: ["diabetesType", "glucoseReadings", "hba1c", "devices"],
  tone: { register: "warm", celebrationByDefault: true, countdown: false, readingLevel: "standard" },
};

/**
 * D7 — thyroid in pregnancy. The destination of the C8→D7 flagship (`docs/09` §9).
 *
 * Its §I asks for "the D1 week-by-week hero **plus a thyroid strip**: latest TSH,
 * next-lab reminder, today's medication status" — which is the whole reason this
 * persona exists, and exactly what a layered record expresses.
 */
const D7: PersonaRecord = {
  id: "D7",
  track: "D",
  extends: "D1",
  home: {
    t1: [
      { id: "strip.thyroid", emphasis: "primary" },
      { id: "strip.medication", emphasis: "primary" },
      { id: "support.reassurance", emphasis: "primary", params: { topic: "thyroid-and-baby" } },
    ],
    t2: [
      { id: "strip.thyroid", emphasis: "primary" },
      { id: "strip.labs", emphasis: "secondary", params: { set: "thyroid" } },
    ],
    t3: [
      { id: "strip.thyroid", emphasis: "primary" },
      { id: "strip.medication", emphasis: "secondary" },
    ],
    postpartum: [{ id: "strip.thyroid", emphasis: "secondary", params: { watch: "ppt" } }],
  },
  tools: ["labs", "medication"],
  content: {
    skin: "pregnancy-thyroid",
    foreground: [
      "your-thyroid-and-your-baby",
      "why-my-dose-often-goes-up",
      "how-often-checked",
      "taking-levothyroxine-right",
    ],
  },
  alerts: [
    // The cadence the spec describes is *educational* and the clinician sets the
    // schedule — the alert id carries that, the copy never states a dose.
    { id: "thyroid.labCadence", kind: "cadence", params: { everyWeeks: 4 } },
    { id: "thyroid.medicationReviewOnEntry", kind: "education" },
    { id: "thyroid.postpartumThyroiditisPrimer", kind: "milestone", params: { week: 34 } },
  ],
  emrView: ["tsh", "freeT4", "antibodies", "thyroidMedication", "doseChangeHistory"],
  // "vigilant-reassuring… validate her fear for the baby without feeding it" (§I).
  tone: {
    register: "vigilantReassuring",
    celebrationByDefault: true,
    countdown: false,
    readingLevel: "standard",
  },
};

export const TRACK_D_RECORDS: readonly PersonaRecord[] = [D1, D2, D3, D4, D7];

/** Lookup by id. Kept as a function so the registry stays plain data. */
export function findRecord(id: string): PersonaRecord | undefined {
  return TRACK_D_RECORDS.find((r) => r.id === id);
}
