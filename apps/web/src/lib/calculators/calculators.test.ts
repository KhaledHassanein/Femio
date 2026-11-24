import { describe, expect, it } from "vitest";
import { addDays, diffDays } from "./dates";
import {
  bmi,
  cycleStats,
  estimateDueDate,
  estimateDueDateFrom,
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

  it("refuses a cycle length outside the accepted range instead of clamping it", () => {
    expect(estimateDueDate(LMP, 5)).toBeNull();
    expect(estimateDueDate(LMP, 99)).toBeNull();
    expect(estimateDueDate(LMP, 45)).not.toBeNull();
  });

  it("returns null for an invalid date", () => {
    expect(estimateDueDate("not-a-date")).toBeNull();
    expect(estimateDueDate("2026-13-40")).toBeNull();
  });
});

describe("fertileWindow", () => {
  it("puts ovulation 14 days before the next period and the window as the six days ending on it (MR-07)", () => {
    const r = fertileWindow(LMP, 28)!;
    expect(r.nextPeriod).toBe(addDays(LMP, 28));
    const w = r.window!;
    expect(diffDays(w.ovulation, r.nextPeriod)).toBe(14);
    expect(diffDays(w.start, w.ovulation)).toBe(5);
    expect(w.end).toBe(w.ovulation);
  });

  it("shifts ovulation later for longer cycles", () => {
    const short = fertileWindow(LMP, 26)!;
    const long = fertileWindow(LMP, 32)!;
    expect(diffDays(short.window!.ovulation, long.window!.ovulation)).toBe(6);
  });

  it("withholds the window, but not the next period, outside 21–35 days (MR-08)", () => {
    const r = fertileWindow(LMP, 40)!;
    expect(r.window).toBeNull();
    expect(r.nextPeriod).toBe(addDays(LMP, 40));
    expect(fertileWindow(LMP, 21)!.window).not.toBeNull();
    expect(fertileWindow(LMP, 35)!.window).not.toBeNull();
    expect(fertileWindow(LMP, 36)!.window).toBeNull();
  });

  it("returns null outside the accepted range rather than clamping", () => {
    expect(fertileWindow(LMP, 20)).toBeNull();
    expect(fertileWindow(LMP, 46)).toBeNull();
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

  it("rejects a date before the last period or past 315 days (MR-26)", () => {
    expect(gestationalAge(LMP, addDays(LMP, -1))).toBeNull();
    expect(gestationalAge(LMP, addDays(LMP, 315))).not.toBeNull();
    expect(gestationalAge(LMP, addDays(LMP, 316))).toBeNull();
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
      lengths: [28],
    });
  });

  it("flags irregular when the spread is more than 9 days (MR-09)", () => {
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

  it("accepts the bounds in either order and refuses an out-of-range bound", () => {
    expect(periodForecast(LMP, 30, 26)).toEqual(periodForecast(LMP, 26, 30));
    expect(periodForecast(LMP, 5, 99)).toBeNull();
    expect(periodForecast(LMP, 21, 45)).not.toBeNull();
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

describe("estimateDueDateFrom (R11.1)", () => {
  it("agrees with every method on one pregnancy and keeps the 37w0d-42w0d window", () => {
    const byLmp = estimateDueDateFrom("lmp", "2026-01-01")!;
    const byConception = estimateDueDateFrom("conception", "2026-01-15")!;
    const byDay5 = estimateDueDateFrom("transfer5", "2026-01-20")!;
    const byDay3 = estimateDueDateFrom("transfer3", "2026-01-18")!;
    const byScan = estimateDueDateFrom("scan", "2026-03-26", { scanWeeks: 12, scanDays: 0 })!;
    for (const r of [byConception, byDay5, byDay3, byScan]) expect(r).toEqual(byLmp);
    expect(diffDays(byLmp.termStart, byLmp.edd)).toBe(21);
    expect(diffDays(byLmp.edd, byLmp.termEnd)).toBe(14);
    expect(byLmp.lmp).toBe("2026-01-01");
  });

  it("refuses a scan gestation outside 4w0d-41w6d rather than computing it", () => {
    expect(estimateDueDateFrom("scan", "2026-03-26", { scanWeeks: 3, scanDays: 6 })).toBeNull();
    expect(estimateDueDateFrom("scan", "2026-03-26", { scanWeeks: 42, scanDays: 0 })).toBeNull();
    expect(estimateDueDateFrom("scan", "2026-03-26")).toBeNull();
  });
});
