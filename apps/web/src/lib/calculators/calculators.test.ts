import { describe, expect, it } from "vitest";
import { addDays, diffDays } from "./dates";
import { bmi, cycleStats, estimateDueDate, fertileWindow, gestationalAge } from "./index";

const LMP = "2026-01-01";

describe("estimateDueDate", () => {
  it("is 280 days after LMP for a 28-day cycle", () => {
    const r = estimateDueDate(LMP, 28)!;
    expect(diffDays(LMP, r.edd)).toBe(280);
    expect(diffDays(LMP, r.termStart)).toBe(259); // 37w
    expect(diffDays(LMP, r.termEnd)).toBe(294); // 42w
  });

  it("adjusts for cycle length", () => {
    expect(diffDays(LMP, estimateDueDate(LMP, 35)!.edd)).toBe(280 + 7);
    expect(diffDays(LMP, estimateDueDate(LMP, 21)!.edd)).toBe(280 - 7);
  });

  it("clamps extreme cycle lengths", () => {
    expect(diffDays(LMP, estimateDueDate(LMP, 999)!.edd)).toBe(280 + (45 - 28));
    expect(diffDays(LMP, estimateDueDate(LMP, 1)!.edd)).toBe(280 + (20 - 28));
  });

  it("returns null for an invalid date", () => {
    expect(estimateDueDate("not-a-date")).toBeNull();
    expect(estimateDueDate("2026-13-40")).toBeNull();
  });
});

describe("fertileWindow", () => {
  it("puts ovulation ~14 days before the next period", () => {
    const r = fertileWindow(LMP, 28)!;
    expect(r.nextPeriod).toBe(addDays(LMP, 28));
    expect(diffDays(r.ovulation, r.nextPeriod)).toBe(14);
    expect(diffDays(r.windowStart, r.ovulation)).toBe(5);
    expect(diffDays(r.ovulation, r.windowEnd)).toBe(1);
  });

  it("shifts ovulation later for longer cycles", () => {
    const short = fertileWindow(LMP, 26)!;
    const long = fertileWindow(LMP, 32)!;
    expect(diffDays(short.ovulation, long.ovulation)).toBe(6);
  });

  it("returns null for an invalid date", () => {
    expect(fertileWindow("")).toBeNull();
  });
});

describe("gestationalAge", () => {
  it("computes weeks + days", () => {
    expect(gestationalAge(LMP, addDays(LMP, 0))).toEqual({ weeks: 0, days: 0, totalDays: 0 });
    expect(gestationalAge(LMP, addDays(LMP, 100))).toEqual({ weeks: 14, days: 2, totalDays: 100 });
  });

  it("rejects a date before LMP or absurdly far after", () => {
    expect(gestationalAge(LMP, addDays(LMP, -1))).toBeNull();
    expect(gestationalAge(LMP, addDays(LMP, 400))).toBeNull();
  });
});

describe("bmi", () => {
  it("computes value and category", () => {
    expect(bmi(70, 175)).toEqual({ value: 22.9, category: "normal" });
  });

  it("classifies WHO boundaries (lower bound inclusive)", () => {
    expect(bmi(74, 200)!.category).toBe("normal"); // exactly 18.5
    expect(bmi(72, 200)!.category).toBe("underweight"); // 18.0
    expect(bmi(100, 200)!.category).toBe("overweight"); // exactly 25.0
    expect(bmi(120, 200)!.category).toBe("obese"); // exactly 30.0
  });

  it("returns null for non-positive input", () => {
    expect(bmi(0, 175)).toBeNull();
    expect(bmi(70, 0)).toBeNull();
  });
});

describe("cycleStats", () => {
  it("averages consecutive gaps", () => {
    expect(cycleStats(["2026-01-01", "2026-01-29"])).toEqual({
      averageLength: 28,
      min: 28,
      max: 28,
      count: 1,
      regular: true,
    });
  });

  it("flags irregular when spread > 7 days", () => {
    const r = cycleStats(["2026-01-01", "2026-01-26", "2026-03-05"])!; // 25, then 38
    expect(r.min).toBe(25);
    expect(r.max).toBe(38);
    expect(r.regular).toBe(false);
    expect(r.count).toBe(2);
  });

  it("sorts and de-dupes input, ignores invalid dates", () => {
    const r = cycleStats(["2026-01-29", "2026-01-01", "2026-01-01", "bad"])!;
    expect(r.averageLength).toBe(28);
    expect(r.count).toBe(1);
  });

  it("needs at least two valid dates", () => {
    expect(cycleStats(["2026-01-01"])).toBeNull();
    expect(cycleStats([])).toBeNull();
  });
});
