import { describe, expect, it } from "vitest";
import { versionForSurface, versionsForSurfaces, surfaceFlagKey } from "./flags";

/**
 * The hook itself needs a DOM and a Supabase client, neither of which this suite
 * has. What is worth pinning is the *decision* it supplies to — the order in
 * which sources are trusted — because that is what decides which contract a
 * woman's dashboard renders, and it is pure.
 */
describe("surface version resolution (RB-C4)", () => {
  const key = surfaceFlagKey("home");

  it("defaults to v1 when nothing is known", () => {
    // A device that has never completed a fetch renders the contract that has been
    // in production longest, not the newest one.
    expect(versionForSurface("home")).toBe(1);
    expect(versionForSurface("home", {})).toBe(1);
  });

  it("prefers remote over cache when both disagree", () => {
    expect(versionForSurface("home", { remote: { [key]: false }, cached: { [key]: true } })).toBe(1);
    expect(versionForSurface("home", { remote: { [key]: true }, cached: { [key]: false } })).toBe(2);
  });

  it("falls back to cache when remote is unreachable", () => {
    // Without this, every cold start on a bad connection would silently roll a
    // migrated surface back to v1 — worse than whatever the flag was flipped for.
    expect(versionForSurface("home", { cached: { [key]: true } })).toBe(2);
  });

  it("keeps surfaces independent", () => {
    const sources = { remote: { [surfaceFlagKey("home")]: true } };
    const all = versionsForSurfaces(sources);
    expect(all.home).toBe(2);
    expect(all.calendar).toBe(1);
    expect(all.tools).toBe(1);
  });

  it("treats an unrelated flag as no answer at all", () => {
    expect(versionForSurface("home", { remote: { "something.else": true } })).toBe(1);
  });
});
