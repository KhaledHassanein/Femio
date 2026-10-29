import { env } from "@/lib/env";
import { adsTxt } from "@/lib/ads/adsense";

/**
 * `/ads.txt` (R6.8): the IAB file that tells ad buyers who may sell this site's
 * inventory. AdSense requires it at the domain root and warns in the console
 * until it is found.
 *
 * Built once at build time from `NEXT_PUBLIC_ADSENSE_CLIENT`, so it is a file on the
 * CDN like every other page. Without a publisher id it holds a comment and no sellers,
 * which is the truthful answer while the site awaits AdSense approval.
 */
export const dynamic = "force-static";

export function GET() {
  return new Response(adsTxt(env.NEXT_PUBLIC_ADSENSE_CLIENT), {
    headers: { "content-type": "text/plain; charset=utf-8" },
  });
}
