"use client";

import { useTranslations } from "next-intl";

import { Card, CardContent } from "@/components/ui/card";
import { Link } from "@/i18n/navigation";
import type { CyclePhase } from "@/lib/cycle/phases";

/**
 * What is happening in the phase she is in (`docs/27` phase 3.1).
 *
 * The competitive research behind `docs/26` §7 is blunt about this: apps that
 * explain the phases deliver dramatically more value than apps that only predict
 * when bleeding starts. Femio did only the second. The phase strip (ADR-066) put a
 * name on screen; this is the part that makes the name worth having.
 *
 * ## The copy is not written here, and that matters
 *
 * Every sentence comes from `docs/content/articles/menstrual-cycle-basics.md`,
 * which is clinician-reviewed and cited to the NHS cycle guide and ACOG's
 * menstrual-cycle infographic. Nothing is paraphrased into new medical claims —
 * paraphrasing reviewed content is how a reviewed fact quietly becomes an
 * unreviewed one, and the whole point of a knowledge base is that it is the source
 * rather than the decoration. The article is one tap away so she can read the rest
 * with its citations attached.
 *
 * ## What it deliberately does not say
 *
 * No advice. No "eat this, train that, rest now" — those are the claims that would
 * move Femio from education into something a regulator reads differently
 * (product rule 1), and none of them is in the reviewed source.
 *
 * The ovulatory copy carries the article's own warning in the article's own words:
 * these dates are estimates and **not a reliable way to avoid pregnancy**. That
 * sentence is bolded in the source and is repeated here rather than softened.
 *
 * Renders nothing when the phase is unknown. An irregular cycle gets no phase from
 * `phases.ts`, and inventing education for a phase Femio cannot place would be the
 * same false confidence in a different costume.
 */
export function PhaseEducation({ phase }: { phase: CyclePhase | null }) {
  const t = useTranslations("phaseEducation");
  if (!phase) return null;

  return (
    <Card>
      <CardContent className="flex flex-col gap-2 p-6">
        <h2 className="font-display text-md text-text">{t(`${phase}.heading`)}</h2>
        <p className="text-sm text-text-muted">{t(`${phase}.body`)}</p>
        {phase === "ovulatory" ? (
          <p className="text-sm font-medium text-text">{t("ovulatory.notContraception")}</p>
        ) : null}
        <Link
          href="/learn/menstrual-cycle-basics"
          className="text-sm text-text-link underline"
        >
          {t("readMore")}
        </Link>
      </CardContent>
    </Card>
  );
}
