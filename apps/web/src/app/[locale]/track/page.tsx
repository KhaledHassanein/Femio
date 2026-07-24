import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { getFormatter, getTranslations, setRequestLocale } from "next-intl/server";
import { createClient } from "@/lib/supabase/server";
import { predictNextPeriod } from "@/lib/cycle/predict";
import { SYMPTOM_GROUPS } from "@/lib/cycle/symptoms";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { LogPeriod } from "@/components/cycle/log-period";
import { LogSymptoms } from "@/components/cycle/log-symptoms";

const KNOWN_SYMPTOMS = new Set<string>(SYMPTOM_GROUPS.flatMap((g) => g.symptoms));

type PageProps = { params: Promise<{ locale: string }> };

// Auth-gated + personal data → never cached/prerendered.
export const dynamic = "force-dynamic";

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "track" });
  return { title: t("title"), robots: { index: false, follow: false } };
}

export default async function TrackPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect(`/${locale}/welcome`);

  const { data: cycles } = await supabase
    .from("cycles")
    .select("id, period_start")
    .order("period_start", { ascending: false });

  const { data: symptoms } = await supabase
    .from("symptom_logs")
    .select("id, type, logged_at")
    .order("logged_at", { ascending: false })
    .limit(24);

  const t = await getTranslations("track");
  const st = await getTranslations("symptoms");
  // type comes from the DB (string); membership is validated at runtime, so the
  // key cast is safe. Cast st to a plain string lookup for the dynamic key.
  const stItem = st as unknown as (key: string) => string;
  const symptomLabel = (type: string) =>
    KNOWN_SYMPTOMS.has(type) ? stItem(`items.${type}`) : type;
  const format = await getFormatter();
  const fmt = (iso: string) =>
    format.dateTime(new Date(`${iso}T00:00:00Z`), { dateStyle: "medium", timeZone: "UTC" });

  const starts = (cycles ?? []).map((c) => c.period_start as string);
  const prediction = predictNextPeriod(starts);

  const confidenceText = prediction
    ? prediction.confidence === "high"
      ? t("prediction.confidenceHigh", { count: prediction.cyclesAnalyzed })
      : prediction.confidence === "medium"
        ? t("prediction.confidenceMedium", { count: prediction.cyclesAnalyzed })
        : t("prediction.confidenceLow")
    : null;

  return (
    <main className="mx-auto flex w-full max-w-2xl flex-col gap-6 px-6 py-12">
      <h1 className="font-display text-2xl text-text">{t("title")}</h1>

      <section>
        <h2 className="mb-2 text-md font-semibold text-text">{t("prediction.heading")}</h2>
        {prediction ? (
          <div className="flex flex-col gap-2 rounded-md border border-dashed border-border bg-surface-sunken p-4">
            <p className="font-display text-lg text-text">
              {t("prediction.window", { start: fmt(prediction.windowStart), end: fmt(prediction.windowEnd) })}
            </p>
            <p className="text-sm text-text-muted">
              {t("prediction.averageLength", { days: prediction.averageLength })}
            </p>
            <p className="text-sm text-text-muted">{confidenceText}</p>
            {prediction.irregular ? (
              <p className="text-sm text-warning-text">{t("prediction.irregularNote")}</p>
            ) : null}
          </div>
        ) : (
          <p className="text-sm text-text-muted">{t("prediction.needMore")}</p>
        )}
      </section>

      <LogPeriod />

      <LogSymptoms />

      <section className="flex flex-col gap-3">
        <h2 className="text-md font-semibold text-text">{st("recentHeading")}</h2>
        {symptoms && symptoms.length > 0 ? (
          <div className="flex flex-wrap gap-2">
            {symptoms.map((s) => (
              <Badge key={s.id as string} variant="primary">
                {symptomLabel(s.type as string)}
              </Badge>
            ))}
          </div>
        ) : (
          <p className="text-sm text-text-muted">{st("recentEmpty")}</p>
        )}
      </section>

      <section className="flex flex-col gap-3">
        <h2 className="text-md font-semibold text-text">{t("history.heading")}</h2>
        {starts.length > 0 ? (
          <ul className="flex flex-col">
            {starts.map((iso, i) => (
              <li key={`${iso}-${i}`} className="flex flex-col">
                <span className="py-2 text-sm text-text">{fmt(iso)}</span>
                {i < starts.length - 1 ? <Separator /> : null}
              </li>
            ))}
          </ul>
        ) : (
          <p className="text-sm text-text-muted">{t("history.empty")}</p>
        )}
      </section>
    </main>
  );
}
