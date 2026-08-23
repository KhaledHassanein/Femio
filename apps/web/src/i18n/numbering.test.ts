import { describe, expect, it } from "vitest";
import { routing } from "./routing";

/**
 * Arabic renders Western digits, and that is now a decision rather than a default
 * (R3.5.2, owner direction 2026-08-23: *"arabic digits are same as english"*).
 *
 * `docs/26` reported Arabic mixing Western and Arabic-Indic numerals and filed it
 * as a locale call. Measured here, both Node's ICU and Chromium's resolve `ar` to
 * the `latn` numbering system, and every literal in `ar.json` already uses Western
 * digits — so the product has been doing the right thing by accident.
 *
 * **By accident is the problem this test fixes.** Nothing in Femio asks for `latn`;
 * it is the CLDR default for `ar` today. A future ICU or CLDR release that flips
 * that default would silently change every number a woman sees — her cycle length,
 * her age band, her due date — with no code change, no failing build, and no way to
 * connect the change to a cause months later. This is the same class as the
 * Tailwind-preset trap in `STATE.md`: a default that is right until it isn't.
 *
 * So the decision is pinned. If this fails, the runtime changed its mind and
 * somebody has to make the call again deliberately — the fix is then to pass the
 * `-u-nu-latn` extension where we format, not to relax this.
 */
describe("Arabic numbering system", () => {
  it("resolves to Western digits for every locale we ship", () => {
    for (const locale of routing.locales) {
      expect(new Intl.NumberFormat(locale).resolvedOptions().numberingSystem).toBe("latn");
    }
  });

  it("renders a cycle length the same way in Arabic as in English", () => {
    expect(new Intl.NumberFormat("ar").format(28)).toBe("28");
    expect(new Intl.NumberFormat("ar").format(13)).toBe("13");
  });

  /**
   * Dates were already Western and are the half `docs/26` found correct. Pinned
   * with the rest, because "correct in one place and not the other" was the
   * original complaint and a partial pin would let it come back.
   */
  it("renders a date with Western digits in Arabic", () => {
    const formatted = new Intl.DateTimeFormat("ar", {
      day: "numeric",
      month: "numeric",
      year: "numeric",
      timeZone: "UTC",
    }).format(new Date("2026-08-23T00:00:00Z"));
    expect(formatted).toMatch(/\d/);
    expect(formatted).not.toMatch(/[٠-٩۰-۹]/);
  });
});
