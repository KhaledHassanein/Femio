import type { ReactNode } from "react";
import { AppNav } from "@/components/app-nav";
import { OfflineSync } from "@/components/offline-sync";
import { PageView } from "@/components/analytics/page-view";

// Shell for the signed-in app pages (dashboard / track / settings). The route
// group keeps the URLs unchanged. Auth is enforced per-page (each redirects).
export default function AppLayout({ children }: { children: ReactNode }) {
  return (
    <>
      <PageView area="app" />
      <AppNav />
      <OfflineSync />
      {children}
    </>
  );
}
