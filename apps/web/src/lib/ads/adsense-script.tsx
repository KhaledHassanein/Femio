import { adsenseScriptSrc } from "./adsense";
import { adsEnabled } from "./placements";

/**
 * Loads the AdSense script on a page that carries at least one ad unit (R6.8).
 * Server component: one static `<script async>` or nothing. React hoists an async
 * external script to the head and renders a given `src` once, so a page with two
 * units still loads the script once.
 *
 * It is rendered by the content components (article, hub) and never by the root
 * layout: calculators, help-now, legal pages and the home page must not load it
 * (02_MONETIZATION.md §1.1), and the cheapest way to make that true is for those
 * pages to have no path to this component.
 */
export function AdSenseScript({ client }: { client: string | undefined }) {
  if (!adsEnabled(client) || client === undefined) return null;
  return <script async src={adsenseScriptSrc(client)} crossOrigin="anonymous" />;
}
