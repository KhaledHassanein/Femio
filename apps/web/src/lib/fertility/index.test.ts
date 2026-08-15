import { describe, expect, it } from "vitest";
import * as fertility from "./index";
import {
  bbtChart,
  cycleDayOf,
  isEmptyEntry,
  isPlausibleBbt,
  recentFirst,
  unitOf,
  type FertilityEntry,
} from "./index";

const entry = (over: Partial<FertilityEntry> = {}): FertilityEntry => ({
  id: over.id ?? "e",
  loggedAt: "2026-08-16",
  bbt: null,
  opk: null,
  cm: null,
  intercourse: null,
  ...over,
});

/**
 * The assertion this file exists for.
 *
 * A BBT series has a well-known reading, and Femio deliberately does not make it.
 * If a future change adds `ovulationDay` or `thermalShift` here, this test is what
 * says no — before the feature that would inevitably be built on it: "days you
 * could avoid", which is the contraception guardrail this table's own schema
 * comment names.
 */
describe("the line this module will not cross", () => {
  it("exports nothing that reads a temperature series", () => {
    for (const forbidden of [
      "ovulationDay",
      "thermalShift",
      "detectOvulation",
      "fertileDays",
      "safeDays",
      "phaseOf",
      "isFertile",
    ]) {
      expect(Object.hasOwn(fertility, forbidden)).toBe(false);
    }
  });

  it("gives an entry no field to hold a conclusion in", () => {
    const e = entry({ bbt: 36.5 });
    for (const forbidden of ["fertile", "ovulated", "phase", "result", "status"]) {
      expect(Object.hasOwn(e, forbidden)).toBe(false);
    }
  });
});

describe("isPlausibleBbt / unitOf", () => {
  it("accepts ordinary readings in both units", () => {
    expect(isPlausibleBbt(36.5, "c")).toBe(true);
    expect(isPlausibleBbt(97.7, "f")).toBe(true);
    expect(unitOf(36.5)).toBe("c");
    expect(unitOf(97.7)).toBe("f");
  });

  it("rejects the stray keypress, not the person", () => {
    // 365 is a typo for 36.5. The range is wide on purpose — it is a typo guard,
    // never a comment on her temperature.
    expect(isPlausibleBbt(365, "c")).toBe(false);
    expect(isPlausibleBbt(3.65, "c")).toBe(false);
    expect(unitOf(365)).toBeNull();
    // 34.0 and 40.0 are inside the range and stay there: this must not become a
    // "your temperature is abnormal" check by narrowing.
    expect(isPlausibleBbt(34, "c")).toBe(true);
    expect(isPlausibleBbt(40, "c")).toBe(true);
  });
});

describe("cycleDayOf", () => {
  it("counts from day 1, not day 0", () => {
    expect(cycleDayOf(entry({ loggedAt: "2026-08-01" }), "2026-08-01")).toBe(1);
    expect(cycleDayOf(entry({ loggedAt: "2026-08-16" }), "2026-08-01")).toBe(16);
  });

  it("returns null rather than a negative day for an entry before the cycle", () => {
    expect(cycleDayOf(entry({ loggedAt: "2026-07-20" }), "2026-08-01")).toBeNull();
    expect(cycleDayOf(entry(), null)).toBeNull();
  });
});

describe("bbtChart", () => {
  const series = [
    entry({ id: "a", loggedAt: "2026-08-03", bbt: 36.4 }),
    entry({ id: "b", loggedAt: "2026-08-01", bbt: 36.3 }),
    entry({ id: "c", loggedAt: "2026-08-02", bbt: 36.5 }),
  ];

  it("returns nothing to draw below three readings", () => {
    // A chart of one dot pretending to be a trend is worse than "keep logging".
    expect(bbtChart(series.slice(0, 2), "2026-08-01")).toBeNull();
  });

  it("orders by date and carries the cycle day", () => {
    const chart = bbtChart(series, "2026-08-01")!;
    expect(chart.points.map((p) => p.entryId)).toEqual(["b", "c", "a"]);
    expect(chart.points.map((p) => p.cycleDay)).toEqual([1, 2, 3]);
  });

  it("pads the axis rather than fitting it tightly", () => {
    // A tight fit turns a 0.1° wobble into a mountain, which is a chart implying
    // something the numbers do not.
    const chart = bbtChart(series, null)!;
    expect(chart.low).toBeLessThan(36.3);
    expect(chart.high).toBeGreaterThan(36.5);
    for (const point of chart.points) {
      expect(point.y).toBeGreaterThan(0);
      expect(point.y).toBeLessThan(1);
    }
  });

  it("ignores days with no temperature instead of drawing a gap as a value", () => {
    const chart = bbtChart([...series, entry({ id: "none", loggedAt: "2026-08-04" })], null)!;
    expect(chart.points.map((p) => p.entryId)).toEqual(["b", "c", "a"]);
  });

  it("reads the unit from her own numbers", () => {
    const f = [
      entry({ id: "a", loggedAt: "2026-08-01", bbt: 97.4 }),
      entry({ id: "b", loggedAt: "2026-08-02", bbt: 97.6 }),
      entry({ id: "c", loggedAt: "2026-08-03", bbt: 98.1 }),
    ];
    expect(bbtChart(f, null)!.unit).toBe("f");
  });
});

describe("recentFirst / isEmptyEntry", () => {
  it("lists newest first", () => {
    const rows = [entry({ id: "old", loggedAt: "2026-08-01" }), entry({ id: "new", loggedAt: "2026-08-10" })];
    expect(recentFirst(rows).map((e) => e.id)).toEqual(["new", "old"]);
  });

  it("treats a row that says nothing as empty", () => {
    expect(isEmptyEntry({ bbt: null, opk: null, cm: null, intercourse: null })).toBe(true);
    expect(isEmptyEntry({ bbt: null, opk: null, cm: null, intercourse: false })).toBe(true);
    expect(isEmptyEntry({ bbt: null, opk: "peak", cm: null, intercourse: null })).toBe(false);
    expect(isEmptyEntry({ bbt: 36.5, opk: null, cm: null, intercourse: null })).toBe(false);
  });
});
