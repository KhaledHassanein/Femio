import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { TrustPage } from "@/components/site/trust-page";
import { localizedAlternates } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string }> };
type Point = { heading: string; body: string };

// Terms of Service — published as a clearly-marked DRAFT (P1.9b.3); see the note on
// the privacy page. `noindex` + out of the sitemap until counsel finalizes at P0.12.
export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "terms" });
  return {
    title: t("title"),
    description: t("intro"),
    alternates: localizedAlternates(locale, "/terms"),
    robots: { index: false, follow: true },
  };
}

export default async function TermsPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("terms");
  const nav = await getTranslations("nav");
  return (
    <TrustPage
      title={t("title")}
      intro={t("intro")}
      notice={{ title: t("draft.title"), body: t("draft.body") }}
      points={t.raw("points") as Point[]}
      footnote={t("footnote")}
      related={[
        { href: "/privacy", label: nav("privacy") },
        { href: "/about", label: nav("about") },
      ]}
    />
  );
}
