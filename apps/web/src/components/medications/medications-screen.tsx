"use client";

import { useState } from "react";
import { useFormatter, useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import { useSupabaseQuery, unwrap } from "@/lib/supabase/use-query";
import { todayISO } from "@/lib/calculators/dates";
import {
  daysOn,
  fromRow,
  MAX_NOTE_LENGTH,
  normalizeName,
  SCHEDULES,
  splitMedications,
  toScheduleJson,
  type Medication,
  type Schedule,
} from "@/lib/medications";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { chipVariants } from "@/components/ui/chip";
import { AppScreen, ScreenError } from "@/components/patterns/app-screen";
import { LoadingState } from "@/components/patterns/loading-state";

/**
 * Medicines and supplements (P2.4).
 *
 * `meds_supplements` is the fourth table unused since schema v1. The queue called
 * this "the HRT log" and HRT is what prompted it, but the screen is not HRT-shaped:
 * a woman on levothyroxine, a prenatal vitamin, an antidepressant and a patch has
 * one list, and splitting it by life stage would be the restriction-by-data-
 * structure the symptom vocabulary just avoided.
 *
 * ## The two absences
 *
 * **Nothing here advises on a dose.** No suggestion, no range, no interaction
 * check, no red text when a number looks unusual. `lib/medications` has no function
 * that could produce one. Femio is wellness, education and tracking (product rule
 * 1); an app with an opinion about how much of something a woman should take is
 * something else, and she has a prescriber for that.
 *
 * **Nothing here scores her.** No streak, no "missed", no adherence percentage. The
 * apps that grade people on taking their medicine reliably make the worst days
 * worse, which is what `docs/09` invariant 7 exists to prevent. The days-on number
 * counts from the date she wrote down, not from doses recorded — it cannot go up
 * for being good or reset for being late, because there is no adherence data here
 * to reset it with.
 *
 * **Stopping keeps the row.** `active` goes false and the entry moves down the
 * screen. "I used to be on this" is one of the most useful lines in a medical
 * history, and rule 5 says the record never loses what was true.
 */

const EMPTY = {
  name: "",
  dose: "",
  schedule: null as Schedule | null,
  startedOn: "",
  note: "",
};

export function MedicationsScreen() {
  const t = useTranslations("medications");
  const format = useFormatter();
  const today = todayISO();

  const [form, setForm] = useState(EMPTY);
  const [open, setOpen] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const query = useSupabaseQuery(async (supabase) => {
    const rows = await unwrap(
      supabase
        .from("meds_supplements")
        .select("id, name, active, schedule_json")
        .order("created_at", { ascending: false }),
    );
    return ((rows ?? []) as Parameters<typeof fromRow>[0][]).map(fromRow);
  });

  const save = async () => {
    setSaving(true);
    setError(null);

    const name = normalizeName(form.name);
    if (!name) {
      setError(t("nameRequired"));
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

    const { error: insertError } = await supabase.from("meds_supplements").insert({
      profile_id: session.user.id,
      name,
      active: true,
      schedule_json: toScheduleJson({
        dose: form.dose.trim() || null,
        schedule: form.schedule,
        startedOn: form.startedOn || null,
        stoppedOn: null,
        note: form.note.trim().slice(0, MAX_NOTE_LENGTH) || null,
      }),
    });

    setSaving(false);
    if (insertError) {
      setError(t("saveFailed"));
      return;
    }
    setForm(EMPTY);
    setOpen(false);
    query.refresh();
  };

  const stop = async (medication: Medication) => {
    const supabase = createClient();
    const { error: updateError } = await supabase
      .from("meds_supplements")
      .update({
        active: false,
        // The row stays. Only `active` and the stop date change — see rule 5.
        schedule_json: toScheduleJson({ ...medication, stoppedOn: today }),
      })
      .eq("id", medication.id);
    if (!updateError) query.refresh();
  };

  const restart = async (medication: Medication) => {
    const supabase = createClient();
    const { error: updateError } = await supabase
      .from("meds_supplements")
      .update({
        active: true,
        schedule_json: toScheduleJson({ ...medication, stoppedOn: null }),
      })
      .eq("id", medication.id);
    if (!updateError) query.refresh();
  };

  if (query.status === "loading") {
    return (
      <AppScreen busy>
        <LoadingState label={t("loading")} />
      </AppScreen>
    );
  }

  if (query.status === "error") {
    return (
      <AppScreen>
        <ScreenError
          title={t("title")}
          message={t("loadError")}
          retryLabel={t("retry")}
          onRetry={query.refresh}
        />
      </AppScreen>
    );
  }

  const { current, stopped } = splitMedications(query.data);
  const fmt = (iso: string) =>
    format.dateTime(new Date(`${iso}T00:00:00Z`), { dateStyle: "medium", timeZone: "UTC" });

  const row = (medication: Medication) => {
    const days = daysOn(medication, today);
    return (
      <Card key={medication.id}>
        <CardContent className="flex flex-col gap-2 p-5">
          <div className="flex flex-wrap items-baseline justify-between gap-x-3 gap-y-1">
            <p className="font-display text-md text-text">{medication.name}</p>
            {medication.dose ? (
              <p className="text-sm text-text-muted">{medication.dose}</p>
            ) : null}
          </div>
          {medication.schedule ? (
            <p className="text-sm text-text-muted">{t(`schedules.${medication.schedule}`)}</p>
          ) : null}
          {medication.startedOn ? (
            <p className="text-sm text-text-muted">
              {medication.active
                ? t("since", { date: fmt(medication.startedOn) })
                : t("between", {
                    start: fmt(medication.startedOn),
                    end: medication.stoppedOn ? fmt(medication.stoppedOn) : "—",
                  })}
              {days !== null ? ` · ${t("daysOn", { days })}` : ""}
            </p>
          ) : null}
          {medication.note ? <p className="text-sm text-text">{medication.note}</p> : null}
          <Button
            variant="outline"
            className="self-start"
            onClick={() => (medication.active ? stop(medication) : restart(medication))}
          >
            {medication.active ? t("stop") : t("restart")}
          </Button>
        </CardContent>
      </Card>
    );
  };

  return (
    <AppScreen>
      <div className="flex flex-wrap items-center justify-between gap-3">
        <h1 className="font-display text-lg text-text">{t("title")}</h1>
        <Button variant={open ? "outline" : "accent"} onClick={() => setOpen(!open)}>
          {open ? t("cancel") : t("add")}
        </Button>
      </div>

      {/* Said once, at the top. The absences below are deliberate and she should
          not have to infer them from a missing field. */}
      <p className="text-2xs leading-relaxed text-text-subtle">{t("boundary")}</p>

      {open ? (
        <Card>
          <CardContent className="flex flex-col gap-4 p-5">
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="med-name">{t("form.name")}</Label>
              <Input
                id="med-name"
                value={form.name}
                placeholder={t("form.namePlaceholder")}
                onChange={(e) => setForm({ ...form, name: e.target.value })}
              />
            </div>
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="med-dose">{t("form.dose")}</Label>
              <Input
                id="med-dose"
                value={form.dose}
                placeholder={t("form.dosePlaceholder")}
                onChange={(e) => setForm({ ...form, dose: e.target.value })}
              />
              <p className="text-2xs text-text-subtle">{t("form.doseHint")}</p>
            </div>
            <fieldset className="flex flex-col gap-2">
              <legend className="text-sm font-medium text-text">{t("form.schedule")}</legend>
              <div className="flex flex-wrap gap-2">
                {SCHEDULES.map((schedule) => (
                  <button
                    key={schedule}
                    type="button"
                    aria-pressed={form.schedule === schedule}
                    onClick={() =>
                      setForm({
                        ...form,
                        schedule: form.schedule === schedule ? null : schedule,
                      })
                    }
                    className={chipVariants({ selected: form.schedule === schedule })}
                  >
                    {t(`schedules.${schedule}`)}
                  </button>
                ))}
              </div>
            </fieldset>
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="med-started">{t("form.startedOn")}</Label>
              <Input
                id="med-started"
                type="date"
                max={today}
                value={form.startedOn}
                onChange={(e) => setForm({ ...form, startedOn: e.target.value })}
              />
            </div>
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="med-note">{t("form.note")}</Label>
              <Input
                id="med-note"
                value={form.note}
                maxLength={MAX_NOTE_LENGTH}
                placeholder={t("form.notePlaceholder")}
                onChange={(e) => setForm({ ...form, note: e.target.value })}
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
          </CardContent>
        </Card>
      ) : null}

      {current.length === 0 && stopped.length === 0 ? (
        <Card>
          <CardContent className="flex flex-col gap-2 p-6">
            <p className="font-display text-md text-text">{t("empty.heading")}</p>
            <p className="text-sm text-text-muted">{t("empty.body")}</p>
          </CardContent>
        </Card>
      ) : null}

      {current.length > 0 ? (
        <section className="flex flex-col gap-3">
          <h2 className="text-md font-semibold text-text">{t("currentHeading")}</h2>
          {current.map(row)}
        </section>
      ) : null}

      {/* Never hidden, only lower. What she used to take is history, and history is
          exactly what a consultation asks for. */}
      {stopped.length > 0 ? (
        <section className="flex flex-col gap-3">
          <h2 className="text-md font-semibold text-text">{t("stoppedHeading")}</h2>
          {stopped.map(row)}
        </section>
      ) : null}
    </AppScreen>
  );
}
