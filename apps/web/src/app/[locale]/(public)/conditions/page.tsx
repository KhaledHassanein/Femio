import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { listContent } from "@/lib/cms/client";
import { lede } from "@/lib/cms/format";
import { ContentHub } from "@/components/cms/content-hub";
import { localizedAlternates } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string }> };

export const revalidate = 300;

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "conditions" });
  return {
    title: t("title"),
    description: t("subtitle"),
    alternates: localizedAlternates(locale, "/conditions"),
  };
}

export default async function ConditionsPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("conditions");
  const items = await listContent("conditions", locale);

  return (
    <ContentHub
      title={t("title")}
      subtitle={t("subtitle")}
      emptyText={t("empty")}
      items={items}
      hrefBase="/conditions"
      lede={lede}
    />
  );
}
