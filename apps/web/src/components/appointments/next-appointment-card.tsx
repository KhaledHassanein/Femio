"use client";

import { useFormatter, useTranslations } from "next-intl";
import { useSupabaseQuery, unwrap } from "@/lib/supabase/use-query";
import { todayISO } from "@/lib/calculators/dates";
import { daysUntil, nextAppointment, type Appointment } from "@/lib/appointments";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Link } from "@/i18n/navigation";

/**
 * The `pregnancy.appointments` module (P2.2.3).
 *
 * The registry has emitted this id since R2.1 and it has rendered nothing since,
 * which `module-registry.tsx` named honestly in `UNIMPLEMENTED` rather than letting
 * it vanish. This is the component that retires it from that list.
 *
 * Deliberately a **pointer, not a second screen.** It shows the next appointment
 * and a route to the rest; the list, the form and the prep questions live at
 * `/appointments`, which every mode can reach. Building a fuller panel here would
 * have made appointments a pregnancy feature, and they are not.
 *
 * It reads its own data. The dashboard's query is already six round trips and this
 * module renders for four of the D personas but none of the others, so folding it
 * into the shared query would fetch appointments for everybody to serve some.
 */
export function NextAppointmentCard() {
  const t = useTranslations("appointments");
  const format = useFormatter();
  const today = todayISO();

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

  // A failed read renders the empty invitation rather than an error: this is one
  // card on someone else's screen, and it has no heading of its own to hang
  // "we could not load it" from (ADR-046's distinction, applied downward).
  const next = query.status === "ready" ? nextAppointment(query.data, today) : null;
  const days = next ? daysUntil(next, today) : null;

  return (
    <Card>
      <CardContent className="flex flex-col gap-2 p-5">
        <p className="text-2xs font-semibold uppercase tracking-wider text-text-muted">
          {t("card.eyebrow")}
        </p>
        {next ? (
          <>
            <p className="font-display text-md text-text">{next.type || t("untitled")}</p>
            <p className="text-sm text-text-muted">
              {format.dateTime(new Date(next.datetime!), {
                dateStyle: "medium",
                timeStyle: "short",
              })}
            </p>
            {days !== null && days >= 0 ? (
              <p className="text-sm text-primary">
                {days === 0 ? t("todayLabel") : t("inDays", { days })}
              </p>
            ) : null}
            {next.prep.length > 0 ? (
              <p className="text-sm text-text-muted">
                {t("card.prepCount", { count: next.prep.length })}
              </p>
            ) : null}
          </>
        ) : (
          <p className="text-sm text-text-muted">{t("card.none")}</p>
        )}
        <Button asChild variant="outline" className="w-full">
          <Link href="/appointments">{next ? t("card.all") : t("add")}</Link>
        </Button>
      </CardContent>
    </Card>
  );
}
