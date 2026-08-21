import { describe, expect, it } from "vitest";
import { cycleSegments, phaseOnDay } from "./phases";

describe("phaseOnDay", () => {
  const base = { cycleLength: 28, periodLength: 5 };

  it("counts bleeding days as menstrual, from day 1", () => {
    expect(phaseOnDay({ ...base, cycleDay: 1 })).toBe("menstrual");
    expect(phaseOnDay({ ...base, cycleDay: 5 })).toBe("menstrual");
    expect(phaseOnDay({ ...base, cycleDay: 6 })).toBe("follicular");
  });

  it("estimates ovulation backwards from the next period, not as day 14", () => {
    // The whole point: a 32-day cycle ovulates around day 18, not day 14. Assuming
    // day 14 is the most common error in this category and would put the fertile
    // window four days early for her.
    expect(phaseOnDay({ cycleLength: 32, periodLength: 5, cycleDay: 18 })).toBe("ovulatory");
    expect(phaseOnDay({ cycleLength: 32, periodLength: 5, cycleDay: 14 })).toBe("follicular");

    // And a short cycle ovulates earlier, for the same reason.
    expect(phaseOnDay({ cycleLength: 24, periodLength: 4, cycleDay: 10 })).toBe("ovulatory");
  });

  it("gives ovulation a window rather than a single day", () => {
    for (const day of [12, 13, 14, 15, 16]) {
      expect(phaseOnDay({ ...base, cycleDay: day })).toBe("ovulatory");
    }
    expect(phaseOnDay({ ...base, cycleDay: 11 })).toBe("follicular");
    expect(phaseOnDay({ ...base, cycleDay: 17 })).toBe("luteal");
  });

  it("returns null for irregular cycles instead of guessing", () => {
    // Product rule 3. A confident wrong phase is worse than no phase, and this is
    // the case both incumbents handle badly (docs/26 §7).
    expect(phaseOnDay({ ...base, cycleDay: 14, irregular: true })).toBeNull();
  });

  it("returns null when the cycle is too short for the estimate to mean anything", () => {
    // cycleLength - 14 would land on or before the bleeding days.
    expect(phaseOnDay({ cycleLength: 18, periodLength: 5, cycleDay: 6 })).toBeNull();
  });

  it("stays luteal past the expected length rather than going blank", () => {
    // Her period is late, which is ordinary. Never a 'late' counter (product rule 3),
    // but the phase is still knowable and saying so beats saying nothing.
    expect(phaseOnDay({ ...base, cycleDay: 31 })).toBe("luteal");
  });

  it("rejects nonsense input rather than coercing it", () => {
    expect(phaseOnDay({ ...base, cycleDay: 0 })).toBeNull();
    expect(phaseOnDay({ ...base, cycleDay: Number.NaN })).toBeNull();
    expect(phaseOnDay({ cycleLength: Number.NaN, cycleDay: 3 })).toBeNull();
  });

  it("handles a period longer than the follicular estimate without overlapping", () => {
    const phase = phaseOnDay({ cycleLength: 22, periodLength: 8, cycleDay: 8 });
    expect(phase).toBe("menstrual");
  });
});

describe("cycleSegments", () => {
  it("covers every day exactly once, in order, with no gaps", () => {
    const segments = cycleSegments({ cycleLength: 28, periodLength: 5 });
    expect(segments.length).toBeGreaterThan(0);
    expect(segments.at(0)?.startDay).toBe(1);
    expect(segments.at(-1)?.endDay).toBe(28);
    for (let i = 1; i < segments.length; i += 1) {
      expect(segments[i]?.startDay).toBe((segments[i - 1]?.endDay ?? 0) + 1);
    }
  });

  it("agrees with phaseOnDay for every day — the strip cannot contradict the label", () => {
    const input = { cycleLength: 31, periodLength: 6 };
    for (const seg of cycleSegments(input)) {
      for (let day = seg.startDay; day <= seg.endDay; day += 1) {
        expect(phaseOnDay({ ...input, cycleDay: day })).toBe(seg.phase);
      }
    }
  });

  it("returns nothing for an irregular cycle, so the ring renders as unknown", () => {
    expect(cycleSegments({ cycleLength: 28, irregular: true })).toEqual([]);
    expect(cycleSegments({ cycleLength: 15 })).toEqual([]);
  });
});
