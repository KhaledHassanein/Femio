import { createClient } from "@/lib/supabase/client";

// Owner-scoped tables to include in a GDPR data export. RLS guarantees only the
// user's own rows are returned.
const EXPORT_TABLES = [
  "profiles",
  "consent_records",
  "cycles",
  "symptom_logs",
  "meds_supplements",
  "conditions_flagged",
  "screener_results",
  "labs",
  "vitals",
  "fertility_logs",
  "pregnancy",
  "appointments",
  "key_dates",
  "persona_state",
  "adaptation_events",
  "subscriptions",
] as const;

export type FemioExport = {
  exportedAt: string;
  profileId: string | null;
  tables: Record<string, unknown[]>;
};

/** Assemble the signed-in user's full record as a plain object (JSON export). */
export async function buildExport(): Promise<FemioExport> {
  const supabase = createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const tables: Record<string, unknown[]> = {};
  for (const table of EXPORT_TABLES) {
    const { data } = await supabase.from(table).select("*");
    tables[table] = data ?? [];
  }

  return { exportedAt: new Date().toISOString(), profileId: user?.id ?? null, tables };
}
