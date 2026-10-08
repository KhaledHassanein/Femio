import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { CalculatorLayout } from "@/components/calculators/calculator-layout";
import { PregnancyTestCalculator } from "@/components/calculators/pregnancy-test-calculator";
import { localizedAlternates } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string }> };
const PATH = "/calculators/pregnancy-test";

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "calculators" });
  return {
    title: t("pregnancyTest.title"),
    description: t("pregnancyTest.intro"),
    alternates: localizedAlternates(locale, PATH),
  };
}

export default async function Page({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("calculators");
  return (
    <CalculatorLayout
      title={t("pregnancyTest.title")}
      intro={t("pregnancyTest.intro")}
      disclaimer={t("disclaimer")}
      backLabel={t("common.back")}
      appCta={t("appCta")}
      appCtaLink={t("appCtaLink")}
      locale={locale}
      path={PATH}
    >
      <PregnancyTestCalculator />
    </CalculatorLayout>
  );
}
