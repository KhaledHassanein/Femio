import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { requireStaff } from "@/lib/auth/require-staff";
import { loadInsights, DIMENSIONS, type Dimension } from "@/lib/insights/queries";
import { K } from "@/lib/insights/k-anon";
import {
  BreakdownTable,
  OverviewTiles,
  RetentionTable,
} from "@/components/admin/insights-panels";
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";
import { Link } from "@/i18n/navigation";

type PageProps = { params: Promise<{ locale: string }> };

export const dynamic = "force-dynamic";

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "insights" });
  return { title: t("title"), robots: { index: false, follow: false } };
}

const OVERVIEW_METRICS = [
  "total_users",
  "onboarded_users",
  "active_28d",
  "registered_users",
  "anonymous_users",
] as const;

/**
 * First-party product insights (P1.20.3) — the dimensions PostHog must never
 * hold. Life-stage mode, persona/condition tag, age band and cohort retention
 * are health inferences (ADR-017), so they are computed here, over our own
 * database, and never leave it un-aggregated: the page reads only the
 * aggregate-only RPCs from migration 0006, every group below k is suppressed in
 * SQL, and the guard is re-applied on the way to the screen.
 */
export default async function InsightsPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  await requireStaff(locale, "admin");

  const t = await getTranslations("insights");
  const data = await loadInsights();

  // Life-stage tracks are single letters in the database (docs/09); everything
  // else is already readable. Looked up rather than `t(key)` so an unmapped or
  // newly-added track renders as itself instead of throwing on a missing key.
  const modeLabels = t.raw("modes") as Record<string, string>;
  const dimensionLabel = (dimension: Dimension) => (bucket: string) => {
    if (bucket === "unset") return t("unset");
    if (dimension === "mode") return modeLabels[bucket] ?? bucket;
    return bucket;
  };

  return (
    <main className="mx-auto flex w-full max-w-3xl flex-col gap-8 px-6 py-12">
      <div className="flex flex-col gap-2">
        <h1 className="font-display text-2xl text-text">{t("title")}</h1>
        <p className="text-sm text-text-muted">{t("desc")}</p>
        <nav className="flex gap-4 text-sm">
          <Link href="/admin/translations" className="text-text-link underline">
            {t("translationsLink")}
          </Link>
        </nav>
      </div>

      <Alert variant="info">
        <AlertTitle>{t("privacy.title")}</AlertTitle>
        <AlertDescription>{t("privacy.body", { k: K })}</AlertDescription>
      </Alert>

      {data.status === "not_installed" ? (
        <Alert variant="warning">
          <AlertTitle>{t("notInstalled.title")}</AlertTitle>
          <AlertDescription>{t("notInstalled.body")}</AlertDescription>
        </Alert>
      ) : data.status === "not_authorized" ? (
        <Alert variant="warning">
          <AlertDescription>{t("notAuthorized")}</AlertDescription>
        </Alert>
      ) : data.status === "error" ? (
        <Alert variant="danger">
          <AlertDescription>{t("error")}</AlertDescription>
        </Alert>
      ) : (
        <>
          <OverviewTiles
            metrics={OVERVIEW_METRICS.map((key) => ({
              key,
              value: data.overview[key] ?? null,
            }))}
          />

          {DIMENSIONS.map((dimension) => (
            <BreakdownTable
              key={dimension}
              title={t(`dimensions.${dimension}.title`)}
              note={t(`dimensions.${dimension}.note`)}
              rows={data.breakdowns[dimension]}
              labelFor={dimensionLabel(dimension)}
            />
          ))}

          <RetentionTable rows={data.retention} locale={locale} />
        </>
      )}
    </main>
  );
}
