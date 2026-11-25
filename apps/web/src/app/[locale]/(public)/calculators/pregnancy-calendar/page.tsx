import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { CalculatorLayout } from "@/components/calculators/calculator-layout";
import { PregnancyCalendarCalculator } from "@/components/calculators/pregnancy-calendar-calculator";
import { readFaqMessages } from "@/lib/calculators/faq";
import { pageMetadata } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string }> };
const PATH = "/calculators/pregnancy-calendar";

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "calculators" });
  return pageMetadata({ locale, path: PATH, title: t("pregnancyCalendar.metaTitle"), description: t("pregnancyCalendar.intro") });
}

export default async function Page({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("calculators");
  return (
    <CalculatorLayout
      title={t("pregnancyCalendar.title")}
      intro={t("pregnancyCalendar.intro")}
      disclaimer={t("disclaimer")}
      backLabel={t("common.back")}
      faqTitle={t("faqTitle")}
      faq={readFaqMessages(t.raw("pregnancyCalendar.faq"))}
      locale={locale}
      path={PATH}
    >
      <PregnancyCalendarCalculator />
    </CalculatorLayout>
  );
}
