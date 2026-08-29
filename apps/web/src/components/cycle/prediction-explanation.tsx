"use client";

import { useState } from "react";
import { ChevronDown } from "lucide-react";
import { useTranslations } from "next-intl";

import { cn } from "@/lib/utils";
import { marginSource, type CyclePrediction } from "@/lib/cycle/predict";

/**
 * Why the window says what it says (D3, chapter 06 §1's ⓘ).
 *
 * The teardown's finding, in `0018`'s header: Flo hedges well — *"likely to
 * start"*, *"on or around"* — and **cannot say why**, because there is nowhere for
 * the reasoning to live. Femio computed every number behind the window and then
 * dropped all of them, so it was in the same position for a different reason.
 * `predict.ts` now returns its evidence and this renders it.
 *
 * ## It explains, it does not reassure
 *
 * Nothing here argues the prediction is right. It says what the prediction was
 * built from and lets her judge it — which is the difference between *"we are
 * fairly confident"*, which is a mood, and *"±3 days, because your cycles have
 * varied by five"*, which is a fact she can check against her own memory.
 *
 * That is also why the widest windows get the fullest explanation rather than the
 * quietest. A vague answer with no reason reads as the app failing; the same answer
 * with its reason reads as the app being careful, and product rule 3 is only
 * survivable if uncertainty looks like rigour rather than breakage.
 *
 * ## Collapsed by default, and never a modal
 *
 * She asked for a date, not a methodology. The explanation is one tap away and
 * takes nothing from the card above it — a dialog would make reading the reasoning
 * an interruption, and the point is that it is always available and never demanded.
 */
export function PredictionExplanation({ prediction }: { prediction: CyclePrediction }) {
  const t = useTranslations("prediction");
  const [open, setOpen] = useState(false);
  const e = prediction.evidence;

  /**
   * Where the margin actually came from.
   *
   * `predict.ts` computes `max(2, ceil(spread / 2))`, so the ±2 floor wins whenever
   * her spread is 3 days or less. The first draft of this component said *"±2 days,
   * which is half that difference"* regardless — which for a spread of 0 is both
   * unreadable ("differed by 0") and **false**: 2 is not half of 0, it is the floor.
   * An explanation feature that misstates its own arithmetic is worse than no
   * explanation, so the sentence follows the branch the code actually took.
   */
  const marginFromSpread = marginSource(e) === "spread";

  // Her stated number and a measured average are different claims and must not
  // share a sentence — `rule` is exactly this distinction, surfaced.
  /**
   * `t.rich`, so `±3` can be isolated from the surrounding text.
   *
   * Bidi reorders a sign next to a number into `3±` when it trails Arabic — the
   * same failure as `°C` → `C°` in RB-C6. Invisible isolate characters (U+2068 /
   * U+2069) in the message did not survive the ICU parse, so the isolation is
   * markup, which is what already works here.
   */
  const ltr = (chunks: React.ReactNode) => <span dir="ltr">{chunks}</span>;

  const body =
    e.rule === "stated"
      ? t.rich("explain.stated", { length: prediction.averageLength, margin: e.margin, ltr })
      : marginFromSpread
        ? t.rich("explain.observedSpread", {
            cycles: e.cyclesUsed,
            length: prediction.averageLength,
            spread: e.spread,
            margin: e.margin,
            ltr,
          })
        : e.spread === 0
          ? t.rich("explain.observedExact", {
              cycles: e.cyclesUsed,
              length: prediction.averageLength,
              margin: e.margin,
              ltr,
            })
          : t.rich("explain.observedFloor", {
              cycles: e.cyclesUsed,
              length: prediction.averageLength,
              spread: e.spread,
              margin: e.margin,
              ltr,
            });

  return (
    <div className="flex flex-col gap-2">
      <button
        type="button"
        aria-expanded={open}
        onClick={() => setOpen((v) => !v)}
        className="inline-flex min-h-11 items-center gap-1 self-start text-sm text-text-link underline"
      >
        {t("explain.trigger")}
        <ChevronDown
          aria-hidden
          className={cn("size-4 transition-transform duration-quick", open && "rotate-180")}
        />
      </button>
      {open ? (
        <div className="flex flex-col gap-2 rounded-md border border-border bg-surface-sunken p-4">
          <p className="text-sm text-text">{body}</p>
          {/* Only where the sentence above has not already said it. In the floor
              cases the main text explains the minimum, and repeating it underneath
              reads as the app insisting. */}
          {marginFromSpread ? (
            <p className="text-xs text-text-muted">{t("explain.floor")}</p>
          ) : null}
        </div>
      ) : null}
    </div>
  );
}
