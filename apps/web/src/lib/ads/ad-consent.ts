/**
 * "Ads only after you allow them" (privacy notice, ADR-075): the one place that decides
 * whether an ad unit may be filled.
 *
 * Consent Mode v2 is the signal. The page starts with every signal denied
 * (`lib/consent/consent-default.ts`); when the visitor taps Allow, the consent tool calls
 * `gtag('consent', 'update', { ad_storage: 'granted', … })`, which lands in `dataLayer`.
 * This module only READS that queue: it never pushes, so the tripwire's allow-list for
 * `dataLayer.push` stays as it is. A unit is filled when, and only when, an update that
 * grants `ad_storage` has been seen. No dataLayer, no update, or a visitor who declined:
 * the unit stays empty and invisible, and the notice stays true.
 *
 * Consequence the owner must know (dashboard item `consent-banner`): the consent tool has
 * to show its dialog to every visitor and update consent mode, or non-EEA readers never
 * see an ad. AdSense's own "Privacy & messaging" shows the GDPR message in the EEA, the
 * UK and Switzerland only; a certified tool shown everywhere is route B of the owner guide.
 */

type ConsentState = Record<string, unknown>;

/**
 * True when one dataLayer entry is `gtag('consent', 'update', {...})` with `ad_storage`
 * granted. gtag queues its `arguments` object (array-like, not an array), so both shapes
 * are accepted.
 */
export function consentUpdateGrantsAds(entry: unknown): boolean {
  if (entry === null || typeof entry !== "object" || !("length" in entry)) return false;
  const args = Array.from(entry as ArrayLike<unknown>);
  if (args[0] !== "consent" || args[1] !== "update") return false;
  const state = args[2];
  if (state === null || typeof state !== "object") return false;
  return (state as ConsentState).ad_storage === "granted";
}

/** True when any entry of the queue grants ads. The latest update wins, so a later denial revokes. */
export function queueGrantsAds(queue: unknown): boolean {
  if (!Array.isArray(queue)) return false;
  let granted = false;
  for (const entry of queue) {
    if (entry === null || typeof entry !== "object" || !("length" in entry)) continue;
    const args = Array.from(entry as ArrayLike<unknown>);
    if (args[0] !== "consent" || args[1] !== "update") continue;
    const state = args[2];
    if (state === null || typeof state !== "object") continue;
    const value = (state as ConsentState).ad_storage;
    if (value === "granted") granted = true;
    else if (value === "denied") granted = false;
  }
  return granted;
}

/** How often the queue is re-read while waiting for the visitor's answer. */
export const AD_CONSENT_POLL_MS = 1000;

/**
 * Calls `onGranted` once, as soon as the queue grants ads (now, or later when the visitor
 * taps Allow). Polling is deliberate: it needs no hook into gtag, creates no dataLayer
 * when none exists, and stops the moment the answer arrives or the unit unmounts.
 * Returns the function that stops waiting.
 */
export function waitForAdConsent(onGranted: () => void, read: () => unknown = () => (window as Window & { dataLayer?: unknown }).dataLayer): () => void {
  if (queueGrantsAds(read())) {
    onGranted();
    return () => {};
  }
  const timer = setInterval(() => {
    if (!queueGrantsAds(read())) return;
    clearInterval(timer);
    onGranted();
  }, AD_CONSENT_POLL_MS);
  return () => clearInterval(timer);
}
