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

/** Build one insertable row per selected symptom, each carrying its own severity. */
export function buildSymptomRows(
  profileId: string,
  selected: Iterable<[string, Severity | null]>,
  note: string,
): Array<{ profile_id: string; type: string; severity: Severity | null; note: string | null }> {
  return [...selected].map(([type, severity]) => ({
    profile_id: profileId,
    type,
    severity,
    note: note.trim() || null,
  }));
}
