import { describe, expect, it } from "vitest";
import { PERSONA_RECORDS } from "./registry";
import { TRACK_BASE_PERSONA } from "../persona/resolver";

/**
 * Z1 is the fallback persona — the one a record lands on when the evidence does
 * not place her in a life stage — and until R3.1.6 it had **no registry record at
 * all**, because `track-z.ts` did not exist. Her dashboard showed a prediction only
 * because `dashboard-screen.tsx` carried a hardcoded `HeroCard` behind a
 * `mode ===` branch, which is the concrete gap `docs/26` §4.1 found.
 *
 * That branch is now deleted, so these assertions are what stands between the
 * fallback persona and an empty screen. They are deliberately about *reachability*
 * rather than layout: which modules she is served may be tuned, but she must never
 * again be served nothing.
 */
describe("Track Z is reachable (R3.1.6)", () => {
  const z1 = PERSONA_RECORDS.find((r) => r.id === "Z1");

  it("has a record at all — the failure this file exists to prevent", () => {
    expect(z1).toBeDefined();
  });

  it("is the base persona the resolver falls back to", () => {
    expect(TRACK_BASE_PERSONA.Z).toBe("Z1");
  });

  it("serves the modules the deleted branch used to hardcode", () => {
    const ids = (z1?.home.default ?? []).map((m) => m.id);
    // `cycle.window` is the one the removed HeroCard was standing in for.
    expect(ids).toContain("cycle.window");
    expect(ids).toContain("quickLog");
  });

  it("keeps everything else reachable, because the fallback restricts nothing", () => {
    // Product rule 2. The woman Femio cannot place is the most likely to need to
    // reach something it has not offered her.
    const ids = (z1?.home.default ?? []).map((m) => m.id);
    expect(ids).toContain("library");
    expect(ids).toContain("visitPrep");
  });

  it("never counts down, like every other track", () => {
    expect(z1?.tone.countdown).toBe(false);
  });
});

describe("every track has a document", () => {
  it("leaves no base persona without a record", () => {
    // The generalised version of the Z1 bug: a track mapped in TRACK_BASE_PERSONA
    // with no registry file serves an empty experience and fails silently.
    for (const [track, personaId] of Object.entries(TRACK_BASE_PERSONA)) {
      const record = PERSONA_RECORDS.find((r) => r.id === personaId);
      expect(record, `track ${track} → ${personaId} has no registry record`).toBeDefined();
    }
  });
});
