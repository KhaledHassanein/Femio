/**
 * Where an ad may appear, and nowhere else (docs/34_GROWTH_OPS/02_MONETIZATION.md §1.1).
 *
 * Three placements, each behind its own slot id so the owner can switch one off in
 * Vercel without a deploy:
 *
 *   article-mid   after the first H2 section of an article (below the fold on a phone;
 *                 never inside the warning box, the disclaimer or the sources)
 *   article-end   after the sources, before the app hand-off card
 *   hub-top       on the Learn index, after the "start here" row; on a condition hub,
 *                 after the third card (§1.1 says "after the first row"; on a 390-pixel
 *                 phone a hub list is one column and the first card is above the fold,
 *                 and "nothing above the fold on mobile" is the stronger rule)
 *
 * Calculators, help-now, legal pages and the home page carry no placement by
 * construction: there is no entry for them here and no component renders one.
 */
import { env } from "@/lib/env";
import { isAdSenseClient, isAdSlot } from "./adsense";

export type AdPlacement = "article-mid" | "article-end" | "hub-top";

/** How many hub cards precede the hub unit. */
export const HUB_UNIT_AFTER_CARDS = 3;

/** The slot id each placement reads, so a placement is one line in Vercel. */
const SLOT_FOR: Record<AdPlacement, string | undefined> = {
  "article-mid": env.NEXT_PUBLIC_ADSENSE_SLOT_ARTICLE_MID,
  "article-end": env.NEXT_PUBLIC_ADSENSE_SLOT_ARTICLE_END,
  "hub-top": env.NEXT_PUBLIC_ADSENSE_SLOT_HUB_TOP,
};

/** Everything a unit needs to render, or null when this placement is off. */
export type AdUnitConfig = { client: string; slot: string; placement: AdPlacement };

/**
 * The configuration for one placement, resolved from the environment: null when the
 * publisher id or this placement's slot is unset or malformed. Callers render nothing
 * on null, so a half-configured site never shows an empty ad box.
 */
export function adUnitConfig(placement: AdPlacement, overrides?: Partial<Record<"client" | "slot", string | undefined>>): AdUnitConfig | null {
  const client = overrides && "client" in overrides ? overrides.client : env.NEXT_PUBLIC_ADSENSE_CLIENT;
  const slot = overrides && "slot" in overrides ? overrides.slot : SLOT_FOR[placement];
  if (!isAdSenseClient(client) || !isAdSlot(slot)) return null;
  return { client, slot, placement };
}

/** True when the page should load the AdSense script at all: a publisher id is set. */
export function adsEnabled(client: string | undefined = env.NEXT_PUBLIC_ADSENSE_CLIENT): boolean {
  return isAdSenseClient(client);
}
