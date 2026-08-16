import { describe, expect, it } from "vitest";
import { signalsFromRows, type SignalRows } from "../persona/signals-from-rows";
import { resolveForStatedTrack, resolvePersona } from "../persona/resolver";
import { buildExperienceConfig, registryOf } from "./build";
import { emotionalLayersFor } from "./layers";
import { phaseForTrack } from "./phase";
import { PERSONA_RECORDS } from "./registry";

/**
 * Track E, end to end (R2.4).
 *
 * R2.5 shipped postpartum and this suite is the check nobody ran on it: **could the
 * pipeline that actually feeds the screen ever produce a Track E document?** It
 * could not. Two independent faults, each invisible on its own because the browser
 * was composing E1 by hand from the stored persona id and never asking:
 *
 *   1. `weeksSincePregnancyEnd` was written by nothing, so `E1.requires` could only
 *      fail and the resolver answered Z1.
 *   2. The phase came from the pregnancy row, so a woman who joined Femio *after*
 *      giving birth had no phase at all — and every E1 module is filed under
 *      `postpartum`.
 *
 * Either one alone turns her dashboard into the generic experience, which is the
 * next-period prediction R2.5 exists to stop showing her. So the assertions here are
 * deliberately about the whole chain rather than any one function.
 */

const REGISTRY = registryOf(PERSONA_RECORDS);
const TODAY = "2026-08-15";

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

const ENDED_FIVE_WEEKS_AGO = {
  status: "completed",
  createdAt: "2025-11-02T09:00:00Z",
  updatedAt: "2026-07-11T08:30:00Z",
};

function documentFor(input: SignalRows, statedTrack: "E" | null) {
  const signals = signalsFromRows(input);
  const resolution = resolveForStatedTrack(signals, statedTrack);
  return buildExperienceConfig({
    resolution,
    phase: phaseForTrack(statedTrack, {
      edd: null,
      status: input.pregnancy?.status ?? null,
      todayISO: TODAY,
    }),
    registry: REGISTRY,
    resolvedAt: "2026-08-15T00:00:00.000Z",
    emotionalLayers: emotionalLayersFor(resolution.track, resolution.emotionalContext),
  });
}

describe("Track E reachability", () => {
  it("resolves Track E from a pregnancy that ended five weeks ago", () => {
    const signals = signalsFromRows(rows({ pregnancy: ENDED_FIVE_WEEKS_AGO }));
    expect(signals.weeksSincePregnancyEnd).toBe(5);
    // `ENDED_FIVE_WEEKS_AGO` is a stated live birth, so the specific persona wins:
    // E2 extends E1 and keeps everything it contributed. The outcome split is
    // exercised properly in "Track E routes on how the pregnancy ended", below.
    expect(resolvePersona(signals).track).toBe("E");
    expect(resolvePersona(signals).personaId).toBe("E2");
    // Unstated, she gets recovery and nothing assumed.
    const unstated = signalsFromRows(rows({ pregnancy: { ...ENDED_FIVE_WEEKS_AGO, status: "ended" } }));
    expect(resolvePersona(unstated).personaId).toBe("E1");
  });

  /** The regression, stated as the gate that used to fail. */
  it("cannot resolve E1 when the weeks-since signal is missing", () => {
    const signals = signalsFromRows(rows({ pregnancy: ENDED_FIVE_WEEKS_AGO }));
    expect(resolvePersona({ ...signals, weeksSincePregnancyEnd: null }).personaId).toBe("Z1");
  });

  it("gives her a postpartum document even with no pregnancy row — she joined after the birth", () => {
    const config = documentFor(rows(), "E");
    expect(config.track).toBe("E");
    expect(config.personaId).toBe("E1");
    expect(config.phase).toBe("postpartum");
    expect(config.home.modules.map((m) => m.id)).toContain("pregnancy.warningSigns");
    expect(config.home.modules.length).toBeGreaterThan(0);
  });

  /**
   * Without `resolveForStatedTrack` this is what the Edge Function would have
   * served her: a generic document, from which the dashboard would have drawn a
   * next-period prediction over cycles that have not returned.
   */
  it("would have served the generic document without her stated stage", () => {
    const config = documentFor(rows(), null);
    expect(config.personaId).toBe("Z1");
    expect(config.home.modules).toHaveLength(0);
  });

  it("never celebrates by default, whichever way she arrived", () => {
    for (const input of [rows(), rows({ pregnancy: ENDED_FIVE_WEEKS_AGO })]) {
      expect(documentFor(input, "E").tone.celebrationByDefault).toBe(false);
    }
  });

  /**
   * The mapping that had been copied into four files and disagreed with itself.
   * D2 is a pregnancy carried *after* a loss; E6 is the loss. Handing a woman in
   * Track E the D2 layer is the wrong stage's tone, not a near-miss.
   */
  it("carries a loss into E6, never D2", () => {
    expect(emotionalLayersFor("E", ["prior_loss"])).toEqual(["E6"]);
    expect(emotionalLayersFor("D", ["prior_loss"])).toEqual(["D2"]);
    expect(emotionalLayersFor("B", ["prior_loss"])).toEqual([]);
    // A context with no layer for its track contributes nothing rather than
    // resolving to something invented — `waiting` belongs to Track C, which has
    // no emotional layer yet.
    expect(emotionalLayersFor("C", ["waiting"])).toEqual([]);
  });

  it("speaks gently after a loss, and the clinical layer cannot switch it back", () => {
    const config = documentFor(
      rows({
        pregnancy: { ...ENDED_FIVE_WEEKS_AGO, status: "loss" },
        conditions: [{ code: "prior_loss", recordedAt: "2026-07-11T08:30:00Z" }],
      }),
      "E",
    );
    expect(config.personaId).toBe("E6");
    expect(config.tone.register).toBe("gentle");
    expect(config.tone.countdown).toBe(false);
  });
});

