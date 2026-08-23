/**
 * What Femio may send her, when, and in what words (P2.8).
 *
 * Tier 2: pure, portable, no framework and no data layer, because a Flutter client
 * will schedule the same reminders and "may this be sent now" is not a question
 * two clients may answer differently. The Dart twin reads this file.
 *
 * ## The problem this is really solving
 *
 * A notification is the only thing Femio does to a woman rather than for her. It
 * arrives on a lock screen, in a room she did not choose, possibly in front of
 * someone she has not told. Every decision below follows from that:
 *
 * - **Nothing is on by default.** `DEFAULT_PREFS` is every kind off. An app that
 *   opts her into being interrupted about her cycle and waits to be corrected has
 *   already made the disclosure it was supposed to be asking about.
 * - **Discreet wording is the default *when* a kind is on**, not an advanced
 *   setting. `discreetTitle` never names a period, a symptom, a medicine or a
 *   pregnancy — it says "Femio" and asks her to open the app. The full wording is
 *   opt-in and phrased so she knows what she is turning on.
 * - **Quiet hours are honoured by the decision, not by the sender.** Putting the
 *   check here means a future scheduler, a cron, or a Dart background task cannot
 *   forget it.
 * - **No streaks, no counts of missed days, no "you haven't logged in a while".**
 *   `docs/09` invariant 7, and the same refusal P2.4 made about adherence scores.
 *   A reminder may say *you can log today*; it may never grade her for not having.
 * - **Nothing about being late.** Product rule 3 forbids a "late" counter in the
 *   UI; a push notification is a worse place for one, not an exempt one.
 */

/**
 * The kinds Femio can send. A closed set: a kind that is not here cannot be
 * scheduled, which is the same closed-catalog discipline `lib/analytics/events.ts`
 * uses for a related reason — a free-form notification type is a free-form
 * disclosure.
 */
export const NOTIFICATION_KINDS = [
  /** Her predicted window is opening. A range, never a date, like everywhere else. */
  "periodWindow",
  /** A gentle "you can log today". Never a streak and never a count of missed days. */
  "logReminder",
  /** An appointment she recorded is coming up, with the questions she wrote down. */
  "appointment",
  /** A medicine she asked to be reminded about. Never adherence, never a score. */
  "medication",
  /** Her cycle ended and the summary is ready. */
  "cycleSummary",
] as const;

export type NotificationKind = (typeof NOTIFICATION_KINDS)[number];

export type NotificationPrefs = {
  /** Per-kind opt-in. Absent or unknown reads as off. */
  kinds: Readonly<Record<NotificationKind, boolean>>;
  /**
   * Lock-screen wording that names nothing. On by default for every kind she
   * enables — see the header. Turning it off is her choice to make explicitly.
   */
  discreet: boolean;
  /** Local hour (0–23) quiet time starts. Inclusive. */
  quietFrom: number;
  /** Local hour quiet time ends. Exclusive. Wraps past midnight. */
  quietTo: number;
};

/** Nothing on, discreet wording, and a night that is actually quiet. */
export const DEFAULT_PREFS: NotificationPrefs = Object.freeze({
  kinds: Object.freeze(
    Object.fromEntries(NOTIFICATION_KINDS.map((k) => [k, false])) as Record<
      NotificationKind,
      boolean
    >,
  ),
  discreet: true,
  quietFrom: 22,
  quietTo: 8,
});

/** Read a stored preferences blob without trusting it. Anything unknown is off. */
export function normalizePrefs(raw: unknown): NotificationPrefs {
  const source = raw && typeof raw === "object" ? (raw as Record<string, unknown>) : {};
  const kindsRaw =
    source.kinds && typeof source.kinds === "object"
      ? (source.kinds as Record<string, unknown>)
      : {};

  const hour = (value: unknown, fallback: number) =>
    typeof value === "number" && Number.isInteger(value) && value >= 0 && value <= 23
      ? value
      : fallback;

  return Object.freeze({
    kinds: Object.freeze(
      Object.fromEntries(
        NOTIFICATION_KINDS.map((k) => [k, kindsRaw[k] === true]),
      ) as Record<NotificationKind, boolean>,
    ),
    // Fails *safe* rather than closed: anything other than an explicit `false`
    // keeps the discreet wording, because the cost of being wrong is a health
    // word on a lock screen.
    discreet: source.discreet !== false,
    quietFrom: hour(source.quietFrom, DEFAULT_PREFS.quietFrom),
    quietTo: hour(source.quietTo, DEFAULT_PREFS.quietTo),
  });
}

export function anyKindEnabled(prefs: NotificationPrefs): boolean {
  return NOTIFICATION_KINDS.some((k) => prefs.kinds[k]);
}

/**
 * Is `hour` inside her quiet window? Handles the ordinary case where quiet time
 * wraps past midnight (22 → 8), which is what almost everyone sets.
 *
 * `quietFrom === quietTo` means **no quiet hours**, not twenty-four of them. The
 * other reading would let a mis-set pair silence everything forever with no
 * feedback, which is indistinguishable from the feature being broken.
 */
export function isQuietHour(hour: number, prefs: NotificationPrefs): boolean {
  const { quietFrom, quietTo } = prefs;
  if (quietFrom === quietTo) return false;
  if (!Number.isInteger(hour) || hour < 0 || hour > 23) return false;
  return quietFrom < quietTo
    ? hour >= quietFrom && hour < quietTo
    : hour >= quietFrom || hour < quietTo;
}

export type SendDecision =
  | { send: true }
  | { send: false; reason: "kind_off" | "quiet_hours" | "not_subscribed" };

/**
 * The one decision, in one place. A scheduler asks; it does not decide.
 *
 * Ordered so the cheapest and most absolute gate runs first, and so the reason
 * returned is the most useful one: "you turned this off" is a different message to
 * a developer than "it is half past three in the morning".
 */
export function shouldSend(
  kind: NotificationKind,
  prefs: NotificationPrefs,
  context: { localHour: number; subscribed: boolean },
): SendDecision {
  if (!context.subscribed) return { send: false, reason: "not_subscribed" };
  if (!prefs.kinds[kind]) return { send: false, reason: "kind_off" };
  if (isQuietHour(context.localHour, prefs)) return { send: false, reason: "quiet_hours" };
  return { send: true };
}

/**
 * Which message body a notification uses.
 *
 * Returns an i18n **key**, never text: copy lives in the catalogs in four locales
 * and a tier-2 module that returned English would be the `AlertSpec` mistake
 * (`lib/experience/types.ts`) in a new place.
 *
 * The discreet key is deliberately the *same* for every kind. Five distinct
 * discreet messages would be five distinguishable notifications, and someone
 * reading over her shoulder twice learns the mapping — which defeats the point far
 * more subtly than naming the period would.
 */
export function bodyKeyFor(kind: NotificationKind, prefs: NotificationPrefs): string {
  return prefs.discreet ? "discreet" : `plain.${kind}`;
}
