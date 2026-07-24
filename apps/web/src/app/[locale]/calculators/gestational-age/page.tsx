import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { CalculatorLayout } from "@/components/calculators/calculator-layout";
import { GestationalAgeCalculator } from "@/components/calculators/gestational-age-calculator";
import { localizedAlternates } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string }> };
const PATH = "/calculators/gestational-age";

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "calculators" });
  return {
    title: t("gestationalAge.title"),
    description: t("gestationalAge.intro"),
    alternates: localizedAlternates(locale, PATH),
  };
}

export default async function Page({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("calculators");
  return (
    <CalculatorLayout
      title={t("gestationalAge.title")}
      intro={t("gestationalAge.intro")}
      disclaimer={t("disclaimer")}
      backLabel={t("common.back")}
      locale={locale}
      path={PATH}
    >
      <GestationalAgeCalculator />
    </CalculatorLayout>
  );
}
