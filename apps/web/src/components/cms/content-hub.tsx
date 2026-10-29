import { getTranslations } from "next-intl/server";
import type { ContentDoc } from "@/lib/cms/client";
import { Link } from "@/i18n/navigation";
import { AdSenseScript } from "@/lib/ads/adsense-script";
import { AdUnit } from "@/lib/ads/ad-unit";
import { adUnitConfig, HUB_UNIT_AFTER_CARDS } from "@/lib/ads/placements";
import { env } from "@/lib/env";

// Shared list view for a content collection hub (articles, conditions, …). Carries
// the one hub ad placement (R6.8): a unit after the third card, rendered only when
// the publisher id and the hub slot are set.
export async function ContentHub({
  title,
  subtitle,
  emptyText,
  items,
  hrefBase, // locale-less, e.g. "/conditions"
  lede,
}: {
  title: string;
  subtitle: string;
  emptyText: string;
  items: ContentDoc[];
  hrefBase: string;
  lede: (doc: ContentDoc) => string | null | undefined;
}) {
  const hubAd = adUnitConfig("hub-top");
  const adLabel = hubAd ? (await getTranslations("ads"))("label") : "";
  return (
    <main className="mx-auto flex w-full max-w-3xl flex-col gap-6 px-6 py-12">
      <div className="flex flex-col gap-1">
        <h1 className="font-display text-3xl text-text">{title}</h1>
        <p className="text-sm text-text-muted">{subtitle}</p>
      </div>

      {items.length > 0 ? (
        <ul className="flex flex-col gap-4">
          {items.map((doc, index) => {
            const summary = lede(doc);
            return (
              <li key={doc.id}>
                {hubAd && index === HUB_UNIT_AFTER_CARDS ? (
                  <div className="mb-4">
                    <AdUnit config={hubAd} label={adLabel} />
                  </div>
                ) : null}
                <Link
                  href={`${hrefBase}/${doc.slug}`}
                  className="block rounded-md border border-border p-4 hover:bg-surface-sunken"
                >
                  <h2 className="font-display text-lg text-text">{doc.title}</h2>
                  {summary ? <p className="mt-1 text-sm text-text-muted">{summary}</p> : null}
                </Link>
              </li>
            );
          })}
        </ul>
      ) : (
        <p className="text-sm text-text-muted">{emptyText}</p>
      )}
      {hubAd ? <AdSenseScript client={env.NEXT_PUBLIC_ADSENSE_CLIENT} /> : null}
    </main>
  );
}
