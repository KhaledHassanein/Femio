import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { clearExperienceCache, loadExperienceConfig } from "./client";
import { EXPERIENCE_CONTRACT_VERSION } from "./types";

/**
 * The three-source ladder (R2.4): server → cache → local.
 *
 * The one that matters most is the **fallback**. Deploying the Edge Function is an
 * owner task, so until it happens every call fails — and a screen that broke while
 * waiting for a deployment would be a worse product than one with no engine at all.
 */

const CONFIG = {
  version: EXPERIENCE_CONTRACT_VERSION,
  resolvedAt: "2026-08-12T00:00:00.000Z",
  track: "D",
  personaId: "D7",
  modifiers: ["thyroid"],
  emotionalContext: [],
  confidence: 1,
  offer: null,
  phase: "t2",
  home: { modules: [], quickLog: [] },
  tools: [],
  content: { skin: "pregnancy-thyroid", foreground: [] },
  alerts: [],
  emrView: [],
  tone: { register: "warm", celebrationByDefault: true, countdown: false, readingLevel: "standard" },
};

function stubClient(invoke: () => Promise<unknown>, userId: string | null = "u1") {
  const table = () => {
    const b: Record<string, unknown> = {};
    for (const m of ["select", "order", "limit", "eq"]) b[m] = () => b;
    b.maybeSingle = () => Promise.resolve({ data: null, error: null });
    b.then = (res: (v: unknown) => unknown) => res({ data: [], error: null });
    return b;
  };
  return {
    auth: { getUser: async () => ({ data: { user: userId ? { id: userId } : null } }) },
    from: () => table(),
    functions: { invoke },
  } as never;
}

// jsdom is not configured for these suites, so localStorage is stubbed directly.
beforeEach(() => {
  const store = new Map<string, string>();
  vi.stubGlobal("localStorage", {
    getItem: (k: string) => store.get(k) ?? null,
    setItem: (k: string, v: string) => void store.set(k, v),
    removeItem: (k: string) => void store.delete(k),
    key: (i: number) => [...store.keys()][i] ?? null,
    get length() {
      return store.size;
    },
  });
});

afterEach(() => vi.unstubAllGlobals());

describe("loadExperienceConfig", () => {
  it("prefers the server when the function answers", async () => {
    const loaded = await loadExperienceConfig(
      stubClient(async () => ({ data: CONFIG, error: null })),
    );
    expect(loaded?.source).toBe("server");
    expect(loaded?.config.personaId).toBe("D7");
  });

  /** The state the app is in today: written, not deployed. It must not break. */
  it("falls back to local computation when the function is not deployed", async () => {
    const loaded = await loadExperienceConfig(
      stubClient(async () => {
        throw new Error("Function not found");
      }),
    );
    expect(loaded?.source).toBe("local");
    expect(loaded?.config.version).toBe(EXPERIENCE_CONTRACT_VERSION);
  });

  it("serves the cache when the server is unreachable — the offline case", async () => {
    const online = stubClient(async () => ({ data: CONFIG, error: null }));
    await loadExperienceConfig(online);

    const offline = stubClient(async () => {
      throw new Error("offline");
    });
    const loaded = await loadExperienceConfig(offline);
    expect(loaded?.source).toBe("cache");
    expect(loaded?.config.personaId).toBe("D7");
  });

  /**
   * A document from a newer contract may name modules this build cannot render.
   * Refusing it is safer than rendering half a screen.
   */
  it("refuses a cached document from a different contract version", async () => {
    const online = stubClient(async () => ({
      data: { ...CONFIG, version: EXPERIENCE_CONTRACT_VERSION + 1 },
      error: null,
    }));
    const first = await loadExperienceConfig(online);
    // Not accepted from the server either — same rule, same reason.
    expect(first?.source).toBe("local");
  });

  it("returns null when nobody is signed in, rather than resolving a stranger", async () => {
    const loaded = await loadExperienceConfig(
      stubClient(async () => ({ data: CONFIG, error: null }), null),
    );
    expect(loaded).toBeNull();
  });

  /** Health data must not outlive the session on a shared device. */
  it("clears every cached document on sign-out", async () => {
    await loadExperienceConfig(stubClient(async () => ({ data: CONFIG, error: null })));
    expect(localStorage.length).toBeGreaterThan(0);
    clearExperienceCache();
    expect(localStorage.length).toBe(0);
  });
});
