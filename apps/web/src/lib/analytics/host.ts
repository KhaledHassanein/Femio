/**
 * PostHog host validation.
 *
 * Health-adjacent product data must stay in the EU (docs/13 §6, DATA_MAP). PostHog
 * runs separate US and EU clouds and the US host is the SDK default, so a missing
 * or copy-pasted host silently ships an international transfer with no mechanism
 * behind it. A non-EU value therefore FAILS THE BUILD (env.ts) rather than
 * shipping — the same posture as the crisis directory link.
 *
 * Kept as a standalone pure function so it is unit tested independently of env.
 */
export const POSTHOG_EU_HOSTS = ["eu.i.posthog.com", "eu.posthog.com"] as const;

export function isApprovedPostHogHost(value: string): boolean {
  let parsed: URL;
  try {
    parsed = new URL(value);
  } catch {
    return false;
  }
  return (
    parsed.protocol === "https:" &&
    (POSTHOG_EU_HOSTS as readonly string[]).includes(parsed.hostname) &&
    parsed.search === "" &&
    parsed.hash === ""
  );
}
