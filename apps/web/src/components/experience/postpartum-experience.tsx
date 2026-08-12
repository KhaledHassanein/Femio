"use client";

import { useTranslations } from "next-intl";
import { buildExperienceConfig, registryOf } from "@/lib/experience/build";
import { PERSONA_RECORDS, findRecord } from "@/lib/experience/registry";
import type { Resolution } from "@/lib/persona/resolver";
import { ExperienceModules } from "./module-registry";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { HeroCard } from "@/components/ui/hero-card";
import { Link } from "@/i18n/navigation";

/**
 * Postpartum (R2.5, ADR-061). Track E's first screen.
 *
 * ## Why this exists before P2.3 does
 *
 * Track E had no mode at all (`docs/23` §3.1), so a woman weeks after giving birth
 * fell through to `general` — and `general` shows a next-period prediction. A
 * window computed from cycles that stopped nine months ago is not an estimate, it
 * is an invention, and it is the same class of defect ADR-041 fixed for pregnancy
 * and ADR-042 for menopause.
 *
 * So this is deliberately **small and honest** rather than a preview of P2.3. The
 * recovery tracker, EPDS and feeding logs are real features and none of them is
 * built; what she gets today is a check-in, the warning signs that still apply
 * after birth, and logging that works. A short honest screen beats a rich
 * dishonest one.
 *
 * ## The two things it refuses to do
 *
 * **It does not congratulate her.** `E1.tone.celebrationByDefault` is false because
 * the mode alone does not tell us whether she brought a baby home. E6 exists for
 * the people who did not, and it stacks as an emotional layer — but the default has
 * to be safe before the layer applies, not after.
 *
 * **It does not predict the return of her cycle.** `showsCyclePredictions` excludes
 * postpartum for that reason. When her period returns she can log it, and the cycle
 * tools become useful again on their own.
 */

const REGISTRY = registryOf(PERSONA_RECORDS);
const CONTEXT_TO_LAYER: Record<string, string> = { prior_loss: "E6" };

export function PostpartumExperience({
  personaId,
  modifiers,
  emotionalContext,
}: {
  personaId: string | null;
  modifiers: readonly string[];
  emotionalContext: readonly string[];
}) {
  const t = useTranslations("postpartum");
  const td = useTranslations("dashboard");

  const record = (personaId ? findRecord(personaId) : undefined) ?? findRecord("E1")!;

  const resolution: Resolution = {
    personaId: record.id,
    track: "E",
    modifiers: [...modifiers],
    emotionalContext: [...emotionalContext],
    confidence: 1,
    runnerUp: null,
  };

  const config = buildExperienceConfig({
    resolution,
    phase: "postpartum",
    registry: REGISTRY,
    resolvedAt: new Date().toISOString(),
    emotionalLayers: emotionalContext
      .map((c) => CONTEXT_TO_LAYER[c])
      .filter((id): id is string => Boolean(id)),
  });

  const gentle = config.tone.register === "gentle";

  return (
    <div className="flex flex-col gap-4">
      <ExperienceModules
        ctx={{
          config,
          /**
           * `support.checkIn` is the hero. It asks and then stops — no score, no
           * streak, no interpretation. A mood *screener* is P2.7 and needs the
           * crisis routing that comes with it (P1.26.3); a check-in that pretended
           * to be one would be the exact thing product rule 1 forbids.
           */
          pregnancyHero: (
            <HeroCard
              tone={gentle ? "brand" : "warm"}
              eyebrow={t(gentle ? "loss.eyebrow" : "checkIn.eyebrow")}
              headline={t(gentle ? "loss.heading" : "checkIn.heading")}
              footnote={t(gentle ? "loss.note" : "checkIn.note")}
            />
          ),
          warningSigns: (
            // The dangerous window does not close at delivery. Kept high, and
            // carrying no phone number (P1.26.1).
            <Alert variant="danger">
              <AlertDescription className="flex flex-col gap-2">
                <span className="font-medium">{t("redFlags.heading")}</span>
                <span>{t("redFlags.body")}</span>
              </AlertDescription>
            </Alert>
          ),
          reading: (
            <Card>
              <CardContent className="flex flex-col gap-2 p-6">
                <h2 className="font-display text-lg text-text">{t("reading.heading")}</h2>
                <p className="text-sm text-text-muted">{t("reading.pending")}</p>
              </CardContent>
            </Card>
          ),
          movement: null,
          quickLog: (
            <Button asChild variant="accent" className="w-full">
              <Link href="/track">{td("logCta")}</Link>
            </Button>
          ),
        }}
      />

      {/* Said plainly rather than implied by an absent panel: she is not being
          shown a prediction because there is nothing honest to predict yet. */}
      <p className="text-2xs leading-relaxed text-text-subtle">{t("cycleReturnNote")}</p>
    </div>
  );
}
