import { describe, expect, it } from "vitest";
import {
  DEFAULT_DIMENSION_ORDER,
  moveDimension,
  orderedDimensions,
  searchTerms,
} from "./log-search";
import type { LogTerm } from "./vocabulary";

const t = (key: string, label: string, dimension: LogTerm["dimension"] = "symptom"): LogTerm => ({
  key,
  dimension,
  labelKey: `x.${key}`,
  severityScale: true,
  lifeStages: ["B"],
  sensitivity: "normal",
});
const TERMS = [
  t("cramps", "Cramps"),
  t("backCramps", "Back cramps"),
  t("fatigue", "Fatigué"),
  t("lowMood", "Ánimo bajo", "mood"),
];
const label = (term: LogTerm) =>
  ({ cramps: "Cramps", backCramps: "Back cramps", fatigue: "Fatigué", lowMood: "Ánimo bajo" })[
    term.key
  ] ?? term.key;

describe("searchTerms", () => {
  it("returns nothing for an empty query rather than everything", () => {
    // The field is an alternative to browsing the cards, not a duplicate of them.
    expect(searchTerms("", label, TERMS)).toEqual([]);
    expect(searchTerms("   ", label, TERMS)).toEqual([]);
  });

  it("ranks a prefix match above one in the middle", () => {
    const hits = searchTerms("cr", label, TERMS).map((x) => x.key);
    expect(hits).toEqual(["cramps", "backCramps"]);
  });

  it("matches across accents, so French and Spanish work without them", () => {
    expect(searchTerms("fatigue", label, TERMS).map((x) => x.key)).toEqual(["fatigue"]);
    expect(searchTerms("animo", label, TERMS).map((x) => x.key)).toEqual(["lowMood"]);
  });

  it("is case-insensitive, and still matches a term that merely contains the word", () => {
    // "Back cramps" contains "cramps" and should be found — the first expectation
    // written here asserted otherwise and was wrong about the product, not the code.
    expect(searchTerms("CRAMPS", label, TERMS).map((x) => x.key)).toEqual([
      "cramps",
      "backCramps",
    ]);
  });

  it("searches every dimension, not just the visible ones", () => {
    // Hiding a category hides it from the default view; it never removes a term
    // from search, because she asked for it by name.
    expect(searchTerms("animo", label, TERMS).map((x) => x.dimension)).toEqual(["mood"]);
  });
});

describe("orderedDimensions", () => {
  it("defaults to the documented order", () => {
    expect(orderedDimensions().visible).toEqual(DEFAULT_DIMENSION_ORDER);
    expect(orderedDimensions().hidden).toEqual([]);
  });

  it("honours her order and appends anything she has no opinion about", () => {
    // A dimension added by a later release must appear, not vanish.
    const { visible } = orderedDimensions({ order: ["mood", "symptom"] });
    expect(visible.slice(0, 2)).toEqual(["mood", "symptom"]);
    expect(new Set(visible)).toEqual(new Set(DEFAULT_DIMENSION_ORDER));
  });

  it("ignores a stale preference naming a dimension that no longer exists", () => {
    const { visible } = orderedDimensions({
      order: ["mood", "notADimension" as never, "symptom"],
    });
    expect(new Set(visible)).toEqual(new Set(DEFAULT_DIMENSION_ORDER));
  });

  it("separates hidden rather than dropping them, so they can be offered back", () => {
    const { visible, hidden } = orderedDimensions({ hidden: ["vital"] });
    expect(visible).not.toContain("vital");
    expect(hidden).toEqual(["vital"]);
  });
});

describe("moveDimension", () => {
  it("moves one place and is total at the ends", () => {
    const order = ["symptom", "mood", "vital"] as const;
    expect(moveDimension(order, "mood", -1)).toEqual(["mood", "symptom", "vital"]);
    expect(moveDimension(order, "symptom", -1)).toEqual(order);
    expect(moveDimension(order, "vital", 1)).toEqual(order);
  });

  it("returns the input unchanged for a dimension it does not contain", () => {
    const order = ["symptom"] as const;
    expect(moveDimension(order, "mood", 1)).toEqual(order);
  });
});
