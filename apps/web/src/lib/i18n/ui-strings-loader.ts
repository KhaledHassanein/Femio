import { createClient } from "@supabase/supabase-js";
import { unstable_cache } from "next/cache";
import { env } from "@/lib/env";
import { overlay, UI_STRINGS_TAG, type FlatStrings, type Nested } from "./ui-strings";

/**
 * DB-backed UI strings loader (P1.19, the ADR-009 swap point). Only serves
 * `status = 'human_reviewed'` rows, so an unreviewed draft, an unseeded/empty
 * table, or a DB error all leave the app on pure JSON — zero behaviour change
 * until a string is deliberately approved in the portal. One cached read per
 * locale (revalidated); the portal busts the cache on approve via `UI_STRINGS_TAG`.
 */
function anonClient() {
  return createClient(env.NEXT_PUBLIC_SUPABASE_URL, env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
}

const fetchApproved = (locale: string) =>
  unstable_cache(
    async (): Promise<FlatStrings> => {
      try {
        const { data, error } = await anonClient()
          .from("ui_strings")
          .select("key, value")
          .eq("locale", locale)
          .eq("status", "human_reviewed");
        if (error || !data) return {};
        const out: FlatStrings = {};
        for (const row of data) if (row.value) out[row.key as string] = row.value as string;
        return out;
      } catch {
        return {};
      }
    },
    ["ui-strings", locale],
    { revalidate: 60, tags: [UI_STRINGS_TAG] },
  )();

/** Base JSON messages overlaid with approved DB strings. Falls back to pure JSON. */
export async function loadMessages(locale: string, jsonMessages: Nested): Promise<Nested> {
  const db = await fetchApproved(locale);
  if (Object.keys(db).length === 0) return jsonMessages;
  return overlay(jsonMessages, db);
}
