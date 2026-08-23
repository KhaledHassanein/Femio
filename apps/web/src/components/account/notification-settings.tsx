"use client";

import { useEffect, useState } from "react";
import { useTranslations } from "next-intl";
import {
  NOTIFICATION_KINDS,
  normalizePrefs,
  type NotificationKind,
  type NotificationPrefs,
} from "@/lib/notifications";
import {
  isSubscribedHere,
  pushSupported,
  readPrefs,
  savePrefs,
  setKind,
  subscribeThisDevice,
  unsubscribeThisDevice,
} from "@/lib/notifications/actions";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Skeleton } from "@/components/ui/skeleton";

/**
 * Her notification settings (P2.8).
 *
 * Everything here is off until she turns it on, and the panel is built so that
 * staying off is not a dead end she has to hunt through — the reminders she can
 * have are listed whether or not delivery is switched on, because "what could this
 * do for me" is the question she is answering.
 *
 * ## The two controls that are not toggles
 *
 * **Discreet wording** is presented as what it is: what a notification looks like
 * to someone who is not her. The copy shows the actual discreet text rather than
 * describing it, because "we use discreet wording" is a promise and *"Femio — open
 * the app"* is the thing she can check.
 *
 * **Quiet hours** are two hour pickers rather than a "do not disturb" switch. A
 * switch would need a default schedule anyway, and an app that silently decided
 * her night runs 23:00–07:00 is deciding something about her life.
 *
 * ## Why enabling delivery is a separate, later step
 *
 * The browser gives an origin **one** notification permission prompt, and a denial
 * is permanent. So the prompt is raised from an explicit tap, after she has chosen
 * what she wants — never on mount, and never at all when `NEXT_PUBLIC_VAPID_PUBLIC_KEY`
 * is unset, in which case the panel says delivery is not set up yet rather than
 * offering a button that cannot work.
 */

const HOURS = Array.from({ length: 24 }, (_, i) => i);

