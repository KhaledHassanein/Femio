"use client";

import { useTranslations } from "next-intl";

import { Card, CardContent } from "@/components/ui/card";
import type { SymptomPattern } from "@/lib/cycle/symptom-patterns";

/**
 * Her own symptoms, read back against her own cycle (`docs/27` phase 3.2).
 *
 * `symptom_logs` has held real data since P1.14 and nothing read it beyond
 * counting the three most frequent types. Both incumbents ship pattern spotting;
 * `docs/26` §6 lists it as table stakes Femio was missing.
 *
 * ## The claim is deliberately small
 *
 * "You logged this on days 1–3, in 4 of your last 5 cycles" is arithmetic she
 * could do with a calendar, and it is the entire claim. It does not say the cycle
 * *caused* anything, does not predict the next occurrence, and does not name a
 * condition. The reviewed article beside it puts the limit in the words this card
 * borrows: *a repeating pattern may be useful to record, but the pattern alone
 * cannot confirm a health condition.*
 *
 * ## Why the denominator is on screen
 *
 * "In 4 of your last 5 cycles" is doing real work. Without it, "days 1–3" reads as
 * a rule about her body; with it, she can see how much evidence is behind it and
 * discount it herself. Showing the strength of evidence rather than a confidence
 * word is the same choice the prediction band makes by drawing its uncertainty
 * instead of stating it (`docs/25` §5a).
 *
 * Renders nothing below the evidence threshold — `symptomPatterns` returns `[]`
 * and this returns `null`, because "not yet" is a real answer and an empty card
 * inviting her to log more would be nagging her for data to fill a box.
 */
export function SymptomPatternCard({
  patterns,
  label,
}: {
  patterns: readonly SymptomPattern[];
  /** Translates a symptom key to her own vocabulary. */
  label: (type: string) => string;
}) {
  const t = useTranslations("symptomPatterns");
  if (patterns.length === 0) return null;

  return (
    <Card>
      <CardContent className="flex flex-col gap-3 p-6">
        <div className="flex flex-col gap-0.5">
          <h2 className="font-display text-md text-text">{t("heading")}</h2>
          <p className="text-2xs text-text-muted">{t("note")}</p>
        </div>

        <ul className="flex flex-col gap-2">
          {patterns.map((p) => (
            <li key={p.type} className="flex flex-col gap-0.5">
              <span className="text-sm text-text">
                {p.from === p.to
                  ? t("onDay", { symptom: label(p.type), day: p.from })
                  : t("onDays", { symptom: label(p.type), from: p.from, to: p.to })}
              </span>
              {/* The evidence, not a confidence adjective. */}
              <span className="text-2xs text-text-muted">
                {t("evidence", { cycles: p.cycles, ofCycles: p.ofCycles })}
              </span>
            </li>
          ))}
        </ul>

        <p className="text-2xs text-text-muted">{t("limit")}</p>
      </CardContent>
    </Card>
  );
}
