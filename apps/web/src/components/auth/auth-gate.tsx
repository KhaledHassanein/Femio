"use client";

import { useEffect, useState } from "react";
import { useRouter } from "@/i18n/navigation";
import { createClient } from "@/lib/supabase/client";

type Gate = "checking" | "authed" | "anon";

/**
 * Client-side replacement for the server `redirect()` that used to guard every
 * tracker screen (P4.0, ADR-048).
 *
 * On the web a signed-out visitor was bounced before any HTML was sent. On a device
 * there is no server to do that, so the check has to happen after the bundle boots.
 * That is a real difference and it is why this renders **nothing** while checking:
 * flashing a dashboard shell at someone who is not signed in, in a health app, is a
 * privacy tell even when it holds no data — it says a session exists here.
 *
 * This is not the security boundary. RLS is: every table is row-scoped in Postgres,
 * so an unauthenticated client that skipped this component would still read nothing.
 * This decides what to *show*, which is why it can safely live in the browser.
 */
export function AuthGate({
  children,
  redirectTo = "/welcome",
}: {
  children: React.ReactNode;
  redirectTo?: string;
}) {
  const router = useRouter();
  const [gate, setGate] = useState<Gate>("checking");

  useEffect(() => {
    let cancelled = false;
    void (async () => {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (cancelled) return;
      setGate(user ? "authed" : "anon");
    })();
    return () => {
      cancelled = true;
    };
  }, []);

  useEffect(() => {
    if (gate === "anon") router.replace(redirectTo);
  }, [gate, redirectTo, router]);

  if (gate !== "authed") return null;
  return <>{children}</>;
}
