"use client";

import { useEffect, useState } from "react";
import { useTranslations } from "next-intl";
import { useRouter } from "@/i18n/navigation";
import { createClient } from "@/lib/supabase/client";
import { safeNextPath } from "@/lib/auth/mfa";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

/**
 * Step-up challenge (P1.23.3): the session is signed in but hasn't satisfied its
 * second factor, so a back-office route bounced it here. On success the session
 * becomes aal2 and we return to wherever the guard was heading.
 */
export function MfaChallenge({ next }: { next: string | null }) {
  const t = useTranslations("mfa");
  const router = useRouter();
  const supabase = createClient();

  const [factorId, setFactorId] = useState<string | null>(null);
  const [code, setCode] = useState("");
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    void (async () => {
      const { data } = await supabase.auth.mfa.listFactors();
      const verified = (data?.totp ?? []).find((f) => f.status === "verified");
      setFactorId(verified?.id ?? null);
    })();
  }, [supabase]);

  const submit = async () => {
    if (!factorId) return;
    setBusy(true);
    setError(null);
    const { data: challenge, error: challengeError } = await supabase.auth.mfa.challenge({ factorId });
    if (challengeError || !challenge) {
      setBusy(false);
      setError(t("error"));
      return;
    }
    const { error: verifyError } = await supabase.auth.mfa.verify({
      factorId,
      challengeId: challenge.id,
      code: code.trim(),
    });
    if (verifyError) {
      setBusy(false);
      setError(t("wrongCode"));
      return;
    }
    // Guarded: only a same-origin path may be used as a destination.
    router.replace(safeNextPath(next, "/dashboard"));
    router.refresh();
  };

  return (
    <div className="flex flex-col gap-4">
      {error ? (
        <Alert variant="danger">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      ) : null}

      <div className="flex flex-col gap-2">
        <Label htmlFor="mfa-challenge-code">{t("codeLabel")}</Label>
        <Input
          id="mfa-challenge-code"
          inputMode="numeric"
          autoComplete="one-time-code"
          maxLength={6}
          value={code}
          onChange={(e) => setCode(e.target.value)}
          className="max-w-[10rem] font-mono tracking-widest"
        />
      </div>

      <Button
        onClick={() => void submit()}
        disabled={busy || !factorId || code.trim().length < 6}
        className="self-start"
      >
        {busy ? t("verifying") : t("verify")}
      </Button>
    </div>
  );
}
