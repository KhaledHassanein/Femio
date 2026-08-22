import { describe, expect, it } from "vitest";
import { lastCompletedCycle } from "./cycle-report";

const none = { symptoms: [] as { type: string; date: string }[] };

describe("lastCompletedCycle", () => {
  it("says nothing until a cycle has actually completed", () => {
    // A cycle's length is only knowable once the next period starts. Reporting on
    // the running one would mean guessing, which is the prediction's job.
    expect(lastCompletedCycle({ periodDates: ["2026-08-05"], ...none })).toBeNull();
    expect(lastCompletedCycle({ periodDates: [], ...none })).toBeNull();
  });

  it("measures the completed cycle from both logged ends", () => {
    const r = lastCompletedCycle({ periodDates: ["2026-07-08", "2026-08-05"], ...none })!;
    expect(r.start).toBe("2026-07-08");
    expect(r.end).toBe("2026-08-05");
    expect(r.length).toBe(28);
  });

  it("compares to her own earlier cycles, never to a textbook 28", () => {
    // Two 28s, then a 31: three days longer than *her* usual.
    const r = lastCompletedCycle({
      periodDates: ["2026-05-13", "2026-06-10", "2026-07-08", "2026-08-08"],
      ...none,
    })!;
    expect(r.length).toBe(31);
    expect(r.deltaFromUsual).toBe(3);
  });

  it("excludes the reported cycle from the usual it is compared against", () => {
    // Including it would blunt the very difference the card exists to show.
    const r = lastCompletedCycle({
      periodDates: ["2026-06-10", "2026-07-08", "2026-08-08"],
      ...none,
    })!;
    expect(r.deltaFromUsual).toBe(3); // 31 against the single earlier 28
  });

  it("offers no comparison for her first completed cycle", () => {
    const r = lastCompletedCycle({ periodDates: ["2026-07-08", "2026-08-05"], ...none })!;
    expect(r.deltaFromUsual).toBeNull();
  });

  it("counts her bleed days from raw entries, not from collapsed starts", () => {
    // The collapse finds cycle boundaries; using it here would report every period
    // as one day long (R3.1.9).
    const r = lastCompletedCycle({
      periodDates: ["2026-07-08", "2026-07-09", "2026-07-10", "2026-08-05"],
      ...none,
    })!;
    expect(r.length).toBe(28);
    expect(r.bleedDays).toBe(3);
  });

  it("counts only symptoms inside the cycle it reports", () => {
    const r = lastCompletedCycle({
      periodDates: ["2026-07-08", "2026-08-05"],
      symptoms: [
        { type: "cramps", date: "2026-07-09" },
        { type: "cramps", date: "2026-07-10" },
        { type: "headache", date: "2026-07-20" },
        { type: "cramps", date: "2026-08-06" }, // after it ended
        { type: "cramps", date: "2026-07-01" }, // before it began
      ],
    })!;
    expect(r.symptoms).toEqual([
      { type: "cramps", count: 2 },
      { type: "headache", count: 1 },
    ]);
  });

  it("ignores malformed dates rather than throwing", () => {
    const r = lastCompletedCycle({
      periodDates: ["2026-07-08", "nope", "2026-08-05"],
      symptoms: [{ type: "cramps", date: "bad" }],
    })!;
    expect(r.length).toBe(28);
    expect(r.symptoms).toEqual([]);
  });
});
