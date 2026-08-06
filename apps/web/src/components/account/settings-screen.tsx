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
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Link } from "@/i18n/navigation";

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

  return (
    <main className="mx-auto flex w-full max-w-2xl flex-col gap-6 px-6 py-12">
      <h1 className="font-display text-2xl text-text">{t("title")}</h1>

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

      <Card>
        <CardContent className="flex flex-col gap-3 p-6">
          <div className="flex flex-col gap-1">
            <h2 className="text-md font-semibold text-text">{t("delete.heading")}</h2>
            <p className="text-sm text-text-muted">{t("delete.desc")}</p>
          </div>
          <DeleteButton />
        </CardContent>
      </Card>
    </main>
  );
}
