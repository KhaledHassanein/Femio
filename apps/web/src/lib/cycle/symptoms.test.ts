import { describe, expect, it } from "vitest";
import { readFileSync } from "node:fs";
import { join } from "node:path";
import {
  buildSymptomRows,
  KNOWN_SYMPTOMS,
  loggedAtForDate,
  normalizeCustomSymptom,
  SYMPTOM_GROUPS,
} from "./symptoms";
import { MENOPAUSE_SYMPTOMS } from "../menopause";

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

/**
 * The vocabulary and its copy, checked together (P2.4).
 *
 * A built-in key with no label does not throw — `track-screen` falls back to the raw
 * key, because that is correct for a *custom* symptom she typed herself. So a
 * built-in added without copy would quietly show a woman the string `nightSweats`,
 * in all four languages, and nothing else in the suite would notice.
 */
describe("the symptom vocabulary and the catalogs agree", () => {
  const en = JSON.parse(
    readFileSync(join(process.cwd(), "messages", "en.json"), "utf8"),
  ) as { symptoms: { items: Record<string, string> } };

  it("has an English label for every built-in symptom", () => {
    const missing = [...KNOWN_SYMPTOMS].filter((key) => !(key in en.symptoms.items));
    expect(missing, "built-in symptoms with no label").toEqual([]);
  });

  it("has no label left over from a symptom that was removed", () => {
    const orphaned = Object.keys(en.symptoms.items).filter((key) => !KNOWN_SYMPTOMS.has(key));
    expect(orphaned, "labels with no symptom").toEqual([]);
  });

  it("declares each key once, across all groups", () => {
    const all = SYMPTOM_GROUPS.flatMap((g) => g.symptoms);
    expect(all.length).toBe(new Set(all).size);
  });
});

/**
 * `MENOPAUSE_SYMPTOMS` decides **emphasis**, never availability — so every key in
 * it has to exist in the shared vocabulary every other mode logs from. A menopause
 * key that lived only in the menopause list would be restriction by data structure.
 */
describe("the menopause set is a view over the shared vocabulary", () => {
  it("contains only keys every mode can log", () => {
    const foreign = MENOPAUSE_SYMPTOMS.filter((key) => !KNOWN_SYMPTOMS.has(key));
    expect(foreign, "menopause symptoms missing from the shared set").toEqual([]);
  });

  /**
   * The circulating "34 symptoms of menopause" list includes osteoporosis and
   * allergies. Neither is something a woman notices and logs; both are findings a
   * clinician establishes, and offering one as a tickable symptom would be Femio
   * inviting a self-diagnosis and then storing it (product rule 1).
   */
  it("offers no diagnosis as a tickable symptom", () => {
    for (const diagnosis of [
      "osteoporosis",
      "allergies",
      "depression",
      "anxietyDisorder",
      "thyroid",
      "pcos",
    ]) {
      expect(KNOWN_SYMPTOMS.has(diagnosis)).toBe(false);
      expect(MENOPAUSE_SYMPTOMS as readonly string[]).not.toContain(diagnosis);
    }
  });

  /**
   * Irregular periods are *derived* from her period history, which the app already
   * holds and already reasons about. Asking her to tick it too would give the same
   * question two answers, and `predictNextPeriod` is the one that gets to answer it.
   */
  it("does not ask her to tick something the record already knows", () => {
    expect(MENOPAUSE_SYMPTOMS as readonly string[]).not.toContain("irregularPeriods");
  });
});
