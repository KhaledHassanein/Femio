/**
 * Google AdSense: the ids, the script URL, and the `ads.txt` line (ADR-075, R6.8).
 *
 * Pure functions, no DOM, so the components that render ads stay a few lines and the
 * markup is testable in the unit runner. This is the one module allowed to name the
 * AdSense host (scripts/analytics-lint.mjs).
 *
 * Where ads appear is decided in docs/34_GROWTH_OPS/02_MONETIZATION.md §1.1 and encoded
 * in `./placements.ts`; this file only knows how to talk to AdSense. With no publisher
 * id the site renders no ad markup, loads no ad script and serves an `ads.txt` with no
 * sellers, so previews, tests and a site awaiting approval stay ad-free without a code
 * change.
 *
 * Consent: the AdSense script reads the Consent Mode defaults that `adsense-script.tsx`
 * sets just ahead of it (every signal denied, `./consent-mode-default.ts`), so before a
 * visitor consents it can only request non-personalised ads. The consent dialog itself
 * is AdSense's own "Privacy & messaging" (owner guide part E).
 */

/** The only ad host the privacy tripwire allows, and only from this module. */
export const ADSENSE_HOST = "pagead2.googlesyndication.com";

/**
 * Google's seller id for every AdSense publisher: the third field of the `ads.txt`
 * line. A constant, not a per-publisher value (https://support.google.com/adsense/answer/12171612).
 */
export const ADSENSE_SELLER_ID = "f08c47fec0942fa0";

/** A publisher id as AdSense shows it in the ad code: `ca-pub-` and 10 to 20 digits. */
const PUBLISHER_ID = /^ca-pub-\d{10,20}$/;

/** An ad unit's slot id: digits only. */
const SLOT_ID = /^\d{6,12}$/;

/** True for a well-formed publisher id; anything else renders nothing. */
export function isAdSenseClient(id: string | undefined | null): id is string {
  return typeof id === "string" && PUBLISHER_ID.test(id);
}

/** True for a well-formed slot id; a unit whose slot is missing or malformed is not rendered. */
export function isAdSlot(id: string | undefined | null): id is string {
  return typeof id === "string" && SLOT_ID.test(id);
}

/** The AdSense loader URL for this publisher. */
export function adsenseScriptSrc(client: string): string {
  if (!isAdSenseClient(client)) throw new Error(`adsenseScriptSrc: not a publisher id: ${String(client)}`);
  return `https://${ADSENSE_HOST}/pagead/js/adsbygoogle.js?client=${client}`;
}

/**
 * The body of `/ads.txt`. The IAB format wants the publisher id without the `ca-`
 * prefix (`pub-…`), which is how AdSense itself prints the line.
 * With no publisher id the file holds one comment and no sellers: a crawler reads it
 * as "nobody is authorised to sell this inventory", which is the truth.
 */
export function adsTxt(client: string | undefined): string {
  if (!isAdSenseClient(client)) return "# femio: no advertising configured\n";
  return `google.com, ${client.replace(/^ca-/, "")}, DIRECT, ${ADSENSE_SELLER_ID}\n`;
}

/** An AdMob publisher id as the AdMob console prints it: `pub-` and 10 to 20 digits. */
const ADMOB_PUBLISHER_ID = /^pub-\d{10,20}$/;

/** True for a well-formed AdMob publisher id. */
export function isAdMobPublisher(id: string | undefined | null): id is string {
  return typeof id === "string" && ADMOB_PUBLISHER_ID.test(id);
}

/**
 * The body of `/app-ads.txt` (ADR-076, app ads): the same IAB line, for the app's AdMob
 * publisher. AdMob reads it from the developer website named in the Play listing and
 * refuses to serve most ads until it is found. With no publisher id: one comment, no sellers.
 */
export function appAdsTxt(publisher: string | undefined): string {
  if (!isAdMobPublisher(publisher)) return "# femio: no app advertising configured\n";
  return `google.com, ${publisher}, DIRECT, ${ADSENSE_SELLER_ID}\n`;
}
