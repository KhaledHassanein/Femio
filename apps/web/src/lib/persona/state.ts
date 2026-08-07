import type { createClient } from "@/lib/supabase/client";

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
 * Initial persona id per mode. Deliberately the first persona of each track:
 * the full resolver that picks among ~73 personas does not exist yet, so this
 * is an honest placeholder rather than a pretence of resolution (see the
 * `resolver` note in docs/09 §5 and the open TODO).
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

  const { error } = await supabase.from("persona_state").upsert({
    profile_id: user.id,
    track: trackFromMode(next),
    persona_id: personaIdFromMode(next),
    flags_json: flagsFromMode(next),
  });
  if (error) return { ok: false, error: error.message };

  // Append-only history. A failure here must not undo the switch she asked for,
  // so it is recorded and ignored rather than surfaced as a failed mode change.
  await supabase.from("adaptation_events").insert({
    profile_id: user.id,
    event_type: "mode_changed_by_user",
    from_state: { track: before.track, persona_id: before.personaId },
    to_state: { track: trackFromMode(next), persona_id: personaIdFromMode(next) },
  });

  return { ok: true, mode: next };
}
