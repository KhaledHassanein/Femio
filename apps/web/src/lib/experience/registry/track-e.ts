/**
 * Track E — postpartum (R2.5, ADR-061).
 *
 * Encoded from `docs/personas/E1_*` and `E6_*`. Track E is the one the audit named
 * twice: `docs/23` §3.1 found it had **no mode at all**, so the resolver could
 * return E1 or E6 and nothing could render it, and §3.2 listed postpartum among the
 * things the product promises and does not have.
 *
 * ## What this is, and what it is not
 *
 * It is **not** P2.3. The recovery tracker, EPDS and feeding logs are real Phase-2
 * features and none of them is built. What this does is make the stage *reachable
 * and honest*: she can say "I recently gave birth", the app stops showing her a
 * next-period prediction built on cycles that have not returned, and the modules
 * she gets are ones that actually exist.
 *
 * A short honest experience beats a rich dishonest one. The alternative shipped for
 * months: postpartum fell through to `general`, which cheerfully predicted a period.
 *
 * ## E6 is the one to get right
 *
 * E6 is pregnancy loss. Its whole design is subtraction — no milestones, no
 * celebration, no counters, nothing that assumes a baby. It is an `emotionalLayer`
 * for the same reason D2 is: `docs/09` invariant 7 says loss suppresses celebratory
 * content *instantly and until she says otherwise*, and that has to survive being
 * stacked with anything else.
 */

import type { PersonaRecord } from "../types.ts";

/** E1 — recovery after birth. The spine of the track. */
const E1: PersonaRecord = {
  id: "E1",
  track: "E",
  home: {
    postpartum: [
      { id: "support.checkIn", emphasis: "hero" },
      /**
       * The EPDS (P2.7). Below the check-in, never in place of it: the hero asks
       * how she is and stops, and a ten-item questionnaire in that position would
       * make opening the app feel like being assessed. Offered, never pushed —
       * including to E6, because nothing is ever removed and a woman after a loss
       * may want it as much as anyone.
       */
      { id: "support.moodScreener", emphasis: "primary" },
      { id: "pregnancy.warningSigns", emphasis: "primary", params: { set: "postpartum" } },
      { id: "quickLog", emphasis: "primary" },
      { id: "library", emphasis: "secondary" },
    ],
  },
  // Symptom and mood are what exists and what E1 §G asks for first. Bleeding is
  // logged as a period entry because that is where the return of the cycle lands,
  // and it is the only honest place to put it today.
  tools: ["symptom", "mood", "period"],
  content: {
    skin: "postpartum",
    /**
     * The shelf E1 §F asks for, in the order it asks for it: what is happening to
     * her body, what is not ordinary, how she is, and then the cycle question that
     * arrives later. Six topics rather than three because the postpartum set now
     * exists (P2.3c) — the card renders the first four that are published, and
     * `/learn` holds the rest.
     */
    foreground: [
      "recovery-after-birth",
      "when-to-seek-care",
      "mood-after-birth",
      "bleeding-after-birth",
      "your-postnatal-check",
      "return-of-your-cycle",
    ],
  },
  alerts: [
    /**
     * The postpartum red-flag set is its own, not the pregnancy one. The dangerous
     * window does not close at delivery — `docs/09` §6 routes severe headache,
     * heavy bleeding, breathlessness and mood crisis the same way after birth as
     * before, and the copy is deliberately the same shape (P1.26.1: no numbers).
     */
    { id: "postpartum.redFlags", kind: "redFlag" },
    { id: "postpartum.moodCheckIn", kind: "cadence", params: { everyWeeks: 2 } },
  ],
  emrView: ["deliveryDate", "postpartumWeek"],
  tone: {
    register: "warm",
    // Not celebratory by default. Some of the people in this mode did not bring a
    // baby home, and the mode alone does not tell us which.
    celebrationByDefault: false,
    countdown: false,
    readingLevel: "standard",
  },
};