export function NotificationSettings() {
  const t = useTranslations("notifications");
  const [prefs, setPrefs] = useState<NotificationPrefs | null>(null);
  const [subscribed, setSubscribed] = useState(false);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [denied, setDenied] = useState(false);

  const supported = pushSupported();

  useEffect(() => {
    let active = true;
    void Promise.all([readPrefs(), isSubscribedHere()]).then(([p, s]) => {
      if (!active) return;
      setPrefs(p);
      setSubscribed(s);
    });
    return () => {
      active = false;
    };
  }, []);

  const persist = async (next: NotificationPrefs) => {
    setPrefs(next);
    const res = await savePrefs(next);
    if (!res.ok) setError(t("saveError"));
  };

  const toggleKind = async (kind: NotificationKind, enabled: boolean) => {
    if (!prefs) return;
    setError(null);
    const { prefs: next, result } = await setKind(prefs, kind, enabled);
    setPrefs(next);
    if (!result.ok) setError(t("saveError"));
  };

  const enableDelivery = async () => {
    setBusy(true);
    setError(null);
    const res = await subscribeThisDevice();
    setBusy(false);
    if (res.ok) {
      setSubscribed(true);
      return;
    }
    // A denied prompt is permanent for the origin, so it gets its own explanation
    // pointing at the browser rather than a retry button that can never work.
    if (res.error === "denied") setDenied(true);
    else setError(t("enableError"));
  };

  const disableDelivery = async () => {
    setBusy(true);
    setError(null);
    const res = await unsubscribeThisDevice();
    setBusy(false);
    if (res.ok) setSubscribed(false);
    else setError(t("saveError"));
  };

  if (!prefs) {
    return (
      <div className="flex flex-col gap-3" aria-busy>
        <Skeleton className="h-5 w-full" />
        <Skeleton className="h-5 w-5/6" />
        <Skeleton className="h-5 w-4/6" />
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-5">
      {error ? (
        <Alert variant="danger">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      ) : null}

      {denied ? (
        <Alert variant="warning">
          <AlertDescription>{t("deniedNotice")}</AlertDescription>
        </Alert>
      ) : null}

      {/* What she can be reminded about. Listed whether or not delivery is on:
          the question she is answering is "what could this do for me". */}
      <div className="flex flex-col gap-3">
        {NOTIFICATION_KINDS.map((kind) => (
          <label key={kind} className="flex items-start gap-3 text-sm text-text">
            <input
              type="checkbox"
              className="mt-0.5 size-5 shrink-0 accent-primary-solid"
              checked={prefs.kinds[kind]}
              onChange={(e) => void toggleKind(kind, e.target.checked)}
            />
            <span className="flex flex-col gap-0.5">
              <span>{t(`kinds.${kind}.label`)}</span>
              <span className="text-xs text-text-muted">{t(`kinds.${kind}.note`)}</span>
            </span>
          </label>
        ))}
      </div>

      {/* Shown rather than described: "we use discreet wording" is a promise, and
          the sample is the thing she can check. */}
      <div className="flex flex-col gap-2 border-t border-border pt-4">
        <label className="flex items-start gap-3 text-sm text-text">
          <input
            type="checkbox"
            className="mt-0.5 size-5 shrink-0 accent-primary-solid"
            checked={prefs.discreet}
            onChange={(e) =>
              void persist(normalizePrefs({ ...prefs, discreet: e.target.checked }))
            }
          />
          <span className="flex flex-col gap-0.5">
            <span>{t("discreet.label")}</span>
            <span className="text-xs text-text-muted">{t("discreet.note")}</span>
          </span>
        </label>
        <p className="rounded-md bg-surface-sunken p-3 text-xs text-text-muted">
          {prefs.discreet ? t("discreet.sample") : t("discreet.samplePlain")}
        </p>
      </div>

      <div className="flex flex-col gap-2 border-t border-border pt-4">
        <p className="text-sm text-text">{t("quiet.label")}</p>
        <p className="text-xs text-text-muted">{t("quiet.note")}</p>
        <div className="flex flex-wrap items-center gap-3">
          <span className="flex items-center gap-2">
            <Label htmlFor="quiet-from" className="text-xs text-text-muted">
              {t("quiet.from")}
            </Label>
            <select
              id="quiet-from"
              className="h-11 rounded-md border border-border bg-surface px-3 text-sm text-text"
              value={prefs.quietFrom}
              onChange={(e) =>
                void persist(normalizePrefs({ ...prefs, quietFrom: Number(e.target.value) }))
              }
            >
              {HOURS.map((h) => (
                <option key={h} value={h}>
                  {String(h).padStart(2, "0")}:00
                </option>
              ))}
            </select>
          </span>
          <span className="flex items-center gap-2">
            <Label htmlFor="quiet-to" className="text-xs text-text-muted">
              {t("quiet.to")}
            </Label>
            <select
              id="quiet-to"
              className="h-11 rounded-md border border-border bg-surface px-3 text-sm text-text"
              value={prefs.quietTo}
              onChange={(e) =>
                void persist(normalizePrefs({ ...prefs, quietTo: Number(e.target.value) }))
              }
            >
              {HOURS.map((h) => (
                <option key={h} value={h}>
                  {String(h).padStart(2, "0")}:00
                </option>
              ))}
            </select>
          </span>
        </div>
        {prefs.quietFrom === prefs.quietTo ? (
          // Said out loud, because the alternative reading of an empty window is a
          // silent twenty-four hours and she would have no way to tell which she got.
          <p className="text-xs text-text-muted">{t("quiet.none")}</p>
        ) : null}
      </div>

      <div className="flex flex-col gap-2 border-t border-border pt-4">
        <p className="text-sm text-text">{t("delivery.label")}</p>
        {!supported ? (
          <p className="text-xs text-text-muted">{t("delivery.unavailable")}</p>
        ) : subscribed ? (
          <>
            <p className="text-xs text-text-muted">{t("delivery.on")}</p>
            <Button
              variant="outline"
              className="self-start"
              disabled={busy}
              onClick={() => void disableDelivery()}
            >
              {t("delivery.turnOff")}
            </Button>
          </>
        ) : (
          <>
            <p className="text-xs text-text-muted">{t("delivery.off")}</p>
            <Button
              variant="outline"
              className="self-start"
              disabled={busy}
              onClick={() => void enableDelivery()}
            >
              {t("delivery.turnOn")}
            </Button>
          </>
        )}
      </div>

      {/* The absence worth stating: no streaks, no missed-day counts, no grading.
          `docs/09` invariant 7, and the same refusal P2.4 made about adherence. */}
      <p className="text-2xs leading-relaxed text-text-subtle">{t("neverDoes")}</p>
    </div>
  );
}
