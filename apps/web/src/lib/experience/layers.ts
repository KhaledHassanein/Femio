/**
 * Emotional context → the persona that carries it (R2.4, `docs/09` invariant 7).
 *
 * `emotional_context` stores *reasons* — `prior_loss`, `waiting` — while
 * `buildExperienceConfig` takes *persona ids* to stack as layers. Something has to
 * map one to the other, and that something had been copied into four files: the
 * client ladder, the Edge Function, the pregnancy screen and the postpartum screen.
 *
 * Three of them said `prior_loss → D2`. The fourth said `prior_loss → E6`, and the
 * fourth was right for its track: **D2 is a pregnancy carried after a loss; E6 is
 * the loss itself.** Handing a woman in Track E the D2 layer is not a near-miss, it
 * is the wrong stage's tone. So the mapping is a table, it is keyed by track, and it
 * lives in tier 1 where the server and both clients read the same one.
 *
 * A context with no layer for a track contributes nothing — silently, and correctly.
 * `waiting` is the case today: it belongs to Track C, which has no emotional layer
 * yet, and inventing one to fill the table would be worse than an empty cell.
 */

import type { Track } from "../persona/resolver.ts";

const LAYER_BY_TRACK: Partial<Record<Track, Readonly<Record<string, string>>>> = {
  // A pregnancy after loss: the D1 spine keeps the hero, D2 brings anxiety-aware
  // tone and the loss-suppression net on top (`docs/09` §8 rule 2).
  D: { prior_loss: "D2" },
  // After a loss: E6 is gentle register, no celebration, no cadence.
  E: { prior_loss: "E6" },
};

export function emotionalLayersFor(
  track: Track,
  emotionalContext: readonly string[],
): string[] {
  const table = LAYER_BY_TRACK[track];
  if (!table) return [];
  return emotionalContext
    .map((context) => table[context])
    .filter((id): id is string => Boolean(id));
}
