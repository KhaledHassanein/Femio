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
   * `feeding` is wired (R2.10b) and `fertility` is not, and the split is the point:
   * E2 owns feeding and exists, while the persona that owns fertility logging is
   * Track C — which has **no registry at all**. C1, C2 and C3 resolve into nothing
   * to compose, so `/fertility` is still opened by a button rather than surfaced by
   * the engine. Delete this half when Track C lands; do not weaken it before then.
   */
  it("still has nobody to surface fertility logging, because Track C has no registry", () => {
    expect(offered.has("fertility")).toBe(false);
    expect(PERSONA_RECORDS.some((r) => r.track === "C")).toBe(false);
  });

  /**
   * And feeding reaches exactly one persona. E2's gate is a stated live birth,
   * which E6 can never satisfy — a feeding logger on the recovery spine would
   * reach a woman after a loss through `extends`, which is the one thing this
   * track must never do.
   */
  it("offers feeding from E2 alone", () => {
    const offering = PERSONA_RECORDS.filter((r) => r.tools.includes("feeding")).map((r) => r.id);
    expect(offering).toEqual(["E2"]);
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
