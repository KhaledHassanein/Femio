"use client";

import { useState } from "react";
import { useLocale, useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import { Link } from "@/i18n/navigation";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

// Passwordless sign-in for returning users. Onboarding links an email without a
// password (updateUser), so the return path is a magic link (signInWithOtp) that
// lands on /api/auth/callback.
export function SignInForm({ hadError = false }: { hadError?: boolean }) {
  const t = useTranslations("signIn");
  const locale = useLocale();
  const [email, setEmail] = useState("");
  const [sent, setSent] = useState(false);
  const [sending, setSending] = useState(false);
  const [error, setError] = useState<string | null>(hadError ? t("error") : null);

  const submit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSending(true);
    setError(null);
    const supabase = createClient();
    const next = `/${locale}/dashboard`;
    const emailRedirectTo = `${window.location.origin}/api/auth/callback?next=${encodeURIComponent(next)}`;
    const { error } = await supabase.auth.signInWithOtp({ email, options: { emailRedirectTo } });
    setSending(false);
    if (error) setError(error.message);
    else setSent(true);
  };

  if (sent) {
    return (
      <div className="flex flex-col gap-3">
        <h1 className="font-display text-2xl text-text">{t("sentHeading")}</h1>
        <p className="text-sm text-text-muted">{t("sentBody", { email })}</p>
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
        <Label htmlFor="email">{t("emailLabel")}</Label>
        <Input
          id="email"
          type="email"
          autoComplete="email"
          required
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />
      </div>

      {error ? (
        <Alert variant="danger">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      ) : null}

      <Button type="submit" disabled={sending || email.length < 4} className="self-start">
        {sending ? t("sending") : t("submit")}
      </Button>

      <p className="text-sm text-text-muted">
        {t("noAccount")}{" "}
        <Link href="/welcome" className="text-text-link underline">
          {t("createAccount")}
        </Link>
      </p>
    </form>
  );
}
