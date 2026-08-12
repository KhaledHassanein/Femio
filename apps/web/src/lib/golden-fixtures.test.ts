import { describe, expect, it } from "vitest";
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";
import { predictNextPeriod } from "./cycle/predict";
import { pregnancyProgress } from "./pregnancy";
import { phaseFor } from "./experience/phase";
import { resolvePersona } from "./persona/resolver";
import { buildExperienceConfig, registryOf } from "./experience/build";
import { TRACK_D_RECORDS } from "./experience/registry/track-d";

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

const REGISTRY = registryOf(TRACK_D_RECORDS);

/** Every fixture file must be executed by a case below — an unrun fixture is a lie. */
const RUNNERS: Record<string, (input: never) => unknown> = {
  "cycle-prediction": (i: { starts: string[] }) => predictNextPeriod(i.starts),
  "gestational-age": (i: { edd: string; today: string }) => pregnancyProgress(i.edd, i.today),
  phase: (i: Parameters<typeof phaseFor>[0]) => phaseFor(i),
  "persona-resolution": (i: Parameters<typeof resolvePersona>[0]) => resolvePersona(i),
  "experience-config": (i: { personaId: string; phase: string; emotionalLayers: string[] }) =>
    buildExperienceConfig({
      resolution: {
        personaId: i.personaId,
        track: "D",
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
