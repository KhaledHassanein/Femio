"use server";

import { revalidateTag } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import { getMyRoles, hasRole } from "@/lib/auth/roles";
import { UI_STRINGS_TAG } from "./ui-strings";

export type SaveResult = { ok: true } | { ok: false; error: string };

/**
 * Upsert one translation and mark it human-approved (P1.19). RLS (ui_strings
 * staff-write) is the real boundary; the role check here fails fast with a clear
 * message. Approving busts the cached overlay so the string goes live immediately.
 */
export async function saveUiString(
  key: string,
  locale: string,
  value: string,
): Promise<SaveResult> {
  const supabase = await createClient();
  const roles = await getMyRoles(supabase);
  if (!hasRole(roles, "admin", "translator")) {
    return { ok: false, error: "Not authorized." };
  }

  const { error } = await supabase.from("ui_strings").upsert(
    { key, locale, value, status: "human_reviewed", icu: /\{.*\}/.test(value) },
    { onConflict: "key,locale" },
  );
  if (error) return { ok: false, error: error.message };

  revalidateTag(UI_STRINGS_TAG);
  return { ok: true };
}
