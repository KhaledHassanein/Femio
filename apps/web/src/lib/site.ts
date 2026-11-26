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

/**
 * The early test build (APK) for testers and hackathon judges (R14.4, REL-2, UX-1).
 *
 * `null` until the build is published as a GitHub Release; while null, `/app` shows an
 * honest "download link coming soon" card instead of a button that leads nowhere. Once
 * the release exists, its asset URL goes here and `/app` shows the download with the
 * sideload steps. Google Play closed testing is separate and comes later
 * (`PLAY_STORE_URL`).
 */
export const APK_DOWNLOAD_URL: string | null = null;
