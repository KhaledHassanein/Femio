import { describe, expect, it } from "vitest";

import type { ExperienceConfigV2, ModuleSpecV2 } from "./types.ts";
import {
  SEED_VARIABLES,
  isSeedVariable,
  modulesAffectedBy,
  setVariable,
  validateWiring,
} from "./variables.ts";

/** A module with the required envelope and nothing else, so tests read as data. */
function mod(id: string, extra: Partial<ModuleSpecV2> = {}): ModuleSpecV2 {
  return {
    id: id as ModuleSpecV2["id"],
    emphasis: "secondary",
    a11y: { labelKey: `modules.${id}.label` },
    ...extra,
  };
}

function config(modules: readonly ModuleSpecV2[], variables = {}): ExperienceConfigV2 {
  return {
    version: 2,
    resolvedAt: "2026-08-23T00:00:00.000Z",
    resolverVersion: "test",
    track: "B",
    personaId: "B1",
    modifiers: [],
    emotionalContext: [],
    confidence: 1,
    offer: null,
    transition: null,
    phase: null,
    content: { tone: "neutral" } as ExperienceConfigV2["content"],
    alerts: [],
    emrView: [],
    tone: {} as ExperienceConfigV2["tone"],
    surfaces: {
      home: { modules, quickLog: [] },
      calendar: { modules: [] },
      learn: { collections: [] },
      tools: { featured: [] },
      insights: { modules: [] },
    },
    variables,
  };
}

describe("seeded variables are read-only", () => {
  it("names the four tier-1 seeds", () => {
    expect([...SEED_VARIABLES]).toEqual([
      "cycleDay",
      "phase",
      "daysToPrediction",
      "confidenceBand",
    ]);
    expect(isSeedVariable("cycleDay")).toBe(true);
    expect(isSeedVariable("somethingElse")).toBe(false);
  });

  it("rejects a document whose module writes one", () => {
    // A renderer that can write `cycleDay` can contradict a medical decision, and
    // it would do so invisibly because the screen still looks right.
    const problems = validateWiring(config([mod("cycle.window", { writes: "cycleDay" })]));
    expect(problems).toContainEqual({
      kind: "writes-seed",
      moduleId: "cycle.window",
      variable: "cycleDay",
    });
  });

  it("refuses the write at runtime too, not only at validation", () => {
    // The cached document in client.ts outlives the resolver that made it, so a
    // document can reach a client without ever being validated.
    const scope = setVariable({ cycleDay: 15 }, "cycleDay", 99);
    expect(scope.cycleDay).toBe(15);
  });

  it("allows a module to write a variable of its own", () => {
    expect(setVariable({}, "logSheetOpen", true)).toEqual({ logSheetOpen: true });
  });
});

describe("every reference resolves", () => {
  it("accepts reacting to a seed", () => {
    expect(validateWiring(config([mod("cycle.phase", { reactsTo: ["cycleDay"] })]))).toEqual([]);
  });

  it("accepts reacting to something another module writes", () => {
    const problems = validateWiring(
      config([
        mod("cycle.flowStrip", { writes: "selectedDay" }),
        mod("cycle.window", { reactsTo: ["selectedDay"] }),
      ]),
    );
    expect(problems).toEqual([]);
  });

  it("rejects reacting to a variable nothing declares", () => {
    // Dead wiring renders once and never updates. No test notices, because the
    // screen is not wrong — only frozen.
    const problems = validateWiring(config([mod("cycle.window", { reactsTo: ["ghost"] })]));
    expect(problems).toContainEqual({
      kind: "reacts-to-unknown",
      moduleId: "cycle.window",
      variable: "ghost",
    });
  });

  it("looks across surfaces, not just home", () => {
    const c = config([]);
    const withCalendar: ExperienceConfigV2 = {
      ...c,
      surfaces: { ...c.surfaces, calendar: { modules: [mod("cycle.phase", { reactsTo: ["ghost"] })] } },
    };
    expect(validateWiring(withCalendar)).toHaveLength(1);
  });
});

describe("one writer per variable", () => {
  it("rejects two modules writing the same name", () => {
    // Which wins depends on render order, which is to say on nothing anyone chose.
    const problems = validateWiring(
      config([
        mod("cycle.window", { writes: "selectedDay" }),
        mod("cycle.phase", { writes: "selectedDay" }),
      ]),
    );
    expect(problems).toContainEqual({
      kind: "written-twice",
      variable: "selectedDay",
      moduleIds: ["cycle.window", "cycle.phase"],
    });
  });
});

describe("no reactive cycles", () => {
  it("detects a two-module loop", () => {
    const problems = validateWiring(
      config([
        mod("cycle.window", { writes: "a", reactsTo: ["b"] }),
        mod("cycle.phase", { writes: "b", reactsTo: ["a"] }),
      ]),
    );
    const cycle = problems.find((p) => p.kind === "cycle");
    expect(cycle).toBeDefined();
    expect(cycle?.kind === "cycle" && cycle.moduleIds.length).toBeGreaterThan(1);
  });

  it("does not flag a module reacting to what it writes itself", () => {
    // Self-reference is a no-op, not a loop: nothing else re-renders.
    const problems = validateWiring(
      config([mod("cycle.window", { writes: "a", reactsTo: ["a"] })]),
    );
    expect(problems.filter((p) => p.kind === "cycle")).toEqual([]);
  });

  it("does not flag a chain", () => {
    const problems = validateWiring(
      config([
        mod("cycle.window", { writes: "a" }),
        mod("cycle.phase", { writes: "b", reactsTo: ["a"] }),
        mod("cycle.variability", { reactsTo: ["b"] }),
      ]),
    );
    expect(problems).toEqual([]);
  });
});

describe("reactivity is opted into", () => {
  it("re-renders only modules that declared the variable", () => {
    const modules = [
      mod("cycle.window", { reactsTo: ["selectedDay"] }),
      mod("cycle.phase", { reactsTo: ["cycleDay"] }),
      mod("cycle.variability"),
    ];
    expect(modulesAffectedBy(modules, ["selectedDay"])).toEqual(["cycle.window"]);
  });

  it("leaves a module with no reactsTo static", () => {
    // The default is static. A served document must not be able to make the whole
    // screen thrash, which is what a store-driven UI does by default.
    expect(modulesAffectedBy([mod("cycle.variability")], ["cycleDay", "phase"])).toEqual([]);
  });
});
