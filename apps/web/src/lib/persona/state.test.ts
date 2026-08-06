import { describe, expect, it } from "vitest";
import {
  PERSONA_MODES,
  flagsFromMode,
  isPersonaMode,
  modeFromTrack,
  personaIdFromMode,
  showsCyclePredictions,
  trackFromMode,
} from "./state";

describe("track <-> mode mapping", () => {
  it("round-trips every mode", () => {
    for (const mode of PERSONA_MODES) {
      expect(modeFromTrack(trackFromMode(mode))).toBe(mode);
    }
  });

  it("maps Z to general — the Z1 fallback the schema has always allowed", () => {
    expect(modeFromTrack("Z")).toBe("general");
    expect(trackFromMode("general")).toBe("Z");
    expect(personaIdFromMode("general")).toBe("Z1");
  });

  it("falls back to general for an unrecognised track rather than throwing", () => {
    // Tracks A and E exist in the taxonomy but have no app mode yet. Someone whose
    // state holds one must still get a usable app, not a crash or a blank screen.
    expect(modeFromTrack("A")).toBe("general");
    expect(modeFromTrack("E")).toBe("general");
    expect(modeFromTrack("nonsense")).toBe("general");
  });

  it("treats a missing track as cycle, preserving the pre-existing default", () => {
    expect(modeFromTrack(null)).toBe("cycle");
    expect(modeFromTrack(undefined)).toBe("cycle");
  });

  it("sets the ttc and pregnancy flags the resolver keys on", () => {
    expect(flagsFromMode("ttc")).toEqual({ ttc_intent: true });
    expect(flagsFromMode("pregnancy")).toEqual({ pregnant: true });
    expect(flagsFromMode("general")).toEqual({});
  });
});

describe("showsCyclePredictions", () => {
  it("hides predictions in pregnancy and menopause", () => {
    // A next-period date is meaningless to one and misleading to the other
    // (ADR-041/043).
    expect(showsCyclePredictions("pregnancy")).toBe(false);
    expect(showsCyclePredictions("menopause")).toBe(false);
  });

  it("shows them in general — the generic mode restricts nothing", () => {
    // Product rule 2: personalize, never restrict. General means "stop assuming
    // her stage", not "give her less".
    expect(showsCyclePredictions("general")).toBe(true);
    expect(showsCyclePredictions("cycle")).toBe(true);
    expect(showsCyclePredictions("ttc")).toBe(true);
  });
});

describe("isPersonaMode", () => {
  it("accepts every declared mode and rejects anything else", () => {
    for (const mode of PERSONA_MODES) expect(isPersonaMode(mode)).toBe(true);
    for (const bad of ["", "Cycle", "postpartum", null, undefined, 3, {}]) {
      expect(isPersonaMode(bad)).toBe(false);
    }
  });
});
