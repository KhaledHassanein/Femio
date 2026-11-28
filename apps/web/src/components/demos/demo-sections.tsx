/**
 * The website's app sections (R2.10), rendered on the server: the tour, the three
 * "try it" demos and "what can leave this phone".
 *
 * Why it exists: the demos are client components, but their words come from the
 * catalogs (`appDemo.*`, with `appDemo.app` synced word for word from the app's ARB
 * files by `scripts/web/sync-app-strings.mjs`). Resolving them here and passing plain
 * strings keeps the catalogs off the browser and keeps one place that decides which
 * app sentence each demo quotes. `/app` and the home page share these sections.
 */
import { getFormatter, getTranslations } from "next-intl/server";
import { CloudCog, Link2, Save, Share2, ShieldCheck, Smartphone, Store } from "lucide-react";

import { Link } from "@/i18n/navigation";
import {
  ASK_SOURCE,
  PERIOD_PATTERNS,
  periodDemo,
  periodTimeline,
  SAY_IT_TERMS,
  TOUR_SCREEN_WIDTH,
  TOUR_SCREENS,
  tourImage,
  type PeriodPattern,
} from "@/lib/demos/samples";

import { AppTour } from "./app-tour";
import { AskDemo } from "./ask-demo";
import { DemoLabel } from "./demo-label";
import { PeriodsDemo, type PeriodView } from "./periods-demo";
import { SayItDemo } from "./say-it-demo";

/** The most words one Say it sample can find, so the save button has a label for each count. */
const maxSayItTerms = Math.max(...Object.values(SAY_IT_TERMS).map((terms) => terms.length));

/** A stored day (YYYY-MM-DD) as a Date at UTC midnight, for formatting with timeZone UTC. */
function utcDay(iso: string): Date {
  return new Date(`${iso}T00:00:00Z`);
}

function Heading({
  eyebrow,
  title,
  body,
  demo,
}: {
  eyebrow: string;
  title: string;
  body?: string;
  /** When set, the heading carries the "Demo" label and its scripted-example note. */
  demo?: { label: string; note: string };
}) {
  return (
    <div className="flex flex-col gap-2">
      <p className="text-2xs font-semibold uppercase tracking-wider text-primary rtl:normal-case rtl:tracking-normal">
        {eyebrow}
      </p>
      <h2 className="font-display text-xl text-text rtl:font-bold">{title}</h2>
      {demo && <DemoLabel strings={demo} />}
      {body && <p className="text-sm leading-relaxed text-text-muted">{body}</p>}
    </div>
  );
}

/** The tour of real app screens. */
export async function AppTourSection({ locale }: { locale: string }) {
  const t = await getTranslations({ locale, namespace: "appDemo.tour" });
  const steps = TOUR_SCREENS.map(({ key, height }) => {
    const { light, dark } = tourImage(key, locale);
    return {
      key,
      label: t(`steps.${key}.label`),
      title: t(`steps.${key}.title`),
      body: t(`steps.${key}.body`),
      alt: t(`steps.${key}.alt`),
      light,
      dark,
      ratio: height / TOUR_SCREEN_WIDTH,
    };
  });
  return (
    <section id="tour" className="scroll-mt-20">
      <div className="mx-auto flex w-full max-w-5xl flex-col gap-8 px-6 py-14">
        <Heading eyebrow={t("eyebrow")} title={t("heading")} body={t("sub")} />
        <AppTour
          steps={steps}
          strings={{ pause: t("pause"), play: t("play"), synthetic: t("synthetic"), languagesNote: t("languagesNote") }}
        />
      </div>
    </section>
  );
}

