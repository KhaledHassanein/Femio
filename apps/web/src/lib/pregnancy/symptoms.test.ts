import { describe, expect, it } from "vitest";
import {
  EMERGENCY_SYMPTOMS,
  PREGNANCY_SYMPTOMS,
  PREGNANCY_SYMPTOM_GROUPS,
  SAME_DAY_SYMPTOMS,
  urgencyFor,
  urgencyOf,
} from "./symptoms";

describe("urgencyOf", () => {
  it("returns null when nothing selected is urgent", () => {
    expect(urgencyOf(["nausea", "fatigue", "heartburn"])).toBeNull();
    expect(urgencyOf([])).toBeNull();
  });

  it("flags a same-day symptom", () => {
    expect(urgencyOf(["nausea", "reducedMovements"])).toBe("sameDay");
  });

  it("flags an emergency symptom", () => {
    expect(urgencyOf(["heavyBleeding"])).toBe("emergency");
  });

  it("returns the HIGHEST urgency, not the first match", () => {
    // Showing both tiers at once would bury the more serious one.
    expect(urgencyOf(["reducedMovements", "heavyBleeding"])).toBe("emergency");
    expect(urgencyOf(["heavyBleeding", "reducedMovements"])).toBe("emergency");
  });

  it("catches self-harm as an emergency, not a mood entry", () => {
    // The one symptom where treating it as an ordinary log would be indefensible.
    expect(urgencyOf(["thoughtsOfHarm"])).toBe("emergency");
  });

  it("ignores unknown and custom symptoms", () => {
    expect(urgencyOf(["something the user typed"])).toBeNull();
  });
});

describe("urgencyFor", () => {
  it("classifies each tier", () => {
    expect(urgencyFor("severeAbdominalPain")).toBe("emergency");
    expect(urgencyFor("visionChanges")).toBe("sameDay");
    expect(urgencyFor("nausea")).toBeNull();
  });
});

describe("the symptom sets", () => {
  it("keeps the two urgency tiers disjoint", () => {
    // A symptom in both tiers would make urgencyFor's answer depend on lookup order.
    const sameDay: readonly string[] = SAME_DAY_SYMPTOMS;
    const overlap = (EMERGENCY_SYMPTOMS as readonly string[]).filter((s) => sameDay.includes(s));
    expect(overlap).toEqual([]);
  });

  it("keeps urgent symptoms out of the ordinary picker groups", () => {
    // They are surfaced separately; listing them among everyday symptoms would
    // present "heavy bleeding" as just another thing to tick.
    const everyday: string[] = PREGNANCY_SYMPTOM_GROUPS.flatMap((g) => [...g.symptoms]);
    const urgent: string[] = [...EMERGENCY_SYMPTOMS, ...SAME_DAY_SYMPTOMS];
    expect(everyday.filter((s) => urgent.includes(s))).toEqual([]);
  });

  it("includes every group symptom and both tiers in the known set", () => {
    for (const s of PREGNANCY_SYMPTOM_GROUPS.flatMap((g) => g.symptoms)) {
      expect(PREGNANCY_SYMPTOMS.has(s)).toBe(true);
    }
    for (const s of [...EMERGENCY_SYMPTOMS, ...SAME_DAY_SYMPTOMS]) {
      expect(PREGNANCY_SYMPTOMS.has(s)).toBe(true);
    }
  });

  it("has no duplicate keys within the everyday groups", () => {
    const everyday: string[] = PREGNANCY_SYMPTOM_GROUPS.flatMap((g) => [...g.symptoms]);
    expect(new Set(everyday).size).toBe(everyday.length);
  });
});
