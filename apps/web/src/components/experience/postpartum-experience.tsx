"use client";

import { useTranslations } from "next-intl";
import type { ExperienceConfig } from "@/lib/experience/types";
import { ExperienceModules } from "./module-registry";
import { MoodCheck } from "@/components/postpartum/mood-check";
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
 *
 * ## It resolves nothing (R2.4)
 *
 * The document arrives from `loadExperienceConfig`; this file renders it. Building
 * it here meant Track E's modules were decided in the browser while the Edge
 * Function decided them again on the server, and the two did not agree — the server
 * had no way to know she had *told us* she was postpartum, so it resolved her to Z1
 * and would have served a generic screen. `resolveForStatedTrack` and
 * `phaseForTrack` fixed that on the tier-1 side; this is the client half.
 */

export function PostpartumExperience({ config }: { config: ExperienceConfig | null }) {
  const t = useTranslations("postpartum");
  const td = useTranslations("dashboard");

  const gentle = config?.tone.register === "gentle";

  const warningSigns = (
    // The dangerous window does not close at delivery. Kept high, and carrying no
    // phone number (P1.26.1).
    <Alert variant="danger">
      <AlertDescription className="flex flex-col gap-2">
        <span className="font-medium">{t("redFlags.heading")}</span>
        <span>{t("redFlags.body")}</span>
      </AlertDescription>
    </Alert>
  );

  // Said plainly rather than implied by an absent panel: she is not being shown a
  // prediction because there is nothing honest to predict yet.
  const cycleNote = (
    <p className="text-2xs leading-relaxed text-text-subtle">{t("cycleReturnNote")}</p>
  );

  /**
   * No document, or one carrying nothing for this phase. It should not happen —
   * a stated Track E resolves to E1 and `phaseForTrack` guarantees the phase — but
   * if it ever does, **the warning signs are the one thing that must not disappear
   * with the engine.** A silent screen would be the failure `module-registry`'s
   * `UNIMPLEMENTED` list exists to prevent, one level up.
   */
  if (!config || config.home.modules.length === 0) {
    return (
      <div className="flex flex-col gap-4">
        {warningSigns}
        {cycleNote}
      </div>
    );
  }

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
          checkIn: (
            <HeroCard
              tone={gentle ? "brand" : "warm"}
              eyebrow={t(gentle ? "loss.eyebrow" : "checkIn.eyebrow")}
              headline={t(gentle ? "loss.heading" : "checkIn.heading")}
              footnote={t(gentle ? "loss.note" : "checkIn.note")}
            />
          ),
          moodScreener: <MoodCheck />,
          warningSigns,
          pregnancyHero: null,
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
      {cycleNote}
    </div>
  );
}
