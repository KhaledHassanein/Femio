import { describe, expect, it } from "vitest";
import { resolvePersona } from "@/lib/persona/resolver";
import { EMPTY_SIGNALS, type PersonaSignals } from "@/lib/persona/signals";
import { buildExperienceConfig, registryOf } from "./build";
import { TRACK_E_RECORDS } from "./registry/track-e";
import { PERSONA_RECORDS } from "./registry";

/**
 * Track E reachability (R2.5f).
 *
 * The lesson R2.4 charged the most for: **R2.5 shipped a track that could not
 * actually resolve.** `weeksSincePregnancyEnd` was written by nothing, so E1's gate
 * could only fail, and the screen only looked right because the browser composed
 * the persona by hand and never asked the resolver. A registry record with no path
 * through the resolver is a file, not a feature — so every record in this track is
 * walked here from a signal set a real account could produce.
 */

const postpartum = (over: Partial<PersonaSignals> = {}): PersonaSignals => ({
  ...EMPTY_SIGNALS,
  ageBand: "25_34",
  cycleRegularity: "absent",
  averageCycleLength: 29,
  pregnancyStatus: "ended",
  weeksSincePregnancyEnd: 8,
  symptomCounts: { fatigue: 3 },
  ...over,
});

describe("every Track E persona is reachable", () => {
  const cases: Record<string, PersonaSignals> = {
    E1: postpartum(),
    E2: postpartum({ pregnancyOutcome: "completed" }),
    E3: postpartum({ conditions: ["depression_anxiety"] }),
    E4: postpartum({ conditions: ["gestational_diabetes"] }),
    E6: postpartum({ pregnancyOutcome: "loss", priorLoss: true }),
    E7: postpartum({ conditions: ["thyroid"] }),
  };

  it("has a case for every record in the registry", () => {
    expect(TRACK_E_RECORDS.map((r) => r.id).sort()).toEqual(Object.keys(cases).sort());
  });

  for (const [id, signals] of Object.entries(cases)) {
    it(`resolves ${id} from a record an account could really hold`, () => {
      const resolution = resolvePersona(signals);
      expect(resolution.track).toBe("E");
      expect(resolution.personaId).toBe(id);
    });
  }
});

describe("what wins when several apply", () => {
  /**
   * The fourth outing of the tie trap. Before E1 gained `conditions.length === 0`,
   * a woman who told the triage about her thyroid scored E1 and E7 identically at
   * 1.0, E1 won on rule order, and the condition she had reported changed nothing.
   */
  it("lets a reported condition beat the general postpartum persona", () => {
    expect(resolvePersona(postpartum({ conditions: ["thyroid"] })).personaId).toBe("E7");
    expect(resolvePersona(postpartum({ conditions: ["depression_anxiety"] })).personaId).toBe("E3");
  });

  it("still answers E1 when she reported nothing", () => {
    expect(resolvePersona(postpartum()).personaId).toBe("E1");
  });

  /**
   * `docs/09` §8 rule 2 — the most acute clinical emphasis wins the hero. The E4
   * schedule is time-critical (the 72-hour and 7–10-day blood-pressure checks, the
   * 4–12 week glucose test); postpartum thyroiditis is a watch across a year.
   */
  it("puts the time-critical follow-up ahead of the thyroid watch", () => {
    const both = postpartum({ conditions: ["pre_eclampsia", "thyroid"] });
    expect(resolvePersona(both).personaId).toBe("E4");
  });

  it("puts mood ahead of both", () => {
    const all = postpartum({ conditions: ["depression_anxiety", "gestational_diabetes", "thyroid"] });
    expect(resolvePersona(all).personaId).toBe("E3");
  });

  /**
   * The one that must never bend. A recorded loss routes to E6 whatever else is
   * true — a woman who lost a pregnancy and also reported gestational diabetes must
   * not be handed a follow-up schedule as her experience.
   */
  it("routes a loss to E6 no matter what else she reported", () => {
    for (const condition of ["depression_anxiety", "gestational_diabetes", "thyroid"]) {
      const signals = postpartum({
        pregnancyOutcome: "loss",
        priorLoss: true,
        conditions: [condition],
      });
      expect(resolvePersona(signals).personaId).toBe("E6");
    }
  });

  /** A year, not six months: E3 §A is explicit that mood can begin late. */
  it("keeps the mood and condition layers open for a full year", () => {
    const late = postpartum({ weeksSincePregnancyEnd: 40, conditions: ["depression_anxiety"] });
    expect(resolvePersona(late).personaId).toBe("E3");
  });
});

describe("the documents the new records compose", () => {
  const build = (personaId: string) =>
    buildExperienceConfig({
      resolution: {
        personaId,
        track: "E",
        modifiers: [],
        emotionalContext: [],
        confidence: 1,
        runnerUp: null,
      },
      phase: "postpartum",
      registry: registryOf(PERSONA_RECORDS),
      resolvedAt: "2026-08-16T00:00:00.000Z",
    });

  for (const id of ["E3", "E4", "E7"]) {
    it(`${id} keeps E1's spine rather than replacing it`, () => {
      const config = build(id);
      const ids = config.home.modules.map((m) => m.id);
      // E1 §A's own words, inherited through `extends`: the recovery experience
      // remains intact and foregrounded, and the layer *adds*.
      expect(ids).toContain("pregnancy.warningSigns");
      expect(ids).toContain("quickLog");
      expect(ids).toContain("library");
    });

    it(`${id} raises exactly one hero`, () => {
      const heroes = build(id).home.modules.filter((m) => m.emphasis === "hero");
      expect(heroes).toHaveLength(1);
    });

    it(`${id} never celebrates by default`, () => {
      // The mode alone does not say whether she brought a baby home.
      expect(build(id).tone.celebrationByDefault).toBe(false);
      expect(build(id).tone.countdown).toBe(false);
    });
  }

  it("gives E3 a support hero rather than a questionnaire", () => {
    const hero = build("E3").home.modules.find((m) => m.emphasis === "hero");
    // P2.7a: a ten-item screener in the first position makes opening the app feel
    // like being assessed, and this is the persona least able to afford that.
    expect(hero?.id).toBe("support.moodSupport");
  });

  it("surfaces the logs each layer actually needs", () => {
    expect(build("E4").tools).toContain("glucose");
    expect(build("E7").tools).toContain("labs");
    // And never at the cost of what E1 offered — nothing is ever removed.
    expect(build("E7").tools).toContain("period");
  });

  /**
   * The contract cannot express restriction, and these records must not be the
   * first to try. `tools` means *surfaced*, never *permitted*.
   */
  it("adds no way to take anything away", () => {
    for (const record of TRACK_E_RECORDS) {
      const json = JSON.stringify(record);
      for (const forbidden of ["hidden", "blocked", "disabled", "available", "locked"]) {
        expect(json).not.toContain(`"${forbidden}"`);
      }
    }
  });
});
