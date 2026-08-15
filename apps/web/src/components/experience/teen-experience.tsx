"use client";

import { useFormatter, useTranslations } from "next-intl";
import type { ExperienceConfig } from "@/lib/experience/types";
import type { CyclePrediction } from "@/lib/cycle/predict";
import { predictionBand } from "@/lib/ui/range-band";
import { ExperienceModules } from "./module-registry";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { HeroCard } from "@/components/ui/hero-card";
import { Link } from "@/i18n/navigation";

/**
 * Track A — the adolescent screen (R2.5c, ADR-061).
 *
 * ## The defect it closes
 *
 * Track A had no mode, so a 13-year-old resolved to `general` and got the adult
 * cycle dashboard: a confident-looking window, a cycle-day counter, an
 * average-length card, and none of the reassurance that `A2` §B says is the whole
 * value at this age. `docs/23` §3.1 counted Track A among the tracks the persona
 * engine could resolve and nothing could render. This is the rendering half.
 *
 * ## What it does *not* do, and why each one is deliberate
 *
 * **It does not restrict anything.** A2 §A: *"Teen mode changes data handling, ads,
 * and social exposure, not knowledge access."* There is no gate in this file. The
 * protection lives at the write path (`lib/persona/minor.ts`) where a UI refactor
 * cannot undo it, and the library link below reaches the same articles every other
 * mode reaches.
 *
 * **It never frames a window as fertility or safety.** A2 §K forbids
 * fertile-window and "safe day" framing for a minor outright, and the `tools` in
 * her registry record carry no `fertility` entry, so the module registry has
 * nothing to render even if a future edit asked it to.
 *
 * **It does not predict a first period.** A1 contributes no `teen.window` at all
 * (A1 §I), so the absence is data, not an `if` — and the honest thing to tell a
 * child worried about when it will start is what usually happens, not a date.
 *
 * **It does not say PCOS.** A2 §D: PCOS should generally not be diagnosed within
 * 2–3 years of menarche because irregular cycles are developmentally expected. The
 * `teen.worthMentioning` alert is an `education` kind rather than a `redFlag` for
 * the same reason — the red-flag panel is a danger surface, and this is a "some
 * people find it helpful to mention this" note.
 */

export function TeenExperience({
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
  const t = useTranslations("teen");
  const td = useTranslations("dashboard");
  const format = useFormatter();

  const fmtShort = (iso: string) =>
    format.dateTime(new Date(`${iso}T00:00:00Z`), {
      day: "numeric",
      month: "short",
      timeZone: "UTC",
    });

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
   * The window, with its reason attached rather than available elsewhere.
   *
   * A2 §B records the failure in her own words — *"It said my period would come
   * Tuesday and it didn't. Is the app broken, or am I broken?"* — so the sentence
   * under the range is not a footnote, it is the answer to the question the range
   * provokes. And when the window has passed it says so, because that is the moment
   * she is most likely to be looking. Still no day count, in any mode.
   */
  const windowCard = prediction ? (
    <HeroCard
      tone="brand"
      eyebrow={t("window.eyebrow")}
      headline={t("window.range", {
        start: fmtShort(prediction.windowStart),
        end: fmtShort(prediction.windowEnd),
      })}
      footnote={band?.pastWindow ? t("window.passed") : t("window.why")}
      band={band}
    />
  ) : (
    <HeroCard
      tone="brand"
      eyebrow={t("window.eyebrow")}
      headline={t("window.needData")}
      footnote={t("window.needDataNote")}
    />
  );

  const reassurance = (
    <Card>
      <CardContent className="flex flex-col gap-2 p-6">
        <h2 className="font-display text-lg text-text">{t("reassurance.heading")}</h2>
        <p className="text-sm text-text-muted">{t("reassurance.body")}</p>
      </CardContent>
    </Card>
  );

  const worthMentioning = (
    // `info`, not `warning`. A2 §G: no alarms, no diagnosis, no "you might have X".
    // The same words in a red panel are a different message.
    <Alert variant="info">
      <AlertDescription className="flex flex-col gap-2">
        <span className="font-medium">{t("worthMentioning.heading")}</span>
        <span>{t("worthMentioning.body")}</span>
      </AlertDescription>
    </Alert>
  );

  const privacy = (
    <Card>
      <CardContent className="flex flex-col gap-2 p-6">
        <h2 className="font-display text-lg text-text">{t("privacy.heading")}</h2>
        <p className="text-sm text-text-muted">{t("privacy.body")}</p>
        <Link href="/settings" className="text-sm text-text-link underline">
          {t("privacy.cta")}
        </Link>
      </CardContent>
    </Card>
  );

  const reading = (
    <Card>
      <CardContent className="flex flex-col gap-2 p-6">
        <h2 className="font-display text-lg text-text">{t("reading.heading")}</h2>
        <p className="text-sm text-text-muted">{t("reading.body")}</p>
        {/* The open door, said plainly. A2 §I: being blocked drives her to worse
            sources, so the whole library is one tap away and labelled as such. */}
        <Link href="/learn" className="text-sm text-text-link underline">
          {t("reading.cta")}
        </Link>
      </CardContent>
    </Card>
  );

  /**
   * No document, or nothing for this track. Unreachable in practice — a stated
   * Track A resolves to A2 and `default` modules always exist — but reassurance is
   * the one thing that must not vanish with the engine, for the same reason the
   * postpartum screen keeps its warning signs.
   */
  if (!config || config.home.modules.length === 0) {
    return <div className="flex flex-col gap-4">{reassurance}</div>;
  }

  return (
    <div className="flex flex-col gap-4">
      <ExperienceModules
        ctx={{
          config,
          teenWindow: windowCard,
          teenReassurance: reassurance,
          teenWorthMentioning: worthMentioning,
          teenPrivacy: privacy,
          warningSigns: null,
          reading,
          movement: null,
          pregnancyHero: null,
          quickLog: (
            <Button asChild variant="accent" className="w-full">
              <Link href="/track">{td("logCta")}</Link>
            </Button>
          ),
        }}
      />
    </div>
  );
}
