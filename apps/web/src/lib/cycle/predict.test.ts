import { describe, expect, it } from "vitest";
import { addDays, diffDays } from "@/lib/calculators/dates";
import { daysUntilPredicted, predictNextPeriod } from "./predict";

// Six regular 28-day cycles → 7 start dates.
const regular = Array.from({ length: 7 }, (_, i) => addDays("2026-01-01", i * 28));

describe("predictNextPeriod", () => {
  it("predicts one average length past the last start", () => {
    const p = predictNextPeriod(regular)!;
    expect(p.averageLength).toBe(28);
    expect(p.cyclesAnalyzed).toBe(6);
    expect(diffDays(regular.at(-1)!, p.predictedStart)).toBe(28);
  });

  it("gives a tight window + high confidence for very regular cycles", () => {
    const p = predictNextPeriod(regular)!;
    expect(p.confidence).toBe("high");
    expect(p.irregular).toBe(false);
    expect(diffDays(p.windowStart, p.predictedStart)).toBe(2);
    expect(diffDays(p.predictedStart, p.windowEnd)).toBe(2);
  });

  it("flags irregular + widens the window when cycles vary a lot", () => {
    // starts spaced 25, 40, 30 days → spread 15
    const starts = ["2026-01-01", "2026-01-26", "2026-03-07", "2026-04-06"];
    const p = predictNextPeriod(starts)!;
    expect(p.irregular).toBe(true);
    expect(p.confidence).toBe("low");
    expect(diffDays(p.windowStart, p.windowEnd)).toBeGreaterThan(4);
  });

  it("works with a single cycle but low confidence", () => {
    const p = predictNextPeriod(["2026-01-01", "2026-01-29"])!;
    expect(p.cyclesAnalyzed).toBe(1);
    expect(p.confidence).toBe("low");
    expect(p.averageLength).toBe(28);
  });

  it("needs at least two starts", () => {
    expect(predictNextPeriod(["2026-01-01"])).toBeNull();
    expect(predictNextPeriod([])).toBeNull();
  });

  it("sorts, de-dupes, and ignores invalid dates", () => {
    const p = predictNextPeriod(["2026-01-29", "2026-01-01", "2026-01-01", "bad-date"])!;
    expect(p.averageLength).toBe(28);
    expect(p.cyclesAnalyzed).toBe(1);
  });
});

describe("daysUntilPredicted (no 'late' counter when irregular)", () => {
  it("counts down for regular cycles", () => {
    const p = predictNextPeriod(regular)!;
    const before = addDays(p.predictedStart, -3);
    expect(daysUntilPredicted(p, before)).toBe(3);
  });

  it("returns null in irregular mode", () => {
    const p = predictNextPeriod(["2026-01-01", "2026-01-26", "2026-03-07", "2026-04-06"])!;
    expect(p.irregular).toBe(true);
    expect(daysUntilPredicted(p, "2026-05-01")).toBeNull();
  });
});
