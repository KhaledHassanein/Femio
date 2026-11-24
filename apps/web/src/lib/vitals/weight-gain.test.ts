import { describe, expect, it } from "vitest";
import { weightGainRange } from "./weight-gain";

// MR-54 as properties; the full table is pinned by `fixtures/domain/weight-gain.json`.
describe("weightGainRange (MR-54, IOM 2009)", () => {
  it("returns the one-baby range for a BMI in the healthy band", () => {
    expect(weightGainRange(62, 165, 1)).toEqual({
      bmi: 22.8,
      band: "normal",
      babies: 1,
      range: { lowKg: 11.5, highKg: 16, lowLb: 25, highLb: 35 },
      noRangeReason: null,
    });
  });

  it("gives no range for twins under BMI 18.5, nor for three or more babies", () => {
    expect(weightGainRange(50, 170, 2)?.noRangeReason).toBe("twinsUnderweight");
    expect(weightGainRange(62, 165, 3)?.noRangeReason).toBe("multiples");
    expect(weightGainRange(62, 165, 3)?.range).toBeNull();
  });

  it("uses the rounded BMI at the band edges, like the BMI calculator", () => {
    expect(weightGainRange(72.2, 170, 1)?.band).toBe("overweight"); // 24.98 → 25.0
  });

  it("refuses input outside the accepted ranges", () => {
    expect(weightGainRange(24, 160, 1)).toBeNull();
    expect(weightGainRange(301, 160, 1)).toBeNull();
    expect(weightGainRange(60, 119, 1)).toBeNull();
    expect(weightGainRange(60, 160, 0)).toBeNull();
    expect(weightGainRange(Number.NaN, 160, 1)).toBeNull();
  });

  it("never returns a verdict word, only band names and numbers", () => {
    const r = weightGainRange(95, 158, 1)!;
    expect(Object.keys(r).sort()).toEqual(["babies", "band", "bmi", "noRangeReason", "range"]);
  });
});
