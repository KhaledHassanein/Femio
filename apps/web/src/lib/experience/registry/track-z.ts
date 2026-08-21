/**
 * Track Z — the fallback, and the one track that never had a document (R3.1.6).
 *
 * `TRACK_BASE_PERSONA` has mapped `Z → Z1` since the resolver was written, and
 * `TRACK_TO_MODE` maps `Z → general`. There was no `track-z.ts`. So a woman whose
 * evidence did not resolve to a life stage — the fallback in `docs/08`, and the
 * one every ambiguous or brand-new record lands on — was served an experience
 * document containing nothing, and the only reason her dashboard showed a
 * prediction at all was a hardcoded `HeroCard` behind `showsCyclePredictions(mode)`
 * in `dashboard-screen.tsx`.
 *
 * That is the concrete shape of the gap `docs/26` §4.1 found: the engine was built,
 * the screens were not moved onto it, and the leftover branch was load-bearing for
 * exactly the users who had told Femio least about themselves. Deleting the branch
 * without this file would have silently removed their predictions — which is why
 * R3.1.3a suppressed it by module id rather than removing it, and why this exists
 * before the branch goes.
 *
 * ## What Z1 gets, and why it is not "less"
 *
 * Product rule 2 is personalize, **never restrict**. Z1 is not a reduced tier for
 * someone who failed a questionnaire; it is the honest answer when Femio does not
 * know her stage yet, and `docs/08`'s fallback is explicit that the generic mode
 * withholds nothing. So this is Track B's cycle home minus the pieces that assume a
 * stage she has not claimed:
 *
 *   * `cycle.window` and `cycle.phase` — a cycle is the one thing Femio can
 *     reasonably assume of an adult who has not said otherwise, and
 *     `showsCyclePredictions` has always answered **yes** for `general` for exactly
 *     that reason. Both degrade honestly on their own when the data is thin.
 *   * `cycle.flowStrip` and `quickLog` — her own record, and the way to add to it.
 *     Neither infers anything.
 *   * `library`, `visitPrep`, `privacy` — the "everything else is still here"
 *     surfaces. These matter *most* here: the woman Femio cannot place is the one
 *     most likely to need to reach something it has not offered her.
 *
 * Deliberately absent: `cycle.personalNormal`, which sets her range against a
 * typical one. That framing belongs to someone tracking a cycle on purpose; shown
 * to a record Femio has not placed, it invites a comparison she did not ask for
 * against a norm that may not be hers.
 */

import type { PersonaRecord } from "../types.ts";

const Z1: PersonaRecord = {
  id: "Z1",
  track: "Z",
  home: {
    /** `default` for the same reason B1 uses it: a cycle has no phase bucket. */
    default: [
      { id: "cycle.window", emphasis: "hero" },
      { id: "cycle.phase", emphasis: "primary" },
      { id: "cycle.flowStrip", emphasis: "primary" },
      { id: "quickLog", emphasis: "primary" },
      { id: "library", emphasis: "secondary" },
      { id: "visitPrep", emphasis: "secondary" },
      { id: "privacy", emphasis: "secondary" },
    ],
  },
  /** Her own record and the ways into it. Nothing stage-specific is assumed. */
  tools: ["period", "symptom", "mood"],
  content: {
    skin: "cycle",
    foreground: [],
  },
  /**
   * Cadence only, and no education alert that presumes a stage.
   *
   * `cycle.longGap` is deliberately kept: a long gap is worth surfacing to someone
   * Femio has not placed *precisely because* it is one of the signals that would
   * place her, and it is framed as education rather than alarm.
   */
  alerts: [
    { id: "cycle.periodDue", kind: "cadence" },
    { id: "cycle.longGap", kind: "education", params: { afterDays: 90 } },
  ],
  emrView: ["cycleLengthRange", "periodLength", "cycleVariability", "lastBleed"],
  tone: {
    register: "neutral",
    /** `standard`, as Track B uses. Not `gentle`: that is Track A's register for a
     *  teenager, and applying it to an unplaced adult would be Femio deciding she
     *  needs softening on no evidence at all. */
    readingLevel: "standard",
    celebrationByDefault: false,
    /** Product rule 3. Never a certain date, never a "late" counter. */
    countdown: false,
  },
};

export const TRACK_Z_RECORDS: readonly PersonaRecord[] = [Z1];
