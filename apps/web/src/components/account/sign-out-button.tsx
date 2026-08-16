"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import { Button } from "@/components/ui/button";
import { clearExperienceCache } from "@/lib/experience/client";
import { clearOfferDismissals } from "@/components/experience/persona-offer";

/**
 * Sign out, moved here from the app nav (P1.28.1).
 *
 * Also clears the cached `ExperienceConfig` (R2.4). That document carries her
 * `modifiers` — her recorded conditions — so it is health data in `localStorage`,
 * and it must not outlive the session on a shared device. Cleared *before* the
 * sign-out call, so a failure there cannot leave it behind.
 */
export function SignOutButton() {
  const t = useTranslations("appNav");
  const router = useRouter();
  const [busy, setBusy] = useState(false);

  const signOut = async () => {
    setBusy(true);
    clearExperienceCache();
    // Her dismissals are hers, not the next person's on a shared device.
    clearOfferDismissals();
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
