import { describe, expect, it } from "vitest";
import * as weight from "./weight";
import { isPlausibleWeight, toKg, weightChart, type WeightEntry } from "./weight";

const entry = (id: string, measuredOn: string, value: number, unit: "kg" | "lb" = "kg"): WeightEntry => ({
  id,
  measuredOn,
  value,
  unit,
});

/**
 * The reason this file is short and this test is long.
 *
 * There is published, BMI-banded guidance on weight gain in pregnancy. Drawing it
 * behind her own dots would be an assessment of her body rendered as a background
 * colour — read that way whatever the caption says — and pregnancy is a high-risk
 * period for disordered eating and for weight stigma from routine weighing.
 */
describe("no target, no band, no comparison", () => {
  it("exports nothing that grades a weight or a gain", () => {
    for (const forbidden of [
      "recommendedGain",
      "gainRange",
      "expectedWeight",
      "isGainHealthy",
      "bmiBand",
      "targetFor",
      "compareToGuidance",
    ]) {
      expect(Object.hasOwn(weight, forbidden)).toBe(false);
    }
  });

  it("gives the chart no field to hold a target in", () => {
    const chart = weightChart([entry("a", "2026-01-01", 62), entry("b", "2026-02-01", 63)])!;
    for (const forbidden of ["target", "recommended", "band", "status", "expected"]) {
      expect(Object.hasOwn(chart, forbidden)).toBe(false);
    }
    // The change is a number and nothing else — no judgement travels with it.
    expect(chart.changeSinceFirst).toBe(1);
  });
});

describe("isPlausibleWeight", () => {
  it("catches the stray keypress", () => {
    expect(isPlausibleWeight(650, "kg")).toBe(false);
    expect(isPlausibleWeight(6.5, "kg")).toBe(false);
    expect(isPlausibleWeight(65, "kg")).toBe(true);
    expect(isPlausibleWeight(145, "lb")).toBe(true);
  });

  it("stays wide enough never to become a comment on her body", () => {
    // Both ends are real people. This is a typo guard and must not narrow.
    expect(isPlausibleWeight(25, "kg")).toBe(true);
    expect(isPlausibleWeight(300, "kg")).toBe(true);
  });
});

describe("weightChart", () => {
  it("needs two readings before it draws anything", () => {
    expect(weightChart([entry("a", "2026-01-01", 62)])).toBeNull();
  });

  it("orders by date and pads the axis", () => {
    const chart = weightChart([
      entry("b", "2026-03-01", 64),
      entry("a", "2026-01-01", 62),
      entry("c", "2026-02-01", 63),
    ])!;
    expect(chart.points.map((p) => p.entryId)).toEqual(["a", "c", "b"]);
    expect(chart.low).toBeLessThan(62);
    expect(chart.high).toBeGreaterThan(64);
    for (const point of chart.points) {
      expect(point.y).toBeGreaterThan(0);
      expect(point.y).toBeLessThan(1);
    }
  });

  /**
   * Switching the axis to kilograms because one old entry was in kilograms would
   * make today's number unreadable to someone who thinks in pounds.
   */
  it("uses the unit she measured in most recently, converting the rest", () => {
    const chart = weightChart([
      entry("a", "2026-01-01", 60, "kg"),
      entry("b", "2026-02-01", 140, "lb"),
    ])!;
    expect(chart.unit).toBe("lb");
    // 60 kg is about 132.3 lb.
    expect(chart.points[0]!.value).toBeCloseTo(132.3, 1);
    expect(chart.changeSinceFirst).toBeCloseTo(7.7, 1);
  });

  it("converts consistently", () => {
    expect(toKg(10, "kg")).toBe(10);
    expect(toKg(220.46, "lb")).toBeCloseTo(100, 1);
  });
});
