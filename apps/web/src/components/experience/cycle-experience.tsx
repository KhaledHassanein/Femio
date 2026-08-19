"use client";

import { useFormatter, useTranslations } from "next-intl";
import type { ExperienceConfig } from "@/lib/experience/types";
import type { CyclePrediction } from "@/lib/cycle/predict";
import { predictionBand } from "@/lib/ui/range-band";
import { ExperienceModules } from "./module-registry";
import { Card, CardContent } from "@/components/ui/card";
import { HeroCard } from "@/components/ui/hero-card";

/**
 * Track B's supporting modules, rendered from the served document (R1.9a).
 *
 * R2.8 gave Track B a registry and nothing drew it, so B1, B5 and B6 reached a
 * woman as tone, alerts and a reading list but never as layout. This is the first
 * piece of that: the two modules whose *distinction* is the architectural point,
 * rendered by id instead of by a `mode ===` check.
 *
 * ## Why `cycle.window` and `cycle.variability` are two modules
 *
 * One predicts and the other declines to. `types.ts` says it plainly: whether
 * Femio is willing to predict at all is a tier-1 decision, so it is expressed as
 * *which module the record contributes* rather than as a `predict: false` param on
 * one module. A flag would put the safety decision inside a component's props,
 * where a refactor can flip it; two ids put it in the registry, where changing it
 * is a reviewed diff.
 *
 * B5 is the case that makes it real — irregular cycles, where a confident window
 * is an invention rather than an estimate (ADR-041/042). It contributes
 * `cycle.variability`, which shows her own lengths and the sentence saying why
 * there is no range, and it contributes no window at all.
 *
 * ## It renders nothing of its own accord
 *
 * No fallback, no default card. If the document carries neither module this
 * returns null and the screen above it is unchanged — the engine decides, and a
 * component that drew a window "just in case" would be the exact defect the two
 * ids exist to prevent.
 */
export function CycleExperience({
  config,
  prediction,
  lastStart,
  today,
}: {
  config: ExperienceConfig | null;
  prediction: CyclePrediction | null;
  lastStart: string | null;
  today: string;
}) {
  const t = useTranslations("dashboard");
  const format = useFormatter();

  const fmt = (iso: string) =>
    format.dateTime(new Date(`${iso}T00:00:00Z`), { dateStyle: "medium", timeZone: "UTC" });

  const ids = new Set(config?.home.modules.map((m) => m.id) ?? []);
  if (!ids.has("cycle.window") && !ids.has("cycle.variability")) return null;

  const band =
    lastStart && prediction
      ? predictionBand({
          axisStart: lastStart,
          windowStart: prediction.windowStart,
          windowEnd: prediction.windowEnd,
          today,
        })
      : null;

  /**
   * The prediction, as a range with its uncertainty drawn rather than described.
   * Never a single date, and never a day count — product rule 3, and the band's
   * soft edges are the honest picture rather than decoration.
   */
  const windowCard = prediction ? (
    <HeroCard
      tone="brand"
      eyebrow={t("nextPeriod")}
      headline={t("window", { start: fmt(prediction.windowStart), end: fmt(prediction.windowEnd) })}
      footnote={prediction.irregular ? t("irregularNote") : undefined}
      band={band}
    />
  ) : null;

  /**
   * Her own cycle lengths, and no range. This is what a woman whose cycles vary
   * gets *instead of* a prediction — the absence is the content, so the card says
   * why rather than leaving a gap to be interpreted as the app being broken.
   */
  const variabilityCard = (
    <Card>
      <CardContent className="flex min-h-24 flex-col justify-center gap-1 p-6">
        <p className="text-sm text-text-muted">{t("avgLengthHeading")}</p>
        <p className="font-display text-lg text-text">
          {prediction ? t("avgLengthDays", { days: prediction.averageLength }) : t("needData")}
        </p>
        {prediction?.irregular ? (
          <p className="text-sm text-warning-text">{t("irregularNote")}</p>
        ) : null}
      </CardContent>
    </Card>
  );

  return (
    <ExperienceModules
      ctx={{
        config: config!,
        cycleWindow: windowCard,
        cycleVariability: variabilityCard,
        warningSigns: null,
        reading: null,
        movement: null,
        pregnancyHero: null,
        quickLog: null,
      }}
    />
  );
}
