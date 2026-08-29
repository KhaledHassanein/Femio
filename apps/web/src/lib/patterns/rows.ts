import { CONFIDENCE_RANK, type PatternConfidence } from "./confidence.ts";
import type { CoOccurrence } from "./co-occurrence.ts";
import type { SeverityTrend } from "./severity.ts";
import type { SymptomPattern } from "../cycle/symptom-patterns.ts";

/**
 * Engine findings as `patterns` rows (D2, migration `0019`).
 *
 * The three pattern modules each return their own shape, and until now those
 * shapes only ever reached a screen. `0019` exists so a finding can also reach the
 * **home surface and the visit pack**, which means it has to survive being written
 * down — and *how* it is written down is a decision two clients must not make
 * differently. So the mapping is tier 2, pure and tested, and both the Edge
 * Function and a future Dart twin call this rather than each shaping a row.
 *
 * ## `summary_key`, never a sentence
 *
 * `0019`'s own comment: the row is read in four languages, so what is stored is an
 * i18n key and the numbers behind it. Storing English would make the database the
 * one place in Femio that cannot be translated.
 *
 * ## Confidence is stored as the coverage it came from
 *
 * The column is `numeric 0..1` while the engine speaks in `low | medium | high`.
 * Storing the band as a number would invent precision; storing the **coverage
 * ratio the band was derived from** stores what was actually measured, and the
 * band is recomputed on read. That way a later change to the thresholds
 * re-classifies existing rows instead of leaving them frozen at whatever the
 * thresholds were on the day they were written.
 *
 * ## What is deliberately not here
 *
 * No cause, no projection, no "worse". Severity moves **higher** or **lower** —
 * a fact about her entries rather than a judgement about her health (`docs/09`
 * invariant 7). A `steady` trend is not written at all: it is the absence of a
 * finding, and a row saying "nothing changed" is a notification with no content.
 */

/** Bumped when a mapping or a threshold changes, so stale rows are identifiable. */
export const PATTERNS_ENGINE_VERSION = "d2.1";

export type PatternRow = {
  kind: "timing" | "co_occurrence" | "severity_trend";
  subject: string;
  partner_key: string | null;
  summary_key: string;
  evidence_json: Record<string, number | string>;
  confidence: number;
  cycles_used: number;
  engine_version: string;
};

/** Coverage, clamped — the denominator is never allowed to produce a value above 1. */
function coverage(cycles: number, ofCycles: number): number {
  if (!Number.isFinite(cycles) || !Number.isFinite(ofCycles) || ofCycles <= 0) return 0;
  return Math.min(1, Math.max(0, cycles / ofCycles));
}

export function timingRow(p: SymptomPattern): PatternRow {
  return {
    kind: "timing",
    subject: p.type,
    partner_key: null,
    summary_key: "patterns.timing.summary",
    // `from`/`to` rather than the full day list: the claim is the run, and the
    // list is what the run was derived from. The screen may show more; the row
    // carries what the sentence needs.
    evidence_json: { from: p.from, to: p.to, cycles: p.cycles, ofCycles: p.ofCycles },
    confidence: coverage(p.cycles, p.ofCycles),
    cycles_used: p.ofCycles,
    engine_version: PATTERNS_ENGINE_VERSION,
  };
}

export function coOccurrenceRow(c: CoOccurrence): PatternRow {
  return {
    kind: "co_occurrence",
    // Already alphabetical from the engine, and kept that way: the unique index is
    // on (kind, subject, partner_key), so swapping the pair would write the same
    // finding twice under two keys.
    subject: c.a,
    partner_key: c.b,
    summary_key: "patterns.together.summary",
    evidence_json: { cycles: c.cycles, ofCycles: c.ofCycles, days: c.days },
    confidence: coverage(c.cycles, c.ofCycles),
    cycles_used: c.ofCycles,
    engine_version: PATTERNS_ENGINE_VERSION,
  };
}

/** `null` for a steady trend — see the header. */
export function severityRow(t: SeverityTrend): PatternRow | null {
  if (t.direction === "steady") return null;
  const ofCycles = t.recentCycles + t.earlierCycles;
  return {
    kind: "severity_trend",
    subject: t.type,
    partner_key: null,
    summary_key: `patterns.severity.${t.direction}`,
    evidence_json: {
      direction: t.direction,
      recentMean: t.recentMean,
      earlierMean: t.earlierMean,
      recentCycles: t.recentCycles,
      earlierCycles: t.earlierCycles,
    },
    // A trend rests on every cycle that fed either mean, so coverage is 1 by
    // construction — which would be a meaningless "certain". The confidence band
    // the engine already assigned is what carries the information here, mapped
    // back onto the numeric column at the midpoint of its range.
    confidence: BAND_MIDPOINT[t.confidence],
    cycles_used: ofCycles,
    engine_version: PATTERNS_ENGINE_VERSION,
  };
}

/**
 * Where a band sits on the 0..1 column when there is no ratio to store.
 *
 * Only `severity_trend` needs this. It is a lossy write and it is labelled as one:
 * the number exists so the column has a value and so ordering works, not so anyone
 * reads a percentage off it. Nothing renders `confidence` as a figure — `0019`
 * says it is shown through `--confidence-*` and never as a percentage badge.
 */
const BAND_MIDPOINT: Record<PatternConfidence, number> = {
  low: 0.35,
  medium: 0.65,
  high: 0.9,
};

/**
 * Every finding, ordered so the strongest is first.
 *
 * One ordering for all three kinds, because a home surface showing two findings
 * must not put a `medium` above a `high` merely because timing was computed first
 * — the reason `CONFIDENCE_RANK` was exported in the first place.
 */
export function patternRows(input: {
  timing: readonly SymptomPattern[];
  coOccurrence: readonly CoOccurrence[];
  severity: readonly SeverityTrend[];
}): PatternRow[] {
  const rows = [
    ...input.timing.map(timingRow),
    ...input.coOccurrence.map(coOccurrenceRow),
    ...input.severity.map(severityRow).filter((r): r is PatternRow => r !== null),
  ];
  return rows.sort((a, b) => b.confidence - a.confidence);
}

/** The band, recomputed on read rather than trusted from the row. See the header. */
export function bandFor(row: { confidence: number; cycles_used: number }): PatternConfidence {
  if (row.confidence >= 0.8 && row.cycles_used >= 5) return "high";
  if (row.confidence >= 0.5) return "medium";
  return "low";
}

export { CONFIDENCE_RANK };
