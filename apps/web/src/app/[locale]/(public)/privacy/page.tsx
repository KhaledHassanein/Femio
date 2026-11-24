import type { Metadata } from "next";
import { getTranslations } from "next-intl/server";
import { LegalPage, legalMetadata } from "@/components/site/legal-page";

type PageProps = { params: Promise<{ locale: string }> };

// privacy page, text from docs/33_REBUILD_V3/03_LEGAL_PACK.md. Indexable and in the
// sitemap (R2.4); the owner's blanks ([ENTITY], [EMAIL], [DATE]) are in
// `lib/legal/placeholders.ts` and render highlighted until filled.
export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  return legalMetadata(locale, "privacy");
}

export default async function Page({ params }: PageProps) {
  const { locale } = await params;
  const nav = await getTranslations({ locale, namespace: "nav" });
  return (
    <LegalPage
      locale={locale}
      namespace="privacy"
      related={[
        { href: "/consumer-health-data", label: nav("healthData") },
        { href: "/terms", label: nav("terms") },
      ]}
    />
  );
}
