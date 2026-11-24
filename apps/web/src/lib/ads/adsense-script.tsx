import { adsenseScriptSrc } from "./adsense";
import { CONSENT_DEFAULT_SNIPPET } from "./consent-mode-default";
import { adsEnabled } from "./placements";

/** Id of the AdSense loader element, so a page with several units loads it once. */
export const ADSENSE_LOADER_ID = "femio-adsense-loader";

/**
 * One inline script: set the Consent Mode defaults (every signal denied), THEN add the
 * AdSense loader. A single script makes the order certain: a separate `<script async>`
 * element may be hoisted into the head by React 19 and run before the defaults, which
 * would let AdSense start without them (ADR-080). The client id is validated by
 * `adsEnabled` (`ca-pub-` + digits) and JSON-encoded, so nothing can break out of it.
 */
export function adsenseLoaderSnippet(client: string): string {
  return [
    CONSENT_DEFAULT_SNIPPET,
    `if(!document.getElementById(${JSON.stringify(ADSENSE_LOADER_ID)})){`,
    "var s=document.createElement('script');",
    `s.id=${JSON.stringify(ADSENSE_LOADER_ID)};s.async=true;s.crossOrigin='anonymous';`,
    `s.src=${JSON.stringify(adsenseScriptSrc(client))};`,
    "document.head.appendChild(s);}",
  ].join("");
}

/**
 * Loads AdSense on a page that carries at least one ad unit (R6.8), after the Consent
 * Mode defaults. Server component: one inline script or nothing.
 *
 * It is rendered by the content components (article, hub, Learn) and never by the root
 * layout: calculators, help-now, legal pages and the home page must not load it
 * (02_MONETIZATION.md §1.1), and the cheapest way to make that true is for those
 * pages to have no path to this component.
 */
export function AdSenseScript({ client }: { client: string | undefined }) {
  if (!adsEnabled(client) || client === undefined) return null;
  return <script id="femio-consent-mode-default" dangerouslySetInnerHTML={{ __html: adsenseLoaderSnippet(client) }} />;
}
