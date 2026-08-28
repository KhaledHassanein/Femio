import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { AuthGate } from "@/components/auth/auth-gate";
import { CalendarScreen } from "@/components/cycle/calendar-screen";

type PageProps = { params: Promise<{ locale: string }> };

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "calendar" });
  return { title: t("title"), robots: { index: false, follow: false } };
}

export default async function CalendarPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  return (
    <AuthGate>
      <CalendarScreen />
    </AuthGate>
  );
}
