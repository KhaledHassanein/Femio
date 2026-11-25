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

export const PLAY_STORE_URL: string | null = null;
