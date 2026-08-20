import { describe, expect, it } from "vitest";
import { signalsFromRows, type SignalRows } from "./signals-from-rows";

/**
 * Which date the postpartum week is counted from (migration 0009, P2.4c).
 *
 * `updated_at` means *last edited*. Before `ended_on` existed it stood in for the
 * end date, and the comment in `signals-from-rows.ts` said plainly that a dedicated
 * column would be truer and was worth adding the day anything else edited an ended
 * pregnancy. P2.4b was that day: a follow-up schedule anchored to "last edited"
 * moves whenever she corrects a typo, taking her postpartum week with it.
 *
 * These two cases are the contract — the recorded date wins, and rows written
 * before the column still work.
 */

const rows = (over: Partial<SignalRows> = {}): SignalRows => ({
  ageBand: "25_34",
  periodStarts: [],
  conditions: [],
  pregnancy: null,
  symptomTypes: [],
  ttcIntent: false,
  ttcMonths: null,
  statedWeeksSinceBirth: null,
  todayISO: "2026-08-19",
  ...over,
});

const weeksAfter = (endedOn: string | null, updatedAt: string) =>
  signalsFromRows(
    rows({ pregnancy: { status: "completed", createdAt: "2025-10-01T00:00:00Z", updatedAt, endedOn } }),
  ).weeksSincePregnancyEnd;

describe("which date the postpartum week is counted from", () => {
  it("counts from the day she recorded, not from when the row was touched", () => {
    // Ended eight weeks ago and edited yesterday. Before 0009 this answered 0,
    // which would have told a woman two months post-birth that she had just given
    // birth — and handed her a follow-up window starting from yesterday.
    expect(weeksAfter("2026-06-24", "2026-08-18T10:00:00Z")).toBe(8);
  });

  it("falls back to the row timestamp for records written before the column existed", () => {
    expect(weeksAfter(null, "2026-06-24T10:00:00Z")).toBe(8);
  });

  it("treats an omitted field the same as an absent date", () => {
    // A Dart client or a golden fixture written before 0009 passes neither, and
    // must get the fallback rather than `undefined` arithmetic.
    const signals = signalsFromRows(
      rows({ pregnancy: { status: "completed", createdAt: "2025-10-01T00:00:00Z", updatedAt: "2026-06-24T10:00:00Z" } }),
    );
    expect(signals.weeksSincePregnancyEnd).toBe(8);
  });

  it("says nothing about weeks while a pregnancy is still active", () => {
    expect(
      weeksAfter("2026-06-24", "2026-08-18T10:00:00Z") !== null &&
        signalsFromRows(
          rows({
            pregnancy: {
              status: "active",
              createdAt: "2026-02-01T00:00:00Z",
              updatedAt: "2026-08-18T10:00:00Z",
              endedOn: null,
            },
          }),
        ).weeksSincePregnancyEnd,
    ).toBeNull();
  });
});
