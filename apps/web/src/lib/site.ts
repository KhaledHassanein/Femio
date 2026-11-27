/**
 * Site-wide constants for the public website.
 *
 * `APP_PAGE` is where every "Get the app" call to action points. It used to live
 * in `lib/web-app.ts` beside the switch that closed the web tracker; the tracker
 * is gone (2026-10-27), the page stays.
 *
 * `PLAY_STORE_URL` is `null` until the app is listed. While null every hand-off
 * button sends to the app page, which explains what is coming; once the listing
 * exists the URL goes here, in one place, and every button follows: the hand-off card,
 * the badge on /app and the line under the home hero all read it (2026-11 SEO audit).
 */
export const APP_PAGE = "/app";

/**
 * femio's Google Play listing (owner 2026-11-27: the app is distributed through Play, and
 * every download link on the site goes to this listing). Play serves the page only once a
 * production or open-testing release is approved; before that it answers "not found". So
 * the links follow it only when `PLAY_LISTING_LIVE` is true: flip that one line on the day
 * Play shows the listing, and the hand-off card, the /app badge and the home line all switch.
 */
export const PLAY_LISTING_URL = "https://play.google.com/store/apps/details?id=com.femioapp.femio";
export const PLAY_LISTING_LIVE = false;

export const PLAY_STORE_URL: string | null = PLAY_LISTING_LIVE ? PLAY_LISTING_URL : null;

/**
 * An early test build (APK) for hackathon judges only (R14.4, REL-2, UX-1). The owner ruled
 * on 2026-11-27 that femio is distributed through Google Play, not as an APK: while this is
 * `null`, `/app` shows no APK card at all. Set it only if a judge-only build is published.
 */
export const APK_DOWNLOAD_URL: string | null = null;
