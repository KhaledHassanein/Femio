import { describe, expect, it } from "vitest";

import {
  bandFor,
  coOccurrenceRow,
  patternRows,
  PATTERNS_ENGINE_VERSION,
  severityRow,
  timingRow,
} from "./rows.ts";

const timing = { type: "cramps", days: [2, 3], from: 2, to: 3, cycles: 4, ofCycles: 6 };
const pair = { a: "bloating", b: "cramps", cycles: 4, ofCycles: 6, days: 5, confidence: "medium" } as const;
const trend = {
  type: "headache",
  direction: "higher",
  recentMean: 3.1,
  earlierMean: 2.0,
  recentCycles: 3,
  earlierCycles: 4,
  confidence: "medium",
} as const;

describe("timingRow", () => {
  it("stores an i18n key, never a sentence", () => {
    // The row is read in four languages; English in the database would make it the
    // one part of Femio that cannot be translated.
    expect(timingRow(timing).summary_key).toBe("patterns.timing.summary");
  });

  it("stores the coverage the band came from, not the band", () => {
    expect(timingRow(timing).confidence).toBeCloseTo(4 / 6);
  });

  it("keeps the denominator in the evidence", () => {
    expect(timingRow(timing).evidence_json).toMatchObject({ cycles: 4, ofCycles: 6 });
  });
});

describe("coOccurrenceRow", () => {
  it("keeps the pair alphabetical so the unique index cannot hold it twice", () => {
    const row = coOccurrenceRow(pair);
    expect([row.subject, row.partner_key]).toEqual(["bloating", "cramps"]);
  });
});

describe("severityRow", () => {
  it("writes nothing for a steady trend", () => {
    // The absence of a finding. A row saying "nothing changed" is a notification
    // with no content.
    expect(severityRow({ ...trend, direction: "steady" })).toBeNull();
  });

  it("says higher or lower, never worse", () => {
    const row = severityRow(trend)!;
    expect(row.summary_key).toBe("patterns.severity.higher");
    expect(JSON.stringify(row)).not.toMatch(/worse|abnormal|bad/i);
  });

  it("counts every cycle behind either mean", () => {
    expect(severityRow(trend)!.cycles_used).toBe(7);
  });
});

describe("patternRows", () => {
  it("orders the strongest first across all three kinds", () => {
    const rows = patternRows({
      timing: [{ ...timing, cycles: 3, ofCycles: 6 }],
      coOccurrence: [{ ...pair, cycles: 6, ofCycles: 6 }],
      severity: [trend],
    });
    expect(rows[0]!.kind).toBe("co_occurrence");
    expect(rows.map((r) => r.confidence)).toEqual([...rows.map((r) => r.confidence)].sort((a, b) => b - a));
  });

  it("drops steady trends on the way through", () => {
    const rows = patternRows({ timing: [], coOccurrence: [], severity: [{ ...trend, direction: "steady" }] });
    expect(rows).toHaveLength(0);
  });

  it("stamps every row with the engine version", () => {
    const rows = patternRows({ timing: [timing], coOccurrence: [pair], severity: [trend] });
    expect(rows.every((r) => r.engine_version === PATTERNS_ENGINE_VERSION)).toBe(true);
  });
});

describe("bandFor", () => {
  it("recomputes on read, so a threshold change re-classifies existing rows", () => {
    expect(bandFor({ confidence: 0.9, cycles_used: 6 })).toBe("high");
    // Clean coverage but too few cycles behind it is never `high`.
    expect(bandFor({ confidence: 0.9, cycles_used: 4 })).toBe("medium");
    expect(bandFor({ confidence: 0.4, cycles_used: 9 })).toBe("low");
  });
});

describe("the composition the Edge Function performs", () => {
  // `supabase/functions/patterns/index.ts` is Deno and is not type-checked by CI,
  // so the one thing that could silently break there — feeding the three engines
  // the wrong shape — is exercised here instead. The first draft passed
  // `{type, logged_at}` to `symptomPatterns`, which wants `{type, date}`, and
  // nothing in the repo would have caught it.
  it("feeds one entry shape to all three engines and writes ordered rows", async () => {
    const { symptomPatterns } = await import("../cycle/symptom-patterns.ts");
    const { coOccurrences } = await import("./co-occurrence.ts");
    const { severityTrends } = await import("./severity.ts");

    // Six cycles, cramps and bloating together on day 2 of most of them.
    const periodStarts = [
      "2026-01-01", "2026-01-29", "2026-02-26", "2026-03-26", "2026-04-23", "2026-05-21",
    ];
    const entries = periodStarts.slice(0, 5).flatMap((start) => {
      const day2 = new Date(`${start}T00:00:00Z`);
      day2.setUTCDate(day2.getUTCDate() + 1);
      const date = day2.toISOString().slice(0, 10);
      return [
        { type: "cramps", date, severity: 3 },
        { type: "bloating", date, severity: 2 },
      ];
    });

    const rows = patternRows({
      timing: symptomPatterns(entries, periodStarts),
      coOccurrence: coOccurrences(entries, periodStarts),
      severity: severityTrends(entries, periodStarts),
    });

    expect(rows.length).toBeGreaterThan(0);
    for (const row of rows) {
      expect(row.summary_key.startsWith("patterns.")).toBe(true);
      expect(row.confidence).toBeGreaterThanOrEqual(0);
      expect(row.confidence).toBeLessThanOrEqual(1);
      expect(row.cycles_used).toBeGreaterThan(0);
    }
    expect(rows.map((r) => r.confidence)).toEqual(
      [...rows.map((r) => r.confidence)].sort((a, b) => b - a),
    );
  });
});
