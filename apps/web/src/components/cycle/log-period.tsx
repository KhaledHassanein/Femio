"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
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

  const save = async () => {
    setSaving(true);
    setError(null);
    const supabase = createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) {
      router.push("/welcome");
      return;
    }
    const { error: insertError } = await supabase
      .from("cycles")
      .insert({ profile_id: user.id, period_start: date });
    if (insertError) {
      setError(insertError.message);
      setSaving(false);
      return;
    }
    setSaving(false);
    // Re-run the server component so the new period + prediction show.
    router.refresh();
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
        <Button onClick={save} disabled={saving || !date} className="self-start">
          {t("logButton")}
        </Button>
      </CardContent>
    </Card>
  );
}
