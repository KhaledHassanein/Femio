import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { CalculatorLayout } from "@/components/calculators/calculator-layout";
import { PregnancyTestCalculator } from "@/components/calculators/pregnancy-test-calculator";
import { readFaqMessages } from "@/lib/calculators/faq";
import { pageMetadata } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string }> };
const PATH = "/calculators/pregnancy-test";

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "calculators" });
  return pageMetadata({ locale, path: PATH, title: t("pregnancyTest.metaTitle"), description: t("pregnancyTest.intro") });
}

export default async function Page({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("calculators");
  return (
    <CalculatorLayout
      title={t("pregnancyTest.title")}
      intro={t("pregnancyTest.intro")}
      disclaimer={t("disclaimer")}
      backLabel={t("common.back")}
      faqTitle={t("faqTitle")}
      faq={readFaqMessages(t.raw("pregnancyTest.faq"))}
      locale={locale}
      path={PATH}
    >
      <PregnancyTestCalculator />
    </CalculatorLayout>
  );
}
