/**
 * The v1 → v2 derivation, asserted over the **golden fixtures** rather than over
 * synthetic documents.
 *
 * Those nine cases are the ones the Dart twin will also load, so checking the
 * derivation against them means the mapping is pinned by the same inputs that pin
 * the resolver. It also means a v1 change that would break v2 fails here rather
 * than after a flag flip.
 *
 * Deliberately no `experience-config-v2.json`. The fixture file's own rule is that
 * regenerating a fixture by running the implementation proves nothing — and a v2
 * fixture would be exactly that, since the derivation is mechanical. Properties over
 * every golden case are stronger than one hand-written expectation.
 */
import { readFileSync } from "node:fs";
import { join } from "node:path";
import { describe, expect, it } from "vitest";

import type { ExperienceConfig } from "../types.ts";
import { RESOLVER_VERSION, moduleLabelKey, toV2, toV2Checked } from "./upgrade.ts";

const fixture = JSON.parse(
  readFileSync(join(process.cwd(), "..", "..", "fixtures", "domain", "experience-config.json"), "utf8"),
) as { cases: Array<{ expected: ExperienceConfig }> };

const V1_CASES = fixture.cases.map((c) => c.expected);

describe("the golden cases load", () => {
  it("has the nine documents the resolver is pinned against", () => {
    expect(V1_CASES).toHaveLength(9);
    expect(V1_CASES.every((c) => typeof c.personaId === "string")).toBe(true);
  });
});

describe("v1 is not touched", () => {
  it("does not mutate the document it was given", () => {
    for (const v1 of V1_CASES) {
      const before = JSON.stringify(v1);
      toV2(v1);
      expect(JSON.stringify(v1)).toBe(before);
    }
  });
});

describe("every module survives the crossing", () => {
  it("keeps id, emphasis, params and order", () => {
    for (const v1 of V1_CASES) {
      const v2 = toV2(v1);
      expect(v2.surfaces.home.modules.map((m) => m.id)).toEqual(v1.home.modules.map((m) => m.id));
      v1.home.modules.forEach((m, i) => {
        const upgraded = v2.surfaces.home.modules[i];
        expect(upgraded?.emphasis).toBe(m.emphasis);
        expect(upgraded?.params).toEqual(m.params);
      });
    }
  });

  it("gives every module an accessible name", () => {
    for (const v1 of V1_CASES) {
      for (const m of toV2(v1).surfaces.home.modules) {
        expect(m.a11y.labelKey).toBe(moduleLabelKey(m.id));
      }
    }
  });

  it("keeps quickLog as it was", () => {
    for (const v1 of V1_CASES) {
      expect(toV2(v1).surfaces.home.quickLog).toEqual(v1.home.quickLog);
    }
  });
});

describe("the document's non-surface half is carried through unchanged", () => {
  it("copies persona, tone, alerts and content verbatim", () => {
    for (const v1 of V1_CASES) {
      const v2 = toV2(v1);
      expect(v2.track).toBe(v1.track);
      expect(v2.personaId).toBe(v1.personaId);
      expect(v2.modifiers).toEqual(v1.modifiers);
      expect(v2.emotionalContext).toEqual(v1.emotionalContext);
      expect(v2.confidence).toBe(v1.confidence);
      expect(v2.offer).toEqual(v1.offer);
      expect(v2.transition).toEqual(v1.transition);
      expect(v2.phase).toBe(v1.phase);
      expect(v2.content).toEqual(v1.content);
      expect(v2.alerts).toEqual(v1.alerts);
      expect(v2.emrView).toEqual(v1.emrView);
      expect(v2.tone).toEqual(v1.tone);
      expect(v2.resolvedAt).toBe(v1.resolvedAt);
    }
  });

  it("stamps the resolver version so a document is attributable", () => {
    expect(toV2(V1_CASES[0]!).resolverVersion).toBe(RESOLVER_VERSION);
  });
});

describe("the new surfaces are empty, and empty has a meaning", () => {
  it("leaves calendar, learn, tools and insights unfilled", () => {
    // Empty is "the screen's own default", not "nothing". v1 cannot express any of
    // these — that absence is the gap OD-10 named, and a derivation cannot invent
    // what the persona registry has not been asked for yet.
    for (const v1 of V1_CASES) {
      const { calendar, learn, tools, insights } = toV2(v1).surfaces;
      expect(calendar.modules).toEqual([]);
      expect(learn.collections).toEqual([]);
      expect(tools.featured).toEqual([]);
      expect(insights.modules).toEqual([]);
    }
  });
});

describe("variables", () => {
  it("declares all four seeds even when none is known", () => {
    // Null rather than absent: a module reacting to `cycleDay` before she has logged
    // a cycle must not make the document invalid, and validateWiring treats an
    // absent name as dead wiring.
    expect(toV2(V1_CASES[0]!).variables).toEqual({
      cycleDay: null,
      phase: null,
      daysToPrediction: null,
      confidenceBand: null,
    });
  });

  it("takes the seeds it is given", () => {
    const v2 = toV2(V1_CASES[0]!, { seed: { cycleDay: 15, confidenceBand: "medium" } });
    expect(v2.variables.cycleDay).toBe(15);
    expect(v2.variables.confidenceBand).toBe("medium");
    expect(v2.variables.daysToPrediction).toBeNull();
  });

  it("drops a name that is not a seed", () => {
    // A "seed" a module could also write is not a seed. Tier 1 owns these four.
    const v2 = toV2(V1_CASES[0]!, { seed: { selectedDay: "2026-08-23" } as never });
    expect(Object.keys(v2.variables).sort()).toEqual(
      ["confidenceBand", "cycleDay", "daysToPrediction", "phase"].sort(),
    );
  });
});

describe("a derived document is always well-wired", () => {
  it("has no wiring problems for any golden case", () => {
    // Nothing here sets reactsTo or writes, so a problem means the mapping has a
    // bug — which is why the resolver logs and still serves v1 rather than failing.
    for (const v1 of V1_CASES) {
      expect(toV2Checked(v1).problems).toEqual([]);
    }
  });
});