describe("resolveForStatedTrack", () => {
  it("lets the resolver refine within the track she chose", () => {
    // Pregnant with a thyroid condition: D7, not the base D1 her statement alone
    // would have given her.
    const signals = signalsFromRows(
      rows({
        pregnancy: { status: "active", createdAt: "2026-03-01T00:00:00Z", updatedAt: "2026-03-01T00:00:00Z" },
        conditions: [{ code: "thyroid", recordedAt: "2026-03-02T00:00:00Z" }],
      }),
    );
    expect(resolveForStatedTrack(signals, "D").personaId).toBe("D7");
  });

  it("keeps her modifiers when it falls back to the track's base persona", () => {
    const signals = signalsFromRows(
      rows({ conditions: [{ code: "pcos", recordedAt: "2026-01-01T00:00:00Z" }] }),
    );
    const resolved = resolveForStatedTrack(signals, "E");
    expect(resolved.personaId).toBe("E1");
    // Nothing is ever removed: the layer she has stays on the document.
    expect(resolved.modifiers).toContain("pcos");
  });

  it("makes no offer from a track she has just said she is not in", () => {
    expect(resolveForStatedTrack(signalsFromRows(rows()), "E").runnerUp).toBeNull();
  });
});

/**
 * The outcome decides the persona, not just the message (2026-08-16).
 *
 * E6 §A calls itself "the destination state of the universal loss handler", and E2
 * §E scopes feeding content to a live birth. Between them these two rules decide
 * whether a woman who has just lost a pregnancy is shown breastfeeding content,
 * which is the worst thing this track could get wrong.
 */
describe("Track E routes on how the pregnancy ended", () => {
  const outcome = (status: string, over: Partial<SignalRows> = {}) =>
    signalsFromRows(
      rows({ pregnancy: { ...ENDED_FIVE_WEEKS_AGO, status }, ...over }),
    );

  it("sends a recorded loss to E6, whatever else is true", () => {
    expect(resolvePersona(outcome("loss")).personaId).toBe("E6");
  });

  it("keeps feeding content away from a loss, and from an unstated outcome", () => {
    // E2 is gated on a *stated* live birth, not on "not a loss".
    expect(resolvePersona(outcome("loss")).personaId).not.toBe("E2");
    expect(resolvePersona(outcome("ended")).personaId).not.toBe("E2");
  });

  it("offers lactation after a stated birth", () => {
    expect(resolvePersona(outcome("completed")).personaId).toBe("E2");
  });

  it("does not treat an unstated ending as a birth", () => {
    // She did not say. E1 — recovery, the honest middle — not E2's feeding hero.
    expect(resolvePersona(outcome("ended")).personaId).toBe("E1");
  });

  it("gives E2 the feeding modules on top of everything E1 had", () => {
    const config = documentFor(rows({ pregnancy: { ...ENDED_FIVE_WEEKS_AGO, status: "completed" } }), "E");
    const ids = config.home.modules.map((m) => m.id);
    expect(config.personaId).toBe("E2");
    expect(ids).toContain("support.feeding");
    expect(ids).toContain("support.breastSymptoms");
    // Layers add: her recovery has not stopped because feeding started.
    expect(ids).toContain("pregnancy.warningSigns");
    expect(ids).toContain("support.moodScreener");
  });

  it("still does not celebrate by default, even while feeding", () => {
    // E2 §E10: she may be feeding through pain, or grieving a plan that did not
    // happen. Guilt-free combination and formula content is the persona, not an
    // afterthought.
    const config = documentFor(rows({ pregnancy: { ...ENDED_FIVE_WEEKS_AGO, status: "completed" } }), "E");
    expect(config.tone.celebrationByDefault).toBe(false);
  });
});
