import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { Card, CardContent } from "@/components/ui/card";
import { Link } from "@/i18n/navigation";

type PageProps = { params: Promise<{ locale: string }> };

const TOOLS = [
  { slug: "due-date", key: "dueDate" },
  { slug: "fertile-window", key: "ovulation" },
  { slug: "gestational-age", key: "gestationalAge" },
  { slug: "bmi", key: "bmi" },
  { slug: "cycle-length", key: "cycleLength" },
] as const;

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "calculators" });
  return { title: `${t("title")} — Femio`, description: t("subtitle") };
}

export default async function CalculatorsPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("calculators");

  return (
    <main className="mx-auto flex w-full max-w-3xl flex-col gap-6 px-6 py-12">
      <div className="flex flex-col gap-1">
        <h1 className="font-display text-3xl text-text">{t("title")}</h1>
        <p className="text-sm text-text-muted">{t("subtitle")}</p>
      </div>
      <div className="grid gap-4 sm:grid-cols-2">
        {TOOLS.map((tool) => (
          <Link key={tool.slug} href={`/calculators/${tool.slug}`} className="rounded-md">
            <Card className="h-full transition-shadow hover:shadow-md">
              <CardContent className="flex flex-col gap-1 p-6">
                <p className="font-display text-lg text-text">{t(`list.${tool.key}.name`)}</p>
                <p className="text-sm text-text-muted">{t(`list.${tool.key}.desc`)}</p>
              </CardContent>
            </Card>
          </Link>
        ))}
      </div>
    </main>
  );
}
