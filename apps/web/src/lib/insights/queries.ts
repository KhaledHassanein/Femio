import { createClient } from "@/lib/supabase/server";
import { suppressBuckets, suppressCount, type Bucket, type Count } from "./k-anon";

/**
 * Server-side reads for the first-party insights dashboard (P1.20.3).
 *
 * Everything comes from the aggregate-only RPCs in migration 0006 — this file
 * never selects a row from a health table, and could not: RLS would return
 * nothing, which is the point. Each call degrades gracefully, because the
 * migration is applied by hand (runbook A3) and a missing function must show an
 * explanation, not a stack trace.
 */

export const DIMENSIONS = ["mode", "persona", "age_band", "locale", "account_type"] as const;
export type Dimension = (typeof DIMENSIONS)[number];

export type OverviewMetric =
  | "total_users"
  | "registered_users"
  | "anonymous_users"
  | "onboarded_users"
  | "active_28d";

export type RetentionRow = {
  cohort: string;
  cohort_size: Count;
  month_1: Count;
  month_2: Count;
};

/** Why a dashboard has no data — each needs a different thing said to staff. */
export type InsightsStatus = "ok" | "not_installed" | "not_authorized" | "error";

export type InsightsData = {
  status: InsightsStatus;
  overview: Partial<Record<OverviewMetric, Count>>;
  breakdowns: Record<Dimension, Bucket[]>;
  retention: RetentionRow[];
};

const EMPTY_BREAKDOWNS = {
  mode: [],
  persona: [],
  age_band: [],
  locale: [],
  account_type: [],
} satisfies Record<Dimension, Bucket[]>;

/** Postgres/PostgREST codes for "that function isn't there (yet)". */
function isMissingFunction(code?: string): boolean {
  return code === "42883" || code === "PGRST202";
}

export async function loadInsights(): Promise<InsightsData> {
  const supabase = await createClient();
  const empty: InsightsData = {
    status: "ok",
    overview: {},
    breakdowns: { ...EMPTY_BREAKDOWNS },
    retention: [],
  };

  const overviewRes = await supabase.rpc("insights_overview");
  if (overviewRes.error) {
    const code = overviewRes.error.code;
    return {
      ...empty,
      status: isMissingFunction(code)
        ? "not_installed"
        : code === "42501"
          ? "not_authorized"
          : "error",
    };
  }

  const overview: Partial<Record<OverviewMetric, Count>> = {};
  for (const row of (overviewRes.data ?? []) as { metric: string; value: number | null }[]) {
    overview[row.metric as OverviewMetric] = suppressCount(row.value);
  }

  const breakdowns = { ...EMPTY_BREAKDOWNS } as Record<Dimension, Bucket[]>;
  for (const dimension of DIMENSIONS) {
    const { data, error } = await supabase.rpc("insights_by_dimension", { dimension });
    breakdowns[dimension] = error ? [] : suppressBuckets((data ?? []) as Bucket[]);
  }

  const retentionRes = await supabase.rpc("insights_retention", { months: 6 });
  const retention = retentionRes.error
    ? []
    : ((retentionRes.data ?? []) as RetentionRow[]).map((r) => ({
        ...r,
        cohort_size: suppressCount(r.cohort_size),
        month_1: suppressCount(r.month_1),
        month_2: suppressCount(r.month_2),
      }));

  return { status: "ok", overview, breakdowns, retention };
}
