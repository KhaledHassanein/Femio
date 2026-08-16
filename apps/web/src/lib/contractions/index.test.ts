import { describe, expect, it } from "vitest";
import * as contractions from "./index";
import {
  formatDuration,
  inProgress,
  summarize,
  timeContractions,
  type Contraction,
} from "./index";

const at = (minute: number, second = 0) =>
  `2026-08-16T10:${String(minute).padStart(2, "0")}:${String(second).padStart(2, "0")}Z`;

const c = (id: string, startMin: number, endMin: number | null, endSec = 0): Contraction => ({
  id,
  startedAt: at(startMin),
  endedAt: endMin === null ? null : at(endMin, endSec),
});

/**
 * The property this module exists to hold.
 *
 * The 5-1-1 pattern is guidance a clinician gives about *when to call*. An app that
 * returned "this is active labour" would be making a clinical assessment from a
 * stopwatch — and it is the assessment with the worst failure mode in the product,
 * because a woman told "not yet" by her phone may wait.
 */
describe("it times contractions and does not read them", () => {
  it("exports no verdict, stage or labour test", () => {
    for (const forbidden of [
      "isLabour",
      "isActiveLabour",
      "stageOf",
      "phaseOf",
      "shouldGoToHospital",
      "meets511",
      "isRegular",
    ]) {
      expect(Object.hasOwn(contractions, forbidden)).toBe(false);
    }
  });

  it("gives the summary no field to hold a direction or a judgement in", () => {
    const summary = summarize(timeContractions([c("a", 0, 1), c("b", 5, 6)]));
    for (const forbidden of ["trend", "gettingCloser", "regular", "stage", "verdict", "advice"]) {
      expect(Object.hasOwn(summary, forbidden)).toBe(false);
    }
  });
});

describe("timeContractions", () => {
  it("measures duration and the gap since the previous start", () => {
    const timed = timeContractions([c("a", 0, 1), c("b", 5, 6)]);
    expect(timed.map((t) => t.durationSeconds)).toEqual([60, 60]);
    // Interval is start-to-start, which is the number she will be asked for.
    expect(timed.map((t) => t.intervalSeconds)).toEqual([null, 300]);
  });

  /**
   * The first contraction has nothing to measure from. A zero would be a lie that
   * drags every average down, in a number she reads aloud to a midwife.
   */
  it("leaves the first interval null rather than calling it zero", () => {
    expect(timeContractions([c("a", 0, 1)])[0]!.intervalSeconds).toBeNull();
  });

  it("sorts before measuring — an out-of-order row would produce a wrong number", () => {
    const timed = timeContractions([c("b", 5, 6), c("a", 0, 1)]);
    expect(timed.map((t) => t.id)).toEqual(["a", "b"]);
    expect(timed[1]!.intervalSeconds).toBe(300);
  });

  it("keeps a contraction that is still running", () => {
    const timed = timeContractions([c("a", 0, 1), c("b", 5, null)]);
    expect(timed[1]!.durationSeconds).toBeNull();
    expect(inProgress(timed)?.id).toBe("b");
  });

  it("keeps one she never stopped, rather than dropping the row", () => {
    // She put the phone down. The row is still true and still hers.
    const timed = timeContractions([c("a", 0, null), c("b", 5, 6)]);
    expect(timed).toHaveLength(2);
    expect(timed[0]!.durationSeconds).toBeNull();
    // And it is not "in progress" once a later one exists — only the last can be.
    expect(inProgress(timed)?.id).toBeUndefined();
  });
});

describe("summarize", () => {
  it("averages over the recent few, not the whole night", () => {
    // Twenty minutes apart four hours ago must not flatten the number she is being
    // asked about now.
    const early = [c("e1", 0, 1), c("e2", 20, 21), c("e3", 40, 41)];
    const recent = [c("r1", 45, 46), c("r2", 50, 51), c("r3", 55, 56)];
    const summary = summarize(timeContractions([...early, ...recent]), 3);
    expect(summary.counted).toBe(3);
    expect(summary.averageIntervalSeconds).toBe(300);
  });

  it("ignores the ones still running instead of counting them as short", () => {
    const summary = summarize(timeContractions([c("a", 0, 1), c("b", 5, null)]));
    expect(summary.averageDurationSeconds).toBe(60);
  });

  it("says nothing when there is nothing to say", () => {
    const summary = summarize([]);
    expect(summary).toEqual({
      counted: 0,
      averageDurationSeconds: null,
      averageIntervalSeconds: null,
    });
  });
});

describe("formatDuration", () => {
  it("reads like a stopwatch", () => {
    expect(formatDuration(0)).toBe("0:00");
    expect(formatDuration(9)).toBe("0:09");
    expect(formatDuration(75)).toBe("1:15");
    expect(formatDuration(600)).toBe("10:00");
  });
});
