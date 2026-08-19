import { describe, expect, it } from "vitest";
import { resolvePersona } from "@/lib/persona/resolver";
import { EMPTY_SIGNALS, type PersonaSignals } from "@/lib/persona/signals";
import { buildExperienceConfig, registryOf } from "./build";
import { PERSONA_RECORDS } from "./registry";
import { TRACK_C_RECORDS } from "./registry/track-c";

/**
 * Track C, end to end (R2.11).
 *
 * Five resolver rules have existed since P1.27.4 with **no record to compose**, so
 * every woman trying to conceive fell through to the generic document. This suite
 * asks the question R2.4 taught: does each record have a path through the resolver
 * from signals a real account could hold?
 */

const REGISTRY = registryOf(PERSONA_RECORDS);

const ttc = (over: Partial<PersonaSignals> = {}): PersonaSignals => ({
  ...EMPTY_SIGNALS,
  ageBand: "25_34",
  cycleRegularity: "regular",
  averageCycleLength: 29,
  ttcIntent: true,
  ttcMonths: 3,
  ...over,
});

const build = (personaId: string) =>
  buildExperienceConfig({
    resolution: {
      personaId,
      track: "C",
      modifiers: [],
      emotionalContext: [],
      confidence: 1,
      runnerUp: null,
    },
    // Track C has no phase concept, so the modules come from `home.default`.
    phase: null,
    registry: REGISTRY,
    resolvedAt: "2026-08-19T00:00:00.000Z",
  });

describe("every Track C persona is reachable", () => {
  const cases: Record<string, PersonaSignals> = {
    C1: ttc(),
    C2: ttc({ ttcMonths: 18 }),
    C3: ttc({ ageBand: "35_44", ttcMonths: 9 }),
    C6: ttc({ conditions: ["pcos"] }),
    C8: ttc({ conditions: ["thyroid"] }),
  };

  it("has a case for every record in the registry", () => {
    expect(TRACK_C_RECORDS.map((r) => r.id).sort()).toEqual(Object.keys(cases).sort());
  });

  for (const [id, signals] of Object.entries(cases)) {
    it(`resolves ${id} from a record an account could really hold`, () => {
      const resolution = resolvePersona(signals);
      expect(resolution.track).toBe("C");
      expect(resolution.personaId).toBe(id);
    });
  }

  /**
   * The evaluation window is one definition with three consumers (P1.27.8): twelve
   * months, six from 35. A 37-year-old at nine months is past hers while a
   * 30-year-old at nine months is not, and getting that backwards would hold her at
   * C1 for six extra months — the expensive direction.
   */
  it("uses her own window rather than one number", () => {
    expect(resolvePersona(ttc({ ttcMonths: 9 })).personaId).toBe("C1");
    expect(resolvePersona(ttc({ ageBand: "35_44", ttcMonths: 9 })).personaId).toBe("C3");
  });
});

describe("the documents Track C composes", () => {
  it("gives every persona the fertility log the track exists for", () => {
    for (const record of TRACK_C_RECORDS) {
      expect(build(record.id).tools).toContain("fertility");
      // And never at the cost of the cycle, which is what everything else predicts from.
      expect(build(record.id).tools).toContain("period");
    }
  });

  it("keeps C1's spine under every layer", () => {
    for (const id of ["C2", "C3", "C6", "C8"]) {
      const ids = build(id).home.modules.map((m) => m.id);
      expect(ids).toContain("quickLog");
      expect(ids).toContain("library");
    }
  });

  /**
   * Past her window the roadmap leads instead of the window: a fertile-window card
   * in month fourteen is the app answering a question she stopped asking. It is a
   * change of emphasis and **not** a statement that she has infertility (C2 §I).
   */
  it("lets the work-up take the hero from the window", () => {
    for (const id of ["C2", "C3"]) {
      const hero = build(id).home.modules.find((m) => m.emphasis === "hero");
      expect(hero?.id).toBe("ttc.workup");
    }
    expect(build("C1").home.modules.find((m) => m.emphasis === "hero")?.id).toBe("ttc.window");
  });

  it("raises exactly one hero per persona", () => {
    for (const record of TRACK_C_RECORDS) {
      expect(build(record.id).home.modules.filter((m) => m.emphasis === "hero")).toHaveLength(1);
    }
  });

  /**
   * Nothing in this track may schedule her. A daily nudge to someone trying to
   * conceive is the product setting the pace of the most anxious part of her month
   * (`docs/09` invariant 7), and a countdown to a test date is worse.
   */
  it("never sets the pace, and never counts down", () => {
    for (const record of TRACK_C_RECORDS) {
      const config = build(record.id);
      expect(config.tone.countdown).toBe(false);
      expect(config.tone.celebrationByDefault).toBe(false);
      expect(config.alerts.some((a) => a.kind === "cadence" && !a.id.startsWith("thyroid"))).toBe(
        false,
      );
    }
  });

  /** The contract cannot express restriction, and this track must not be the first. */
  it("adds no way to take anything away", () => {
    const json = JSON.stringify(TRACK_C_RECORDS);
    for (const forbidden of ["hidden", "blocked", "disabled", "available", "locked"]) {
      expect(json).not.toContain(`"${forbidden}"`);
    }
  });
});
