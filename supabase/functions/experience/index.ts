/**
 * `experience` — tier 1, running on the server (R2.4, ADR-060/061, `docs/24` §1).
 *
 * **The backend owns decisions; the clients render them.** This function reads a
 * woman's own record, resolves who she is, and returns the `ExperienceConfig` a
 * client renders. The web app and the Flutter client call the same endpoint and get
 * the same document — which is the entire point: two clients re-implementing cycle
 * prediction or urgency tiers is a *safety* problem, not a duplication one.
 *
 * ## What it deliberately does not do
 *
 * - **No service-role key.** It runs the caller's own JWT through Supabase, so RLS
 *   is still the security boundary. A bug here cannot read someone else's record,
 *   because the database would refuse — the same reasoning that made `AuthGate` a
 *   display decision rather than a security one (ADR-048).
 * - **No writes.** Resolution is a read. Persisting it is the client's job through
 *   `switchMode`, which already records an `adaptation_events` row.
 * - **No interpretation.** It returns which modules to show. It does not decide
 *   whether a value is normal, and the contract cannot express that it did.
 *
 * ## Imports
 *
 * The tier-1 modules are imported straight from `apps/web/src`, relative. They are
 * held framework-free, data-free and alias-free by `pnpm tier1-portability-lint`
 * precisely so this import works — one implementation, not a copy that drifts.
 */

import { createClient } from "jsr:@supabase/supabase-js@2";
import { resolvePersona } from "../../../apps/web/src/lib/persona/resolver.ts";
import { EMPTY_SIGNALS } from "../../../apps/web/src/lib/persona/signals.ts";
import type { PersonaSignals } from "../../../apps/web/src/lib/persona/signals.ts";
import { buildExperienceConfig, registryOf } from "../../../apps/web/src/lib/experience/build.ts";
import { TRACK_D_RECORDS } from "../../../apps/web/src/lib/experience/registry/track-d.ts";
import { phaseFor } from "../../../apps/web/src/lib/experience/phase.ts";
import { predictNextPeriod } from "../../../apps/web/src/lib/cycle/predict.ts";
import type { Phase } from "../../../apps/web/src/lib/experience/types.ts";

const REGISTRY = registryOf(TRACK_D_RECORDS);
const ABSENT_AFTER_DAYS = 90;

/** Emotional layers are persona ids; `emotional_context` carries the reasons. */
const CONTEXT_TO_LAYER: Record<string, string> = { prior_loss: "D2" };

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function daysBetween(fromISO: string, toISO: string): number {
  const from = Date.parse(`${fromISO}T00:00:00Z`);
  const to = Date.parse(`${toISO}T00:00:00Z`);
  if (Number.isNaN(from) || Number.isNaN(to)) return 0;
  return Math.round((to - from) / 86_400_000);
}

/**
 * `absent` describes the record, never the woman. A long gap is a gap in what she
 * logged — amenorrhea is a clinical finding and Femio does not make them
 * (product rule 1). This mirrors `signals-from-db.ts` exactly; when the client
 * cache lands, this is the only copy that runs.
 */
