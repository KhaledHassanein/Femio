import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { Baby, CalendarHeart, Flower2, Languages, ShieldCheck, Stethoscope } from "lucide-react";

import { PhoneMock } from "@/components/site/phone-mock";
import { Button } from "@/components/ui/button";
import { Link } from "@/i18n/navigation";
import { localizedAlternates } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string }> };

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "getApp" });
  return {
    title: t("metaTitle"),
    description: t("body"),
    alternates: localizedAlternates(locale, "/app"),
  };
}

const FEATURES = [
  { key: "period", Icon: CalendarHeart },
  { key: "fertile", Icon: Flower2 },
  { key: "pregnancy", Icon: Baby },
  { key: "private", Icon: ShieldCheck },
  { key: "arabic", Icon: Languages },
  { key: "doctor", Icon: Stethoscope },
] as const;

/**
 * `/app`: the product is the private Android app (D8, ADR-070), and this is where
 * every "get started" on the website leads, including the closed web-app routes.
 *
 * The store row says "coming soon" because there is no listing yet. It must not look
 * like Google's official badge, nor link to a listing that does not exist.
 */
export default async function GetAppPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("getApp");

  return (
    <main className="flex w-full flex-1 flex-col">

      <section className="aurora text-text-on-brand">
        <div className="mx-auto flex w-full max-w-5xl flex-col items-center gap-10 px-6 pb-16 pt-12 md:flex-row md:items-center">
          <div className="flex flex-1 flex-col gap-4">
            <p className="text-2xs font-semibold uppercase tracking-widest opacity-85">
              {t("eyebrow")}
            </p>
            <h1 className="font-display text-2xl leading-tight sm:text-3xl rtl:font-bold rtl:leading-relaxed">
              {t("title")}
            </h1>
            <p className="text-sm leading-relaxed opacity-95">{t("body")}</p>

            <ul className="mt-2 flex flex-wrap gap-3">
              <li className="flex items-center gap-3 rounded-lg bg-white/10 px-4 py-3 ring-1 ring-white/30 backdrop-blur-sm">
                <span className="text-sm font-semibold">{t("android")}</span>
                <span className="rounded-pill bg-white px-2.5 py-0.5 text-2xs font-semibold text-primary-solid">
                  {t("androidStatus")}
                </span>
              </li>
              <li className="flex items-center gap-3 rounded-lg px-4 py-3 ring-1 ring-white/25">
                <span className="text-sm font-semibold opacity-90">{t("ios")}</span>
                <span className="text-2xs opacity-80">{t("iosStatus")}</span>
              </li>
            </ul>
          </div>
          <PhoneMock
            strings={{
              day: t("mock.day"),
              title: t("mock.title"),
              range: t("mock.range"),
              note: t("mock.note"),
              period: t("mock.period"),
            }}
          />
        </div>
      </section>

      <section className="mx-auto flex w-full max-w-5xl flex-col gap-6 px-6 py-14">
        <h2 className="font-display text-xl text-text">{t("featuresTitle")}</h2>
        <ul className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {FEATURES.map(({ key, Icon }) => (
            <li key={key} className="flex gap-4 rounded-lg border border-border bg-surface p-5">
              <span className="flex size-11 shrink-0 items-center justify-center rounded-pill bg-primary-soft text-primary-soft-text">
                <Icon className="size-5" aria-hidden />
              </span>
              <div className="flex flex-col gap-1">
                <h3 className="text-sm font-semibold text-text">{t(`features.${key}.title`)}</h3>
                <p className="text-xs leading-relaxed text-text-muted">
                  {t(`features.${key}.body`)}
                </p>
              </div>
            </li>
          ))}
        </ul>
      </section>

      <section className="mx-auto mb-16 flex w-full max-w-5xl flex-col gap-4 px-6">
        <div className="flex flex-col gap-4 rounded-lg bg-accent-soft p-6 text-accent-soft-text sm:flex-row sm:items-center">
          <div className="flex flex-1 flex-col gap-1">
            <h2 className="font-display text-lg">{t("meanwhileTitle")}</h2>
            <p className="text-sm">{t("meanwhileBody")}</p>
          </div>
          <div className="flex flex-col gap-2 sm:flex-row">
            <Button asChild>
              <Link href="/calculators">{t("meanwhileCalculators")}</Link>
            </Button>
            <Button asChild variant="outline">
              <Link href="/learn">{t("meanwhileLearn")}</Link>
            </Button>
          </div>
        </div>
        <p className="text-2xs text-text-subtle">{t("notMedical")}</p>
      </section>
    </main>
  );
}
