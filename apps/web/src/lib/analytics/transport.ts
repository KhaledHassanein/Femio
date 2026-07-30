/**
 * Transport seam.
 *
 * The guarded event layer is deliberately decoupled from the vendor. Today no
 * PostHog project exists (P1.20.APPLY), so the only transport is a no-op and **no
 * third-party script is loaded at all** — which is the correct behaviour, not a
 * placeholder: loading an analytics SDK before there is a signed DPA and a
 * consent toggle would itself be the violation.
 *
 * When the EU key lands, P1.20.1 adds a PostHog transport behind this interface.
 * It must be created with autocapture and session recording **off** — autocapture
 * would hoover up DOM text (symptom labels, article titles) and defeat the whole
 * catalog, and session recording would capture health fields on screen.
 */

import type { EventName } from "./events";

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
