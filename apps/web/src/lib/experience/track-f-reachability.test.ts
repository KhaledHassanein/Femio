import { describe, expect, it } from "vitest";
import { signalsFromRows, type SignalRows } from "../persona/signals-from-rows";
import { resolveForStatedTrack, resolvePersona } from "../persona/resolver";
import { buildExperienceConfig, registryOf } from "./build";
import { emotionalLayersFor } from "./layers";
import { phaseForTrack } from "./phase";
import { PERSONA_RECORDS } from "./registry";
import { ARTICLE_FOR_TOPIC, NO_ARTICLE_YET } from "./reading";
import { IMPLEMENTED, UNIMPLEMENTED } from "@/components/experience/module-registry";
import type { ModuleId } from "./types";

/**
 * Track F, end to end (R2.9).
 *
 * The brief for this track is one sentence (`docs/25` §3.5): it **reports a count
 * and refuses a conclusion**. So alongside the structural questions the other
 * reachability suites ask, this one asks three that are specific to it:
 *
 * 1. Does a skipped cycle still resolve to perimenopause? It did not — `"absent"`
 *    is what `signals-from-rows` returns after ninety days, and F1 only counted
 *    `"irregular"`.
 * 2. Does she stay in F2 after logging a bleed? She did not, which meant losing
 *    the persona whose whole job is that bleed.
 * 3. Is there any countdown, milestone or conclusion anywhere in the document?
 */

const REGISTRY = registryOf(PERSONA_RECORDS);
const TODAY = "2026-08-17";

const rows = (over: Partial<SignalRows> = {}): SignalRows => ({
  ageBand: "45_54",
  periodStarts: [],
  conditions: [],
  pregnancy: null,
  symptomTypes: [],
  ttcIntent: false,
  ttcMonths: null,
  statedWeeksSinceBirth: null,
  todayISO: TODAY,
  ...over,
});

/** Lengthening and scattering — the pattern F1 §I describes. Last bleed 41 days ago. */
const TRANSITION = ["2026-01-04", "2026-02-04", "2026-03-17", "2026-05-28", "2026-07-07"];
/** Four months past her last period: late transition, and `regularity` reads "absent". */
const SKIPPING = ["2025-11-02", "2025-12-20", "2026-04-08"];
/** Nothing for well over a year. */
const STOPPED = ["2024-11-02", "2025-01-04", "2025-03-14"];
/** The same record, plus a bleed logged after the twelve-month gap. */
const STOPPED_THEN_BLED = [...STOPPED, "2026-08-10"];

const HOT_FLUSHES = ["hotFlushes", "hotFlushes", "hotFlushes", "troubleSleeping", "troubleSleeping"];

function documentFor(input: SignalRows) {
  const signals = signalsFromRows(input);
  const resolution = resolveForStatedTrack(signals, "F");
  return buildExperienceConfig({
    resolution,
    // Track F has no phase, and `phaseForTrack` must not invent one.
    phase: phaseForTrack("F", { edd: null, status: null, todayISO: TODAY }),
    registry: REGISTRY,
    resolvedAt: "2026-08-17T00:00:00.000Z",
    emotionalLayers: emotionalLayersFor(resolution.track, resolution.emotionalContext),
  });
}

const idsOf = (config: ReturnType<typeof documentFor>) => config.home.modules.map((m) => m.id);

