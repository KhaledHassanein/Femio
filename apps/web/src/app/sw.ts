/// <reference lib="webworker" />
import { defaultCache } from "@serwist/next/worker";
import type { PrecacheEntry, SerwistGlobalConfig } from "serwist";
import { Serwist } from "serwist";

// Service worker source. @serwist/next compiles this to public/sw.js at build time
// and injects the precache manifest. Enables offline-capable logging later (P1.17).
declare global {
  interface WorkerGlobalScope extends SerwistGlobalConfig {
    __SW_MANIFEST: (PrecacheEntry | string)[] | undefined;
  }
}

declare const self: ServiceWorkerGlobalScope;

const serwist = new Serwist({
  precacheEntries: self.__SW_MANIFEST,
  skipWaiting: true,
  clientsClaim: true,
  navigationPreload: true,
  runtimeCaching: defaultCache,
});

serwist.addEventListeners();

/**
 * Web push (P2.8).
 *
 * The sender decides *whether* to send — quiet hours, per-kind opt-in and discreet
 * wording all live in `lib/notifications`, which the Dart client will share. This
 * worker only renders what arrived, and it is deliberately incapable of deciding
 * anything: there is no branch here on kind, on time, or on any health value.
 *
 * `title` and `body` arrive already localised and already discreet-or-not. A
 * service worker has no locale context and no access to the message catalogs, so
 * composing copy here would mean an English notification for an Arabic reader —
 * the exact defect the crisis dialog shipped with until 2026-08-23.
 */
self.addEventListener("push", (event) => {
  if (!event.data) return;

  let payload: { title?: string; body?: string; url?: string } = {};
  try {
    payload = event.data.json() as typeof payload;
  } catch {
    // A malformed push is dropped rather than rendered as "[object Object]" on a
    // lock screen. Silence is the safe failure for this feature.
    return;
  }
  if (!payload.title) return;

  event.waitUntil(
    self.registration.showNotification(payload.title, {
      body: payload.body,
      icon: "/icon.svg",
      badge: "/icon.svg",
      // No image, no actions, no tag grouping: every one of those is a way for
      // more to appear on a lock screen than the discreet setting intended.
      data: { url: payload.url ?? "/" },
    }),
  );
});

self.addEventListener("notificationclick", (event) => {
  event.notification.close();
  const url = (event.notification.data as { url?: string } | undefined)?.url ?? "/";
  event.waitUntil(
    self.clients.matchAll({ type: "window", includeUncontrolled: true }).then((clients) => {
      // Focus a tab that is already open rather than stacking another one.
      const open = clients.find((c) => "focus" in c);
      if (open) return open.focus();
      return self.clients.openWindow(url);
    }),
  );
});
