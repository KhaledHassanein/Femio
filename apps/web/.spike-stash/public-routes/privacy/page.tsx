import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { TrustPage } from "@/components/site/trust-page";
import { localizedAlternates } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string }> };
type Point = { heading: string; body: string };

// Privacy Policy — published as a clearly-marked DRAFT (P1.9b.3). The binding text
// is finalized by counsel + the DPO at the P0.12 launch gate; until then the page is
// `noindex` and kept out of the sitemap so search engines never present a draft as
// Femio's policy of record. Flipping both (here + app/sitemap.ts) is part of P0.12.
export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "privacy" });
  return {
    title: t("title"),
    description: t("intro"),
    alternates: localizedAlternates(locale, "/privacy"),
    robots: { index: false, follow: true },
  };
}

export default async function PrivacyPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("privacy");
  const nav = await getTranslations("nav");
  return (
    <TrustPage
      title={t("title")}
      intro={t("intro")}
      notice={{ title: t("draft.title"), body: t("draft.body") }}
      points={t.raw("points") as Point[]}
      footnote={t("footnote")}
      related={[
        { href: "/terms", label: nav("terms") },
        { href: "/about", label: nav("about") },
      ]}
    />
  );
}
