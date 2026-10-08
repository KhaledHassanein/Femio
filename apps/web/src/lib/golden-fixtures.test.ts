import { describe, expect, it } from "vitest";
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";
import { predictNextPeriod } from "./cycle/predict";
import { bbtChart, type FertilityEntry } from "./fertility";
import { eddFromConception, eddFromLmp, eddFromTransfer, pregnancyProgress } from "./pregnancy";
import { phaseFor, phaseForTrack } from "./experience/phase";
import { resolvePersona } from "./persona/resolver";
import { signalsFromRows } from "./persona/signals-from-rows";
import { buildExperienceConfig, registryOf } from "./experience/build";
import { PERSONA_RECORDS } from "./experience/registry";
import type { Track } from "./persona/resolver";

/**
 * The golden fixtures (R2.4, `docs/24` §4).
 *
 * Tier 2 is the only place in the architecture where the same rule exists twice —
 * once in TypeScript and, when the Flutter client lands, once in Dart. That is the
 * one spot drift can happen, and **drift here means two clients disagreeing about a
 * woman's health**: one telling her she is 24 weeks pregnant and the other 25, or
 * one surfacing a thyroid strip the other hides.
 *
 * So the fixtures are plain JSON at the repo root rather than TypeScript. This suite
 * loads them; the Dart suite will load the **same files**. New behaviour lands as a
 * new fixture *before* it lands as code in either language, which is what stops a
 * Dart implementation quietly diverging and a TS change quietly breaking the app.
 *
 * Regenerating them by running the implementation would defeat the purpose — a
 * fixture that always matches proves nothing. They are committed, and a change to
 * one is a change a reviewer has to look at.
 */

const DIR = join(process.cwd(), "..", "..", "fixtures", "domain");

function load(name: string): { cases: Array<{ input: never; expected: unknown }> } {
  return JSON.parse(readFileSync(join(DIR, `${name}.json`), "utf8"));
}

// Every track's records, so a Track E fixture resolves the same registry the Edge
// Function does. Track D cases are unaffected: ids do not collide across tracks.
const REGISTRY = registryOf(PERSONA_RECORDS);

/** Every fixture file must be executed by a case below — an unrun fixture is a lie. */
const RUNNERS: Record<string, (input: never) => unknown> = {
  "cycle-prediction": (i: { starts: string[]; statedCycleLength?: number }) =>
    predictNextPeriod(i.starts, i.statedCycleLength),
  "bbt-chart": (i: { cycleStart: string | null; entries: Array<{ id: string; loggedAt: string; bbt: number }> }) => {
    const r4 = (n: number) => Math.round(n * 10_000) / 10_000;
    const entries: FertilityEntry[] = i.entries.map((e) => ({ ...e, opk: null, cm: null, intercourse: null }));
    const chart = bbtChart(entries, i.cycleStart);
    return chart && { ...chart, low: r4(chart.low), high: r4(chart.high), points: chart.points.map((p) => ({ ...p, y: r4(p.y) })) };
  },
  "edd-from": (i: { method: "lmp" | "conception" | "transfer3" | "transfer5"; date: string }) =>
    i.method === "lmp"
      ? eddFromLmp(i.date)
      : i.method === "conception"
        ? eddFromConception(i.date)
        : eddFromTransfer(i.date, i.method === "transfer3" ? 3 : 5),
  "gestational-age": (i: { edd: string; today: string }) => pregnancyProgress(i.edd, i.today),
  phase: (i: Parameters<typeof phaseFor>[0] & { track?: Track }) =>
    "track" in i ? phaseForTrack(i.track ?? null, i) : phaseFor(i),
  "persona-resolution": (i: Parameters<typeof resolvePersona>[0]) => resolvePersona(i),
  "signals-from-rows": (i: Parameters<typeof signalsFromRows>[0]) => signalsFromRows(i),
  "experience-config": (i: {
    personaId: string;
    track?: Track;
    phase: string;
    emotionalLayers: string[];
  }) =>
    buildExperienceConfig({
      resolution: {
        personaId: i.personaId,
        track: i.track ?? "D",
        modifiers: [],
        emotionalContext: [],
        confidence: 1,
        runnerUp: null,
      },
      phase: i.phase as never,
      registry: REGISTRY,
      resolvedAt: "2026-08-12T00:00:00.000Z",
      emotionalLayers: i.emotionalLayers,
    }),
};

describe("golden fixtures", () => {
  it("runs every fixture file on disk — an unexecuted fixture proves nothing", () => {
    const onDisk = readdirSync(DIR)
      .filter((f) => f.endsWith(".json"))
      .map((f) => f.replace(/\.json$/, ""))
      .sort();
    expect(onDisk).toEqual(Object.keys(RUNNERS).sort());
  });

  for (const [name, run] of Object.entries(RUNNERS)) {
    describe(name, () => {
      const { cases } = load(name);

      it("has cases", () => {
        expect(cases.length).toBeGreaterThan(0);
      });

      cases.forEach((testCase, index) => {
        it(`case ${index} matches the recorded answer`, () => {
          // `toEqual` rather than `toStrictEqual`: the JSON round-trip drops
          // `undefined` members, and a Dart implementation will not have them
          // either. What has to match is the *value*, not the encoding.
          expect(run(testCase.input)).toEqual(testCase.expected);
        });
      });
    });
  }
});
