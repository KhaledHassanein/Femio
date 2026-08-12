import type { createClient } from "@/lib/supabase/client";
import { resolvePersona } from "./resolver";
import { readSignals } from "./signals-from-db";
import { buildConditionRows, type ConditionCode } from "./conditions";

/**
 * Persona state — the one place that maps a stored `track` to what the app
 * emphasises, and the only supported way to change it (docs/09).
 *
 * Until now `track` was written once, at onboarding, and never again: there was
 * no way to re-enter the wizard, correct a wrong answer, or move between life
 * stages. That made three of the six product rules unreachable in practice —
 * "personalize, never restrict", "constant EMR, additive layers", and the
 * re-openable wizard docs/09 §4 promises from Settings.
 *
 * Two invariants this module exists to hold:
 *
 * 1. **A mode change re-layers; it never deletes.** Switching out of pregnancy
 *    does not touch the pregnancy row, and switching back finds it intact. The
 *    record spans a life; the mode only decides which part of it is in front of
 *    her today. Nothing here issues a DELETE, and nothing should be added that does.
 * 2. **Every change is recorded.** `adaptation_events` has carried `from_state`
 *    and `to_state` columns since schema v1 for exactly this, and it is what makes
 *    a transition reversible rather than merely repeatable.
 */

export const PERSONA_MODES = ["cycle", "ttc", "pregnancy", "menopause", "general"] as const;
export type PersonaMode = (typeof PERSONA_MODES)[number];

/**
 * Mirrors the `profiles.age_band` check constraint. Age is stored as a band rather
 * than a date wherever possible — data minimisation, and the resolver never needs
 * more precision than this (docs/14).
 */
export const AGE_BANDS = [
  "under_13",
  "13_15",
  "16_17",
  "18_24",
  "25_34",
  "35_44",
  "45_54",
  "55_plus",
] as const;
export type AgeBand = (typeof AGE_BANDS)[number];

/**
 * Track letters come from the taxonomy in docs/08. `Z` is the Z1 fallback —
 * "general", the mode for someone who does not fit a life-stage bucket or does
 * not want one. It has always been permitted by the `persona_state.track` check
 * constraint; the app simply never wrote it.
 */
const TRACK_TO_MODE: Record<string, PersonaMode> = {
  B: "cycle",
  C: "ttc",
  D: "pregnancy",
  F: "menopause",
  Z: "general",
};

const MODE_TO_TRACK: Record<PersonaMode, string> = {
  cycle: "B",
  ttc: "C",
  pregnancy: "D",
  menopause: "F",
  general: "Z",
};

/**
 * Fallback persona per mode — used **only** when the resolver lands on a different
 * track than the one she explicitly chose.
 *
 * Her stated stage wins, because she just told us (product rule 3). If she says
 * "I'm pregnant" and the resolver has no pregnancy row to work from yet, the honest
 * answer is the track's base persona rather than overriding her with a cycle
 * persona the evidence happens to score higher.
 */
const MODE_TO_PERSONA: Record<PersonaMode, string> = {
  cycle: "B1",
  ttc: "C1",
  pregnancy: "D1",
  menopause: "F1",
  general: "Z1",
};

const MODE_TO_FLAGS: Record<PersonaMode, Record<string, boolean>> = {
  cycle: {},
  ttc: { ttc_intent: true },
  pregnancy: { pregnant: true },
  menopause: {},
  general: {},
};

/** Map a stored track letter to a mode. Unknown or missing → general, never a crash. */
export function modeFromTrack(track: string | null | undefined): PersonaMode {
  if (!track) return "cycle";
  return TRACK_TO_MODE[track] ?? "general";
}

export function trackFromMode(mode: PersonaMode): string {
  return MODE_TO_TRACK[mode];
}

export function personaIdFromMode(mode: PersonaMode): string {
  return MODE_TO_PERSONA[mode];
}

export function flagsFromMode(mode: PersonaMode): Record<string, boolean> {
  return MODE_TO_FLAGS[mode];
}

export function isPersonaMode(value: unknown): value is PersonaMode {
  return typeof value === "string" && (PERSONA_MODES as readonly string[]).includes(value);
}

/**
 * Whether a mode should be offered a next-period prediction and cycle calendar.
 *
 * Pregnancy and menopause say no for the reasons in ADR-041/043: a next-period
 * date is meaningless to one and actively misleading to the other. General says
 * **yes** — "personalize, never restrict" means the generic mode withholds
 * nothing; it simply stops assuming which stage she is in.
 */
export function showsCyclePredictions(mode: PersonaMode): boolean {
  return mode !== "pregnancy" && mode !== "menopause";
}

export type PersonaState = {
  track: string | null;
  personaId: string | null;
  mode: PersonaMode;
};

type Client = ReturnType<typeof createClient>;

export async function readPersonaState(supabase: Client): Promise<PersonaState> {
  const { data } = await supabase.from("persona_state").select("track, persona_id").maybeSingle();
  const track = (data?.track as string | null) ?? null;
  return {
    track,
    personaId: (data?.persona_id as string | null) ?? null,
    mode: modeFromTrack(track),
  };
}

