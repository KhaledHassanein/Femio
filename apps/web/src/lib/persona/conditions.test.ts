import { describe, expect, it } from "vitest";
import {
  buildConditionRows,
  CONDITION_CODES,
  CONDITIONS_BY_MODE,
  isConditionCode,
  type ConditionCode,
} from "@/lib/persona/conditions";
import { PERSONA_MODES } from "@/lib/persona/state";

describe("condition vocabulary", () => {
  it("every stage offers only codes from the vocabulary", () => {
    for (const mode of PERSONA_MODES) {
      for (const code of CONDITIONS_BY_MODE[mode]) {
        expect(isConditionCode(code)).toBe(true);
      }
    }
  });

  it("offers no duplicates within a stage", () => {
    for (const mode of PERSONA_MODES) {
      const codes = CONDITIONS_BY_MODE[mode];
      expect(new Set(codes).size).toBe(codes.length);
    }
  });

  it("keeps gestational and pre-existing diabetes as separate questions", () => {
    // docs/09 §8 rule 3. If the wizard asked one "diabetes?" question the resolver
    // could not gate D3 against D4, and the difference is a one-off postpartum
    // OGTT versus lifelong care.
    const pregnancy = CONDITIONS_BY_MODE.pregnancy;
    expect(pregnancy).toContain("gestational_diabetes");
    expect(pregnancy).toContain("diabetes");
  });

  it("general mode asks nothing — she has already declined to categorise herself", () => {
    expect(CONDITIONS_BY_MODE.general).toHaveLength(0);
  });

  it("every code is reachable from at least one stage", () => {
    const offered = new Set(Object.values(CONDITIONS_BY_MODE).flat());
    const orphans = CONDITION_CODES.filter((c) => !offered.has(c));
    expect(orphans).toEqual([]);
  });
});

describe("buildConditionRows", () => {
  it("marks every row self-reported and non-diagnostic", () => {
    // Femio never diagnoses (product rule 1). These two fields are the schema-level
    // expression of that, so nothing may write a row without them.
    const rows = buildConditionRows("user-1", ["pcos", "thyroid"]);
    expect(rows).toEqual([
      { profile_id: "user-1", condition_code: "pcos", source: "self", non_diagnostic: true },
      { profile_id: "user-1", condition_code: "thyroid", source: "self", non_diagnostic: true },
    ]);
  });

  it("de-duplicates, so re-running the wizard cannot double-write", () => {
    const rows = buildConditionRows("u", ["pcos", "pcos", "thyroid"] as ConditionCode[]);
    expect(rows).toHaveLength(2);
  });

  it("an empty selection writes nothing", () => {
    expect(buildConditionRows("u", [])).toEqual([]);
  });
});
