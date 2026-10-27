import createMiddleware from "next-intl/middleware";
import { routing } from "./i18n/routing";

/**
 * Locale routing only. The website holds no session and makes no database call:
 * the web tracker was removed on 2026-10-27 (docs/33_REBUILD_V3). Old tracker
 * URLs are redirected to the app page in `vercel.json`, not here, so a page view
 * never runs code it does not need.
 */
export default createMiddleware(routing);

export const config = {
  // Skip API, Next internals, and files with an extension.
  matcher: ["/((?!api|_next|_vercel|.*\\..*).*)"],
};
