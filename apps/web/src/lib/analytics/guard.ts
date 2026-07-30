/**
 * Runtime guard for analytics payloads.
 *
 * `events.ts` makes an unsafe event un-typeable, but TypeScript is erased at
 * runtime: a value crossing an `any`, a JSON round-trip, or a future refactor can
 * still reach `track()`. This module is the enforcement layer that actually runs.
 * It is pure and synchronous so it can be unit-tested without a browser, a
 * network, or a PostHog key.
 *
 * The posture is allowlist-first: a payload is dropped unless the event name is
 * in the catalog, every property key is declared for that event, and every value
 * is one of that key's enumerated values. The health-term denylist below is a
 * second belt — it can only ever catch what the allowlist has already excluded,
 * but it turns "someone widened an enum carelessly" into a loud failure.
 */

import { EVENT_SCHEMA, FORBIDDEN_AREAS, type EventName } from "./events";

/**
 * Word stems that must never appear in a property key or value, mirroring the
 * special-category fields in docs/compliance/DATA_MAP.md.
 *
 * These are matched against *tokens* (see `tokenize`) with a prefix test, not as
 * raw substrings. Substring matching would be both too loose and too tight here:
 * "age" would fire on "page", "language" and "storage", while `\bsymptom\b`
 * would miss `symptom_type` because an underscore is a word character. Splitting
 * on separators and camelCase and then prefix-matching each token catches
 * `symptomType`, `symptom_type` and `symptoms` while leaving `language` alone.
 */
export const HEALTH_TERM_STEMS = [
  "symptom",
  "cycle",
  "period",
  "menstrual",
  "menses",
  "flow",
  "ovulation",
  "fertile",
  "fertility",
  "pregnan",
  "gestation",
  "postpartum",
  "menopaus",
  "perimenopaus",
  "ttc",
  "conceive",
  "conception",
  "contracept",
  "mood",
  "depress",
  "anxiety",
  "epds",
  "phq",
  "gad",
  "screener",
  "diagnos",
  "condition",
  "persona",
  "medication",
  "dose",
  "dosage",
  "bmi",
  "weight",
  "height",
  "temperature",
  "bbt",
  "crisis",
  "suicide",
  "selfharm",
  "dob",
  "birthdate",
  "birthday",
  "age",
] as const;

/**
 * Stems too short to prefix-match safely, so these are compared as whole tokens.
 * "lab" is the motivating case: as a prefix it fires on "label", a word any UI
 * uses constantly. Tokenization still catches the real targets, because
 * `lab_result` and `labValue` both split to a bare `lab` token.
 */
export const HEALTH_TERM_EXACT = ["lab", "labs"] as const;

export type GuardResult =
  | { ok: true; name: EventName; props: Record<string, string> }
  | { ok: false; reason: string };

/** Lowercased word tokens, splitting on separators and camelCase boundaries. */
export function tokenize(value: string): string[] {
  return value
    .replace(/([a-z0-9])([A-Z])/g, "$1 $2")
    .split(/[^a-zA-Z0-9]+/)
    .filter(Boolean)
    .map((token) => token.toLowerCase());
}

/** The offending term, if any token prefix-matches a stem or equals an exact term. */
export function findHealthTerm(value: string): string | undefined {
  const tokens = tokenize(value);
  return (
    HEALTH_TERM_STEMS.find((stem) => tokens.some((token) => token.startsWith(stem))) ??
    HEALTH_TERM_EXACT.find((term) => tokens.includes(term))
  );
}

/**
 * Validates an event against the catalog. Returns the sanitized payload, or the
 * reason it was rejected. Never throws — an analytics bug must not take down a
 * page, so callers drop rejected events (and surface the reason in development).
 */
export function guardEvent(name: string, props: Record<string, unknown> = {}): GuardResult {
  if (!Object.hasOwn(EVENT_SCHEMA, name)) {
    return { ok: false, reason: `unknown event "${name}" (not in the catalog)` };
  }
  const eventName = name as EventName;
  const schema = EVENT_SCHEMA[eventName] as Record<string, readonly string[]>;

  const declared = Object.keys(schema);
  const given = Object.keys(props);

  const extra = given.filter((key) => !declared.includes(key));
  if (extra.length > 0) {
    return { ok: false, reason: `event "${name}" got undeclared propert(ies): ${extra.join(", ")}` };
  }

  const missing = declared.filter((key) => !given.includes(key));
  if (missing.length > 0) {
    return { ok: false, reason: `event "${name}" is missing propert(ies): ${missing.join(", ")}` };
  }

  const clean: Record<string, string> = {};
  for (const key of declared) {
    const value = props[key];
    if (typeof value !== "string") {
      // Only enumerated strings exist in the schema, so a non-string is always a
      // caller bug — and is exactly how a raw number (a lab value, a timestamp)
      // would otherwise slip through.
      return { ok: false, reason: `"${name}.${key}" must be a string, got ${typeof value}` };
    }
    const allowed = schema[key];
    if (!allowed?.includes(value)) {
      return { ok: false, reason: `"${name}.${key}" has non-allowlisted value "${value}"` };
    }
    if (Object.hasOwn(FORBIDDEN_AREAS, value)) {
      return { ok: false, reason: `"${value}" must never be measured: ${FORBIDDEN_AREAS[value]}` };
    }
    const keyTerm = findHealthTerm(key);
    if (keyTerm) {
      return { ok: false, reason: `"${name}.${key}" looks like health data ("${keyTerm}")` };
    }
    const valueTerm = findHealthTerm(value);
    if (valueTerm) {
      return { ok: false, reason: `"${name}.${key}" value looks like health data ("${valueTerm}")` };
    }
    clean[key] = value;
  }

  return { ok: true, name: eventName, props: clean };
}
