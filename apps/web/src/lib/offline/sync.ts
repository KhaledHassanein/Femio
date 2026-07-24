import { createClient } from "@/lib/supabase/client";
import { enqueue, getAllQueued, removeQueued, type QueuePayload, type QueueItem } from "./queue";

export type SaveResult = "synced" | "queued" | { error: string };

function isOffline(): boolean {
  return typeof navigator !== "undefined" && !navigator.onLine;
}

/**
 * Insert a log row, or queue it if offline / the network fails. A returned
 * `error` is a real (non-network) failure — e.g. RLS/validation — and is NOT
 * queued, since it would never succeed.
 */
export async function saveOrQueue(
  table: QueueItem["table"],
  payload: QueuePayload,
): Promise<SaveResult> {
  if (isOffline()) {
    await enqueue({ table, payload, createdAt: new Date().toISOString() });
    return "queued";
  }
  try {
    const supabase = createClient();
    const { error } = await supabase.from(table).insert(payload as never);
    if (error) return { error: error.message };
    return "synced";
  } catch {
    await enqueue({ table, payload, createdAt: new Date().toISOString() });
    return "queued";
  }
}

/** Flush queued entries to Supabase when online. Returns how many synced. */
export async function flushQueue(): Promise<number> {
  if (isOffline()) return 0;
  const items = await getAllQueued();
  if (items.length === 0) return 0;

  const supabase = createClient();
  let flushed = 0;
  for (const item of items) {
    try {
      const { error } = await supabase.from(item.table).insert(item.payload as never);
      if (error) continue; // leave in queue; a later flush retries
      if (item.id != null) {
        await removeQueued(item.id);
        flushed += 1;
      }
    } catch {
      break; // network dropped again — stop and retry later
    }
  }
  return flushed;
}
