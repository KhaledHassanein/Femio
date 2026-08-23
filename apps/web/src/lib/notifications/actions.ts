import { createClient } from "@/lib/supabase/client";
import { env } from "@/lib/env";
import {
  DEFAULT_PREFS,
  normalizePrefs,
  type NotificationKind,
  type NotificationPrefs,
} from "./index";

/**
 * Reading and changing her notification settings, and subscribing this device
 * (P2.8).
 *
 * The rules are in `./index.ts` and the boundary is RLS. This file is the round
 * trip, plus the browser half of web push — which is the only part of the feature
 * that cannot be pure.
 *
 * ## Delivery is configured, not assumed
 *
 * `NEXT_PUBLIC_VAPID_PUBLIC_KEY` unset → `pushSupported()` is false, the Settings
 * panel says so, and no permission prompt is ever raised. The same posture as
 * PostHog and Sentry: an unconfigured vendor path is a verified no-op rather than
 * a half-working one, and asking for notification permission Femio cannot yet
 * deliver on would spend the one prompt a browser gives you.
 */

type Ok = { ok: true };
type Failure = { ok: false; error: string };
const fail = (error: string): Failure => ({ ok: false, error });

export async function readPrefs(): Promise<NotificationPrefs> {
  const supabase = createClient();
  const { data: auth } = await supabase.auth.getUser();
  if (!auth.user) return DEFAULT_PREFS;

  const { data, error } = await supabase
    .from("notification_prefs")
    .select("kinds, discreet, quiet_from, quiet_to")
    .eq("profile_id", auth.user.id)
    .maybeSingle();

  // No row is the normal state, not an error: it means she has never opened this
  // panel, and the defaults are "nothing on".
  if (error || !data) return DEFAULT_PREFS;
  const row = data as { kinds: unknown; discreet: boolean; quiet_from: number; quiet_to: number };
  return normalizePrefs({
    kinds: row.kinds,
    discreet: row.discreet,
    quietFrom: row.quiet_from,
    quietTo: row.quiet_to,
  });
}

export async function savePrefs(prefs: NotificationPrefs): Promise<Ok | Failure> {
  const supabase = createClient();
  const { data: auth } = await supabase.auth.getUser();
  if (!auth.user) return fail("not_signed_in");

  const { error } = await supabase.from("notification_prefs").upsert(
    {
      profile_id: auth.user.id,
      kinds: prefs.kinds,
      discreet: prefs.discreet,
      quiet_from: prefs.quietFrom,
      quiet_to: prefs.quietTo,
    },
    { onConflict: "profile_id" },
  );
  return error ? fail(error.message) : { ok: true };
}

export function pushSupported(): boolean {
  if (typeof window === "undefined") return false;
  if (!("serviceWorker" in navigator) || !("PushManager" in window)) return false;
  return Boolean(env.NEXT_PUBLIC_VAPID_PUBLIC_KEY);
}

/**
 * The VAPID key is base64url; `applicationServerKey` wants raw bytes.
 *
 * Typed as `ArrayBuffer` rather than `Uint8Array` because TypeScript 5.7 made
 * `Uint8Array` generic over its buffer, and a plain one is no longer assignable to
 * `BufferSource` — the DOM type wants a view over a definitely-not-shared buffer.
 * Handing back the `.buffer` is both correct and the version-proof shape.
 */
function urlBase64ToBytes(base64: string): ArrayBuffer {
  const padded = base64.padEnd(base64.length + ((4 - (base64.length % 4)) % 4), "=");
  const raw = atob(padded.replace(/-/g, "+").replace(/_/g, "/"));
  const bytes = new Uint8Array(raw.length);
  for (let i = 0; i < raw.length; i += 1) bytes[i] = raw.charCodeAt(i);
  return bytes.buffer;
}

/**
 * Subscribe this device.
 *
 * Called from a click, never on mount. A permission prompt she did not ask for is
 * the single most disliked pattern on the web, and a denied prompt is permanent
 * for the origin — so it is spent only when she has already said yes in the UI.
 */
export async function subscribeThisDevice(): Promise<Ok | Failure> {
  if (!pushSupported()) return fail("not_supported");

  const permission = await Notification.requestPermission();
  if (permission !== "granted") return fail("denied");

  const registration = await navigator.serviceWorker.ready;
  const existing = await registration.pushManager.getSubscription();
  const subscription =
    existing ??
    (await registration.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: urlBase64ToBytes(env.NEXT_PUBLIC_VAPID_PUBLIC_KEY!),
    }));

  const json = subscription.toJSON();
  if (!json.endpoint || !json.keys?.p256dh || !json.keys?.auth) return fail("bad_subscription");

  const supabase = createClient();
  const { data: auth } = await supabase.auth.getUser();
  if (!auth.user) return fail("not_signed_in");

  const { error } = await supabase.from("push_subscriptions").upsert(
    {
      profile_id: auth.user.id,
      endpoint: json.endpoint,
      p256dh: json.keys.p256dh,
      auth: json.keys.auth,
    },
    { onConflict: "endpoint" },
  );
  return error ? fail(error.message) : { ok: true };
}

/**
 * Unsubscribe this device, on both sides.
 *
 * The browser subscription is dropped *and* the row is deleted. Deleting only the
 * row would leave a live endpoint at the push service that Femio has forgotten
 * about; unsubscribing only in the browser would leave a row that fails to deliver
 * forever. Neither half is optional.
 */
export async function unsubscribeThisDevice(): Promise<Ok | Failure> {
  if (typeof window === "undefined" || !("serviceWorker" in navigator)) return { ok: true };

  const registration = await navigator.serviceWorker.ready;
  const subscription = await registration.pushManager.getSubscription();
  const endpoint = subscription?.endpoint ?? null;
  if (subscription) await subscription.unsubscribe();

  if (endpoint) {
    const supabase = createClient();
    const { error } = await supabase.from("push_subscriptions").delete().eq("endpoint", endpoint);
    if (error) return fail(error.message);
  }
  return { ok: true };
}

/** Whether this browser currently holds a subscription. Used to render the toggle honestly. */
export async function isSubscribedHere(): Promise<boolean> {
  if (!pushSupported()) return false;
  if (Notification.permission !== "granted") return false;
  const registration = await navigator.serviceWorker.ready;
  return Boolean(await registration.pushManager.getSubscription());
}

/** Toggle one kind and persist. Returns the new prefs so the caller renders truth. */
export async function setKind(
  prefs: NotificationPrefs,
  kind: NotificationKind,
  enabled: boolean,
): Promise<{ prefs: NotificationPrefs; result: Ok | Failure }> {
  const next = normalizePrefs({
    ...prefs,
    kinds: { ...prefs.kinds, [kind]: enabled },
  });
  return { prefs: next, result: await savePrefs(next) };
}
