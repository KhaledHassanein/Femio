import { describe, expect, it } from "vitest";
import { buildSymptomRows, normalizeCustomSymptom } from "./symptoms";

describe("normalizeCustomSymptom", () => {
  it("trims, collapses whitespace, and caps length", () => {
    expect(normalizeCustomSymptom("  hot   flushes  ")).toBe("hot flushes");
    expect(normalizeCustomSymptom("x".repeat(60))!.length).toBe(40);
  });

  it("rejects empty and duplicates (built-in or already selected, case-insensitively)", () => {
    expect(normalizeCustomSymptom("   ")).toBeNull();
    expect(normalizeCustomSymptom("Cramps")).toBeNull(); // built-in "cramps"
    expect(normalizeCustomSymptom("My symptom", ["my symptom"])).toBeNull();
    expect(normalizeCustomSymptom("New one", ["something"])).toBe("New one");
  });
});

describe("buildSymptomRows", () => {
  it("emits one row per symptom, each with its own severity + shared note", () => {
    const rows = buildSymptomRows(
      "user-1",
      [
        ["cramps", 3],
        ["hot flushes", null],
      ],
      "  felt off  ",
    );
    expect(rows).toEqual([
      { profile_id: "user-1", type: "cramps", severity: 3, note: "felt off" },
      { profile_id: "user-1", type: "hot flushes", severity: null, note: "felt off" },
    ]);
  });

  it("normalizes an empty note to null", () => {
    expect(buildSymptomRows("u", [["sad", null]], "   ")[0]!.note).toBeNull();
  });
});
