import { describe, expect, it } from "vitest";
import * as epds from "./epds";
import {
  EPDS_ITEMS,
  EPDS_SELF_HARM_ITEM,
  epdsResultRow,
  optionForValue,
  scoreEpds,
  valueForOption,
  type EpdsAnswers,
} from "./epds";

const all = (value: number): EpdsAnswers =>
  Object.fromEntries(EPDS_ITEMS.map((item) => [item, value])) as EpdsAnswers;

describe("the EPDS structure", () => {
  it("has the published ten items", () => {
    expect(EPDS_ITEMS).toHaveLength(10);
    expect(new Set(EPDS_ITEMS).size).toBe(10);
    expect(EPDS_ITEMS).toContain(EPDS_SELF_HARM_ITEM);
  });

  /**
   * Getting this backwards understates a woman's score on exactly the items a
   * depressed person answers lowest — the two about humour and looking forward.
   * Options are always shown least-symptomatic first; the flip happens here so no
   * client can do it differently.
   */
  it("reverse-scores the two positively-worded items", () => {
    expect(valueForOption("ableToLaugh", 0)).toBe(3);
    expect(valueForOption("ableToLaugh", 3)).toBe(0);
    expect(valueForOption("lookedForward", 1)).toBe(2);
    // Everything else is straight.
    expect(valueForOption("sadOrMiserable", 0)).toBe(0);
    expect(valueForOption("sadOrMiserable", 3)).toBe(3);
  });

  it("round-trips option to value and back, on both kinds of item", () => {
    // A screen that derives the selected chip with its own arithmetic gets the
    // reverse-scored items wrong, and the wrong chip looks selected on exactly
    // the two questions a depressed woman answers lowest.
    for (const item of EPDS_ITEMS) {
      for (const index of [0, 1, 2, 3]) {
        expect(optionForValue(item, valueForOption(item, index))).toBe(index);
      }
    }
  });
});

describe("scoreEpds", () => {
  it("sums to the published range", () => {
    expect(scoreEpds(all(0)).total).toBe(0);
    expect(scoreEpds(all(3)).total).toBe(30);
  });

  it("counts answers rather than scoring a blank as none", () => {
    const score = scoreEpds({ sadOrMiserable: 2, anxiousOrWorried: 1 });
    expect(score.total).toBe(3);
    expect(score.answered).toBe(2);
    expect(score.complete).toBe(false);
  });

  it("ignores a value outside the scale", () => {
    expect(scoreEpds({ sadOrMiserable: 9, anxiousOrWorried: 2 }).total).toBe(2);
  });
});

/**
 * The reason this file exists, and the one behaviour in the codebase that must
 * survive every future refactor.
 *
 * Published guidance is unanimous that a positive item 10 is followed up
 * regardless of the total — and a woman can answer it above zero while scoring
 * below any cut-off anyone would call concerning. So the flag is separate, no total
 * can mask it, and P1.26.3 makes it open the crisis route before any number is
 * shown.
 */
describe("item 10 is not like the other nine", () => {
  it("flags any answer above never, even at the lowest possible total", () => {
    const score = scoreEpds({ ...all(0), [EPDS_SELF_HARM_ITEM]: 1 });
    expect(score.total).toBe(1);
    expect(score.selfHarmItemPositive).toBe(true);
  });

  it("does not flag it when she answered never", () => {
    expect(scoreEpds(all(0)).selfHarmItemPositive).toBe(false);
  });

  it("does not flag it when she skipped it, however high the rest", () => {
    // Unanswered is not a negative answer — but it is not an affirmative one
    // either, and inventing a crisis route from silence would teach her that
    // answering honestly is what triggers it.
    const answers = { ...all(3) };
    delete answers[EPDS_SELF_HARM_ITEM];
    const score = scoreEpds(answers);
    expect(score.total).toBe(27);
    expect(score.selfHarmItemPositive).toBe(false);
  });

  it("is a fact about her answer, never a severity", () => {
    const score = scoreEpds(all(3));
    for (const forbidden of ["risk", "riskLevel", "severity", "urgency", "band"]) {
      expect(Object.hasOwn(score, forbidden)).toBe(false);
    }
  });
});

/**
 * The same posture as the MRS: the literature attaches cut-offs — commonly 10, 11
 * or 13 depending on setting and translation, which is itself the argument — and
 * Femio applies none of them.
 */
describe("what it must never produce", () => {
  it("exports no threshold, band or label", () => {
    for (const forbidden of [
      "EPDS_THRESHOLD",
      "EPDS_CUTOFF",
      "severityOf",
      "bandOf",
      "isProbableDepression",
      "interpret",
    ]) {
      expect(Object.hasOwn(epds, forbidden)).toBe(false);
    }
  });
});

describe("epdsResultRow", () => {
  it("records the total, the count and the item-10 fact", () => {
    const row = epdsResultRow("p", scoreEpds({ ...all(0), [EPDS_SELF_HARM_ITEM]: 2 }));
    expect(row.tool).toBe("EPDS");
    expect(row.score).toBe(2);
    expect(row.subscores_json).toEqual({ answered: 10, selfHarmItemPositive: true });
  });

  it("never sets non_diagnostic", () => {
    expect(Object.hasOwn(epdsResultRow("p", scoreEpds(all(0))), "non_diagnostic")).toBe(false);
  });
});
