import { describe, expect, it } from "vitest";
import { buildVisitSummary } from "./visit-summary";

const AT = "2026-07-24T10:00:00.000Z";

describe("buildVisitSummary", () => {
  it("computes cycle count, average length and range from period starts", () => {
    const s = buildVisitSummary(
      { cycles: [{ period_start: "2026-05-01" }, { period_start: "2026-05-29" }, { period_start: "2026-06-27" }] },
      AT,
    );
    expect(s.cycle.logged).toBe(3);
    expect(s.derived.averageLength).toBe(29); // 28 and 29 → mean 28.5 → 29
    expect(s.derived.rangeLow).toBe(28);
    expect(s.derived.rangeHigh).toBe(29);
    expect(s.cycle.lastPeriod).toBe("2026-06-27");
  });

  it("ignores gaps/outliers when computing lengths", () => {
    const s = buildVisitSummary(
      { cycles: [{ period_start: "2026-01-01" }, { period_start: "2026-06-01" }] },
      AT,
    );
    // 151-day gap is dropped → no valid lengths.
    expect(s.derived.averageLength).toBe(null);
    expect(s.cycle.logged).toBe(2);
  });

  it("caps recent symptoms at 15 and normalizes fields", () => {
    const symptoms = Array.from({ length: 20 }, (_, i) => ({
      type: "cramps",
      severity: i % 4 || null,
      logged_at: `2026-07-${String((i % 28) + 1).padStart(2, "0")}T08:00:00Z`,
    }));
    const s = buildVisitSummary({ symptoms }, AT);
    expect(s.symptoms.length).toBe(15);
    expect(s.symptoms[0]!.date).toMatch(/^\d{4}-\d{2}-\d{2}$/);
  });

  it("excludes key dates the user marked hidden", () => {
    const s = buildVisitSummary(
      {
        keyDates: [
          { label: "Anniversary", date: "2026-03-01", display_pref: "hidden" },
          { label: "Started meds", date: "2026-04-01" },
        ],
      },
      AT,
    );
    expect(s.keyDates).toEqual([{ label: "Started meds", date: "2026-04-01" }]);
  });

  it("marks meds active unless explicitly false; passes through conditions", () => {
    const s = buildVisitSummary(
      {
        meds: [{ name: "Vitamin D" }, { name: "Old med", active: false }],
        conditions: [{ condition_code: "pcos", source: "self" }],
      },
      AT,
    );
    expect(s.meds).toEqual([
      { name: "Vitamin D", active: true },
      { name: "Old med", active: false },
    ]);
    expect(s.conditions).toEqual([{ code: "pcos", source: "self" }]);
  });
});

describe("recorded and derived stay apart (R3.1c)", () => {
  const iso = "2026-08-21T00:00:00.000Z";

  it("puts nothing computed in the recorded section", () => {
    const s = buildVisitSummary(
      { cycles: [{ period_start: "2026-08-05" }, { period_start: "2026-07-08" }] },
      iso,
    );
    // The whole requirement: `cycle` is what she wrote down, and carries no estimate.
    expect(Object.keys(s.cycle).sort()).toEqual(["lastPeriod", "logged", "recent"]);
  });

  it("says an average came from her own logs when it did", () => {
    const s = buildVisitSummary(
      {
        cycles: [{ period_start: "2026-08-05" }, { period_start: "2026-07-08" }],
      },
      iso,
    );
    expect(s.derived.basis).toBe("observed");
    expect(s.derived.averageLength).toBe(28);
  });

  it("says an average came from what she stated when it did", () => {
    const s = buildVisitSummary(
      { cycles: [{ period_start: "2026-08-05" }], statedCycleLength: 30 },
      iso,
    );
    expect(s.derived.basis).toBe("stated");
    expect(s.derived.averageLength).toBe(30);
    // A remembered number has no measured spread, and inventing one would dress it
    // as a measurement.
    expect(s.derived.rangeLow).toBeNull();
    expect(s.derived.rangeHigh).toBeNull();
  });

  it("agrees with the dashboard about consecutive logged days", () => {
    // The report used to compute its own intervals, so three days of one period
    // became three cycles here too — and the printed page is the one that wins an
    // argument in a consulting room (R3.1.9).
    const s = buildVisitSummary(
      {
        cycles: [
          { period_start: "2026-08-17" },
          { period_start: "2026-08-18" },
          { period_start: "2026-08-19" },
        ],
      },
      iso,
    );
    expect(s.derived.averageLength).not.toBe(1);
    expect(s.derived.averageLength).toBeNull();
    // Her three logged days are still all present as *records*.
    expect(s.cycle.logged).toBe(3);
  });

  it("estimates nothing when there is nothing to estimate from", () => {
    const s = buildVisitSummary({ cycles: [] }, iso);
    expect(s.derived.averageLength).toBeNull();
    expect(s.derived.basis).toBeNull();
    expect(s.derived.predictedWindow).toBeNull();
  });
});
