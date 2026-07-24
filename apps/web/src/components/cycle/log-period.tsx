"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import { saveOrQueue } from "@/lib/offline/sync";
import { todayISO } from "@/lib/calculators/dates";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

export function LogPeriod() {
  const t = useTranslations("track");
  const router = useRouter();
  const [date, setDate] = useState(todayISO());
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [queued, setQueued] = useState(false);

  const save = async () => {
    setSaving(true);
    setError(null);
    setQueued(false);
    const supabase = createClient();
    // getSession reads the cached session without a network call, so this works
    // offline (unlike getUser).
    const {
      data: { session },
    } = await supabase.auth.getSession();
    if (!session) {
      router.push("/welcome");
      return;
    }
    const res = await saveOrQueue("cycles", { profile_id: session.user.id, period_start: date });
    setSaving(false);
    if (res === "synced") {
      router.refresh(); // re-run the server component so the new period + prediction show
    } else if (res === "queued") {
      setQueued(true);
    } else {
      setError(res.error);
    }
  };

  return (
    <Card>
      <CardContent className="flex flex-col gap-4 p-6">
        <h2 className="text-md font-semibold text-text">{t("logHeading")}</h2>
        <div className="flex flex-col gap-2">
          <Label htmlFor="period-date">{t("logDateLabel")}</Label>
          <Input
            id="period-date"
            type="date"
            max={todayISO()}
            value={date}
            onChange={(e) => setDate(e.target.value)}
          />
        </div>
        {error ? (
          <Alert variant="danger">
            <AlertDescription>{error}</AlertDescription>
          </Alert>
        ) : null}
        {queued ? (
          <Alert variant="info">
            <AlertDescription>{t("savedOffline")}</AlertDescription>
          </Alert>
        ) : null}
        <Button onClick={save} disabled={saving || !date} className="self-start">
          {t("logButton")}
        </Button>
      </CardContent>
    </Card>
  );
}
