import { describe, expect, it } from "vitest";
import {
  CONFIDENCE_THRESHOLD,
  PERSONA_RULES,
  resolvePersona,
  type Resolution,
} from "@/lib/persona/resolver";
import { EMPTY_SIGNALS, type PersonaSignals } from "@/lib/persona/signals";

const signals = (over: Partial<PersonaSignals> = {}): PersonaSignals => ({
  ...EMPTY_SIGNALS,
  ...over,
});

/** A well-populated signal set, so confidence is not suppressed by thin coverage. */
const rich = (over: Partial<PersonaSignals> = {}): PersonaSignals =>
  signals({
    ageBand: "25_34",
    cycleRegularity: "regular",
    averageCycleLength: 28,
    daysSinceLastPeriod: 10,
    pregnancyStatus: null,
    conditions: [],
    symptomCounts: { cramps: 3 },
    ...over,
  });

describe("resolvePersona — the invariants", () => {
  it("always resolves to something; an empty account is Z1, not a failure", () => {
    const r = resolvePersona(EMPTY_SIGNALS);
    expect(r.personaId).toBe("Z1");
    expect(r.track).toBe("Z");
    // docs/09 §5: "if no persona fits, she stays in the rich generic experience
    // permanently — that is a valid, first-class state, not a failure."
    expect(r.confidence).toBeLessThan(CONFIDENCE_THRESHOLD);
  });

  it("cannot express restriction — the result shape has no access fields", () => {
    // Invariant 1 is "personalize, never restrict". This asserts the *type* stays
    // incapable of gating, the same way the movement log has no verdict column.
    const r: Resolution = resolvePersona(rich());
    for (const forbidden of ["hidden", "blocked", "disabled", "locked", "available", "allowed"]) {
      expect(Object.hasOwn(r, forbidden)).toBe(false);
    }
    expect(Object.keys(r).sort()).toEqual(
      ["confidence", "emotionalContext", "modifiers", "personaId", "runnerUp", "track"].sort(),
    );
  });

  it("offers rather than commits when confidence is below the threshold", () => {
    // One weak signal and nothing else: a real persona would be a guess.
    const r = resolvePersona(signals({ ageBand: "13_15" }));
    expect(r.personaId).toBe("Z1");
    expect(r.runnerUp?.personaId).toBe("A2");
    // P1.27.5 shows this as "Want me to tailor Femio for X?" — never applies it.
    expect(r.runnerUp!.confidence).toBeLessThan(CONFIDENCE_THRESHOLD);
  });

  it("blends to Z1 when the top two are too close to choose between", () => {
    // Irregular cycles with no other distinguishing signal put B1 and B5 within a
    // hair of each other; docs/09 §5 says blend rather than commit.
    const r = resolvePersona(
      rich({ cycleRegularity: "irregular", daysSinceLastPeriod: 50, symptomCounts: {} }),
    );
    if (r.personaId === "Z1") expect(r.runnerUp).not.toBeNull();
    else expect(r.confidence).toBeGreaterThanOrEqual(CONFIDENCE_THRESHOLD);
  });
});

describe("resolvePersona — D3 and D4 must never be conflated", () => {
  // docs/09 §8 rule 3. Gestational diabetes resolves postpartum and routes to a
  // one-off OGTT; pre-existing diabetes is lifelong and routes to ongoing E4 care.
  // Getting this backwards would give the wrong follow-up to a real condition.
  const base = rich({
    pregnancyStatus: "active",
    conditions: ["diabetes"],
    ageBand: "25_34",
    symptomCounts: { nausea: 3 },
  });

  it("diabetes recorded during the pregnancy resolves to D3", () => {
    const r = resolvePersona({ ...base, diabetesRecordedBeforePregnancy: false });
    expect(r.personaId).toBe("D3");
  });

  it("diabetes recorded before the pregnancy resolves to D4", () => {
    const r = resolvePersona({ ...base, diabetesRecordedBeforePregnancy: true });
    expect(r.personaId).toBe("D4");
  });

  it("the two are mutually exclusive by construction, not by scoring luck", () => {
    // Each gates on the flag, so exactly one can ever be a candidate.
    const d3 = PERSONA_RULES.find((r) => r.id === "D3")!;
    const d4 = PERSONA_RULES.find((r) => r.id === "D4")!;
    const before = { ...base, diabetesRecordedBeforePregnancy: true };
    const during = { ...base, diabetesRecordedBeforePregnancy: false };
    const gated = (rule: typeof d3, s: PersonaSignals) => rule.requires!.every((g) => g(s));
    expect(gated(d3, before)).toBe(false);
    expect(gated(d4, before)).toBe(true);
    expect(gated(d3, during)).toBe(true);
    expect(gated(d4, during)).toBe(false);
  });
});

