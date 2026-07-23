import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { CalculatorLayout } from "@/components/calculators/calculator-layout";
import { GestationalAgeCalculator } from "@/components/calculators/gestational-age-calculator";

type PageProps = { params: Promise<{ locale: string }> };

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "calculators" });
  return { title: `${t("gestationalAge.title")} — Femio`, description: t("gestationalAge.intro") };
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
    >
      <GestationalAgeCalculator />
    </CalculatorLayout>
  );
}
