"use client";

import { useEffect, useState } from "react";
import { useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import { useCrisisHelp } from "@/hooks/use-crisis-help";
import {
  EPDS_ITEMS,
  EPDS_MAX,
  epdsResultRow,
  optionForValue,
  scoreEpds,
  valueForOption,
  type EpdsAnswers,
  type EpdsItem,
} from "@/lib/screeners/epds";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { chipVariants } from "@/components/ui/chip";

/**
 * The postpartum mood check — EPDS (P2.7, P1.26.3).
 *
 * This retires `support.checkIn` from `UNIMPLEMENTED`. R2.5 shipped Track E with a
 * hero that asks how she is doing and deliberately stops there, because a mood
 * *screener* needs the crisis routing that comes with it. This is that screener,
 * with that routing.
 *
 * ## The behaviour that matters more than the score
 *
 * Item 10 is *"the thought of harming myself has occurred to me"*. Any answer above
 * "never" opens the crisis help route **immediately** — the moment she taps it,
 * before any total is calculated or shown, and whatever the total turns out to be.
 * Published guidance is unanimous that a positive item 10 is followed up regardless
 * of the score, and a woman can answer it above zero while scoring below every
 * published cut-off.
 *
 * That decision lives in `lib/screeners/epds.ts` as `selfHarmItemPositive`, not
 * here, so it cannot be lost by a screen forgetting it. What this file owns is the
 * *timing*: on the tap, not on submit. Someone who answers honestly and then closes
 * the app must still have been offered the door.
 *
 * ## And the number is still just a number
 *
 * No band, no "probable depression", no colour. The literature attaches cut-offs —
 * 10, 11 and 13 all appear depending on setting and translation, which is itself
 * the argument — and Femio applies none. Same posture as the MRS: it reports, and
 * it says take this to your clinician.
 *
 * Saving is optional and separate from answering. She may want the route without
 * wanting a record, and requiring the second to get the first would be a toll on
 * asking for help.
 */
export function MoodCheck() {
  const t = useTranslations("epds");
  const crisis = useCrisisHelp();

  const [answers, setAnswers] = useState<EpdsAnswers>({});
  const [saving, setSaving] = useState(false);
  const [saved, setSaved] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const score = scoreEpds(answers);

  /**
   * Open the door on the answer, not on the submit.
   *
   * `useEffect` rather than an inline call in the tap handler so it also fires if
   * she reaches the state any other way — a restored draft, a future edit to this
   * screen. It runs once per transition into the positive state; re-opening the
   * dialog she has just closed would be badgering, not helping.
   */
  useEffect(() => {
    if (score.selfHarmItemPositive) crisis.open();
    // eslint-disable-next-line react-hooks/exhaustive-deps -- open() is stable; re-running on `crisis` would reopen it.
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
      .insert(epdsResultRow(session.user.id, score));
    setSaving(false);
    if (insertError) {
      setError(t("saveFailed"));
      return;
    }
    setSaved(true);
  };

  const pick = (item: EpdsItem, optionIndex: number) => {
    setAnswers((prev) => {
      const next = { ...prev };
      const value = valueForOption(item, optionIndex);
      // Tapping the same answer clears it, so "I would rather not say" stays
      // reachable after a mis-tap — including on item 10.
      if (next[item] === value) delete next[item];
      else next[item] = value;
      return next;
    });
  };

  const selectedIndex = (item: EpdsItem) => {
    const value = answers[item];
    return value === undefined ? null : optionForValue(item, value);
  };

  return (
    <Card>
      <CardContent className="flex flex-col gap-5 p-5">
        <div className="flex flex-col gap-1">
          <h2 className="text-md font-semibold text-text">{t("heading")}</h2>
          <p className="text-sm text-text-muted">{t("intro")}</p>
        </div>

        {EPDS_ITEMS.map((item) => (
          <fieldset key={item} className="flex flex-col gap-2">
            <legend className="text-sm font-medium text-text">{t(`items.${item}.label`)}</legend>
            <div className="flex flex-wrap gap-2">
              {Array.from({ length: EPDS_MAX + 1 }, (_, index) => (
                <button
                  key={index}
                  type="button"
                  aria-pressed={selectedIndex(item) === index}
                  onClick={() => pick(item, index)}
                  className={chipVariants({ selected: selectedIndex(item) === index })}
                >
                  {t(`items.${item}.options.${index}`)}
                </button>
              ))}
            </div>
          </fieldset>
        ))}

        {/* Shown as well as opening the dialog, because the dialog can be closed
            and this should still be on the screen she returns to. It carries no
            interpretation of her — only the route. */}
        {score.selfHarmItemPositive ? (
          <Alert variant="warning">
            <AlertDescription className="flex flex-col gap-2">
              <span className="font-medium">{t("support.heading")}</span>
              <span>{t("support.body")}</span>
              <button
                type="button"
                onClick={crisis.open}
                className="self-start underline"
              >
                {t("support.cta")}
              </button>
            </AlertDescription>
          </Alert>
        ) : null}

        {score.answered > 0 ? (
          <div className="flex flex-col gap-2 rounded-md border border-border bg-surface-sunken p-4">
            <p className="font-display text-lg text-text">
              {t("total", { total: score.total, answered: score.answered })}
            </p>
            {!score.complete ? (
              <p className="text-sm text-warning-text">{t("partial")}</p>
            ) : null}
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

        {/* Saving is optional and deliberately separate from answering: she may
            want the route without wanting a record, and making the second the price
            of the first would be a toll on asking for help. */}
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
