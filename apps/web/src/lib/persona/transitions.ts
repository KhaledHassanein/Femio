/**
 * The universal transition graph (P1.27.6, `docs/09` §6–§7).
 *
 * `docs/09` §6 defines seven global handlers that "fire from almost any state" —
 * the events that recurred in nearly every persona's §J and were therefore lifted
 * out and defined once. Until now none of them fired at all: a woman's mode changed
 * only when she opened Settings and changed it herself.
 *
 * The gap this closes is not theoretical. A woman who records that her pregnancy
 * has ended stays in pregnancy mode indefinitely, looking at a panel that says her
 * pregnancy ended, until it occurs to her that a settings screen exists. A woman
 * who logs a positive test while in TTC mode keeps the fertile-window hero the
 * event is supposed to suppress.
 *
 * ## Offered, never applied — and this is the whole design
 *
 * `docs/09` invariant 3: *"Every mode switch is offered, confirmed by the user, and
 * reversible. Nothing is forced."* So this module returns a **suggestion**, it is
 * surfaced through the same `ExperienceConfig.offer` channel P1.27.5 built, and it
 * is dismissible in one tap.
 *
 * A pregnancy loss is the case that makes the rule non-negotiable. An app that
 * silently reconfigured itself the moment she recorded one — new screen, new tone,
 * grief resources she did not ask for — would be announcing her loss back to her,
 * on its own schedule, possibly in front of someone. It offers, gently, and she
 * decides when.
 *
 * ## What is deliberately not here
 *
 * The §6 handlers that are **not** mode changes: crisis routing (already wired,
 * P1.26.3), red-flag surfacing (already wired), disengagement, and the
 * age-of-consent milestone. Those change what is shown or what is permitted, not
 * which track she is in, and folding them into a transition table would blur two
 * different things.
 */

import type { PersonaSignals } from "./signals.ts";
import { TRACK_BASE_PERSONA, type Track } from "./resolver.ts";

export type TransitionId =
  | "positiveTest"
  | "pregnancyEnded"
  | "postpartumPassed";

export type Transition = {
  id: TransitionId;
  /** The track she would move to. Rendered as a life stage, never a persona code. */
  to: Track;
  /** The persona she would land on; the resolver refines within the track after. */
  personaId: string;
};

type Rule = {
  id: TransitionId;
  to: Track;
  /** Tracks this can fire from. Empty means any track except the destination. */
  from?: readonly Track[];
  when: (signals: PersonaSignals) => boolean;
};

/** After this long, "recently gave birth" has stopped describing her (E1's own gate). */
const POSTPARTUM_WEEKS = 26;

/**
 * Order matters: the first match wins, and pregnancy comes before anything else
 * because an active pregnancy is the most consequential thing Femio can be wrong
 * about. Each rule is one row of the `docs/09` §7 graph.
 */
const RULES: readonly Rule[] = [
  {
    /**
     * §6, positive pregnancy test. Fires from anywhere she is not already in
     * Track D — most usefully from TTC, where the fertile-window hero is exactly
     * what the handler says to suppress.
     */
    id: "positiveTest",
    to: "D",
    when: (s) => s.pregnancyStatus === "active",
  },
  {
    /**
     * §6, pregnancy loss or birth. **Only from Track D**, because "her pregnancy
     * ended" is only news if Femio currently thinks she is pregnant; for anyone
     * else it is an old fact in her record and re-offering it would be the app
     * bringing up a loss unprompted, months later.
     */
    id: "pregnancyEnded",
    to: "E",
    from: ["D"],
    when: (s) => s.pregnancyStatus === "ended",
  },
  {
    /**
     * The quiet one, and the only transition *out* of a stage rather than into a
     * crisis or a milestone. Six months after birth E1's own gate stops holding,
     * and a woman still being shown recovery content a year later is the mirror
     * image of the problem R2.5 fixed. `docs/09` §7 routes her to the general
     * cycle track, from which the resolver can refine as her cycles return.
     */
    id: "postpartumPassed",
    to: "B",
    from: ["E"],
    when: (s) => (s.weeksSincePregnancyEnd ?? 0) > POSTPARTUM_WEEKS,
  },
];

/**
 * The transition Femio would suggest, or null.
 *
 * Never fires when she is already in the destination track: a suggestion to move
 * where she already is reads as the product not knowing her, which is worse than
 * saying nothing.
 */
export function suggestTransition(
  signals: PersonaSignals,
  currentTrack: Track | null,
): Transition | null {
  for (const rule of RULES) {
    if (currentTrack === rule.to) continue;
    if (rule.from && (currentTrack === null || !rule.from.includes(currentTrack))) continue;
    if (!rule.when(signals)) continue;
    return { id: rule.id, to: rule.to, personaId: TRACK_BASE_PERSONA[rule.to] };
  }
  return null;
}
