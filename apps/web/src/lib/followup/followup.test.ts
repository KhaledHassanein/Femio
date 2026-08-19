import { describe, expect, it } from "vitest";
import { followUpKindsFor, followUpsFor } from "./index";

const BIRTH = "2026-06-01";

const at = (todayISO: string, conditions: string[] = ["gestational_diabetes"]) =>
  followUpsFor({ conditions, birthDateISO: BIRTH, todayISO });

describe("which follow-ups a reported condition calls for", () => {
  it("asks for a glucose test after either kind of diabetes", () => {
    expect(followUpKindsFor(["gestational_diabetes"])).toEqual(["glucose"]);
    expect(followUpKindsFor(["diabetes"])).toEqual(["glucose"]);
  });

  it("asks for a blood-pressure review after a hypertensive pregnancy", () => {
    expect(followUpKindsFor(["pre_eclampsia"])).toEqual(["bloodPressure"]);
    expect(followUpKindsFor(["hypertension"])).toEqual(["bloodPressure"]);
  });

  it("asks for both when both were reported, and never duplicates", () => {
    expect(followUpKindsFor(["gestational_diabetes", "diabetes", "pre_eclampsia"])).toEqual([
      "glucose",
      "bloodPressure",
    ]);
  });

  /**
   * Thyroid routes to E7's own watch rather than onto this schedule (the resolver
   * splits them for the same reason), and a condition with no postpartum follow-up
   * must not manufacture one.
   */
  it("stays silent for conditions that carry no follow-up here", () => {
    expect(followUpKindsFor(["thyroid", "anemia", "depression_anxiety"])).toEqual([]);
  });
});

describe("where today sits against the window", () => {
  it("is upcoming before the window opens", () => {
    expect(at("2026-06-14")[0]?.status).toBe("upcoming"); // day 13, glucose opens day 28
  });

  it("is open inside it", () => {
    expect(at("2026-07-06")[0]?.status).toBe("open"); // day 35
  });

  it("is open on both edges, because a window that excludes its own last day is a trap", () => {
    expect(at("2026-06-29")[0]?.status).toBe("open"); // day 28 exactly
    expect(at("2026-08-24")[0]?.status).toBe("open"); // day 84 exactly
  });

  it("is overdue after it closes", () => {
    expect(at("2026-08-25")[0]?.status).toBe("overdue"); // day 85
  });

  /**
   * `overdue` is arithmetic on a window guidance describes, not a statement about
   * her — E4 §A says the usual reason a check is missed is that nobody offered it.
   * The type carries no `missed`, no `failed` and no score, and a test asserts the
   * shape so a later edit cannot add one quietly.
   */
  it("never grades her", () => {
    const json = JSON.stringify(at("2026-12-01"));
    for (const forbidden of ["missed", "failed", "score", "adherence", "compliant"]) {
      expect(json).not.toContain(forbidden);
    }
  });

  /** No result, no reading, no verdict — the fourth time this call has been made. */
  it("records nothing about what a test found", () => {
    const entry = at("2026-07-06")[0]!;
    expect(Object.keys(entry).sort()).toEqual(["fromDay", "kind", "status", "toDay"]);
  });
});

describe("what it refuses to say", () => {
  it("says nothing without a birth date to anchor it", () => {
    expect(
      followUpsFor({
        conditions: ["gestational_diabetes"],
        birthDateISO: null,
        todayISO: "2026-07-06",
      }),
    ).toEqual([]);
  });

  /** A birth date in the future is a typo, not a pregnancy to count down to. */
  it("says nothing when the birth date is ahead of today", () => {
    expect(
      followUpsFor({
        conditions: ["gestational_diabetes"],
        birthDateISO: "2026-09-01",
        todayISO: "2026-07-06",
      }),
    ).toEqual([]);
  });

  it("says nothing when she reported nothing", () => {
    expect(at("2026-07-06", [])).toEqual([]);
  });

  /**
   * The blood-pressure window runs from the day of birth, so a woman reading this
   * three days after and one reading it on day nine both see the same thing: not
   * finished. Its outer bound is what she is told to chase against.
   */
  it("opens the blood-pressure review immediately", () => {
    const [bp] = at("2026-06-01", ["pre_eclampsia"]);
    expect(bp?.status).toBe("open");
    expect(bp?.toDay).toBe(10);
  });
});
