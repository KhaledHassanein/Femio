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
 * - **No derivation of its own.** Rows in, `signalsFromRows` out. This file used to
 *   carry a hand-copied version of that derivation "mirroring `signals-from-db.ts`
 *   exactly", and it had already stopped matching — the browser hard-coded
 *   `ttcIntent` to false while this side read it from `flags_json`. A comment cannot
 *   hold two implementations together, so now there is one.
 *
 * ## Imports
 *
 * The tier-1 modules are imported straight from `apps/web/src`, relative. They are
 * held framework-free, data-free and alias-free by `pnpm tier1-portability-lint`
 * precisely so this import works — one implementation, not a copy that drifts.
 */

import { createClient } from "jsr:@supabase/supabase-js@2";
import { resolveForStatedTrack } from "../../../apps/web/src/lib/persona/resolver.ts";
import type { Track } from "../../../apps/web/src/lib/persona/resolver.ts";
import { signalsFromRows } from "../../../apps/web/src/lib/persona/signals-from-rows.ts";
import { buildExperienceConfig, registryOf } from "../../../apps/web/src/lib/experience/build.ts";
import { PERSONA_RECORDS } from "../../../apps/web/src/lib/experience/registry/index.ts";
import { phaseForTrack } from "../../../apps/web/src/lib/experience/phase.ts";
import { emotionalLayersFor } from "../../../apps/web/src/lib/experience/layers.ts";

const REGISTRY = registryOf(PERSONA_RECORDS);

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

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

  // The same six queries `readPersonaRows` runs in the browser.
  const [profile, cycles, conditions, pregnancy, symptoms, state] = await Promise.all([
    supabase.from("profiles").select("age_band").maybeSingle(),
    supabase.from("cycles").select("period_start").order("period_start", { ascending: false }),
    supabase.from("conditions_flagged").select("condition_code, created_at"),
    supabase
      .from("pregnancy")
      .select("status, edd, created_at, updated_at")
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
  const statedTrack = ((state.data?.track as string | null) ?? null) as Track | null;

  const signals = signalsFromRows({
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
    // Her stated intent, carried on persona_state — never inferred from behaviour.
    ttcIntent: flags.ttc_intent === true,
    todayISO: today,
  });

  // Her stated stage wins the track; the resolver refines within it (R2.6).
  const resolution = resolveForStatedTrack(signals, statedTrack);

  const phase = phaseForTrack(statedTrack, {
    edd: pregnancyRow?.edd ?? null,
    status: pregnancyRow?.status ?? null,
    todayISO: today,
  });

  const config = buildExperienceConfig({
    resolution,
    phase,
    registry: REGISTRY,
    resolvedAt: new Date().toISOString(),
    emotionalLayers: emotionalLayersFor(resolution.track, resolution.emotionalContext),
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
