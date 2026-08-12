"use client";

import { buildExperienceConfig, registryOf } from "@/lib/experience/build";
import { TRACK_D_RECORDS, findRecord } from "@/lib/experience/registry/track-d";
import { phaseFor } from "@/lib/experience/phase";
import type { Resolution } from "@/lib/persona/resolver";
import { ExperienceModules } from "./module-registry";
import {
  PregnancyHero,
  PregnancyPanel,
  PregnancyReading,
  PregnancyWarningSigns,
} from "@/components/pregnancy/pregnancy-panel";
import { EndPregnancy } from "@/components/pregnancy/end-pregnancy";
import { Button } from "@/components/ui/button";
import { Link } from "@/i18n/navigation";
import { useTranslations } from "next-intl";

/**
 * The pregnancy dashboard, rendered from an `ExperienceConfig` (R2.3, ADR-061).
 *
 * ## What changed, and why it is the whole point
 *
 * The screen used to be a fixed composition: hero, red flags, reading, end. Every
 * persona got the same one, so the ~73 specs could not reach a pixel and telling
 * D3 from D7 would have meant a new branch per persona (`docs/23` §3.1).
 *
 * Now the engine returns an ordered module list and this component renders it by
 * id. **D1, D3, D4 and D7 differ because their registry rows differ — not because
 * anything here asks which persona she is.** There is no `personaId ===` in this
 * file, and there must never be one; the acceptance test for R2 is exactly that.
 *
 * The pre-conditions stay outside the engine: a pregnancy that has ended and a
 * missing due date are not modules, they are reasons there is no dashboard yet, and
 * `PregnancyPanel` still owns both.
 */

const REGISTRY = registryOf(TRACK_D_RECORDS);

/** Emotional layers are persona ids; `emotional_context` carries reasons. */
const CONTEXT_TO_LAYER: Record<string, string> = { prior_loss: "D2" };

export function PregnancyExperience({
  pregnancy,
  today,
  personaId,
  modifiers,
  emotionalContext,
}: {
  pregnancy: { id: string; edd: string | null; status: string } | null;
  today: string;
  personaId: string | null;
  modifiers: readonly string[];
  emotionalContext: readonly string[];
}) {
  const t = useTranslations("dashboard");

  const phase = phaseFor({
    edd: pregnancy?.edd ?? null,
    status: pregnancy?.status ?? null,
    todayISO: today,
  });

  /**
   * Fall back to the fixed panel when the engine has nothing better to say — an
   * unregistered persona, or no due date yet. Z1 is a real answer (`docs/09` §5),
   * and the panel is the honest generic pregnancy screen rather than a blank one.
   */
  const record = personaId ? findRecord(personaId) : undefined;
  if (!record || !phase || phase === "postpartum") {
    return <PregnancyPanel pregnancy={pregnancy} today={today} />;
  }

  const resolution: Resolution = {
    personaId: record.id,
    track: "D",
    modifiers: [...modifiers],
    emotionalContext: [...emotionalContext],
    confidence: 1,
    runnerUp: null,
  };

  /**
   * Built here from the stored persona rather than fetched.
   *
   * `loadExperienceConfig` (R2.4) is the server-first path and exists — but the
   * Edge Function is not deployed yet, and calling it on every dashboard render
   * would add a round trip that falls through to this same computation anyway. The
   * document this produces is identical to the one the function returns, because it
   * is the same modules. It moves to the fetched document in the same change that
   * deploys the function, which is a one-line swap here.
   */
  const config = buildExperienceConfig({
    resolution,
    phase,
    registry: REGISTRY,
    resolvedAt: new Date().toISOString(),
    emotionalLayers: emotionalContext
      .map((c) => CONTEXT_TO_LAYER[c])
      .filter((id): id is string => Boolean(id)),
  });

  return (
    <div className="flex flex-col gap-4">
      <ExperienceModules
        ctx={{
          config,
          pregnancyHero: <PregnancyHero edd={pregnancy!.edd!} today={today} />,
          warningSigns: <PregnancyWarningSigns />,
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
