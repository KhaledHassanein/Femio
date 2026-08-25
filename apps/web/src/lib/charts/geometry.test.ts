import { describe, expect, it } from "vitest";

import {
  confidenceBand,
  dotStrip,
  flipX,
  hasEnoughPoints,
  histogram,
  linearScale,
  niceBounds,
  plotArea,
  polyline,
  rangeBand,
  ringProgress,
  timeSeries,
} from "./geometry.ts";

const BOX = { width: 300, height: 100 };

describe("plotArea", () => {
  it("subtracts padding from both sides", () => {
    const a = plotArea({ width: 300, height: 100, padding: { left: 20, right: 10, top: 5, bottom: 5 } });
    expect(a).toEqual({ x: 20, y: 5, width: 270, height: 90 });
  });

  it("never returns a negative size", () => {
    const a = plotArea({ width: 10, height: 10, padding: { left: 20, right: 20 } });
    expect(a.width).toBe(0);
  });
});

describe("RTL is one thing to get right, not seven", () => {
  it("mirrors within the plot area", () => {
    const area = { x: 0, width: 100 };
    expect(flipX(0, area, "rtl")).toBe(100);
    expect(flipX(100, area, "rtl")).toBe(0);
    expect(flipX(25, area, "rtl")).toBe(75);
  });

  it("leaves ltr untouched", () => {
    expect(flipX(25, { x: 0, width: 100 }, "ltr")).toBe(25);
  });

  it("reverses a dot strip so day one reads first in Arabic", () => {
    const ltr = dotStrip(5, BOX, "ltr");
    const rtl = dotStrip(5, BOX, "rtl");
    expect(ltr[0]!.cx).toBeLessThan(ltr[4]!.cx);
    expect(rtl[0]!.cx).toBeGreaterThan(rtl[4]!.cx);
  });

  it("keeps a range band the same width when mirrored", () => {
    // The band must move, not resize. An early implementation that flipped only the
    // left edge produced a band of the wrong length in Arabic.
    const ltr = rangeBand(2, 5, 10, BOX, "ltr")!;
    const rtl = rangeBand(2, 5, 10, BOX, "rtl")!;
    expect(rtl.width).toBeCloseTo(ltr.width);
    expect(rtl.x).not.toBeCloseTo(ltr.x);
  });

  it("keeps histogram bars the same width when mirrored", () => {
    const ltr = histogram([1, 2, 3], BOX, "ltr");
    const rtl = histogram([1, 2, 3], BOX, "rtl");
    expect(rtl[0]!.width).toBeCloseTo(ltr[0]!.width);
    expect(rtl[0]!.x).toBeGreaterThan(rtl[2]!.x);
  });
});

describe("linearScale", () => {
  it("maps a value across the size", () => {
    expect(linearScale(5, 0, 10, 100)).toBe(50);
  });

  it("puts a single value in the middle instead of dividing by zero", () => {
    // One logged weight is a real state. NaN would render nothing at all.
    expect(linearScale(70, 70, 70, 100)).toBe(50);
  });
});

describe("niceBounds", () => {
  it("rounds outward to human numbers", () => {
    const b = niceBounds(28.4, 31.7);
    expect(b.min).toBeLessThanOrEqual(28.4);
    expect(b.max).toBeGreaterThanOrEqual(31.7);
    expect(Number.isInteger(b.ticks[0])).toBe(true);
  });

  it("gives a flat series room above and below", () => {
    const b = niceBounds(70, 70);
    expect(b.min).toBeLessThan(70);
    expect(b.max).toBeGreaterThan(70);
  });

  it("survives non-finite input", () => {
    expect(niceBounds(Number.NaN, Number.POSITIVE_INFINITY)).toEqual({ min: 0, max: 1, ticks: [0, 1] });
  });

  it("terminates on a pathological range", () => {
    expect(niceBounds(0, 1e12).ticks.length).toBeLessThanOrEqual(64);
  });
});

