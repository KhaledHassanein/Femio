import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { CalculatorLayout } from "@/components/calculators/calculator-layout";
import { WeightGainCalculator } from "@/components/calculators/weight-gain-calculator";
import { readFaqMessages } from "@/lib/calculators/faq";
import { localizedAlternates } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string }> };
const PATH = "/calculators/pregnancy-weight-gain";

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "calculators" });
  return {
    title: t("weightGain.metaTitle"),
    description: t("weightGain.intro"),
    alternates: localizedAlternates(locale, PATH),
  };
}

export default async function Page({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("calculators");
  return (
    <CalculatorLayout
      title={t("weightGain.title")}
      intro={t("weightGain.intro")}
      disclaimer={t("disclaimer")}
      backLabel={t("common.back")}
      faqTitle={t("faqTitle")}
      faq={readFaqMessages(t.raw("weightGain.faq"))}
      locale={locale}
      path={PATH}
    >
      <WeightGainCalculator />
    </CalculatorLayout>
  );
}