/**
 * E2 — breastfeeding and lactation.
 *
 * Layers on E1 rather than replacing it: her recovery has not stopped because
 * feeding started. What E2 adds is a surface where **she** is the subject — E2 §E
 * puts it as "her breasts, her body, her mood" — and it explicitly scopes *out*
 * full baby tracking, growth curves and any adequacy verdict.
 *
 * ## The two things this record must never contribute
 *
 * **No milk-adequacy verdict.** E2 §E lists it under "explicitly out of scope",
 * and the reason is the same one that keeps a `result` column off the movement log:
 * "is the baby getting enough" is the question that brings a woman here at 2am, and
 * an app answering it from a feeding log would be answering a clinical question
 * from data that cannot support it. What she gets is the CDC/OWH signals to look
 * for and a route to a lactation consultant.
 *
 * **No medication compatibility ruling.** Also §E. Femio can explain how
 * compatibility is assessed and link the record; it does not decide.
 *
 * Gated in the resolver on a **stated live birth**, not merely "not a loss": E6 §A
 * notes lactation after loss is close to unspeakable in some of Femio's markets,
 * and surfacing feeding content on an unstated outcome would be the worst thing
 * this track could do.
 */
const E2: PersonaRecord = {
  id: "E2",
  track: "E",
  extends: "E1",
  home: {
    postpartum: [
      { id: "support.feeding", emphasis: "hero" },
      /**
       * The mastitis-spectrum surface (E2 §E item 2, §G). Per breast, with the
       * red-flag box after concerning entries — and it is a *log with education*,
       * never an assessment.
       */
      { id: "support.breastSymptoms", emphasis: "primary" },
    ],
  },
  // A feeding log deliberately minimal enough not to become a baby tracker (§E4).
  tools: ["symptom", "mood", "period"],
  content: {
    skin: "postpartum-feeding",
    /**
     * The newborn seed set lands here and **nowhere else in Track E** (P2.13c).
     *
     * E1 would be the obvious home — a woman weeks after birth is the reader these
     * pages were written for — and it is the one place they must not go. `foreground`
     * merges purely additively up the `extends` chain (`build.ts`), and **E6 extends
     * E1**, so a topic added to the recovery spine appears on the reading card of a
     * woman after a pregnancy loss. "Your newborn in the first two weeks" in front of
     * her is the worst thing this track could do, and E6 §A says so in those words.
     *
     * E2 is safe because its resolver gate is a **stated live birth**
     * (`pregnancyOutcome === "completed"`, no prior loss), which E6 can never satisfy.
     * So the two newborn topics that belong to feeding sit here, and `warning-signs`
     * comes with them because it is the one newborn page that must be one tap away.
     * The other five articles are reachable from `/learn` and from each other, which
     * is the right amount of reach for a seed set; giving them a persona shelf needs
     * either a subtraction mechanism in the engine or a live-birth-gated general
     * newborn persona, and that is a decision, not a wiring task (BLOCKERS).
     */
    foreground: [
      "breastfeeding-first-two-weeks",
      "if-breastfeeding-is-not-working",
      "is-baby-getting-enough",
      "newborn-warning-signs",
      "mastitis-and-blocked-ducts",
      "bottle-and-formula-feeding",
    ],
  },
  alerts: [
    // "Seek care now", never a diagnosis: the mastitis spectrum escalates on time
    // (ABM 2022 — 12–24h without improvement), and that is education, not triage.
    { id: "feeding.redFlags", kind: "redFlag" },
  ],
  emrView: ["feedingMethod", "postpartumWeek"],
  tone: {
    register: "warm",
    // Still not celebratory by default. She may be feeding through pain, or
    // grieving a feeding plan that did not happen; §E10 is explicit that guilt-free
    // combination and formula content is part of the persona, not an afterthought.
    celebrationByDefault: false,
    countdown: false,
    readingLevel: "standard",
  },
};

