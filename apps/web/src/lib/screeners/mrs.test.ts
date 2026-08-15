import { describe, expect, it } from "vitest";
import * as mrs from "./mrs";
import { MRS_ITEMS, MRS_SUBSCALES, mrsResultRow, scoreMrs, type MrsAnswers } from "./mrs";

const all = (value: number): MrsAnswers =>
  Object.fromEntries(MRS_ITEMS.map((item) => [item, value])) as MrsAnswers;

describe("the MRS structure", () => {
  it("has the published 11 items across three subscales, each used once", () => {
    const inSubscales = Object.values(MRS_SUBSCALES).flat();
    expect(inSubscales).toHaveLength(MRS_ITEMS.length);
    expect(new Set(inSubscales).size).toBe(MRS_ITEMS.length);
    for (const item of MRS_ITEMS) expect(inSubscales).toContain(item);
  });
});

describe("scoreMrs", () => {
  it("sums the scale and its subscales", () => {
    const score = scoreMrs(all(2));
    expect(score.total).toBe(22);
    expect(score.subscales).toEqual({ somatic: 8, psychological: 8, urogenital: 6 });
    expect(score.complete).toBe(true);
  });

  it("reaches the published maximum and no further", () => {
    expect(scoreMrs(all(4)).total).toBe(44);
    expect(scoreMrs(all(0)).total).toBe(0);
  });

  /**
   * The one that matters most. A total from six items is not comparable to a total
   * from eleven, and treating a blank as a zero would quietly describe a woman as
   * having fewer symptoms than she reported — in a number she may carry into an
   * appointment.
   */
  it("counts answers rather than scoring a blank as none", () => {
    const partial: MrsAnswers = { hotFlushes: 3, anxiety: 4 };
    const score = scoreMrs(partial);
    expect(score.total).toBe(7);
    expect(score.answered).toBe(2);
    expect(score.complete).toBe(false);
  });

  it("ignores a value outside the scale instead of trusting it", () => {
    const score = scoreMrs({ hotFlushes: 9, anxiety: -1, irritability: 2.5, sleepProblems: 3 });
    expect(score.total).toBe(3);
    expect(score.answered).toBe(1);
  });
});

/**
 * The property this module exists to hold. The literature attaches cut-offs to
 * these totals; Femio reports the number and refuses to grade it. "Your total is
 * 19" is arithmetic on her own answers. "Your symptoms are severe" is a clinical
 * assessment — the thing that makes an app a medical device, and the thing she
 * would reasonably act on without ever speaking to anyone.
 */
describe("what it must never produce", () => {
  it("exports no banding, threshold or severity", () => {
    for (const forbidden of [
      "MRS_THRESHOLDS",
      "severityOf",
      "bandOf",
      "interpret",
      "isSevere",
      "MRS_CUTOFF",
    ]) {
      expect(Object.hasOwn(mrs, forbidden)).toBe(false);
    }
  });

  it("gives the score object no field to hold a verdict in", () => {
    const score = scoreMrs(all(4));
    for (const forbidden of ["severity", "band", "label", "interpretation", "risk"]) {
      expect(Object.hasOwn(score, forbidden)).toBe(false);
    }
  });
});

describe("mrsResultRow", () => {
  it("writes the number and the subscores, tagged as MRS", () => {
    const row = mrsResultRow("profile-1", scoreMrs(all(1)));
    expect(row.tool).toBe("MRS");
    expect(row.score).toBe(11);
    expect(row.subscores_json).toEqual({
      somatic: 4,
      psychological: 4,
      urogenital: 3,
      answered: 11,
    });
  });

  /**
   * `non_diagnostic` defaults to true in the schema and nothing in Femio has ever
   * set it false. Not passing it means a screener row cannot become diagnostic by
   * someone forgetting a field.
   */
  it("never sets non_diagnostic", () => {
    expect(Object.hasOwn(mrsResultRow("p", scoreMrs(all(0))), "non_diagnostic")).toBe(false);
  });
});
