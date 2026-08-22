import { describe, expect, it } from "vitest";
import { observedRange } from "./variability";

describe("observedRange", () => {
  it("states her range as fact once there are three intervals", () => {
    const r = observedRange(["2026-05-01", "2026-05-25", "2026-06-28", "2026-08-08"])!;
    expect(r.shortest).toBe(24);
    expect(r.longest).toBe(41);
    expect(r.spread).toBe(17);
    expect(r.cycles).toBe(3);
  });

  it("says nothing from two intervals — that is not a range", () => {
    expect(observedRange(["2026-05-01", "2026-05-25", "2026-06-28"])).toBeNull();
    expect(observedRange(["2026-05-01"])).toBeNull();
    expect(observedRange([])).toBeNull();
  });

  it("excludes gaps too long to be a cycle", () => {
    // Otherwise her range reads "28 to 151 days" — true of her logs, useless as a
    // description of her cycles, and the drift R3.1.10 exists to close.
    const r = observedRange([
      "2025-01-01",
      "2026-05-01",
      "2026-05-29",
      "2026-06-26",
      "2026-07-24",
    ])!;
    expect(r.longest).toBe(28);
    expect(r.cycles).toBe(3);
  });

  it("treats consecutive logged period days as one cycle", () => {
    const r = observedRange([
      "2026-05-01",
      "2026-05-02",
      "2026-05-25",
      "2026-06-28",
      "2026-08-08",
    ])!;
    expect(r.shortest).toBe(24);
    expect(r.cycles).toBe(3);
  });

  it("reports a zero spread without complaint when her cycles are steady", () => {
    // A regular user gets a range too — it is a fact either way, and nothing here
    // grades it. There is no ideal variability.
    const r = observedRange(["2026-05-06", "2026-06-03", "2026-07-01", "2026-07-29"])!;
    expect(r.spread).toBe(0);
    expect(r.shortest).toBe(28);
  });
});
