"use client";

import { useTranslations } from "next-intl";

import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { bandFor } from "@/lib/patterns/rows";

/**
 * One persisted finding, on the home surface (D2, `patterns.finding`).
 *
 * The patterns *screen* already read her entries back to her; what it could not do
 * is put a finding where she actually looks. `0019` exists for that, and this is
 * what renders a row from it.
 *
 * ## Every rule the screen holds, this holds too
 *
 * **The claim never arrives without its denominator.** "Cramps around day 2" is a
 * rule about her body that Femio has no standing to state; "in 4 of your last 6
 * cycles" is an observation. The evidence line is not optional and there is no
 * prop to turn it off — product rule 3 applied to an observation rather than a
 * prediction.
 *
 * **Confidence is a word, never a percentage.** `0019`: shown through
 * `--confidence-*`, never as a percentage badge. A figure invites her to read
 * precision that three to twelve cycles of unprotocolled self-report cannot carry,
 * and the band is recomputed from the stored coverage on every read so a later
 * change to the thresholds reclassifies old rows rather than leaving them frozen.
 *
 * **Nothing interprets.** No cause, no projection, no "worse" — severity moves
 * *higher* or *lower*, a fact about her entries rather than a judgement about her
 * health (`docs/09` invariant 7).
 *
 * ## Dismissal is the whole reason this is safe to put on the home screen
 *
 * A finding she has read and put away does not come back. `0019` names repeating
 * insight cards as the specific thing that makes a competitor tiresome, and a card
 * she cannot silence on the one screen she cannot avoid is worse than no card. The
 * write goes through the only column `authenticated` may update.
 */

export type FindingRow = {
  id: string;
  kind: "timing" | "co_occurrence" | "severity_trend";
  subject: string;
  partner_key: string | null;
  summary_key: string;
  evidence_json: Record<string, string | number>;
  confidence: number;
  cycles_used: number;
};

export function PatternFindingCard({
  row,
  label,
  onDismiss,
}: {
  row: FindingRow;
  /** Term key → her language. Supplied by the caller, which owns the namespaces. */
  label: (key: string) => string;
  onDismiss: () => void;
}) {
  const t = useTranslations("patterns");
  const band = bandFor(row);
  const e = row.evidence_json;

  // The summary key is stored, not the sentence, so the row reads in four
  // languages. Each kind supplies its own values because they are genuinely
  // different claims — a shared bag of params would let a missing one render as a
  // literal `{from}` in somebody's browser.
  const summary =
    row.kind === "timing"
      ? t("timing.summary", { symptom: label(row.subject), from: Number(e.from), to: Number(e.to) })
      : row.kind === "co_occurrence"
        ? t("together.summary", { a: label(row.subject), b: label(row.partner_key ?? "") })
        : t(row.summary_key.replace(/^patterns\./, ""), { symptom: label(row.subject) });

  const evidence =
    row.kind === "severity_trend"
      ? t("severity.evidence", {
          recent: Number(e.recentMean),
          earlier: Number(e.earlierMean),
          cycles: row.cycles_used,
        })
      : row.kind === "timing"
        ? t("timing.evidence", { cycles: Number(e.cycles), ofCycles: Number(e.ofCycles) })
        : t("together.evidence", { cycles: Number(e.cycles), ofCycles: Number(e.ofCycles) });

  return (
    <Card>
      <CardContent className="flex flex-col gap-2 p-5">
        <div className="flex items-start justify-between gap-3">
          <p className="font-display text-md text-text">{summary}</p>
          {/* Neutral, always: confidence is information, not emphasis, and one
              accent per screen (`docs/25` §5a). A coloured badge would make the
              strongest finding the loudest thing on her home screen. */}
          <Badge variant="neutral">{t(`confidence.${band}`)}</Badge>
        </div>
        <p className="text-sm text-text-muted">{evidence}</p>
        <div>
          <Button variant="ghost" size="sm" onClick={onDismiss}>
            {t("dismiss")}
          </Button>
        </div>
      </CardContent>
    </Card>
  );
}
