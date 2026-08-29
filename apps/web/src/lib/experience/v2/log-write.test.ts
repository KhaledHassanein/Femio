import { describe, expect, it } from "vitest";

import { buildLogWrites, hasAnything, isSingleSelect, VITAL_UNITS } from "./log-write.ts";

const P = "00000000-0000-0000-0000-000000000001";
const DATE = "2026-08-29";

const draft = (selected: [string, number | null][] = [], vitals: Record<string, string> = {}) => ({
  selected: new Map(selected),
  vitals,
});

describe("buildLogWrites", () => {
  it("routes symptoms and moods to symptom_logs, carrying severity", () => {
    const w = buildLogWrites(P, DATE, draft([["cramps", 3]]));
    expect(w.symptomLogs).toEqual([{ profile_id: P, type: "cramps", severity: 3, logged_at: DATE }]);
  });

  it("routes intercourse to fertility_logs and never to symptom_logs", () => {
    const w = buildLogWrites(P, DATE, draft([["intercourse", null]]));
    expect(w.fertilityLog?.intercourse).toBe(true);
    expect(w.symptomLogs).toHaveLength(0);
  });

  it("routes cervical mucus to fertility_logs.cm_type", () => {
    const w = buildLogWrites(P, DATE, draft([["eggWhite", null]]));
    expect(w.fertilityLog).toEqual({
      profile_id: P,
      logged_at: DATE,
      cm_type: "eggWhite",
      intercourse: null,
    });
  });

  it("writes no fertility row when nothing fertility-shaped was logged", () => {
    expect(buildLogWrites(P, DATE, draft([["cramps", null]])).fertilityLog).toBeNull();
  });

  it("ignores an unknown term instead of throwing, so the rest of the day still saves", () => {
    const w = buildLogWrites(
      P,
      DATE,
      draft([
        ["removedInV3", 2],
        ["cramps", 1],
      ]),
    );
    expect(w.symptomLogs.map((r) => r.type)).toEqual(["cramps"]);
  });

  it("skips blank and unparseable vitals", () => {
    const w = buildLogWrites(P, DATE, draft([], { weight: "  ", glucose: "12kg", steps: "8000" }));
    expect(w.vitals).toEqual([
      {
        profile_id: P,
        type: "steps",
        value: 8000,
        unit: "",
        measured_at: `${DATE}T12:00:00.000Z`,
      },
    ]);
  });

  it("gives every vital in the vocabulary a unit", () => {
    const w = buildLogWrites(P, DATE, draft([], { weight: "62.5" }));
    expect(w.vitals[0]!.unit).toBe("kg");
    expect(Object.keys(VITAL_UNITS)).toContain("bp_sys");
  });

  it("does not treat a selected vital chip as a value", () => {
    expect(buildLogWrites(P, DATE, draft([["weight", null]])).vitals).toHaveLength(0);
  });
});

describe("hasAnything", () => {
  it("is false for an empty day and true for any one write", () => {
    expect(hasAnything(buildLogWrites(P, DATE, draft()))).toBe(false);
    expect(hasAnything(buildLogWrites(P, DATE, draft([["cramps", null]])))).toBe(true);
    expect(hasAnything(buildLogWrites(P, DATE, draft([], { steps: "10" })))).toBe(true);
  });
});

describe("isSingleSelect", () => {
  it("is true only for discharge, whose column is singular", () => {
    expect(isSingleSelect("discharge")).toBe(true);
    expect(isSingleSelect("symptom")).toBe(false);
    expect(isSingleSelect("mood")).toBe(false);
  });
});
