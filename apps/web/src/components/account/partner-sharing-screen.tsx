"use client";

import { useEffect, useState } from "react";
import { useFormatter, useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import type { AgeBand } from "@/lib/persona/age";
import {
  EMPTY_SCOPE,
  MAX_RECIPIENT_LABEL,
  SHARE_CATEGORIES,
  formatInviteCode,
  hasAnyCategory,
  type ShareCategory,
  type ShareScope,
} from "@/lib/partner";
import {
  createShare,
  readOwnerShares,
  redeemInvite,
  renewShare,
  revokeShare,
  type OwnerShare,
} from "@/lib/partner/actions";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Skeleton } from "@/components/ui/skeleton";
import { Link } from "@/i18n/navigation";
import { AppScreen } from "@/components/patterns/app-screen";

/**
 * Partner sharing, from her side (Phase 4.5).
 *
 * Design and reasoning: `docs/compliance/PARTNER_SHARING_DESIGN.md`, approved
 * 2026-08-23. Three of its decisions are visible in this file and are the reason
 * it looks the way it does rather than the way a sharing screen usually looks.
 *
 * **There is no "share everything".** Seven checkboxes, all off, and no shortcut
 * that ticks them. A single toggle is the thing a coercive partner asks for, and
 * its convenience to her is worth less than the friction it removes from that
 * conversation. Ticking six boxes is a small cost to her and a real obstacle to
 * the person leaning over her shoulder.
 *
 * **Stopping is one tap and there is no confirmation dialog.** Art. 7(3) says
 * withdrawal must be as easy as granting; granting takes seven decisions and a
 * code, so ending it takes one tap and no "are you sure". A mis-tap costs her a
 * new invite. A confirmation step costs her the seconds in which someone standing
 * over her shoulder can read what she is doing.
 *
 * **The panel is worded as the recipient's view, not her settings.** "What they
 * can see right now", listing the categories in the same plain words the
 * checkboxes use — because the question she actually has is not *which switches
 * are on* but *what are they looking at*.
 */

/** Offered when Femio refuses the grant because it does not know how old she is. */
const ADULT_BANDS: readonly AgeBand[] = ["18_24", "25_34", "35_44", "45_54", "55_plus"];

