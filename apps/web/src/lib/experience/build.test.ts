import { describe, expect, it } from "vitest";
import { buildExperienceConfig, registryOf, type Registry } from "./build";
import { TRACK_D_RECORDS } from "./registry/track-d";
import type { Resolution } from "@/lib/persona/resolver";

const registry: Registry = registryOf(TRACK_D_RECORDS);
const AT = "2026-08-11T00:00:00.000Z";

function resolution(personaId: string, over: Partial<Resolution> = {}): Resolution {
  return {
    personaId,
    track: "D",
    modifiers: [],
    emotionalContext: [],
    confidence: 0.9,
    runnerUp: null,
    ...over,
  };
}

const build = (personaId: string, phase: Parameters<typeof buildExperienceConfig>[0]["phase"], over?: Partial<Resolution>, emotionalLayers?: string[]) =>
  buildExperienceConfig({
    resolution: resolution(personaId, over),
    phase,
    registry,
    resolvedAt: AT,
    emotionalLayers,
  });

const ids = (c: ReturnType<typeof build>) => c.home.modules.map((m) => m.id);
const heroes = (c: ReturnType<typeof build>) =>
  c.home.modules.filter((m) => m.emphasis === "hero").map((m) => m.id);

describe("buildExperienceConfig", () => {
  it("gives D1 the week card as its hero, and the T3 tools T3 asks for", () => {
    const t3 = build("D1", "t3");
    expect(heroes(t3)).toEqual(["pregnancy.week"]);
    expect(ids(t3)).toContain("pregnancy.movement");
    expect(ids(t3)).toContain("pregnancy.contractions");
  });

  /**
   * The rule every Track-D spec states: the D1 experience "remains completely
   * intact and foregrounded" and the clinical tools are *added*. If a layer ever
   * starts subtracting, this fails.
   */
  it("layers add to the spine and never remove from it", () => {
    const base = new Set(ids(build("D1", "t2")));
    for (const persona of ["D3", "D4", "D7"]) {
      const layered = new Set(ids(build(persona, "t2")));
      for (const id of base) {
        expect(layered.has(id), `${persona} dropped ${id}`).toBe(true);
      }
      expect(layered.size).toBeGreaterThan(base.size);
    }
  });

  /**
   * THE ACCEPTANCE TEST FOR R2.3. If these two produce the same screen, the whole
   * engine is pointless — and `docs/09` §8 rule 3 says conflating them is the
   * specific error to design against.
   */
  it("makes D3 and D4 genuinely different screens", () => {
    const d3 = build("D3", "t2");
    const d4 = build("D4", "t2");

    expect(ids(d3)).not.toEqual(ids(d4));
    expect(d3.content.skin).not.toBe(d4.content.skin);
    expect(d3.alerts.map((a) => a.id)).not.toEqual(d4.alerts.map((a) => a.id));

    // The clinical difference, not a cosmetic one: only the lifelong persona has a
    // preconception phase and device modules.
    expect(ids(build("D4", "preconception")).length).toBeGreaterThan(0);
    expect(ids(build("D3", "preconception"))).toEqual([]);
    expect(ids(d4)).toContain("strip.devices");
    expect(ids(d3)).not.toContain("strip.devices");
  });

  it("gives D7 its thyroid strip beside the week card — the reason D7 exists", () => {
    const d7 = build("D7", "t1");
    expect(ids(d7)).toContain("strip.thyroid");
    expect(heroes(d7)).toEqual(["pregnancy.week"]);
  });

  it("never leaves more than one hero on a screen", () => {
    for (const persona of ["D1", "D2", "D3", "D4", "D7"]) {
      for (const phase of ["preconception", "t1", "t2", "t3", "postpartum"] as const) {
        expect(heroes(build(persona, phase)).length, `${persona}/${phase}`).toBeLessThanOrEqual(1);
      }
    }
  });

  /**
   * D2 §I: "Hero = next milestone… not a fruit card or day counter." The week card
   * is **demoted, not deleted** — she can opt back into development content.
   */
  it("lets D2 take the hero from the week card without removing it", () => {
    const d2 = build("D2", "t1");
    expect(heroes(d2)).toEqual(["pregnancy.milestone"]);
    expect(ids(d2)).toContain("pregnancy.week");
    expect(d2.home.modules.find((m) => m.id === "pregnancy.week")?.emphasis).toBe("primary");
  });

  /**
   * The worked blend from `docs/09` §8/§9: pregnancy + thyroid + prior loss is a
   * D7 hero with thyroid and PAL strips and an anxiety-aware tone — not a D2
   * screen, and not a shrug. This is the case the whole layering model exists for.
   */
  it("stacks D2's tone onto a clinical persona without taking its hero", () => {
    const blended = build(
      "D7",
      "t3",
      { modifiers: ["thyroid"], emotionalContext: ["prior_loss"] },
      ["D2"],
    );

    // The CLINICAL persona keeps the hero — the worked example says "hero =
    // pregnancy timeline", not a milestone card. A woman carrying thyroid disease
    // through a pregnancy after loss must not lose the answer she opened the app
    // for, and PAL arrives as a strip beside it.
    expect(heroes(blended)).toEqual(["pregnancy.week"]);
    // …the thyroid strip is still there…
    expect(ids(blended)).toContain("strip.thyroid");
    // …the loss-aware support arrives as a strip, and the milestone card is
    // present but subordinate…
    expect(ids(blended)).toContain("support.lossAware");
    expect(blended.home.modules.find((m) => m.id === "pregnancy.milestone")?.emphasis).toBe(
      "primary",
    );
    // …the tone is the protective one…
    expect(blended.tone.register).toBe("anxietyAware");
    expect(blended.tone.celebrationByDefault).toBe(false);
    // …and the library is still the thyroid one, because her condition did not go
    // away when her tone changed.
    expect(blended.content.skin).toBe("pregnancy-thyroid");
  });

  it("cannot have celebration switched back on by a clinical layer", () => {
    const withLoss = build("D3", "t2", { emotionalContext: ["prior_loss"] }, ["D2"]);
    expect(withLoss.tone.celebrationByDefault).toBe(false);
    expect(withLoss.tone.readingLevel).toBe("gentle");
  });

  it("merges overlapping alerts by id rather than double-counting them", () => {
    const d7 = build("D7", "t3");
    const seen = d7.alerts.map((a) => a.id);
    expect(new Set(seen).size).toBe(seen.length);
    // D1's red-flag set survives the layering — safety layers union, never replace.
    expect(seen).toContain("pregnancy.redFlags");
  });

  /**
   * `docs/09` §5: Z1 is a real answer, not a failure. An unregistered persona must
   * degrade to the generic experience rather than throw at someone opening her app.
   */
  it("degrades to a generic document for a persona the registry does not know", () => {
    const unknown = buildExperienceConfig({
      resolution: resolution("D99"),
      phase: "t2",
      registry,
      resolvedAt: AT,
    });
    expect(unknown.home.modules).toEqual([]);
    expect(unknown.tools).toEqual([]);
    expect(unknown.tone.register).toBe("neutral");
    expect(unknown.version).toBe(1);
  });

  it("is deterministic — same input, identical document", () => {
    expect(build("D7", "t2")).toEqual(build("D7", "t2"));
  });

  /** Product rule 2, checked on the output and not only on the input records. */
  it("produces a document that cannot express restriction", () => {
    const forbidden = ["hidden", "blocked", "disabled", "locked", "available", "permitted"];
    const walk = (value: unknown, path: string): void => {
      if (value === null || typeof value !== "object") return;
      if (Array.isArray(value)) return value.forEach((v, i) => walk(v, `${path}[${i}]`));
      for (const [key, v] of Object.entries(value)) {
        expect(forbidden, `${path}.${key}`).not.toContain(key.toLowerCase());
        walk(v, `${path}.${key}`);
      }
    };
    walk(build("D7", "t3", { emotionalContext: ["prior_loss"] }, ["D2"]), "config");
  });
});
