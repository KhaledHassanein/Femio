import { describe, expect, it } from "vitest";
import { FIRST_ROW_WEEK, LAST_ROW_WEEK, pregnancyCalendar } from "./calendar";

// The register's rules (MR-53) as properties; the exact dates are pinned by the
// golden fixture `pregnancy-calendar.json`.
describe("pregnancyCalendar (MR-53)", () => {
  const cal = pregnancyCalendar("2027-03-01", "2026-09-14")!;

  it("lists every week from 4 to 41, each exactly seven days, back to back", () => {
    expect(cal.weeks.map((w) => w.week)).toEqual(Array.from({ length: LAST_ROW_WEEK - FIRST_ROW_WEEK + 1 }, (_, i) => i + FIRST_ROW_WEEK));
    for (let i = 1; i < cal.weeks.length; i += 1) {
      const prev = cal.weeks[i - 1]!;
      const next = new Date(`${prev.end}T00:00:00Z`);
      next.setUTCDate(next.getUTCDate() + 1);
      expect(cal.weeks[i]!.start).toBe(next.toISOString().slice(0, 10));
    }
  });

  it("puts the due date in week 40 and the term window from week 37 to the end of week 41", () => {
    const w40 = cal.weeks.find((w) => w.week === 40)!;
    expect(w40.start).toBe(cal.edd);
    expect(cal.weeks.find((w) => w.week === 37)!.start).toBe(cal.termStart);
    expect(cal.termEnd > cal.weeks.at(-1)!.end).toBe(true);
  });

  it("links a guide for weeks 4 to 40 only", () => {
    expect(cal.weeks.filter((w) => w.guide).map((w) => w.week)).toEqual(Array.from({ length: 37 }, (_, i) => i + 4));
    expect(cal.weeks.find((w) => w.week === 41)!.guide).toBeNull();
  });

  it("marks no week before week 4 or after week 41", () => {
    expect(pregnancyCalendar("2027-07-10", "2026-10-10")!.currentWeek).toBeNull();
    expect(pregnancyCalendar("2026-10-01", "2026-11-24")!.currentWeek).toBeNull();
  });

  it("refuses an invalid date", () => {
    expect(pregnancyCalendar("2026-02-30", "2026-01-01")).toBeNull();
  });
});
