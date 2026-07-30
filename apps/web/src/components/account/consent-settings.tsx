"use client";

import { useEffect, useState } from "react";
import { useTranslations } from "next-intl";
import { OPTIONAL_PURPOSES, type OptionalPurpose } from "@/lib/consent/purposes";
import { readOptionalConsents, setConsent } from "@/lib/consent/actions";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Skeleton } from "@/components/ui/skeleton";

/**
 * Grant or withdraw each optional consent (P1.20.2).
 *
 * GDPR Art. 7(3): withdrawing must be as easy as granting — so these are the same
 * choices onboarding offers, in the same words, changeable in one click. Core
 * consent is shown but not switchable: it gates every health write, so withdrawing
 * it means deleting the account, and pretending otherwise would be a dark pattern.
 */
export function ConsentSettings() {
  const t = useTranslations("settings.consent");
  const [values, setValues] = useState<Record<OptionalPurpose, boolean> | null>(null);
  const [pending, setPending] = useState<OptionalPurpose | null>(null);
  const [error, setError] = useState<string | null>(null);

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
      setError(t("error"));
    }
    setPending(null);
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
