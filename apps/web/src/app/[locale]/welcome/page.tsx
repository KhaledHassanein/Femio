import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { OnboardingWizard } from "@/components/onboarding/onboarding-wizard";
import { localizedAlternates } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string }> };

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "onboarding" });
  return {
    title: t("title"),
    alternates: localizedAlternates(locale, "/welcome"),
    robots: { index: false, follow: true },
  };
}

export default async function WelcomePage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  return <OnboardingWizard />;
}
