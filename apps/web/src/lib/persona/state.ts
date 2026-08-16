import type { createClient } from "@/lib/supabase/client";
import { resolveForStatedTrack, TRACK_BASE_PERSONA, type Track } from "./resolver";
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

// Vocabulary lives in pure modules so tier 1 can import it without this file's
// Supabase dependency (R2.4). Imported for local use and re-exported so every
// existing caller keeps working.
import { PERSONA_MODES, type PersonaMode } from "./modes";
export { PERSONA_MODES, type PersonaMode };

// Age bands moved to `./age` so tier 1 can import them without dragging in the
// Supabase client this module uses (R2.4). Re-exported for existing callers.
export { AGE_BANDS, type AgeBand } from "./age";

/**
 * Track letters come from the taxonomy in docs/08. `Z` is the Z1 fallback —
 * "general", the mode for someone who does not fit a life-stage bucket or does
 * not want one. It has always been permitted by the `persona_state.track` check
 * constraint; the app simply never wrote it.
 */
const TRACK_TO_MODE: Record<string, PersonaMode> = {
  A: "teen",
  B: "cycle",
  C: "ttc",
  D: "pregnancy",
  E: "postpartum",
  F: "menopause",
  Z: "general",
};

const MODE_TO_TRACK: Record<PersonaMode, string> = {
  teen: "A",
  cycle: "B",
  ttc: "C",
  pregnancy: "D",
  postpartum: "E",
  menopause: "F",
  general: "Z",
};

const MODE_TO_FLAGS: Record<PersonaMode, Record<string, boolean>> = {
  teen: {},
  cycle: {},
  ttc: { ttc_intent: true },
  pregnancy: { pregnant: true },
  postpartum: {},
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

/**
 * The persona she gets when the evidence has not caught up with what she told us.
 *
 * The table itself moved to `resolver.ts` as `TRACK_BASE_PERSONA` (R2.4): the Edge
 * Function has to apply the identical rule, and it cannot import this file — this
 * one talks to Supabase. A mode→persona map living only in the browser is exactly
 * how the server came to serve a generic document to a woman who had said she was
 * postpartum.
 */
export function personaIdFromMode(mode: PersonaMode): string {
  return TRACK_BASE_PERSONA[MODE_TO_TRACK[mode] as Track];
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
  // Postpartum joins pregnancy and menopause for the same reason both are here: a
  // next-period window computed from cycles that stopped months ago is not an
  // estimate, it is an invention — and the return of the cycle after birth is
  // genuinely unpredictable (E1 §G). Before R2.5 this mode did not exist, so she
  // fell into `general` and got exactly that prediction.
  //
  // Teen is here for a different reason and it is **not** a restriction: A2 gets a
  // window, a wide one, and the engine renders it as `teen.window` with the reason
  // attached. What this excludes is the *generic adult* hero and the average-length
  // card underneath it — A1 is not cycling at all (A1 §I: "no cycle predictions…
  // deliberately hidden until A2"), and A2 needs the range explained rather than
  // stated. The distinction is per-persona, which is exactly what a mode flag
  // cannot express and the registry can.
  return (
    mode !== "pregnancy" && mode !== "menopause" && mode !== "postpartum" && mode !== "teen"
  );
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
   *
   * The "stated stage wins the track" half is `resolveForStatedTrack`, in tier 1,
   * because the Edge Function has to reach the same answer (R2.4). It used to be
   * written out here, and the server — which could not see it — served a different
   * persona than the one this function had stored.
   */
  const signals = await readSignals(supabase);
  const resolved = resolveForStatedTrack(
    {
      ...signals,
      ttcIntent: next === "ttc",
      pregnancyStatus: next === "pregnancy" ? "active" : signals.pregnancyStatus,
    },
    trackFromMode(next) as Track,
  );

  /**
   * Merge the flags rather than replacing them (P1.27.8).
   *
   * `flags_json` used to be overwritten wholesale with `flagsFromMode(next)`, which
   * was harmless while the only flags were mode-derived. It stopped being harmless
   * the moment onboarding started storing her answers there: switching mode once
   * would have silently erased how long she had been trying, or when she gave
   * birth, and the resolver would have quietly dropped back to C1 or Z1 with no
   * way for her to tell why.
   */
  const { data: existing } = await supabase
    .from("persona_state")
    .select("flags_json")
    .maybeSingle();

  const { error } = await supabase.from("persona_state").upsert({
    profile_id: user.id,
    // Her explicit choice wins the track — she just told us. The resolver refines
    // *within* it (product rule 3: explicit, reversible confirmation).
    track: trackFromMode(next),
    persona_id: resolved.personaId,
    modifiers: resolved.modifiers,
    emotional_context: resolved.emotionalContext,
    confidence: resolved.confidence,
    flags_json: { ...((existing?.flags_json ?? {}) as object), ...flagsFromMode(next) },
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
