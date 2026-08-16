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
    foreground: ["recovery-after-birth", "when-to-seek-care", "return-of-your-cycle"],
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
    foreground: [
      "breastfeeding-first-two-weeks",
      "if-breastfeeding-is-not-working",
      "is-baby-getting-enough",
      "mastitis-and-blocked-ducts",
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

export const TRACK_E_RECORDS: readonly PersonaRecord[] = [E1, E2, E6];
