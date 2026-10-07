import type { ReactNode } from "react";
import { SiteHeader } from "@/components/site/site-header";
import { SiteFooter } from "@/components/site/site-footer";
import { SignedInTabs } from "@/components/signed-in-tabs";

// Shell for the public content site (home + library). A persistent header/footer
// wrap every marketing/content page. The signed-in app ((app) group) and the
// minimal auth/onboarding/crisis pages keep their own layouts.
export default function PublicLayout({ children }: { children: ReactNode }) {
  return (
    <div className="flex min-h-dvh flex-col">
      <SiteHeader />
      {children}
      <SiteFooter />
      <SignedInTabs />
    </div>
  );
}
