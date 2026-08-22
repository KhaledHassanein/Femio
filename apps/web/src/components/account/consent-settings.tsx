"use client";

import { useEffect, useState } from "react";
import { useTranslations } from "next-intl";
import { OPTIONAL_PURPOSES, type OptionalPurpose } from "@/lib/consent/purposes";
import { readOptionalConsents, setConsent } from "@/lib/consent/actions";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { createClient } from "@/lib/supabase/client";
import type { AgeBand } from "@/lib/persona/age";
import { Skeleton } from "@/components/ui/skeleton";

/**
 * Grant or withdraw each optional consent (P1.20.2).
 *
 * GDPR Art. 7(3): withdrawing must be as easy as granting — so these are the same
 * choices onboarding offers, in the same words, changeable in one click. Core
 * consent is shown but not switchable: it gates every health write, so withdrawing
 * it means deleting the account, and pretending otherwise would be a dark pattern.
 */
/**
 * Only the adult bands are offered here, and that is not a shortcut.
 *
 * A minor still cannot grant analytics or research — Art. 8 needs verifiable
 * parental consent, which Femio does not implement — so offering "13–15" would
 * invite her to answer a question whose only outcome is the same refusal. If she
 * is under 18 the honest path is Settings' own age control, not this prompt.
 */
const ADULT_BANDS: readonly AgeBand[] = ["18_24", "25_34", "35_44", "45_54", "55_plus"];

export function ConsentSettings() {
  const t = useTranslations("settings.consent");
  const tAge = useTranslations("onboarding.age.bands");
  const [values, setValues] = useState<Record<OptionalPurpose, boolean> | null>(null);
  const [pending, setPending] = useState<OptionalPurpose | null>(null);
  const [error, setError] = useState<string | null>(null);
  /**
   * The grant Femio refused because it does not know how old she is (R3.0.8).
   *
   * `isMinor(null)` is `true` — the right fail-closed default for child
   * protection — and onboarding offers "Skip — I'm not sure", so `age_band: null`
   * is an ordinary, reachable state. For that user `consent/actions.ts` refused
   * every analytics or research grant with `not_permitted_for_age`, the switch
   * sprang back, and a generic "that didn't save" was all she got. Forever, with
   * no way to find out why or fix it.
   *
   * Holding the purpose here rather than just a flag means the answer can be
   * applied to the grant she actually asked for, instead of asking her to find
   * the switch again afterwards.
   */
  const [ageBlocked, setAgeBlocked] = useState<OptionalPurpose | null>(null);
  const [savingAge, setSavingAge] = useState(false);

  useEffect(() => {
    let active = true;
    readOptionalConsents().then((v) => {
      if (active) setValues(v);
    });
    return () => {
      active = false;
    };
  }, []);

  const toggle = async (purpose: OptionalPurpose, next: boolean) => {
    if (!values) return;
    setError(null);
    setPending(purpose);
    // Optimistic: the switch should feel immediate, but a failure must not leave
    // the UI claiming a permission the ledger doesn't hold.
    setValues({ ...values, [purpose]: next });
    const res = await setConsent(purpose, next);
    if (!res.ok) {
      setValues({ ...values, [purpose]: !next });
      // A refusal Femio can explain and she can resolve, versus one she cannot.
      // Product rule 2 and the gate's own comment agree here: it "exists to
      // protect her, not to trap a permission she wants to remove".
      if (res.error === "not_permitted_for_age") setAgeBlocked(purpose);
      else setError(t("error"));
    }
    setPending(null);
  };

  /**
   * Answer the age question here, then complete the grant she was already making.
   *
   * Hiding the switch instead would have been cheaper and worse: she could not
   * tell "not offered to me" from "does not exist", and the gate's own code warns
   * that a UI which merely hides a control is one refactor from granting it anyway.
   */
  const resolveAge = async (band: AgeBand) => {
    if (!ageBlocked) return;
    setSavingAge(true);
    setError(null);
    const supabase = createClient();
    const { data } = await supabase.auth.getUser();
    if (!data.user) {
      setSavingAge(false);
      return;
    }
    const { error: saveError } = await supabase
      .from("profiles")
      .update({ age_band: band })
      .eq("id", data.user.id);
    if (saveError) {
      setSavingAge(false);
      setError(t("error"));
      return;
    }
    const purpose = ageBlocked;
    setAgeBlocked(null);
    setSavingAge(false);
    // Under-18 bands are still refused, and correctly — but now she has been told
    // why, which is the part that was missing.
    await toggle(purpose, true);
  };

  if (!values) {
    return (
      <div className="flex flex-col gap-3" aria-busy>
        <Skeleton className="h-5 w-full" />
        <Skeleton className="h-5 w-5/6" />
        <Skeleton className="h-5 w-4/6" />
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-4">
      {error ? (
        <Alert variant="danger">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      ) : null}

      {ageBlocked ? (
        <Alert variant="warning">
          <AlertDescription className="flex flex-col items-start gap-3">
            <span>{t("ageGate.body")}</span>
            <div className="flex flex-wrap gap-2">
              {ADULT_BANDS.map((band) => (
                <Button
                  key={band}
                  variant="outline"
                  size="sm"
                  disabled={savingAge}
                  onClick={() => void resolveAge(band)}
                >
                  {tAge(band)}
                </Button>
              ))}
              <Button variant="ghost" size="sm" onClick={() => setAgeBlocked(null)}>
                {t("ageGate.dismiss")}
              </Button>
            </div>
          </AlertDescription>
        </Alert>
      ) : null}

      <div className="flex flex-col gap-3">
        {OPTIONAL_PURPOSES.map((purpose) => (
          <label key={purpose} className="flex items-start gap-3 text-sm text-text">
            <input
              type="checkbox"
              className="mt-0.5 size-5 shrink-0 accent-primary-solid"
              checked={values[purpose]}
              disabled={pending === purpose}
              onChange={(e) => void toggle(purpose, e.target.checked)}
            />
            <span className="flex flex-col gap-0.5">
              <span>{t(`${purpose}.label`)}</span>
              <span className="text-xs text-text-muted">{t(`${purpose}.note`)}</span>
            </span>
          </label>
        ))}
      </div>

      <div className="flex flex-col gap-1 border-t border-border pt-3">
        <p className="text-sm text-text">{t("core.label")}</p>
        <p className="text-xs text-text-muted">{t("core.note")}</p>
      </div>
    </div>
  );
}
