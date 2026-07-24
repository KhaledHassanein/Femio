"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import { flushQueue } from "@/lib/offline/sync";

// Flushes queued offline logs on mount and whenever connectivity returns.
// Rendered once in the signed-in app layout; renders nothing.
export function OfflineSync() {
  const router = useRouter();

  useEffect(() => {
    let active = true;
    const flush = async () => {
      const synced = await flushQueue();
      if (active && synced > 0) router.refresh();
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
