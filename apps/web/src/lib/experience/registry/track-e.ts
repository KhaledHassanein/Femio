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

export const TRACK_E_RECORDS: readonly PersonaRecord[] = [E1, E6];
