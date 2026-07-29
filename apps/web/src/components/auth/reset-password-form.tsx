"use client";

import { useEffect, useState } from "react";
import { useLocale, useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import { Link } from "@/i18n/navigation";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

// Set a new password after arriving from a recovery link (the callback established
// a recovery session). Also usable to set a first password for a passwordless
// account. On success, updateUser() persists the password and we go to the dashboard.
const MIN = 8;

export function ResetPasswordForm() {
  const t = useTranslations("resetPassword");
  const locale = useLocale();
  const [ready, setReady] = useState<boolean | null>(null); // null = checking
  const [password, setPassword] = useState("");
  const [confirm, setConfirm] = useState("");
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    createClient()
      .auth.getSession()
      .then(({ data }) => setReady(!!data.session));
  }, []);

  const submit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (password.length < MIN) return setError(t("tooShort", { min: MIN }));
    if (password !== confirm) return setError(t("mismatch"));
    setBusy(true);
    setError(null);
    const { error } = await createClient().auth.updateUser({ password });
    setBusy(false);
    if (error) setError(error.message);
    else window.location.assign(`/${locale}/dashboard`);
  };

  if (ready === null) return <p className="text-sm text-text-muted">{t("checking")}</p>;

  if (!ready) {
    return (
      <div className="flex flex-col gap-3">
        <h1 className="font-display text-2xl text-text">{t("expiredHeading")}</h1>
        <p className="text-sm text-text-muted">{t("expiredBody")}</p>
        <Link href="/sign-in" className="text-sm text-text-link underline">
          {t("backToSignIn")}
        </Link>
      </div>
    );
  }

  return (
    <form onSubmit={submit} className="flex flex-col gap-4">
      <div className="flex flex-col gap-1">
        <h1 className="font-display text-2xl text-text">{t("title")}</h1>
        <p className="text-sm text-text-muted">{t("subtitle")}</p>
      </div>
      <div className="flex flex-col gap-2">
        <Label htmlFor="new-password">{t("newPassword")}</Label>
        <Input
          id="new-password"
          type="password"
          autoComplete="new-password"
          required
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />
      </div>
      <div className="flex flex-col gap-2">
        <Label htmlFor="confirm-password">{t("confirmPassword")}</Label>
        <Input
          id="confirm-password"
          type="password"
          autoComplete="new-password"
          required
          value={confirm}
          onChange={(e) => setConfirm(e.target.value)}
        />
      </div>
      {error ? (
        <Alert variant="danger">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      ) : null}
      <Button type="submit" disabled={busy} className="self-start">
        {busy ? t("saving") : t("save")}
      </Button>
    </form>
  );
}
