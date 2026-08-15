import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { AuthGate } from "@/components/auth/auth-gate";
import { FertilityScreen } from "@/components/fertility/fertility-screen";

type PageProps = { params: Promise<{ locale: string }> };

// Client-rendered screen so the tracker can run without a server (P4.0, ADR-048).
export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "fertility" });
  return { title: t("title"), robots: { index: false, follow: false } };
}

export default async function FertilityPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  return (
    <AuthGate>
      <FertilityScreen />
    </AuthGate>
  );
}
