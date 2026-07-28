import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { createClient } from "@/lib/supabase/server";
import { requireStaff } from "@/lib/auth/require-staff";
import { flatten } from "@/lib/i18n/ui-strings";
import { TranslationEditor } from "@/components/admin/translation-editor";
import enMessages from "../../../../../../messages/en.json";

type PageProps = { params: Promise<{ locale: string }> };

export const dynamic = "force-dynamic";

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "admin" });
  return { title: t("title"), robots: { index: false, follow: false } };
}

export default async function TranslationsPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  // Back-office only. RLS is the real boundary; this keeps non-staff off the page.
  await requireStaff(locale, "admin", "translator");

  const flat = flatten(enMessages as Record<string, unknown> as Parameters<typeof flatten>[0]);
  const masters = Object.entries(flat).map(([key, en]) => ({ key, en }));

  const supabase = await createClient();
  const { data } = await supabase
    .from("ui_strings")
    .select("key, locale, value, status")
    .in("locale", ["ar", "fr", "es"]);

  const existing: Record<string, Record<string, { value: string; status: string }>> = {
    ar: {},
    fr: {},
    es: {},
  };
  for (const row of data ?? []) {
    const loc = row.locale as string;
    if (existing[loc]) existing[loc]![row.key as string] = { value: (row.value as string) ?? "", status: row.status as string };
  }

  const t = await getTranslations("admin");

  return (
    <main className="mx-auto flex w-full max-w-4xl flex-col gap-6 px-6 py-12">
      <div className="flex flex-col gap-1">
        <h1 className="font-display text-2xl text-text">{t("title")}</h1>
        <p className="text-sm text-text-muted">{t("desc")}</p>
      </div>
      <TranslationEditor masters={masters} existing={existing} />
    </main>
  );
}
