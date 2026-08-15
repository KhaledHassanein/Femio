/**
 * Where she is within Track D, derived from what the app already knows.
 *
 * Pure and clock-free like the rest of tier 1, and it **reuses `pregnancyProgress`
 * rather than re-deriving gestational age**. There is exactly one place in this
 * codebase that turns an EDD into weeks and days, and adding a second would be the
 * drift `docs/24` §4 exists to prevent — two answers to "how pregnant is she" is a
 * safety problem, not a tidiness one.
 */

import { pregnancyProgress, type Trimester } from "../pregnancy/index.ts";
import type { Track } from "../persona/resolver.ts";
import type { Phase } from "./types.ts";

const TRIMESTER_PHASE: Record<Trimester, Phase> = { 1: "t1", 2: "t2", 3: "t3" };

export type PhaseInput = {
  /** `null` before she has given a due date, or once the pregnancy has ended. */
  edd: string | null;
  /** `"ended"` covers every outcome — the reason is never a phase input (ADR-043). */
  status: string | null;
  todayISO: string;
};

/**
 * Returns `null` rather than guessing.
 *
 * A null phase means the engine contributes no phase-specific modules, which is the
 * honest state before a due date exists — the alternative is showing her a
 * second-trimester screen because a default had to be picked.
 */
export function phaseFor({ edd, status, todayISO }: PhaseInput): Phase | null {
  if (status === "ended") return "postpartum";
  if (!edd) return null;
  const progress = pregnancyProgress(edd, todayISO);
  if (!progress) return null;
  return TRIMESTER_PHASE[progress.trimester];
}

/**
 * The phase, given what track she is in.
 *
 * Track E **is** the postpartum phase — that is what the letter means — and it has
 * to be derivable without a pregnancy row, because the woman who installs Femio two
 * weeks after giving birth has never had one. Without this she gets a Track E
 * persona whose modules are all filed under `postpartum`, a null phase, and
 * therefore an empty screen: the engine looking correct while her dashboard lost
 * every panel.
 *
 * Track D still reads its phase from gestational age, and a pregnancy row that has
 * ended still wins, so nothing about Track D changes here.
 */
export function phaseForTrack(track: Track | null, input: PhaseInput): Phase | null {
  return phaseFor(input) ?? (track === "E" ? "postpartum" : null);
}
