"use client";

import { useState } from "react";
import { useFormatter, useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import { useSupabaseQuery, unwrap } from "@/lib/supabase/use-query";
import { todayISO } from "@/lib/calculators/dates";
import {
  awaitingResults,
  daysUntil,
  parsePrep,
  splitAppointments,
  type Appointment,
} from "@/lib/appointments";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { AppScreen, ScreenError } from "@/components/patterns/app-screen";
import { LoadingState } from "@/components/patterns/loading-state";

/**
 * Appointments (P2.2.3).
 *
 * `public.appointments` has existed since schema v1, the GDPR export has always
 * included it, RLS has always protected it — and **nothing has ever written a row**
 * (`docs/23` §3.2 listed it among the tables the product promises and does not
 * have). This is the screen that fills it.
 *
 * ## Not a pregnancy feature
 *
 * The `pregnancy.appointments` module has been in the Track D registry since R2.1,
 * so the obvious build was a panel inside the pregnancy dashboard. That would have
 * been the restriction pattern product rule 2 forbids: appointments matter in
 * fertility work-ups, in gynae follow-up, at the menopause clinic and after birth.
 * It is its own route, reachable from every mode, and the pregnancy module is a
 * *surfacing* of it rather than its home.
 *
 * ## The field this screen does not have
 *
 * There is nowhere to record what an appointment *found*. No result, no status, no
 * "normal". That is the third time this codebase has made the same call — the
 * movement log has no `result` column (ADR-049), `ClinicalStrip` has no `status`
 * prop (R2.3) — and the reason is the same each time: the moment Femio stores a
 * clinical finding, the next feature to read it is interpreting one, and product
 * rule 1 is gone.
 *
 * What it does hold is the thing women actually lose track of: **the questions they
 * meant to ask.** That is `prep_json`, it is free text, and it is the reason the
 * visit-summary work (P2.6) has somewhere to point.
 */

const EMPTY_FORM = { type: "", clinician: "", datetime: "", resultsDue: "", prep: "" };

export function AppointmentsScreen() {
  const t = useTranslations("appointments");
  const format = useFormatter();
  const today = todayISO();

  const [form, setForm] = useState(EMPTY_FORM);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [open, setOpen] = useState(false);

  const query = useSupabaseQuery(async (supabase) => {
    const rows = await unwrap(
      supabase
        .from("appointments")
        .select("id, clinician, type, datetime, prep_json, results_due")
        .order("datetime", { ascending: true }),
    );
    return ((rows ?? []) as Record<string, unknown>[]).map(
      (r): Appointment => ({
        id: r.id as string,
        clinician: (r.clinician as string | null) ?? null,
        type: (r.type as string | null) ?? null,
        datetime: (r.datetime as string | null) ?? null,
        prep: Array.isArray(r.prep_json) ? (r.prep_json as string[]) : [],
        resultsDue: (r.results_due as string | null) ?? null,
      }),
    );
  });

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

    const prep = parsePrep(form.prep);
    const { error: insertError } = await supabase.from("appointments").insert({
      profile_id: session.user.id,
      // Every field is optional in the schema and stays optional here. She may be
      // writing down "the scan, sometime in March" and that is a real note.
      type: form.type.trim() || null,
      clinician: form.clinician.trim() || null,
      datetime: form.datetime ? new Date(form.datetime).toISOString() : null,
      results_due: form.resultsDue || null,
      prep_json: prep.length > 0 ? prep : null,
    });

    setSaving(false);
    if (insertError) {
      setError(t("saveFailed"));
      return;
    }
    setForm(EMPTY_FORM);
    setOpen(false);
    query.refresh();
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

  const { upcoming, past } = splitAppointments(query.data, today);
  const chase = awaitingResults(query.data, today);

  const when = (appointment: Appointment) => {
    if (!appointment.datetime) return t("noDate");
    return format.dateTime(new Date(appointment.datetime), {
      dateStyle: "medium",
      timeStyle: "short",
    });
  };

  const countdown = (appointment: Appointment) => {
    const days = daysUntil(appointment, today);
    if (days === null || days < 0) return null;
    if (days === 0) return t("todayLabel");
    return t("inDays", { days });
  };

  const row = (appointment: Appointment) => (
    <Card key={appointment.id}>
      <CardContent className="flex flex-col gap-2 p-5">
        <div className="flex flex-wrap items-baseline justify-between gap-x-3 gap-y-1">
          <p className="font-display text-md text-text">{appointment.type || t("untitled")}</p>
          <p className="text-sm text-text-muted">{when(appointment)}</p>
        </div>
        {appointment.clinician ? (
          <p className="text-sm text-text-muted">{appointment.clinician}</p>
        ) : null}
        {countdown(appointment) ? (
          <p className="text-sm text-primary">{countdown(appointment)}</p>
        ) : null}
        {appointment.prep.length > 0 ? (
          <div className="flex flex-col gap-1">
            <p className="text-2xs font-semibold uppercase tracking-wider text-text-muted">
              {t("prepHeading")}
            </p>
            <ul className="list-disc ps-5 text-sm text-text">
              {appointment.prep.map((question, index) => (
                <li key={`${appointment.id}-${index}`}>{question}</li>
              ))}
            </ul>
          </div>
        ) : null}
      </CardContent>
    </Card>
  );

  return (
    <AppScreen>
      <div className="flex flex-wrap items-center justify-between gap-3">
        <h1 className="font-display text-lg text-text">{t("title")}</h1>
        <Button variant={open ? "outline" : "accent"} onClick={() => setOpen(!open)}>
          {open ? t("cancel") : t("add")}
        </Button>
      </div>

      {/* Said once, at the top, rather than implied by an absent field: Femio holds
          when and what you wanted to ask. It does not hold what they found. */}
      <p className="text-2xs leading-relaxed text-text-subtle">{t("noResultsNote")}</p>

      {open ? (
        <Card>
          <CardContent className="flex flex-col gap-4 p-5">
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="appointment-type">{t("form.type")}</Label>
              <Input
                id="appointment-type"
                value={form.type}
                placeholder={t("form.typePlaceholder")}
                onChange={(e) => setForm({ ...form, type: e.target.value })}
              />
            </div>
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="appointment-clinician">{t("form.clinician")}</Label>
              <Input
                id="appointment-clinician"
                value={form.clinician}
                onChange={(e) => setForm({ ...form, clinician: e.target.value })}
              />
            </div>
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="appointment-datetime">{t("form.datetime")}</Label>
              <Input
                id="appointment-datetime"
                type="datetime-local"
                value={form.datetime}
                onChange={(e) => setForm({ ...form, datetime: e.target.value })}
              />
            </div>
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="appointment-results">{t("form.resultsDue")}</Label>
              <Input
                id="appointment-results"
                type="date"
                value={form.resultsDue}
                onChange={(e) => setForm({ ...form, resultsDue: e.target.value })}
              />
              <p className="text-2xs text-text-subtle">{t("form.resultsDueHint")}</p>
            </div>
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="appointment-prep">{t("form.prep")}</Label>
              <textarea
                id="appointment-prep"
                rows={4}
                value={form.prep}
                placeholder={t("form.prepPlaceholder")}
                onChange={(e) => setForm({ ...form, prep: e.target.value })}
                className="min-h-24 w-full rounded-md border border-border bg-surface p-3 text-sm text-text"
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

      {/* A result she was told to expect that has not arrived. Deliberately an
          `info` alert and deliberately worded as a question to ask a human — a
          result can be late for a dozen ordinary reasons, and making a calendar
          feel clinical is exactly the invention product rule 1 forbids. */}
      {chase.length > 0 ? (
        <Alert variant="info">
          <AlertDescription className="flex flex-col gap-1">
            <span className="font-medium">{t("awaiting.heading")}</span>
            <span>{t("awaiting.body", { count: chase.length })}</span>
          </AlertDescription>
        </Alert>
      ) : null}

      {upcoming.length === 0 && past.length === 0 ? (
        <Card>
          <CardContent className="flex flex-col gap-2 p-6">
            <p className="font-display text-md text-text">{t("empty.heading")}</p>
            <p className="text-sm text-text-muted">{t("empty.body")}</p>
          </CardContent>
        </Card>
      ) : null}

      {upcoming.length > 0 ? (
        <section className="flex flex-col gap-3">
          <h2 className="text-md font-semibold text-text">{t("upcomingHeading")}</h2>
          {upcoming.map(row)}
        </section>
      ) : null}

      {past.length > 0 ? (
        <section className="flex flex-col gap-3">
          <h2 className="text-md font-semibold text-text">{t("pastHeading")}</h2>
          {past.map(row)}
        </section>
      ) : null}
    </AppScreen>
  );
}
