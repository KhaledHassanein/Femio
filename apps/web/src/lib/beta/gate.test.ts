import { describe, expect, it } from "vitest";
import { codeAccepted } from "./gate";

describe("beta invite gate", () => {
  /**
   * The property that matters most. A misconfigured environment must not lock
   * people out of a health app, and until a code is set nothing about the current
   * situation has changed.
   */
  it("is open when no code is configured", () => {
    expect(codeAccepted("", null)).toBe(true);
    expect(codeAccepted("anything", null)).toBe(true);
  });

  it("accepts the code regardless of case and spacing", () => {
    for (const entered of ["FEMIO-BETA", "femio-beta", "  Femio-Beta  ", "femio beta"]) {
      expect(codeAccepted(entered, "femio-beta"), entered).toBe(true);
    }
  });

  it("refuses anything else", () => {
    for (const entered of ["", "femiobeta1", "beta", "femio-betaa"]) {
      expect(codeAccepted(entered, "femio-beta"), entered).toBe(false);
    }
  });
});
