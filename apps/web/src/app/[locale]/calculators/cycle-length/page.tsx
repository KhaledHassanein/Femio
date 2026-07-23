import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { CalculatorLayout } from "@/components/calculators/calculator-layout";
import { CycleLengthCalculator } from "@/components/calculators/cycle-length-calculator";

type PageProps = { params: Promise<{ locale: string }> };

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "calculators" });
  return { title: `${t("cycleLength.title")} — Femio`, description: t("cycleLength.intro") };
}

export default async function Page({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("calculators");
  return (
    <CalculatorLayout
      title={t("cycleLength.title")}
      intro={t("cycleLength.intro")}
      disclaimer={t("disclaimer")}
      backLabel={t("common.back")}
    >
      <CycleLengthCalculator />
    </CalculatorLayout>
  );
}
