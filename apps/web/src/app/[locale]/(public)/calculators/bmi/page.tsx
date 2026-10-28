import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { CalculatorLayout } from "@/components/calculators/calculator-layout";
import { BmiCalculator } from "@/components/calculators/bmi-calculator";
import { readFaqMessages } from "@/lib/calculators/faq";
import { localizedAlternates } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string }> };
const PATH = "/calculators/bmi";

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "calculators" });
  return {
    title: t("bmi.metaTitle"),
    description: t("bmi.intro"),
    alternates: localizedAlternates(locale, PATH),
  };
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
      faqTitle={t("faqTitle")}
      faq={readFaqMessages(t.raw("bmi.faq"))}
      locale={locale}
      path={PATH}
    >
      <BmiCalculator />
    </CalculatorLayout>
  );
}
