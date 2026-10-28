/**
 * Google Tag Manager loader markup (ADR-075). Pure functions so the component that
 * renders them stays a few lines and the markup is testable without a DOM.
 *
 * The container is the only third-party script the site adds: GA4, the Meta Pixel
 * and, later, AdSense ride inside it and each waits for its consent signal (set up
 * in the container by the owner, docs/34_GROWTH_OPS/04_OWNER_GUIDE_GROWTH_A_TO_Z.md
 * part D). With no container id the site renders nothing at all: preview builds,
 * tests and a declined ADR all stay collection-free.
 */
import { CONSENT_DEFAULT_SNIPPET } from "./consent-default";

/** The only host the privacy tripwire allows, and only from this module. */
export const GTM_HOST = "www.googletagmanager.com";

const GTM_ID = /^GTM-[A-Z0-9]{4,12}$/;

/** True for a well-formed container id; anything else renders nothing. */
export function isGtmId(id: string | undefined | null): id is string {
  return typeof id === "string" && GTM_ID.test(id);
}

/** Google's standard loader, with the consent defaults prepended in the same script. */
export function gtmInlineScript(id: string): string {
  if (!isGtmId(id)) throw new Error(`gtmInlineScript: not a container id: ${String(id)}`);
  const loader =
    "(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':new Date().getTime(),event:'gtm.js'});" +
    "var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;" +
    `j.src='https://${GTM_HOST}/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer','${id}');`;
  return CONSENT_DEFAULT_SNIPPET + loader;
}

/** The no-JavaScript fallback Google documents; harmless, kept for parity with the console's snippet. */
export function gtmNoScriptSrc(id: string): string {
  if (!isGtmId(id)) throw new Error(`gtmNoScriptSrc: not a container id: ${String(id)}`);
  return `https://${GTM_HOST}/ns.html?id=${id}`;
}
