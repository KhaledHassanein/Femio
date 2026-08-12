import { describe, expect, it } from "vitest";
import { readSignals } from "./signals-from-db";
import { resolvePersona } from "./resolver";

/**
 * A hand-rolled Supabase stub. The real client is a builder whose calls only
 * resolve at `await`, so each table returns a thenable that yields its fixture —
 * enough to drive `readSignals` without a network or a mock library.
 */
function stubClient(tables: Record<string, unknown>, userId: string | null = "u1") {
  const result = (table: string) => {
    const data = tables[table] ?? null;
    const builder: Record<string, unknown> = {};
    for (const method of ["select", "order", "limit", "eq"]) {
      builder[method] = () => builder;
    }
    builder.maybeSingle = () => Promise.resolve({ data, error: null });
    builder.then = (resolve: (v: unknown) => unknown) => resolve({ data, error: null });
    return builder;
  };
  return {
    auth: { getUser: async () => ({ data: { user: userId ? { id: userId } : null } }) },
    from: (table: string) => result(table),
  } as never;
}

const iso = (daysAgo: number) =>
  new Date(Date.now() - daysAgo * 86_400_000).toISOString().slice(0, 10);

describe("readSignals", () => {
  it("asserts nothing when nobody is signed in", async () => {
    const signals = await readSignals(stubClient({}, null));
    expect(signals.conditions).toEqual([]);
    expect(signals.ageBand).toBeNull();
    expect(signals.cycleRegularity).toBe("unknown");
  });

  it("reads conditions she recorded herself", async () => {
    const signals = await readSignals(
      stubClient({
        conditions_flagged: [
          { condition_code: "thyroid", created_at: "2026-01-01T00:00:00Z" },
          { condition_code: "pcos", created_at: "2026-01-01T00:00:00Z" },
        ],
      }),
    );
    expect([...signals.conditions].sort()).toEqual(["pcos", "thyroid"]);
  });

  /**
   * A long gap describes the RECORD, not the woman. Amenorrhea is a clinical
   * finding and Femio does not make them (product rule 1) — this only widens what
   * the resolver offers.
   */
  it("calls a long gap 'absent' without concluding anything", async () => {
    const signals = await readSignals(
      stubClient({ cycles: [{ period_start: iso(200) }, { period_start: iso(230) }] }),
    );
    expect(signals.cycleRegularity).toBe("absent");
    expect(signals.daysSinceLastPeriod).toBeGreaterThan(90);
  });

  /**
   * `docs/09` §8 rule 3: D3 (gestational, resolves postpartum) and D4
   * (pre-existing, lifelong) must never be conflated, and the only thing that
   * separates them is when the diabetes was recorded relative to the pregnancy.
   */
  it("separates pre-existing diabetes from gestational by when it was recorded", async () => {
    const before = await readSignals(
      stubClient({
        conditions_flagged: [{ condition_code: "diabetes", created_at: "2026-01-01T00:00:00Z" }],
        pregnancy: { status: "active", edd: iso(-100), created_at: "2026-06-01T00:00:00Z" },
      }),
    );
    expect(before.diabetesRecordedBeforePregnancy).toBe(true);
    expect(resolvePersona(before).personaId).toBe("D4");

    const during = await readSignals(
      stubClient({
        conditions_flagged: [{ condition_code: "diabetes", created_at: "2026-07-01T00:00:00Z" }],
        pregnancy: { status: "active", edd: iso(-100), created_at: "2026-06-01T00:00:00Z" },
      }),
    );
    expect(during.diabetesRecordedBeforePregnancy).toBe(false);
    expect(resolvePersona(during).personaId).toBe("D3");
  });

  /**
   * The bug R2.6 fixes, stated as a signal test: a woman with a recorded thyroid
   * condition who is pregnant must resolve to D7, so choosing "I'm pregnant" in
   * Settings cannot drop her thyroid layer the way the old lookup table did.
   */
  it("keeps a recorded condition reaching the resolver for a pregnant user", async () => {
    const signals = await readSignals(
      stubClient({
        conditions_flagged: [{ condition_code: "thyroid", created_at: "2026-01-01T00:00:00Z" }],
        pregnancy: { status: "active", edd: iso(-100), created_at: "2026-06-01T00:00:00Z" },
      }),
    );
    expect(resolvePersona(signals).personaId).toBe("D7");
  });

  it("counts symptoms she logged, and invents none", async () => {
    const signals = await readSignals(
      stubClient({
        symptom_logs: [{ type: "hotFlushes" }, { type: "hotFlushes" }, { type: "cramps" }],
      }),
    );
    expect(signals.symptomCounts).toEqual({ hotFlushes: 2, cramps: 1 });
  });
});
