import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { CalculatorLayout } from "@/components/calculators/calculator-layout";
import { ContractionTimer } from "@/components/calculators/contraction-timer";
import { readFaqMessages } from "@/lib/calculators/faq";
import { pageMetadata } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string }> };
const PATH = "/calculators/contraction-timer";

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "calculators" });
  return pageMetadata({ locale, path: PATH, title: t("contractionTimer.metaTitle"), description: t("contractionTimer.intro") });
}

export default async function Page({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("calculators");
  return (
    <CalculatorLayout
      title={t("contractionTimer.title")}
      intro={t("contractionTimer.intro")}
      disclaimer={t("disclaimer")}
      backLabel={t("common.back")}
      faqTitle={t("faqTitle")}
      faq={readFaqMessages(t.raw("contractionTimer.faq"))}
      locale={locale}
      path={PATH}
    >
      <ContractionTimer />
    </CalculatorLayout>
  );
}
