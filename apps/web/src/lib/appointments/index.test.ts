import { describe, expect, it } from "vitest";
import {
  awaitingResults,
  daysUntil,
  nextAppointment,
  parsePrep,
  splitAppointments,
  type Appointment,
} from "./index";

const TODAY = "2026-08-16";

const appointment = (over: Partial<Appointment> = {}): Appointment => ({
  id: over.id ?? "a",
  clinician: null,
  type: null,
  datetime: null,
  prep: [],
  resultsDue: null,
  ...over,
});

describe("splitAppointments", () => {
  it("keeps today in the future — an appointment this afternoon has not happened", () => {
    const today = appointment({ id: "today", datetime: "2026-08-16T14:00:00Z" });
    const { upcoming, past } = splitAppointments([today], TODAY);
    expect(upcoming.map((a) => a.id)).toEqual(["today"]);
    expect(past).toHaveLength(0);
  });

  it("puts an undated appointment first, not last", () => {
    // She wrote it down because it is going to happen. Sorting it under last
    // year's would bury the one thing still needing a date.
    const { upcoming } = splitAppointments(
      [appointment({ id: "dated", datetime: "2026-09-01T09:00:00Z" }), appointment({ id: "undated" })],
      TODAY,
    );
    expect(upcoming.map((a) => a.id)).toEqual(["undated", "dated"]);
  });

  it("sorts forwards soonest-first and backwards most-recent-first", () => {
    const rows = [
      appointment({ id: "far", datetime: "2026-12-01T09:00:00Z" }),
      appointment({ id: "soon", datetime: "2026-08-20T09:00:00Z" }),
      appointment({ id: "old", datetime: "2026-01-05T09:00:00Z" }),
      appointment({ id: "recent", datetime: "2026-08-01T09:00:00Z" }),
    ];
    const { upcoming, past } = splitAppointments(rows, TODAY);
    expect(upcoming.map((a) => a.id)).toEqual(["soon", "far"]);
    expect(past.map((a) => a.id)).toEqual(["recent", "old"]);
  });
});

describe("nextAppointment", () => {
  it("skips the undated one — it cannot be next if it has no when", () => {
    const rows = [
      appointment({ id: "undated" }),
      appointment({ id: "soon", datetime: "2026-08-20T09:00:00Z" }),
    ];
    expect(nextAppointment(rows, TODAY)?.id).toBe("soon");
  });

  it("returns null rather than reaching into the past", () => {
    expect(nextAppointment([appointment({ datetime: "2026-01-01T09:00:00Z" })], TODAY)).toBeNull();
  });
});

describe("daysUntil", () => {
  it("counts whole days and goes negative once it has passed", () => {
    expect(daysUntil(appointment({ datetime: "2026-08-20T23:30:00Z" }), TODAY)).toBe(4);
    expect(daysUntil(appointment({ datetime: "2026-08-14T01:00:00Z" }), TODAY)).toBe(-2);
    expect(daysUntil(appointment(), TODAY)).toBeNull();
  });
});

describe("awaitingResults", () => {
  it("lists only results whose expected date has passed", () => {
    const rows = [
      appointment({ id: "overdue", resultsDue: "2026-08-10" }),
      appointment({ id: "today", resultsDue: TODAY }),
      appointment({ id: "later", resultsDue: "2026-09-01" }),
      appointment({ id: "none" }),
    ];
    expect(awaitingResults(rows, TODAY).map((a) => a.id)).toEqual(["overdue"]);
  });

  it("oldest first — the one she has been waiting longest for", () => {
    const rows = [
      appointment({ id: "b", resultsDue: "2026-08-10" }),
      appointment({ id: "a", resultsDue: "2026-07-01" }),
    ];
    expect(awaitingResults(rows, TODAY).map((a) => a.id)).toEqual(["a", "b"]);
  });

  /**
   * The property that matters more than any ordering. `Appointment` has no field
   * for a result, and this module has no function that returns one: the most it can
   * ever say is "you were expecting to hear by now", which is a prompt to chase a
   * human. Same reasoning as ADR-049's missing `result` column.
   */
  it("cannot express an outcome at all", () => {
    const a = appointment({ resultsDue: "2026-08-10" });
    for (const forbidden of ["result", "outcome", "status", "normal", "abnormal", "severity"]) {
      expect(Object.hasOwn(a, forbidden)).toBe(false);
    }
  });
});

describe("parsePrep", () => {
  it("drops blank lines and keeps her order", () => {
    expect(parsePrep("  ask about iron \n\n  is the pain normal?\n")).toEqual([
      "ask about iron",
      "is the pain normal?",
    ]);
  });

  it("keeps a repeated question — wanting to ask twice is not our call", () => {
    expect(parsePrep("iron\niron")).toEqual(["iron", "iron"]);
  });

  it("returns nothing for nothing", () => {
    expect(parsePrep("   \n \n")).toEqual([]);
  });
});
