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
    expect(s.cycle.averageLength).toBe(29); // 28 and 29 → mean 28.5 → 29
    expect(s.cycle.rangeLow).toBe(28);
    expect(s.cycle.rangeHigh).toBe(29);
    expect(s.cycle.lastPeriod).toBe("2026-06-27");
  });

  it("ignores gaps/outliers when computing lengths", () => {
    const s = buildVisitSummary(
      { cycles: [{ period_start: "2026-01-01" }, { period_start: "2026-06-01" }] },
      AT,
    );
    // 151-day gap is dropped → no valid lengths.
    expect(s.cycle.averageLength).toBe(null);
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
