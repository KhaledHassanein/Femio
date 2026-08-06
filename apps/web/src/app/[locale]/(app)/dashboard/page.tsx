import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { AuthGate } from "@/components/auth/auth-gate";
import { DashboardScreen } from "@/components/dashboard/dashboard-screen";

type PageProps = { params: Promise<{ locale: string }> };

// No `force-dynamic` and no server-side read: the screen fetches its own data in the
// browser so it can also run inside a Capacitor bundle (P4.0, ADR-048). `generateMetadata`
// stays server-side because it resolves at build time and exports fine.
export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "dashboard" });
  return { title: t("title"), robots: { index: false, follow: false } };
}

export default async function DashboardPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  return (
    <AuthGate>
      <DashboardScreen />
    </AuthGate>
  );
}
