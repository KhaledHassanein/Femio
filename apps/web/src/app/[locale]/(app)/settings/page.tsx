import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { createClient } from "@/lib/supabase/server";
import { Card, CardContent } from "@/components/ui/card";
import { ExportButton } from "@/components/account/export-button";
import { DeleteButton } from "@/components/account/delete-button";
import { SetPassword } from "@/components/account/set-password";
import { Button } from "@/components/ui/button";
import { Link } from "@/i18n/navigation";

type PageProps = { params: Promise<{ locale: string }> };

export const dynamic = "force-dynamic";

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "settings" });
  return { title: t("title"), robots: { index: false, follow: false } };
}

export default async function SettingsPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect(`/${locale}/welcome`);

  const t = await getTranslations("settings");

  return (
    <main className="mx-auto flex w-full max-w-2xl flex-col gap-6 px-6 py-12">
      <h1 className="font-display text-2xl text-text">{t("title")}</h1>

      <Card>
        <CardContent className="flex flex-col gap-3 p-6">
          <div className="flex flex-col gap-1">
            <h2 className="text-md font-semibold text-text">{t("summary.heading")}</h2>
            <p className="text-sm text-text-muted">{t("summary.desc")}</p>
          </div>
          <Button asChild variant="outline" className="self-start">
            <Link href="/summary">{t("summary.link")}</Link>
          </Button>
        </CardContent>
      </Card>

      <Card>
        <CardContent className="flex flex-col gap-3 p-6">
          <div className="flex flex-col gap-1">
            <h2 className="text-md font-semibold text-text">{t("password.heading")}</h2>
            <p className="text-sm text-text-muted">{t("password.desc")}</p>
          </div>
          <SetPassword />
        </CardContent>
      </Card>

      <Card>
        <CardContent className="flex flex-col gap-3 p-6">
          <div className="flex flex-col gap-1">
            <h2 className="text-md font-semibold text-text">{t("export.heading")}</h2>
            <p className="text-sm text-text-muted">{t("export.desc")}</p>
          </div>
          <ExportButton />
        </CardContent>
      </Card>

      <Card>
        <CardContent className="flex flex-col gap-3 p-6">
          <div className="flex flex-col gap-1">
            <h2 className="text-md font-semibold text-text">{t("delete.heading")}</h2>
            <p className="text-sm text-text-muted">{t("delete.desc")}</p>
          </div>
          <DeleteButton />
        </CardContent>
      </Card>
    </main>
  );
}
