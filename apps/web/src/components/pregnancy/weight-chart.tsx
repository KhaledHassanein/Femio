"use client";

import { useState } from "react";
import { useFormatter, useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import { useSupabaseQuery, unwrap } from "@/lib/supabase/use-query";
import { todayISO } from "@/lib/calculators/dates";
import {
  isPlausibleWeight,
  weightChart,
  WEIGHT_UNITS,
  type WeightEntry,
  type WeightUnit,
} from "@/lib/vitals/weight";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { chipVariants } from "@/components/ui/chip";

/**
 * The weight chart (P2.2.3), over `public.vitals` — the fifth table unused since v1.
 *
 * `pregnancy.weight` has been in the Track D registry since R2.1 and rendered
 * nothing. This is the component; `lib/vitals/weight.ts` carries the reasoning for
 * the shape, and the short version is the part worth repeating here:
 *
 * **There is no target line and no shaded range.** Guidance on weight gain in
 * pregnancy exists and is banded by starting BMI, and drawing it behind her own
 * dots would be an assessment of her body rendered as a background colour — read
 * that way whatever the caption underneath says. Pregnancy is also a high-risk
 * period for disordered eating and for weight stigma from routine weighing, so a
 * chart that silently says "above the line" every week is the app doing something
 * no clinician asked it to.
 *
 * Her dots, her axis, her numbers, and the change since her first entry as a plain
 * figure with nothing compared to it.
 */
export function WeightChart() {
  const t = useTranslations("weight");
  const format = useFormatter();
  const today = todayISO();

  const [value, setValue] = useState("");
  const [unit, setUnit] = useState<WeightUnit>("kg");
  const [measuredOn, setMeasuredOn] = useState(today);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const query = useSupabaseQuery(async (supabase) => {
    const rows = await unwrap(
      supabase
        .from("vitals")
        .select("id, value, unit, measured_at")
        .eq("type", "weight")
        .order("measured_at", { ascending: false })
        .limit(60),
    );
    return ((rows ?? []) as Record<string, unknown>[]).map(
      (r): WeightEntry => ({
        id: r.id as string,
        measuredOn: (r.measured_at as string).slice(0, 10),
        value: Number(r.value),
        unit: ((r.unit as string) === "lb" ? "lb" : "kg") as WeightUnit,
      }),
    );
  });

  const save = async () => {
    setSaving(true);
    setError(null);

    const parsed = Number(value);
    if (!isPlausibleWeight(parsed, unit)) {
      // A typo guard, not a comment on the number — see `lib/vitals/weight.ts`.
      setError(t("invalid"));
      setSaving(false);
      return;
    }

    const supabase = createClient();
    const {
      data: { session },
    } = await supabase.auth.getSession();
    if (!session) {
      setSaving(false);
      setError(t("saveFailed"));
      return;
    }

    const { error: insertError } = await supabase.from("vitals").insert({
      profile_id: session.user.id,
      type: "weight",
      value: parsed,
      unit,
      measured_at: `${measuredOn}T12:00:00Z`,
    });

    setSaving(false);
    if (insertError) {
      setError(t("saveFailed"));
      return;
    }
    setValue("");
    query.refresh();
  };

  const chart = query.status === "ready" ? weightChart(query.data) : null;
  const fmt = (iso: string) =>
    format.dateTime(new Date(`${iso}T00:00:00Z`), { day: "numeric", month: "short", timeZone: "UTC" });

  return (
    <Card>
      <CardContent className="flex flex-col gap-4 p-5">
        <div className="flex flex-col gap-1">
          <h2 className="text-md font-semibold text-text">{t("heading")}</h2>
          <p className="text-sm text-text-muted">{t("intro")}</p>
        </div>

        <div className="flex flex-wrap items-end gap-3">
          <div className="flex min-w-32 flex-1 flex-col gap-1.5">
            <Label htmlFor="weight-value">{t("value")}</Label>
            <Input
              id="weight-value"
              type="number"
              inputMode="decimal"
              step="0.1"
              value={value}
              onChange={(e) => setValue(e.target.value)}
            />
          </div>
          <div className="flex gap-2 pb-1">
            {WEIGHT_UNITS.map((u) => (
              <button
                key={u}
                type="button"
                aria-pressed={unit === u}
                onClick={() => setUnit(u)}
                className={chipVariants({ selected: unit === u })}
              >
                {t(`units.${u}`)}
              </button>
            ))}
          </div>
        </div>

        <div className="flex flex-col gap-1.5">
          <Label htmlFor="weight-date">{t("date")}</Label>
          <Input
            id="weight-date"
            type="date"
            max={today}
            value={measuredOn}
            onChange={(e) => setMeasuredOn(e.target.value)}
          />
        </div>

        {error ? (
          <Alert variant="danger">
            <AlertDescription>{error}</AlertDescription>
          </Alert>
        ) : null}

        <Button onClick={save} disabled={saving} variant="accent" className="w-full">
          {saving ? t("saving") : t("save")}
        </Button>

        {chart ? (
          <>
            {/* Dots and an axis. No target line, no shaded band, no colour that
                means anything — see the file comment. */}
            <div
              className="relative h-36 w-full rounded-md border border-border bg-surface-sunken"
              role="img"
              aria-label={t("alt", { count: chart.points.length })}
            >
              {chart.points.map((point, index) => (
                <span
                  key={point.entryId}
                  className="absolute size-2 -translate-x-1/2 translate-y-1/2 rounded-full bg-primary-solid"
                  style={{
                    left: `${((index + 0.5) / chart.points.length) * 100}%`,
                    bottom: `${point.y * 100}%`,
                  }}
                />
              ))}
            </div>
            <div className="flex justify-between text-2xs text-text-muted">
              <span>{fmt(chart.points[0]!.measuredOn)}</span>
              <span>{fmt(chart.points[chart.points.length - 1]!.measuredOn)}</span>
            </div>
            <p className="text-sm text-text">
              {t("change", {
                value: (chart.changeSinceFirst ?? 0) > 0
                  ? `+${chart.changeSinceFirst}`
                  : `${chart.changeSinceFirst}`,
                unit: t(`units.${chart.unit}`),
              })}
            </p>
            <p className="text-2xs leading-relaxed text-text-subtle">{t("note")}</p>
          </>
        ) : (
          <p className="text-sm text-text-muted">{t("needData")}</p>
        )}
      </CardContent>
    </Card>
  );
}
