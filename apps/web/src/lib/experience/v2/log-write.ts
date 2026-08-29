import { LOG_TERMS, type LogDimension, type LogTerm } from "./vocabulary.ts";

/**
 * Where each logged term is stored (RB-C6, `docs/29_REBUILD/06` §3).
 *
 * The log screen is one surface over **four** tables, and which table a term
 * belongs to is decided by its dimension. That mapping is logic, not layout — the
 * Dart client needs exactly the same answer — so it lives here, pure and tested,
 * rather than inside the screen.
 *
 * | Dimension | Table | Column |
 * |---|---|---|
 * | `symptom`, `mood` | `symptom_logs` | `type`, `severity` |
 * | `discharge` | `fertility_logs` | `cm_type` |
 * | `intercourse` | `fertility_logs` | `intercourse` |
 * | `vital` | `vitals` | `type`, `value`, `unit` |
 *
 * ## No `dimension` column, deliberately
 *
 * A term's dimension is a property of the vocabulary, not of the entry: `cramps`
 * is a symptom in every row that will ever hold it. Storing it alongside would
 * denormalise a constant and create a second place for the vocabulary to be
 * wrong — and the tables already separate the dimensions that matter.
 *
 * ## Two dimensions are single-select, because the column is singular
 *
 * `fertility_logs.cm_type` is one text column and `intercourse` is one boolean.
 * A day has one cervical-mucus observation, which is also how the literature
 * treats it. The screen enforces this rather than letting a user select three and
 * silently keeping one — a save that quietly drops input is the failure this
 * whole chapter exists to avoid.
 *
 * ## Vitals are values, not presence
 *
 * A chip cannot log a weight. Vitals carry a number and a unit, so the screen
 * gives them fields instead of chips, and a field left empty writes nothing. This
 * is the first writer `public.vitals` has ever had — the table has existed since
 * schema v1 (`0001`) and CLAUDE.md has listed it as unused since.
 */

/** Dimensions where a day holds exactly one answer. */
export function isSingleSelect(dimension: LogDimension): boolean {
  return dimension === "discharge";
}

/** Canonical unit per vital, so a stored number is never ambiguous. */
export const VITAL_UNITS: Readonly<Record<string, string>> = {
  weight: "kg",
  glucose: "mmol/L",
  bp_sys: "mmHg",
  bp_dia: "mmHg",
  temp_body: "°C",
  resting_hr: "bpm",
  hrv: "ms",
  sleep_minutes: "min",
  steps: "count",
};

export type SymptomRow = {
  profile_id: string;
  type: string;
  severity: number | null;
  logged_at: string;
};

export type FertilityRow = {
  profile_id: string;
  logged_at: string;
  cm_type: string | null;
  intercourse: boolean | null;
};

export type VitalRow = {
  profile_id: string;
  type: string;
  value: number;
  unit: string;
  measured_at: string;
};

export type LogDraft = {
  /** Term key → severity, or `null` for selected-without-a-level. */
  selected: ReadonlyMap<string, number | null>;
  /** Vital key → the raw string from its field. Blank and unparseable are skipped. */
  vitals: Readonly<Record<string, string>>;
};

export type LogWrites = {
  symptomLogs: readonly SymptomRow[];
  fertilityLog: FertilityRow | null;
  vitals: readonly VitalRow[];
};

/**
 * Turn a day's draft into the rows each table needs.
 *
 * Total: an unknown term key is ignored rather than thrown on, because a stale
 * client holding a key a later vocabulary removed must still be able to save the
 * rest of her day.
 */
export function buildLogWrites(
  profileId: string,
  date: string,
  draft: LogDraft,
  terms: readonly LogTerm[] = LOG_TERMS,
): LogWrites {
  const byKey = new Map(terms.map((t) => [t.key, t]));

  const symptomLogs: SymptomRow[] = [];
  let cmType: string | null = null;
  let intercourse: boolean | null = null;

  for (const [key, severity] of draft.selected) {
    const term = byKey.get(key);
    if (!term) continue;
    switch (term.dimension) {
      case "symptom":
      case "mood":
        symptomLogs.push({
          profile_id: profileId,
          type: key,
          // Presence-only terms never carry a level, and a selected chip that was
          // never cycled stays `null`. A default here would be Femio inventing a
          // number and then feeding it to a trend.
          severity: term.severityScale ? severity : null,
          logged_at: date,
        });
        break;
      case "discharge":
        cmType = key;
        break;
      case "intercourse":
        intercourse = true;
        break;
      case "vital":
        // Selected-ness is meaningless for a measurement; only `draft.vitals` counts.
        break;
    }
  }

  const vitals: VitalRow[] = [];
  for (const [key, raw] of Object.entries(draft.vitals)) {
    const term = byKey.get(key);
    if (!term || term.dimension !== "vital") continue;
    const trimmed = raw.trim();
    if (trimmed.length === 0) continue;
    const value = Number(trimmed);
    // `Number("")` is 0 and `Number("12kg")` is NaN — both must be rejected, or a
    // typo becomes a data point in a chart she will later be shown.
    if (!Number.isFinite(value)) continue;
    vitals.push({
      profile_id: profileId,
      type: key,
      value,
      unit: VITAL_UNITS[key] ?? "",
      measured_at: `${date}T12:00:00.000Z`,
    });
  }

  return {
    symptomLogs,
    // A fertility row is written only when there is something in it. An all-null
    // row would claim she recorded a day on which she recorded nothing.
    fertilityLog:
      cmType !== null || intercourse !== null
        ? { profile_id: profileId, logged_at: date, cm_type: cmType, intercourse }
        : null,
    vitals,
  };
}

/** Whether a draft would write anything at all — the Save button's enabled state. */
export function hasAnything(writes: LogWrites): boolean {
  return writes.symptomLogs.length > 0 || writes.fertilityLog !== null || writes.vitals.length > 0;
}
