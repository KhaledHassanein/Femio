/**
 * The vocabulary's invariants — and, most importantly, that unifying three lists
 * into one did not silently drop a term.
 */
import { describe, expect, it } from "vitest";

import { CM_TYPES } from "../../fertility/index.ts";
import { SYMPTOM_GROUPS } from "../../cycle/symptoms.ts";
import {
  LOG_TERMS,
  LOG_VOCABULARY,
  defaultTermsForTrack,
  findTerm,
  termsInDimension,
} from "./vocabulary.ts";

describe("nothing was lost in the unification", () => {
  it("carries every key from SYMPTOM_GROUPS", () => {
    const legacy = SYMPTOM_GROUPS.flatMap((g) => g.symptoms as readonly string[]);
    const missing = legacy.filter((k) => findTerm(k) === undefined);
    expect(missing).toEqual([]);
    expect(legacy).toHaveLength(45);
  });

  it("carries every cervical-mucus type", () => {
    const missing = CM_TYPES.filter((k) => findTerm(k) === undefined);
    expect(missing).toEqual([]);
  });

  it("keeps the nine mood keys migration 0016 backfills, and no others", () => {
    expect(termsInDimension("mood").map((t) => t.key).sort()).toEqual(
      [
        "anxious",
        "calm",
        "happy",
        "irritable",
        "lowMotivation",
        "moodSwings",
        "panicFeelings",
        "sad",
        "tearfulness",
      ].sort(),
    );
  });
});

describe("structural invariants", () => {
  it("has no duplicate key", () => {
    const keys = LOG_TERMS.map((t) => t.key);
    expect(new Set(keys).size).toBe(keys.length);
  });

  it("gives every term an i18n key rather than a rendered string", () => {
    // A label containing a space is prose; a key is dotted and space-free. This is
    // the one mistake that breaks Arabic silently.
    const prose = LOG_TERMS.filter((t) => t.labelKey.includes(" ") || !t.labelKey.includes("."));
    expect(prose).toEqual([]);
  });

  it("scores severity only where an intensity is meaningful", () => {
    for (const t of LOG_TERMS) {
      if (t.dimension === "discharge" || t.dimension === "intercourse" || t.dimension === "vital") {
        expect(t.severityScale).toBe(false);
      }
    }
  });
});

describe("OD-5 — the intercourse dimension", () => {
  it("holds exactly one term", () => {
    expect(termsInDimension("intercourse")).toHaveLength(1);
  });

  it("names no act type", () => {
    const forbidden = ["oral", "anal", "orgasm", "masturbat", "toy", "sexDrive", "pleasure"];
    const offenders = LOG_TERMS.filter((t) =>
      forbidden.some((f) => t.key.toLowerCase().includes(f.toLowerCase())),
    );
    expect(offenders.map((t) => t.key)).toEqual([]);
  });

  it("keeps the clinical sexual-health symptoms, under clinical names", () => {
    // In scope precisely because a clinician asks about them. Dropping these to
    // satisfy OD-5 would remove dyspareunia from a gynaecology product.
    for (const key of ["painDuringSex", "vaginalDryness", "libidoUp", "libidoDown"]) {
      const t = findTerm(key);
      expect(t?.dimension).toBe("symptom");
      expect(t?.clinicalName).toBeTruthy();
      expect(t?.sensitivity).toBe("elevated");
    }
  });
});

describe("product rule 2 — lifeStages orders, it never restricts", () => {
  it("surfaces a majority of the vocabulary to every track", () => {
    // The guard is against `lifeStages` quietly becoming a filter. If a track's
    // default set ever collapses to a handful, someone has started partitioning.
    for (const track of ["A", "B", "C", "D", "E", "F", "Z"] as const) {
      const defaults = defaultTermsForTrack(track);
      expect(defaults.length).toBeGreaterThan(LOG_TERMS.length / 2);
    }
  });

  it("lets an adolescent log a menopause symptom", () => {
    // Not a hypothetical: `symptoms.ts` records that a separate menopause list
    // would have meant a woman in cycle mode could not log a night sweat. The
    // vocabulary is the whole list for everyone; only the default order differs.
    expect(findTerm("hotFlashes")).toBeDefined();
    expect(findTerm("nightSweats")).toBeDefined();
  });
});

describe("BBT is not duplicated", () => {
  it("has no vital term for basal body temperature", () => {
    // It lives in `fertility_logs.bbt` where lib/fertility reads it. Migration 0017
    // says so explicitly; two sources of truth for one measurement is the defect.
    expect(findTerm("bbt")).toBeUndefined();
    expect(findTerm("temp_bbt")).toBeUndefined();
  });

  it("still offers body temperature, which is a different measurement", () => {
    expect(findTerm("temp_body")?.dimension).toBe("vital");
  });
});

describe("the exported document", () => {
  it("is versioned", () => {
    expect(LOG_VOCABULARY.version).toBe(1);
    expect(LOG_VOCABULARY.terms).toBe(LOG_TERMS);
  });
});
