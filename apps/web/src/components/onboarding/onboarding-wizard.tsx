"use client";

import { useEffect, useState } from "react";
import { useLocale, useTranslations } from "next-intl";
import { useRouter } from "@/i18n/navigation";
import type { Locale } from "@/i18n/routing";
import { completeOnboarding } from "@/lib/onboarding/complete";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { cn } from "@/lib/utils";
import { track } from "@/lib/analytics/track";
import { PageView } from "@/components/analytics/page-view";

type Mode = "cycle" | "ttc" | "pregnancy" | "menopause";
type Account = "anonymous" | "email";

const MODES: readonly Mode[] = ["cycle", "ttc", "pregnancy", "menopause"];
const TOTAL_STEPS = 3;

/**
 * A single-choice row (P1.28.5).
 *
 * `role="radio"` rather than `aria-pressed`: these options are mutually exclusive,
 * and a toggle role tells a screen-reader user the wrong thing and gives her no
 * "2 of 4" position. The visible dot is the same promise in the other direction —
 * before this the only signal that a card was selectable was that selecting it
 * changed the background, which you cannot see until after you have guessed.
 */
function ChoiceRow({
  selected,
  onSelect,
  name,
  desc,
}: {
  selected: boolean;
  onSelect: () => void;
  name: string;
  desc: string;
}) {
  return (
    <button
      type="button"
      role="radio"
      aria-checked={selected}
      onClick={onSelect}
      className={cn(
        "flex w-full items-start gap-3 rounded-md border p-4 text-start",
        "transition-[background-color,border-color,transform] duration-fast",
        "motion-safe:ease-spring motion-safe:active:scale-[0.99]",
        selected
          ? "border-primary bg-primary-soft"
          : "border-border bg-surface hover:bg-surface-sunken",
      )}
    >
      <span
        aria-hidden
        className={cn(
          "mt-0.5 size-5 shrink-0 rounded-round border-2 transition-colors duration-fast",
          selected ? "border-primary bg-primary shadow-[inset_0_0_0_3px_var(--surface)]" : "border-border-strong",
        )}
      />
      <span className="flex flex-col gap-0.5">
        <span className={cn("font-semibold", selected ? "text-primary-soft-text" : "text-text")}>
          {name}
        </span>
        <span className="text-sm text-text-muted">{desc}</span>
      </span>
    </button>
  );
}

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
    <label className="flex min-h-11 cursor-pointer items-start gap-3 py-1 text-sm text-text">
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
  const [analytics, setAnalytics] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    void track("signup_started", { locale });
  }, [locale]);

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
      analytics,
      locale,
    });
    // Funnel only: `mode` is deliberately NOT sent — life stage is health data
    // (it is answered first-party instead, ADR-020).
    void track("signup_completed", {
      locale,
      auth_method: account === "email" ? "email_password" : "anonymous",
      outcome: res.ok ? "success" : "error",
    });
    if (res.ok) {
      router.push("/dashboard");
    } else {
      setError(res.error);
      setSubmitting(false);
    }
  };

  return (
    <div className="pb-tabbar mx-auto flex w-full max-w-xl flex-col gap-5 px-5 pt-6">
      <PageView area="onboarding" />

      {/* The wordmark, because this is the first screen a new user sees and it did
          not say whose app it was. Always English "femio" (product rule 6). */}
      <div className="flex items-center justify-between gap-3">
        <span className="font-display text-lg lowercase tracking-tight text-primary">femio</span>
        <span className="text-2xs font-medium text-text-subtle">
          {t("stepOf", { current: step, total: TOTAL_STEPS })}
        </span>
      </div>

      {/* A bar as well as the words: three steps is short, and showing that it is
          short is most of the reason someone finishes it. `aria-hidden` — the
          "Step 1 of 3" text above already says this. */}
      <div aria-hidden className="h-1 w-full overflow-hidden rounded-pill bg-surface-sunken">
        <div
          className="h-full rounded-pill bg-primary transition-[width] duration-base ease-standard"
          style={{ width: `${(step / TOTAL_STEPS) * 100}%` }}
        />
      </div>

      {/* One h1 per view. It used to repeat "Welcome to Femio" on all three steps,
          which cost the top third of a 390px screen to say nothing new. */}
      <h1 className="font-display text-xl text-text">
        {step === 1 ? t("title") : step === 2 ? t("privacy.heading") : t("confirm.heading")}
      </h1>

      {step === 1 ? (
        <section className="flex flex-col gap-4">
          <div className="flex flex-col gap-1">
            <h2 className="text-md font-semibold text-text">{t("mode.heading")}</h2>
            <p className="text-sm text-text-muted">{t("mode.subheading")}</p>
          </div>
          <div className="flex flex-col gap-3" role="radiogroup" aria-label={t("mode.heading")}>
            {MODES.map((m) => (
              <ChoiceRow
                key={m}
                selected={mode === m}
                onSelect={() => setMode(m)}
                name={t(`mode.${m}.name`)}
                desc={t(`mode.${m}.desc`)}
              />
            ))}
          </div>
        </section>
      ) : null}

      {step === 2 ? (
        <section className="flex flex-col gap-5">
          <p className="text-sm text-text-muted">{t("privacy.intro")}</p>
          <div
            className="flex flex-col gap-3"
            role="radiogroup"
            aria-label={t("privacy.heading")}
          >
            {(["anonymous", "email"] as const).map((a) => (
              <ChoiceRow
                key={a}
                selected={account === a}
                onSelect={() => setAccount(a)}
                name={t(a === "anonymous" ? "privacy.anonymous.name" : "privacy.account.name")}
                desc={t(a === "anonymous" ? "privacy.anonymous.desc" : "privacy.account.desc")}
              />
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
            <ConsentRow checked={analytics} onChange={setAnalytics} label={t("privacy.consentAnalytics")} />
            <p className="text-xs text-text-muted">{t("privacy.consentNote")}</p>
          </div>
        </section>
      ) : null}

      {step === 3 ? (
        <section className="flex flex-col gap-3">
          <dl className="flex flex-col gap-3 rounded-md border border-border bg-surface p-4 text-sm">
            <div className="flex flex-col gap-0.5">
              <dt className="text-2xs uppercase tracking-wider text-text-subtle">
                {t("confirm.modeLabel")}
              </dt>
              <dd className="font-semibold text-text">{mode ? t(`mode.${mode}.name`) : "—"}</dd>
            </div>
            <div className="flex flex-col gap-0.5">
              <dt className="text-2xs uppercase tracking-wider text-text-subtle">
                {t("confirm.accountLabel")}
              </dt>
              <dd className="font-semibold text-text">
                {t(account === "anonymous" ? "privacy.anonymous.name" : "privacy.account.name")}
              </dd>
            </div>
          </dl>
        </section>
      ) : null}

      {error ? (
        <Alert variant="danger">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      ) : null}

      {/* Fixed to the bottom, primary action full width. It was a small button in the
          bottom-right corner, which on step 2 arrived after a screen and a half of
          scrolling — the hardest place on a phone to reach and the last place you
          look. `app-bottom-bar` is the hook that keeps the crisis launcher clear of
          it (globals.css). */}
      <div className="app-bottom-bar pb-safe fixed inset-x-0 bottom-0 z-sticky border-t border-border bg-surface/95 backdrop-blur">
        <div className="mx-auto flex max-w-xl items-center gap-3 px-5 py-3">
          {step > 1 ? (
            <Button variant="ghost" onClick={() => setStep((s) => s - 1)} disabled={submitting}>
              {t("nav.back")}
            </Button>
          ) : null}
          {step < TOTAL_STEPS ? (
            <Button className="flex-1" onClick={() => setStep((s) => s + 1)} disabled={!canAdvance}>
              {t("nav.next")}
            </Button>
          ) : (
            <Button className="flex-1" variant="accent" onClick={finish} disabled={submitting}>
              {t("confirm.start")}
            </Button>
          )}
        </div>
      </div>
    </div>
  );
}