/** The three interactive demos: next periods, Say it, Ask femio. */
export async function TryDemosSection({ locale }: { locale: string }) {
  const t = await getTranslations({ locale, namespace: "appDemo" });
  const format = await getFormatter({ locale });
  const demo = { label: t("label"), note: t("scripted") };
  const reviewed = format.dateTime(utcDay(ASK_SOURCE.reviewed), { dateStyle: "medium", timeZone: "UTC" });

  // Every date is formatted here, once: Node and the browser put different spaces in a
  // formatted range, so a range formatted on both sides would not hydrate.
  const confidence = { high: t("app.confidenceHigh"), medium: t("app.confidenceMedium"), low: t("app.confidenceLowShort") };
  const day = (iso: string) => format.dateTime(utcDay(iso), { day: "numeric", month: "long", timeZone: "UTC" });
  const range = (from: string, to: string) =>
    format
      .dateTimeRange(utcDay(from), utcDay(to), { day: "numeric", month: "short", timeZone: "UTC" })
      // Keep "12 – 18" in reading order inside Arabic text.
      .replace(/(\d+)(\s*[–—-]\s*)(\d+)/, "$1‎$2‎$3");
  const periodViews = Object.fromEntries(
    PERIOD_PATTERNS.map((pattern) => {
      const demo = periodDemo(pattern);
      const timeline = periodTimeline(demo);
      const view: PeriodView = {
        note: `${t(`periods.notes.${pattern}`)} ${t("periods.lastLogged", { date: day(demo.lastStart) })}`,
        bars: timeline.bars,
        ticks: timeline.ticks.map((tick) => ({
          at: tick.at,
          label: format.dateTime(utcDay(tick.iso), { month: "short", timeZone: "UTC" }),
        })),
        rows: demo.periods.map((p) => ({
          range: range(p.windowStart, p.windowEnd),
          confidence: confidence[p.confidence],
          low: p.confidence === "low",
        })),
        footer: demo.periods.length > 1 ? t("app.upcomingPeriodsWider") : t("app.upcomingPeriodsOnlyNext"),
      };
      return [pattern, view];
    }),
  ) as Record<PeriodPattern, PeriodView>;

  return (
    <section className="bg-surface-sunken">
      <div className="mx-auto grid w-full max-w-5xl gap-12 px-6 py-14 lg:grid-cols-2">
        <div className="flex flex-col gap-5 lg:col-span-2 lg:max-w-2xl">
          <Heading eyebrow={t("periods.eyebrow")} title={t("periods.heading")} body={t("periods.body")} demo={demo} />
          <PeriodsDemo
            views={periodViews}
            strings={{
              patternsLabel: t("periods.patternsLabel"),
              patterns: { regular: t("periods.patterns.regular"), varies: t("periods.patterns.varies"), new: t("periods.patterns.new") },
              caption: t("periods.caption"),
              title: t("app.upcomingPeriodsTitle"),
            }}
          />
        </div>

        <div className="flex flex-col gap-5">
          <Heading eyebrow={t("sayIt.eyebrow")} title={t("sayIt.heading")} body={t("sayIt.body")} demo={demo} />
          <SayItDemo
            strings={{
              samplesLabel: t("sayIt.samplesLabel"),
              samples: { cramps: t("sayIt.samples.cramps"), bloated: t("sayIt.samples.bloated"), back: t("sayIt.samples.back") },
              title: t("app.sayItTitle"),
              action: t("app.sayItAction"),
              found: t("app.sayItFound"),
              // The app's counted save button, worded for each possible number of ticked words.
              add: Object.fromEntries(
                Array.from({ length: maxSayItTerms }, (_, i) => [i + 1, t("app.sayItSaveCount", { entries: i + 1, days: 1 })]),
              ),
              added: t("app.sayItAdded"),
              privateNote: t("app.assistantPrivateNote"),
              demoNote: t("sayIt.demoNote"),
              again: t("sayIt.again"),
              terms: {
                cramps: t("app.logCramps"),
                headache: t("app.logHeadache"),
                fatigue: t("app.logFatigue"),
                bloating: t("app.logBloating"),
                nausea: t("app.logNausea"),
                backache: t("app.logBackache"),
                anxious: t("app.logAnxious"),
              },
            }}
          />
        </div>

        <div className="flex flex-col gap-5">
          <Heading eyebrow={t("ask.eyebrow")} title={t("ask.heading")} demo={demo} />
          <AskDemo
            strings={{
              questionsLabel: t("ask.questionsLabel"),
              questions: { cramps: t("ask.questions.cramps"), bleeding: t("ask.questions.bleeding"), uncovered: t("ask.questions.uncovered") },
              intro: t("app.askIntro"),
              action: t("app.askAction"),
              searching: t("app.askSearching"),
              answerOnPhone: t("app.askAnswerOnPhone"),
              answer: t("ask.crampsAnswer"),
              clinicianLine: t("app.askClinicianLine"),
              sourcesTitle: t("app.askSourcesTitle"),
              sourceTitle: t("ask.sourceTitle"),
              sourceLine: t("app.askSourceReviewed", { publisher: ASK_SOURCE.publisher, date: reviewed }),
              safetyHeading: t("app.safetyHeavyBleedingHeading"),
              safetyBody: t("app.safetyHeavyBleedingBody"),
              rulesFirst: t("ask.rulesFirst"),
              helpNow: t("app.helpNowLauncher"),
              notCoveredHeading: t("app.askNotCoveredHeading"),
              notCovered: t("app.askNotCovered"),
              again: t("app.askSearchAgain"),
              demoNote: t("ask.demoNote"),
            }}
          />
        </div>
      </div>
    </section>
  );
}

