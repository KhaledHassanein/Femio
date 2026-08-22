import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { AuthGate } from "@/components/auth/auth-gate";
import { ToolsScreen } from "@/components/tools/tools-screen";

type PageProps = { params: Promise<{ locale: string }> };

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "tools" });
  return { title: t("title"), robots: { index: false, follow: false } };
}

export default async function ToolsPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  return (
    <AuthGate>
      <ToolsScreen />
    </AuthGate>
  );
}
