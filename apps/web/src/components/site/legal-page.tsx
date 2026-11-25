import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { TrustPage, type TrustPoint } from "@/components/site/trust-page";
import { LEGAL_EDITIONS, LEGAL_VALUES } from "@/lib/legal/placeholders";
import { localizedAlternates } from "@/lib/seo/metadata";

/**
 * The privacy policy, the terms of use and the consumer health data policy
 * (ADR-080; Washington RCW 19.373.020 asks for that last one as its own page).
 *
 * All three have the same shape in the catalogs (`privacy`, `terms`, `healthData`):
 * title, intro, an effective-date line, optional "in short" box, and a list of
 * heading + body (or heading + bullets) sections. This one component reads either, so
 * the two route files stay a few lines long and cannot drift apart.
 *
 * Company name and mailbox are ICU arguments filled from `LEGAL_VALUES`, and each page's
 * own date and version from `LEGAL_EDITIONS`; an unknown value renders as a highlighted
 * [ENTITY] / [EMAIL] / [DATE] marker.
 */
export type LegalNamespace = keyof typeof LEGAL_EDITIONS;

/** URL path of each legal page (the namespace name is not always the path). */
export const LEGAL_PATHS: Record<LegalNamespace, string> = {
  privacy: "/privacy",
  terms: "/terms",
  healthData: "/consumer-health-data",
};
type Translator = {
  (key: string, values?: Record<string, string>): string;
  raw(key: string): unknown;
  has(key: string): boolean;
};

async function translator(locale: string, namespace: LegalNamespace): Promise<Translator> {
  return (await getTranslations({ locale, namespace })) as unknown as Translator;
}

/** Search metadata. Indexable: these pages are public and linked from the stores. */
export async function legalMetadata(locale: string, namespace: LegalNamespace): Promise<Metadata> {
  const t = await translator(locale, namespace);
  return {
    title: t("title"),
    description: t("intro"),
    alternates: localizedAlternates(locale, LEGAL_PATHS[namespace]),
  };
}

export async function LegalPage({
  locale,
  namespace,
  related,
}: {
  locale: string;
  namespace: LegalNamespace;
  related: { href: string; label: string }[];
}) {
  setRequestLocale(locale);
  const t = await translator(locale, namespace);
  const values = { ...LEGAL_VALUES, ...LEGAL_EDITIONS[namespace] };

  const raw = t.raw("points") as { items?: unknown[] }[];
  const points: TrustPoint[] = raw.map((p, i) => ({
    heading: t(`points.${i}.heading`, values),
    ...(t.has(`points.${i}.body`) ? { body: t(`points.${i}.body`, values) } : {}),
    ...(p.items
      ? {
          items: p.items.map((_, j) => ({
            lead: t(`points.${i}.items.${j}.lead`, values),
            body: t(`points.${i}.items.${j}.body`, values),
          })),
        }
      : {}),
  }));

  const summary = t.has("summary.title")
    ? {
        title: t("summary.title"),
        items: (t.raw("summary.items") as unknown[]).map((_, i) => t(`summary.items.${i}`, values)),
      }
    : undefined;

  return (
    <TrustPage
      title={t("title")}
      intro={t("intro")}
      effective={t("effective", values)}
      summary={summary}
      points={points}
      tocLabel={t("tocLabel")}
      related={related}
    />
  );
}
