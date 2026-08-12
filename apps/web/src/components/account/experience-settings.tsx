"use client";

import { useEffect, useState } from "react";
import { useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import {
  PERSONA_MODES,
  readPersonaState,
  switchMode,
  type PersonaMode,
} from "@/lib/persona/state";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { ChoiceGroup } from "@/components/ui/choice-row";
import { ReanswerTriage } from "./reanswer-triage";

/**
 * "Your Femio experience" — change life-stage mode, or switch to general
 * (docs/09 §4, which specified this from Settings and which nothing implemented).
 *
 * Why this is not a cosmetic setting: `persona_state.track` was written once at
 * onboarding and never again, so a wrong answer at signup was permanent, and a
 * real life change — pregnant, no longer pregnant, periods stopping — had no way
 * of reaching the app. Femio's whole claim is one record across a life.
 *
 * The copy carries the promise the code has to keep: **nothing is deleted and
 * nothing is hidden.** Switching mode re-layers what is emphasised over an
 * unchanged record, and every tool stays reachable from any mode (product rules
 * 2 and 5). Saying so matters as much as doing it — someone who has recorded a
 * pregnancy will not touch this control if she thinks it might erase it.
 */
export function ExperienceSettings() {
  const t = useTranslations("experience");
  const [current, setCurrent] = useState<PersonaMode | null>(null);
  const [pending, setPending] = useState<PersonaMode | null>(null);
  const [saving, setSaving] = useState(false);
  const [saved, setSaved] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let cancelled = false;
    void (async () => {
      const state = await readPersonaState(createClient());
      if (!cancelled) setCurrent(state.mode);
    })();
    return () => {
      cancelled = true;
    };
  }, []);

  const apply = async () => {
    if (!pending || pending === current) return;
    setSaving(true);
    setError(null);
    const result = await switchMode(createClient(), pending);
    setSaving(false);
    if (!result.ok) {
      setError(result.error);
      return;
    }
    setCurrent(result.mode);
    setPending(null);
    setSaved(true);
  };

  if (current === null) {
    return <div className="h-24 animate-pulse rounded-md bg-surface-sunken" aria-busy="true" />;
  }

  const selected = pending ?? current;

  return (
    <div className="flex flex-col gap-4">
      {/* The same component the wizard uses. This screen had its own copy, and it
          had already lost the radio dot and the arrow-key handling — Settings is
          where a wrong onboarding answer gets corrected, so it is the last place
          that should be the weaker version of the control. */}
      <ChoiceGroup
        label={t("heading")}
        value={selected}
        onChange={(mode) => {
          setPending(mode);
          setSaved(false);
        }}
        className="gap-2"
        options={PERSONA_MODES.map((mode: PersonaMode) => ({
          value: mode,
          name: t(`modes.${mode}.label`),
          desc: t(`modes.${mode}.desc`),
          note:
            mode === current ? (
              <span className="text-2xs text-text-subtle">{t("currentBadge")}</span>
            ) : undefined,
        }))}
      />

      {/* The reassurance is the feature. See the component note. */}
      <p className="text-sm text-text-muted">{t("nothingLost")}</p>

      {error ? (
        <Alert variant="danger">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      ) : null}
      {saved ? (
        <Alert variant="info">
          <AlertDescription>{t("saved")}</AlertDescription>
        </Alert>
      ) : null}

      <Button
        variant="accent"
        className="self-start"
        onClick={apply}
        disabled={saving || !pending || pending === current}
      >
        {saving ? t("saving") : t("apply")}
      </Button>

      {/* The second half of docs/09 §4: not just "change my stage", but "I answered
          that wrong". Keyed on the SAVED mode, not the pending one — the questions
          offered have to match the stage she is actually in. */}
      <ReanswerTriage key={current} mode={current} />
    </div>
  );
}