const LEAVE_ITEMS = [
  { key: "cloud", Icon: CloudCog },
  { key: "check", Icon: ShieldCheck },
  { key: "model", Icon: Smartphone },
  { key: "play", Icon: Store },
  { key: "links", Icon: Link2 },
  { key: "share", Icon: Share2 },
  { key: "backup", Icon: Save },
] as const;

/**
 * "What can leave this phone": the privacy policy's complete list, in short. Each item
 * mirrors a lead in `privacy.points[3]` ("Everything that can leave your phone"), and the
 * never-sent line is the app's own Cloud boost sentence, so the three cannot disagree
 * without a visible diff.
 */
export async function WhatCanLeaveSection({ locale }: { locale: string }) {
  const t = await getTranslations({ locale, namespace: "appDemo" });
  return (
    <section id="what-can-leave" className="scroll-mt-20 bg-[var(--aurora-ground)] text-text-on-brand">
      <div className="mx-auto flex w-full max-w-5xl flex-col gap-6 px-6 py-14">
        <div className="flex max-w-2xl flex-col gap-2">
          <p className="flex items-center gap-2 text-2xs font-semibold uppercase tracking-wider opacity-85 rtl:normal-case rtl:tracking-normal">
            <ShieldCheck className="size-4" aria-hidden />
            {t("privacy.eyebrow")}
          </p>
          <h2 className="font-display text-xl rtl:font-bold">{t("privacy.heading")}</h2>
          <p className="text-sm leading-relaxed opacity-90">{t("privacy.body")}</p>
        </div>
        <ul className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
          {LEAVE_ITEMS.map(({ key, Icon }) => (
            <li key={key} className="flex flex-col gap-2 rounded-lg bg-white/10 p-4 ring-1 ring-white/15">
              <Icon className="size-5" aria-hidden />
              <span className="text-sm font-semibold">{t(`privacy.items.${key}.title`)}</span>
              <span className="text-2xs leading-relaxed opacity-90">{t(`privacy.items.${key}.body`)}</span>
            </li>
          ))}
        </ul>
        <div className="rounded-lg bg-white/15 p-4 ring-1 ring-white/25">
          <p className="text-sm font-semibold">{t("app.boostNeverHeading")}</p>
          <p className="mt-1 text-xs leading-relaxed opacity-95">{t("app.boostNever")}</p>
        </div>
        <Link href="/privacy" className="self-start text-sm font-semibold underline underline-offset-4">
          {t("privacy.policyLink")}
        </Link>
      </div>
    </section>
  );
}
