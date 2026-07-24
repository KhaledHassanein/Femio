import { describe, expect, it } from "vitest";
import { currentCycleDay, topSymptoms } from "./insights";

describe("currentCycleDay", () => {
  it("counts from the last period start (day 1 = start day)", () => {
    expect(currentCycleDay(["2026-01-01"], "2026-01-01")).toBe(1);
    expect(currentCycleDay(["2026-01-01"], "2026-01-10")).toBe(10);
  });

  it("uses the most recent past start, ignoring future ones", () => {
    expect(currentCycleDay(["2026-01-01", "2026-01-29", "2026-03-01"], "2026-02-05")).toBe(8);
  });

  it("returns null with no past starts", () => {
    expect(currentCycleDay([], "2026-01-10")).toBeNull();
    expect(currentCycleDay(["2026-02-01"], "2026-01-10")).toBeNull();
  });
});

describe("topSymptoms", () => {
  it("ranks by frequency", () => {
    const types = ["cramps", "fatigue", "cramps", "cramps", "fatigue", "acne"];
    expect(topSymptoms(types)).toEqual([
      { type: "cramps", count: 3 },
      { type: "fatigue", count: 2 },
      { type: "acne", count: 1 },
    ]);
  });

  it("limits the result and breaks ties by name", () => {
    const types = ["b", "a", "c"];
    expect(topSymptoms(types, 2)).toEqual([
      { type: "a", count: 1 },
      { type: "b", count: 1 },
    ]);
  });

  it("handles no symptoms", () => {
    expect(topSymptoms([])).toEqual([]);
  });
});
