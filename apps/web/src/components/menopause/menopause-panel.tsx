"use client";

import { useFormatter, useTranslations } from "next-intl";
import { cycleVariability, sinceLastPeriod, MENOPAUSE_SYMPTOMS } from "@/lib/menopause";
import { Badge } from "@/components/ui/badge";
import { HeroCard } from "@/components/ui/hero-card";
import { Card, CardContent } from "@/components/ui/card";
import { MrsCheck } from "./mrs-check";
import { ExperienceModules } from "@/components/experience/module-registry";
import type { ExperienceConfig } from "@/lib/experience/types";
import { ReadingList } from "@/components/experience/reading-list";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Link } from "@/i18n/navigation";

/**
 * The perimenopause / menopause dashboard (P1.13c).
 *
 * Replaces the "coming soon" card that this mode shared with pregnancy until today.
 *
 * The whole design question here is what Femio is allowed to say. The clinical
 * convention is twelve consecutive months without a period *with no other cause*, and
 * that last clause is the reason this screen reports a count and stops. Pregnancy,
 * thyroid disease, some medicines and several other things also stop periods; deciding
 * which applies is diagnosis, and diagnosis is outside what Femio is (product rule 1).
 *
 * So: the arithmetic is ours, the conclusion is hers and her clinician's. The count is
 * shown plainly, the convention is named as a convention, and the next step offered is a
 * conversation rather than a verdict.
 *
 * Was a server component — it renders text from dates, so there was nothing for the
 * browser to do. Now a client component, because a server one cannot run in a Capacitor
 * bundle and this screen has to ship to iOS/Android (P4.0, ADR-048).
 */
/**
 * Track F's screen. **Rendered from the served document since R1.9e** — the last
 * hand-written dashboard in the product.
 *
 * The composition below is unchanged; what changed is who orders it. F1 and F2 are
 * siblings rather than layers (`build.ts` has no path that subtracts a module), so
 * F2 — a year past her last period — simply does not contribute `menopause.trend`,
 * and the cycle view disappears because her persona stopped asking for it rather
 * than because this file checks how long it has been.
 *
 * The document is optional: with none, every node still renders in its old order.
 * A woman must not lose the twelve-month count because an Edge Function was
 * unreachable.
 */
