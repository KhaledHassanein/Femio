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
 * Track B, end to end (R2.8).
 *
 * The same question `track-a-reachability` and `track-e-reachability` ask, of the
 * largest audience in the product: can rows, resolution, phase and build produce a
 * cycle document at all? Track E taught why it has to be asked before shipping —
 * it shipped a mode whose pipeline could not resolve, and nobody noticed because
 * the screen composed its own answer.
 *
 * Then the three questions the B specs care about more than any structural one:
 *
 * 1. **Does B1 stay non-TTC?** (§A — the pregnancy-funnel default is what this
 *    persona is written against.)
 * 2. **Does an irregular cycle stop Femio predicting?** (§I — the honest absence,
 *    and the third life stage at which the invented window has had to be fixed.)
 * 3. **Can a woman who reported PCOS actually reach B6?** She could not, until the
 *    resolver change that shipped with this registry.
 */

const REGISTRY = registryOf(PERSONA_RECORDS);
const TODAY = "2026-08-16";

const rows = (over: Partial<SignalRows> = {}): SignalRows => ({
  ageBand: "25_34",
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

/** Four cycles ~28 days apart — steady enough for a prediction to exist. */
const STEADY = ["2026-05-10", "2026-06-07", "2026-07-05", "2026-08-02"];
/** 31, 47 and 62 days — the pattern B5 §I describes, and unpredictable. */
const SCATTERED = ["2026-02-14", "2026-03-17", "2026-05-03", "2026-07-04"];

/** Her own statement, which is the only thing B6 is ever gated on (ADR-065's rule). */
const PCOS = { code: "pcos", recordedAt: "2026-01-04" };
const THYROID = { code: "thyroid", recordedAt: "2026-01-04" };

function documentFor(input: SignalRows) {
  const signals = signalsFromRows(input);
  const resolution = resolveForStatedTrack(signals, "B");
  return buildExperienceConfig({
    resolution,
    // Track B has no phase, and `phaseForTrack` must not invent one.
    phase: phaseForTrack("B", { edd: null, status: null, todayISO: TODAY }),
    registry: REGISTRY,
    resolvedAt: "2026-08-16T00:00:00.000Z",
    emotionalLayers: emotionalLayersFor(resolution.track, resolution.emotionalContext),
  });
}

const idsOf = (config: ReturnType<typeof documentFor>) => config.home.modules.map((m) => m.id);

describe("Track B reachability", () => {
  it("has no phase, and the engine still gives her a screen", () => {
    const config = documentFor(rows({ periodStarts: STEADY }));
    expect(config.phase).toBeNull();
    expect(config.home.modules.length).toBeGreaterThan(0);
  });

  it("resolves B1 for the hub case, on the evidence alone", () => {
    const signals = signalsFromRows(rows({ periodStarts: STEADY }));
    expect(resolvePersona(signals).personaId).toBe("B1");
    expect(documentFor(rows({ periodStarts: STEADY })).personaId).toBe("B1");
  });

  it("leads with the predicted window, and keeps exactly one raised element", () => {
    const config = documentFor(rows({ periodStarts: STEADY }));
    const heroes = config.home.modules.filter((m) => m.emphasis === "hero");
    expect(heroes).toHaveLength(1);
    expect(heroes[0]!.id).toBe("cycle.window");
  });

  /**
   * §A is written against the pregnancy funnel: *"Every screen is baby this,
   * ovulation that. I'm not in that chapter."* The registry carries no fertility
   * module and no TTC tool, so there is nothing for a screen to render — and
   * `explore` is what makes the absence emphasis rather than restriction.
   */
  it("never funnels the hub persona toward TTC or pregnancy", () => {
    const config = documentFor(rows({ periodStarts: STEADY }));
    expect(idsOf(config).some((id) => id.startsWith("pregnancy."))).toBe(false);
    expect(config.tools).not.toContain("movement");
    expect(config.tools).not.toContain("contractions");
    expect(idsOf(config)).toContain("explore");
    expect(idsOf(config)).toContain("library");
  });

  /**
   * The honest absence, and the reason B5 does not extend B1. Inheriting a
   * prediction hero she cannot have would be the invented-window defect ADR-041,
   * ADR-042 and R2.5 each fixed at a different life stage.
   */
  it("stops predicting when the cycles cannot support a prediction", () => {
    const config = documentFor(rows({ periodStarts: SCATTERED, ageBand: "25_34" }));
    expect(config.personaId).toBe("B5");
    expect(idsOf(config)).toContain("cycle.variability");
    expect(idsOf(config)).not.toContain("cycle.window");
    const heroes = config.home.modules.filter((m) => m.emphasis === "hero");
    expect(heroes).toHaveLength(1);
    expect(heroes[0]!.id).toBe("cycle.variability");
  });

  /**
   * The trap, for the fifth time. Before the `conditions.length === 0` signal on
   * B5, this woman scored B5 and B6 identically at 1.0, B5 won on rule order, and
   * B6 was unreachable — the PCOS she reported changed nothing about her app.
   * Delete that one line and this test goes red.
   */
  it("reaches B6 for a woman who reported PCOS", () => {
    const signals = signalsFromRows(rows({ periodStarts: SCATTERED, conditions: [PCOS] }));
    expect(resolvePersona(signals).personaId).toBe("B6");
    expect(documentFor(rows({ periodStarts: SCATTERED, conditions: [PCOS] })).personaId).toBe("B6");
  });

  /**
   * The same woman when her cycles are currently regular — treated, or simply
   * having a good few months.
   *
   * On the evidence alone this is Z1 **with B6 as the offer**, and that is the
   * confidence machinery working rather than failing: PCOS with a steady pattern is
   * genuinely less certain than PCOS with a scattered one, and `docs/09` §5 says
   * offer rather than commit. What matters here is *which* persona gets offered.
   * Before B1's "no conditions" signal was raised to match "regular cycles", B1
   * outscored B6 at 0.857 to 0.714 and she was pointed at the general dashboard
   * instead of the library she came for. She states her track at onboarding, so the
   * path the app actually runs lands on B6.
   */
  it("offers B6, not B1, when her cycles are regular right now", () => {
    const signals = signalsFromRows(rows({ periodStarts: STEADY, conditions: [PCOS] }));
    expect(resolvePersona(signals).runnerUp?.personaId).toBe("B6");
    expect(resolveForStatedTrack(signals, "B").personaId).toBe("B6");
  });

  it("keeps B1 for a woman with an unrelated condition and ordinary cycles", () => {
    /**
     * The reason "no conditions" is a signal and not a gate. Track B has no B17
     * rule, so gating B1 would leave nothing to catch her at all and take the cycle
     * dashboard away — restriction dressed as precision.
     */
    const signals = signalsFromRows(rows({ periodStarts: STEADY, conditions: [THYROID] }));
    expect(signals.conditions).toContain("thyroid");
    expect(resolvePersona(signals).runnerUp?.personaId).toBe("B1");
    expect(resolveForStatedTrack(signals, "B").personaId).toBe("B1");
  });

  it("B6 keeps everything B5 contributed, and swaps the library", () => {
    const b5 = documentFor(rows({ periodStarts: SCATTERED }));
    const b6 = documentFor(rows({ periodStarts: SCATTERED, conditions: [PCOS] }));
    // Layers add and never replace.
    for (const id of idsOf(b5)) expect(idsOf(b6)).toContain(id);
    expect(b5.content.skin).toBe("irregular-cycles");
    expect(b6.content.skin).toBe("pcos");
    // §I pins visit-prep for B6; `mergeModules` upgrades rather than duplicating.
    expect(idsOf(b6).filter((id) => id === "visitPrep")).toHaveLength(1);
    expect(b6.home.modules.find((m) => m.id === "visitPrep")?.emphasis).toBe("primary");
  });

  /**
   * §D: a pattern change raises content and visit-prep prominence, *never a red
   * banner*. So the alert `kind` is the safety decision, exactly as it is in Track
   * A — and Track B contributes no red-flag alert at all, which is the deliberate
   * opposite of Track D, where late is the harmful direction.
   */
  it("never renders a cycle change as a danger surface", () => {
    for (const input of [rows({ periodStarts: STEADY }), rows({ periodStarts: SCATTERED })]) {
      const config = documentFor(input);
      expect(config.alerts.every((a) => a.kind !== "redFlag")).toBe(true);
      expect(idsOf(config)).not.toContain("pregnancy.warningSigns");
    }
  });

  /**
   * Product rule 3, checked at the document rather than remembered in a screen.
   * `countdown: false` is what a client reads to know it may never render one, and
   * B1 §K states the rule twice.
   */
  it("never carries a countdown or a celebration cadence", () => {
    for (const input of [rows({ periodStarts: STEADY }), rows({ periodStarts: SCATTERED })]) {
      const config = documentFor(input);
      expect(config.tone.countdown).toBe(false);
      expect(config.tone.celebrationByDefault).toBe(false);
      expect(config.alerts.some((a) => a.kind === "milestone")).toBe(false);
    }
  });

  it("keeps the long-gap threshold as one definition across the track", () => {
    // Merged by id (`docs/09` §8 rule 1), so B6's inherited alert cannot disagree
    // with B1's about the number.
    const thresholds = new Set<unknown>();
    for (const input of [
      rows({ periodStarts: STEADY }),
      rows({ periodStarts: SCATTERED }),
      rows({ periodStarts: SCATTERED, conditions: [PCOS] }),
    ]) {
      const alert = documentFor(input).alerts.find((a) => a.id === "cycle.longGap");
      if (alert) thresholds.add(alert.params?.afterDays);
    }
    expect(thresholds).toEqual(new Set([90]));
  });

  it("restricts nothing — every cycle surface is emphasis, never access", () => {
    const config = documentFor(rows({ periodStarts: SCATTERED }));
    for (const forbidden of ["hidden", "blocked", "disabled", "locked", "available"]) {
      expect(Object.hasOwn(config, forbidden)).toBe(false);
      for (const spec of config.home.modules) {
        expect(Object.hasOwn(spec.params ?? {}, forbidden)).toBe(false);
      }
    }
  });

  it("has a component for every module it can emit, or names it as missing", () => {
    const emitted = new Set<ModuleId>([
      ...idsOf(documentFor(rows({ periodStarts: STEADY }))),
      ...idsOf(documentFor(rows({ periodStarts: SCATTERED }))),
      ...idsOf(documentFor(rows({ periodStarts: SCATTERED, conditions: [PCOS] }))),
    ]);
    const known = new Set<ModuleId>([...IMPLEMENTED, ...UNIMPLEMENTED]);
    for (const id of emitted) expect(known.has(id)).toBe(true);
  });

  it("has an article or a queued gap for every topic it foregrounds", () => {
    // The `UNIMPLEMENTED` idiom applied to content (P2.3c): a topic dropped without
    // a home fails here rather than quietly vanishing from a reading list.
    for (const input of [
      rows({ periodStarts: STEADY }),
      rows({ periodStarts: SCATTERED }),
      rows({ periodStarts: SCATTERED, conditions: [PCOS] }),
    ]) {
      for (const topic of documentFor(input).content.foreground) {
        expect(topic in ARTICLE_FOR_TOPIC || NO_ARTICLE_YET.includes(topic)).toBe(true);
      }
    }
  });

  it("fills B6's reading card entirely from published articles", () => {
    // The point of choosing these five topics: B6 is the first persona in the
    // product whose foreground is answered by the library that already exists.
    const config = documentFor(rows({ periodStarts: SCATTERED, conditions: [PCOS] }));
    const withArticles = config.content.foreground.filter((t) => t in ARTICLE_FOR_TOPIC);
    expect(withArticles.length).toBeGreaterThanOrEqual(4);
  });
});
