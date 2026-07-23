import createMiddleware from "next-intl/middleware";
import type { NextRequest } from "next/server";
import { routing } from "./i18n/routing";
import { updateSession } from "./lib/supabase/middleware";

const intlMiddleware = createMiddleware(routing);

export async function middleware(request: NextRequest) {
  // Resolve locale first (may redirect / set locale cookie), then refresh the
  // Supabase auth session onto that same response.
  const response = intlMiddleware(request);
  return updateSession(request, response);
}

export const config = {
  // Skip API, Next internals, and files with an extension.
  matcher: ["/((?!api|_next|_vercel|.*\\..*).*)"],
};
