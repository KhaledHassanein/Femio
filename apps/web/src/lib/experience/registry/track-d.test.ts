import { describe, expect, it } from "vitest";
import { TRACK_D_RECORDS, findRecord } from "./track-d";
import type { PersonaRecord } from "../types";

/**
 * These are **structural** tests, not behavioural ones — nothing consumes the
 * registry yet (R2.1 is data only). They exist because the invariants below are
 * the ones a future session could break by accident, and because a registry that
 * silently drifts from the specs is worse than no registry: it would look
 * authoritative while being wrong.
 */

describe("Track D registry", () => {
  it("covers the five personas R2 proves the engine on", () => {
    expect(TRACK_D_RECORDS.map((r) => r.id).sort()).toEqual(["D1", "D2", "D3", "D4", "D7"]);
  });

  it("every `extends` resolves, and D1 is the spine that extends nothing", () => {
    for (const r of TRACK_D_RECORDS) {
      if (r.id === "D1") {
        expect(r.extends).toBeUndefined();
        continue;
      }
      expect(r.extends).toBe("D1");
      expect(findRecord(r.extends!)).toBeDefined();
    }
  });

  /**
   * Product rule 2, made structural. Every Track-D spec says "nothing is locked",
   * so no record may carry a field that could express it — a type can be widened
   * by a careless `as`, but this test reads the actual objects.
   */
  it("cannot express restriction — no record has a hiding field", () => {
    const forbidden = ["hidden", "blocked", "disabled", "locked", "available", "permitted"];
    const walk = (value: unknown, path: string): void => {
      if (value === null || typeof value !== "object") return;
      if (Array.isArray(value)) {
        value.forEach((v, i) => walk(v, `${path}[${i}]`));
        return;
      }
      for (const [key, v] of Object.entries(value)) {
        expect(forbidden, `${path}.${key} is a restriction field`).not.toContain(key.toLowerCase());
        walk(v, `${path}.${key}`);
      }
    };
    walk(TRACK_D_RECORDS, "TRACK_D_RECORDS");
  });

  /**
   * `docs/09` §8 rule 3: gestational and pre-existing diabetes must never be
   * conflated — one resolves postpartum into a single OGTT, the other is lifelong.
   * Watched failing against a version where D4 simply reused D3's records.
   */
  it("keeps D3 and D4 distinct where it clinically matters", () => {
    const d3 = findRecord("D3")!;
    const d4 = findRecord("D4")!;

    // Only the lifelong one starts before conception.
    expect(d3.home.preconception).toBeUndefined();
    expect(d4.home.preconception).toBeDefined();

    // Both continue postpartum, but for opposite reasons: D3 hands off to a
    // one-off OGTT, D4 carries on because diabetes does not end.
    const alertIds = (r: PersonaRecord) => r.alerts.map((a) => a.id);
    expect(alertIds(d3)).toContain("gdm.postpartumOgtt");
    expect(alertIds(d4)).not.toContain("gdm.postpartumOgtt");
    expect(alertIds(d4)).toContain("diabetes.postpartumHypo");

    // And they never collapse into the same content skin.
    expect(d3.content.skin).not.toBe(d4.content.skin);
  });

  /**
   * D2 §I: it "stacks on any D-track clinical persona" — the clinical layer wins
   * the hero, the anxiety-aware tone stays. It is the only Track-D record that is
   * an emotional layer, and the only one that turns celebration off.
   */
  it("marks D2 as the emotional layer, with celebration and countdown off", () => {
    const layers = TRACK_D_RECORDS.filter((r) => r.emotionalLayer);
    expect(layers.map((r) => r.id)).toEqual(["D2"]);

    const d2 = findRecord("D2")!;
    expect(d2.tone.register).toBe("anxietyAware");
    expect(d2.tone.celebrationByDefault).toBe(false);
    expect(d2.tone.countdown).toBe(false);
  });

  /** No Track-D persona may run a countdown — the EDD is not a finish line (ADR-053). */
  it("never runs a countdown in any persona", () => {
    for (const r of TRACK_D_RECORDS) expect(r.tone.countdown).toBe(false);
  });

  /**
   * D7 is the destination of the C8→D7 flagship, and the single reason it exists
   * is the thyroid strip beside the week card.
   */
  it("gives D7 a thyroid strip in every pregnancy phase", () => {
    const d7 = findRecord("D7")!;
    for (const phase of ["t1", "t2", "t3"] as const) {
      const ids = (d7.home[phase] ?? []).map((m) => m.id);
      expect(ids, `D7 ${phase}`).toContain("strip.thyroid");
    }
  });

  /**
   * A layer must not claim the hero: the base owns it, and D2 is the deliberate
   * exception because its spec replaces the week card with a milestone.
   */
  it("only the spine and the emotional layer set a hero", () => {
    for (const r of TRACK_D_RECORDS) {
      if (r.id === "D1" || r.id === "D2") continue;
      const heroes = Object.values(r.home)
        .flat()
        .filter((m) => m?.emphasis === "hero")
        .map((m) => `${r.id}:${m!.id}`);
      // D4's preconception phase is its own base — there is no pregnancy week card
      // before conception — so it is allowed exactly one hero there.
      const allowed = r.id === "D4" ? ["D4:strip.glucose"] : [];
      expect(heroes).toEqual(allowed);
    }
  });
});
