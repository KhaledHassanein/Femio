import type { createClient } from "@/lib/supabase/client";
import { readSignals } from "@/lib/persona/signals-from-db";
import { resolvePersona } from "@/lib/persona/resolver";
import { todayISO } from "@/lib/calculators/dates";
import { buildExperienceConfig, registryOf } from "./build";
import { TRACK_D_RECORDS } from "./registry/track-d";
import { EXPERIENCE_CONTRACT_VERSION, type ExperienceConfig, type Phase } from "./types";

/**
 * Getting the experience document to the client (R2.4, `docs/24` §3).
 *
 * Three sources, in order, and the order is the design:
 *
 * 1. **The Edge Function** — tier 1, the authority. One implementation of anything
 *    medical, shared with the Flutter client when it lands.
 * 2. **The local cache** — the last document she was served. This is what makes the
 *    screen work on a plane or a bad connection: nothing medical is *decided*
 *    offline, it is only re-displayed.
 * 3. **Local computation** — the same tier-1 code running in the browser.
 *
 * Step 3 exists because **deploying the function is an owner task**, and the app
 * must not depend on it having happened. Until it is deployed the fallback runs and
 * the result is identical, because it is literally the same modules — which the
 * golden fixtures and `tier1-portability-lint` between them guarantee. Deployment
 * is then a strict upgrade with no flag day.
 *
 * ## Why the cache is scoped and cleared
 *
 * A resolved config carries `modifiers` — her recorded conditions — so it is health
 * data sitting in `localStorage`. Two consequences, both deliberate: the key is
 * scoped to her user id so a shared device cannot show one woman another's state,
 * and `clearExperienceCache()` runs on sign-out. It is the same trade the offline
 * queue already makes, taken knowingly rather than by accident.
 */

type Client = ReturnType<typeof createClient>;

const CACHE_PREFIX = "femio.experience.v1";
/** Long enough to survive a flight, short enough that a stale persona self-corrects. */
const MAX_AGE_MS = 24 * 60 * 60 * 1000;

const REGISTRY = registryOf(TRACK_D_RECORDS);
const CONTEXT_TO_LAYER: Record<string, string> = { prior_loss: "D2" };

export type ExperienceSource = "server" | "cache" | "local";
export type LoadedExperience = { config: ExperienceConfig; source: ExperienceSource };

const cacheKey = (userId: string) => `${CACHE_PREFIX}.${userId}`;

function readCache(userId: string): ExperienceConfig | null {
  try {
    const raw = localStorage.getItem(cacheKey(userId));
    if (!raw) return null;
    const { at, config } = JSON.parse(raw) as { at: number; config: ExperienceConfig };
    if (Date.now() - at > MAX_AGE_MS) return null;
    // A document from a newer contract may contain modules this build cannot
    // render. Refusing it is safer than rendering half of it.
    if (config.version !== EXPERIENCE_CONTRACT_VERSION) return null;
    return config;
  } catch {
    return null;
  }
}

function writeCache(userId: string, config: ExperienceConfig): void {
  try {
    localStorage.setItem(cacheKey(userId), JSON.stringify({ at: Date.now(), config }));
  } catch {
    // A full or blocked storage is not a reason to fail a screen.
  }
}

/** Called on sign-out. Health data does not outlive the session on a shared device. */
export function clearExperienceCache(): void {
  try {
    for (let i = localStorage.length - 1; i >= 0; i--) {
      const key = localStorage.key(i);
      if (key?.startsWith(CACHE_PREFIX)) localStorage.removeItem(key);
    }
  } catch {
    // Nothing to do — and nothing worth breaking sign-out over.
  }
}

/** Tier 1, in the browser. Identical modules to the Edge Function, by construction. */
async function computeLocally(
  supabase: Client,
  today: string,
  phase: Phase | null,
): Promise<ExperienceConfig> {
  const signals = await readSignals(supabase);
  const resolution = resolvePersona(signals);
  return buildExperienceConfig({
    resolution,
    phase,
    registry: REGISTRY,
    resolvedAt: new Date().toISOString(),
    emotionalLayers: resolution.emotionalContext
      .map((c) => CONTEXT_TO_LAYER[c])
      .filter((id): id is string => Boolean(id)),
  });
}

export async function loadExperienceConfig(
  supabase: Client,
  options: { today?: string; phase?: Phase | null } = {},
): Promise<LoadedExperience | null> {
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return null;

  const today = options.today ?? todayISO();

  try {
    const { data, error } = await supabase.functions.invoke<ExperienceConfig>("experience", {
      body: { today },
    });
    if (!error && data && data.version === EXPERIENCE_CONTRACT_VERSION) {
      writeCache(user.id, data);
      return { config: data, source: "server" };
    }
  } catch {
    // Not deployed, offline, or refused — fall through. This is expected, not
    // exceptional, until the function ships.
  }

  const cached = readCache(user.id);
  if (cached) return { config: cached, source: "cache" };

  const config = await computeLocally(supabase, today, options.phase ?? null);
  writeCache(user.id, config);
  return { config, source: "local" };
}