describe("timeSeries", () => {
  it("puts a higher value nearer the top", () => {
    const { points } = timeSeries({ values: [1, 10], box: BOX });
    expect(points[1]!.y).toBeLessThan(points[0]!.y);
  });

  it("breaks the line where she did not log", () => {
    // Interpolating across a gap implies data she never gave — the visual
    // equivalent of inventing a reading.
    const { segments } = timeSeries({ values: [1, 2, null, 4, 5], box: BOX });
    expect(segments).toHaveLength(2);
    expect(segments[0]).toHaveLength(2);
    expect(segments[1]).toHaveLength(2);
  });

  it("returns nulls in place so an index still maps to a day", () => {
    const { points } = timeSeries({ values: [1, null, 3], box: BOX });
    expect(points[1]).toBeNull();
    expect(points).toHaveLength(3);
  });

  it("handles an empty series without throwing", () => {
    expect(timeSeries({ values: [], box: BOX }).segments).toEqual([]);
  });
});

describe("polyline", () => {
  it("starts with a move and continues with lines", () => {
    expect(polyline([{ x: 1, y: 2 }, { x: 3, y: 4 }])).toBe("M1.00 2.00 L3.00 4.00");
  });

  it("is empty for no points", () => {
    expect(polyline([])).toBe("");
  });
});

describe("rangeBand", () => {
  it("includes both ends", () => {
    // "From the 16th to the 26th" includes the 26th. Off-by-one here quietly drops
    // her last fertile day.
    const band = rangeBand(0, 0, 10, { width: 100, height: 10 })!;
    expect(band.width).toBeCloseTo(10);
  });

  it("clamps to the domain", () => {
    const band = rangeBand(-5, 99, 10, { width: 100, height: 10 })!;
    expect(band.x).toBeCloseTo(0);
    expect(band.width).toBeCloseTo(100);
  });

  it("returns null when there is nothing to draw", () => {
    expect(rangeBand(0, 1, 0, BOX)).toBeNull();
  });
});

describe("ringProgress", () => {
  it("dashes the whole circumference at 1", () => {
    const r = ringProgress(1, { width: 100, height: 100 });
    expect(r.dash).toBeCloseTo(r.circumference);
  });

  it("clamps out-of-range and non-finite progress", () => {
    expect(ringProgress(2, BOX).dash).toBeCloseTo(ringProgress(1, BOX).dash);
    expect(ringProgress(-1, BOX).dash).toBe(0);
    expect(ringProgress(Number.NaN, BOX).dash).toBe(0);
  });

  it("keeps the stroke inside the box", () => {
    const r = ringProgress(0.5, { width: 100, height: 100 }, { strokeWidth: 20 });
    expect(r.r + r.strokeWidth / 2).toBeLessThanOrEqual(50);
  });
});

describe("confidenceBand", () => {
  it("closes the area path", () => {
    const c = confidenceBand({
      centre: [5, 6, 7],
      lower: [4, 5, 6],
      upper: [6, 7, 8],
      box: BOX,
    });
    expect(c.area.startsWith("M")).toBe(true);
    expect(c.area.endsWith("Z")).toBe(true);
    expect(c.centreLine).not.toBe("");
  });

  it("shares one scale between the band and its centre", () => {
    // If the band and the line were scaled separately the centre could fall outside
    // its own interval, which would be worse than drawing nothing.
    const c = confidenceBand({ centre: [5], lower: [0], upper: [10], box: BOX });
    expect(c.bounds.min).toBeLessThanOrEqual(0);
    expect(c.bounds.max).toBeGreaterThanOrEqual(10);
  });

  it("draws no area when there is no interval", () => {
    expect(confidenceBand({ centre: [5], lower: [], upper: [], box: BOX }).area).toBe("");
  });
});

describe("hasEnoughPoints", () => {
  it("refuses to call two points a trend", () => {
    expect(hasEnoughPoints([1, 2])).toBe(false);
    expect(hasEnoughPoints([1, 2, 3])).toBe(true);
  });

  it("does not count gaps", () => {
    expect(hasEnoughPoints([1, null, 2, null])).toBe(false);
  });
});
