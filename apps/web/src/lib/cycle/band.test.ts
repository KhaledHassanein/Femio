import { describe, expect, it } from "vitest";
import { predictionBand } from "@/lib/cycle/band";

// A 28-day cycle started 2026-08-01, window 2026-08-27…2026-08-31 (predicted
// 2026-08-29 ± 2). The window is 4 days wide, so the pad is 2 days and the axis
// runs day 1 → 2026-09-02 = 32 days.
const base = {
  cycleStart: "2026-08-01",
  windowStart: "2026-08-27",
  windowEnd: "2026-08-31",
};

describe("predictionBand", () => {
  it("places the window inside an axis that runs a little past the window end", () => {
    const band = predictionBand({ ...base, today: "2026-08-16" })!;
    // 26/32 and 30/32 days along the axis.
    expect(band.windowStartPct).toBeCloseTo((26 / 32) * 100, 5);
    expect(band.windowEndPct).toBeCloseTo((30 / 32) * 100, 5);
    expect(band.todayPct).toBeCloseTo((15 / 32) * 100, 5);
    expect(band.pastWindow).toBe(false);
  });

  it("never draws the window flush against the end of the bar", () => {
    for (const [windowStart, windowEnd] of [
      ["2026-08-27", "2026-08-31"],
      ["2026-08-20", "2026-09-10"],
      ["2026-08-15", "2026-08-15"],
    ]) {
      const band = predictionBand({
        cycleStart: "2026-08-01",
        windowStart: windowStart!,
        windowEnd: windowEnd!,
        today: "2026-08-10",
      })!;
      expect(band.windowEndPct).toBeLessThan(100);
    }
  });

  it("today sits exactly on the left edge on the first day of the window", () => {
    const band = predictionBand({ ...base, today: "2026-08-27" })!;
    expect(band.todayPct).toBeCloseTo(band.windowStartPct, 5);
    expect(band.pastWindow).toBe(false);
  });

  it("extends the axis once today runs past the pad, so the marker is not pinned", () => {
    // 2026-09-09 is day 40 and past the padded end (2026-09-02), so the axis
    // becomes 39 days and the window sits well short of the marker.
    const band = predictionBand({ ...base, today: "2026-09-09" })!;
    expect(band.pastWindow).toBe(true);
    expect(band.todayPct).toBe(100);
    expect(band.windowEndPct).toBeCloseTo((30 / 39) * 100, 5);
  });

  it("flags a passed window even while today is still inside the pad", () => {
    // 2026-09-01: one day past the window, still before the padded axis end.
    const band = predictionBand({ ...base, today: "2026-09-01" })!;
    expect(band.pastWindow).toBe(true);
    expect(band.todayPct).toBeGreaterThan(band.windowEndPct);
    expect(band.todayPct).toBeLessThan(100);
  });

  it("a wider window is drawn wider — the uncertainty is the width", () => {
    const tight = predictionBand({ ...base, today: "2026-08-16" })!;
    const wide = predictionBand({
      cycleStart: "2026-08-01",
      windowStart: "2026-08-22",
      windowEnd: "2026-09-05",
      today: "2026-08-16",
    })!;
    expect(wide.windowEndPct - wide.windowStartPct).toBeGreaterThan(
      tight.windowEndPct - tight.windowStartPct,
    );
  });

  it("returns null rather than guessing on impossible or malformed input", () => {
    expect(predictionBand({ ...base, today: "not-a-date" })).toBeNull();
    expect(predictionBand({ ...base, today: "2026-08-32" })).toBeNull();
    // Window ends before it starts.
    expect(
      predictionBand({
        cycleStart: "2026-08-01",
        windowStart: "2026-08-31",
        windowEnd: "2026-08-27",
        today: "2026-08-16",
      }),
    ).toBeNull();
    // Today before day 1 of the cycle.
    expect(predictionBand({ ...base, today: "2026-07-30" })).toBeNull();
    // Window starts before day 1 of the cycle.
    expect(
      predictionBand({
        cycleStart: "2026-08-01",
        windowStart: "2026-07-28",
        windowEnd: "2026-08-31",
        today: "2026-08-16",
      }),
    ).toBeNull();
  });

  it("still draws a degenerate single-day window, because the pad gives it an axis", () => {
    const band = predictionBand({
      cycleStart: "2026-08-01",
      windowStart: "2026-08-01",
      windowEnd: "2026-08-01",
      today: "2026-08-01",
    })!;
    expect(band.windowStartPct).toBe(0);
    expect(band.todayPct).toBe(0);
    expect(band.windowEndPct).toBeLessThan(100);
  });
});