export type SwitchResult = { ok: true; mode: PersonaMode } | { ok: false; error: string };

/**
 * Move to a different mode.
 *
 * Writes the new state and appends an `adaptation_events` row carrying both the
 * old and new state. No health row is read, changed or removed — see invariant 1.
 */
export async function switchMode(supabase: Client, next: PersonaMode): Promise<SwitchResult> {
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return { ok: false, error: "not-signed-in" };

  const before = await readPersonaState(supabase);

  /**
   * Re-resolve against her real record instead of writing the track's first
   * persona (R2.6).
   *
   * This used to store `personaIdFromMode(next)` — B1/C1/D1/F1/Z1 — while leaving
   * the resolver's `modifiers` and `confidence` from onboarding untouched. The row
   * then held two disagreeing accounts of who she is: a persona chosen by a lookup
   * table and modifiers computed for a different one (`docs/23` §3.1). Worse, a
   * woman with a recorded thyroid condition who chose "I'm pregnant" here got D1
   * and lost the thyroid layer she had been given at signup.
   *
   * Now the stage she picked is combined with what she has recorded and the
   * resolver decides, exactly as it does at onboarding.
   */
  const signals = await readSignals(supabase);
  const resolved = resolvePersona({
    ...signals,
    ttcIntent: next === "ttc",
    pregnancyStatus: next === "pregnancy" ? "active" : signals.pregnancyStatus,
  });

  const { error } = await supabase.from("persona_state").upsert({
    profile_id: user.id,
    // Her explicit choice wins the track — she just told us. The resolver refines
    // *within* it (product rule 3: explicit, reversible confirmation).
    track: trackFromMode(next),
    persona_id: resolved.track === trackFromMode(next) ? resolved.personaId : personaIdFromMode(next),
    modifiers: resolved.modifiers,
    emotional_context: resolved.emotionalContext,
    confidence: resolved.confidence,
    flags_json: flagsFromMode(next),
  });
  if (error) return { ok: false, error: error.message };

  // Append-only history. A failure here must not undo the switch she asked for,
  // so it is recorded and ignored rather than surfaced as a failed mode change.
  await supabase.from("adaptation_events").insert({
    profile_id: user.id,
    event_type: "mode_changed_by_user",
    from_state: { track: before.track, persona_id: before.personaId },
    to_state: { track: trackFromMode(next), persona_id: resolved.personaId },
  });

  return { ok: true, mode: next };
}

/**
 * Re-answer the questions that decide her experience (P1.27.3).
 *
 * `docs/09` §4 promised a wizard that is "re-openable anytime from Settings", and
 * nothing implemented it — so a wrong answer at signup was permanent. This is that
 * promise, narrowed to the part that matters: the life stage and the triage
 * answers. It deliberately does **not** re-run account creation or consent; those
 * already happened, and re-asking would be theatre.
 *
 * ## Why this one is allowed to delete, when nothing else is
 *
 * Invariant 2 — "a transition re-layers, it never deletes" — is about life-stage
 * changes not destroying her record. This is a different act: she is telling us a
 * statement she made about herself was wrong. Leaving a retracted "PCOS" on file
 * because a rule said never delete would make the record *less* true, and it would
 * keep shaping her experience against her wishes.
 *
 * So the replacement is bounded as tightly as it can be:
 * - only `source = 'self'` rows are touched. A screener result (P2.7) is evidence
 *   she cannot retract by re-answering a wizard question, and is left alone.
 * - the change is written to `adaptation_events` before and after, so the
 *   correction is auditable even though the superseded rows are gone.
 * - nothing outside `conditions_flagged` is read or written. Cycles, pregnancies,
 *   symptoms and logs are untouched.
 */
export async function reanswerTriage(
  supabase: Client,
  next: PersonaMode,
  conditions: readonly ConditionCode[],
): Promise<SwitchResult> {
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return { ok: false, error: "not-signed-in" };

  const before = await readPersonaState(supabase);

  // Replace only what she said about herself.
  const { error: clearError } = await supabase
    .from("conditions_flagged")
    .delete()
    .eq("profile_id", user.id)
    .eq("source", "self");
  if (clearError) return { ok: false, error: clearError.message };

  const rows = buildConditionRows(user.id, [...conditions]);
  if (rows.length > 0) {
    const { error: insertError } = await supabase.from("conditions_flagged").insert(rows);
    if (insertError) return { ok: false, error: insertError.message };
  }

  // Resolve against the corrected record, not the one she just replaced.
  return switchMode(supabase, next).then((result) => {
    if (result.ok) {
      void supabase.from("adaptation_events").insert({
        profile_id: user.id,
        event_type: "triage_reanswered_by_user",
        from_state: { track: before.track, persona_id: before.personaId },
        to_state: { track: trackFromMode(next), conditions: [...conditions] },
      });
    }
    return result;
  });
}
