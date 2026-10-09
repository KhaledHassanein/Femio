import { describe, expect, it } from "vitest";
import { addDays, diffDays, todayISO } from "./dates";
import {
  bmi,
  cycleStats,
  estimateDueDate,
  fertileWindow,
  gestationalAge,
  periodForecast,
  pregnancyTestFromPeriod,
  pregnancyTestFromSex,
  trimesterOf,
} from "./index";

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

  it("refuses cycle lengths calendar maths cannot use, instead of clamping them", () => {
    // Audit F02: 90 was silently computed as 45 with 90 still showing in the box.
    expect(estimateDueDate(LMP, 999)).toBeNull();
    expect(estimateDueDate(LMP, 1)).toBeNull();
    expect(diffDays(LMP, estimateDueDate(LMP, 45)!.edd)).toBe(280 + (45 - 28));
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

  it("returns null for non-positive or implausible adult input", () => {
    expect(bmi(0, 175)).toBeNull();
    expect(bmi(70, 0)).toBeNull();
    expect(bmi(-70, 170)).toBeNull();
    expect(bmi(300.5, 170)).toBeNull();
    expect(bmi(70, 50)).toBeNull();
  });
});

describe("cycleStats", () => {
  it("averages consecutive gaps", () => {
    expect(cycleStats(["2026-01-01", "2026-01-29"])).toEqual({
      averageLength: 28,
      min: 28,
      max: 28,
      count: 1,
      regular: null,
      tooClose: false,
    });
  });

  it("gives no regularity verdict from one interval, and flags starts too close to be cycles", () => {
    // Audit F04: one interval, even a one-day one, was called "regular".
    expect(cycleStats(["2026-08-01", "2026-08-29"])!.regular).toBeNull();
    expect(cycleStats(["2026-08-01", "2026-08-02"])!.tooClose).toBe(true);
    expect(cycleStats(["2026-01-01", "2026-01-29", "2026-02-26"])!.regular).toBe(true);
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

describe("periodForecast", () => {
  it("gives a range as wide as her cycles vary, widening each cycle ahead", () => {
    const r = periodForecast(LMP, 26, 30, 5, 3)!;
    expect(r.map((p) => [diffDays(LMP, p.earliest), diffDays(LMP, p.latest)])).toEqual([
      [26, 30],
      [52, 60],
      [78, 90],
    ]);
    expect(diffDays(r[0]!.earliest, r[0]!.endIfEarliest)).toBe(4);
  });

  it("collapses to one day only when she says her cycles do not vary", () => {
    const [first] = periodForecast(LMP, 28, 28)!;
    expect(first!.earliest).toBe(first!.latest);
  });

  it("accepts the bounds in either order and refuses out-of-range ones", () => {
    expect(periodForecast(LMP, 30, 26)).toEqual(periodForecast(LMP, 26, 30));
    expect(periodForecast(LMP, 24, 90)).toBeNull();
    expect(periodForecast(LMP, 5, 30)).toBeNull();
  });

  it("returns null for an invalid date", () => {
    expect(periodForecast("2026-02-30", 28, 28)).toBeNull();
  });
});

describe("pregnancy test timing (NHS)", () => {
  it("is the first day of the expected period", () => {
    expect(pregnancyTestFromPeriod(LMP, 30)).toEqual({
      expectedPeriod: addDays(LMP, 30),
      testFrom: addDays(LMP, 30),
    });
  });

  it("is 21 days after sex when the period date is unknown", () => {
    expect(pregnancyTestFromSex("2026-03-01")).toEqual({ testFrom: "2026-03-22" });
    expect(pregnancyTestFromSex("nope")).toBeNull();
  });
});

describe("trimesterOf", () => {
  it("uses ACOG's 14 and 28 week boundaries", () => {
    expect([0, 13, 14, 27, 28, 41].map(trimesterOf)).toEqual([1, 1, 2, 2, 3, 3]);
  });
});

describe("todayISO", () => {
  it("is her local calendar date, not UTC's", () => {
    // 23:30 local on 9 October is still the 9th, whatever UTC says (audit F17).
    expect(todayISO(new Date(2026, 9, 9, 23, 30))).toBe("2026-10-09");
    expect(todayISO(new Date(2026, 9, 10, 0, 30))).toBe("2026-10-10");
  });
});
