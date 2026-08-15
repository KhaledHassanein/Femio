import { describe, expect, it } from "vitest";
import { signalsFromRows, type SignalRows } from "../persona/signals-from-rows";
import { resolveForStatedTrack, resolvePersona } from "../persona/resolver";
import { CONDITIONS_BY_MODE } from "../persona/conditions";
import { buildExperienceConfig, registryOf } from "./build";
import { emotionalLayersFor } from "./layers";
import { phaseForTrack } from "./phase";
import { PERSONA_RECORDS } from "./registry";
import { IMPLEMENTED, UNIMPLEMENTED } from "@/components/experience/module-registry";
import type { ModuleId } from "./types";

/**
 * Track A, end to end (R2.5c).
 *
 * Written the way `track-e-reachability.test.ts` had to be written after the fact:
 * Track E shipped a mode whose pipeline could not actually resolve, and nobody
 * noticed because the screen composed its own answer. This suite asks the same
 * question of Track A *before* shipping it — can rows, resolution, phase and build
 * produce an adolescent document at all? — and then asks the two questions the
 * specs care about more than any structural one:
 *
 * 1. **Does A1 avoid predicting a period she has not had?** (A1 §I)
 * 2. **Is anything hidden from her?** (A2 §A — teen mode governs data, ads and
 *    social exposure, never knowledge.)
 */

const REGISTRY = registryOf(PERSONA_RECORDS);
const TODAY = "2026-08-16";

const rows = (over: Partial<SignalRows> = {}): SignalRows => ({
  ageBand: "13_15",
  periodStarts: [],
  conditions: [],
  pregnancy: null,
  symptomTypes: [],
  ttcIntent: false,
  todayISO: TODAY,
  ...over,
});

/** Four cycles, ~28 days apart — enough for a prediction to exist. */
const LOGGED_PERIODS = ["2026-05-10", "2026-06-07", "2026-07-05", "2026-08-02"];

function documentFor(input: SignalRows) {
  const signals = signalsFromRows(input);
  const resolution = resolveForStatedTrack(signals, "A");
  return buildExperienceConfig({
    resolution,
    // Track A has no phase, and `phaseForTrack` must not invent one.
    phase: phaseForTrack("A", { edd: null, status: null, todayISO: TODAY }),
    registry: REGISTRY,
    resolvedAt: "2026-08-16T00:00:00.000Z",
    emotionalLayers: emotionalLayersFor(resolution.track, resolution.emotionalContext),
  });
}

const idsOf = (config: ReturnType<typeof documentFor>) => config.home.modules.map((m) => m.id);