function regularityFrom(starts: readonly string[], today: string): PersonaSignals["cycleRegularity"] {
  if (starts.length === 0) return "unknown";
  const sorted = [...starts].sort();
  if (daysBetween(sorted[sorted.length - 1]!, today) > ABSENT_AFTER_DAYS) return "absent";
  const prediction = predictNextPeriod(sorted);
  if (!prediction) return "unknown";
  return prediction.irregular ? "irregular" : "regular";
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });

  const authorization = req.headers.get("Authorization");
  if (!authorization) {
    return new Response(JSON.stringify({ error: "unauthorized" }), {
      status: 401,
      headers: { ...CORS, "Content-Type": "application/json" },
    });
  }

  // The caller's JWT, not the service role — RLS stays the boundary.
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_ANON_KEY")!,
    { global: { headers: { Authorization: authorization } } },
  );

  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return new Response(JSON.stringify({ error: "unauthorized" }), {
      status: 401,
      headers: { ...CORS, "Content-Type": "application/json" },
    });
  }

  /**
   * `today` comes from the caller, not from the server clock.
   *
   * She is the one in a timezone. A server in UTC deciding it is already tomorrow
   * would shift her gestational age by a day, and "how pregnant am I" is not a
   * question to get wrong by rounding. Validated rather than trusted.
   */
  const body = await req.json().catch(() => ({}));
  const today: string = /^\d{4}-\d{2}-\d{2}$/.test(body?.today ?? "")
    ? body.today
    : new Date().toISOString().slice(0, 10);

  const [profile, cycles, conditions, pregnancy, symptoms, state] = await Promise.all([
    supabase.from("profiles").select("age_band").maybeSingle(),
    supabase.from("cycles").select("period_start").order("period_start", { ascending: false }),
    supabase.from("conditions_flagged").select("condition_code, created_at"),
    supabase
      .from("pregnancy")
      .select("status, edd, created_at")
      .order("updated_at", { ascending: false })
      .limit(1)
      .maybeSingle(),
    supabase.from("symptom_logs").select("type").order("logged_at", { ascending: false }).limit(200),
    supabase.from("persona_state").select("track, flags_json").maybeSingle(),
  ]);

  const starts = (cycles.data ?? []).map((c) => c.period_start as string).filter(Boolean).sort();
  const prediction = starts.length > 0 ? predictNextPeriod(starts) : null;

  const conditionRows = (conditions.data ?? []) as { condition_code: string; created_at: string }[];
  const codes = [...new Set(conditionRows.map((r) => r.condition_code))];

  const symptomCounts: Record<string, number> = {};
  for (const row of (symptoms.data ?? []) as { type: string }[]) {
    symptomCounts[row.type] = (symptomCounts[row.type] ?? 0) + 1;
  }

  const pregnancyRow = pregnancy.data as
    | { status: string; edd: string | null; created_at: string }
    | null;

  const diabetesRow = conditionRows.find((r) => r.condition_code === "diabetes");

  const flags = (state.data?.flags_json ?? {}) as Record<string, boolean>;

  const signals: PersonaSignals = {
    ...EMPTY_SIGNALS,
    ageBand: (profile.data?.age_band as PersonaSignals["ageBand"]) ?? null,
    cycleRegularity: regularityFrom(starts, today),
    averageCycleLength: prediction?.averageLength ?? null,
    daysSinceLastPeriod: starts.length > 0 ? daysBetween(starts[starts.length - 1]!, today) : null,
    // Her stated intent, carried on persona_state — never inferred from behaviour.
    ttcIntent: flags.ttc_intent === true,
    pregnancyStatus: pregnancyRow ? (pregnancyRow.status === "active" ? "active" : "ended") : null,
    conditions: codes,
    symptomCounts,
    diabetesRecordedBeforePregnancy: Boolean(
      diabetesRow &&
        pregnancyRow &&
        Date.parse(diabetesRow.created_at) < Date.parse(pregnancyRow.created_at),
    ),
    priorLoss: codes.includes("prior_loss"),
  };

  const resolution = resolvePersona(signals);

  const phase: Phase | null = phaseFor({
    edd: pregnancyRow?.edd ?? null,
    status: pregnancyRow?.status ?? null,
    todayISO: today,
  });

  const config = buildExperienceConfig({
    resolution,
    phase,
    registry: REGISTRY,
    resolvedAt: new Date().toISOString(),
    emotionalLayers: resolution.emotionalContext
      .map((c) => CONTEXT_TO_LAYER[c])
      .filter((id): id is string => Boolean(id)),
  });

  return new Response(JSON.stringify(config), {
    headers: {
      ...CORS,
      "Content-Type": "application/json",
      // Health data: never cached by a proxy, only by the client that owns it.
      "Cache-Control": "private, no-store",
    },
  });
});
