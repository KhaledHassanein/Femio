"use client";

import { useCallback, useEffect, useState } from "react";
import { useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Skeleton } from "@/components/ui/skeleton";

/**
 * Enrol / remove a TOTP second factor (P1.23.3).
 *
 * Offered to every signed-in account with an email, not just staff — a health
 * record is worth protecting whoever owns it — but only *enforced* for staff
 * routes (`requireStaff`). The QR code Supabase returns is an inline SVG data
 * URI, which the CSP allows via `img-src data:` (ADR-021).
 */
type Factor = { id: string; status: string };

export function MfaSettings() {
  const t = useTranslations("settings.mfa");
  const supabase = createClient();

  const [factors, setFactors] = useState<Factor[] | null>(null);
  const [enrolling, setEnrolling] = useState<{ id: string; qr: string; secret: string } | null>(null);
  const [code, setCode] = useState("");
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [done, setDone] = useState(false);

  const refresh = useCallback(async () => {
    const { data } = await supabase.auth.mfa.listFactors();
    setFactors((data?.totp ?? []).map((f) => ({ id: f.id, status: f.status })));
  }, [supabase]);

  useEffect(() => {
    void refresh();
  }, [refresh]);

  const verified = factors?.some((f) => f.status === "verified") ?? false;

  const startEnrolment = async () => {
    setError(null);
    setBusy(true);
    // An abandoned enrolment leaves an `unverified` factor behind, and Supabase
    // refuses a second one with the same friendly name — clear them first so a
    // retry can never dead-end.
    for (const stale of (factors ?? []).filter((f) => f.status !== "verified")) {
      await supabase.auth.mfa.unenroll({ factorId: stale.id });
    }
    const { data, error: enrollError } = await supabase.auth.mfa.enroll({ factorType: "totp" });
    setBusy(false);
    if (enrollError || !data) {
      setError(enrollError?.message ?? t("error"));
      return;
    }
    setEnrolling({ id: data.id, qr: data.totp.qr_code, secret: data.totp.secret });
  };

  const confirm = async () => {
    if (!enrolling) return;
    setError(null);
    setBusy(true);
    const { data: challenge, error: challengeError } = await supabase.auth.mfa.challenge({
      factorId: enrolling.id,
    });
    if (challengeError || !challenge) {
      setBusy(false);
      setError(challengeError?.message ?? t("error"));
      return;
    }
    const { error: verifyError } = await supabase.auth.mfa.verify({
      factorId: enrolling.id,
      challengeId: challenge.id,
      code: code.trim(),
    });
    setBusy(false);
    if (verifyError) {
      setError(t("wrongCode"));
      return;
    }
    setEnrolling(null);
    setCode("");
    setDone(true);
    await refresh();
  };

  const disable = async () => {
    setError(null);
    setBusy(true);
    for (const f of factors ?? []) await supabase.auth.mfa.unenroll({ factorId: f.id });
    setBusy(false);
    setDone(false);
    await refresh();
  };

  if (factors === null) return <Skeleton className="h-10 w-full" />;

  return (
    <div className="flex flex-col gap-4">
      {error ? (
        <Alert variant="danger">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      ) : null}

      {verified ? (
        <>
          <p className="text-sm text-success-text">{t("enabled")}</p>
          <Button variant="outline" onClick={() => void disable()} disabled={busy} className="self-start">
            {t("disable")}
          </Button>
        </>
      ) : enrolling ? (
        <div className="flex flex-col gap-3">
          <p className="text-sm text-text-muted">{t("scan")}</p>
          {/* Supabase returns the QR as an inline SVG data URI. */}
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img
            src={enrolling.qr}
            alt={t("qrAlt")}
            width={200}
            height={200}
            className="rounded-md border border-border bg-surface p-2"
          />
          <p className="text-xs text-text-muted">
            {t("manualEntry")} <code className="select-all font-mono">{enrolling.secret}</code>
          </p>
          <div className="flex flex-col gap-2">
            <Label htmlFor="mfa-code">{t("codeLabel")}</Label>
            <Input
              id="mfa-code"
              inputMode="numeric"
              autoComplete="one-time-code"
              maxLength={6}
              value={code}
              onChange={(e) => setCode(e.target.value)}
              className="max-w-[10rem] font-mono tracking-widest"
            />
          </div>
          <div className="flex gap-2">
            <Button onClick={() => void confirm()} disabled={busy || code.trim().length < 6}>
              {busy ? t("verifying") : t("verify")}
            </Button>
            <Button variant="ghost" onClick={() => setEnrolling(null)} disabled={busy}>
              {t("cancel")}
            </Button>
          </div>
        </div>
      ) : (
        <>
          {done ? (
            <Alert variant="success">
              <AlertDescription>{t("saved")}</AlertDescription>
            </Alert>
          ) : null}
          <Button onClick={() => void startEnrolment()} disabled={busy} className="self-start">
            {t("enable")}
          </Button>
        </>
      )}
    </div>
  );
}
