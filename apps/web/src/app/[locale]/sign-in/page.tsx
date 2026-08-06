import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { SignInScreen } from "@/components/auth/sign-in-screen";
import { localizedAlternates } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string }> };

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "signIn" });
  return {
    title: t("title"),
    alternates: localizedAlternates(locale, "/sign-in"),
    robots: { index: false, follow: true },
  };
}

// `?error=1` is read in the browser now, so this page no longer needs a server
// (P4.0, ADR-048).
export default async function SignInPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  return <SignInScreen />;
}
