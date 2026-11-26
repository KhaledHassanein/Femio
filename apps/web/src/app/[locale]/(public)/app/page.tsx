import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import {
  Baby,
  CalendarRange,
  ClipboardList,
  Languages,
  LayoutDashboard,
  Lightbulb,
  MessageCircleQuestion,
  PenLine,
  ShieldCheck,
} from "lucide-react";

import { AppTourSection, TryDemosSection, WhatCanLeaveSection } from "@/components/demos/demo-sections";

import { PhoneMock } from "@/components/site/phone-mock";
import { TestBuildCard } from "@/components/site/test-build-card";
import { Button } from "@/components/ui/button";
import { Link } from "@/i18n/navigation";
import { pageMetadata } from "@/lib/seo/metadata";
import { APK_DOWNLOAD_URL, PLAY_STORE_URL } from "@/lib/site";

type PageProps = { params: Promise<{ locale: string }> };

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "getApp" });
  return pageMetadata({ locale, path: "/app", title: t("metaTitle"), description: t("body") });
}

const FEATURES = [
  { key: "today", Icon: LayoutDashboard },
  { key: "calendar", Icon: CalendarRange },
  { key: "ask", Icon: MessageCircleQuestion },
  { key: "sayIt", Icon: PenLine },
  { key: "tips", Icon: Lightbulb },
  { key: "visit", Icon: ClipboardList },
  { key: "pregnancy", Icon: Baby },
  { key: "private", Icon: ShieldCheck },
  { key: "languages", Icon: Languages },
] as const;

/**
 * `/app`: the product is the private Android app (D8, ADR-070), and this is where
 * every "get started" on the website leads, including the closed web-app routes.
 *
 * The store row says "coming soon" because there is no listing yet. It must not look
 * like Google's official badge, nor link to a listing that does not exist.
 *
 * R2.10 (2026-11-24): the page shows the app as built: the feature list follows the app's
 * screens, a tour of real app screens, three demos on sample data, and "what can leave
 * this phone", which restates the privacy policy's complete list.
 *
 * R14.4 (2026-11-27): right under the hero, the early test build card gives a tester or a
 * judge an install path (`APK_DOWNLOAD_URL`), or says honestly that the link is coming.
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
            <p className="text-sm leading-relaxed opacity-95">{PLAY_STORE_URL ? t("bodyLive") : t("body")}</p>

            <ul className="mt-2 flex flex-wrap gap-3">
              <li className="flex items-center gap-3 rounded-lg bg-white/10 px-4 py-3 ring-1 ring-white/30 backdrop-blur-sm">
                <span className="text-sm font-semibold">{t("android")}</span>
                {PLAY_STORE_URL ? (
                  <a
                    href={PLAY_STORE_URL}
                    rel="noopener"
                    className="rounded-pill bg-white px-2.5 py-0.5 text-2xs font-semibold text-primary-solid underline-offset-2 hover:underline"
                  >
                    {t("androidLive")}
                  </a>
                ) : (
                  <span className="rounded-pill bg-white px-2.5 py-0.5 text-2xs font-semibold text-primary-solid">
                    {t("androidStatus")}
                  </span>
                )}
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

      <TestBuildCard
        url={APK_DOWNLOAD_URL}
        strings={{
          title: t("testBuild.title"),
          body: t("testBuild.body"),
          soon: t("testBuild.soon"),
          soonBody: t("testBuild.soonBody"),
          download: t("testBuild.download"),
          stepsTitle: t("testBuild.stepsTitle"),
          steps: [t("testBuild.steps.download"), t("testBuild.steps.allow"), t("testBuild.steps.open")],
        }}
      />

      <section className="mx-auto flex w-full max-w-5xl flex-col gap-6 px-6 py-14">
        <h2 className="font-display text-xl text-text rtl:font-bold">{t("featuresTitle")}</h2>
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
        <p className="rounded-md bg-primary-soft px-4 py-3 text-xs leading-relaxed text-primary-soft-text">
          {t("companion")}
        </p>
      </section>

      <AppTourSection locale={locale} />
      <TryDemosSection locale={locale} />
      <WhatCanLeaveSection locale={locale} />

      <section className="mx-auto my-16 flex w-full max-w-5xl flex-col gap-4 px-6">
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
