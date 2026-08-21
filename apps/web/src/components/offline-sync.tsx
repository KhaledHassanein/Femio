"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import { flushQueue } from "@/lib/offline/sync";
import { OFFLINE_FLUSHED_EVENT } from "@/lib/supabase/use-query";

// Flushes queued offline logs on mount and whenever connectivity returns.
// Rendered once in the signed-in app layout; renders nothing.
export function OfflineSync() {
  const router = useRouter();

  useEffect(() => {
    let active = true;
    const flush = async () => {
      const synced = await flushQueue();
      if (!active || synced === 0) return;

      // Two notifications, because the app renders both ways. `router.refresh()`
      // re-runs server components — which is what this did on its own, and why
      // nothing visibly updated: every tracker screen reads through
      // `useSupabaseQuery` in the browser since P4.0/ADR-048, and a server refresh
      // does not touch a client query. A period logged offline therefore synced to
      // Supabase and stayed hidden behind "No periods logged yet" until a manual
      // reload, which reads as data loss on the one screen where that is least
      // forgivable. The event covers the client reads; the refresh stays for any
      // server-rendered surface that still exists.
      router.refresh();
      window.dispatchEvent(new Event(OFFLINE_FLUSHED_EVENT));
    };
    void flush();
    window.addEventListener("online", flush);
    return () => {
      active = false;
      window.removeEventListener("online", flush);
    };
  }, [router]);

  return null;
}
