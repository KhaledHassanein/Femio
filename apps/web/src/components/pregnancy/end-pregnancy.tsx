"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";

/**
 * End an active pregnancy record (P1.13d).
 *
 * WHY THIS MATTERS MORE THAN IT LOOKS: without it the week counter simply kept running,
 * and once the record aged past plausibility the panel fell back to "Set up your
 * pregnancy" — so a person who had just had a loss was shown either a running count of a
 * pregnancy she no longer had, or a cheerful invitation to start again. Neither is a
 * neutral default. The schema anticipated this (`status` accepts completed/loss/ended);
 * nothing in the UI ever set it.
 *
 * Design notes, all of them about not making a bad day worse:
 *  - The action is deliberately quiet: a plain link-styled control, not a prominent
 *    button competing with the week count.
 *  - Confirmation is one step, not an "are you sure?" interrogation. Being asked twice
 *    to confirm a loss is its own small cruelty.
 *  - The three outcomes are named plainly and without euphemism, because a euphemism
 *    here reads as discomfort with her situation.
 *  - Nothing is deleted. The row is kept with its status so history stays intact — a
 *    life spans several pregnancies, which is why the table holds rows rather than one
 *    per profile — and she can export or delete it like any other data.
 */
type Outcome = "completed" | "loss" | "ended";
const OUTCOMES: Outcome[] = ["completed", "loss", "ended"];

export function EndPregnancy({ pregnancyId }: { pregnancyId: string }) {
  const t = useTranslations("pregnancy.end");
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [saving, setSaving] = useState<Outcome | null>(null);
  const [error, setError] = useState<string | null>(null);

  const end = async (outcome: Outcome) => {
    setSaving(outcome);
    setError(null);

    const supabase = createClient();
    const {
      data: { session },
    } = await supabase.auth.getSession();
    if (!session) {
      router.push("/welcome");
      return;
    }

    const { error: writeError } = await supabase
      .from("pregnancy")
      .update({ status: outcome })
      .eq("id", pregnancyId);

    if (writeError) {
      setError(t("failed"));
      setSaving(null);
      return;
    }

    router.refresh();
  };

  if (!open) {
    return (
      <button
        type="button"
        onClick={() => setOpen(true)}
        className="self-start text-sm text-text-muted underline"
      >
        {t("trigger")}
      </button>
    );
  }

  return (
    <div className="flex flex-col gap-3 rounded-lg border border-border p-4">
      <p className="text-sm text-text">{t("prompt")}</p>

      <div className="flex flex-col gap-2">
        {OUTCOMES.map((outcome) => (
          <Button
            key={outcome}
            type="button"
            variant="outline"
            size="sm"
            className="justify-start"
            disabled={saving !== null}
            onClick={() => end(outcome)}
          >
            {saving === outcome ? t("saving") : t(`outcome.${outcome}`)}
          </Button>
        ))}
      </div>

      {error ? (
        <Alert variant="danger">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      ) : null}

      <div className="flex items-center gap-3">
        <button
          type="button"
          onClick={() => {
            setOpen(false);
            setError(null);
          }}
          className="text-sm text-text-muted underline"
          disabled={saving !== null}
        >
          {t("cancel")}
        </button>
      </div>

      <p className="text-sm text-text-subtle">{t("privacyNote")}</p>
    </div>
  );
}
