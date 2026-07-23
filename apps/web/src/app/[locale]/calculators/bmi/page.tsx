import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { CalculatorLayout } from "@/components/calculators/calculator-layout";
import { BmiCalculator } from "@/components/calculators/bmi-calculator";

type PageProps = { params: Promise<{ locale: string }> };

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "calculators" });
  return { title: `${t("bmi.title")} — Femio`, description: t("bmi.intro") };
}

export default async function Page({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("calculators");
  return (
    <CalculatorLayout
      title={t("bmi.title")}
      intro={t("bmi.intro")}
      disclaimer={t("disclaimer")}
      backLabel={t("common.back")}
    >
      <BmiCalculator />
    </CalculatorLayout>
  );
}
