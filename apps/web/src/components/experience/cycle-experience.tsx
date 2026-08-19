"use client";

import { useFormatter, useTranslations } from "next-intl";
import type { ExperienceConfig, ModuleId } from "@/lib/experience/types";
import type { CyclePrediction } from "@/lib/cycle/predict";
import { predictionBand } from "@/lib/ui/range-band";
import { ExperienceModules } from "./module-registry";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { HeroCard } from "@/components/ui/hero-card";
import { Link } from "@/i18n/navigation";

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
  topSymptoms,
  symptomLabel,
}: {
  config: ExperienceConfig | null;
  prediction: CyclePrediction | null;
  lastStart: string | null;
  today: string;
  /** Her most-logged symptoms, already counted by tier 2 (`lib/cycle/insights`). */
  topSymptoms: readonly { type: string; count: number }[];
  symptomLabel: (type: string) => string;
}) {
  const t = useTranslations("dashboard");
  const format = useFormatter();

  const fmt = (iso: string) =>
    format.dateTime(new Date(`${iso}T00:00:00Z`), { dateStyle: "medium", timeZone: "UTC" });

  const ids = new Set(config?.home.modules.map((m) => m.id) ?? []);
  const drawable: ModuleId[] = [
    "cycle.window",
    "cycle.variability",
    "cycle.personalNormal",
    "explore",
    "visitPrep",
    "privacy",
  ];
  if (!drawable.some((id) => ids.has(id))) return null;

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

  /**
   * Her own pattern, which is the thing no competitor can copy by copying a screen
   * — it is her record, not a population average. Only Track B contributes it: the
   * block this replaces was gated on `mode !== "menopause"`, and the registry says
   * the same thing better, because F1 and F2 simply do not offer the module.
   */
  const personalNormal =
    topSymptoms.length > 0 ? (
      <section className="flex flex-col gap-2">
        <h2 className="text-md font-semibold text-text">{t("topSymptomsHeading")}</h2>
        <div className="flex flex-wrap gap-2">
          {topSymptoms.map((s) => (
            <Badge key={s.type} variant="primary">
              {symptomLabel(s.type)} · {s.count}
            </Badge>
          ))}
        </div>
      </section>
    ) : null;

  /**
   * The hidden-but-reachable rule, given a surface at last (R1.9b).
   *
   * Every B and F spec repeats it in its §I and `types.ts` names the problem
   * exactly: *"today it is true of the router and invisible on the screen — a
   * product rule with no UI is a claim rather than a property."* Product rule 2
   * says personalize, never restrict, and until now a woman had no way to see that
   * the rest of Femio was still there. Now she does, in her own language.
   */
  const linkCard = (key: "explore" | "visitPrep" | "privacyNote", href: string) => (
    <Card>
      <CardContent className="flex flex-col gap-2 p-6">
        <h2 className="font-display text-lg text-text">{t(`${key}.heading`)}</h2>
        <p className="text-sm text-text-muted">{t(`${key}.body`)}</p>
        <Link href={href} className="text-sm text-text-link underline">
          {t(`${key}.cta`)}
        </Link>
      </CardContent>
    </Card>
  );

  return (
    <ExperienceModules
      ctx={{
        config: config!,
        cycleWindow: windowCard,
        cycleVariability: variabilityCard,
        cyclePersonalNormal: personalNormal,
        explore: linkCard("explore", "/learn"),
        visitPrep: linkCard("visitPrep", "/summary"),
        privacy: linkCard("privacyNote", "/settings"),
        warningSigns: null,
        reading: null,
        movement: null,
        pregnancyHero: null,
        quickLog: null,
      }}
    />
  );
}
