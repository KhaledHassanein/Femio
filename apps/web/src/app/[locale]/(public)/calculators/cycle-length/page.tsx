import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { CalculatorLayout } from "@/components/calculators/calculator-layout";
import { CycleLengthCalculator } from "@/components/calculators/cycle-length-calculator";
import { localizedAlternates } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string }> };
const PATH = "/calculators/cycle-length";

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "calculators" });
  return {
    title: t("cycleLength.title"),
    description: t("cycleLength.intro"),
    alternates: localizedAlternates(locale, PATH),
  };
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
      privateNote={t("privateNote")}
      backLabel={t("common.back")}
      appCta={t("appCta")}
      appCtaLink={t("appCtaLink")}
      locale={locale}
      path={PATH}
    >
      <CycleLengthCalculator />
    </CalculatorLayout>
  );
}
