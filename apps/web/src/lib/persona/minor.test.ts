import { describe, expect, it } from "vitest";
import { AGE_BANDS } from "./age";
import { MINOR_BLOCKED_PURPOSES, isMinor, purposeAllowedForAge } from "./minor";

describe("minor tier", () => {
  it("treats the three under-18 bands as minors and nobody else", () => {
    const minors = AGE_BANDS.filter((b) => isMinor(b));
    expect(minors).toEqual(["under_13", "13_15", "16_17"]);
  });

  /**
   * The uncomfortable default, and the deliberate one. Skipping an optional age
   * question must not silently opt a child into a third-party analytics SDK. The
   * cost of the other reading is one un-fired vendor script for an adult.
   */
  it("treats an unknown age as a minor — fails closed, not open", () => {
    expect(isMinor(null)).toBe(true);
    expect(isMinor(undefined)).toBe(true);
  });

  it("blocks analytics and research for a minor, whatever she taps", () => {
    for (const purpose of MINOR_BLOCKED_PURPOSES) {
      expect(purposeAllowedForAge(purpose, "13_15")).toBe(false);
      expect(purposeAllowedForAge(purpose, null)).toBe(false);
    }
  });

  /**
   * `insights` is first-party processing of her own record inside our own
   * database. Blocking it would take away the thing that makes the app useful to
   * her, which is restriction rather than protection (product rule 2).
   */
  it("leaves first-party insights available to a minor", () => {
    expect(purposeAllowedForAge("insights", "13_15")).toBe(true);
    expect(purposeAllowedForAge("core", "under_13")).toBe(true);
  });

  it("blocks nothing for an adult", () => {
    for (const purpose of ["analytics", "research", "insights", "core"]) {
      expect(purposeAllowedForAge(purpose, "25_34")).toBe(true);
    }
  });
});
