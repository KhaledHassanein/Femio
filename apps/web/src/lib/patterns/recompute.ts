"use client";

import { createClient } from "@/lib/supabase/client";

/**
 * Ask tier 1 to recompute her findings (D2).
 *
 * `0019` revokes `insert` on `patterns` from `authenticated`, so the browser can
 * never write a finding — it can only ask the Edge Function to. Without a caller
 * the table stays empty forever and the home module never renders, which is the
 * gap this closes.
 *
 * ## Throttled to once a day, and why that is the right cadence
 *
 * A pattern rests on **cycles**, not on entries. One more logged symptom cannot
 * move a finding that is measured across three to twelve cycles, so recomputing on
 * every log would spend her battery and our function invocations to produce the
 * same rows. Once a day is already more often than the underlying data can
 * meaningfully change.
 *
 * The stamp is per-device in `localStorage` rather than in her record: it is a
 * scheduling detail, not health data, and product rule 4 says store less. The cost
 * is one extra recompute when she opens Femio on a second device, which is
 * nothing.
 *
 * ## Fire and forget, deliberately
 *
 * Nothing awaits this and no error is surfaced. The findings she can see are
 * whatever tier 1 has already written; a failed recompute means she sees the
 * previous set, which is correct rather than merely acceptable. Showing her an
 * error about a background job she did not ask for would be the intrusion.
 */

const STAMP_KEY = "femio.patterns.recomputed.v1";
const ONCE_PER_MS = 24 * 60 * 60 * 1000;

/** Enough cycles that the engine's floor (`MIN_CYCLES`) could possibly be cleared. */
const MIN_CYCLES_TO_BOTHER = 3;

export function recomputePatterns(cycleCount: number): void {
  if (typeof window === "undefined") return;
  // Below the engine's own floor every kind returns nothing, so the call is
  // guaranteed to write zero rows. Not asking is the same answer for free.
  if (cycleCount < MIN_CYCLES_TO_BOTHER) return;

  try {
    const last = Number(window.localStorage.getItem(STAMP_KEY) ?? 0);
    if (Number.isFinite(last) && Date.now() - last < ONCE_PER_MS) return;
    window.localStorage.setItem(STAMP_KEY, String(Date.now()));
  } catch {
    // Storage blocked. Recomputing every load is wasteful but harmless, and is a
    // better failure than never recomputing at all.
  }

  void createClient()
    .functions.invoke("patterns", { body: {} })
    .catch(() => {
      // Not deployed yet, offline, or failing. She sees the previous findings.
    });
}