/**
 * E6 — pregnancy loss and grief.
 *
 * Layered on E1 rather than replacing it, because her body still went through a
 * birth and the recovery content still applies. What changes is everything about
 * how it speaks.
 */
const E6: PersonaRecord = {
  id: "E6",
  track: "E",
  extends: "E1",
  emotionalLayer: true,
  home: {
    postpartum: [
      { id: "support.lossAware", emphasis: "hero" },
      { id: "support.checkIn", emphasis: "primary" },
    ],
  },
  tools: ["mood"],
  content: {
    skin: "postpartum-loss",
    foreground: ["grief-and-what-helps", "your-body-after-a-loss", "telling-people"],
  },
  // No cadence at all. A scheduled nudge to someone grieving is the product
  // deciding when she should be ready, and invariant 7 says silence over risk on
  // grief paths. The check-in is available; it is never pushed.
  alerts: [{ id: "loss.suppression", kind: "education" }],
  emrView: ["lossDate", "gestationAtLoss"],
  tone: {
    register: "gentle",
    celebrationByDefault: false,
    countdown: false,
    readingLevel: "gentle",
  },
};

/**
 * E3 — postpartum mood (PPD, anxiety, intrusive thoughts, rage).
 *
 * Layered on E1: her recovery has not paused. What changes is what leads and how
 * it speaks — E3 §A's whole tonal job is to *separate her from the illness*.
 *
 * ## Resolved from what she said, never from a score
 *
 * The gate is the `depression_anxiety` code the postpartum triage already asks
 * about — **her own statement**. It is deliberately *not* an EPDS total, even
 * though `screener_results` now holds one: reconfiguring a woman's app because a
 * questionnaire crossed a line is Femio deciding she has a condition, which is the
 * thing product rule 1 forbids and the thing P2.7 refused to do at the point of
 * scoring. The screener routes crisis on item 10 and reports a number; it does not
 * assign her a persona.
 *
 * ## What this record must never contribute
 *
 * **No diagnostic label.** Nothing here says "postpartum depression" *about her*;
 * the content explains what the term means and the tone stops there.
 * **No psychosis screening.** §A is explicit that postpartum psychosis is
 * education plus urgent routing only — a rare emergency Femio must be able to
 * describe and must never claim to detect. That is why the alert is `education`.
 */
const E3: PersonaRecord = {
  id: "E3",
  track: "E",
  extends: "E1",
  home: {
    postpartum: [
      /**
       * The hero is support, not assessment. E1 learned this the expensive way in
       * P2.7a: a ten-item questionnaire in the first position makes opening the
       * app feel like being graded, and this is the persona least able to afford
       * that. The screener stays available directly below, inherited from E1.
       */
      { id: "support.moodSupport", emphasis: "hero" },
      /**
       * §A: intrusive thoughts are reported by the large majority of new mothers
       * and having them says nothing about what she will do. Naming that plainly
       * is the single highest-value thing this persona says, because the shame is
       * what stops her telling anyone.
       */
      { id: "support.intrusiveThoughts", emphasis: "primary" },
    ],
  },
  tools: ["mood", "symptom", "period"],
  content: {
    skin: "postpartum-mood",
    foreground: ["mood-after-birth", "recovery-after-birth", "when-to-seek-care", "partner-explainer"],
  },
  alerts: [
    // Education, never surveillance: what the warning signs are — for her *and for
    // her family*, who are the ones most likely to notice — and that they need
    // same-day emergency care. Femio never screens for or monitors psychosis.
    { id: "mood.psychosisEducation", kind: "education" },
  ],
  emrView: ["postpartumWeek", "moodHistory"],
  tone: {
    register: "gentle",
    celebrationByDefault: false,
    countdown: false,
    // §A: 3 a.m., one-handed, depleted. Short sentences are not a simplification
    // here, they are the difference between being read and not.
    readingLevel: "gentle",
  },
};

