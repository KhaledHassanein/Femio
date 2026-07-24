"use client";

import { useState } from "react";
import { useLocale, useTranslations } from "next-intl";
import { useRouter } from "@/i18n/navigation";
import type { Locale } from "@/i18n/routing";
import { completeOnboarding } from "@/lib/onboarding/complete";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { cn } from "@/lib/utils";

type Mode = "cycle" | "ttc" | "pregnancy" | "menopause";
type Account = "anonymous" | "email";

const MODES: readonly Mode[] = ["cycle", "ttc", "pregnancy", "menopause"];
const TOTAL_STEPS = 3;

function ConsentRow({
  checked,
  onChange,
  disabled,
  label,
}: {
  checked: boolean;
  onChange?: (v: boolean) => void;
  disabled?: boolean;
  label: string;
}) {
  return (
    <label className="flex items-start gap-3 text-sm text-text">
      <input
        type="checkbox"
        className="mt-0.5 size-5 shrink-0 accent-primary-solid"
        checked={checked}
        disabled={disabled}
        onChange={(e) => onChange?.(e.target.checked)}
      />
      <span>{label}</span>
    </label>
  );
}

export function OnboardingWizard() {
  const t = useTranslations("onboarding");
  const locale = useLocale() as Locale;
  const router = useRouter();
  const [step, setStep] = useState(1);
  const [mode, setMode] = useState<Mode | null>(null);
  const [account, setAccount] = useState<Account>("anonymous");
  const [email, setEmail] = useState("");
  const [insights, setInsights] = useState(false);
  const [research, setResearch] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const canAdvance =
    step === 1 ? mode !== null : step === 2 ? account === "anonymous" || email.length > 3 : true;

  const finish = async () => {
    if (!mode) return;
    setSubmitting(true);
    setError(null);
    const res = await completeOnboarding({
      mode,
      email: account === "email" ? email : undefined,
      insights,
      research,
      locale,
    });
    if (res.ok) {
      router.push("/dashboard");
    } else {
      setError(res.error);
      setSubmitting(false);
    }
  };

  return (
    <div className="mx-auto flex w-full max-w-xl flex-col gap-6 px-6 py-12">
      <div className="flex flex-col gap-1">
        <p className="text-sm text-text-subtle">{t("stepOf", { current: step, total: TOTAL_STEPS })}</p>
        <h1 className="font-display text-2xl text-text">{t("title")}</h1>
      </div>

      {step === 1 ? (
        <section className="flex flex-col gap-4">
          <div className="flex flex-col gap-1">
            <h2 className="text-md font-semibold text-text">{t("mode.heading")}</h2>
            <p className="text-sm text-text-muted">{t("mode.subheading")}</p>
          </div>
          <div className="grid gap-3 sm:grid-cols-2">
            {MODES.map((m) => (
              <button
                key={m}
                type="button"
                onClick={() => setMode(m)}
                aria-pressed={mode === m}
                className={cn(
                  "rounded-md border p-4 text-start transition-colors",
                  mode === m
                    ? "border-primary bg-primary-soft"
                    : "border-border bg-surface hover:bg-surface-sunken",
                )}
              >
                <p className="font-semibold text-text">{t(`mode.${m}.name`)}</p>
                <p className="text-sm text-text-muted">{t(`mode.${m}.desc`)}</p>
              </button>
            ))}
          </div>
        </section>
      ) : null}

      {step === 2 ? (
        <section className="flex flex-col gap-5">
          <div className="flex flex-col gap-1">
            <h2 className="text-md font-semibold text-text">{t("privacy.heading")}</h2>
            <p className="text-sm text-text-muted">{t("privacy.intro")}</p>
          </div>
          <div className="grid gap-3 sm:grid-cols-2">
            {(["anonymous", "email"] as const).map((a) => (
              <button
                key={a}
                type="button"
                onClick={() => setAccount(a)}
                aria-pressed={account === a}
                className={cn(
                  "rounded-md border p-4 text-start transition-colors",
                  account === a
                    ? "border-primary bg-primary-soft"
                    : "border-border bg-surface hover:bg-surface-sunken",
                )}
              >
                <p className="font-semibold text-text">
                  {t(a === "anonymous" ? "privacy.anonymous.name" : "privacy.account.name")}
                </p>
                <p className="text-sm text-text-muted">
                  {t(a === "anonymous" ? "privacy.anonymous.desc" : "privacy.account.desc")}
                </p>
              </button>
            ))}
          </div>
          {account === "email" ? (
            <div className="flex flex-col gap-2">
              <Label htmlFor="email">{t("privacy.emailLabel")}</Label>
              <Input
                id="email"
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
              />
            </div>
          ) : null}
          <div className="flex flex-col gap-3">
            <h3 className="text-sm font-semibold text-text">{t("privacy.consentHeading")}</h3>
            <ConsentRow checked disabled label={t("privacy.consentCore")} />
            <ConsentRow checked={insights} onChange={setInsights} label={t("privacy.consentInsights")} />
            <ConsentRow checked={research} onChange={setResearch} label={t("privacy.consentResearch")} />
            <p className="text-xs text-text-muted">{t("privacy.consentNote")}</p>
          </div>
        </section>
      ) : null}

      {step === 3 ? (
        <section className="flex flex-col gap-3">
          <h2 className="text-md font-semibold text-text">{t("confirm.heading")}</h2>
          <div className="rounded-md border border-border bg-surface p-4 text-sm">
            <p>
              <span className="text-text-muted">{t("confirm.modeLabel")}: </span>
              {mode ? t(`mode.${mode}.name`) : "—"}
            </p>
            <p className="mt-1">
              <span className="text-text-muted">{t("confirm.accountLabel")}: </span>
              {t(account === "anonymous" ? "privacy.anonymous.name" : "privacy.account.name")}
            </p>
          </div>
        </section>
      ) : null}

      {error ? (
        <Alert variant="danger">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      ) : null}

      <div className="flex items-center justify-between">
        {step > 1 ? (
          <Button variant="ghost" onClick={() => setStep((s) => s - 1)} disabled={submitting}>
            {t("nav.back")}
          </Button>
        ) : (
          <span />
        )}
        {step < TOTAL_STEPS ? (
          <Button onClick={() => setStep((s) => s + 1)} disabled={!canAdvance}>
            {t("nav.next")}
          </Button>
        ) : (
          <Button variant="accent" onClick={finish} disabled={submitting}>
            {t("confirm.start")}
          </Button>
        )}
      </div>
    </div>
  );
}
