"use client";

import { useFormatter, useTranslations } from "next-intl";
import type { ExperienceConfig, ModuleId } from "@/lib/experience/types";
import { predictionBand } from "@/lib/ui/range-band";
import { ExperienceModules } from "./module-registry";
import { Button } from "@/components/ui/button";
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
  const drawable: ModuleId[] = ["ttc.window", "ttc.logSummary"];
  if (!drawable.some((id) => ids.has(id))) return null;

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
        warningSigns: null,
        reading: null,
        movement: null,
        pregnancyHero: null,
        quickLog: null,
      }}
    />
  );
}
