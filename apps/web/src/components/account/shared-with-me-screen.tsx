"use client";

import { useEffect, useState } from "react";
import { useFormatter, useTranslations } from "next-intl";
import { todayISO } from "@/lib/calculators/dates";
import { KNOWN_SYMPTOMS } from "@/lib/cycle/symptoms";
import { readSharedWithMe, type PartnerShareView } from "@/lib/partner/actions";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Card, CardContent } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { AppScreen } from "@/components/patterns/app-screen";

/**
 * What someone has chosen to share with you (Phase 4.5).
 *
 * This screen is the one the design's §3 is about, and every decision in it is
 * that section: **it renders only what is present in the payload.** There is no
 * list of categories to iterate, no "not shared" row, no locked card, no greyed
 * section and no count of how many of seven she picked. If she shared her next
 * period and nothing else, this page is a page about a next period — identical to
 * what it would be if Femio had no symptom log, no medicines list and no charting
 * at all.
 *
 * That is not a styling preference. Granular sharing that *displays* its own gaps
 * produces a map of what she chose to conceal, which is more dangerous than
 * sharing everything: it turns each withheld category into a question she now has
 * to answer. It is also invisible in a screenshot, which is why it is written here
 * rather than left to review.
 *
 * The same reasoning governs the empty state. A share that was revoked, one that
 * expired, and one that never existed all render the identical sentence, because a
 * revocation he can detect is one she may not feel safe making (§2).
 *
 * ## Nothing here is interpreted
 *
 * Dates, a phase name, week numbers, a list of symptom names. No trend, no "she
 * seems", no advice about what to do with any of it. Femio does not tell a partner
 * what his partner's data means, and there is no field in the payload that could.
 */
