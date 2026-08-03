/**
 * Strip PostHog's automatic properties (P1.20.1).
 *
 * THIS IS THE PART THAT MATTERS. The event catalog controls what *we* send, but
 * `posthog-js` attaches its own properties to every capture — and the defaults
 * include `$current_url`, `$pathname` and `$referrer`. On Femio those are health
 * data: `/en/learn/endometriosis-symptoms` attached to a persistent `distinct_id`
 * is a health inference about a person, which is exactly what docs/13 §5 forbids
 * and exactly the pattern the FTC pursued Flo and Premom over. A closed event
 * catalog is worth nothing if the SDK quietly appends the URL to every event.
 *
 * So the allow-list runs in both directions: the catalog decides what we add, and
 * this decides what the vendor is allowed to keep. Anything not explicitly
 * permitted is dropped — including future `$…` properties added by an SDK upgrade,
 * which is why this is a deny-by-default filter rather than a list of banned keys.
 */

/**
 * PostHog-internal properties that are safe and useful to keep. All are
 * pseudonymous identifiers or coarse client facts — none can carry a URL, a
 * search term, or anything the user typed.
 */
const ALLOWED_VENDOR_PROPERTIES = new Set([
  "$device_id",
  "$session_id",
  "$window_id",
  "$browser",
  "$browser_version",
  "$os",
  "$device_type",
  "$screen_height",
  "$screen_width",
  "$viewport_height",
  "$viewport_width",
  "$lib",
  "$lib_version",
  "$time",
  "$sent_at",
  "$insert_id",
  "distinct_id",
]);

/**
 * Properties the SDK adds that must never leave, listed explicitly so the
 * *reason* is documented even though deny-by-default would already drop them.
 * Kept as a named export so the unit tests can assert each one is refused.
 */
export const FORBIDDEN_VENDOR_PROPERTIES = [
  // Any of these can carry an article slug — i.e. what she was reading.
  "$current_url",
  "$pathname",
  "$host",
  "$initial_current_url",
  "$initial_pathname",
  // Referrers leak the same thing from the other direction, plus search terms.
  "$referrer",
  "$referring_domain",
  "$initial_referrer",
  "$initial_referring_domain",
  // Campaign parameters are attacker-shaped free text and can carry anything.
  "$utm_source",
  "$utm_medium",
  "$utm_campaign",
  "$utm_content",
  "$utm_term",
  "gclid",
  "fbclid",
  // Network identifiers.
  "$ip",
] as const;

/**
 * Keep only the properties we put there plus a short vendor allow-list.
 *
 * @param props   the merged property bag PostHog is about to send
 * @param ourKeys the property names this event legitimately declares
 */
export function sanitizeProperties(
  props: Record<string, unknown>,
  ourKeys: readonly string[],
): Record<string, unknown> {
  const allowed = new Set<string>([...ourKeys, ...ALLOWED_VENDOR_PROPERTIES]);
  const out: Record<string, unknown> = {};
  for (const [key, value] of Object.entries(props)) {
    if (allowed.has(key)) out[key] = value;
  }
  return out;
}
