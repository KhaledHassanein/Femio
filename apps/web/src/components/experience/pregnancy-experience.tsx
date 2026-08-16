"use client";

import type { ExperienceConfig } from "@/lib/experience/types";
import { ExperienceModules } from "./module-registry";
import {
  PregnancyHero,
  PregnancyPanel,
  PregnancyReading,
  PregnancyWarningSigns,
} from "@/components/pregnancy/pregnancy-panel";
import { EndPregnancy } from "@/components/pregnancy/end-pregnancy";
import { NextAppointmentCard } from "@/components/appointments/next-appointment-card";
import { WeightChart } from "@/components/pregnancy/weight-chart";
import { ContractionTimer } from "@/components/pregnancy/contraction-timer";
import { Button } from "@/components/ui/button";
import { Link } from "@/i18n/navigation";
import { useTranslations } from "next-intl";

/**
 * The pregnancy dashboard, rendered from a **served** `ExperienceConfig`
 * (R2.3 → R2.4, ADR-060/061).
 *
 * ## What changed, and why it is the whole point
 *
 * The screen used to be a fixed composition: hero, red flags, reading, end. Every
 * persona got the same one, so the ~73 specs could not reach a pixel and telling
 * D3 from D7 would have meant a new branch per persona (`docs/23` §3.1).
 *
 * Then R2.3 made it render an ordered module list — but it still *built* that list
 * here, in the browser, from the stored persona id. R2.4 finishes the job: the
 * document arrives from `loadExperienceConfig` (server → cache → local) and this
 * component only renders it. **There is no resolution left in this file.** No
 * registry lookup, no `buildExperienceConfig`, no `Resolution` assembled from props
 * — which is the ADR-060 rule stated as code rather than as a memory, and is now
 * held there by `native-readiness-lint`.
 *
 * D1, D3, D4 and D7 differ because their registry rows differ. There is no
 * `personaId ===` in this file and there must never be one.
 *
 * The pre-conditions stay outside the engine: a pregnancy that has ended and a
 * missing due date are not modules, they are reasons there is no dashboard yet, and
 * `PregnancyPanel` still owns both.
 */

/** Phases in which this screen has a dashboard to draw. */
const PREGNANT_PHASES = new Set(["t1", "t2", "t3"]);

export function PregnancyExperience({
  pregnancy,
  today,
  config,
}: {
  pregnancy: { id: string; edd: string | null; status: string } | null;
  today: string;
  config: ExperienceConfig | null;
}) {
  const t = useTranslations("dashboard");

  /**
   * Fall back to the fixed panel when there is no dashboard to draw: no served
   * document yet, a phase outside pregnancy, or an engine that produced nothing for
   * her (an unregistered persona degrades to the generic document — Z1 is a real
   * answer, `docs/09` §5, and the panel is the honest generic pregnancy screen).
   *
   * `pregnancy?.edd` is checked here too, and not only through the phase. The
   * document is resolved from the server's read of the pregnancy row while `edd`
   * below comes from this screen's own read; if those two ever disagree the honest
   * outcome is the panel, not a non-null assertion that throws in her face.
   */
  const drawable =
    config !== null &&
    config.phase !== null &&
    PREGNANT_PHASES.has(config.phase) &&
    config.home.modules.length > 0 &&
    Boolean(pregnancy?.edd);

  if (!drawable) {
    return <PregnancyPanel pregnancy={pregnancy} today={today} />;
  }

  return (
    <div className="flex flex-col gap-4">
      <ExperienceModules
        ctx={{
          config: config!,
          pregnancyHero: <PregnancyHero edd={pregnancy!.edd!} today={today} />,
          warningSigns: <PregnancyWarningSigns />,
          // P2.2.3. The card reads its own data, so it needs nothing from this
          // screen and drops into any track’s registry unchanged.
          appointments: <NextAppointmentCard />,
          weight: <WeightChart />,
          contractions: <ContractionTimer />,
          reading: <PregnancyReading />,
          movement: (
            <Button asChild variant="outline" className="w-full">
              <Link href="/track">{t("logCta")}</Link>
            </Button>
          ),
          quickLog: (
            <Button asChild variant="accent" className="w-full">
              <Link href="/track">{t("logCta")}</Link>
            </Button>
          ),
        }}
      />
      {/* Outside the engine on purpose: recording a loss is not a module whose
          prominence a persona should be able to change. */}
      <EndPregnancy pregnancyId={pregnancy!.id} />
    </div>
  );
}
