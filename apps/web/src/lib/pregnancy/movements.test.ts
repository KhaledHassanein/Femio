import { describe, expect, it } from "vitest";
import {
  comparePattern,
  minutesPerMovement,
  sessionDurationMs,
  MIN_SESSIONS_FOR_PATTERN,
  SLOWER_RATIO,
  type MovementSession,
} from "./movements";

const at = (minutes: number) => new Date(Date.UTC(2026, 0, 1, 0, minutes)).toISOString();

/** A session that took `minutes` and recorded `count` movements. */
const session = (minutes: number, count: number | null, offset = 0): MovementSession => ({
  startedAt: at(offset),
  endedAt: at(offset + minutes),
  movementCount: count,
});

describe("sessionDurationMs", () => {
  it("returns null while a session is still running", () => {
    expect(sessionDurationMs({ startedAt: at(0), endedAt: null, movementCount: 3 })).toBeNull();
  });

  it("rejects an end before the start rather than returning a negative duration", () => {
    expect(
      sessionDurationMs({ startedAt: at(30), endedAt: at(10), movementCount: 3 }),
    ).toBeNull();
  });
});

describe("minutesPerMovement", () => {
  it("is the session length divided by the count", () => {
    expect(minutesPerMovement(session(30, 10))).toBe(3);
  });

  it("is null when nothing was felt — zero movements must never read as a fast session", () => {
    // The dangerous bug this guards: 0 movements dividing into a short duration and
    // producing a small, reassuring-looking number.
    expect(minutesPerMovement(session(30, 0))).toBeNull();
    expect(minutesPerMovement(session(30, null))).toBeNull();
  });

  it("is null for an unfinished session", () => {
    expect(
      minutesPerMovement({ startedAt: at(0), endedAt: null, movementCount: 5 }),
    ).toBeNull();
  });
});

describe("comparePattern", () => {
  it(`needs ${MIN_SESSIONS_FOR_PATTERN} comparable sessions before it says anything`, () => {
    const result = comparePattern([session(30, 10), session(30, 10)]);
    expect(result.status).toBe("insufficient");
  });

  it("does not count unfinished or empty sessions toward the minimum", () => {
    const result = comparePattern([
      session(30, 10),
      session(30, 0),
      { startedAt: at(0), endedAt: null, movementCount: 4 },
    ]);
    expect(result).toEqual({ status: "insufficient", sessions: 1 });
  });

  it("reports a steady pattern as not slower", () => {
    const result = comparePattern([session(30, 10), session(31, 10), session(29, 10)]);
    expect(result.status).toBe("comparable");
    if (result.status !== "comparable") throw new Error("unreachable");
    expect(result.slower).toBe(false);
    expect(result.ratio).toBeCloseTo(30 / 30, 1);
  });

  it("flags the latest session when gaps are markedly longer than her own median", () => {
    // Typical 3 min/movement; latest 6 min/movement = 2x.
    const result = comparePattern([session(60, 10), session(30, 10), session(30, 10), session(30, 10)]);
    expect(result.status).toBe("comparable");
    if (result.status !== "comparable") throw new Error("unreachable");
    expect(result.ratio).toBeCloseTo(2, 5);
    expect(result.slower).toBe(true);
  });

  it("uses the median so one outlier cannot mask a later slowdown", () => {
    // A single very long session in her history. With a mean, typical would be
    // dragged up and the genuinely slow latest session would look normal.
    const history = [session(30, 10), session(30, 10), session(240, 10), session(30, 10)];
    const latestSlow = session(60, 10);
    const result = comparePattern([latestSlow, ...history]);
    expect(result.status).toBe("comparable");
    if (result.status !== "comparable") throw new Error("unreachable");
    expect(result.typicalMinutesPerMovement).toBe(3); // median, not the 7.75 mean
    expect(result.slower).toBe(true);
  });

  it(`treats exactly ${SLOWER_RATIO}x as slower — the boundary errs toward prompting`, () => {
    // typical 2 min/movement, latest 3 min/movement = exactly 1.5x
    const result = comparePattern([session(30, 10), session(20, 10), session(20, 10), session(20, 10)]);
    expect(result.status).toBe("comparable");
    if (result.status !== "comparable") throw new Error("unreachable");
    expect(result.ratio).toBeCloseTo(SLOWER_RATIO, 5);
    expect(result.slower).toBe(true);
  });

  it("never exposes a verdict field — the module must not be able to say 'normal'", () => {
    const result = comparePattern([session(30, 10), session(30, 10), session(30, 10)]);
    const keys = Object.keys(result);
    for (const forbidden of ["normal", "passed", "ok", "reassuring", "target", "result"]) {
      expect(keys).not.toContain(forbidden);
    }
  });
});
