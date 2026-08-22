import { describe, expect, it } from "vitest";
import { MIN_CYCLES_FOR_PATTERN, symptomPatterns } from "./symptom-patterns";

/** Three 28-day cycles, plus a fourth start so the third is complete. */
const STARTS = ["2026-05-06", "2026-06-03", "2026-07-01", "2026-07-29"];

const on = (date: string, type = "cramps") => ({ type, date });

describe("symptomPatterns", () => {
  it("says nothing from a single cycle — that is an observation, not a pattern", () => {
    // The same false confidence R3.1.7 removed from the prediction copy: one
    // occurrence cannot support "you always get this on day 2".
    expect(symptomPatterns([on("2026-05-07")], STARTS)).toEqual([]);
  });

  it("needs the symptom in three distinct cycles before reporting it", () => {
    const two = [on("2026-05-07"), on("2026-06-04")];
    expect(symptomPatterns(two, STARTS)).toEqual([]);

    const three = [...two, on("2026-07-02")];
    const [pattern] = symptomPatterns(three, STARTS);
    expect(pattern?.cycles).toBe(MIN_CYCLES_FOR_PATTERN);
  });

  it("reports the cycle days it fell on, and the evidence behind them", () => {
    const logs = [
      on("2026-05-06"), // day 1
      on("2026-05-08"), // day 3
      on("2026-06-03"), // day 1
      on("2026-07-01"), // day 1
    ];
    const [pattern] = symptomPatterns(logs, STARTS);
    expect(pattern?.days).toEqual([1, 3]);
    expect(pattern?.from).toBe(1);
    expect(pattern?.to).toBe(3);
    expect(pattern?.cycles).toBe(3);
    // The denominator is shown, not hidden: three complete cycles, not four.
    expect(pattern?.ofCycles).toBe(3);
  });

  it("ignores the cycle still in progress, so its absence is not counted against her", () => {
    // A symptom that has not happened *yet* in the running cycle has not failed to
    // appear, and counting that cycle would drag every denominator down.
    const logs = [on("2026-05-07"), on("2026-06-04"), on("2026-07-02"), on("2026-07-30")];
    const [pattern] = symptomPatterns(logs, STARTS);
    expect(pattern?.ofCycles).toBe(3);
    expect(pattern?.cycles).toBe(3);
  });

  it("treats consecutive logged period days as one cycle", () => {
    // Otherwise every symptom lands on day 1 of a one-day cycle (R3.1.9).
    const starts = ["2026-05-06", "2026-05-07", "2026-05-08", "2026-06-03", "2026-07-01", "2026-07-29"];
    const logs = [on("2026-05-09"), on("2026-06-06"), on("2026-07-04")];
    const [pattern] = symptomPatterns(logs, starts);
    expect(pattern?.days).toEqual([4]);
    expect(pattern?.cycles).toBe(3);
  });

  it("ranks by how often it repeats, and is stable across renders", () => {
    const logs = [
      on("2026-05-07", "cramps"),
      on("2026-06-04", "cramps"),
      on("2026-07-02", "cramps"),
      on("2026-05-20", "headache"),
      on("2026-06-17", "headache"),
      on("2026-07-15", "headache"),
      on("2026-05-21", "bloating"),
      on("2026-06-18", "bloating"),
    ];
    const patterns = symptomPatterns(logs, STARTS);
    // bloating appears in two cycles and is therefore not reported at all.
    expect(patterns.map((p) => p.type)).toEqual(["cramps", "headache"]);
  });

  it("returns nothing before there are two period starts to define a cycle", () => {
    expect(symptomPatterns([on("2026-05-07")], ["2026-05-06"])).toEqual([]);
    expect(symptomPatterns([on("2026-05-07")], [])).toEqual([]);
  });

  it("ignores logs that predate her first recorded period", () => {
    const logs = [on("2026-01-01"), on("2026-05-07"), on("2026-06-04"), on("2026-07-02")];
    const [pattern] = symptomPatterns(logs, STARTS);
    expect(pattern?.cycles).toBe(3);
    expect(pattern?.days).toEqual([2]);
  });

  it("ignores malformed dates rather than throwing on them", () => {
    const logs = [on("not-a-date"), on("2026-05-07"), on("2026-06-04"), on("2026-07-02")];
    expect(symptomPatterns(logs, STARTS)[0]?.cycles).toBe(3);
  });
});
