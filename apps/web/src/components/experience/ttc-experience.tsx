"use client";

import { useFormatter, useTranslations } from "next-intl";
import type { ExperienceConfig, ModuleId } from "@/lib/experience/types";
import { predictionBand } from "@/lib/ui/range-band";
import { ExperienceModules } from "./module-registry";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { HeroCard } from "@/components/ui/hero-card";
import { Link } from "@/i18n/navigation";

/**
 * Track C's dashboard modules, rendered from the served document (R1.9c).
 *
 * R2.11 gave Track C a registry and nothing drew it. The dashboard branched on
 * `mode === "ttc"` in three places instead — for the hero, for the charting link,
 * and for whether to compute a window at all — so which woman saw what was decided
 * by a string comparison in a screen rather than by her persona.
 *
 * ## What this deliberately does not become
 *
 * `lib/fertility` has no `ovulationDay`, no `thermalShift` and no `isFertile`, and
 * a test asserts it never gains one. The window here comes from cycle history and
 * is drawn as a **band with soft edges**, which is the honest picture: an estimate
 * of days worth knowing about, never a boundary between safe and unsafe. The
 * feature everyone builds on top of a firm edge is "days you could avoid" — the
 * contraception line and the medical-device line in a single step (product rule 1).
 *
 * ## The charting link is surfaced, not gated
 *
 * `/fertility` is reachable from Settings in every mode. What Track C changes is
 * *prominence*, which is the whole of product rule 2: her own temperatures and
 * tests are better evidence about her body than a window computed from history, so
 * this is where they are easiest to reach — not the only place they exist.
 */
export function TtcExperience({
  config,
  fertile,
  lastStart,
  today,
}: {
  config: ExperienceConfig | null;
  /** The shape `fertileWindow` returns; kept structural so this file imports no logic. */
  fertile: { windowStart: string; windowEnd: string } | null;
  lastStart: string | null;
  today: string;
}) {
  const t = useTranslations("dashboard");
  const tFertility = useTranslations("fertility");
  const format = useFormatter();

  const fmtShort = (iso: string) =>
    format.dateTime(new Date(`${iso}T00:00:00Z`), {
      day: "numeric",
      month: "short",
      timeZone: "UTC",
    });

  const ids = new Set(config?.home.modules.map((m) => m.id) ?? []);
  const drawable: ModuleId[] = [
    "ttc.window",
    "ttc.logSummary",
    "ttc.workup",
    "ttc.conditionContext",
  ];
  if (!drawable.some((id) => ids.has(id))) return null;

  /**
   * Which article the condition layer points at. C6 and C8 carry the code as a
   * module param, so the mapping lives here rather than as a branch on her
   * persona id — `persona-branch-lint` forbids the latter and is right to: a
   * screen that knows what C6 *is* has re-implemented the registry.
   */
  const conditionArticle: Record<string, string> = {
    pcos: "/learn/pcos-and-fertility",
    thyroid: "/learn/thyroid-and-conceiving",
  };
  const conditionParam = config?.home.modules.find((m) => m.id === "ttc.conditionContext")?.params
    ?.condition;
  const conditionHref =
    typeof conditionParam === "string" ? conditionArticle[conditionParam] : undefined;

  const linkCard = (key: "ttcWorkup" | "ttcCondition", href: string) => (
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

  const band =
    lastStart && fertile
      ? predictionBand({
          axisStart: lastStart,
          windowStart: fertile.windowStart,
          windowEnd: fertile.windowEnd,
          today,
        })
      : null;

  return (
    <ExperienceModules
      ctx={{
        config: config!,
        ttcWindow: (
          <HeroCard
            tone="fertile"
            eyebrow={t("fertileHeading")}
            headline={
              fertile
                ? t("fertileWindow", {
                    start: fmtShort(fertile.windowStart),
                    end: fmtShort(fertile.windowEnd),
                  })
                : t("needData")
            }
            footnote={fertile ? t("fertileNote") : undefined}
            band={band}
          />
        ),
        ttcLogSummary: (
          <Button asChild variant="outline" className="w-full">
            <Link href="/fertility">{tFertility("title")}</Link>
          </Button>
        ),
        /**
         * Emphasis, never a label. C2 §I is explicit that being past her window
         * changes what leads and says nothing about infertility, and the copy
         * holds that line: "a good moment to find out, not a verdict".
         */
        ttcWorkup: linkCard("ttcWorkup", "/learn/fertility-tests-what-to-expect"),
        // Nothing is drawn for a condition with no article, rather than a card
        // that promises a page that is not there.
        ttcConditionContext: conditionHref ? linkCard("ttcCondition", conditionHref) : null,
        warningSigns: null,
        reading: null,
        movement: null,
        pregnancyHero: null,
        quickLog: (
          <Button asChild variant="accent" className="w-full">
            <Link href="/track">{t("logCta")}</Link>
          </Button>
        ),
      }}
    />
  );
}
