import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { getFormatter, getTranslations, setRequestLocale } from "next-intl/server";
import { createClient } from "@/lib/supabase/server";
import { fertileWindow } from "@/lib/calculators";
import { todayISO } from "@/lib/calculators/dates";
import { predictNextPeriod } from "@/lib/cycle/predict";
import { currentCycleDay, topSymptoms } from "@/lib/cycle/insights";
import { SYMPTOM_GROUPS } from "@/lib/cycle/symptoms";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Link } from "@/i18n/navigation";
import { PregnancyPanel } from "@/components/pregnancy/pregnancy-panel";
import { MenopausePanel } from "@/components/menopause/menopause-panel";

type PageProps = { params: Promise<{ locale: string }> };

export const dynamic = "force-dynamic";

const KNOWN_SYMPTOMS = new Set<string>(SYMPTOM_GROUPS.flatMap((g) => g.symptoms));
type Mode = "cycle" | "ttc" | "pregnancy" | "menopause";
const TRACK_TO_MODE: Record<string, Mode> = { B: "cycle", C: "ttc", D: "pregnancy", F: "menopause" };

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "dashboard" });
  return { title: t("title"), robots: { index: false, follow: false } };
}

export default async function DashboardPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect(`/${locale}/welcome`);

  const [{ data: state }, { data: cycles }, { data: symptoms }] = await Promise.all([
    supabase.from("persona_state").select("track").maybeSingle(),
    supabase.from("cycles").select("period_start").order("period_start", { ascending: false }),
    supabase.from("symptom_logs").select("type").order("logged_at", { ascending: false }).limit(200),
  ]);

  // Only the pregnancy dashboard needs this, and only one pregnancy is active at a time.
  const { data: pregnancy } =
    TRACK_TO_MODE[(state?.track as string) ?? "B"] === "pregnancy"
      ? await supabase.from("pregnancy").select("edd").eq("status", "active").maybeSingle()
      : { data: null };

  const mode = TRACK_TO_MODE[(state?.track as string) ?? "B"] ?? "cycle";
  const starts = (cycles ?? []).map((c) => c.period_start as string);
  const today = todayISO();
  const prediction = predictNextPeriod(starts);
  const cycleDay = currentCycleDay(starts, today);
  const top = topSymptoms((symptoms ?? []).map((s) => s.type as string));
  const lastStart = starts.length > 0 ? [...starts].sort().at(-1)! : null;
  const fertile =
    mode === "ttc" && lastStart ? fertileWindow(lastStart, prediction?.averageLength ?? 28) : null;

  const t = await getTranslations("dashboard");
  const st = await getTranslations("symptoms");
  const stItem = st as unknown as (key: string) => string;
  const symptomLabel = (type: string) =>
    KNOWN_SYMPTOMS.has(type) ? stItem(`items.${type}`) : type;
  const format = await getFormatter();
  const fmt = (iso: string) =>
    format.dateTime(new Date(`${iso}T00:00:00Z`), { dateStyle: "medium", timeZone: "UTC" });

  return (
    <main className="mx-auto flex w-full max-w-2xl flex-col gap-6 px-6 py-12">
      <div className="flex items-center justify-between gap-3">
        <div className="flex flex-col gap-1">
          <h1 className="font-display text-2xl text-text">{t("title")}</h1>
          <p className="text-sm text-text-muted">{t(`modeLabel.${mode}`)}</p>
        </div>
        <Button asChild variant="accent">
          <Link href="/track">{t("logCta")}</Link>
        </Button>
      </div>

      {/* Pregnancy gets its own dashboard rather than cycle tools plus an apology.
          A cycle-day counter and a next-period prediction are meaningless to someone
          who is pregnant, and the second one is alarming (P1.13b). */}
      {mode === "pregnancy" ? <PregnancyPanel edd={pregnancy?.edd ?? null} today={today} /> : null}

      {/* Perimenopause/menopause gets its own view too: a next-period prediction is
          the least useful thing to show someone whose cycles are stopping (P1.13c). */}
      {mode === "menopause" ? (
        <MenopausePanel starts={starts} symptomCounts={top} today={today} />
      ) : null}

      {mode === "pregnancy" || mode === "menopause" ? null : (
      <div className="grid gap-4 sm:grid-cols-2">
        <Card>
          <CardContent className="flex min-h-24 flex-col justify-center p-6">
            {cycleDay ? (
              <p className="font-display text-xl text-text">{t("cycleDay", { day: cycleDay })}</p>
            ) : (
              <p className="text-sm text-text-muted">{t("cycleDayUnknown")}</p>
            )}
          </CardContent>
        </Card>

        <Card>
          <CardContent className="flex min-h-24 flex-col gap-1 p-6">
            <p className="text-sm text-text-muted">{t("nextPeriod")}</p>
            {prediction ? (
              <>
                <p className="font-display text-lg text-text">
                  {t("window", { start: fmt(prediction.windowStart), end: fmt(prediction.windowEnd) })}
                </p>
                <p className="text-sm text-text-muted">
                  {t("avgLength", { days: prediction.averageLength })}
                </p>
                {prediction.irregular ? (
                  <p className="text-sm text-warning-text">{t("irregularNote")}</p>
                ) : null}
              </>
            ) : (
              <p className="text-sm text-text-muted">{t("needData")}</p>
            )}
          </CardContent>
        </Card>
      </div>
      )}

      {fertile ? (
        <Card>
          <CardContent className="flex flex-col gap-1 p-6">
            <p className="text-sm text-text-muted">{t("fertileHeading")}</p>
            <p className="font-display text-lg text-text">
              {t("fertileWindow", { start: fmt(fertile.windowStart), end: fmt(fertile.windowEnd) })}
            </p>
          </CardContent>
        </Card>
      ) : null}

      {top.length > 0 && mode !== "menopause" ? (
        <section className="flex flex-col gap-2">
          <h2 className="text-md font-semibold text-text">{t("topSymptomsHeading")}</h2>
          <div className="flex flex-wrap gap-2">
            {top.map((s) => (
              <Badge key={s.type} variant="primary">
                {symptomLabel(s.type)} · {s.count}
              </Badge>
            ))}
          </div>
        </section>
      ) : null}
    </main>
  );
}
