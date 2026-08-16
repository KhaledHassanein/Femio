import { describe, expect, it } from "vitest";
import * as mood from "./mood";
import {
  GAD7_ITEMS,
  MOOD_ITEMS,
  moodResultRow,
  PHQ9_ITEMS,
  PHQ9_SELF_HARM_ITEM,
  scoreMood,
  type MoodAnswers,
  type MoodTool,
} from "./mood";

const all = (tool: MoodTool, value: number): MoodAnswers =>
  Object.fromEntries(MOOD_ITEMS[tool].map((item) => [item, value])) as MoodAnswers;

describe("the published structures", () => {
  it("has nine PHQ-9 items and seven GAD-7 items, none shared", () => {
    expect(PHQ9_ITEMS).toHaveLength(9);
    expect(GAD7_ITEMS).toHaveLength(7);
    const overlap = PHQ9_ITEMS.filter((i) => (GAD7_ITEMS as readonly string[]).includes(i));
    expect(overlap).toEqual([]);
  });

  it("reaches the published maxima", () => {
    expect(scoreMood("PHQ9", all("PHQ9", 3)).total).toBe(27);
    expect(scoreMood("GAD7", all("GAD7", 3)).total).toBe(21);
  });
});

describe("scoreMood", () => {
  it("counts answers rather than scoring a blank as none", () => {
    const score = scoreMood("GAD7", { feelingNervous: 2, restless: 1 });
    expect(score.total).toBe(3);
    expect(score.answered).toBe(2);
    expect(score.complete).toBe(false);
  });

  it("ignores a value outside the scale", () => {
    expect(scoreMood("GAD7", { feelingNervous: 9, restless: 2 }).total).toBe(2);
  });

  it("scores only its own instrument's items", () => {
    // A PHQ-9 answer left in state must not leak into a GAD-7 total.
    const score = scoreMood("GAD7", { ...all("GAD7", 1), feelingDown: 3 });
    expect(score.total).toBe(7);
    expect(score.answered).toBe(7);
  });
});

/**
 * PHQ-9 item 9 behaves like EPDS item 10: a separate flag no total can mask, acted
 * on by opening a door rather than by rendering a conclusion. A woman can answer it
 * above zero while scoring below every published band.
 */
describe("PHQ-9 item 9", () => {
  it("flags any answer above not-at-all, at the lowest possible total", () => {
    const score = scoreMood("PHQ9", { ...all("PHQ9", 0), [PHQ9_SELF_HARM_ITEM]: 1 });
    expect(score.total).toBe(1);
    expect(score.selfHarmItemPositive).toBe(true);
  });

  it("does not flag it when she answered not-at-all, or skipped it", () => {
    expect(scoreMood("PHQ9", all("PHQ9", 0)).selfHarmItemPositive).toBe(false);
    const skipped = { ...all("PHQ9", 3) };
    delete skipped[PHQ9_SELF_HARM_ITEM];
    // Silence is not an affirmative answer, and routing from it would teach her
    // that answering honestly is what triggers the alarm.
    expect(scoreMood("PHQ9", skipped).selfHarmItemPositive).toBe(false);
  });

  /**
   * GAD-7 has no such item. Kept in the type rather than left for a screen to know,
   * so a future screener screen cannot invent one by reusing the wrong constant.
   */
  it("is always false for GAD-7, at any total", () => {
    expect(scoreMood("GAD7", all("GAD7", 3)).selfHarmItemPositive).toBe(false);
  });
});

describe("what it must never produce", () => {
  it("exports no threshold, band or severity label", () => {
    for (const forbidden of [
      "PHQ9_BANDS",
      "GAD7_BANDS",
      "severityOf",
      "bandOf",
      "interpret",
      "isModerate",
      "isSevere",
    ]) {
      expect(Object.hasOwn(mood, forbidden)).toBe(false);
    }
  });

  it("gives the score no field to hold a verdict in", () => {
    const score = scoreMood("PHQ9", all("PHQ9", 3));
    for (const forbidden of ["severity", "band", "label", "risk", "interpretation"]) {
      expect(Object.hasOwn(score, forbidden)).toBe(false);
    }
  });
});

describe("moodResultRow", () => {
  it("tags the row with the instrument it came from", () => {
    expect(moodResultRow("p", scoreMood("PHQ9", all("PHQ9", 1))).tool).toBe("PHQ9");
    expect(moodResultRow("p", scoreMood("GAD7", all("GAD7", 1))).tool).toBe("GAD7");
  });

  it("never sets non_diagnostic", () => {
    const row = moodResultRow("p", scoreMood("GAD7", all("GAD7", 0)));
    expect(Object.hasOwn(row, "non_diagnostic")).toBe(false);
  });
});
