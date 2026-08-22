import { describe, expect, it } from "vitest";
import { addDays, diffDays } from "@/lib/calculators/dates";
import { daysUntilPredicted, predictNextPeriod } from "./predict";

// Six regular 28-day cycles → 7 start dates.
const regular = Array.from({ length: 7 }, (_, i) => addDays("2026-01-01", i * 28));

describe("predictNextPeriod", () => {
  it("predicts one average length past the last start", () => {
    const p = predictNextPeriod(regular)!;
    expect(p.averageLength).toBe(28);
    expect(diffDays(regular.at(-1)!, p.predictedStart)).toBe(28);
  });

  it("gives a tight window + high confidence for very regular cycles", () => {
    const p = predictNextPeriod(regular)!;
    expect(p.confidence).toBe("high");
    expect(p.irregular).toBe(false);
    expect(diffDays(p.windowStart, p.predictedStart)).toBe(2);
    expect(diffDays(p.predictedStart, p.windowEnd)).toBe(2);
  });

  it("flags irregular + widens the window when cycles vary a lot", () => {
    // starts spaced 25, 40, 30 days → spread 15
    const starts = ["2026-01-01", "2026-01-26", "2026-03-07", "2026-04-06"];
    const p = predictNextPeriod(starts)!;
    expect(p.irregular).toBe(true);
    expect(p.confidence).toBe("low");
    expect(diffDays(p.windowStart, p.windowEnd)).toBeGreaterThan(4);
  });

  it("works with a single cycle but low confidence", () => {
    const p = predictNextPeriod(["2026-01-01", "2026-01-29"])!;
    expect(p.confidence).toBe("low");
    expect(p.averageLength).toBe(28);
  });

  it("needs at least two starts", () => {
    expect(predictNextPeriod(["2026-01-01"])).toBeNull();
    expect(predictNextPeriod([])).toBeNull();
  });

  it("sorts, de-dupes, and ignores invalid dates", () => {
    const p = predictNextPeriod(["2026-01-29", "2026-01-01", "2026-01-01", "bad-date"])!;
    expect(p.averageLength).toBe(28);
  });
});

describe("daysUntilPredicted (no 'late' counter when irregular)", () => {
  it("counts down for regular cycles", () => {
    const p = predictNextPeriod(regular)!;
    const before = addDays(p.predictedStart, -3);
    expect(daysUntilPredicted(p, before)).toBe(3);
  });

  it("returns null in irregular mode", () => {
    const p = predictNextPeriod(["2026-01-01", "2026-01-26", "2026-03-07", "2026-04-06"])!;
    expect(p.irregular).toBe(true);
    expect(daysUntilPredicted(p, "2026-05-01")).toBeNull();
  });
});

describe("learning vs irregular (R3.1.7)", () => {
  it("does not call two logged periods irregular", () => {
    // One interval has no spread to measure, so "your cycles vary" would be a
    // claim about her body drawn from a single data point. This is the exact
    // state every new user is in immediately after onboarding.
    const p = predictNextPeriod(["2026-07-08", "2026-08-05"])!;
    expect(p.learning).toBe(true);
    expect(p.irregular).toBe(false);
  });

  it("stops learning once there are two intervals, and stays regular if they agree", () => {
    const p = predictNextPeriod(["2026-06-10", "2026-07-08", "2026-08-05"])!;
    expect(p.learning).toBe(false);
    expect(p.irregular).toBe(false);
  });

  it("calls genuinely variable cycles irregular, and is not still learning", () => {
    const p = predictNextPeriod(["2026-01-01", "2026-01-26", "2026-03-07", "2026-04-06"])!;
    expect(p.learning).toBe(false);
    expect(p.irregular).toBe(true);
  });

  it("shows no countdown while still learning", () => {
    // The safety behaviour both states share. Splitting the flag would have
    // re-enabled a "late" counter for the thinnest histories if this were missed.
    const p = predictNextPeriod(["2026-07-08", "2026-08-05"])!;
    expect(daysUntilPredicted(p, "2026-09-10")).toBeNull();
  });
});

describe("a stated baseline (R3.1b)", () => {
  it("says something useful from one logged period plus her stated length", () => {
    // Flo and Clue both do this; Femio said nothing until the second cycle, which
    // is most of why the first run felt empty.
    const p = predictNextPeriod(["2026-08-05"], 30)!;
    expect(p.averageLength).toBe(30);
    expect(p.basis).toBe("stated");
    expect(p.predictedStart).toBe("2026-09-04");
  });

  it("never mistakes a stated length for an observation", () => {
    const p = predictNextPeriod(["2026-08-05"], 30)!;
    expect(p.learning).toBe(true);
    expect(p.irregular).toBe(false);
    expect(p.confidence).toBe("low");
    // No countdown from a number she remembered rather than logged.
    expect(daysUntilPredicted(p, "2026-09-01")).toBeNull();
  });

  it("hands over to her own cycles as soon as there are two", () => {
    const p = predictNextPeriod(["2026-07-08", "2026-08-05"], 30)!;
    expect(p.basis).toBe("observed");
    expect(p.averageLength).toBe(28); // hers, not the 30 she guessed
  });

  it("refuses to invent a length when she skipped the question", () => {
    // "Not sure" must not silently become 28 — that is a number she never gave us,
    // shown back as though she had.
    expect(predictNextPeriod(["2026-08-05"])).toBeNull();
    expect(predictNextPeriod(["2026-08-05"], null)).toBeNull();
  });

  it("ignores a stated length outside what the schema accepts", () => {
    expect(predictNextPeriod(["2026-08-05"], 3)).toBeNull();
    expect(predictNextPeriod(["2026-08-05"], 90)).toBeNull();
  });

  it("gives a stated length a wider window than measured cycles get", () => {
    const stated = predictNextPeriod(["2026-08-05"], 28)!;
    const observed = predictNextPeriod(["2026-06-10", "2026-07-08", "2026-08-05"], 28)!;
    const width = (p: { windowStart: string; windowEnd: string }) =>
      new Date(p.windowEnd).getTime() - new Date(p.windowStart).getTime();
    expect(width(stated)).toBeGreaterThan(width(observed));
  });
});

