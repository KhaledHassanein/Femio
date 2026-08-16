import { describe, expect, it } from "vitest";
import * as medications from "./index";
import {
  daysOn,
  fromRow,
  MAX_NAME_LENGTH,
  normalizeName,
  splitMedications,
  toScheduleJson,
  type Medication,
} from "./index";

const TODAY = "2026-08-16";

const med = (over: Partial<Medication> = {}): Medication => ({
  id: over.id ?? "m",
  name: over.name ?? "Levothyroxine",
  dose: null,
  schedule: null,
  startedOn: null,
  stoppedOn: null,
  active: true,
  note: null,
  ...over,
});

/**
 * The two things this module must never grow.
 *
 * Dosing guidance would make Femio something other than wellness, education and
 * tracking. An adherence score would make the worst days worse — `docs/09`
 * invariant 7 — and the apps that grade people on taking their medicine reliably do
 * exactly that.
 */
describe("what it will not do", () => {
  it("exports nothing that advises on a dose", () => {
    for (const forbidden of [
      "suggestDose",
      "validateDose",
      "maxDose",
      "isDoseSafe",
      "recommendedDose",
      "interactionsWith",
    ]) {
      expect(Object.hasOwn(medications, forbidden)).toBe(false);
    }
  });

  it("exports nothing that scores her on taking it", () => {
    for (const forbidden of ["adherence", "streakOf", "missedDoses", "complianceRate"]) {
      expect(Object.hasOwn(medications, forbidden)).toBe(false);
    }
  });

  it("gives a record no field to hold either in", () => {
    const m = med();
    for (const forbidden of ["adherence", "streak", "missed", "recommendedDose", "severity"]) {
      expect(Object.hasOwn(m, forbidden)).toBe(false);
    }
  });
});

describe("normalizeName", () => {
  it("trims, collapses whitespace and caps length", () => {
    expect(normalizeName("  oestrogen   patch ")).toBe("oestrogen patch");
    expect(normalizeName("x".repeat(200))!.length).toBe(MAX_NAME_LENGTH);
  });

  it("refuses an empty name and nothing else", () => {
    expect(normalizeName("   ")).toBeNull();
    // A medicine name is hers to write — no allowlist, no spellcheck, no rejection
    // of something Femio has not heard of.
    expect(normalizeName("Utrogestan 100mg (nights)")).toBe("Utrogestan 100mg (nights)");
  });
});

describe("splitMedications", () => {
  it("puts what she takes now first, alphabetically", () => {
    const rows = [med({ id: "b", name: "Vitamin D" }), med({ id: "a", name: "Levothyroxine" })];
    expect(splitMedications(rows).current.map((m) => m.id)).toEqual(["a", "b"]);
  });

  /**
   * Stopping is a state, not a deletion. "I used to be on this" is one of the most
   * useful things in a medical history, and rule 5 says the record never loses what
   * was true.
   */
  it("keeps what she stopped, most recently stopped first", () => {
    const rows = [
      med({ id: "old", active: false, stoppedOn: "2025-01-01" }),
      med({ id: "recent", active: false, stoppedOn: "2026-06-01" }),
      med({ id: "now" }),
    ];
    const { current, stopped } = splitMedications(rows);
    expect(current.map((m) => m.id)).toEqual(["now"]);
    expect(stopped.map((m) => m.id)).toEqual(["recent", "old"]);
  });
});

describe("daysOn", () => {
  it("counts from the date she gave", () => {
    expect(daysOn(med({ startedOn: "2026-08-01" }), TODAY)).toBe(15);
  });

  it("stops counting at the day she stopped", () => {
    expect(daysOn(med({ startedOn: "2026-01-01", stoppedOn: "2026-01-31" }), TODAY)).toBe(30);
  });

  it("says nothing when she gave no date", () => {
    expect(daysOn(med(), TODAY)).toBeNull();
  });

  it("returns null rather than a negative count for a future start", () => {
    expect(daysOn(med({ startedOn: "2027-01-01" }), TODAY)).toBeNull();
  });
});

describe("toScheduleJson / fromRow", () => {
  it("round-trips everything the row carries", () => {
    const original = med({
      dose: "50 mcg",
      schedule: "daily",
      startedOn: "2026-05-01",
      note: "morning, before food",
    });
    const back = fromRow({
      id: original.id,
      name: original.name,
      active: original.active,
      schedule_json: toScheduleJson(original),
    });
    expect(back).toEqual(original);
  });

  it("reads a row written before a field existed", () => {
    const back = fromRow({ id: "m", name: "Vitamin D", active: true, schedule_json: null });
    expect(back.dose).toBeNull();
    expect(back.schedule).toBeNull();
    expect(back.name).toBe("Vitamin D");
  });

  it("drops a schedule value this build does not know", () => {
    const back = fromRow({
      id: "m",
      name: "x",
      active: true,
      schedule_json: { schedule: "fortnightly" },
    });
    expect(back.schedule).toBeNull();
  });
});
