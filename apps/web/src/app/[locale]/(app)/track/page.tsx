"use client";

// SPIKE STUB (P4.0 Step 1) — original at .spike-stash/original-pages/track.page.tsx.
// Keeps the real LogSymptoms child, which is already a client component and is the
// path offline sync actually runs through.

import { useTranslations } from "next-intl";
import { LogSymptoms } from "@/components/cycle/log-symptoms";

export default function TrackPage() {
  const t = useTranslations("track");
  return (
    <main className="mx-auto flex w-full max-w-2xl flex-col gap-6 px-6 py-12">
      <h1 className="font-display text-2xl text-text">{t("title")}</h1>
      <LogSymptoms />
    </main>
  );
}
