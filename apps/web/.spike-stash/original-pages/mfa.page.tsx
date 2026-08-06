import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { createClient } from "@/lib/supabase/server";
import { MfaChallenge } from "@/components/auth/mfa-challenge";
import { safeNextPath } from "@/lib/auth/mfa";

type PageProps = {
  params: Promise<{ locale: string }>;
  searchParams: Promise<{ next?: string }>;
};

export const dynamic = "force-dynamic";

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "mfa" });
  return { title: t("title"), robots: { index: false, follow: false } };
}

// Step-up page for a signed-in session that hasn't satisfied its second factor
// (P1.23.3). Reached by redirect from `requireStaff`, never linked.
export default async function MfaPage({ params, searchParams }: PageProps) {
  const { locale } = await params;
  const { next } = await searchParams;
  setRequestLocale(locale);

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect(`/${locale}/sign-in`);

  const t = await getTranslations("mfa");

  return (
    <main className="mx-auto flex w-full max-w-md flex-col gap-6 px-6 py-16">
      <div className="flex flex-col gap-2">
        <h1 className="font-display text-2xl text-text">{t("title")}</h1>
        <p className="text-sm text-text-muted">{t("intro")}</p>
      </div>
      {/* Locale-less: the challenge navigates with the i18n router. */}
      <MfaChallenge next={safeNextPath(next, "/dashboard")} />
    </main>
  );
}
