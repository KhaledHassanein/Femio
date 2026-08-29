/**
 * `patterns` — tier 1, the only thing permitted to write a finding (D2, `0019`).
 *
 * `0019` revokes `insert` on `public.patterns` from `authenticated` and says why:
 * *a client that can write a pattern can write "your headaches cluster before your
 * period" into her record without any data behind it.* So the engine runs here.
 *
 * ## Two clients, deliberately, and why this one is not like `experience`
 *
 * `experience` runs entirely on the caller's JWT, because it only reads. This one
 * has to insert into a table the caller may not insert into, so it uses **both**:
 *
 * - **The caller's JWT** to identify her *and* to read her logs. RLS is still what
 *   stops this function reading somebody else's record — a bug here cannot widen
 *   its own reach, because the database refuses.
 * - **The service role**, for the write alone, scoped to the `profile_id` that came
 *   back from verifying that same JWT. It is never used to read and never takes a
 *   profile id from the request body, which is the shape that would turn this into
 *   "write a finding into any woman's record".
 *
 * ## It computes nothing of its own
 *
 * Every threshold, every denominator and the row mapping come from `lib/patterns`,
 * imported straight from `apps/web/src` and held portable by
 * `tier1-portability-lint`. `experience`'s header records what happens otherwise:
 * a hand-copied derivation that had *already* drifted from the browser's. One
 * implementation, or eventually two answers.
 *
 * ## Dismissal survives recomputation
 *
 * The upsert deliberately does not touch `dismissed_at`. A finding she has read and
 * put away must not come back because the engine ran again — `0019` calls that
 * *the specific thing that makes a competitor's repeating insight cards tiresome*,
 * and an upsert that reset the column would reintroduce it on a schedule.
 */

import { createClient } from "jsr:@supabase/supabase-js@2";
import { symptomPatterns } from "../../../apps/web/src/lib/cycle/symptom-patterns.ts";
import { coOccurrences } from "../../../apps/web/src/lib/patterns/co-occurrence.ts";
import { severityTrends } from "../../../apps/web/src/lib/patterns/severity.ts";
import { patternRows } from "../../../apps/web/src/lib/patterns/rows.ts";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { ...CORS, "Content-Type": "application/json" },
  });

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });

  const authorization = req.headers.get("Authorization");
  if (!authorization) return json({ error: "unauthorized" }, 401);

  // Reads run as her. RLS stays the boundary.
  const asUser = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_ANON_KEY")!,
    { global: { headers: { Authorization: authorization } } },
  );

  const {
    data: { user },
  } = await asUser.auth.getUser();
  if (!user) return json({ error: "unauthorized" }, 401);

  const [cycles, logs] = await Promise.all([
    asUser.from("cycles").select("period_start").order("period_start"),
    asUser
      .from("symptom_logs")
      .select("type, severity, logged_at")
      .order("logged_at", { ascending: false })
      .limit(2000),
  ]);

  if (cycles.error || logs.error) return json({ error: "read-failed" }, 502);

  const periodStarts = ((cycles.data ?? []) as { period_start: string }[]).map(
    (c) => c.period_start,
  );
  const rawLogs = (logs.data ?? []) as {
    type: string;
    severity: number | null;
    logged_at: string;
  }[];

  // The engine's own shapes. `logged_at` is a timestamp on this table and every
  // pattern module works in whole days, so it is truncated once, here, rather than
  // three times inconsistently downstream.
  const entries = rawLogs.map((l) => ({
    type: l.type,
    date: l.logged_at.slice(0, 10),
    severity: l.severity,
  }));

  // One shape feeds all three: `SymptomLog` is `{type, date}` and `Entry` is that
  // plus an optional severity, so `entries` satisfies both. Building a second
  // shape per engine is how a field gets renamed in one place and not the other.
  const rows = patternRows({
    timing: symptomPatterns(entries, periodStarts),
    coOccurrence: coOccurrences(entries, periodStarts),
    severity: severityTrends(entries, periodStarts),
  });

  if (rows.length === 0) return json({ written: 0, patterns: [] });

  // The write, and only the write. Scoped to the verified user — never to an id
  // from the request body.
  const asService = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const { error } = await asService
    .from("patterns")
    .upsert(
      rows.map((r) => ({ ...r, profile_id: user.id, computed_at: new Date().toISOString() })),
      // Matches the unique index in `0019`. `dismissed_at` is absent from the
      // payload, so an existing row keeps hers.
      { onConflict: "profile_id,kind,subject,partner_key", ignoreDuplicates: false },
    );

  if (error) return json({ error: "write-failed", detail: error.message }, 500);

  return json({ written: rows.length, patterns: rows });
});
