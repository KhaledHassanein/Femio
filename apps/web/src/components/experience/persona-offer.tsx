"use client";

import { useEffect, useState } from "react";
import { useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import type { ExperienceConfig } from "@/lib/experience/types";
import { trackOfPersona } from "@/lib/persona/resolver";
import { modeFromTrack, switchMode, type PersonaMode } from "@/lib/persona/state";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";

/**
 * Progressive personalization — the offer (P1.27.5, `docs/09` §5).
 *
 * `Resolution.runnerUp` has existed since ADR-057 and `ExperienceConfig.offer`
 * since R2.2. **Nothing has ever rendered either.** That is the same shape as the
 * finding `docs/23` §3.1 opened this whole workstream with: the engine computing an
 * answer that no pixel consumes. `docs/09` §5 names the missing screen almost
 * exactly — *"Want me to tailor Femio for [situation]? You can undo this anytime."*
 *
 * ## Offered, never applied
 *
 * The resolver reaches Z1 whenever the evidence is thin or the top two candidates
 * disagree about the track. Z1 is a **real answer**, not a failure, so this is not
 * an error state to be cleared: she is being shown the generic experience because
 * that is the honest one, and the offer is a door, not a nag.
 *
 * Three things follow from that, and each is a decision rather than a detail:
 *
 * - **It names a life stage, not a persona.** She has never heard of "F1", and a
 *   product that told her it had classified her as one would be doing something
 *   she did not ask for. The track's own label is what she recognises, and the
 *   mapping is a lookup in tier 1 — never a persona-id comparison in a component,
 *   which `persona-branch-lint` fails the build over.
 * - **Dismissing it is permanent enough to matter.** Stored per user on the device,
 *   beside the experience cache and cleared with it on sign-out. Re-asking a woman
 *   who has said no is the behaviour that makes people stop reading anything an app
 *   says.
 * - **Accepting is reversible in one tap**, and the copy says so before she taps.
 *   `switchMode` re-resolves against her real record and writes an
 *   `adaptation_events` row, so the change is auditable and undoable — and Settings
 *   can put it straight back.
 */

const DISMISS_PREFIX = "femio.offer.dismissed.v1";

/** Cleared on sign-out alongside the experience cache — see `lib/experience/client`. */
function dismissKey(userId: string) {
  return `${DISMISS_PREFIX}.${userId}`;
}

export function PersonaOffer({ config }: { config: ExperienceConfig | null }) {
  const t = useTranslations("offer");
  const te = useTranslations("experience");
  const [dismissed, setDismissed] = useState(true);
  const [userId, setUserId] = useState<string | null>(null);
  const [applying, setApplying] = useState(false);

  const offered = config?.offer ?? null;
  const track = offered ? trackOfPersona(offered.personaId) : null;
  const mode: PersonaMode | null = track ? modeFromTrack(track) : null;

  // Read the dismissal once we know who she is. Starts dismissed so the offer
  // cannot flash on screen before we have checked.
  useEffect(() => {
    let cancelled = false;
    void (async () => {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (cancelled || !user) return;
      setUserId(user.id);
      try {
        setDismissed(localStorage.getItem(dismissKey(user.id)) === "1");
      } catch {
        // Blocked storage is not a reason to hide an offer or to show it twice.
        setDismissed(false);
      }
    })();
    return () => {
      cancelled = true;
    };
  }, []);

  /**
   * Whether there is anything to offer is decided in tier 1 — only from the generic
   * state, only above `OFFER_THRESHOLD`, only when it names a real stage (see
   * `offerFrom` in `lib/experience/build.ts`). This file's job is to render it, and
   * the only condition left here is whether she has already said no.
   */
  if (!offered || !mode || dismissed) return null;

  const dismiss = () => {
    setDismissed(true);
    if (!userId) return;
    try {
      localStorage.setItem(dismissKey(userId), "1");
    } catch {
      // Nothing to do; she will be asked once more at most.
    }
  };

  const accept = async () => {
    setApplying(true);
    const result = await switchMode(createClient(), mode);
    setApplying(false);
    if (result.ok) {
      dismiss();
      // A full reload rather than a refresh: mode changes what the whole screen
      // renders, and the served document is fetched once per mount.
      window.location.reload();
    }
  };

  return (
    <Alert variant="info">
      <AlertDescription className="flex flex-col gap-3">
        <span>{t("body", { stage: te(`modes.${mode}.label`) })}</span>
        {/* Said before she taps, not after: this is the "you can undo this
            anytime" half of `docs/09` §5, and it is what makes the offer safe to
            accept without thinking hard. */}
        <span className="text-2xs text-text-muted">{t("reversible")}</span>
        <div className="flex flex-wrap gap-2">
          <Button onClick={accept} disabled={applying} variant="accent">
            {applying ? t("applying") : t("accept")}
          </Button>
          <Button onClick={dismiss} variant="outline">
            {t("decline")}
          </Button>
        </div>
      </AlertDescription>
    </Alert>
  );
}

/** Called on sign-out. Her dismissals are hers, not the next person's on this device. */
export function clearOfferDismissals(): void {
  try {
    for (let i = localStorage.length - 1; i >= 0; i--) {
      const key = localStorage.key(i);
      if (key?.startsWith(DISMISS_PREFIX)) localStorage.removeItem(key);
    }
  } catch {
    // Nothing worth breaking sign-out over.
  }
}
