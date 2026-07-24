import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { CalculatorLayout } from "@/components/calculators/calculator-layout";
import { OvulationCalculator } from "@/components/calculators/ovulation-calculator";
import { localizedAlternates } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string }> };
const PATH = "/calculators/fertile-window";

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "calculators" });
  return {
    title: t("ovulation.title"),
    description: t("ovulation.intro"),
    alternates: localizedAlternates(locale, PATH),
  };
}

export default async function Page({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("calculators");
  return (
    <CalculatorLayout
      title={t("ovulation.title")}
      intro={t("ovulation.intro")}
      disclaimer={t("disclaimer")}
      backLabel={t("common.back")}
      locale={locale}
      path={PATH}
    >
      <OvulationCalculator />
    </CalculatorLayout>
  );
}
