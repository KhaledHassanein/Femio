import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { CalculatorLayout } from "@/components/calculators/calculator-layout";
import { PeriodCalculator } from "@/components/calculators/period-calculator";
import { readFaqMessages } from "@/lib/calculators/faq";
import { localizedAlternates } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string }> };
const PATH = "/calculators/period";

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "calculators" });
  return {
    title: t("period.metaTitle"),
    description: t("period.intro"),
    alternates: localizedAlternates(locale, PATH),
  };
}

export default async function Page({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("calculators");
  return (
    <CalculatorLayout
      title={t("period.title")}
      intro={t("period.intro")}
      disclaimer={t("disclaimer")}
      backLabel={t("common.back")}
      faqTitle={t("faqTitle")}
      faq={readFaqMessages(t.raw("period.faq"))}
      locale={locale}
      path={PATH}
    >
      <PeriodCalculator />
    </CalculatorLayout>
  );
}
