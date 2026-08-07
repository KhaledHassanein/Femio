// Curated symptom/mood taxonomy for logging. Keys are stable (stored in
// symptom_logs.type); labels come from i18n. The full 100+ set is DB/CMS-driven
// (P1.19 translation portal); this curated list plus user-defined custom symptoms
// (the schema accepts any `type`) covers logging today.
export const SYMPTOM_GROUPS = [
  { group: "mood", symptoms: ["happy", "calm", "anxious", "irritable", "sad", "moodSwings", "lowMotivation"] },
  {
    group: "body",
    symptoms: [
      "cramps",
      "headache",
      "bloating",
      "breastTenderness",
      "backache",
      "jointPain",
      "nausea",
      "constipation",
      "diarrhea",
      "fatigue",
      "acne",
      "hotFlashes",
      "spotting",
    ],
  },
  { group: "other", symptoms: ["cravings", "insomnia", "dizziness", "brainFog", "libidoUp", "libidoDown"] },
] as const;

/** Stable set of built-in symptom keys (everything else is a user custom symptom). */
export const KNOWN_SYMPTOMS: ReadonlySet<string> = new Set(SYMPTOM_GROUPS.flatMap((g) => g.symptoms));

// 0 = not set; 1 mild … 4 severe (matches symptom_logs.severity CHECK 0..4).
export const SEVERITY_LEVELS = [1, 2, 3, 4] as const;
export type Severity = (typeof SEVERITY_LEVELS)[number];

export const MAX_CUSTOM_SYMPTOM_LENGTH = 40;

/**
 * Normalize a user-typed custom symptom: trim, collapse whitespace, cap length.
 * Returns null when empty or already present (built-in key or already selected).
 */
export function normalizeCustomSymptom(
  input: string,
  existing: Iterable<string> = [],
): string | null {
  const value = input.trim().replace(/\s+/g, " ").slice(0, MAX_CUSTOM_SYMPTOM_LENGTH);
  if (!value) return null;
  const taken = new Set<string>([...KNOWN_SYMPTOMS, ...existing].map((s) => s.toLowerCase()));
  if (taken.has(value.toLowerCase())) return null;
  return value;
}

/**
 * Timestamp for a symptom logged against a past day (P1.28.3).
 *
 * Returns null for today, so the row keeps the column's `now()` default and the
 * real time of day survives. For an earlier day it returns the instant of **local
 * noon** on that day.
 *
 * Two things this gets right that the obvious versions do not. It is *local*,
 * because the day she tapped is a day in her calendar, not in UTC — a fixed
 * `T12:00:00Z` lands on the following day for UTC+13/+14 and the entry appears
 * under the wrong date, which a first version of this did and a test caught. And
 * it is *noon*, because midnight does not exist on every local date: zones that
 * spring forward at 00:00 (Santiago, Beirut, Havana) skip it, and the timestamp
 * would silently roll into the next day there.
 */
export function loggedAtForDate(date: string, today: string): string | null {
  // No `Z`: parsed in the runtime's zone, which in the browser is hers.
  return date === today ? null : new Date(`${date}T12:00:00`).toISOString();
}

/** Build one insertable row per selected symptom, each carrying its own severity. */
export function buildSymptomRows(
  profileId: string,
  selected: Iterable<[string, Severity | null]>,
  note: string,
  loggedAt: string | null = null,
): Array<{
  profile_id: string;
  type: string;
  severity: Severity | null;
  note: string | null;
  logged_at?: string;
}> {
  return [...selected].map(([type, severity]) => ({
    profile_id: profileId,
    type,
    severity,
    note: note.trim() || null,
    ...(loggedAt ? { logged_at: loggedAt } : {}),
  }));
}
