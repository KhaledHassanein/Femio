import { describe, expect, it } from "vitest";
import { dayStates, type FlowLevel } from "./day-states";

const p = (day: string, flow: FlowLevel = "medium") => ({ day, flow });
const range = (from: string, count: number) =>
  Array.from({ length: count }, (_, i) => {
    const d = new Date(`${from}T00:00:00Z`);
    d.setUTCDate(d.getUTCDate() + i);
    return d.toISOString().slice(0, 10);
  });

describe("dayStates", () => {
  const base = { logDates: [], todayISO: "2026-08-20" };

  it("marks a run's first and last day so length reads without counting", () => {
    const out = dayStates({
      ...base,
      dates: range("2026-08-01", 6),
      periodDays: [p("2026-08-02"), p("2026-08-03"), p("2026-08-04")],
    });
    expect(out.map((d) => [d.runStart, d.runEnd])).toEqual([
      [false, false],
      [true, false],
      [false, false],
      [false, true],
      [false, false],
      [false, false],
    ]);
  });

  it("decides run ends from neighbouring days, not from the array", () => {
    // The grid starts mid-run. Day 1 of the window is not day 1 of the period, and
    // capping it would claim a boundary she did not record.
    const out = dayStates({
      ...base,
      dates: range("2026-08-03", 3),
      periodDays: [p("2026-08-02"), p("2026-08-03"), p("2026-08-04")],
    });
    expect(out[0]?.runStart).toBe(false);
    expect(out[1]?.runEnd).toBe(true);
  });

  it("keeps her own flow intensity rather than inferring one", () => {
    const out = dayStates({
      ...base,
      dates: ["2026-08-02", "2026-08-03"],
      periodDays: [p("2026-08-02", "spotting"), p("2026-08-03", "heavy")],
    });
    expect(out[0]?.period).toEqual({ flow: "spotting" });
    expect(out[1]?.period).toEqual({ flow: "heavy" });
  });

  it("renders both probability tiers separately, not collapsed", () => {
    // The differentiator: Flo computes both and draws one ring.
    const out = dayStates({
      ...base,
      dates: ["2026-09-01", "2026-09-03", "2026-09-07"],
      periodDays: [],
      prediction: {
        windowStart: "2026-09-01",
        windowEnd: "2026-09-07",
        likelyStart: "2026-09-03",
        likelyEnd: "2026-09-04",
      },
    });
    expect(out.map((d) => [d.predictedPossible, d.predictedLikely])).toEqual([
      [true, false],
      [true, true],
      [true, false],
    ]);
  });

  it("does not assume the likely tier sits inside the wider one", () => {
    // If a model change ever makes them disjoint, both flags must still be honest.
    const out = dayStates({
      ...base,
      dates: ["2026-09-10"],
      periodDays: [],
      prediction: {
        windowStart: "2026-09-01",
        windowEnd: "2026-09-05",
        likelyStart: "2026-09-09",
        likelyEnd: "2026-09-11",
      },
    });
    expect(out[0]?.predictedLikely).toBe(true);
    expect(out[0]?.predictedPossible).toBe(false);
  });

  it("marks the fertile window and never its complement", () => {
    const out = dayStates({
      ...base,
      dates: ["2026-08-12", "2026-08-14", "2026-08-20"],
      periodDays: [],
      fertile: { start: "2026-08-12", end: "2026-08-18", ovulation: "2026-08-14" },
    });
    expect(out.map((d) => d.fertile)).toEqual([true, true, false]);
    expect(out.map((d) => d.ovulation)).toEqual([false, true, false]);
    // Nothing anywhere says "safe" — the absence of a band is not a claim.
    expect(Object.keys(out[2] ?? {})).not.toContain("infertile");
  });

  it("composes states rather than ranking them", () => {
    // Today, bleeding, and other logs at once — an enum could not express this.
    const out = dayStates({
      dates: ["2026-08-20"],
      periodDays: [p("2026-08-20", "light")],
      logDates: ["2026-08-20"],
      todayISO: "2026-08-20",
      prediction: { windowStart: "2026-08-19", windowEnd: "2026-08-22" },
    });
    const d = out[0]!;
    expect([d.today, Boolean(d.period), d.hasLogs, d.predictedPossible]).toEqual([
      true,
      true,
      true,
      true,
    ]);
  });

  it("draws a blank cell rather than throwing on a bad date", () => {
    const out = dayStates({ ...base, dates: ["not-a-date"], periodDays: [] });
    expect(out[0]?.period).toBeNull();
    expect(out[0]?.today).toBe(false);
  });

  it("tolerates a prediction with only one bound", () => {
    const out = dayStates({
      ...base,
      dates: ["2026-09-01"],
      periodDays: [],
      prediction: { windowStart: "2026-09-01", windowEnd: null },
    });
    expect(out[0]?.predictedPossible).toBe(false);
  });
});
