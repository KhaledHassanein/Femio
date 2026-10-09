import type { ReactNode } from "react";
import { setRequestLocale } from "next-intl/server";
import { SiteHeader } from "@/components/site/site-header";
import { SiteFooter } from "@/components/site/site-footer";
import { SignedInTabs } from "@/components/signed-in-tabs";

// Shell for the public content site (home + library). A persistent header/footer
// wrap every marketing/content page. The signed-in app ((app) group) and the
// minimal auth/onboarding/crisis pages keep their own layouts.
//
// `setRequestLocale` here is load-bearing, not ceremony (P0.6). A layout renders
// independently of its page, so without it the header and footer had no request
// locale and next-intl fell back to reading `headers()`. That is invisible while
// every page renders per request, and it turns every cached (ISR) render into a
// DYNAMIC_SERVER_USAGE 500 the moment a page stops being `force-dynamic`. The
// locale is also passed down explicitly, so the header and footer never depend on
// render order.
export default async function PublicLayout({
  children,
  params,
}: {
  children: ReactNode;
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  setRequestLocale(locale);
  return (
    <div className="flex min-h-dvh flex-col">
      <SiteHeader locale={locale} />
      {/* The skip link's target: past the header, onto the page's own content. */}
      <div id="content" tabIndex={-1} className="flex flex-1 flex-col outline-none">
        {children}
      </div>
      <SiteFooter locale={locale} />
      <SignedInTabs />
    </div>
  );
}
