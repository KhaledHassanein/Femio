/**
 * Transport seam.
 *
 * The guarded event layer is deliberately decoupled from the vendor, so what
 * leaves the browser is decided by our catalog rather than by an SDK's defaults.
 *
 * Two transports exist: a no-op used whenever no key is configured (still the
 * correct behaviour, not a placeholder — an analytics SDK loaded before a signed
 * DPA and a consent toggle would itself be the violation), and the PostHog
 * transport below, which loads lazily and only after consent.
 */

import type { EventName } from "./events";
import { sanitizeProperties } from "./sanitize";

export type Transport = {
  readonly name: string;
  capture(event: EventName, props: Record<string, string>): void;
};

/** Drops everything. Used whenever no key is configured. */
export const noopTransport: Transport = {
  name: "noop",
  capture() {
    // Intentionally empty.
  },
};

/**
 * The real PostHog transport (P1.20.1).
 *
 * Loaded with a **dynamic import inside `capture`**, which is the mechanism that
 * keeps docs/13 §6's promise literally rather than approximately: `track()` has
 * already passed the consent gate by the time this runs, so for a visitor who
 * never opts in the vendor script is not merely idle — it is **never fetched, and
 * no vendor code ever executes**. Initialising at module scope would break that
 * while still looking correct.
 *
 * Every option below is a deliberate subtraction:
 *   - `autocapture: false`      — would scrape DOM text: symptom labels, article titles.
 *   - session recording off     — would record health fields on screen.
 *   - `capture_pageview: false` — a pageview carries the URL, and a Femio URL is
 *                                 itself a health inference. We send a coarse `area` instead.
 *   - `persistence: localStorage` — no analytics cookies at all, so there is nothing
 *                                 to disclose in a cookie banner and nothing sent to
 *                                 other origins.
 *   - `sanitize_properties`     — drops `$current_url`/`$referrer`/UTM and anything
 *                                 else not on the allow-list (see sanitize.ts). This is
 *                                 the guard that survives an SDK upgrade adding new
 *                                 autoproperties.
 *   - `advanced_disable_decide` — skips the feature-flag round trip we don't use.
 */
export function createPostHogTransport(key: string, host: string): Transport {
  let clientPromise: Promise<{ capture: (e: string, p: Record<string, unknown>) => void } | null> | null =
    null;

  async function client() {
    if (clientPromise) return clientPromise;
    clientPromise = (async () => {
      if (typeof window === "undefined") return null; // browser-only by design
      const { default: posthog } = await import("posthog-js");
      posthog.init(key, {
        api_host: host,
        autocapture: false,
        capture_pageview: false,
        capture_pageleave: false,
        disable_session_recording: true,
        disable_surveys: true,
        advanced_disable_decide: true,
        persistence: "localStorage",
        person_profiles: "identified_only",
        sanitize_properties: (properties, _event) =>
          sanitizeProperties(properties as Record<string, unknown>, Object.keys(properties ?? {}).filter(
            (k) => !k.startsWith("$"),
          )) as typeof properties,
      });
      return posthog;
    })();
    return clientPromise;
  }

  return {
    name: "posthog",
    capture(event, props) {
      // Fire-and-forget: analytics must never delay or break a user action.
      void client().then((posthog) => posthog?.capture(event, props));
    },
  };
}

/**
 * Collects events in memory instead of sending them. Test-only seam, and the
 * mechanism the unit tests use to assert that nothing escapes without consent.
 */
export function createMemoryTransport(): Transport & {
  readonly captured: { event: EventName; props: Record<string, string> }[];
} {
  const captured: { event: EventName; props: Record<string, string> }[] = [];
  return {
    name: "memory",
    captured,
    capture(event, props) {
      captured.push({ event, props });
    },
  };
}
