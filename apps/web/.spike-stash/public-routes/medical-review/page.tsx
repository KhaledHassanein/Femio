import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { TrustPage } from "@/components/site/trust-page";
import { localizedAlternates } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string }> };
type Point = { heading: string; body: string };

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "medicalReview" });
  return { title: t("title"), description: t("intro"), alternates: localizedAlternates(locale, "/medical-review") };
}

export default async function MedicalReviewPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("medicalReview");
  const nav = await getTranslations("nav");
  return (
    <TrustPage
      title={t("title")}
      intro={t("intro")}
      points={t.raw("points") as Point[]}
      related={[
        { href: "/editorial-policy", label: nav("editorial") },
        { href: "/about", label: nav("about") },
      ]}
    />
  );
}
