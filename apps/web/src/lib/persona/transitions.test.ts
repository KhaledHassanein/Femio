import { describe, expect, it } from "vitest";
import { suggestTransition } from "./transitions";
import { EMPTY_SIGNALS, type PersonaSignals } from "./signals";

const signals = (over: Partial<PersonaSignals> = {}): PersonaSignals => ({
  ...EMPTY_SIGNALS,
  ...over,
});

describe("the universal transitions", () => {
  it("offers pregnancy when a positive test lands in TTC mode", () => {
    // `docs/09` §6: the positive-test handler suppresses the fertile-window hero,
    // and it cannot do that while she is still filed under Track C.
    const t = suggestTransition(signals({ pregnancyStatus: "active", ttcIntent: true }), "C");
    expect(t?.id).toBe("positiveTest");
    expect(t?.to).toBe("D");
    expect(t?.personaId).toBe("D1");
  });

  it("says nothing to someone already in the destination", () => {
    // A suggestion to move where she already is reads as the product not knowing
    // her, which is worse than silence.
    expect(suggestTransition(signals({ pregnancyStatus: "active" }), "D")).toBeNull();
  });

  it("offers postpartum when a pregnancy ends, and only from pregnancy", () => {
    const fromPregnancy = suggestTransition(signals({ pregnancyStatus: "ended" }), "D");
    expect(fromPregnancy?.id).toBe("pregnancyEnded");
    expect(fromPregnancy?.to).toBe("E");
  });

  /**
   * The rule that matters most in this file. "Her pregnancy ended" is only news if
   * Femio currently thinks she is pregnant. For a woman tracking her cycle two
   * years later it is an old fact in her record, and offering to move her to
   * postpartum would be the app raising a loss unprompted, months on, possibly in
   * front of someone.
   */
  it("never raises an old ending from another track", () => {
    for (const track of ["B", "C", "F", "Z"] as const) {
      expect(suggestTransition(signals({ pregnancyStatus: "ended" }), track)).toBeNull();
    }
  });

  it("moves her on when postpartum has stopped describing her", () => {
    const t = suggestTransition(signals({ pregnancyStatus: "ended", weeksSincePregnancyEnd: 40 }), "E");
    expect(t?.id).toBe("postpartumPassed");
    expect(t?.to).toBe("B");
  });

  it("keeps her in postpartum inside the window", () => {
    expect(
      suggestTransition(signals({ pregnancyStatus: "ended", weeksSincePregnancyEnd: 8 }), "E"),
    ).toBeNull();
    // And with no weeks recorded at all, it stays quiet rather than guessing.
    expect(suggestTransition(signals({ pregnancyStatus: "ended" }), "E")).toBeNull();
  });

  it("suggests nothing from an empty record", () => {
    for (const track of ["A", "B", "C", "D", "E", "F", "Z", null] as const) {
      expect(suggestTransition(EMPTY_SIGNALS, track)).toBeNull();
    }
  });

  /**
   * Pregnancy is evaluated first, and deliberately. An active pregnancy is the most
   * consequential thing Femio can be wrong about, so it wins over any other rule
   * that might also match.
   */
  it("puts an active pregnancy ahead of everything else", () => {
    const t = suggestTransition(
      signals({ pregnancyStatus: "active", weeksSincePregnancyEnd: 40 }),
      "E",
    );
    expect(t?.id).toBe("positiveTest");
  });

  it("returns a suggestion and nothing that could apply itself", () => {
    const t = suggestTransition(signals({ pregnancyStatus: "active" }), "C")!;
    for (const forbidden of ["apply", "force", "auto", "confirmed"]) {
      expect(Object.hasOwn(t, forbidden)).toBe(false);
    }
    expect(Object.keys(t).sort()).toEqual(["id", "personaId", "to"]);
  });
});
