import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { SignInForm } from "@/components/auth/sign-in-form";
import { localizedAlternates } from "@/lib/seo/metadata";
import { PageView } from "@/components/analytics/page-view";

type PageProps = {
  params: Promise<{ locale: string }>;
  searchParams: Promise<{ error?: string }>;
};

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "signIn" });
  return {
    title: t("title"),
    alternates: localizedAlternates(locale, "/sign-in"),
    robots: { index: false, follow: true },
  };
}

export default async function SignInPage({ params, searchParams }: PageProps) {
  const { locale } = await params;
  const { error } = await searchParams;
  setRequestLocale(locale);
  return (
    <main className="mx-auto flex w-full max-w-md flex-col gap-6 px-6 py-16">
      <PageView area="auth" />
      <SignInForm hadError={error === "1"} />
    </main>
  );
}
