"use client";

import { useTranslations } from "next-intl";
import type { ExperienceConfig } from "@/lib/experience/types";
import { ExperienceModules } from "./module-registry";
import { ReadingList } from "./reading-list";
import { MoodCheck } from "@/components/postpartum/mood-check";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Card, CardContent } from "@/components/ui/card";
import { HeroCard } from "@/components/ui/hero-card";
import { Link } from "@/i18n/navigation";
import { followUpKindsFor, followUpsFor } from "@/lib/followup";

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

export function PostpartumExperience({
  config,
  birthDateISO = null,
  todayISO,
}: {
  config: ExperienceConfig | null;
  /**
   * When she gave birth, if Femio actually knows.
   *
   * **It does not today, and that is the finding.** E1's `emrView` has named
   * `deliveryDate` since R2.5 and **nothing writes one**: tier 1 derives
   * `weeksSincePregnancyEnd` from `pregnancy.updated_at`, which is fine for a
   * coarse signal and wrong for a day-anchored schedule — editing the row would
   * move her follow-up window. So the card renders the checks without saying where
   * she is in them until a real delivery date exists (P2.4b).
   */
  birthDateISO?: string | null;
  todayISO: string;
}) {
  const t = useTranslations("postpartum");

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
  if (config?.track !== "E") return null;

  if (config.home.modules.length === 0) {
    return (
      <div className="flex flex-col gap-4">
        {warningSigns}
        {cycleNote}
      </div>
    );
  }

  /**
   * E3's two surfaces (R1.9j). E3 is the highest-sensitivity persona in the
   * product by its own spec, and both cards exist to do one thing: **separate her
   * from the illness**. No score, no label, nothing that says "you might have".
   *
   * The intrusive-thoughts card is the one that earns its place. §A: unwanted
   * thoughts about harm coming to the baby are reported by the large majority of
   * new mothers, and the shame is what stops her telling anyone — so the card says
   * the sentence that ends it, plainly, and routes the one case that is urgent.
   * It carries **no phone number** (P1.26.1) and never implies she is dangerous.
   */
  const moodSupport = (
    <Card>
      <CardContent className="flex flex-col gap-2 p-6">
        <h2 className="font-display text-lg text-text">{t("moodSupport.heading")}</h2>
        <p className="text-sm text-text-muted">{t("moodSupport.body")}</p>
        <Link href="/learn/mood-after-birth" className="text-sm text-text-link underline">
          {t("moodSupport.cta")}
        </Link>
      </CardContent>
    </Card>
  );

  const intrusiveThoughts = (
    <Card>
      <CardContent className="flex flex-col gap-2 p-6">
        <h2 className="font-display text-lg text-text">{t("intrusiveThoughts.heading")}</h2>
        <p className="text-sm text-text-muted">{t("intrusiveThoughts.body")}</p>
        <Link href="/learn/mood-after-birth" className="text-sm text-text-link underline">
          {t("intrusiveThoughts.cta")}
        </Link>
        {/* The one case that is not reassurance: a thought she feels pulled to act
            on is help-today, and it routes to the global crisis page rather than
            being softened into the paragraph above it. */}
        <p className="text-sm text-text">{t("intrusiveThoughts.urgent")}</p>
        <Link href="/help-now" className="text-sm text-text-link underline">
          {t("intrusiveThoughts.helpNow")}
        </Link>
      </CardContent>
    </Card>
  );

  /**
   * E4's schedule (P2.4b). The "postpartum cliff" its spec names: during pregnancy
   * she was watched weekly, and afterwards the follow-up evaporates — the glucose
   * test after gestational diabetes is completed by a minority of the women who
   * need it, and the reason §A gives is that nobody offers it.
   *
   * Prompts to attend, never readings. Nothing here records a result, and the note
   * says so out loud rather than leaving the absence to be read as an oversight.
   */
  const conditions = config?.emrView.includes("conditionsCarriedForward")
    ? (config.home.modules.find((m) => m.id === "followup.schedule")?.params?.conditions ?? "")
    : "";
  const codes = String(conditions).split(",").filter(Boolean);
  const scheduled = followUpsFor({ conditions: codes, birthDateISO, todayISO });
  const kinds = scheduled.length > 0 ? scheduled : followUpKindsFor(codes).map((kind) => ({ kind }));

  const followUpCard = (
    <Card>
      <CardContent className="flex flex-col gap-2 p-6">
        <h2 className="font-display text-lg text-text">{t("followup.heading")}</h2>
        <p className="text-sm text-text-muted">{t("followup.body")}</p>
        <ul className="flex flex-col gap-2 text-sm">
          {kinds.map((entry) => (
            <li key={entry.kind} className="flex flex-col">
              <span className="text-text">{t(`followup.${entry.kind}`)}</span>
              {"status" in entry ? (
                <span className="text-text-muted">{t(`followup.${entry.status}`)}</span>
              ) : null}
            </li>
          ))}
        </ul>
        <p className="text-2xs text-text-subtle">{t("followup.note")}</p>
      </CardContent>
    </Card>
  );

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
          moodSupport,
          followupSchedule: followUpCard,
          intrusiveThoughts,
          warningSigns,
          pregnancyHero: null,
          /**
           * P2.3c. The card is the persona's own `content.foreground` rendered —
           * the first field in the document that had been written since R2.1 and
           * read by nothing. It shows the guides the CMS is publishing, and the
           * "being written" line until the reviewer approves them.
           */
          reading: (
            <ReadingList
              foreground={config.content.foreground}
              heading={t("reading.heading")}
              pending={t("reading.pending")}
            />
          ),
          movement: null,
        }}
      />
      {cycleNote}
    </div>
  );
}