export function PartnerSharingScreen() {
  const t = useTranslations("partnerSharing");
  const tAge = useTranslations("onboarding.age.bands");
  const tShared = useTranslations("partnerShared");
  const format = useFormatter();

  const [shares, setShares] = useState<OwnerShare[] | null>(null);
  const [scope, setScope] = useState<ShareScope>(EMPTY_SCOPE);
  const [recipient, setRecipient] = useState("");
  const [creating, setCreating] = useState(false);
  const [newCode, setNewCode] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [ageBlocked, setAgeBlocked] = useState(false);
  const [savingAge, setSavingAge] = useState(false);
  const [busyId, setBusyId] = useState<string | null>(null);

  const [redeemValue, setRedeemValue] = useState("");
  const [redeeming, setRedeeming] = useState(false);
  const [redeemError, setRedeemError] = useState<string | null>(null);
  const [redeemed, setRedeemed] = useState(false);

  const refresh = () => {
    void readOwnerShares().then(setShares);
  };

  useEffect(() => {
    let active = true;
    readOwnerShares().then((rows) => {
      if (active) setShares(rows);
    });
    return () => {
      active = false;
    };
  }, []);

  const fmtDate = (iso: string) =>
    format.dateTime(new Date(iso), { day: "numeric", month: "long", year: "numeric" });

  const create = async () => {
    setCreating(true);
    setError(null);
    setNewCode(null);
    const res = await createShare(scope, recipient);
    setCreating(false);
    if (!res.ok) {
      if (res.error === "not_permitted_for_age") setAgeBlocked(true);
      else if (res.error === "recipient_required") setError(t("create.recipientRequired"));
      else setError(t("createError"));
      return;
    }
    setNewCode(res.value);
    setScope(EMPTY_SCOPE);
    setRecipient("");
    refresh();
  };

  /**
   * The same shape `consent-settings.tsx` uses for the analytics gate (R3.0.8):
   * explain, offer the question, and complete the action she was already taking.
   * Hiding the control instead would leave her unable to tell "not offered to me"
   * from "does not exist", and under-18 bands are still refused afterwards — which
   * is correct, and now explained.
   */
  const resolveAge = async (band: AgeBand) => {
    setSavingAge(true);
    const supabase = createClient();
    const { data } = await supabase.auth.getUser();
    if (!data.user) {
      setSavingAge(false);
      return;
    }
    const { error: saveError } = await supabase
      .from("profiles")
      .update({ age_band: band })
      .eq("id", data.user.id);
    setSavingAge(false);
    if (saveError) {
      setError(t("createError"));
      return;
    }
    setAgeBlocked(false);
    await create();
  };

  const stop = async (id: string) => {
    setBusyId(id);
    // Optimistic and silent. The row disappears from her list immediately; nothing
    // is sent anywhere, and nothing on their side announces it.
    setShares((rows) => (rows ?? []).filter((r) => r.id !== id));
    const res = await revokeShare(id);
    setBusyId(null);
    if (!res.ok) {
      setError(t("stopError"));
      refresh();
    }
  };

  const renew = async (id: string) => {
    setBusyId(id);
    const res = await renewShare(id);
    setBusyId(null);
    if (!res.ok) setError(t("renewError"));
    refresh();
  };

  const redeem = async () => {
    setRedeeming(true);
    setRedeemError(null);
    const res = await redeemInvite(redeemValue);
    setRedeeming(false);
    if (!res.ok) {
      setRedeemError(t("redeem.error"));
      return;
    }
    setRedeemValue("");
    setRedeemed(true);
  };

  return (
    <AppScreen>
      <div className="flex flex-col gap-1">
        <h1 className="font-display text-lg text-text">{t("title")}</h1>
        <p className="text-sm text-text-muted">{t("intro")}</p>
      </div>

      {error ? (
        <Alert variant="danger">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      ) : null}

      {ageBlocked ? (
        <Alert variant="warning">
          <AlertDescription className="flex flex-col items-start gap-3">
            <span>{t("ageGate.body")}</span>
            <div className="flex flex-wrap gap-2">
              {ADULT_BANDS.map((band) => (
                <Button
                  key={band}
                  variant="outline"
                  size="sm"
                  disabled={savingAge}
                  onClick={() => void resolveAge(band)}
                >
                  {tAge(band)}
                </Button>
              ))}
              <Button variant="ghost" size="sm" onClick={() => setAgeBlocked(false)}>
                {t("ageGate.dismiss")}
              </Button>
            </div>
          </AlertDescription>
        </Alert>
      ) : null}

      {/* "What they can see right now" — her view of their view. Never buried
          behind a link, and listed in the words the categories are offered in, so
          the panel and the checkboxes cannot drift into describing different
          things. */}
      <Card>
        <CardContent className="flex flex-col gap-4 p-6">
          <div className="flex flex-col gap-1">
            <h2 className="text-md font-semibold text-text">{t("current.heading")}</h2>
            <p className="text-sm text-text-muted">{t("current.desc")}</p>
          </div>

          {shares === null ? (
            <div className="flex flex-col gap-2" aria-busy>
              <Skeleton className="h-5 w-full" />
              <Skeleton className="h-5 w-4/6" />
            </div>
          ) : shares.length === 0 ? (
            <p className="text-sm text-text-muted">{t("current.none")}</p>
          ) : (
            <ul className="flex flex-col gap-4">
              {shares.map((share) => (
                <li key={share.id} className="flex flex-col gap-2 border-t border-border pt-4">
                  <p className="text-sm font-semibold text-text">
                    {share.inviteCode
                      ? t("current.pendingNamed", {
                          name: share.recipientLabel ?? t("current.unnamed"),
                          code: formatInviteCode(share.inviteCode),
                        })
                      : t("current.activeNamed", {
                          name: share.recipientLabel ?? t("current.unnamed"),
                        })}
                  </p>
                  <ul className="flex flex-col gap-0.5">
                    {share.categories.map((c) => (
                      <li key={c} className="text-sm text-text-muted">
                        {t(`categories.${c}.label`)}
                      </li>
                    ))}
                  </ul>
                  <p className="text-xs text-text-subtle">
                    {t("current.until", { date: fmtDate(share.expiresAt) })}
                  </p>
                  <div className="flex flex-wrap gap-2">
                    <Button
                      variant="outline"
                      size="sm"
                      disabled={busyId === share.id}
                      onClick={() => void stop(share.id)}
                    >
                      {t("current.stop")}
                    </Button>
                    {share.inviteCode ? null : (
                      <Button
                        variant="ghost"
                        size="sm"
                        disabled={busyId === share.id}
                        onClick={() => void renew(share.id)}
                      >
                        {t("current.renew")}
                      </Button>
                    )}
                  </div>
                </li>
              ))}
            </ul>
          )}
        </CardContent>
      </Card>

      {/* Starting a new share. Nothing is pre-ticked and there is no shortcut. */}
      <Card>
        <CardContent className="flex flex-col gap-4 p-6">
          <div className="flex flex-col gap-1">
            <h2 className="text-md font-semibold text-text">{t("create.heading")}</h2>
            <p className="text-sm text-text-muted">{t("create.desc")}</p>
          </div>

          {/* Asked first, and required. Art. 9(2)(a) consent names the recipient as
              well as the data, and until this existed a share was a grant to
              "whoever redeems this code" — granular, but not explicit (migration
              0012). It is also the answer to the question she actually has when
              she opens this screen in four months. */}
          <div className="flex flex-col gap-2">
            <Label htmlFor="recipient-label">{t("create.recipientLabel")}</Label>
            <Input
              id="recipient-label"
              value={recipient}
              maxLength={MAX_RECIPIENT_LABEL}
              autoComplete="off"
              onChange={(e) => setRecipient(e.target.value)}
              placeholder={t("create.recipientPlaceholder")}
            />
            <p className="text-xs text-text-muted">{t("create.recipientNote")}</p>
          </div>

          <div className="flex flex-col gap-3">
            {SHARE_CATEGORIES.map((category: ShareCategory) => (
              <label key={category} className="flex items-start gap-3 text-sm text-text">
                <input
                  type="checkbox"
                  className="mt-0.5 size-5 shrink-0 accent-primary-solid"
                  checked={scope[category]}
                  onChange={(e) =>
                    setScope({ ...scope, [category]: e.target.checked } as ShareScope)
                  }
                />
                <span className="flex flex-col gap-0.5">
                  <span>{t(`categories.${category}.label`)}</span>
                  <span className="text-xs text-text-muted">{t(`categories.${category}.note`)}</span>
                </span>
              </label>
            ))}
          </div>

          {/* The absence of a checkbox is the protection (design §4) — but an
              absence she cannot see is indistinguishable from an oversight, and it
              is worth more to her said out loud: she can point at it. */}
          <p className="rounded-md bg-surface-sunken p-3 text-xs text-text-muted">
            {t("create.neverShared")}
          </p>

          <Button
            disabled={creating || !hasAnyCategory(scope) || recipient.trim().length === 0}
            onClick={() => void create()}
          >
            {t("create.cta")}
          </Button>

          {newCode ? (
            <Alert variant="success">
              <AlertDescription className="flex flex-col gap-2">
                <span>{t("create.codeIntro")}</span>
                <span className="font-display text-lg tracking-widest text-text">
                  {formatInviteCode(newCode)}
                </span>
                <span className="text-xs text-text-muted">{t("create.codeNote")}</span>
              </AlertDescription>
            </Alert>
          ) : null}
        </CardContent>
      </Card>

      {/* The other half of the feature: taking up someone else's invite. It lives
          on the same screen because "sharing" is one idea to the person using it,
          and a second route would be one more thing to find. */}
      <Card>
        <CardContent className="flex flex-col gap-3 p-6">
          <div className="flex flex-col gap-1">
            <h2 className="text-md font-semibold text-text">{t("redeem.heading")}</h2>
            <p className="text-sm text-text-muted">{t("redeem.desc")}</p>
          </div>

          {redeemed ? (
            <Alert variant="success">
              <AlertDescription>{t("redeem.done")}</AlertDescription>
            </Alert>
          ) : null}
          {redeemError ? (
            <Alert variant="danger">
              <AlertDescription>{redeemError}</AlertDescription>
            </Alert>
          ) : null}

          <div className="flex flex-col gap-2">
            <Label htmlFor="partner-code">{t("redeem.label")}</Label>
            <Input
              id="partner-code"
              value={redeemValue}
              autoComplete="off"
              spellCheck={false}
              onChange={(e) => setRedeemValue(e.target.value)}
              placeholder="ABCD-2345"
            />
          </div>
          <div className="flex flex-wrap gap-2">
            <Button
              variant="outline"
              disabled={redeeming || redeemValue.trim().length === 0}
              onClick={() => void redeem()}
            >
              {t("redeem.cta")}
            </Button>
            {/* Reachable whether or not she has just redeemed something: a recipient
                arriving weeks later needs a way in that is not "remember the code". */}
            <Button asChild variant="ghost">
              <Link href="/shared-with-me">{tShared("title")}</Link>
            </Button>
          </div>
        </CardContent>
      </Card>
    </AppScreen>
  );
}
