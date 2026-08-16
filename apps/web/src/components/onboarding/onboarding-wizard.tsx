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
import { ChoiceGroup } from "@/components/ui/choice-row";
import { chipVariants } from "@/components/ui/chip";
import { CONDITIONS_BY_MODE, type ConditionCode } from "@/lib/persona/conditions";
import type { PersonaMode } from "@/lib/persona/modes";
import { AGE_BANDS, type AgeBand } from "@/lib/persona/age";
import {
  FOLLOWUP_BY_MODE,
  type BirthRecencyBand,
  type FollowUpBand,
  type TtcDurationBand,
} from "@/lib/persona/followup";
import { isMinor } from "@/lib/persona/minor";
import { codeAccepted, isBetaGateOn } from "@/lib/beta/gate";
import { track } from "@/lib/analytics/track";
import { PageView } from "@/components/analytics/page-view";

// Was a hand-written copy of the mode list — a fourth one, which is how
// "postpartum" could be added everywhere else and still not compile here.
type Mode = PersonaMode;
type Account = "anonymous" | "email";

// docs/09 §4 Q1 lists "I recently gave birth" among the eight branches; it was
// one of the four that had never been offered (R2.5). `teen` joined it in R2.5c —
// it sits first because Track A is the earliest life stage, and because a
// thirteen-year-old scanning a list of adult options for herself is the experience
// A2 §A describes as the "17+ gap".
const MODES: readonly Mode[] = ["teen", "cycle", "ttc", "pregnancy", "postpartum", "menopause"];
const ACCOUNTS: readonly Account[] = ["anonymous", "email"];
// Q1 life stage → Q2 triage → privacy → confirm. docs/09 §4 specifies six
// branches; the triage step is Q2–Q6 collapsed into one stage-scoped question,
// because they only ever differ by which conditions they offer.
const TOTAL_STEPS = 4;

// The message keys predate the `Account` union and do not match it, so the mapping
// lives here rather than as the same ternary written out at three call sites.
const ACCOUNT_KEY: Record<Account, string> = {
  anonymous: "privacy.anonymous",
  email: "privacy.account",
};

