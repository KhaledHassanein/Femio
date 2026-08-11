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

/**
 * English is the master and it lives in the repo, never in the database.
 *
 * The portal (P1.19) is a **translation** tool: its board is per-locale for
 * ar/fr/es and it renders English as the read-only master column. English rows
 * exist in `ui_strings` only because the seed script imported the whole catalog,
 * and all they do is shadow the repo.
 *
 * That shadow was a live defect, found on 2026-08-11 while implementing R1.3
 * (ADR-064). The new homepage shipped with its new markup and the **old text**:
 * `home.heroTitle` had been seeded as "One account for your whole health life."
 * and marked `human_reviewed`, so the overlay won. Every English copy edit made
 * to a seeded key since P1.19 had silently done nothing in production — the class
 * of failure that is invisible from inside a diff and only shows up on a rendered
 * page, which is why `docs/STATE.md` says to check the deployed thing.
 *
 * Translations still overlay normally; only the source locale is protected.
 */
export function overlaysFromDatabase(locale: string, defaultLocale: string): boolean {
  return locale !== defaultLocale;
}

/** Base JSON messages overlaid with approved DB strings. Falls back to pure JSON. */
export async function loadMessages(
  locale: string,
  jsonMessages: Nested,
  defaultLocale = "en",
): Promise<Nested> {
  if (!overlaysFromDatabase(locale, defaultLocale)) return jsonMessages;
  const db = await fetchApproved(locale);
  if (Object.keys(db).length === 0) return jsonMessages;
  return overlay(jsonMessages, db);
}
