"use client";

import { Suspense } from "react";
import { useSearchParams } from "next/navigation";
import { useTranslations } from "next-intl";
import { MfaChallenge } from "@/components/auth/mfa-challenge";
import { safeNextPath } from "@/lib/auth/mfa";

/**
 * Step-up screen for a signed-in session that hasn't satisfied its second factor
 * (P1.23.3). Reached by redirect from `requireStaff`, never linked.
 *
 * Client-rendered so it can run without a server (P4.0, ADR-048). `safeNextPath`
 * still sanitises the `next` parameter — moving the read from the server to the
 * browser does not change that an open redirect is the risk here, and the check is
 * the same pure function either way.
 */
function MfaChallengeWithNext() {
  const next = useSearchParams().get("next");
  return <MfaChallenge next={safeNextPath(next, "/dashboard")} />;
}

export function MfaScreen() {
  const t = useTranslations("mfa");
  return (
    <main className="mx-auto flex w-full max-w-md flex-col gap-6 px-6 py-16">
      <div className="flex flex-col gap-2">
        <h1 className="font-display text-2xl text-text">{t("title")}</h1>
        <p className="text-sm text-text-muted">{t("intro")}</p>
      </div>
      {/* Locale-less: the challenge navigates with the i18n router. */}
      <Suspense fallback={null}>
        <MfaChallengeWithNext />
      </Suspense>
    </main>
  );
}