// One h1 per step, indexed rather than chained.
const STEP_HEADING = ["title", "triage.heading", "privacy.heading", "confirm.heading"] as const;

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
  // One answer, whichever question her stage asks. Which field it becomes is
  // decided at submit from `FOLLOWUP_BY_MODE`, not by a branch here.
  const [followUpBand, setFollowUpBand] = useState<FollowUpBand | null>(null);
  const [conditions, setConditions] = useState<Set<ConditionCode>>(new Set());
  // `null` is a real answer ("prefer not to say"), and it is treated as a minor
  // for consent purposes rather than as an adult (lib/persona/minor.ts).
  const [ageBand, setAgeBand] = useState<AgeBand | null>(null);
  const [account, setAccount] = useState<Account>("anonymous");
  const [email, setEmail] = useState("");
  const [insights, setInsights] = useState(false);
  const [research, setResearch] = useState(false);
  const [analytics, setAnalytics] = useState(false);
  const [inviteCode, setInviteCode] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    void track("signup_started", { locale });
  }, [locale]);

  const canAdvance =
    step === 1
      ? mode !== null
      : // Triage is always skippable: "none of these" is a real answer, and
        // requiring a tick would push someone into claiming a condition.
        step === 2
        ? true
        : step === 3
          ? account === "anonymous" || email.length > 3
          : // The private-beta gate (P0.12.5). Off entirely when no code is
            // configured, so this reads `true` in every environment that has not
            // set one — including today's.
            codeAccepted(inviteCode);

  const offered = mode ? CONDITIONS_BY_MODE[mode] : [];
  const followUp = mode ? FOLLOWUP_BY_MODE[mode] : undefined;
  const toggleCondition = (code: ConditionCode) =>
    setConditions((prev) => {
      const next = new Set(prev);
      if (next.has(code)) next.delete(code);
      else next.add(code);
      return next;
    });

  const finish = async () => {
    if (!mode) return;
    setSubmitting(true);
    setError(null);
    const res = await completeOnboarding({
      mode,
      ttcDuration: followUp?.id === "ttc" ? (followUpBand as TtcDurationBand) : null,
      birthRecency: followUp?.id === "birth" ? (followUpBand as BirthRecencyBand) : null,
      conditions: [...conditions],
      ageBand,
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
    <div className="pb-bottom-bar mx-auto flex w-full max-w-xl flex-col gap-5 px-5 pt-6">
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
      <h1 className="font-display text-xl text-text">{t(STEP_HEADING[step - 1]!)}</h1>

      {step === 1 ? (
        <section className="flex flex-col gap-4">
          <div className="flex flex-col gap-1">
            <h2 className="text-md font-semibold text-text">{t("mode.heading")}</h2>
            <p className="text-sm text-text-muted">{t("mode.subheading")}</p>
          </div>
          <ChoiceGroup
            label={t("mode.heading")}
            value={mode}
            onChange={setMode}
            options={MODES.map((m) => ({
              value: m,
              name: t(`mode.${m}.name`),
              desc: t(`mode.${m}.desc`),
            }))}
          />
          {/* Age band. Optional, and asked here rather than as its own step so the
              flow stays short (R1.4). It is the resolver's most-used gate — A2, F1
              and F2 all require one — and nothing collected it until R2.5b, so
              those rules could never fire. Bands rather than a date of birth is
              data minimisation: nothing in the taxonomy needs more precision. */}
          <div className="flex flex-col gap-2 border-t border-border pt-4">
            <p className="text-sm font-medium text-text">{t("age.heading")}</p>
            <p className="text-2xs text-text-muted">{t("age.note")}</p>
            <div className="flex flex-wrap gap-2">
              {AGE_BANDS.map((band) => (
                <button
                  key={band}
                  type="button"
                  aria-pressed={ageBand === band}
                  onClick={() => setAgeBand(ageBand === band ? null : band)}
                  className={chipVariants({ selected: ageBand === band })}
                >
                  {t(`age.bands.${band}`)}
                </button>
              ))}
            </div>
            {isMinor(ageBand) && ageBand ? (
              <p className="text-2xs leading-relaxed text-text-muted">{t("age.minorNote")}</p>
            ) : null}
          </div>

          {/* "Skip / I'm not sure" → Z1 (P1.27.7, docs/09 §4). Required, and it
              was missing: the wizard forced a choice among four stages. Z1 is the
              full generic experience, not a lesser one. */}
          <button
            type="button"
            onClick={() => {
              setMode("general");
              setConditions(new Set());
              setStep(3);
            }}
            className="self-center rounded-sm px-4 py-2 text-sm text-text-muted underline hover:text-text"
          >
            {t("mode.skip")}
          </button>
        </section>
      ) : null}

      {step === 2 ? (
        <section className="flex flex-col gap-4">
          {/* The triage question, and the reason the whole questionnaire exists.
              Which conditions her clinician is watching is what decides the
              persona — the same thing a clinician would ask first. It is a
              multi-select because conditions stack (docs/09 §8), and it never
              asks about mood: mood drives contextual tips, not which version of
              the app she gets. */}
          <p className="text-sm text-text-muted">{t("triage.intro")}</p>
          <div className="flex flex-wrap gap-2" role="group" aria-label={t("triage.heading")}>
            {offered.map((code) => (
              <button
                key={code}
                type="button"
                onClick={() => toggleCondition(code)}
                aria-pressed={conditions.has(code)}
                className={chipVariants({ selected: conditions.has(code) })}
              >
                {t(`triage.conditions.${code}`)}
              </button>
            ))}
          </div>
          {offered.length === 0 ? (
            <p className="text-sm text-text-muted">{t("triage.noneOffered")}</p>
          ) : null}
          {/* The stage-scoped follow-up (P1.27.8, docs/09 §4 Q3–Q6), driven by
              `FOLLOWUP_BY_MODE` rather than by a branch — what a stage asks is
              data, exactly as which conditions it offers is. A question exists
              only if a resolver rule reads the answer; asking something Femio then
              ignores is worse than not asking. Bands, not dates: nothing needs
              more precision, and a delivery date is sharper health data than the
              answer requires. */}
          {followUp ? (
            <div className="flex flex-col gap-2 border-t border-border pt-4">
              <p className="text-sm font-medium text-text">
                {t(`followUp.${followUp.id}.heading`)}
              </p>
              <p className="text-2xs text-text-muted">{t(`followUp.${followUp.id}.note`)}</p>
              <div className="flex flex-wrap gap-2">
                {followUp.bands.map((band) => (
                  <button
                    key={band.id}
                    type="button"
                    aria-pressed={followUpBand === band.id}
                    onClick={() => setFollowUpBand(followUpBand === band.id ? null : band.id)}
                    className={chipVariants({ selected: followUpBand === band.id })}
                  >
                    {t(`followUp.${followUp.id}.bands.${band.id}`)}
                  </button>
                ))}
              </div>
            </div>
          ) : null}

          {/* Not a diagnosis, and it says so where she answers rather than in a
              policy page (product rule 1). */}
          <p className="text-2xs text-text-subtle">{t("triage.note")}</p>
        </section>
      ) : null}

      {step === 3 ? (
        <section className="flex flex-col gap-5">
          <p className="text-sm text-text-muted">{t("privacy.intro")}</p>
          <ChoiceGroup
            label={t("privacy.heading")}
            value={account}
            onChange={setAccount}
            options={ACCOUNTS.map((a) => ({
              value: a,
              name: t(`${ACCOUNT_KEY[a]}.name`),
              desc: t(`${ACCOUNT_KEY[a]}.desc`),
            }))}
          />
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

      {step === 4 ? (
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
              <dd className="font-semibold text-text">{t(`${ACCOUNT_KEY[account]}.name`)}</dd>
            </div>
          </dl>

          {/* Private beta (P0.12.5, B4). Shown only when a code is configured, so
              nothing changes until the owner turns it on. The notice is the point
              as much as the field: someone storing real health data deserves to
              know the privacy policy is still a draft. */}
          {isBetaGateOn() ? (
            <div className="flex flex-col gap-3 rounded-md bg-warning-soft p-4">
              <div className="flex flex-col gap-1">
                <h2 className="text-sm font-semibold text-warning-text">{t("beta.heading")}</h2>
                <p className="text-2xs leading-relaxed text-warning-text">{t("beta.body")}</p>
              </div>
              <div className="flex flex-col gap-1">
                <Label htmlFor="invite">{t("beta.label")}</Label>
                <Input
                  id="invite"
                  value={inviteCode}
                  onChange={(e) => setInviteCode(e.target.value)}
                  autoComplete="off"
                  placeholder={t("beta.placeholder")}
                />
              </div>
            </div>
          ) : null}
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
