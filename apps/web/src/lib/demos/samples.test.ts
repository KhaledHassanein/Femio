import { existsSync } from "node:fs";
import { join } from "node:path";
import { describe, expect, it } from "vitest";

import { diffDays } from "../calculators/dates.ts";
import { PERIOD_PATTERNS, periodDemo, TOUR_SCREENS, tourImage } from "./samples.ts";

const width = (p: { windowStart: string; windowEnd: string }) => diffDays(p.windowStart, p.windowEnd);

describe("period demo (synthetic samples, MR-51)", () => {
  it("shows three widening ranges for regular cycles, confidence never rising", () => {
    const { periods } = periodDemo("regular");
    expect(periods).toHaveLength(3);
    expect(width(periods[1]!)).toBeGreaterThan(width(periods[0]!));
    expect(width(periods[2]!)).toBeGreaterThan(width(periods[1]!));
    const order = ["high", "medium", "low"];
    for (let i = 1; i < periods.length; i += 1) {
      expect(order.indexOf(periods[i]!.confidence)).toBeGreaterThanOrEqual(order.indexOf(periods[i - 1]!.confidence));
    }
  });

  it("shows only the next period when cycles vary", () => {
    const demo = periodDemo("varies");
    expect(demo.prediction?.irregular).toBe(true);
    expect(demo.periods).toHaveLength(1);
  });

  it("a stated regular length shows three periods, all low confidence (MR-57)", () => {
    const demo = periodDemo("new");
    expect(demo.prediction?.learning).toBe(true);
    expect(demo.periods).toHaveLength(3);
    expect(demo.periods.every((p) => p.confidence === "low")).toBe(true);
  });

  it("never draws a single date: every range spans days", () => {
    for (const p of PERIOD_PATTERNS) {
      for (const r of periodDemo(p).periods) expect(width(r)).toBeGreaterThan(0);
    }
  });
});

describe("tour screenshots", () => {
  it("has every image it points at", () => {
    const pub = join(__dirname, "..", "..", "..", "public");
    for (const { key } of TOUR_SCREENS) {
      for (const locale of ["en", "ar", "fr", "es"]) {
        const { light, dark } = tourImage(key, locale);
        expect(existsSync(join(pub, light))).toBe(true);
        if (dark) expect(existsSync(join(pub, dark))).toBe(true);
      }
    }
  });
});
