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
 *
 * ## Offline is not signed out (RB-C7)
 *
 * `getUser()` calls the auth server. Offline it fails, `user` comes back null, and
 * the first version of this component read that as *anon* and redirected — so a
 * signed-in woman who lost signal was **bounced to onboarding**, which tells her
 * her account is gone. It also made every offline state in the app unreachable:
 * she could never get to a screen to see one.
 *
 * The two cases are genuinely different and both are knowable. `getSession()`
 * reads the stored session **without a network call**, so:
 *
 * - **no stored session** → anon, whatever the network is doing. Nothing to show.
 * - **stored session, server unreachable** → show the app. Her screens then render
 *   their own offline states, which is the honest answer.
 * - **stored session, server says no** → anon. A revoked session is a real answer.
 *
 * This is safe precisely because of the paragraph above: showing the shell to
 * someone whose token cannot be *verified right now* leaks nothing, because every
 * read still goes through RLS and an invalid JWT reads nothing. The alternative —
 * treating an unreachable server as proof she is signed out — is the option that
 * actually costs something.
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

      // Local first, and no network involved: if there is no stored session there
      // is nothing to show regardless of connectivity.
      const {
        data: { session },
      } = await supabase.auth.getSession();
      if (cancelled) return;
      if (!session) {
        setGate("anon");
        return;
      }

      const { data, error } = await supabase.auth.getUser();
      if (cancelled) return;
      if (data.user) {
        setGate("authed");
        return;
      }
      // A stored session the server could not be asked about. `AuthError` carries a
      // status for a real rejection; a fetch that never reached the server has
      // none, and that is the case we must not read as "signed out".
      const unreachable = Boolean(error) && !(error as { status?: number }).status;
      setGate(unreachable ? "authed" : "anon");
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
