import { describe, expect, it } from "vitest";

import { groundImage, phaseToken, withoutModulesPrefix } from "./ground.ts";

describe("phase is the ground, not a badge", () => {
  it("maps the four cycle phases to their existing tokens", () => {
    // Reading the same token the phase strip reads is what stops the ground and the
    // strip disagreeing about which phase she is in.
    expect(phaseToken("menstrual")).toBe("--phase-menstrual");
    expect(phaseToken("follicular")).toBe("--phase-follicular");
    expect(phaseToken("ovulatory")).toBe("--phase-ovulatory");
    expect(phaseToken("luteal")).toBe("--phase-luteal");
  });

  it("returns null when tier 1 will not name a phase", () => {
    // The common case, and a correct one. A woman whose cycles are too irregular to
    // place gets neutral ground — not a guess and not an apology.
    expect(phaseToken(null)).toBeNull();
    expect(groundImage(null)).toBeNull();
  });

  it("degrades to plain for a phase name it does not know", () => {
    // Tier 1 can add a phase after this build shipped. Unknown must mean plain, not
    // a broken gradient.
    expect(phaseToken("lutealish")).toBeNull();
    expect(groundImage("lutealish")).toBeNull();
  });

  it("survives a non-string variable", () => {
    // `variables.phase` is a VariableValue: it can legitimately be a number or a
    // boolean if a document is wrong, and a wrong document must not throw.
    expect(phaseToken(15)).toBeNull();
    expect(phaseToken(true)).toBeNull();
    expect(phaseToken(undefined)).toBeNull();
  });

  it("builds a soft radial from the token, never a literal colour", () => {
    const image = groundImage("luteal");
    expect(image).toContain("var(--phase-luteal)");
    expect(image).toContain("radial-gradient");
    // Scenery, not a theme change: text contrast is measured against --bg, which
    // stays underneath.
    expect(image).toContain("14%");
    expect(image).not.toMatch(/#[0-9a-f]{3,8}/i);
  });
});

describe("the label key crosses the namespace boundary once", () => {
  it("strips the prefix a served document carries", () => {
    expect(withoutModulesPrefix("modules.cycle.window.label")).toBe("cycle.window.label");
  });

  it("leaves a key that is already relative alone", () => {
    expect(withoutModulesPrefix("cycle.window.label")).toBe("cycle.window.label");
  });

  it("does not strip a key that merely starts with the same letters", () => {
    expect(withoutModulesPrefix("modulesomething.label")).toBe("modulesomething.label");
  });
});
