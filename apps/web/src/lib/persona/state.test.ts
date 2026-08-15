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

  it("maps E to postpartum — the track that used to have no mode at all", () => {
    // This assertion previously read `expect(modeFromTrack("E")).toBe("general")`,
    // which documented the defect rather than a decision: falling into `general`
    // meant a woman weeks after giving birth was shown a next-period prediction
    // built on cycles that had not returned (R2.5).
    expect(modeFromTrack("E")).toBe("postpartum");
    expect(trackFromMode("postpartum")).toBe("E");
    expect(personaIdFromMode("postpartum")).toBe("E1");
  });

  it("maps Track A to teen — the last track that had no mode (R2.5c)", () => {
    // Before this a 13-year-old fell through to `general`: the adult cycle
    // dashboard, with adult framing, for the one audience whose specs are most
    // explicit about not being adults.
    expect(modeFromTrack("A")).toBe("teen");
    expect(trackFromMode("teen")).toBe("A");
    expect(personaIdFromMode("teen")).toBe("A2");
  });

  it("falls back to general for an unknown track, rather than throwing", () => {
    // Every track letter now has a mode, so the fallback is only for a value the
    // build has never heard of. It must still be a usable app, not a crash.
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

  it("keeps the generic hero out of teen mode without taking the window away", () => {
    // Not a restriction: A2 gets a window, from `teen.window`, wide and with its
    // reason attached. What this excludes is the adult hero and the
    // average-length card — and A1 gets no window at all, because she is not
    // cycling yet (A1 §I). The difference is per-persona, which a mode flag
    // cannot express and the registry can.
    expect(showsCyclePredictions("teen")).toBe(false);
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
    // "postpartum" and then "teen" were both in this list as modes that did not
    // exist. Both do now, which is the shape this test keeps catching.
    for (const bad of ["", "Cycle", "adolescent", null, undefined, 3, {}]) {
      expect(isPersonaMode(bad)).toBe(false);
    }
  });
});
