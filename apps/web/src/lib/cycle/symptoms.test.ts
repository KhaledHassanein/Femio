import { describe, expect, it } from "vitest";
import { buildSymptomRows, loggedAtForDate, normalizeCustomSymptom } from "./symptoms";

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

  it("omits logged_at unless a backdated timestamp is supplied", () => {
    expect(buildSymptomRows("u", [["sad", null]], "")[0]).not.toHaveProperty("logged_at");
    const rows = buildSymptomRows("u", [["sad", null]], "", "2026-08-05T12:00:00.000Z");
    expect(rows[0]!.logged_at).toBe("2026-08-05T12:00:00.000Z");
  });
});

describe("loggedAtForDate", () => {
  it("returns null for today, so the row keeps the real time of day", () => {
    expect(loggedAtForDate("2026-08-07", "2026-08-07")).toBeNull();
  });

  it("puts an earlier day at local noon, so it reads back as the day she picked", () => {
    for (const date of ["2026-08-05", "2026-01-01", "2026-03-29", "2026-12-31"]) {
      const back = new Date(loggedAtForDate(date, "2026-08-07")!);
      const local = [
        back.getFullYear(),
        String(back.getMonth() + 1).padStart(2, "0"),
        String(back.getDate()).padStart(2, "0"),
      ].join("-");
      expect(local).toBe(date);
      // Noon, not midnight: zones that spring forward at 00:00 have no midnight
      // on the transition date and the timestamp would roll into the next day.
      expect(back.getHours()).toBe(12);
    }
  });
});
