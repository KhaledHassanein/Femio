import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { Baby, CalendarDays, CalendarHeart, CalendarRange, Flower2, Hourglass, Ruler, Scale, TestTube, Timer } from "lucide-react";
import { Link } from "@/i18n/navigation";
import { pageMetadata } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string }> };

// Ordered by what women search for (Flo's calculator set, `04_ANDROID_APP_SPEC` §2):
// period and ovulation first, then pregnancy, then the general tools.
const TOOLS = [
  { slug: "period", key: "period", Icon: CalendarHeart },
  { slug: "fertile-window", key: "ovulation", Icon: Flower2 },
  { slug: "pregnancy-test", key: "pregnancyTest", Icon: TestTube },
  { slug: "due-date", key: "dueDate", Icon: Baby },
  { slug: "gestational-age", key: "gestationalAge", Icon: Timer },
  { slug: "pregnancy-calendar", key: "pregnancyCalendar", Icon: CalendarDays },
  { slug: "pregnancy-weight-gain", key: "weightGain", Icon: Scale },
  { slug: "contraction-timer", key: "contractionTimer", Icon: Hourglass },
  { slug: "cycle-length", key: "cycleLength", Icon: CalendarRange },
  { slug: "bmi", key: "bmi", Icon: Ruler },
] as const;

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "calculators" });
  return pageMetadata({ locale, path: "/calculators", title: t("title"), description: t("subtitle") });
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
        {TOOLS.map(({ slug, key, Icon }) => (
          <Link
            key={slug}
            href={`/calculators/${slug}`}
            className="group flex items-start gap-4 rounded-lg border border-border bg-surface p-5 transition-shadow hover:shadow-md"
          >
            <span className="flex size-12 shrink-0 items-center justify-center rounded-pill bg-primary-soft text-primary-soft-text transition-transform motion-safe:group-hover:scale-105">
              <Icon className="size-6" aria-hidden />
            </span>
            <span className="flex flex-col gap-1">
              <span className="font-display text-lg text-text">{t(`list.${key}.name`)}</span>
              <span className="text-sm text-text-muted">{t(`list.${key}.desc`)}</span>
            </span>
          </Link>
        ))}
      </div>
    </main>
  );
}