export function MenopausePanel({
  starts,
  symptomCounts,
  today,
  config,
}: {
  starts: string[];
  symptomCounts: { type: string; count: number }[];
  today: string;
  config?: ExperienceConfig | null;
}) {
  const t = useTranslations("menopause");
  const st = useTranslations("symptoms");
  // The three link cards below live in `dashboard` because they are the same
  // surfaces Track B offers; duplicating the copy per namespace is how two screens
  // come to say slightly different things about privacy.
  const tDash = useTranslations("dashboard");
  const stItem = st as unknown as (key: string) => string;
  const format = useFormatter();

  const lastStart = starts.length > 0 ? [...starts].sort().at(-1)! : null;
  const since = sinceLastPeriod(lastStart, today);
  const variability = cycleVariability(starts);

  const relevant = symptomCounts
    .filter((s) => (MENOPAUSE_SYMPTOMS as readonly string[]).includes(s.type))
    .slice(0, 6);

  const fmt = (iso: string) =>
    format.dateTime(new Date(`${iso}T00:00:00Z`), { dateStyle: "medium", timeZone: "UTC" });

  const sinceNode = (
    <>
    {/* Deliberately **no band here**, and this is the one place in the app where
        leaving the visual out is the decision rather than the omission. A bar
        filling toward the twelve-month mark would read as a countdown to
        menopause, and the convention includes "with no other cause" — periods
        also stop for pregnancy, thyroid changes and some medicines. Drawing
        progress toward a conclusion Femio is not allowed to reach would turn
        arithmetic into a diagnosis (product rule 1, ADR-043). The number is the
        number; the marker is named as a convention and nothing points at it. */}
    {since ? (
      <HeroCard
        tone="brand"
        eyebrow={t("lastLogged", { date: fmt(lastStart!) })}
        headline={
          since.months < 1
            ? t("sinceDays", { days: since.days })
            : t("sinceMonths", { months: since.months })
        }
        footnote={since.pastConventionalMarker ? t("markerPassed") : t("markerAhead")}
      />
    ) : (
      <Card>
        <CardContent className="flex flex-col gap-3 p-6">
          <h2 className="font-display text-lg text-text">{t("empty.heading")}</h2>
          <p className="text-sm text-text-muted">{t("empty.body")}</p>
        </CardContent>
      </Card>
    )}
    </>
  );

  const markerNode = (
    <>
    {/* Below the hero rather than inside it: four lines of white-on-violet is not
        how you present the most important qualification on the screen. */}
    {since ? (
      <Card>
        <CardContent className="p-6">
          <p className="text-sm text-text-muted">{t("notDiagnosis")}</p>
        </CardContent>
      </Card>
    ) : null}
    </>
  );

  const trendNode = (
    <>
    {variability ? (
      <Card>
        <CardContent className="flex flex-col gap-1 p-6">
          <p className="text-sm text-text-muted">{t("variability.heading")}</p>
          <p className="font-display text-lg text-text">
            {t("variability.range", { shortest: variability.shortest, longest: variability.longest })}
          </p>
          <p className="text-sm text-text-muted">
            {variability.irregular ? t("variability.irregular") : t("variability.steady")}
          </p>
        </CardContent>
      </Card>
    ) : null}
    </>
  );

  const stripNode = (
    <>
    {relevant.length > 0 ? (
      <section className="flex flex-col gap-2">
        <h2 className="text-md font-semibold text-text">{t("symptoms.heading")}</h2>
        <div className="flex flex-wrap gap-2">
          {relevant.map((s) => (
            <Badge key={s.type} variant="primary">
              {stItem(`items.${s.type}`)} · {s.count}
            </Badge>
          ))}
        </div>
        <p className="text-sm text-text-subtle">{t("symptoms.note")}</p>
      </section>
    ) : null}
    </>
  );

  /**
   * The reading card, driven by F1/F2's own `content.foreground` (P2.3c's
   * mechanism) rather than the four fixed links it replaces. F2 foregrounds
   * `postmenopausal-bleeding`, which R2.9b wrote — so the page behind the only red
   * flag in this track reaches her from her own shelf.
   */
  const readingNode = (
    <ReadingList
      foreground={config?.content.foreground ?? []}
      heading={t("reading.heading")}
      pending={t("empty.body")}
    />
  );

  /**
   * The only red flag in Track F, and the last one in the product to get a surface
   * (R1.9f). The alert has been in F2's document since R2.9 and the article behind
   * it since R2.9b, and between them sat nothing on screen: a woman who logged a
   * bleed a year after her last period had the finding in her config and no panel.
   *
   * **It is standing, not conditional.** F2 §G shows it every time rather than
   * after the fact, because a woman who has not bled yet is exactly who needs to
   * know what to do if she does — and because a box that appears only once
   * something has happened tells her something has happened.
   *
   * Says nothing about what a bleed means. No triage, no reassurance in place of
   * routing, and **no phone number** (P1.26.1): the whole message is that any bleed
   * after twelve months is checked promptly, however small.
   */
  const pmbNode = (
    <Alert variant="danger">
      <AlertDescription className="flex flex-col gap-2">
        <span className="font-medium">{t("pmb.heading")}</span>
        <span>{t("pmb.body")}</span>
        <Link href="/learn/postmenopausal-bleeding" className="underline">
          {t("pmb.cta")}
        </Link>
      </AlertDescription>
    </Alert>
  );

  const td = tDash;

  const linkCard = (key: "longTerm" | "medications" | "gsm", href: string) => (
    <Card>
      <CardContent className="flex flex-col gap-2 p-6">
        <h2 className="font-display text-lg text-text">{td(`${key}.heading`)}</h2>
        <p className="text-sm text-text-muted">{td(`${key}.body`)}</p>
        <Link href={href} className="text-sm text-text-link underline">
          {td(`${key}.cta`)}
        </Link>
      </CardContent>
    </Card>
  );

  const nodes = {
    menopauseSince: sinceNode,
    menopausePmb: pmbNode,
    /**
     * F2 §F 4–5. **Awareness, never risk-scoring** — the specs are explicit, and a
     * calculated number here would be a clinical assessment wearing a progress bar.
     * It says the two things that change after menopause and points at a clinician.
     */
    menopauseLongTerm: linkCard("longTerm", "/learn/menopause-care-options"),
    /** One list for everything she takes: no dosing, no adherence score (P2.4). */
    medications: linkCard("medications", "/medications"),
    /**
     * F6 §I. Genitourinary symptoms are common, treatable, and the thing least
     * likely to be raised in a ten-minute appointment. **Femio raises it once, in a
     * card she can ignore** — it is never inferred from her symptom log and never
     * reskins her home screen, because a product that reacted to two dryness
     * entries would be announcing her intimate symptoms on her own phone (R2.9a).
     */
    gsm: linkCard("gsm", "/learn/menopause-care-options"),
    menopauseMarker: markerNode,
    menopauseTrend: trendNode,
    menopauseSymptomStrip: stripNode,
    mrs: <MrsCheck />,
    reading: readingNode,
    warningSigns: null,
    movement: null,
    pregnancyHero: null,
  };

  // Mounted from the served document rather than from `mode === "menopause"`
  // (R3.1.6a) — the same swap the other three life-stage screens make.
  if (config?.track !== "F") return null;

  // No modules — offline with an empty cache, or a persona the registry has not
  // met. Everything still renders, in the order it always did.
  if (config.home.modules.length === 0) {
    return (
      <div className="flex flex-col gap-4">
        {sinceNode}
        {/* Kept in the no-document path deliberately: the red flag is the one thing
            that must not disappear with the engine, for the same reason the
            postpartum screen keeps its warning signs. */}
        {pmbNode}
        {markerNode}
        {trendNode}
        {stripNode}
        {readingNode}
        <MrsCheck />
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-4">
      <ExperienceModules ctx={{ config, ...nodes }} />
    </div>
  );
}