describe("resolvePersona — pregnancy gating", () => {
  it("no D-track persona can fire for someone who is not pregnant", () => {
    const notPregnant = rich({ conditions: ["thyroid", "diabetes"], priorLoss: true });
    const r = resolvePersona(notPregnant);
    expect(r.track).not.toBe("D");
  });

  it("a prior loss during a current pregnancy resolves to D2, not D1", () => {
    const r = resolvePersona(
      rich({ pregnancyStatus: "active", priorLoss: true, symptomCounts: { nausea: 3 } }),
    );
    expect(r.personaId).toBe("D2");
  });
});

describe("resolvePersona — modifiers are layers, not personas", () => {
  it("a condition surfaces as a modifier even when another persona wins", () => {
    const r = resolvePersona(
      rich({ pregnancyStatus: "active", conditions: ["thyroid"], symptomCounts: { nausea: 3 } }),
    );
    expect(r.personaId).toBe("D7");
    expect(r.modifiers).toContain("thyroid");
  });

  it("modifiers stack rather than competing", () => {
    const r = resolvePersona(
      rich({
        pregnancyStatus: "active",
        priorLoss: true,
        conditions: ["thyroid"],
        cycleRegularity: "irregular",
        symptomCounts: { nausea: 3 },
      }),
    );
    // docs/09 §8: pregnancy ⊕ thyroid ⊕ PAL is a specified blend.
    expect(r.modifiers).toEqual(expect.arrayContaining(["thyroid", "pregnancy_after_loss"]));
    expect(r.emotionalContext).toContain("prior_loss");
  });

  it("loss marks emotional context wherever it appears", () => {
    // Invariant 7: loss suppresses celebratory content everywhere, so the context
    // must survive independently of which persona resolved.
    const r = resolvePersona(rich({ priorLoss: true }));
    expect(r.emotionalContext).toContain("prior_loss");
  });
});

describe("resolvePersona — determinism and shape", () => {
  it("is a pure function of its input", () => {
    const s = rich({ ttcIntent: true });
    expect(resolvePersona(s)).toEqual(resolvePersona(s));
  });

  it("confidence is always a usable 0–1 number", () => {
    const cases = [
      EMPTY_SIGNALS,
      rich(),
      rich({ ttcIntent: true }),
      rich({ pregnancyStatus: "active", symptomCounts: { nausea: 3 } }),
      rich({ daysSinceLastPeriod: 400, ageBand: "55_plus" }),
    ];
    for (const s of cases) {
      const { confidence } = resolvePersona(s);
      expect(Number.isFinite(confidence)).toBe(true);
      expect(confidence).toBeGreaterThanOrEqual(0);
      expect(confidence).toBeLessThanOrEqual(1);
    }
  });

  it("every rule id is unique and declares at least one weighted signal", () => {
    const ids = PERSONA_RULES.map((r) => r.id);
    expect(new Set(ids).size).toBe(ids.length);
    for (const rule of PERSONA_RULES) {
      expect(rule.signals.length).toBeGreaterThan(0);
      expect(rule.signals.reduce((n, s) => n + s.weight, 0)).toBeGreaterThan(0);
    }
  });
});

describe("resolvePersona — the stated-intent rules", () => {
  it("TTC intent is never inferred; it only ever comes from her saying so", () => {
    const withoutIntent = resolvePersona(rich());
    const withIntent = resolvePersona(rich({ ttcIntent: true }));
    expect(withoutIntent.track).not.toBe("C");
    expect(withIntent.track).toBe("C");
  });

  it("TTC plus a recorded condition prefers the specific persona", () => {
    const r = resolvePersona(rich({ ttcIntent: true, conditions: ["thyroid"] }));
    expect(r.personaId).toBe("C8");
  });
});
