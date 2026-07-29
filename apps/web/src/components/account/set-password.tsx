"use client";

import { useState } from "react";
import { useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

// Lets a signed-in user set or change a password (e.g. after passwordless
// onboarding), so they can sign in with a password next time.
const MIN = 8;

export function SetPassword() {
  const t = useTranslations("settings.password");
  const [password, setPassword] = useState("");
  const [confirm, setConfirm] = useState("");
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [done, setDone] = useState(false);

  const submit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (password.length < MIN) return setError(t("tooShort", { min: MIN }));
    if (password !== confirm) return setError(t("mismatch"));
    setBusy(true);
    setError(null);
    setDone(false);
    const { error } = await createClient().auth.updateUser({ password });
    setBusy(false);
    if (error) setError(error.message);
    else {
      setDone(true);
      setPassword("");
      setConfirm("");
    }
  };

  return (
    <form onSubmit={submit} className="flex flex-col gap-3">
      <div className="flex flex-col gap-2">
        <Label htmlFor="set-password">{t("newPassword")}</Label>
        <Input
          id="set-password"
          type="password"
          autoComplete="new-password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />
      </div>
      <div className="flex flex-col gap-2">
        <Label htmlFor="set-password-confirm">{t("confirmPassword")}</Label>
        <Input
          id="set-password-confirm"
          type="password"
          autoComplete="new-password"
          value={confirm}
          onChange={(e) => setConfirm(e.target.value)}
        />
      </div>
      {error ? (
        <Alert variant="danger">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      ) : null}
      {done ? (
        <Alert variant="info">
          <AlertDescription>{t("saved")}</AlertDescription>
        </Alert>
      ) : null}
      <Button type="submit" disabled={busy || password.length < 1} className="self-start">
        {busy ? t("saving") : t("save")}
      </Button>
    </form>
  );
}
