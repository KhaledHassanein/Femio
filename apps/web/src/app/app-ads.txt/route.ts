import { env } from "@/lib/env";
import { appAdsTxt } from "@/lib/ads/adsense";

/**
 * `/app-ads.txt` (ADR-076): the IAB file AdMob reads from the developer website named in
 * the Play listing, to confirm that this publisher may sell the app's ad inventory.
 * Built once at build time from `NEXT_PUBLIC_ADMOB_PUBLISHER`; a comment and no sellers
 * until the owner sets it.
 */
export const dynamic = "force-static";

export function GET() {
  return new Response(appAdsTxt(env.NEXT_PUBLIC_ADMOB_PUBLISHER), {
    headers: { "content-type": "text/plain; charset=utf-8" },
  });
}
