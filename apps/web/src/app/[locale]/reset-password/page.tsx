import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { ResetPasswordForm } from "@/components/auth/reset-password-form";
import { PageView } from "@/components/analytics/page-view";

type PageProps = { params: Promise<{ locale: string }> };

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "resetPassword" });
  return { title: t("title"), robots: { index: false, follow: false } };
}

export default async function ResetPasswordPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  return (
    <main className="mx-auto flex w-full max-w-md flex-col gap-6 px-6 py-16">
      <PageView area="auth" />
      <ResetPasswordForm />
    </main>
  );
}
