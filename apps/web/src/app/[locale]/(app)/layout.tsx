import type { ReactNode } from "react";
import { NextIntlClientProvider } from "next-intl";
import { getLocale, getMessages } from "next-intl/server";
import { pickAppClientMessages } from "@/i18n/client-namespaces";
import { AppNav } from "@/components/app-nav";
import { OfflineSync } from "@/components/offline-sync";
import { PageView } from "@/components/analytics/page-view";

// Shell for the signed-in app pages (dashboard / track / settings). The route
// group keeps the URLs unchanged. Auth is enforced per-page (AuthGate).
//
// This layout carries a SECOND `NextIntlClientProvider`, and that is the whole
// reason the tracker's strings stay off the public content pages: the root layout
// ships only the public namespaces, and the app's are added here, inside the route
// group that needs them. Without this the `/learn` HTML grew by ~12 KB — caught by
// the page-weight budget in e2e, not by anything in the build (P1.11.2, ADR-048).
export default async function AppLayout({ children }: { children: ReactNode }) {
  const messages = pickAppClientMessages(await getMessages());
  // A nested provider *replaces* the context rather than extending it, so it has to
  // carry the locale too — otherwise it would undo the root layout's fix for every
  // signed-in page. See the comment there for what that costs.
  const locale = await getLocale();
  return (
    <NextIntlClientProvider locale={locale} messages={messages}>
      <PageView area="app" />
      <AppNav />
      <OfflineSync />
      {/* Clears the fixed tab bar. Without it the last card on every screen sits
          under the bar and looks like the page is cut off. */}
      <div className="pb-bottom-bar print:pb-0">{children}</div>
    </NextIntlClientProvider>
  );
}
