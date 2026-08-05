import { describe, expect, it } from "vitest";
import { cycleVariability, sinceLastPeriod, MENOPAUSE_MONTHS } from "./index";

describe("sinceLastPeriod", () => {
  it("counts calendar months, not 30-day blocks", () => {
    // 1 Jan → 1 Jul is six months on anyone's calendar; days/30 would say 6.03 and
    // drift further every year.
    const r = sinceLastPeriod("2026-01-01", "2026-07-01");
    expect(r?.months).toBe(6);
    expect(r?.days).toBe(181);
  });

  it("does not round a month up before the day-of-month is reached", () => {
    expect(sinceLastPeriod("2026-01-15", "2026-02-14")?.months).toBe(0);
    expect(sinceLastPeriod("2026-01-15", "2026-02-15")?.months).toBe(1);
  });

  it("handles a month shorter than the start day", () => {
    // 31 Jan → 28 Feb has not completed a month by day-of-month.
    expect(sinceLastPeriod("2026-01-31", "2026-02-28")?.months).toBe(0);
    expect(sinceLastPeriod("2026-01-31", "2026-03-31")?.months).toBe(2);
  });

  it("crosses a year boundary", () => {
    expect(sinceLastPeriod("2025-11-10", "2026-08-10")?.months).toBe(9);
  });

  it("reports months remaining before the twelve-month convention", () => {
    const r = sinceLastPeriod("2026-01-01", "2026-05-01");
    expect(r?.monthsRemaining).toBe(MENOPAUSE_MONTHS - 4);
    expect(r?.pastConventionalMarker).toBe(false);
  });

  it("marks the convention passed at twelve months, and clamps what remains", () => {
    const r = sinceLastPeriod("2025-01-01", "2026-01-01");
    expect(r?.months).toBe(12);
    expect(r?.pastConventionalMarker).toBe(true);
    expect(r?.monthsRemaining).toBe(0);
  });

  it("returns null with nothing logged", () => {
    expect(sinceLastPeriod(null, "2026-05-01")).toBeNull();
  });

  it("returns null for a future last period rather than a negative gap", () => {
    expect(sinceLastPeriod("2026-09-01", "2026-05-01")).toBeNull();
  });

  it("returns null for malformed dates", () => {
    expect(sinceLastPeriod("nope", "2026-05-01")).toBeNull();
    expect(sinceLastPeriod("2026-01-01", "")).toBeNull();
  });
});

describe("cycleVariability", () => {
  it("reports the spread of recent cycle lengths", () => {
    // 28, 30, 26 day gaps.
    const v = cycleVariability(["2026-01-01", "2026-01-29", "2026-02-28", "2026-03-26"]);
    expect(v?.shortest).toBe(26);
    expect(v?.longest).toBe(30);
    expect(v?.spread).toBe(4);
    expect(v?.irregular).toBe(false);
  });

  it("flags irregular using the same threshold as the cycle predictor", () => {
    // Gaps of 24 and 45 days — spread 21, well past the predictor's >9.
    const v = cycleVariability(["2026-01-01", "2026-01-25", "2026-03-11"]);
    expect(v?.spread).toBe(21);
    expect(v?.irregular).toBe(true);
  });

  it("needs at least three logged starts to say anything", () => {
    expect(cycleVariability(["2026-01-01", "2026-01-29"])).toBeNull();
    expect(cycleVariability([])).toBeNull();
  });

  it("ignores duplicates and unsorted input", () => {
    const v = cycleVariability(["2026-02-28", "2026-01-01", "2026-01-29", "2026-01-29"]);
    expect(v?.shortest).toBe(28);
    expect(v?.longest).toBe(30);
  });

  it("only considers the recent window", () => {
    // A wild gap two years ago must not make today's cycles look irregular.
    const starts = ["2024-01-01", "2024-06-01", "2026-01-01", "2026-01-29", "2026-02-26", "2026-03-26"];
    const v = cycleVariability(starts, 3);
    expect(v?.irregular).toBe(false);
  });
});
