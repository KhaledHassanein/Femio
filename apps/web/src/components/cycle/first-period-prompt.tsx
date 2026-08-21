"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useTranslations } from "next-intl";

import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { createClient } from "@/lib/supabase/client";
import { saveOrQueue } from "@/lib/offline/sync";
import { todayISO } from "@/lib/calculators/dates";

/**
 * The first thing a new user is asked — and the fix for the dashboard's dead end
 * (`docs/26` §2.5).
 *
 * The empty state asked her to "log a couple of periods to unlock insights" and
 * offered one button: **Log today**. Her periods are in the past. The single action
 * on the screen could not produce the state the screen was asking for, so the only
 * way through was to find `/track`, notice the date strip, and back-date by hand —
 * and the date strip only reaches back fourteen days, which is less than one cycle.
 *
 * This is the highest-leverage broken flow in the product, because every single
 * user meets it before anything else, and a first run that dead-ends is a first run
 * that ends.
 *
 * So it asks the question the empty state was already posing, with a field that can
 * answer it. One date, no flow, no symptoms: everything else can be added later,
 * and asking for more here trades the only thing that matters — getting one real
 * date in — against a form she might abandon.
 */
export function FirstPeriodPrompt({
  loggedCount,
  onSaved,
}: {
  /** How many period starts she already has. Predictions need two. */
  loggedCount: number;
  onSaved?: () => void;
}) {
  const t = useTranslations("firstRun");
  // One logged period is still a dead end: `predictNextPeriod` needs two starts,
  // so the window module renders nothing and the screen goes quiet without ever
  // saying what it is waiting for. Asking for the *previous* period is the honest
  // next question — it is exactly what turns one date into a cycle.
  const step = loggedCount === 0 ? "first" : "second";
  const router = useRouter();
  const today = todayISO();

  // Defaults to today, and `max` forbids the future. A future period start is not
  // a log, it is a prediction, and Femio does not accept one as evidence — the
  // prediction maths would treat it as an observed cycle and quietly skew every
  // window that follows it.
  const [date, setDate] = useState(today);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const save = async () => {
    setSaving(true);
    setError(null);
    const supabase = createClient();
    // `getSession` reads the cached session with no network call, so this path
    // still works offline — the same reason `log-period.tsx` uses it.
    const {
      data: { session },
    } = await supabase.auth.getSession();
    if (!session) {
      router.push("/welcome");
      return;
    }
    const res = await saveOrQueue("cycles", { profile_id: session.user.id, period_start: date });
    setSaving(false);
    if (typeof res === "object") {
      setError(res.error);
      return;
    }
    // "queued" counts as done here. She is offline, the row is safely on the
    // device, and telling her it failed would be a lie that costs the first thing
    // she ever gave us.
    onSaved?.();
  };

  return (
    <Card>
      <CardContent className="flex flex-col gap-4 p-6">
        <div className="flex flex-col gap-1">
          <h2 className="font-display text-lg text-text">{t(`${step}.heading`)}</h2>
          <p className="text-sm text-text-muted">{t(`${step}.body`)}</p>
        </div>

        <div className="flex flex-col gap-2">
          <Label htmlFor="first-period-date">{t(`${step}.dateLabel`)}</Label>
          <Input
            id="first-period-date"
            type="date"
            value={date}
            max={today}
            onChange={(e) => setDate(e.target.value)}
          />
        </div>

        <Button onClick={save} disabled={saving || !date} className="w-full">
          {saving ? t("saving") : t("save")}
        </Button>

        {error ? (
          <p role="alert" className="text-sm text-danger">
            {t("error")}
          </p>
        ) : null}

        <p className="text-2xs text-text-muted">{t("note")}</p>
      </CardContent>
    </Card>
  );
}
