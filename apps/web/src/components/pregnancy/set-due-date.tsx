"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import { todayISO } from "@/lib/calculators/dates";
import { eddFromLmp, isPlausibleEdd } from "@/lib/pregnancy";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

/**
 * Capture the due date that drives the pregnancy dashboard (P1.13b).
 *
 * Two ways in, because people arrive holding different things: most have a due date
 * from a clinician, some only remember their last period. Asking for the due date
 * first is deliberate — where a dating scan has revised it, the clinician's date is
 * the correct one, and quietly recomputing from LMP would show a week count that
 * disagrees with her notes.
 */
export function SetDueDate({ initialEdd }: { initialEdd?: string | null }) {
  const t = useTranslations("pregnancy.setup");
  const router = useRouter();
  const today = todayISO();

  const [mode, setMode] = useState<"edd" | "lmp">("edd");
  const [value, setValue] = useState(initialEdd ?? "");
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const save = async () => {
    setSaving(true);
    setError(null);

    const edd = mode === "edd" ? value : eddFromLmp(value);
    if (!edd || !isPlausibleEdd(edd, today)) {
      // A week counter built on a typo is worse than an empty state.
      setError(t("invalid"));
      setSaving(false);
      return;
    }

    const supabase = createClient();
    const {
      data: { session },
    } = await supabase.auth.getSession();
    if (!session) {
      router.push("/welcome");
      return;
    }

    // One active pregnancy at a time; the table holds a row per pregnancy because a
    // life spans several, so update the active row rather than inserting another.
    const { data: existing } = await supabase
      .from("pregnancy")
      .select("id")
      .eq("status", "active")
      .maybeSingle();

    const { error: writeError } = existing
      ? await supabase.from("pregnancy").update({ edd }).eq("id", existing.id)
      : await supabase.from("pregnancy").insert({ profile_id: session.user.id, edd, status: "active" });

    if (writeError) {
      setError(t("saveFailed"));
      setSaving(false);
      return;
    }

    router.refresh();
    setSaving(false);
  };

  return (
    <div className="flex flex-col gap-3">
      <div className="flex flex-wrap gap-2">
        {(["edd", "lmp"] as const).map((m) => (
          <Button
            key={m}
            type="button"
            variant={mode === m ? "accent" : "outline"}
            size="sm"
            onClick={() => {
              setMode(m);
              setValue("");
              setError(null);
            }}
            aria-pressed={mode === m}
          >
            {t(`mode.${m}`)}
          </Button>
        ))}
      </div>

      <div className="flex flex-col gap-1.5">
        <Label htmlFor="pregnancy-date">{t(`label.${mode}`)}</Label>
        <Input
          id="pregnancy-date"
          type="date"
          value={value}
          onChange={(e) => setValue(e.target.value)}
          max={mode === "lmp" ? today : undefined}
        />
      </div>

      {error ? (
        <Alert variant="danger">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      ) : null}

      <div>
        <Button onClick={save} disabled={saving || !value} variant="accent">
          {saving ? t("saving") : t("save")}
        </Button>
      </div>

      <p className="text-sm text-text-subtle">{t("privacyNote")}</p>
    </div>
  );
}
