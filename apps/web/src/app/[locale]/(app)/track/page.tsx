import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { AuthGate } from "@/components/auth/auth-gate";
import { TrackScreen } from "@/components/cycle/track-screen";

type PageProps = { params: Promise<{ locale: string }> };

// Client-rendered screen so the tracker can run without a server (P4.0, ADR-048).
export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "track" });
  return { title: t("title"), robots: { index: false, follow: false } };
}

export default async function TrackPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  return (
    <AuthGate>
      <TrackScreen />
    </AuthGate>
  );
}
