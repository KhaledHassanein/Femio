import type { createClient } from "@/lib/supabase/client";
import { todayISO } from "@/lib/calculators/dates";
import type { Track } from "./resolver";
import { EMPTY_SIGNALS, type PersonaSignals } from "./signals";
import { signalsFromRows, type SignalRows } from "./signals-from-rows";

/**
 * Derive `PersonaSignals` from what she has actually recorded (P1.27.4a).
 *
 * The resolver has existed since ADR-057 and only ever saw wizard answers, which
 * meant it could resolve her once and never again — `docs/23` §3.1. This is the
 * other half: the same signal set, read from the live record, so re-answering a
 * question or logging a period produces a real re-resolution rather than a
 * re-run of the same four answers.
 *
 * **This file is now only the query.** The derivation moved to
 * `signals-from-rows.ts` (tier 1) so the Edge Function runs the same code rather
 * than a copy of it — and the copy had already drifted on `ttcIntent`. Everything
 * about *what a signal means* lives there; what is left here is which rows to fetch.
 */

type Client = ReturnType<typeof createClient>;

/** Everything the engine needs from the database, in one round of queries. */
export type PersonaRecordRows = {
  signals: SignalRows;
  /** `persona_state.track` — the stage she chose. It wins the track (R2.6). */
  statedTrack: Track | null;
  /** For the Track D phase. Null before she gives a due date. */
  edd: string | null;
  pregnancyStatus: string | null;
};

export async function readPersonaRows(supabase: Client): Promise<PersonaRecordRows | null> {
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return null;

  const [profile, cycles, conditions, pregnancy, symptoms, state] = await Promise.all([
    supabase.from("profiles").select("age_band").maybeSingle(),
    supabase.from("cycles").select("period_start").order("period_start", { ascending: false }),
    supabase.from("conditions_flagged").select("condition_code, created_at"),
    supabase
      .from("pregnancy")
      .select("status, edd, created_at, updated_at")
      // Most recent regardless of status: an ended pregnancy still decides the phase.
      .order("updated_at", { ascending: false })
      .limit(1)
      .maybeSingle(),
    supabase.from("symptom_logs").select("type").order("logged_at", { ascending: false }).limit(200),
    supabase.from("persona_state").select("track, flags_json").maybeSingle(),
  ]);

  const pregnancyRow = pregnancy.data as
    | { status: string; edd: string | null; created_at: string; updated_at: string }
    | null;
  const flags = (state.data?.flags_json ?? {}) as Record<string, boolean>;

  return {
    signals: {
      ageBand: (profile.data?.age_band as string | null) ?? null,
      periodStarts: (cycles.data ?? []).map((c) => c.period_start as string),
      conditions: ((conditions.data ?? []) as { condition_code: string; created_at: string }[]).map(
        (r) => ({ code: r.condition_code, recordedAt: r.created_at }),
      ),
      pregnancy: pregnancyRow
        ? {
            status: pregnancyRow.status,
            createdAt: pregnancyRow.created_at,
            updatedAt: pregnancyRow.updated_at,
          }
        : null,
      symptomTypes: ((symptoms.data ?? []) as { type: string }[]).map((r) => r.type),
      // Her stated intent, never inferred. This was hard-coded `false` here while the
      // Edge Function read it from `flags_json`, so C1/C6/C8 could resolve on the
      // server and never in the local fallback — the same document, two answers.
      ttcIntent: flags.ttc_intent === true,
      todayISO: todayISO(),
    },
    statedTrack: ((state.data?.track as string | null) ?? null) as Track | null,
    edd: pregnancyRow?.edd ?? null,
    pregnancyStatus: pregnancyRow?.status ?? null,
  };
}

export async function readSignals(supabase: Client): Promise<PersonaSignals> {
  const rows = await readPersonaRows(supabase);
  if (!rows) return EMPTY_SIGNALS;
  return signalsFromRows(rows.signals);
}
