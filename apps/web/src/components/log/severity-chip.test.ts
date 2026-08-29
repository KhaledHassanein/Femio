import { describe, expect, it } from "vitest";
import { nextSeverity } from "./severity-chip";

describe("nextSeverity (RB-C6)", () => {
  it("starts at 1 when a chip is selected but never levelled", () => {
    // A selected chip logs `severity: null` until she says otherwise — a default
    // would be Femio inventing a number and then feeding it to a trend.
    expect(nextSeverity(null)).toBe(1);
  });

  it("cycles 1 → 2 → 3 → 4 → 1", () => {
    expect([1, 2, 3, 4].map((n) => nextSeverity(n as 1 | 2 | 3 | 4))).toEqual([2, 3, 4, 1]);
  });

  it("never cycles through zero, because removal is its own control", () => {
    // Hiding removal inside the rotation means a mis-tap silently deletes an entry.
    const reached = new Set([nextSeverity(null), ...[1, 2, 3, 4].map((n) => nextSeverity(n as 1))]);
    expect(reached.has(0 as never)).toBe(false);
  });
});
