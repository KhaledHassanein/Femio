"use client";

import { useEffect, useState } from "react";
import { useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import { useCrisisHelp } from "@/hooks/use-crisis-help";
import {
  MOOD_ITEMS,
  MOOD_MAX,
  moodResultRow,
  scoreMood,
  type MoodAnswers,
  type MoodTool,
} from "@/lib/screeners/mood";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { chipVariants } from "@/components/ui/chip";

/**
 * PHQ-9 and GAD-7, as one component parameterised by instrument (P2.7, P1.26.3).
 *
 * The two screeners differ in their items, their length and whether they have a
 * self-harm question — and in nothing else a screen can see. `lib/screeners/mood.ts`
 * owns all three differences, so this file renders `MOOD_ITEMS[tool]` and asks the
 * score whether the crisis route applies. A second near-identical component would
 * have been two places for the item-9 rule to live, and one of them would eventually
 * lose it.
 *
 * The routing is the same rule the EPDS established: a positive PHQ-9 item 9 opens
 * the crisis route **on the answer, not on submit**, whatever the total, with a
 * panel that stays behind the dialog so dismissing it does not remove the door.
 * `selfHarmItemPositive` is always false for GAD-7 because the instrument has no
 * such item, which is a fact of the instrument rather than a branch here.
 *
 * And the number stays a number: no band, no "moderately severe", no colour. The
 * published bands are real; applying them would be Femio assessing her.
 */
export function MoodScreener({ tool }: { tool: MoodTool }) {
  const t = useTranslations("moodScreeners");
  const crisis = useCrisisHelp();

  const [answers, setAnswers] = useState<MoodAnswers>({});
  const [saving, setSaving] = useState(false);
  const [saved, setSaved] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const score = scoreMood(tool, answers);

  // On the answer, not on submit — someone who answers honestly and then closes
  // the app must still have been offered the door.
  useEffect(() => {
    if (score.selfHarmItemPositive) crisis.open();
    // eslint-disable-next-line react-hooks/exhaustive-deps -- re-running on `crisis` would reopen a dialog she just closed.
  }, [score.selfHarmItemPositive]);

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
      .insert(moodResultRow(session.user.id, score));
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
          <h2 className="text-md font-semibold text-text">{t(`${tool}.heading`)}</h2>
          <p className="text-sm text-text-muted">{t("intro")}</p>
        </div>

        {MOOD_ITEMS[tool].map((item) => (
          <fieldset key={item} className="flex flex-col gap-2">
            <legend className="text-sm font-medium text-text">{t(`items.${item}`)}</legend>
            <div className="flex flex-wrap gap-2">
              {Array.from({ length: MOOD_MAX + 1 }, (_, value) => (
                <button
                  key={value}
                  type="button"
                  aria-pressed={answers[item] === value}
                  onClick={() =>
                    setAnswers((prev) => {
                      const next = { ...prev };
                      // Tapping the same answer clears it, so "I would rather not
                      // say" survives a mis-tap — including on item 9.
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

        {score.selfHarmItemPositive ? (
          <Alert variant="warning">
            <AlertDescription className="flex flex-col gap-2">
              <span className="font-medium">{t("support.heading")}</span>
              <span>{t("support.body")}</span>
              <button type="button" onClick={crisis.open} className="self-start underline">
                {t("support.cta")}
              </button>
            </AlertDescription>
          </Alert>
        ) : null}

        {score.answered > 0 ? (
          <div className="flex flex-col gap-2 rounded-md border border-border bg-surface-sunken p-4">
            <p className="font-display text-lg text-text">
              {t("total", {
                total: score.total,
                answered: score.answered,
                items: MOOD_ITEMS[tool].length,
              })}
            </p>
            {!score.complete ? <p className="text-sm text-warning-text">{t("partial")}</p> : null}
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
        <p className="text-2xs leading-relaxed text-text-subtle">{t("saveNote")}</p>
      </CardContent>
    </Card>
  );
}
