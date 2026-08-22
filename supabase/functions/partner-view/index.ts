/**
 * `partner-view` — what a recipient of a partner share is shown (Phase 4.5).
 *
 * Design: `docs/compliance/PARTNER_SHARING_DESIGN.md`. Schema and the reasoning
 * behind the two database functions: `supabase/migrations/0011_partner_sharing.sql`.
 *
 * ## Why this exists at all, rather than a client read
 *
 * A partner granted `nextPeriod` and not `cycleDates` is entitled to a predicted
 * window and **not** to the start dates it is derived from. There is nowhere in his
 * browser that can hold that distinction: whatever the client is sent, the client's
 * owner can read. So the derivation happens here, on the far side of a boundary he
 * cannot see past, and only the granted categories are serialised into the reply.
 *
 * ## The three properties this file must not lose
 *
 * 1. **A withheld category is absent, not empty.** Keys are added only for
 *    categories in `scope`. No `symptoms: []`, no `symptoms: null`, no
 *    `hidden: ["symptoms"]`. His view must be identical to one in which Femio has
 *    no symptom feature at all (design §3) — otherwise granular sharing produces a
 *    map of what she chose to conceal, which is more dangerous than sharing
 *    everything.
 * 2. **Revocation is silent.** A revoked, expired or never-created share all
 *    produce the same thing: a share that is simply not in the array. There is no
 *    "access removed" state to render and no field that could carry one.
 * 3. **Nothing medical is computed twice.** The window and the phase come from
 *    `lib/cycle/predict.ts` and `lib/cycle/phases.ts` — the same tier-2 modules the
 *    dashboard runs, held importable by `pnpm tier1-portability-lint` and bound to
 *    their future Dart twins by the golden fixtures. He sees the window she sees
 *    because it is the same code, not because two implementations agree today.
 *
 * ## The service role, used here and nowhere else in a request path
 *
 * `experience` runs on the caller's own JWT because RLS is a sufficient boundary
 * for reading your own record. This function cannot: it reads *her* rows for *him*,
 * under a grant RLS has no way to express without also handing him the scope. So it
 * holds the service key, calls exactly one function with it —
 * `partner_shared_rows(recipient)` — and passes the recipient id it got from
 * verifying his JWT with the anon client first. The service key never touches a
 * table directly and never sees an id the caller did not prove.
 */

import { createClient } from "jsr:@supabase/supabase-js@2";
import { predictNextPeriod } from "../../../apps/web/src/lib/cycle/predict.ts";
import { phaseOnDay } from "../../../apps/web/src/lib/cycle/phases.ts";
import { pregnancyProgress } from "../../../apps/web/src/lib/pregnancy/index.ts";
import { diffDays, isValidISODate } from "../../../apps/web/src/lib/calculators/dates.ts";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

/** How many of her period start dates `cycleDates` shows. Recent, not the archive. */
const RECENT_STARTS = 6;

type Row = {
  id: string;
  scope: Record<string, boolean>;
  data: {
    expiresAt: string;
    cycleStarts?: string[];
    statedCycleLength?: number | null;
    pregnancy?: { edd: string | null; status: string } | null;
    symptoms?: { type: string; loggedAt: string }[];
    medications?: { name: string }[];
    fertility?: { loggedAt: string; opk: string | null }[];
  };
};

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: {
      ...CORS,
      "Content-Type": "application/json",
      // Someone else's health data. Never a proxy cache, never a disk cache.
      "Cache-Control": "private, no-store",
    },
  });

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });

  const authorization = req.headers.get("Authorization");
  if (!authorization) return json({ error: "unauthorized" }, 401);

  // Step one: prove who is asking, on his own JWT and nothing else.
  const asCaller = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_ANON_KEY")!,
    { global: { headers: { Authorization: authorization } } },
  );
  const {
    data: { user },
  } = await asCaller.auth.getUser();
  if (!user) return json({ error: "unauthorized" }, 401);

  /**
   * `today` comes from the caller, for the same reason `experience` takes it: he is
   * in a timezone and a server in UTC deciding it is already tomorrow would move
   * her cycle day. Validated rather than trusted.
   */
  const body = await req.json().catch(() => ({}));
  const today: string = /^\d{4}-\d{2}-\d{2}$/.test(body?.today ?? "")
    ? body.today
    : new Date().toISOString().slice(0, 10);

  // Step two: the one privileged call, for the id proved in step one.
  const asService = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );
  const { data, error } = await asService.rpc("partner_shared_rows", { recipient: user.id });
  if (error) return json({ error: "unavailable" }, 503);

  const shares = (data ?? []) as Row[];

  const view = shares.map((share) => {
    const scope = share.scope ?? {};
    const raw = share.data ?? { expiresAt: "" };
    const starts = (raw.cycleStarts ?? []).filter(isValidISODate);

    // Derived once, emitted only where granted. A partner with `phase` and without
    // `nextPeriod` still gets a phase computed from the same prediction — which is
    // the point of deriving before deciding what to serialise.
    const prediction = predictNextPeriod(starts, raw.statedCycleLength ?? null);

    const out: Record<string, unknown> = { id: share.id, expiresAt: raw.expiresAt };

    if (scope.nextPeriod && prediction) {
      out.nextPeriod = {
        windowStart: prediction.windowStart,
        windowEnd: prediction.windowEnd,
        confidence: prediction.confidence,
        learning: prediction.learning,
        irregular: prediction.irregular,
      };
    } else if (scope.nextPeriod) {
      // She shared it and there is nothing to predict yet. This is not the
      // withheld case: the key exists because she granted it, and the client
      // renders it as "Femio does not have enough to go on" — the same sentence
      // her own dashboard shows her.
      out.nextPeriod = null;
    }

    if (scope.cycleDates) {
      out.cycleDates = [...starts].sort().reverse().slice(0, RECENT_STARTS);
    }

    if (scope.phase) {
      /**
       * `currentCycleDay` lives in `lib/cycle/insights.ts`, which imports through
       * the `@/` alias and so cannot be resolved by Deno. Rather than add a second
       * alias-free copy of a four-line function, the day is taken here from
       * `diffDays` — the portable helper that one *also* calls — so there is still
       * exactly one implementation of the subtraction.
       */
      const last = starts.length > 0 ? [...starts].sort().at(-1)! : null;
      const cycleDay = last && diffDays(last, today) >= 0 ? diffDays(last, today) + 1 : null;
      const phase =
        cycleDay && prediction
          ? phaseOnDay({
              cycleDay,
              cycleLength: prediction.averageLength,
              irregular: prediction.irregular,
            })
          : null;
      // `null` is a real answer here and the client renders it as one: an irregular
      // or too-short cycle gets "Femio will not guess a phase", never a default.
      out.phase = { phase, cycleDay };
    }

    if (scope.pregnancy) {
      const edd = raw.pregnancy?.edd ?? null;
      const active = raw.pregnancy?.status === "active";
      const progress = active && edd ? pregnancyProgress(edd, today) : null;
      out.pregnancy = progress ? { weeks: progress.weeks, days: progress.days, edd } : null;
    }

    if (scope.symptoms) out.symptoms = raw.symptoms ?? [];
    if (scope.medications) out.medications = (raw.medications ?? []).map((m) => m.name);
    if (scope.fertility) out.fertility = raw.fertility ?? [];

    return out;
  });

  return json({ shares: view });
});
