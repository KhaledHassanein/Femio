import { describe, expect, it } from "vitest";
import { PERSONA_RECORDS } from "./registry";
import type { LogKind } from "./types";

/**
 * The log vocabulary (R2.10a).
 *
 * `ExperienceConfig.tools` is the engine's only way to say "surface this logger",
 * so a screen that exists without a kind is a screen the engine cannot reach —
 * which is how `/fertility` came to be opened by a `mode === "ttc"` button.
 */
describe("the log vocabulary", () => {
  const offered = new Set<string>(PERSONA_RECORDS.flatMap((r) => [...r.tools]));

  /**
   * The two new kinds are deliberately offered by nobody yet: which personas
   * surface a logger is a persona decision and belongs in `registry/`, not in the
   * type. This asserts the gap is the *known* one rather than an oversight, and it
   * is the test that should be deleted — not weakened — when R2.10 wires them.
   */
  it("knows about fertility and feeding before any persona offers them", () => {
    const declared: LogKind[] = ["fertility", "feeding"];
    for (const kind of declared) {
      expect(offered.has(kind)).toBe(false);
    }
  });

  /** Nothing may surface a logger the contract has no word for. */
  it("offers only kinds the contract declares", () => {
    const KNOWN: LogKind[] = [
      "period", "symptom", "weight", "glucose", "medication", "labs",
      "movement", "contractions", "appointment", "mood", "fertility", "feeding",
    ];
    expect([...offered].filter((k) => !(KNOWN as string[]).includes(k))).toEqual([]);
  });

  /** `tools` means surfaced, never permitted — every record keeps it a plain list. */
  it("never lets a record express a restriction through its tools", () => {
    for (const record of PERSONA_RECORDS) {
      expect(Array.isArray(record.tools)).toBe(true);
      expect(record.tools.every((t) => typeof t === "string")).toBe(true);
    }
  });
});
