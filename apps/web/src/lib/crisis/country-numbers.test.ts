import { describe, expect, it } from "vitest";
import en from "../../../messages/en.json";
import ar from "../../../messages/ar.json";
import fr from "../../../messages/fr.json";
import es from "../../../messages/es.json";
import { COUNTRY_IDS, COUNTRY_NUMBERS, COUNTRY_NUMBERS_CHECKED } from "./country-numbers";

const all = COUNTRY_IDS.flatMap((c) => COUNTRY_NUMBERS[c]);

describe("country help numbers", () => {
  it("lists the seven sourced numbers and no others", () => {
    expect(all.map((n) => n.number).sort()).toEqual(
      ["123", "15115", "16328", "1919", "920033360", "937", "997"].sort(),
    );
  });

  it("gives every number a unique id, digits only, and an https source beside it", () => {
    expect(new Set(all.map((n) => n.id)).size).toBe(all.length);
    for (const n of all) {
      expect(n.number).toMatch(/^\d{3,9}$/);
      expect(n.sourceUrl).toMatch(/^https:\/\//);
    }
  });

  it("keeps emergency services apart: exactly one per country, and it is first", () => {
    for (const c of COUNTRY_IDS) {
      const kinds = COUNTRY_NUMBERS[c].map((n) => n.kind);
      expect(kinds.filter((k) => k === "emergency")).toHaveLength(1);
      expect(kinds[0]).toBe("emergency");
    }
  });

  it("has a service name for every number in all four languages", () => {
    for (const messages of [en, ar, fr, es]) {
      const names = messages.helpNow.numbers as Record<string, string>;
      for (const n of all) expect(names[n.id]?.length).toBeGreaterThan(3);
    }
  });

  it("states a check date, so the 12-month re-check can be enforced", () => {
    expect(COUNTRY_NUMBERS_CHECKED).toMatch(/^\d{4}-\d{2}-\d{2}$/);
  });
});
