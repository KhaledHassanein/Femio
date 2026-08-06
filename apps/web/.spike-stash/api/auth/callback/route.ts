import { NextResponse, type NextRequest } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { routing } from "@/i18n/routing";

// Magic-link / OTP callback (P1.12.1). Supabase emails a link to this route with a
// `code` (PKCE); we exchange it for a session (cookies set via the SSR client) and
// redirect to `next`. Lives under /api so the i18n middleware doesn't locale-prefix it.

/** Only allow same-origin app paths as the post-login destination (no open redirect). */
function safeNext(next: string | null): string {
  if (next && next.startsWith("/") && !next.startsWith("//")) return next;
  return `/${routing.defaultLocale}/dashboard`;
}

export async function GET(request: NextRequest) {
  const { searchParams, origin } = new URL(request.url);
  const code = searchParams.get("code");
  const next = safeNext(searchParams.get("next"));

  if (code) {
    const supabase = await createClient();
    const { error } = await supabase.auth.exchangeCodeForSession(code);
    if (!error) return NextResponse.redirect(`${origin}${next}`);
  }

  // No code, or exchange failed → back to sign-in with an error flag.
  const locale = next.split("/")[1] || routing.defaultLocale;
  return NextResponse.redirect(`${origin}/${locale}/sign-in?error=1`);
}
