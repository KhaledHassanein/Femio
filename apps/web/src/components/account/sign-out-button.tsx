"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import { Button } from "@/components/ui/button";

/**
 * Sign out, moved here from the app nav (P1.28.1). Nothing about the behaviour
 * changed — `supabase.auth.signOut()` then home.
 */
export function SignOutButton() {
  const t = useTranslations("appNav");
  const router = useRouter();
  const [busy, setBusy] = useState(false);

  const signOut = async () => {
    setBusy(true);
    const supabase = createClient();
    await supabase.auth.signOut();
    router.push("/");
  };

  return (
    <Button variant="outline" className="self-start" onClick={signOut} disabled={busy}>
      {t("signOut")}
    </Button>
  );
}
