import { describe, expect, it } from "vitest";
import { eddFromLmp, isPlausibleEdd, pregnancyProgress, trimesterFor } from "./index";

// EDD 2026-09-01 → conception-day zero is 2025-11-24 (280 days earlier).
const EDD = "2026-09-01";

describe("pregnancyProgress", () => {
  it("counts weeks and days the way a clinician writes them", () => {
    // 2026-05-01 is 123 days before the due date → 280 − 123 = 157 days = 22w3d.
    const p = pregnancyProgress(EDD, "2026-05-01");
    expect(p).not.toBeNull();
    expect(p?.totalDays).toBe(157);
    expect(p?.weeks).toBe(22);
    expect(p?.days).toBe(3);
  });

  it("reports days until the due date", () => {
    expect(pregnancyProgress(EDD, "2026-08-25")?.daysUntilDue).toBe(7);
  });

  it("handles being overdue rather than breaking", () => {
    // Most pregnancies are not born on the due date; past it must still render.
    const p = pregnancyProgress(EDD, "2026-09-08");
    expect(p?.overdue).toBe(true);
    expect(p?.daysUntilDue).toBe(-7);
    expect(p?.weeks).toBe(41);
    // The progress bar must not overflow once past term.
  });

  it("is exactly 40w0d on the due date, and not overdue", () => {
    const p = pregnancyProgress(EDD, EDD);
    expect(p?.weeks).toBe(40);
    expect(p?.days).toBe(0);
    expect(p?.overdue).toBe(false);
    expect(p?.daysUntilDue).toBe(0);
  });

  it("marks term as 37w0d, three weeks before the due date", () => {
    expect(pregnancyProgress(EDD, "2026-05-01")?.termStart).toBe("2026-08-11");
  });

  it("returns null before conception rather than a negative week count", () => {
    expect(pregnancyProgress(EDD, "2025-11-01")).toBeNull();
  });

  it("returns null implausibly far past term", () => {
    expect(pregnancyProgress(EDD, "2026-12-01")).toBeNull();
  });

  it("returns null for malformed dates", () => {
    expect(pregnancyProgress("not-a-date", "2026-05-01")).toBeNull();
    expect(pregnancyProgress(EDD, "")).toBeNull();
  });
});

describe("trimesterFor", () => {
  it("uses the common clinical boundaries", () => {
    expect(trimesterFor(0)).toBe(1);
    expect(trimesterFor(97)).toBe(1); // 13w6d
    expect(trimesterFor(98)).toBe(2); // 14w0d
    expect(trimesterFor(195)).toBe(2); // 27w6d
    expect(trimesterFor(196)).toBe(3); // 28w0d
    expect(trimesterFor(280)).toBe(3);
  });
});

describe("eddFromLmp", () => {
  it("adds 280 days", () => {
    expect(eddFromLmp("2025-11-24")).toBe("2026-08-31");
  });

  it("rejects a malformed date", () => {
    expect(eddFromLmp("2025-13-45")).toBeNull();
  });
});

describe("isPlausibleEdd", () => {
  const today = "2026-05-01";

  it("accepts a due date within a pregnancy's span", () => {
    expect(isPlausibleEdd("2026-09-01", today)).toBe(true);
  });

  it("accepts recently overdue", () => {
    expect(isPlausibleEdd("2026-04-20", today)).toBe(true);
  });

  it("rejects a typo far in the future", () => {
    // A week counter built on a typo is worse than an empty state.
    expect(isPlausibleEdd("2029-09-01", today)).toBe(false);
  });

  it("rejects a due date long past", () => {
    expect(isPlausibleEdd("2025-01-01", today)).toBe(false);
  });
});