/**
 * E4 — postpartum after a complicated pregnancy.
 *
 * The destination of the D-track condition specs (D3 GDM, D4 diabetes, D5/D6
 * hypertension and pre-eclampsia, D8 preterm/NICU), and the record that makes rule
 * 5 — constant EMR, additive layers — true across the birth. The glucose and blood
 * pressure logs that ran through her pregnancy **do not end at delivery**; they
 * re-tune to a postpartum cadence.
 *
 * ## The "postpartum cliff" is the whole reason it exists
 *
 * §A: during pregnancy she was watched weekly, and afterwards the system's
 * attention transfers to the baby. Only a minority of women with gestational
 * diabetes complete the recommended postpartum glucose test. Femio's part is
 * **education and reminders, never care** — the schedule, and the fact that
 * pre-eclampsia can *begin* after birth, which is the knowledge gap §A calls
 * genuinely dangerous.
 */
const E4: PersonaRecord = {
  id: "E4",
  track: "E",
  extends: "E1",
  home: {
    postpartum: [
      // Not the hero. E1's spine stays foregrounded (§A: "a follow-up *layer*, not
      // a replacement for recovery care"), and what E4 adds is the appointment
      // nobody reminded her about.
      { id: "followup.schedule", emphasis: "primary" },
    ],
  },
  tools: ["symptom", "mood", "period", "glucose", "medication"],
  content: {
    skin: "postpartum-followup",
    foreground: [
      "when-to-seek-care",
      "recovery-after-birth",
      "your-follow-up-tests",
      "what-this-means-long-term",
    ],
  },
  alerts: [
    // A prompt to attend, never a reading of a result. `params` carry the window
    // the guidelines describe; the copy names the test and points at her clinician.
    { id: "followup.glucoseTest", kind: "milestone", params: { weeksAfterBirth: 6 } },
    { id: "followup.bloodPressure", kind: "cadence", params: { everyWeeks: 1 } },
  ],
  emrView: ["postpartumWeek", "glucoseReadings", "conditionsCarriedForward"],
  tone: {
    register: "warm",
    celebrationByDefault: false,
    countdown: false,
    readingLevel: "standard",
  },
};

/**
 * E7 — postpartum thyroiditis watch.
 *
 * The destination of D7's `ppt_watch_flag`, and a small watch-and-organise layer
 * rather than a persona with much of its own screen. §A's defining sentence is
 * *"I can't tell whether I'm sick or just a tired mother"* — the symptoms overlap
 * almost completely with ordinary postpartum exhaustion and with mood, which is
 * why this record surfaces the lab log and the mood screener side by side and
 * resolves neither.
 *
 * **No phase interpretation.** PPT has described phases and Femio never says which
 * one she is in: that is a clinician's call on labs. The strip shows her own
 * entered results with the lab's own reference range and no verdict — the same
 * construction as `ClinicalStrip` in R2.3, for the same reason.
 */
const E7: PersonaRecord = {
  id: "E7",
  track: "E",
  extends: "E1",
  home: {
    postpartum: [
      { id: "thyroid.watch", emphasis: "primary" },
      { id: "strip.thyroid", emphasis: "primary" },
    ],
  },
  tools: ["symptom", "mood", "period", "labs", "medication"],
  content: {
    skin: "postpartum-thyroid",
    foreground: [
      "could-this-be-my-thyroid",
      "when-to-seek-care",
      "recovery-after-birth",
      "mood-after-birth",
    ],
  },
  alerts: [
    // The clinician sets the schedule; the alert carries that, never a dose and
    // never an interpretation of a number.
    { id: "thyroid.labCadence", kind: "cadence", params: { everyWeeks: 8 } },
  ],
  emrView: ["postpartumWeek", "thyroidLabs", "medications"],
  tone: {
    register: "warm",
    celebrationByDefault: false,
    countdown: false,
    readingLevel: "standard",
  },
};

export const TRACK_E_RECORDS: readonly PersonaRecord[] = [E1, E2, E3, E4, E6, E7];
