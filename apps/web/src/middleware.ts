import createMiddleware from "next-intl/middleware";
import { NextResponse, type NextRequest } from "next/server";
import { routing } from "./i18n/routing";
import { updateSession } from "./lib/supabase/middleware";
import { APP_PAGE, webAppEnabled, webAppSegment } from "./lib/web-app";

const intlMiddleware = createMiddleware(routing);

export async function middleware(request: NextRequest) {
  if (!webAppEnabled()) {
    // The web app is closed (D8): its routes lead to the page that links the Android
    // app, and no request refreshes a Supabase session, so a page view makes no
    // database call at all.
    const { locale, segment } = webAppSegment(request.nextUrl.pathname, routing.locales);
    if (segment) {
      const url = new URL(`/${locale ?? routing.defaultLocale}${APP_PAGE}`, request.url);
      return NextResponse.redirect(url, 307);
    }
    return intlMiddleware(request);
  }

  // Resolve locale first (may redirect / set locale cookie), then refresh the
  // Supabase auth session onto that same response.
  const response = intlMiddleware(request);
  return updateSession(request, response);
}

export const config = {
  // Skip API, Next internals, and files with an extension.
  matcher: ["/((?!api|_next|_vercel|.*\\..*).*)"],
};
