import { describe, expect, it } from "vitest";
import { getDir, isLocale } from "./routing";

describe("isLocale", () => {
  it("accepts every supported locale", () => {
    expect(isLocale("en")).toBe(true);
    expect(isLocale("ar")).toBe(true);
    expect(isLocale("fr")).toBe(true);
    expect(isLocale("es")).toBe(true);
  });

  it("rejects unsupported or missing values", () => {
    expect(isLocale("de")).toBe(false);
    expect(isLocale("")).toBe(false);
    expect(isLocale(undefined)).toBe(false);
  });
});

describe("getDir", () => {
  it("returns rtl for Arabic", () => {
    expect(getDir("ar")).toBe("rtl");
  });

  it("returns ltr for Latin-script locales", () => {
    expect(getDir("en")).toBe("ltr");
    expect(getDir("fr")).toBe("ltr");
    expect(getDir("es")).toBe("ltr");
  });
});