describe("consecutive logged days are one period (R3.1.9)", () => {
  it("does not turn three days of bleeding into three cycles", () => {
    // The bug, exactly: this used to yield averageLength 1, irregular false, and a
    // predicted window already in the past.
    const p = predictNextPeriod(["2026-08-17", "2026-08-18", "2026-08-19"], null);
    expect(p).toBeNull(); // one bleed, no interval to measure
  });

  it("measures from the first day of each bleed, not the last", () => {
    const p = predictNextPeriod(
      ["2026-07-06", "2026-07-07", "2026-07-08", "2026-08-03", "2026-08-04"],
      null,
    )!;
    // 6 Jul -> 3 Aug is 28 days. Measuring from the last logged day of each run
    // would give 27, and from a mix would give nonsense.
    expect(p.averageLength).toBe(28);
    expect(p.basis).toBe("observed");
  });

  it("still separates genuinely distinct cycles", () => {
    const p = predictNextPeriod(["2026-06-10", "2026-07-08", "2026-08-05"], null)!;
    expect(p.averageLength).toBe(28);
  });

  it("keeps a short cycle separate rather than swallowing it", () => {
    // 21 days apart is a real cycle at the low end of the NHS range, not one long
    // bleed, and the collapse threshold must not eat it.
    const p = predictNextPeriod(["2026-08-01", "2026-08-22"], 28)!;
    expect(p.averageLength).toBe(21);
    expect(p.basis).toBe("observed");
  });

  it("falls back to her stated length when the logs are all one bleed", () => {
    const p = predictNextPeriod(["2026-08-17", "2026-08-18", "2026-08-19"], 30)!;
    expect(p.basis).toBe("stated");
    expect(p.averageLength).toBe(30);
    expect(p.predictedStart).toBe("2026-09-16"); // from 17 Aug, the first day
  });
});

describe("the average uses recent cycles only (R3.1.10)", () => {
  it("ignores cycles older than the window when averaging", () => {
    // Six 28s after three 40s: her average is 28, not the 32 an all-time mean gives.
    const starts = ["2026-01-01", "2026-02-10", "2026-03-22", "2026-05-01"];
    let d = new Date("2026-05-01T00:00:00Z");
    for (let i = 0; i < 6; i += 1) {
      d = new Date(d.getTime() + 28 * 86_400_000);
      starts.push(d.toISOString().slice(0, 10));
    }
    const p = predictNextPeriod(starts)!;
    expect(p.averageLength).toBe(28);
  });

  it("still uses everything she has when that is less than the window", () => {
    const p = predictNextPeriod(["2026-06-10", "2026-07-08", "2026-08-05"])!;
    expect(p.averageLength).toBe(28);
  });

  it("keeps irregular on her full history, not the window", () => {
    // The Track F case, and the reason the window is scoped to the average alone.
    // A menopausal woman who bleeds after eighteen months must not read as regular
    // just because the recent window makes her look steady (docs/26 §18).
    const p = predictNextPeriod(["2025-01-12", "2025-02-14", "2026-08-10"])!;
    expect(p.irregular).toBe(true);
  });

  it("keeps a long-ago swing visible in irregular even when recent cycles are steady", () => {
    const starts = ["2026-01-01", "2026-02-20"]; // a 50-day cycle, long ago
    let d = new Date("2026-02-20T00:00:00Z");
    for (let i = 0; i < 6; i += 1) {
      d = new Date(d.getTime() + 28 * 86_400_000);
      starts.push(d.toISOString().slice(0, 10));
    }
    const p = predictNextPeriod(starts)!;
    expect(p.averageLength).toBe(28); // the average has moved on
    expect(p.irregular).toBe(true); // the record has not been rewritten
  });
});

describe("implausible gaps leave the average but stay in the record (R3.1.10)", () => {
  const TRACK_F = ["2025-01-12", "2025-02-14", "2026-08-10"];

  it("excludes an 18-month gap from her average", () => {
    // Previously (33 + 542) / 2 = 288 days, which describes no one.
    const p = predictNextPeriod(TRACK_F)!;
    expect(p.averageLength).toBe(33);
  });

  it("but still reports her as irregular, which is what Track F depends on", () => {
    // The exact regression the first attempt at this caused: the gap disappeared
    // from the arithmetic AND from the signal, and a postmenopausal bleed read as
    // a regular cycle.
    const p = predictNextPeriod(TRACK_F)!;
    expect(p.irregular).toBe(true);
    expect(p.learning).toBe(false);
  });

  it("agrees with the visit report, which has always filtered these", () => {
    // One answer to "what is her average cycle length", on screen and on paper.
    const p = predictNextPeriod(TRACK_F)!;
    expect(p.averageLength).toBe(33);
  });

  it("reports no average at all when nothing logged is plausibly a cycle", () => {
    // Two bleeds two years apart do not make a two-year cycle. Averaging the gap
    // would state a number nothing in her body produced.
    expect(predictNextPeriod(["2024-01-01", "2026-01-01"])).toBeNull();
  });

  it("prefers her stated length over averaging a gap", () => {
    const p = predictNextPeriod(["2024-01-01", "2026-01-01"], 30)!;
    expect(p.basis).toBe("stated");
    expect(p.averageLength).toBe(30);
    expect(p.learning).toBe(true);
  });
});
