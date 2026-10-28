/**
 * Consent Mode v2 defaults (ADR-075, docs/34_GROWTH_OPS/01_ANALYTICS_AND_PIXELS.md §3).
 *
 * Every Google consent signal starts DENIED. Only the certified banner (AdSense
 * "Privacy & messaging", or a certified CMP) may flip a signal, and only after the
 * visitor presses Allow. `security_storage` is the one exception: it covers nothing
 * that identifies her (Google's own definition: fraud prevention, authentication) and
 * the site has neither, so granting it changes nothing while keeping the tag's
 * built-in checks consistent.
 *
 * This file is a string on purpose: it is rendered inline BEFORE the Tag Manager
 * loader, and `consent-default.test.ts` reads the object below to assert that every
 * signal is denied. Change the object, never the string; the string is derived.
 */
export const CONSENT_DEFAULTS = {
  ad_storage: "denied",
  ad_user_data: "denied",
  ad_personalization: "denied",
  analytics_storage: "denied",
  functionality_storage: "denied",
  personalization_storage: "denied",
  security_storage: "granted",
} as const;

/** How long (ms) tags wait for the banner's update before reading the defaults. */
export const CONSENT_WAIT_FOR_UPDATE_MS = 500;

/** The inline script that must run before any Google tag. */
export const CONSENT_DEFAULT_SNIPPET = [
  "window.dataLayer=window.dataLayer||[];",
  "function gtag(){dataLayer.push(arguments);}",
  `gtag('consent','default',${JSON.stringify({ ...CONSENT_DEFAULTS, wait_for_update: CONSENT_WAIT_FOR_UPDATE_MS })});`,
].join("");
