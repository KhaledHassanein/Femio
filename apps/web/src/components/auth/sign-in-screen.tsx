"use client";

import { Suspense } from "react";
import { useSearchParams } from "next/navigation";
import { SignInForm } from "@/components/auth/sign-in-form";
import { PageView } from "@/components/analytics/page-view";

/**
 * Sign-in, client-rendered so it can run without a server (P4.0, ADR-048).
 *
 * The only server dependency was reading `?error=1`, which the auth callback sets
 * when a magic link fails. `useSearchParams` bails out of prerendering, so it is
 * isolated in its own Suspense boundary — the form itself still prerenders.
 */
function SignInFormWithError() {
  const hadError = useSearchParams().get("error") === "1";
  return <SignInForm hadError={hadError} />;
}

export function SignInScreen() {
  return (
    <main className="mx-auto flex w-full max-w-md flex-col gap-6 px-6 py-16">
      <PageView area="auth" />
      <Suspense fallback={<SignInForm hadError={false} />}>
        <SignInFormWithError />
      </Suspense>
    </main>
  );
}
