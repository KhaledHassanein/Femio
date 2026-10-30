import { describe, expect, it } from "vitest";
import en from "../../../messages/en.json";
import ar from "../../../messages/ar.json";
import fr from "../../../messages/fr.json";
import es from "../../../messages/es.json";
import { COUNTRY_IDS, COUNTRY_NUMBERS, COUNTRY_NUMBERS_CHECKED } from "./country-numbers";

const all = COUNTRY_IDS.flatMap((c) => COUNTRY_NUMBERS[c]);

describe("country help numbers", () => {
  it("lists sixteen countries, Arabic-speaking first", () => {
    expect(COUNTRY_IDS).toHaveLength(16);
    expect(COUNTRY_IDS.slice(0, 10)).toEqual([
      "egypt",
      "saudi",
      "uae",
      "qatar",
      "kuwait",
      "bahrain",
      "oman",
      "jordan",
      "lebanon",
      "morocco",
    ]);
  });

  it("lists exactly the sourced numbers and no others", () => {
    expect(all.map((n) => n.number).sort()).toEqual(
      ["016", "024", "065815826", "08082000247", "111", "112", "112", "123", "140", "15", "15", "15115", "1564", "16000", "16328", "18007997233", "19", "1919", "193", "3114", "3919", "80077788", "8009112000", "911", "911", "911", "911", "920033360", "937", "988", "988", "997", "998", "999", "999", "999", "9999"],
    );
  });

  it("gives every number a unique id, digits only, and an https source that is not social media", () => {
    expect(new Set(all.map((n) => n.id)).size).toBe(all.length);
    for (const n of all) {
      expect(n.number).toMatch(/^\d{2,11}$/);
      expect(n.sourceUrl).toMatch(/^https:\/\//);
      expect(n.sourceUrl).not.toMatch(/facebook\.com|instagram\.com|x\.com|twitter\.com/);
    }
  });

  it("keeps emergency services apart: every country has one, and they come first", () => {
    for (const c of COUNTRY_IDS) {
      const kinds = COUNTRY_NUMBERS[c].map((n) => n.kind);
      expect(kinds[0]).toBe("emergency");
      const firstSupport = kinds.indexOf("support");
      if (firstSupport !== -1) expect(kinds.slice(firstSupport)).not.toContain("emergency");
    }
  });

  it("has a country name and a service name for every entry in all four languages", () => {
    for (const messages of [en, ar, fr, es]) {
      const countries = messages.helpNow.countries as Record<string, string>;
      const names = messages.helpNow.numbers as Record<string, string>;
      for (const c of COUNTRY_IDS) expect(countries[c]?.length).toBeGreaterThan(2);
      for (const n of all) expect(names[n.id]?.length).toBeGreaterThan(3);
      expect(Object.keys(names).sort()).toEqual(all.map((n) => n.id).sort());
    }
  });

  it("states a check date, so the 12-month re-check can be enforced", () => {
    expect(COUNTRY_NUMBERS_CHECKED).toMatch(/^\d{4}-\d{2}-\d{2}$/);
  });
});
