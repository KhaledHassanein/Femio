"use client";

import { Suspense } from "react";
import { useSearchParams } from "next/navigation";
import { useTranslations } from "next-intl";
import { Card, CardContent } from "@/components/ui/card";
import { ExportButton } from "@/components/account/export-button";
import { DeleteButton } from "@/components/account/delete-button";
import { SetPassword } from "@/components/account/set-password";
import { ConsentSettings } from "@/components/account/consent-settings";
import { MfaSettings } from "@/components/account/mfa-settings";
import { ExperienceSettings } from "@/components/account/experience-settings";
import { SignOutButton } from "@/components/account/sign-out-button";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Link } from "@/i18n/navigation";
import { AppScreen } from "@/components/patterns/app-screen";

/**
 * Settings, client-rendered so it can run without a server (P4.0, ADR-048).
 *
 * There was never a server-side read worth keeping here beyond the auth check —
 * every control on this page (consent, MFA, password, export, delete) was already
 * a client component talking to Supabase from the browser. The conversion is
 * mostly the removal of a `force-dynamic` that only the auth redirect needed.
 */
function MfaRequiredNotice() {
  const t = useTranslations("settings");
  // `?mfa=required` is set by `requireStaff` when it bounces someone here.
  const required = useSearchParams().get("mfa") === "required";
  if (!required) return null;
  return (
    <Alert variant="warning">
      <AlertDescription>{t("mfa.requiredNotice")}</AlertDescription>
    </Alert>
  );
}

export function SettingsScreen() {
  const t = useTranslations("settings");
  const te = useTranslations("experience");
  const ta = useTranslations("appointments");
  const tf = useTranslations("fertility");
  const tm = useTranslations("medications");

  return (
    <AppScreen>
      <h1 className="font-display text-lg text-text">{t("title")}</h1>

      <Card>
        <CardContent className="flex flex-col gap-4 p-6">
          <div className="flex flex-col gap-1">
            <h2 className="text-md font-semibold text-text">{te("heading")}</h2>
            <p className="text-sm text-text-muted">{te("desc")}</p>
          </div>
          <ExperienceSettings />
        </CardContent>
      </Card>

      <Card>
        <CardContent className="flex flex-col gap-3 p-6">
          <div className="flex flex-col gap-1">
            <h2 className="text-md font-semibold text-text">{t("summary.heading")}</h2>
            <p className="text-sm text-text-muted">{t("summary.desc")}</p>
          </div>
          <Button asChild variant="outline" className="self-start">
            <Link href="/summary">{t("summary.link")}</Link>
          </Button>
        </CardContent>
      </Card>

      {/* Appointments are surfaced on the pregnancy dashboard by the engine, and
          reachable from here in every other mode (P2.2.3). A fertility work-up, a
          gynae follow-up and a menopause clinic are all appointments; making them a
          pregnancy feature would be the restriction pattern product rule 2 forbids. */}
      <Card>
        <CardContent className="flex flex-col gap-3 p-6">
          <div className="flex flex-col gap-1">
            <h2 className="text-md font-semibold text-text">{ta("title")}</h2>
            <p className="text-sm text-text-muted">{ta("empty.body")}</p>
          </div>
          <Button asChild variant="outline" className="self-start">
            <Link href="/appointments">{ta("title")}</Link>
          </Button>
        </CardContent>
      </Card>

      {/* Charting, reachable in every mode for the same reason (P2.1). Someone
          charting through perimenopause, or before a fertility appointment without
          calling herself "trying", is not served by a feature behind a mode. */}
      <Card>
        <CardContent className="flex flex-col gap-3 p-6">
          <div className="flex flex-col gap-1">
            <h2 className="text-md font-semibold text-text">{tf("title")}</h2>
            <p className="text-sm text-text-muted">{tf("boundary")}</p>
          </div>
          <Button asChild variant="outline" className="self-start">
            <Link href="/fertility">{tf("title")}</Link>
          </Button>
        </CardContent>
      </Card>

      {/* Medicines and supplements (P2.4). One list across every stage — HRT, the
          pill, thyroid tablets, a prenatal vitamin — because a woman has one list
          and splitting it by life stage would restrict by data structure. */}
      <Card>
        <CardContent className="flex flex-col gap-3 p-6">
          <div className="flex flex-col gap-1">
            <h2 className="text-md font-semibold text-text">{tm("title")}</h2>
            <p className="text-sm text-text-muted">{tm("empty.body")}</p>
          </div>
          <Button asChild variant="outline" className="self-start">
            <Link href="/medications">{tm("title")}</Link>
          </Button>
        </CardContent>
      </Card>

      {/* `useSearchParams` bails out of prerendering, so it is isolated behind its own
          Suspense boundary — otherwise the whole page would, and a static export
          refuses to build (P4.0 Step 1). */}
      <Suspense fallback={null}>
        <MfaRequiredNotice />
      </Suspense>

      <Card>
        <CardContent className="flex flex-col gap-4 p-6">
          <div className="flex flex-col gap-1">
            <h2 className="text-md font-semibold text-text">{t("mfa.heading")}</h2>
            <p className="text-sm text-text-muted">{t("mfa.desc")}</p>
          </div>
          <MfaSettings />
        </CardContent>
      </Card>

      <Card>
        <CardContent className="flex flex-col gap-4 p-6">
          <div className="flex flex-col gap-1">
            <h2 className="text-md font-semibold text-text">{t("consent.heading")}</h2>
            <p className="text-sm text-text-muted">{t("consent.desc")}</p>
          </div>
          <ConsentSettings />
        </CardContent>
      </Card>

      <Card>
        <CardContent className="flex flex-col gap-3 p-6">
          <div className="flex flex-col gap-1">
            <h2 className="text-md font-semibold text-text">{t("password.heading")}</h2>
            <p className="text-sm text-text-muted">{t("password.desc")}</p>
          </div>
          <SetPassword />
        </CardContent>
      </Card>

      <Card>
        <CardContent className="flex flex-col gap-3 p-6">
          <div className="flex flex-col gap-1">
            <h2 className="text-md font-semibold text-text">{t("export.heading")}</h2>
            <p className="text-sm text-text-muted">{t("export.desc")}</p>
          </div>
          <ExportButton />
        </CardContent>
      </Card>

      {/* Sign-out lives here rather than in the nav (P1.28.1): it is an account
          action, not a destination, and it was one mis-tap from "Track". */}
      <Card>
        <CardContent className="flex flex-col gap-3 p-6">
          <div className="flex flex-col gap-1">
            <h2 className="text-md font-semibold text-text">{t("signOut.heading")}</h2>
            <p className="text-sm text-text-muted">{t("signOut.desc")}</p>
          </div>
          <SignOutButton />
        </CardContent>
      </Card>

      <Card>
        <CardContent className="flex flex-col gap-3 p-6">
          <div className="flex flex-col gap-1">
            <h2 className="text-md font-semibold text-text">{t("delete.heading")}</h2>
            <p className="text-sm text-text-muted">{t("delete.desc")}</p>
          </div>
          <DeleteButton />
        </CardContent>
      </Card>
    </AppScreen>
  );
}
