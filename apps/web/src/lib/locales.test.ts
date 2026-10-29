import { describe, expect, it } from "vitest";
import { routing } from "@/i18n/routing";
import { LOCALE_NAMES } from "./locales";

describe("language names for the switcher", () => {
  it("names every shipped locale, in that language's own script", () => {
    for (const l of routing.locales) expect(LOCALE_NAMES[l].length).toBeGreaterThan(0);
    expect(LOCALE_NAMES.ar).toMatch(/[\u0600-\u06FF]/);
  });
});
