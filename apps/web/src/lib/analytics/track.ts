/**
 * The public analytics API.
 *
 * Every call passes three independent gates, in this order, and any one of them
 * closing means nothing is sent:
 *
 *   1. **Configured** — a PostHog EU key exists. None does yet, so today every
 *      call is a no-op and no vendor script loads (P1.20.APPLY).
 *   2. **Consented** — the user granted the `analytics` purpose. Fails closed.
 *   3. **Allowlisted** — the payload passes `guardEvent` against the closed
 *      catalog.
 *
 * The ordering matters for privacy, not just cost: the consent check must never
 * gate on something that has already left the browser, so the send is the last
 * thing that happens, after both the config and consent answers are known.
 */

import { env } from "@/lib/env";
import type { EventName, EventProps } from "./events";
import { guardEvent } from "./guard";
import { hasAnalyticsConsent } from "./consent";
import { noopTransport, type Transport } from "./transport";

export type TrackDeps = {
  /** Overridden in tests; production resolves from the configured key. */
  transport?: Transport;
  /** Overridden in tests to avoid a Supabase round-trip. */
  consent?: () => Promise<boolean>;
  /** Overridden in tests; production reads the validated env. */
  isConfigured?: () => boolean;
};

export type TrackOutcome =
  | { sent: true }
  | { sent: false; reason: "not_configured" | "no_consent" | "rejected"; detail?: string };

export function isAnalyticsConfigured(): boolean {
  return Boolean(env.NEXT_PUBLIC_POSTHOG_KEY);
}

/**
 * Records a product event, if all three gates allow it.
 *
 * Returns the outcome rather than throwing: analytics is never important enough
 * to break a page, and the return value is what makes the gates testable. Callers
 * can safely ignore it (`void track(...)`).
 */
export async function track<E extends EventName>(
  event: E,
  props: EventProps<E>,
  deps: TrackDeps = {},
): Promise<TrackOutcome> {
  const configured = (deps.isConfigured ?? isAnalyticsConfigured)();
  if (!configured) return { sent: false, reason: "not_configured" };

  const consented = await (deps.consent ?? hasAnalyticsConsent)();
  if (!consented) return { sent: false, reason: "no_consent" };

  const guarded = guardEvent(event, props as Record<string, unknown>);
  if (!guarded.ok) {
    // A rejected payload is a bug in the caller, so make it loud in development
    // while staying silent (and harmless) in production.
    if (process.env.NODE_ENV !== "production") {
      console.error(`[analytics] dropped event: ${guarded.reason}`);
    }
    return { sent: false, reason: "rejected", detail: guarded.reason };
  }

  const transport = deps.transport ?? noopTransport;
  transport.capture(guarded.name, guarded.props);
  return { sent: true };
}
