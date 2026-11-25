import type { Metadata } from "next";
import { getTranslations } from "next-intl/server";
import { LegalPage, legalMetadata } from "@/components/site/legal-page";

type PageProps = { params: Promise<{ locale: string }> };

// Consumer health data policy (ADR-080). Washington's My Health My Data Act
// (RCW 19.373.020) asks for it as a separate page linked from the homepage; the footer
// on every page links here. Text: `healthData` namespace in the four catalogues.
export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  return legalMetadata(locale, "healthData");
}

export default async function Page({ params }: PageProps) {
  const { locale } = await params;
  const nav = await getTranslations({ locale, namespace: "nav" });
  return (
    <LegalPage
      locale={locale}
      namespace="healthData"
      related={[
        { href: "/privacy", label: nav("privacy") },
        { href: "/terms", label: nav("terms") },
      ]}
    />
  );
}
