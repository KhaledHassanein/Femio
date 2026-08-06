"use client";

// SPIKE STUB (P4.0 Step 1) — original at .spike-stash/original-pages/dashboard.page.tsx.
// Deliberately realistic rather than empty: it exercises the two things the export
// build needs to prove — `useTranslations` resolving client-side, and a browser
// Supabase read replacing the server one.

import { useEffect, useState } from "react";
import { useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import { predictNextPeriod } from "@/lib/cycle/predict";

export default function DashboardPage() {
  const t = useTranslations("dashboard");
  const [starts, setStarts] = useState<string[] | null>(null);

  useEffect(() => {
    const supabase = createClient();
    void (async () => {
      const { data } = await supabase
        .from("cycles")
        .select("period_start")
        .order("period_start", { ascending: false });
      setStarts((data ?? []).map((c) => c.period_start as string));
    })();
  }, []);

  if (starts === null) return <main className="p-12">…</main>;

  const prediction = predictNextPeriod(starts);

  return (
    <main className="mx-auto flex w-full max-w-2xl flex-col gap-6 px-6 py-12">
      <h1 className="font-display text-2xl text-text">{t("title")}</h1>
      <p className="text-sm text-text-muted">
        {prediction ? `${prediction.windowStart} → ${prediction.windowEnd}` : t("needData")}
      </p>
    </main>
  );
}
