import type { Metadata } from "next";
import { getFormatter, getTranslations, setRequestLocale } from "next-intl/server";
import { CrisisContentView } from "@/components/crisis/crisis-content-view";
import {
  CountryList,
  CountryNumbers,
  type CountryBlock,
} from "@/components/crisis/country-numbers";
import { getCrisisContent } from "@/lib/crisis/content";
import {
  COUNTRY_IDS,
  COUNTRY_NUMBERS,
  COUNTRY_NUMBERS_CHECKED,
  type CountryId,
} from "@/lib/crisis/country-numbers";
import { env } from "@/lib/env";
import { localizedAlternates } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string }> };

// Public, account-less crisis page. It collects nothing (no questionnaire, no
// health data) and is intentionally kept OUT of search: `noindex` here + excluded
// from sitemap.ts. Fully server-rendered so it works with JS disabled and offline.
//
// Order (02_DESIGN_SPEC section 3): the global guidance first, verbatim from the guarded
// crisis.json, always visible. Below it, a country block: two buttons (Egypt, Saudi
// Arabia), and that country's sourced numbers only after a choice, so no number is ever
// presented as global. Without JavaScript both countries are listed under their own names.
export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const content = getCrisisContent(locale);
  return {
    title: content.strings.dialogTitle,
    alternates: localizedAlternates(locale, "/help-now"),
    robots: { index: false, follow: false },
  };
}

export default async function HelpNowPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const content = getCrisisContent(locale);
  const t = await getTranslations({ locale, namespace: "helpNow" });
  const format = await getFormatter();

  const countries: CountryBlock[] = COUNTRY_IDS.map((id: CountryId) => ({
    id,
    name: t(`countries.${id}`),
    groups: (["emergency", "support"] as const)
      .map((kind) => ({
        kind,
        title: t(`groups.${kind}`),
        rows: COUNTRY_NUMBERS[id]
          .filter((n) => n.kind === kind)
          .map((n) => ({
            id: n.id,
            number: n.number,
            label: t(`numbers.${n.id}`),
            callLabel: t("call", { number: n.number }),
            sourceUrl: n.sourceUrl,
          })),
      }))
      .filter((g) => g.rows.length > 0),
  }));
  const sourceLabel = t("source");

  return (
    <main className="mx-auto flex w-full max-w-lg flex-col gap-6 px-6 py-12">
      {/* The title is the guarded `dialogTitle`, so the heading never drifts from the approved copy. */}
      <h1 lang={content.lang} dir={content.dir} className="font-display text-2xl text-text">
        {content.strings.dialogTitle}
      </h1>
      <CrisisContentView content={content} directoryUrl={env.NEXT_PUBLIC_CRISIS_DIRECTORY_URL} />

      <section
        aria-labelledby="country-heading"
        className="flex flex-col gap-4 border-t border-border pt-6"
      >
        <h2 id="country-heading" className="font-display text-lg text-text">
          {t("heading")}
        </h2>
        <CountryNumbers prompt={t("prompt")} countries={countries} sourceLabel={sourceLabel} />
        <noscript>
          <div className="flex flex-col gap-6">
            {countries.map((c) => (
              <div key={c.id} className="flex flex-col gap-3">
                <h3 className="font-display text-lg text-text">{c.name}</h3>
                <CountryList country={c} sourceLabel={sourceLabel} />
              </div>
            ))}
          </div>
        </noscript>
        <p className="text-sm text-text-muted">{t("regionNote")}</p>
        <p className="text-2xs text-text-subtle">
          {t("checked", {
            date: format.dateTime(new Date(`${COUNTRY_NUMBERS_CHECKED}T00:00:00Z`), {
              dateStyle: "long",
              timeZone: "UTC",
            }),
          })}
        </p>
      </section>
    </main>
  );
}
