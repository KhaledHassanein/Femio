"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";

export function DeleteButton() {
  const t = useTranslations("settings");
  const router = useRouter();
  const [confirming, setConfirming] = useState(false);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const del = async () => {
    setBusy(true);
    setError(null);
    const supabase = createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) {
      router.push("/");
      return;
    }
    // Prefer the RPC (removes the auth user + cascades everything). If it isn't
    // deployed yet, fall back to deleting the profile row, which cascades all
    // health data via ON DELETE CASCADE.
    const rpc = await supabase.rpc("delete_account");
    let deleteError = rpc.error;
    if (deleteError) {
      const res = await supabase.from("profiles").delete().eq("id", user.id);
      deleteError = res.error;
    }
    if (deleteError) {
      setError(deleteError.message);
      setBusy(false);
      return;
    }
    await supabase.auth.signOut();
    router.push("/");
  };

  if (!confirming) {
    return (
      <Button variant="outline" onClick={() => setConfirming(true)} className="self-start">
        {t("delete.button")}
      </Button>
    );
  }

  return (
    <div className="flex flex-col gap-3">
      <Alert variant="danger">
        <AlertDescription>{t("delete.confirm")}</AlertDescription>
      </Alert>
      {error ? (
        <Alert variant="danger">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      ) : null}
      <div className="flex gap-2">
        <Button variant="ghost" onClick={() => setConfirming(false)} disabled={busy}>
          {t("delete.cancel")}
        </Button>
        <Button variant="accent" onClick={del} disabled={busy}>
          {busy ? t("deleting") : t("delete.confirmButton")}
        </Button>
      </div>
    </div>
  );
}