export function SharedWithMeScreen() {
  const t = useTranslations("partnerShared");
  const ts = useTranslations("symptoms");
  const tPhase = useTranslations("phaseStrip");
  const format = useFormatter();
  const today = todayISO();

  const [state, setState] = useState<
    { status: "loading" } | { status: "ready"; shares: PartnerShareView[] } | { status: "error" }
  >({ status: "loading" });

  useEffect(() => {
    let active = true;
    readSharedWithMe(today).then((res) => {
      if (!active) return;
      setState(res.ok ? { status: "ready", shares: res.shares } : { status: "error" });
    });
    return () => {
      active = false;
    };
  }, [today]);

  const fmtDay = (iso: string) =>
    format.dateTime(new Date(`${iso.slice(0, 10)}T00:00:00Z`), {
      day: "numeric",
      month: "short",
      timeZone: "UTC",
    });
  const fmtDate = (iso: string) =>
    format.dateTime(new Date(iso), { day: "numeric", month: "long", year: "numeric" });

  const symptomLabel = (type: string) => (KNOWN_SYMPTOMS.has(type) ? ts(`items.${type}`) : type);

  if (state.status === "loading") {
    return (
      <AppScreen busy>
        <h1 className="font-display text-lg text-text">{t("title")}</h1>
        <Skeleton className="h-28 w-full" />
      </AppScreen>
    );
  }

  /**
   * A failed read says so. There is no local fallback and there must not be one:
   * the client is not entitled to her rows, so "we could not load it" is the only
   * honest answer — and rendering the empty state instead would tell him she had
   * stopped sharing when she had not, which is a lie in the direction that starts
   * an argument (ADR-046, applied to someone else's record).
   */
  if (state.status === "error") {
    return (
      <AppScreen>
        <h1 className="font-display text-lg text-text">{t("title")}</h1>
        <Alert variant="danger">
          <AlertDescription>{t("loadError")}</AlertDescription>
        </Alert>
      </AppScreen>
    );
  }

  if (state.shares.length === 0) {
    return (
      <AppScreen>
        <h1 className="font-display text-lg text-text">{t("title")}</h1>
        <p className="text-sm text-text-muted">{t("none")}</p>
      </AppScreen>
    );
  }

  return (
    <AppScreen>
      <div className="flex flex-col gap-1">
        <h1 className="font-display text-lg text-text">{t("title")}</h1>
        <p className="text-sm text-text-muted">{t("intro")}</p>
      </div>

      {state.shares.map((share) => (
        <div key={share.id} className="flex flex-col gap-4">
          {"nextPeriod" in share ? (
            <Card>
              <CardContent className="flex flex-col gap-2 p-6">
                <h2 className="font-display text-lg text-text">{t("nextPeriod.heading")}</h2>
                {share.nextPeriod ? (
                  <>
                    <p className="text-sm text-text">
                      {t("nextPeriod.window", {
                        start: fmtDay(share.nextPeriod.windowStart),
                        end: fmtDay(share.nextPeriod.windowEnd),
                      })}
                    </p>
                    {/* The same uncertainty her own screen carries. A window shown
                        to someone else without it becomes a promise she never made. */}
                    <p className="text-xs text-text-muted">
                      {share.nextPeriod.irregular
                        ? t("nextPeriod.irregular")
                        : t(`nextPeriod.confidence.${share.nextPeriod.confidence}`)}
                    </p>
                  </>
                ) : (
                  <p className="text-sm text-text-muted">{t("nextPeriod.notYet")}</p>
                )}
              </CardContent>
            </Card>
          ) : null}

          {share.phase ? (
            <Card>
              <CardContent className="flex flex-col gap-2 p-6">
                <h2 className="font-display text-lg text-text">{t("phase.heading")}</h2>
                {/* `null` is a real answer — an irregular or very short cycle gets
                    no phase name, here exactly as on her own dashboard (ADR-066). */}
                <p className="text-sm text-text">
                  {share.phase.phase
                    ? tPhase(`phase.${share.phase.phase}`)
                    : t("phase.unknown")}
                </p>
                {share.phase.cycleDay ? (
                  <p className="text-xs text-text-muted">
                    {t("phase.day", { day: share.phase.cycleDay })}
                  </p>
                ) : null}
              </CardContent>
            </Card>
          ) : null}

          {share.cycleDates ? (
            <Card>
              <CardContent className="flex flex-col gap-2 p-6">
                <h2 className="font-display text-lg text-text">{t("cycleDates.heading")}</h2>
                <ul className="flex flex-col gap-0.5">
                  {share.cycleDates.map((d) => (
                    <li key={d} className="text-sm text-text-muted">
                      {fmtDay(d)}
                    </li>
                  ))}
                </ul>
              </CardContent>
            </Card>
          ) : null}

          {"pregnancy" in share ? (
            <Card>
              <CardContent className="flex flex-col gap-2 p-6">
                <h2 className="font-display text-lg text-text">{t("pregnancy.heading")}</h2>
                {share.pregnancy ? (
                  <p className="text-sm text-text">
                    {t("pregnancy.weeks", {
                      weeks: share.pregnancy.weeks,
                      days: share.pregnancy.days,
                    })}
                  </p>
                ) : (
                  <p className="text-sm text-text-muted">{t("pregnancy.none")}</p>
                )}
              </CardContent>
            </Card>
          ) : null}

          {share.symptoms ? (
            <Card>
              <CardContent className="flex flex-col gap-2 p-6">
                <h2 className="font-display text-lg text-text">{t("symptoms.heading")}</h2>
                {share.symptoms.length === 0 ? (
                  <p className="text-sm text-text-muted">{t("symptoms.none")}</p>
                ) : (
                  <ul className="flex flex-col gap-0.5">
                    {share.symptoms.slice(0, 20).map((s, i) => (
                      <li key={`${s.type}-${s.loggedAt}-${i}`} className="text-sm text-text-muted">
                        {t("symptoms.row", {
                          name: symptomLabel(s.type),
                          date: fmtDay(s.loggedAt),
                        })}
                      </li>
                    ))}
                  </ul>
                )}
                {/* Names and dates. No severity: how bad a day was is hers to say
                    in her own words, not a number for someone else to read. */}
                <p className="text-xs text-text-subtle">{t("symptoms.note")}</p>
              </CardContent>
            </Card>
          ) : null}

          {share.medications ? (
            <Card>
              <CardContent className="flex flex-col gap-2 p-6">
                <h2 className="font-display text-lg text-text">{t("medications.heading")}</h2>
                {share.medications.length === 0 ? (
                  <p className="text-sm text-text-muted">{t("medications.none")}</p>
                ) : (
                  <ul className="flex flex-col gap-0.5">
                    {share.medications.map((name) => (
                      <li key={name} className="text-sm text-text-muted">
                        {name}
                      </li>
                    ))}
                  </ul>
                )}
                {/* Names only — never a dose. The medicines screen refuses to hold
                    an opinion about how much of something she takes (P2.4); a
                    partner's copy of it must refuse the same thing. */}
                <p className="text-xs text-text-subtle">{t("medications.note")}</p>
              </CardContent>
            </Card>
          ) : null}

          {share.fertility ? (
            <Card>
              <CardContent className="flex flex-col gap-2 p-6">
                <h2 className="font-display text-lg text-text">{t("fertility.heading")}</h2>
                {share.fertility.length === 0 ? (
                  <p className="text-sm text-text-muted">{t("fertility.none")}</p>
                ) : (
                  <ul className="flex flex-col gap-0.5">
                    {share.fertility.slice(0, 20).map((f, i) => (
                      <li key={`${f.loggedAt}-${i}`} className="text-sm text-text-muted">
                        {f.opk
                          ? t("fertility.rowWithTest", { date: fmtDay(f.loggedAt), result: f.opk })
                          : t("fertility.row", { date: fmtDay(f.loggedAt) })}
                      </li>
                    ))}
                  </ul>
                )}
                {/* Awareness, never a boundary. `lib/fertility` has no `isFertile`
                    and this screen has no fertile-day marker, for the reason
                    product rule 1 exists. */}
                <p className="text-xs text-text-subtle">{t("fertility.note")}</p>
              </CardContent>
            </Card>
          ) : null}

          <p className="text-xs text-text-subtle">
            {t("until", { date: fmtDate(share.expiresAt) })}
          </p>
        </div>
      ))}
    </AppScreen>
  );
}
