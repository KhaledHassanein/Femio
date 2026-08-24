import { describe, expect, it } from "vitest";

import {
  MIGRATABLE_SURFACES,
  migrationComplete,
  surfaceFlagKey,
  versionForSurface,
  versionsForSurfaces,
} from "./flags.ts";

describe("the default is the working screen", () => {
  it("returns v1 when nothing is known", () => {
    // Forgetting to set a flag must leave the working screen in place. The
    // migration only moves forward by someone deciding it should.
    expect(versionForSurface("home")).toBe(1);
    expect(versionForSurface("calendar", {})).toBe(1);
  });

  it("returns v1 for a surface no source mentions", () => {
    expect(versionForSurface("insights", { remote: { "experience.v2.home": true } })).toBe(1);
  });
});

describe("remote beats cached beats compiled", () => {
  it("prefers remote", () => {
    expect(
      versionForSurface("home", {
        remote: { "experience.v2.home": true },
        cached: { "experience.v2.home": false },
      }),
    ).toBe(2);
  });

  it("falls back to cached when remote is absent", () => {
    // A device with no network gets the last value it saw, not nothing.
    expect(versionForSurface("home", { cached: { "experience.v2.home": true } })).toBe(2);
  });

  it("lets remote turn a surface back off", () => {
    // The rollback path matters more than the rollout: a bad v2 screen has to be
    // reversible without a release.
    expect(
      versionForSurface("home", {
        remote: { "experience.v2.home": false },
        cached: { "experience.v2.home": true },
      }),
    ).toBe(1);
  });
});

describe("keys and surfaces", () => {
  it("names the five migratable surfaces", () => {
    expect([...MIGRATABLE_SURFACES]).toEqual(["home", "calendar", "learn", "tools", "insights"]);
  });

  it("builds the flag key a feature_flags row uses", () => {
    expect(surfaceFlagKey("calendar")).toBe("experience.v2.calendar");
  });
});

describe("surfaces migrate independently", () => {
  it("moves one without moving the others", () => {
    const versions = versionsForSurfaces({ remote: { "experience.v2.calendar": true } });
    expect(versions).toEqual({
      home: 1,
      calendar: 2,
      learn: 1,
      tools: 1,
      insights: 1,
    });
  });
});

describe("knowing when it is over", () => {
  it("is incomplete while any surface is still on v1", () => {
    expect(migrationComplete({ remote: { "experience.v2.home": true } })).toBe(false);
  });

  it("is complete when every surface reads v2", () => {
    // The point at which the v1 path can be deleted rather than carried forever —
    // the cost Flo is visibly still paying.
    const remote = Object.fromEntries(
      MIGRATABLE_SURFACES.map((s) => [surfaceFlagKey(s), true]),
    );
    expect(migrationComplete({ remote })).toBe(true);
  });
});
