"use client";

import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { BottomTabs } from "@/components/app-nav";
import { webAppEnabled } from "@/lib/web-app";

/**
 * The app's tab bar on public pages, for a signed-in woman only (v3 P1.6).
 *
 * Learn is a tab now, and Learn lives in the public layout (it is the SEO surface and
 * must stay static). Without this, tapping Learn inside the app would swap her into the
 * marketing shell with no way back but the browser.
 *
 * `getSession()` reads the stored session with **no network call** (STATE.md traps:
 * offline is not signed out), so this costs nothing for a visitor and never blocks the
 * page. A visitor sees nothing: no bar, no spacer, no layout shift.
 */
export function SignedInTabs() {
  // The web app is closed (D8): no session to look for, so no Supabase client at all.
  if (!webAppEnabled()) return null;
  return <SessionTabs />;
}

function SessionTabs() {
  const [signedIn, setSignedIn] = useState(false);

  useEffect(() => {
    let live = true;
    createClient()
      .auth.getSession()
      .then(({ data }) => {
        if (live) setSignedIn(data.session != null);
      })
      .catch(() => undefined);
    return () => {
      live = false;
    };
  }, []);

  if (!signedIn) return null;
  return (
    <>
      {/* Clears the fixed bar, so the footer is not hidden beneath it. */}
      <div aria-hidden className="h-[var(--bottom-bar-clearance)] print:hidden" />
      <BottomTabs />
    </>
  );
}