describe("Track F reachability", () => {
  it("has no phase, and the engine still gives her a screen", () => {
    const config = documentFor(rows({ periodStarts: TRANSITION, symptomTypes: HOT_FLUSHES }));
    expect(config.phase).toBeNull();
    expect(config.home.modules.length).toBeGreaterThan(0);
  });

  it("resolves F1 for a woman whose cycles are lengthening", () => {
    const signals = signalsFromRows(rows({ periodStarts: TRANSITION, symptomTypes: HOT_FLUSHES }));
    expect(resolvePersona(signals).personaId).toBe("F1");
  });

  /**
   * The first defect. `signals-from-rows` calls a record `"absent"` once ninety
   * days have passed, and F1's largest signal only counted `"irregular"` — so a
   * 47-year-old four months past her last period, which is the most characteristic
   * pattern in the persona, scored *lower* on it than one with a 40-day cycle.
   * §I asks for the opposite: skipping and long gaps are late-transition emphasis.
   */
  it("still resolves F1 when she has skipped a cycle entirely", () => {
    const signals = signalsFromRows(rows({ periodStarts: SKIPPING, symptomTypes: HOT_FLUSHES }));
    expect(signals.cycleRegularity).toBe("absent");
    expect(resolvePersona(signals).personaId).toBe("F1");
  });

  /**
   * And the reason that fix needed B5 to move as well: with the skipped cycle
   * counting for F1, B5 was still scoring a perfect 1.0 on the same record and
   * winning on rule order. A woman in the middle of the transition would have been
   * handed the irregular-cycle experience with none of the perimenopause content.
   */
  it("does not hand a woman in her late forties the irregular-cycle persona", () => {
    const signals = signalsFromRows(rows({ periodStarts: SKIPPING, symptomTypes: HOT_FLUSHES }));
    const resolved = resolvePersona(signals);
    expect(resolved.personaId).not.toBe("B5");
    // A 28-year-old with the identical record still gets B5: the signal is the age
    // band, not the cycles.
    const younger = signalsFromRows(
      rows({ ageBand: "25_34", periodStarts: SKIPPING, symptomTypes: HOT_FLUSHES }),
    );
    expect(resolvePersona(younger).personaId).toBe("B5");
  });

  it("resolves F2 once a year has passed, and drops the cycle view entirely", () => {
    const config = documentFor(rows({ periodStarts: STOPPED, symptomTypes: HOT_FLUSHES }));
    expect(config.personaId).toBe("F2");
    // §I: no cycle view, no prediction, no "late" anything. F2 is a sibling of F1
    // rather than a layer on it, because `build.ts` cannot subtract a module.
    expect(idsOf(config)).not.toContain("menopause.trend");
    expect(idsOf(config)).toContain("menopause.since");
  });

  /**
   * The second defect, and the more serious one. F2's gate was the days-since
   * counter alone, so the moment she logged bleeding after twelve months — the one
   * thing F2 §G calls "the main warning sign clinicians look for" — the counter
   * reset, the gate failed, and she resolved to B5. She lost the persona whose
   * entire job is that bleed, by doing the thing it asked her to do.
   */
  it("keeps her in F2 after she logs a bleed, and keeps the red flag with her", () => {
    const signals = signalsFromRows(rows({ periodStarts: STOPPED_THEN_BLED }));
    expect(signals.postmenopausalBleed).toBe(true);
    expect(signals.daysSinceLastPeriod).toBeLessThan(365);
    expect(resolvePersona(signals).personaId).toBe("F2");

    const config = documentFor(rows({ periodStarts: STOPPED_THEN_BLED }));
    expect(idsOf(config)).toContain("menopause.pmb");
    expect(config.alerts.some((a) => a.id === "menopause.postmenopausalBleeding")).toBe(true);
  });

  it("does not call an ordinary short cycle a postmenopausal bleed", () => {
    // The signal is a year-long gap between two logged starts, and nothing else.
    const signals = signalsFromRows(rows({ periodStarts: TRANSITION }));
    expect(signals.postmenopausalBleed).toBe(false);
  });

  /**
   * The red flag is not conditional on having bled. §G shows the box *every time*
   * — never normalised, never reassured away — so it is a standing module directly
   * under the hero rather than something that appears after the fact.
   */
  it("keeps the bleeding red flag standing, and it is the only one in the track", () => {
    for (const input of [
      rows({ periodStarts: STOPPED, symptomTypes: HOT_FLUSHES }),
      rows({ periodStarts: STOPPED_THEN_BLED }),
    ]) {
      const config = documentFor(input);
      expect(idsOf(config)).toContain("menopause.pmb");
      const redFlags = config.alerts.filter((a) => a.kind === "redFlag");
      expect(redFlags).toHaveLength(1);
      expect(redFlags[0]!.id).toBe("menopause.postmenopausalBleeding");
    }
  });

  /**
   * `docs/25` §5a rejects rings because they imply a target and a completion, and
   * ADR-042 says a bar filling toward twelve months reads as a countdown to a
   * diagnosis. `tone.countdown` is what a client reads to know it may never draw
   * one, and a milestone alert would render as a celebration of the same thing.
   */
  it("never carries a countdown, a milestone or a conclusion", () => {
    for (const input of [
      rows({ periodStarts: TRANSITION, symptomTypes: HOT_FLUSHES }),
      rows({ periodStarts: SKIPPING, symptomTypes: HOT_FLUSHES }),
      rows({ periodStarts: STOPPED, symptomTypes: HOT_FLUSHES }),
    ]) {
      const config = documentFor(input);
      expect(config.tone.countdown).toBe(false);
      expect(config.tone.celebrationByDefault).toBe(false);
      expect(config.alerts.some((a) => a.kind === "milestone")).toBe(false);
    }
  });

  it("keeps exactly one raised element, and it is the count", () => {
    for (const [input, expected] of [
      [rows({ periodStarts: TRANSITION, symptomTypes: HOT_FLUSHES }), "menopause.trend"],
      [rows({ periodStarts: STOPPED, symptomTypes: HOT_FLUSHES }), "menopause.since"],
    ] as const) {
      const heroes = documentFor(input).home.modules.filter((m) => m.emphasis === "hero");
      expect(heroes).toHaveLength(1);
      expect(heroes[0]!.id).toBe(expected);
    }
  });

  /**
   * §G: in postmenopause the bleeding log's purpose flips from "track your cycle"
   * to "note and act on any bleeding". Removing `period` from F2's tools would be
   * the worst edit available in that record — it is the only way she can tell
   * Femio the one thing it most needs to hear.
   */
  it("keeps period logging in postmenopause, where its meaning changes", () => {
    const config = documentFor(rows({ periodStarts: STOPPED, symptomTypes: HOT_FLUSHES }));
    expect(config.tools).toContain("period");
  });

  it("surfaces no fertility framing anywhere in the track", () => {
    for (const input of [
      rows({ periodStarts: TRANSITION, symptomTypes: HOT_FLUSHES }),
      rows({ periodStarts: STOPPED, symptomTypes: HOT_FLUSHES }),
    ]) {
      const config = documentFor(input);
      expect(idsOf(config).some((id) => id.startsWith("pregnancy."))).toBe(false);
      expect(idsOf(config)).toContain("explore");
    }
  });

  it("restricts nothing — every menopause surface is emphasis, never access", () => {
    const config = documentFor(rows({ periodStarts: STOPPED, symptomTypes: HOT_FLUSHES }));
    for (const forbidden of ["hidden", "blocked", "disabled", "locked", "available"]) {
      expect(Object.hasOwn(config, forbidden)).toBe(false);
      for (const spec of config.home.modules) {
        expect(Object.hasOwn(spec.params ?? {}, forbidden)).toBe(false);
      }
    }
    expect(idsOf(config)).toContain("library");
  });

  it("has a component for every module it can emit, or names it as missing", () => {
    const emitted = new Set<ModuleId>([
      ...idsOf(documentFor(rows({ periodStarts: TRANSITION, symptomTypes: HOT_FLUSHES }))),
      ...idsOf(documentFor(rows({ periodStarts: STOPPED, symptomTypes: HOT_FLUSHES }))),
    ]);
    const known = new Set<ModuleId>([...IMPLEMENTED, ...UNIMPLEMENTED]);
    for (const id of emitted) expect(known.has(id)).toBe(true);
  });

  it("has an article or a queued gap for every topic it foregrounds", () => {
    for (const input of [
      rows({ periodStarts: TRANSITION, symptomTypes: HOT_FLUSHES }),
      rows({ periodStarts: STOPPED, symptomTypes: HOT_FLUSHES }),
    ]) {
      for (const topic of documentFor(input).content.foreground) {
        expect(topic in ARTICLE_FOR_TOPIC || NO_ARTICLE_YET.includes(topic)).toBe(true);
      }
    }
  });

  /**
   * The gap worth naming out loud: F2 foregrounds the page behind its own red flag
   * and that page does not exist. The module is live, the alert is live, and a
   * woman who taps through has nowhere to land — so this asserts the gap is
   * *tracked* rather than pretending it is closed.
   */
  it("names the missing postmenopausal-bleeding article rather than hiding it", () => {
    const config = documentFor(rows({ periodStarts: STOPPED, symptomTypes: HOT_FLUSHES }));
    expect(config.content.foreground).toContain("postmenopausal-bleeding");
    expect(NO_ARTICLE_YET).toContain("postmenopausal-bleeding");
  });
});