describe("Track A reachability", () => {
  it("has no phase, and the engine still gives her a screen", () => {
    // The `default` bucket (types.ts) is what makes this work. Before it, a
    // phase-less track resolved correctly and contributed zero modules — the
    // engine looking right while her dashboard was empty.
    const config = documentFor(rows({ periodStarts: LOGGED_PERIODS }));
    expect(config.phase).toBeNull();
    expect(config.home.modules.length).toBeGreaterThan(0);
  });

  it("resolves A2 once she has logged a period", () => {
    const signals = signalsFromRows(rows({ periodStarts: LOGGED_PERIODS }));
    /**
     * On the evidence alone this is Z1 *with A2 as the offer*, and that is correct:
     * an age band and four steady cycles is thin, and A2's defining trait —
     * irregularity — is absent, so the confidence machinery declines to commit.
     * She told us she is a teenager, so `resolveForStatedTrack` takes the offer,
     * which is the path the app actually runs.
     */
    expect(resolvePersona(signals).runnerUp?.personaId).toBe("A2");
    expect(resolveForStatedTrack(signals, "A").personaId).toBe("A2");
    expect(documentFor(rows({ periodStarts: LOGGED_PERIODS })).personaId).toBe("A2");
  });

  it("no longer hands a thirteen-year-old the adult cycle tracker", () => {
    // B1 outscored A2 for a teen with steady cycles until R2.5c gated it — the
    // "17+ gap" A2 §C names as the category's recurring failure, reproduced.
    const teen = signalsFromRows(rows({ periodStarts: LOGGED_PERIODS }));
    expect(resolvePersona(teen).runnerUp?.personaId).not.toBe("B1");
    // An adult with the identical cycle history still gets B1: the gate is the age
    // band, not the cycles.
    const adult = signalsFromRows(rows({ ageBand: "25_34", periodStarts: LOGGED_PERIODS }));
    expect(resolvePersona(adult).personaId).toBe("B1");
  });

  it("resolves A1 before the first period, and offers her no window", () => {
    const config = documentFor(rows());
    expect(config.personaId).toBe("A1");
    // A1 §I: "No cycle predictions shown (she isn't cycling) — deliberately hidden
    // until A2." The absence is data, not a branch in a screen.
    expect(idsOf(config)).not.toContain("teen.window");
    expect(config.tools).not.toContain("period");
  });

  it("gives A2 the window, and A2 keeps everything A1 had", () => {
    const a1 = idsOf(documentFor(rows()));
    const a2 = idsOf(documentFor(rows({ periodStarts: LOGGED_PERIODS })));
    expect(a2).toContain("teen.window");
    // A2 extends A1, and layers add rather than replace: nothing A1 contributed
    // may disappear when the layer merges on top.
    for (const id of a1) expect(a2).toContain(id);
  });

  it("leads with the window and keeps exactly one raised element", () => {
    const config = documentFor(rows({ periodStarts: LOGGED_PERIODS }));
    const heroes = config.home.modules.filter((m) => m.emphasis === "hero");
    expect(heroes).toHaveLength(1);
    expect(heroes[0]!.id).toBe("teen.window");
  });

  /**
   * The safety decision this track turns on. A2 §G forbids alarms and §D forbids
   * suggesting PCOS from adolescent irregularity — so the "worth mentioning" note
   * is its own module and its own `education` alert, and must never become the
   * red-flag surface by reusing that module id or that alert kind.
   */
  it("never renders her concerns as a danger panel", () => {
    const config = documentFor(rows({ periodStarts: LOGGED_PERIODS }));
    expect(idsOf(config)).toContain("teen.worthMentioning");
    expect(idsOf(config)).not.toContain("pregnancy.warningSigns");
    expect(config.alerts.every((a) => a.kind !== "redFlag")).toBe(true);
  });

  it("never surfaces fertility framing to a minor", () => {
    // A2 §K forbids fertile-window and "safe day" framing outright. The registry
    // carries no such tool, so the module registry has nothing to render.
    for (const input of [rows(), rows({ periodStarts: LOGGED_PERIODS })]) {
      const config = documentFor(input);
      expect(config.tools).not.toContain("labs");
      expect(config.home.quickLog).not.toContain("glucose");
      expect(idsOf(config).some((id) => id.startsWith("pregnancy."))).toBe(false);
    }
  });

  /**
   * Product rule 2, checked structurally rather than remembered. The contract has
   * no field that can express restriction (`types.ts`), so the only way teen mode
   * could restrict is by a screen inventing one — and this is the assertion that
   * would catch a `tools` list being used as a permission list.
   */
  it("restricts nothing — every teen surface is emphasis, never access", () => {
    const config = documentFor(rows({ periodStarts: LOGGED_PERIODS }));
    for (const forbidden of ["hidden", "blocked", "disabled", "locked", "available"]) {
      expect(Object.hasOwn(config, forbidden)).toBe(false);
      for (const spec of config.home.modules) {
        expect(Object.hasOwn(spec.params ?? {}, forbidden)).toBe(false);
      }
    }
    expect(idsOf(config)).toContain("library");
  });

  it("asks a teenager about her conditions without putting PCOS in front of her", () => {
    // A2 §D: PCOS should generally not be diagnosed within 2–3 years of menarche,
    // because irregular cycles are developmentally normal that early. Offering the
    // word as a checkbox is how an app plants a label a clinician would not.
    expect(CONDITIONS_BY_MODE.teen).not.toContain("pcos");
    expect(CONDITIONS_BY_MODE.teen.length).toBeGreaterThan(0);
  });

  it("has a component for every teen module it can emit, or names it as missing", () => {
    const emitted = new Set<ModuleId>([
      ...idsOf(documentFor(rows())),
      ...idsOf(documentFor(rows({ periodStarts: LOGGED_PERIODS }))),
    ]);
    const known = new Set<ModuleId>([...IMPLEMENTED, ...UNIMPLEMENTED]);
    for (const id of emitted) expect(known.has(id)).toBe(true);
  });
});
