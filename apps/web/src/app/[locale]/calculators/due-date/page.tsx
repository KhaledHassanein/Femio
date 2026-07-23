import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { CalculatorLayout } from "@/components/calculators/calculator-layout";
import { DueDateCalculator } from "@/components/calculators/due-date-calculator";

type PageProps = { params: Promise<{ locale: string }> };

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "calculators" });
  return { title: `${t("dueDate.title")} — Femio`, description: t("dueDate.intro") };
}

export default async function Page({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("calculators");
  return (
    <CalculatorLayout
      title={t("dueDate.title")}
      intro={t("dueDate.intro")}
      disclaimer={t("disclaimer")}
      backLabel={t("common.back")}
    >
      <DueDateCalculator />
    </CalculatorLayout>
  );
}
