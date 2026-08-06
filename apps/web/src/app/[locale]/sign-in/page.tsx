"use client";

// SPIKE STUB (P4.0 Step 1) — original at .spike-stash/original-pages/sign-in.page.tsx.
// The original read `await searchParams` for an error code; on a static export that
// becomes `useSearchParams()`. Small, contained fix.

import { Suspense } from "react";
import { useSearchParams } from "next/navigation";

function SignInInner() {
  const error = useSearchParams().get("error");
  return <main className="p-12">sign-in (spike stub){error ? ` — ${error}` : ""}</main>;
}

export default function SignInPage() {
  // `useSearchParams` forces a CSR bailout, which the export build requires to be
  // wrapped. Worth carrying into the real conversion.
  return (
    <Suspense fallback={<main className="p-12">…</main>}>
      <SignInInner />
    </Suspense>
  );
}
