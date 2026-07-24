import { describe, expect, it } from "vitest";
import { buildMonthGrid, daysInMonth, weekStartForLocale } from "./calendar";

describe("buildMonthGrid", () => {
  it("produces whole weeks with a 7-day row and correct in-month flags", () => {
    // July 2026: 1 Jul is a Wednesday. Monday-start.
    const grid = buildMonthGrid(2026, 6, { today: "2026-07-24" });
    expect(grid.weeks.every((w) => w.length === 7)).toBe(true);
    const flat = grid.weeks.flat();
    expect(flat.filter((c) => c.inMonth).length).toBe(31);
    // First in-month cell is the 1st; leading cells belong to June.
    const firstInMonth = flat.find((c) => c.inMonth)!;
    expect(firstInMonth.iso).toBe("2026-07-01");
    expect(flat[0]!.inMonth).toBe(false);
  });

  it("marks today, periods (with flow), and the predicted window", () => {
    const grid = buildMonthGrid(2026, 6, {
      today: "2026-07-24",
      periods: new Map([
        ["2026-07-03", "heavy"],
        ["2026-07-04", null],
      ]),
      windowStart: "2026-07-28",
      windowEnd: "2026-07-31",
    });
    const flat = grid.weeks.flat();
    expect(flat.find((c) => c.iso === "2026-07-24")!.isToday).toBe(true);
    const heavy = flat.find((c) => c.iso === "2026-07-03")!;
    expect(heavy.isPeriod).toBe(true);
    expect(heavy.flow).toBe("heavy");
    const noFlow = flat.find((c) => c.iso === "2026-07-04")!;
    expect(noFlow.isPeriod).toBe(true);
    expect(noFlow.flow).toBe(null);
    expect(flat.find((c) => c.iso === "2026-07-28")!.isPredicted).toBe(true);
    expect(flat.find((c) => c.iso === "2026-07-31")!.isPredicted).toBe(true);
    expect(flat.find((c) => c.iso === "2026-07-27")!.isPredicted).toBe(false);
  });

  it("honours weekStartsOn (Saturday for Arabic)", () => {
    const mon = buildMonthGrid(2026, 6, { weekStartsOn: 1 });
    const sat = buildMonthGrid(2026, 6, { weekStartsOn: 6 });
    // Different lead padding → different first cell.
    expect(mon.weeks[0]![0]!.iso).not.toBe(sat.weeks[0]![0]!.iso);
    expect(weekStartForLocale("ar")).toBe(6);
    expect(weekStartForLocale("en")).toBe(1);
  });

  it("daysInMonth handles leap February", () => {
    expect(daysInMonth(2024, 1)).toBe(29);
    expect(daysInMonth(2026, 1)).toBe(28);
  });
});
