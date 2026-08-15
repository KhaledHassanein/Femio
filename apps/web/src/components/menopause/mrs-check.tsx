"use client";

import { useState } from "react";
import { useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import { MRS_ITEMS, MRS_MAX, mrsResultRow, scoreMrs, type MrsAnswers } from "@/lib/screeners/mrs";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { chipVariants } from "@/components/ui/chip";

/**
 * The Menopause Rating Scale, as a screener (P2.4).
 *
 * `screener_results` has existed since schema v1 — its comment names MRS
 * explicitly — and nothing has ever written a row. This is the first one.
 *
 * ## It reports a number and refuses to grade it
 *
 * The scoring is in `lib/screeners/mrs.ts` because `native-readiness-lint` forbids
 * screener scoring in a client component (R2.7), and this screen shows the total
 * exactly as tier 1 produced it: no band, no label, no colour that means anything.
 * The published literature does attach cut-offs; Femio does not apply them.
 *
 * The distinction is product rule 1 in one sentence. "Your total is 19" is
 * arithmetic on answers she gave. "Your symptoms are severe" is a clinical
 * assessment — and the difference matters most for the woman who would read the
 * second one and decide she does not need the appointment.
 *
 * So the result is framed the way every Femio screener is framed: *this is
 * screening — take it to your clinician.* The number's job is to make that
 * conversation shorter, not to replace it.
 *
 * ## Partial answers are shown as partial
 *
 * A total from six items is not comparable to a total from eleven, so the count of
 * answered items travels with it. Scoring blanks as zero would describe her as
 * having fewer symptoms than she reported, in a number she may read out loud.
 */
export function MrsCheck() {
  const t = useTranslations("mrs");
  const [answers, setAnswers] = useState<MrsAnswers>({});
  const [saving, setSaving] = useState(false);
  const [saved, setSaved] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const score = scoreMrs(answers);

  const save = async () => {
    setSaving(true);
    setError(null);
    const supabase = createClient();
    const {
      data: { session },
    } = await supabase.auth.getSession();
    if (!session) {
      setSaving(false);
      setError(t("saveFailed"));
      return;
    }
    const { error: insertError } = await supabase
      .from("screener_results")
      .insert(mrsResultRow(session.user.id, score));
    setSaving(false);
    if (insertError) {
      setError(t("saveFailed"));
      return;
    }
    setSaved(true);
  };

  return (
    <Card>
      <CardContent className="flex flex-col gap-5 p-5">
        <div className="flex flex-col gap-1">
          <h2 className="text-md font-semibold text-text">{t("heading")}</h2>
          <p className="text-sm text-text-muted">{t("intro")}</p>
        </div>

        {MRS_ITEMS.map((item) => (
          <fieldset key={item} className="flex flex-col gap-2">
            <legend className="text-sm font-medium text-text">{t(`items.${item}`)}</legend>
            <div className="flex flex-wrap gap-2">
              {Array.from({ length: MRS_MAX + 1 }, (_, value) => (
                <button
                  key={value}
                  type="button"
                  aria-pressed={answers[item] === value}
                  onClick={() =>
                    setAnswers((prev) => {
                      const next = { ...prev };
                      // Tapping the same answer clears it, so "I would rather not
                      // say" stays reachable after a mis-tap.
                      if (next[item] === value) delete next[item];
                      else next[item] = value;
                      return next;
                    })
                  }
                  className={chipVariants({ selected: answers[item] === value })}
                >
                  {t(`levels.${value}`)}
                </button>
              ))}
            </div>
          </fieldset>
        ))}

        {score.answered > 0 ? (
          <div className="flex flex-col gap-2 rounded-md border border-border bg-surface-sunken p-4">
            <p className="font-display text-lg text-text">
              {t("total", { total: score.total, answered: score.answered })}
            </p>
            <p className="text-sm text-text-muted">
              {t("subscales", {
                somatic: score.subscales.somatic,
                psychological: score.subscales.psychological,
                urogenital: score.subscales.urogenital,
              })}
            </p>
            {!score.complete ? (
              <p className="text-sm text-warning-text">{t("partial")}</p>
            ) : null}
            {/* The framing every Femio screener carries, and the reason there is no
                band above it: the number is for the conversation, not instead of it. */}
            <p className="text-sm text-text">{t("discuss")}</p>
          </div>
        ) : null}

        {error ? (
          <Alert variant="danger">
            <AlertDescription>{error}</AlertDescription>
          </Alert>
        ) : null}
        {saved ? (
          <Alert variant="success">
            <AlertDescription>{t("saved")}</AlertDescription>
          </Alert>
        ) : null}

        <Button
          onClick={save}
          disabled={saving || score.answered === 0}
          variant="accent"
          className="w-full"
        >
          {saving ? t("saving") : t("save")}
        </Button>
      </CardContent>
    </Card>
  );
}
