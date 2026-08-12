import type { PersonaRecord } from "../types";
import { TRACK_D_RECORDS } from "./track-d";
import { TRACK_E_RECORDS } from "./track-e";

/**
 * Every persona record the engine knows about (R2.5).
 *
 * One list rather than per-track imports scattered through the app: adding a track
 * should be an edit here and nowhere else, which is the difference between a
 * registry and a pile of files. `docs/09` §10 is explicit that the remaining
 * personas "slot in" rather than being rebuilt — this is where they slot.
 */
export const PERSONA_RECORDS: readonly PersonaRecord[] = [
  ...TRACK_D_RECORDS,
  ...TRACK_E_RECORDS,
];

export function findRecord(id: string): PersonaRecord | undefined {
  return PERSONA_RECORDS.find((r) => r.id === id);
}

export { TRACK_D_RECORDS, TRACK_E_RECORDS };
