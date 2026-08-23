import { describe, expect, it } from "vitest";
import { MIN_CYCLES, confidenceFrom } from "./confidence";
import { coOccurrences } from "./co-occurrence";
import { MIN_SHIFT, RECENT_CYCLES, severityTrends } from "./severity";
import type { Entry } from "./cycles";

/** Period starts every 28 days, most recent last. `n` complete cycles needs n+1 starts. */
function starts(n: number, from = "2026-01-05"): string[] {
  const base = new Date(`${from}T00:00:00Z`);
  return Array.from({ length: n + 1 }, (_, i) => {
    const d = new Date(base);
    d.setUTCDate(d.getUTCDate() + i * 28);
    return d.toISOString().slice(0, 10);
  });
}

/** A log on `day` (1-based) of cycle `cycle` (0-based) in the schedule above. */
function on(cycle: number, day: number, type: string, severity?: number): Entry {
  const d = new Date("2026-01-05T00:00:00Z");
  d.setUTCDate(d.getUTCDate() + cycle * 28 + (day - 1));
  return { type, date: d.toISOString().slice(0, 10), severity };
}

describe("confidence", () => {
  it("says nothing at all below the floor", () => {
    expect(confidenceFrom({ cycles: 2, ofCycles: 6 })).toBeNull();
    expect(confidenceFrom({ cycles: MIN_CYCLES, ofCycles: 2 })).toBeNull();
  });

  /**
   * The guard against the thing that makes patterns dangerous: three clean cycles
   * look like a rule and are not one. `high` needs volume as well as coverage.
   */
  it("refuses to call three-for-three high, however clean", () => {
    expect(confidenceFrom({ cycles: 3, ofCycles: 3 })).toBe("medium");
    expect(confidenceFrom({ cycles: 5, ofCycles: 5 })).toBe("high");
  });

  it("scales with coverage", () => {
    expect(confidenceFrom({ cycles: 3, ofCycles: 10 })).toBe("low");
    expect(confidenceFrom({ cycles: 6, ofCycles: 10 })).toBe("medium");
    expect(confidenceFrom({ cycles: 9, ofCycles: 10 })).toBe("high");
  });

  it("refuses impossible evidence rather than clamping it", () => {
    expect(confidenceFrom({ cycles: 8, ofCycles: 5 })).toBeNull();
    expect(confidenceFrom({ cycles: NaN, ofCycles: 5 })).toBeNull();
  });
});

describe("co-occurrence", () => {
  const both = (cycles: number[]) =>
    cycles.flatMap((c) => [on(c, 2, "cramps"), on(c, 2, "headache")]);

  it("finds a pair that repeats across cycles", () => {
    const found = coOccurrences(both([0, 1, 2, 3, 4]), starts(6));
    expect(found).toHaveLength(1);
    expect(found[0]).toMatchObject({ a: "cramps", b: "headache", cycles: 5, days: 5 });
  });

  /**
   * The failure this module exists to avoid: one bad week is not a pattern. Seven
   * shared days inside a single cycle clear the day floor and must still be
   * rejected, because the claim is about repetition across cycles.
   */
  it("rejects a single bad week that shares many days", () => {
    const oneWeek = [1, 2, 3, 4, 5, 6, 7].flatMap((d) => [
      on(0, d, "cramps"),
      on(0, d, "headache"),
    ]);
    expect(coOccurrences(oneWeek, starts(6))).toEqual([]);
  });

  it("ignores symptoms logged on different days of the same cycle", () => {
    const apart = [0, 1, 2, 3].flatMap((c) => [on(c, 2, "cramps"), on(c, 20, "headache")]);
    expect(coOccurrences(apart, starts(6))).toEqual([]);
  });

  /** No ordering may be inferred, so the pair is always stored alphabetically. */
  it("stores the pair alphabetically whatever order it was logged in", () => {
    const reversed = [0, 1, 2, 3, 4].flatMap((c) => [
      on(c, 2, "headache"),
      on(c, 2, "cramps"),
    ]);
    const found = coOccurrences(reversed, starts(6));
    expect(found[0]!.a).toBe("cramps");
    expect(found[0]!.b).toBe("headache");
  });

  it("needs a cycle history before it says anything", () => {
    expect(coOccurrences(both([0, 1, 2]), ["2026-01-05"])).toEqual([]);
    expect(coOccurrences([], starts(6))).toEqual([]);
  });

  /**
   * The current cycle is still running, so an absence in it is not evidence. A
   * pair logged in every complete cycle must not be diluted by the open one.
   */
  it("ignores the cycle still in progress", () => {
    const s = starts(4); // 4 complete cycles, indices 0..3
    const found = coOccurrences(both([0, 1, 2, 3, 4]), s);
    expect(found[0]!.cycles).toBe(4);
    expect(found[0]!.ofCycles).toBe(4);
  });
});

describe("severity trend", () => {
  /** `n` complete cycles of one symptom at a fixed severity. */
  const at = (cycles: number[], severity: number) =>
    cycles.map((c) => on(c, 2, "cramps", severity));

  it("reports a rise as higher, never as worse", () => {
    const entries = [...at([0, 1, 2], 1), ...at([3, 4, 5], 3)];
    const [trend] = severityTrends(entries, starts(6));
    expect(trend).toMatchObject({ type: "cramps", direction: "higher" });
    expect(trend!.recentMean).toBe(3);
    expect(trend!.earlierMean).toBe(1);
    expect(Object.keys(trend!)).not.toContain("worse");
  });

  it("reports a fall as lower", () => {
    const [trend] = severityTrends([...at([0, 1, 2], 4), ...at([3, 4, 5], 1)], starts(6));
    expect(trend!.direction).toBe("lower");
  });

  /** Noise is not a trend, and `steady` is a real answer rather than an absence. */
  it("calls a sub-threshold difference steady", () => {
    const entries = [...at([0, 1, 2], 2), ...at([3, 4, 5], 2.4)];
    const [trend] = severityTrends(entries, starts(6));
    expect(trend!.direction).toBe("steady");
    expect(Math.abs(trend!.recentMean - trend!.earlierMean)).toBeLessThan(MIN_SHIFT);
  });

  /**
   * A symptom logged without a rating is an entry, not a zero. Treating it as one
   * would make "she didn't rate it" read as "it didn't hurt".
   */
  it("ignores unrated entries rather than counting them as no pain", () => {
    const rated = [...at([0, 1, 2], 3), ...at([3, 4, 5], 3)];
    const unrated = [on(3, 5, "cramps"), on(4, 5, "cramps")];
    const [trend] = severityTrends([...rated, ...unrated], starts(6));
    expect(trend!.recentMean).toBe(3);
    expect(trend!.direction).toBe("steady");
  });

  it("says nothing without a before and an after", () => {
    expect(severityTrends(at([0, 1, 2], 3), starts(RECENT_CYCLES))).toEqual([]);
    expect(severityTrends(at([3, 4, 5], 3), starts(6))).toEqual([]);
  });

  it("puts a change above a steady reading", () => {
    const entries = [
      ...at([0, 1, 2], 1),
      ...at([3, 4, 5], 3),
      ...[0, 1, 2, 3, 4, 5].map((c) => on(c, 6, "bloating", 2)),
    ];
    const trends = severityTrends(entries, starts(6));
    expect(trends[0]!.type).toBe("cramps");
    expect(trends[0]!.direction).toBe("higher");
    expect(trends[1]!.direction).toBe("steady");
  });
});
