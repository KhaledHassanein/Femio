"use client";

import { useEffect, useState } from "react";

import { createClient } from "@/lib/supabase/client";
import {
  MIGRATABLE_SURFACES,
  versionForSurface,
  type ContractVersion,
  type FlagSources,
  type MigratableSurface,
} from "./flags";

/**
 * Which contract version a surface should render, resolved on the client
 * (RB-C4, migration `0021`).
 *
 * `flags.ts` decides; this only supplies it. The split matters because the
 * decision is pure, total and tested, while the supply is a network call that can
 * fail — and a surface that cannot decide must still draw something.
 *
 * ## Resolution order is remote → cached → compiled default
 *
 * Exactly what `0021` specifies, and each step exists for a different failure:
 *
 * - **remote** — the truth, when it is reachable.
 * - **cached** — the last remote answer this device saw. Without it, every cold
 *   start on a bad connection would silently roll a migrated surface back to v1,
 *   which is a worse experience than the one the flag was flipped to escape.
 * - **compiled default (v1)** — a device that has never completed a fetch. The
 *   default is deliberately the *old* contract: a surface that has never heard
 *   from the server should render the version that has been in production
 *   longest, not the newest one.
 *
 * ## Why it starts at v1 and may change once
 *
 * The first render happens before any fetch resolves, so this returns v1 and then
 * possibly upgrades. That is a visible swap, and it is the honest trade: the
 * alternative is blocking the dashboard on a flag call, which makes a network
 * problem into a blank screen. C7's designed loading state is where that swap
 * stops being noticeable.
 *
 * The cached read happens synchronously in the initial state, so a device that has
 * fetched before renders v2 immediately and never swaps.
 */

const CACHE_KEY = "femio.flags.v1";

/** Last known remote answer. Best-effort — a browser with no storage is fine. */
function readCache(): Record<string, boolean> | undefined {
  if (typeof window === "undefined") return undefined;
  try {
    const raw = window.localStorage.getItem(CACHE_KEY);
    if (!raw) return undefined;
    const parsed: unknown = JSON.parse(raw);
    if (!parsed || typeof parsed !== "object") return undefined;
    // Only booleans survive the round trip. A malformed cache is discarded rather
    // than trusted — it decides which contract renders, so a stray string here
    // would be a silent wrong answer.
    const out: Record<string, boolean> = {};
    for (const [k, v] of Object.entries(parsed as Record<string, unknown>)) {
      if (typeof v === "boolean") out[k] = v;
    }
    return out;
  } catch {
    return undefined;
  }
}

function writeCache(flags: Record<string, boolean>): void {
  if (typeof window === "undefined") return;
  try {
    window.localStorage.setItem(CACHE_KEY, JSON.stringify(flags));
  } catch {
    // Storage full or blocked. The remote answer still applies to this session;
    // only the next cold start loses it, which is the compiled default's job.
  }
}

/**
 * Every surface's version at once. One fetch, not five — a client that renders
 * more than one surface should not ask five times.
 */
export function useSurfaceVersions(): Readonly<Record<MigratableSurface, ContractVersion>> {
  const [sources, setSources] = useState<FlagSources>(() => ({ cached: readCache() }));

  useEffect(() => {
    let active = true;
    void (async () => {
      try {
        const supabase = createClient();
        const { data, error } = await supabase
          .from("feature_flags")
          .select("key, enabled")
          .like("key", "experience.v2.%");
        if (error || !data || !active) return;

        const remote: Record<string, boolean> = {};
        for (const row of data as { key: string; enabled: boolean }[]) {
          remote[row.key] = row.enabled;
        }
        writeCache(remote);
        setSources((prev) => ({ ...prev, remote }));
      } catch {
        // Offline, or the table is not readable yet. `versionForSurface` falls
        // through to cached and then to v1, so there is nothing to handle.
      }
    })();
    return () => {
      active = false;
    };
  }, []);

  const out = {} as Record<MigratableSurface, ContractVersion>;
  for (const surface of MIGRATABLE_SURFACES) out[surface] = versionForSurface(surface, sources);
  return out;
}

/** One surface, for a screen that only renders one. */
export function useSurfaceVersion(surface: MigratableSurface): ContractVersion {
  return useSurfaceVersions()[surface];
}
