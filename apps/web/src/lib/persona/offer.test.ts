import { describe, expect, it } from "vitest";
import { OFFER_THRESHOLD, PERSONA_RULES, resolvePersona, trackOfPersona } from "./resolver";
import { modeFromTrack } from "./state";
import { EMPTY_SIGNALS, type PersonaSignals } from "./signals";
import { buildExperienceConfig, registryOf } from "../experience/build";
import { PERSONA_RECORDS } from "../experience/registry";

const REGISTRY = registryOf(PERSONA_RECORDS);

/** What the client actually reads: `ExperienceConfig.offer`, not `runnerUp`. */
const offerFor = (input: PersonaSignals) => {
  const resolution = resolvePersona(input);
  return buildExperienceConfig({
    resolution,
    phase: null,
    registry: REGISTRY,
    resolvedAt: "2026-08-16T00:00:00.000Z",
  }).offer;
};

/**
 * The data contract behind the progressive-personalization offer (P1.27.5).
 *
 * The screen is one alert; what makes it safe is entirely upstream. `runnerUp` has
 * been computed since ADR-057 and rendered by nothing, so nothing has ever checked
 * that what it holds can actually be turned into a sentence a woman recognises.
 */

const signals = (over: Partial<PersonaSignals> = {}): PersonaSignals => ({
  ...EMPTY_SIGNALS,
  ...over,
});

describe("every persona the resolver can offer has a stage to name", () => {
  /**
   * The offer says "tailor Femio for **perimenopause**", not "for **F1**". She has
   * never heard of F1, and a product that told her it had classified her as one
   * would be doing something she did not ask for. That sentence only exists if
   * every rule's track maps to a mode with a label.
   */
  it("maps every rule to a track and every track to a real mode", () => {
    for (const rule of PERSONA_RULES) {
      const track = trackOfPersona(rule.id);
      expect(track, `${rule.id} has no track`).toBe(rule.track);
      const mode = modeFromTrack(track);
      // `general` would be an offer to switch to the state she is already in.
      expect(mode, `${rule.id} resolves to the generic mode`).not.toBe("general");
    }
  });

  it("returns null for an id no rule owns, rather than guessing", () => {
    expect(trackOfPersona("Z1")).toBeNull();
    expect(trackOfPersona("nonsense")).toBeNull();
  });
});

describe("what actually reaches the offer", () => {
  /**
   * The case the offer exists for: enough evidence to have a best guess, not
   * enough to commit. Z1 is a real answer here, not an error to be cleared.
   */
  it("offers the nearest stage on the thin-evidence path", () => {
    const resolution = resolvePersona(signals({ ageBand: "13_15" }));
    expect(resolution.personaId).toBe("Z1");
    const offer = offerFor(signals({ ageBand: "13_15" }));
    expect(offer).not.toBeNull();
    expect(offer!.confidence).toBeGreaterThanOrEqual(OFFER_THRESHOLD);
    expect(offer!.confidence).toBeLessThan(0.6);
    expect(modeFromTrack(trackOfPersona(offer!.personaId))).toBe("teen");
  });

  /**
   * The case that made `OFFER_THRESHOLD` exist. An account with nothing recorded
   * still scores B1 around 0.28 (0.21 before R2.8 raised B1's "no condition"
   * weight) — "no conditions" and "not trying to conceive" are both true of
   * someone who has told us nothing — and `runnerUp` carries it,
   * correctly, as "who we would have picked". Putting that in front of her would
   * be guessing dressed as personalization, so `offer` is where the floor is.
   */
  it("offers nothing when it knows nothing, even though a runner-up exists", () => {
    const resolution = resolvePersona(EMPTY_SIGNALS);
    expect(resolution.personaId).toBe("Z1");
    expect(resolution.runnerUp).not.toBeNull();
    expect(resolution.runnerUp!.confidence).toBeLessThan(OFFER_THRESHOLD);
    expect(offerFor(EMPTY_SIGNALS)).toBeNull();
  });

  /**
   * A confident resolution is not an offer. She is already in that experience —
   * the alert renders only from the generic state, which the component checks as
   * `config.track === "Z"`, and this is the resolver half of the same rule.
   */
  it("does not reach Z1 when the evidence is strong", () => {
    const resolution = resolvePersona(
      signals({
        pregnancyStatus: "active",
        conditions: ["thyroid"],
        ageBand: "25_34",
        cycleRegularity: "regular",
        symptomCounts: { nausea: 3 },
      }),
    );
    expect(resolution.track).toBe("D");
    expect(resolution.personaId).not.toBe("Z1");
  });
});

/**
 * The stage-scoped follow-up (P1.27.8).
 *
 * C2 and C3 are the same persona with two different clocks, and the clock is the
 * age band: twelve months under 35, six months at 35 and over, because that is
 * where the published evaluation windows sit. Getting it wrong in the lenient
 * direction costs a woman half a year of the one thing she cannot get back, which
 * is why both the duration and the band are gates rather than weights.
 */
describe("TTC duration reaches the resolver", () => {
  const trying = (months: number | null, ageBand: PersonaSignals["ageBand"]) =>
    resolvePersona(
      signals({ ttcIntent: true, ttcMonths: months, ageBand, cycleRegularity: "regular" }),
    );

  it("stays C1 before the threshold", () => {
    expect(trying(6, "25_34").personaId).toBe("C1");
  });

  it("reaches C2 at twelve months under 35", () => {
    expect(trying(12, "25_34").personaId).toBe("C2");
  });

  it("reaches C3 at six months from 35", () => {
    // The shorter clock is the whole reason C3 is a separate persona.
    expect(trying(6, "35_44").personaId).toBe("C3");
    // And the same six months under 35 is still C1.
    expect(trying(6, "25_34").personaId).toBe("C1");
  });

  /**
   * She skipped the question. Treating that as "started today" would quietly hold
   * a woman of two years at C1 — but so would treating it as any other number, so
   * the honest answer is that the gate simply does not fire.
   */
  it("does not promote her when she did not answer", () => {
    expect(trying(null, "35_44").personaId).toBe("C1");
  });
});
