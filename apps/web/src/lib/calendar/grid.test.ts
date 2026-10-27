import { describe, expect, it } from "vitest";
import {
  bandSegment,
  daysInMonth,
  hijriDay,
  hijriMonthLine,
  localTodayISO,
  monthGrid,
  monthsSpanning,
  shiftMonth,
  weekStartFor,
  weekdayHeaderDates,
} from "./grid";

describe("weekStartFor", () => {
  it("is Saturday for Arabic, Monday for the others, matched on the language part", () => {
    expect(weekStartFor("ar")).toBe(6);
    expect(weekStartFor("ar-u-nu-latn")).toBe(6);
    expect(weekStartFor("ar-EG")).toBe(6);
    expect(weekStartFor("en")).toBe(1);
    expect(weekStartFor("fr")).toBe(1);
    expect(weekStartFor("es")).toBe(1);
    expect(weekStartFor("de")).toBe(1);
  });
});

describe("localTodayISO", () => {
  it("uses the device's local calendar date, not UTC", () => {
    // 23:30 local on the 26th. In UTC+3 that is 20:30 UTC the same day; the point is
    // that the LOCAL getters are read, which is what the Date below exercises.
    const local = new Date(2026, 9, 26, 23, 30);
    expect(localTodayISO(local)).toBe("2026-10-26");
  });
});

describe("monthGrid", () => {
  it("pads the first row to the week start and the last row to seven", () => {
    // October 2026 starts on a Thursday.
    const monday = monthGrid("2026-10-01", 1);
    expect(monday.weeks[0]).toEqual([null, null, null, "2026-10-01", "2026-10-02", "2026-10-03", "2026-10-04"]);
    expect(monday.weeks.at(-1)).toEqual(["2026-10-26", "2026-10-27", "2026-10-28", "2026-10-29", "2026-10-30", "2026-10-31", null]);
    for (const week of monday.weeks) expect(week).toHaveLength(7);

    const saturday = monthGrid("2026-10-01", 6);
    expect(saturday.weeks[0]).toEqual([null, null, null, null, null, "2026-10-01", "2026-10-02"]);
  });

  it("covers every day of the month exactly once", () => {
    const grid = monthGrid("2026-02-15", 1);
    const days = grid.weeks.flat().filter(Boolean);
    expect(days).toHaveLength(28);
    expect(days[0]).toBe("2026-02-01");
    expect(days.at(-1)).toBe("2026-02-28");
  });
});

describe("months", () => {
  it("shifts and measures months across a year boundary", () => {
    expect(shiftMonth("2026-12-20", 1)).toBe("2027-01-01");
    expect(shiftMonth("2026-01-05", -1)).toBe("2025-12-01");
    expect(daysInMonth("2028-02-10")).toBe(29);
  });

  it("lists the months a range touches, capped", () => {
    expect(monthsSpanning("2026-10-20", "2026-12-02", 3)).toEqual(["2026-10-01", "2026-11-01", "2026-12-01"]);
    expect(monthsSpanning("2026-10-20", "2027-03-02", 3)).toHaveLength(3);
    expect(monthsSpanning("2026-10-20", "2026-10-25", 3)).toEqual(["2026-10-01"]);
  });

  it("builds a weekday header in visual order", () => {
    expect(weekdayHeaderDates(6)[0]).toBe("2026-01-10"); // a Saturday
    expect(weekdayHeaderDates(1)[0]).toBe("2026-01-05"); // a Monday
  });
});

describe("bandSegment", () => {
  const week = ["2026-10-19", "2026-10-20", "2026-10-21", "2026-10-22", "2026-10-23", "2026-10-24", "2026-10-25"];

  it("returns the columns a band covers in a row, with its real edges flagged", () => {
    const seg = bandSegment({ id: "f", kind: "fertile", start: "2026-10-21", end: "2026-10-26" }, week);
    expect(seg).toEqual({ colStart: 3, colEnd: 7, isStart: true, isEnd: false });
  });

  it("is null when the band misses the row", () => {
    expect(bandSegment({ id: "p", kind: "period", start: "2026-11-01", end: "2026-11-05" }, week)).toBeNull();
  });

  it("never spills into padding cells", () => {
    const padded = [null, null, "2026-11-01", "2026-11-02", "2026-11-03", "2026-11-04", "2026-11-05"];
    const seg = bandSegment({ id: "p", kind: "period", start: "2026-10-30", end: "2026-11-02" }, padded);
    expect(seg).toEqual({ colStart: 3, colEnd: 4, isStart: false, isEnd: true });
  });
});

describe("hijri", () => {
  it("labels a day in Western digits on the Umm al-Qura calendar", () => {
    const day = hijriDay("2026-10-27");
    expect(day).toMatch(/^\d{1,2}$/);
    expect(hijriDay("not-a-date")).toBe("");
  });

  it("names the month span with the year", () => {
    const line = hijriMonthLine("2026-10-01", "2026-10-31");
    expect(line).toContain("1448");
    expect(line).not.toMatch(/[٠-٩]/);
  });
});
