import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { AuthGate } from "@/components/auth/auth-gate";
import { MfaScreen } from "@/components/auth/mfa-screen";

type PageProps = { params: Promise<{ locale: string }> };

// Client-rendered screen so the tracker can run without a server (P4.0, ADR-048).
export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "mfa" });
  return { title: t("title"), robots: { index: false, follow: false } };
}

export default async function MfaPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  // A signed-out visitor belongs at sign-in, not welcome: reaching this page at all
  // means something tried to step up an existing session.
  return (
    <AuthGate redirectTo="/sign-in">
      <MfaScreen />
    </AuthGate>
  );
}
