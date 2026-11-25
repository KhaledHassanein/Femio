import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { TrustPage } from "@/components/site/trust-page";
import { pageMetadata } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string }> };
type Point = { heading: string; body: string };

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "editorialPolicy" });
  return pageMetadata({ locale, path: "/editorial-policy", title: t("title"), description: t("intro") });
}

export default async function EditorialPolicyPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("editorialPolicy");
  const nav = await getTranslations("nav");
  return (
    <TrustPage
      title={t("title")}
      intro={t("intro")}
      points={t.raw("points") as Point[]}
      related={[
        { href: "/medical-review", label: nav("medicalReview") },
        { href: "/about", label: nav("about") },
      ]}
    />
  );
}
