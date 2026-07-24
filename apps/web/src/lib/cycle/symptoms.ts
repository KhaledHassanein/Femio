// Curated symptom/mood taxonomy for logging v1. Keys are stable (stored in
// symptom_logs.type); labels come from i18n. Extend the list — or move it to the
// CMS/DB — as the library grows (P1.14.1); the schema already accepts any type.
export const SYMPTOM_GROUPS = [
  { group: "mood", symptoms: ["happy", "calm", "anxious", "irritable", "sad"] },
  {
    group: "body",
    symptoms: ["cramps", "headache", "bloating", "breastTenderness", "backache", "nausea", "fatigue", "acne"],
  },
  { group: "other", symptoms: ["cravings", "insomnia", "dizziness"] },
] as const;

// 0 = not set; 1 mild … 4 severe (matches symptom_logs.severity CHECK 0..4).
export const SEVERITY_LEVELS = [1, 2, 3, 4] as const;
export type Severity = (typeof SEVERITY_LEVELS)[number];
