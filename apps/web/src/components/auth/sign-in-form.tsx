"use client";

import { useState } from "react";
import { useLocale, useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import { env } from "@/lib/env";
import { Link } from "@/i18n/navigation";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { track } from "@/lib/analytics/track";
import type { Locale } from "@/i18n/routing";

type Method = "password" | "magic";

// Returning-user sign-in. Password (reliable, good for staff/admin) + passwordless
// magic link (matches anonymous-first onboarding) + optional Google OAuth. The
// magic link / OAuth / recovery all land on /api/auth/callback.
export function SignInForm({ hadError = false }: { hadError?: boolean }) {
  const t = useTranslations("signIn");
  // Typed to the app's locales so analytics props satisfy the closed catalog.
  const locale = useLocale() as Locale;
  const [method, setMethod] = useState<Method>("password");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [sentMagic, setSentMagic] = useState(false);
  const [sentReset, setSentReset] = useState(false);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(hadError ? t("error") : null);

  const googleEnabled = env.NEXT_PUBLIC_ENABLE_GOOGLE_AUTH === "true";
  const callback = (next: string) =>
    `${window.location.origin}/api/auth/callback?next=${encodeURIComponent(next)}`;

  const signInPassword = async (e: React.FormEvent) => {
    e.preventDefault();
    setBusy(true);
    setError(null);
    const { error } = await createClient().auth.signInWithPassword({ email, password });
    setBusy(false);
    // Method + outcome only. No email, no user id — the catalog has no field for
    // either, and the sign-in funnel doesn't need to know who.
    void track("signin_completed", {
      locale,
      auth_method: "email_password",
      outcome: error ? "error" : "success",
    });
    if (error) setError(error.message);
    else window.location.assign(`/${locale}/dashboard`); // full reload so SSR sees the session
  };

  const sendMagic = async (e: React.FormEvent) => {
    e.preventDefault();
    setBusy(true);
    setError(null);
    const { error } = await createClient().auth.signInWithOtp({
      email,
      options: { emailRedirectTo: callback(`/${locale}/dashboard`) },
    });
    setBusy(false);
    void track("signin_completed", {
      locale,
      auth_method: "magic_link",
      outcome: error ? "error" : "success",
    });
    if (error) setError(error.message);
    else setSentMagic(true);
  };

  const sendReset = async () => {
    if (email.length < 4) {
      setError(t("enterEmailFirst"));
      return;
    }
    setBusy(true);
    setError(null);
    const { error } = await createClient().auth.resetPasswordForEmail(email, {
      redirectTo: callback(`/${locale}/reset-password`),
    });
    setBusy(false);
    if (error) setError(error.message);
    else setSentReset(true);
  };

  const signInGoogle = async () => {
    setBusy(true);
    setError(null);
    const { error } = await createClient().auth.signInWithOAuth({
      provider: "google",
      options: { redirectTo: callback(`/${locale}/dashboard`) },
    });
    if (error) {
      setBusy(false);
      setError(error.message);
      void track("signin_completed", { locale, auth_method: "google", outcome: "error" });
    }
    // On success the browser leaves for Google, so there is no success event to
    // send from here — the redirect back lands on the dashboard, which counts as
    // an `app` area view. Deliberately not tracked twice.
  };

  if (sentMagic || sentReset) {
    return (
      <div className="flex flex-col gap-3">
        <h1 className="font-display text-2xl text-text">{t("sentHeading")}</h1>
        <p className="text-sm text-text-muted">
          {sentReset ? t("resetSentBody", { email }) : t("sentBody", { email })}
        </p>
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-5">
      <div className="flex flex-col gap-1">
        <h1 className="font-display text-2xl text-text">{t("title")}</h1>
        <p className="text-sm text-text-muted">
          {method === "password" ? t("subtitlePassword") : t("subtitle")}
        </p>
      </div>

      {error ? (
        <Alert variant="danger">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      ) : null}

      {googleEnabled ? (
        <>
          <Button type="button" variant="outline" onClick={signInGoogle} disabled={busy} className="w-full">
            {t("google")}
          </Button>
          <div className="flex items-center gap-3 text-2xs text-text-subtle">
            <span className="h-px flex-1 bg-border" />
            {t("or")}
            <span className="h-px flex-1 bg-border" />
          </div>
        </>
      ) : null}

      <form onSubmit={method === "password" ? signInPassword : sendMagic} className="flex flex-col gap-4">
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

        {method === "password" ? (
          <div className="flex flex-col gap-2">
            <div className="flex items-center justify-between">
              <Label htmlFor="password">{t("passwordLabel")}</Label>
              <button type="button" onClick={sendReset} className="text-sm text-text-link underline">
                {t("forgotPassword")}
              </button>
            </div>
            <Input
              id="password"
              type="password"
              autoComplete="current-password"
              required
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />
          </div>
        ) : null}

        <Button
          type="submit"
          disabled={busy || email.length < 4 || (method === "password" && password.length < 1)}
          className="self-start"
        >
          {busy ? t("sending") : method === "password" ? t("submitPassword") : t("submit")}
        </Button>
      </form>

      <button
        type="button"
        onClick={() => {
          setMethod((m) => (m === "password" ? "magic" : "password"));
          setError(null);
        }}
        className="self-start text-sm text-text-link underline"
      >
        {method === "password" ? t("useMagicLink") : t("usePassword")}
      </button>

      <p className="text-sm text-text-muted">
        {t("noAccount")}{" "}
        <Link href="/welcome" className="text-text-link underline">
          {t("createAccount")}
        </Link>
      </p>
    </div>
  );
}
