"use server";

import { revalidateTag } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import { getMyRoles, hasRole } from "@/lib/auth/roles";
import { flatten, UI_STRINGS_TAG, type Nested } from "./ui-strings";
import enMessages from "../../../messages/en.json";

const KNOWN_KEYS = new Set(Object.keys(flatten(enMessages as Nested)));

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

export type ImportResult =
  | { ok: true; updated: number; skipped: number; unknownKeys: string[] }
  | { ok: false; error: string };

/**
 * Bulk-upsert translations (from a CSV import, P1.19.2). Only keys that exist in
 * the English master are written (unknown keys are reported, not created). Empty
 * translations are skipped. `approve` marks rows human_reviewed (published) vs.
 * machine (draft). RLS staff-write is the boundary; the role check fails fast.
 */
export async function importUiStrings(
  locale: string,
  rows: { key: string; value: string }[],
  approve: boolean,
): Promise<ImportResult> {
  const supabase = await createClient();
  const roles = await getMyRoles(supabase);
  if (!hasRole(roles, "admin", "translator")) return { ok: false, error: "Not authorized." };

  const status = approve ? "human_reviewed" : "machine";
  const unknownKeys: string[] = [];
  const seen = new Set<string>();
  const toUpsert: { key: string; locale: string; value: string; status: string; icu: boolean }[] = [];

  for (const { key, value } of rows) {
    const k = key.trim();
    const v = value.trim();
    if (!k || seen.has(k)) continue;
    seen.add(k);
    if (!KNOWN_KEYS.has(k)) {
      unknownKeys.push(k);
      continue;
    }
    if (!v) continue; // don't create empty rows
    toUpsert.push({ key: k, locale, value: v, status, icu: /\{.*\}/.test(v) });
  }

  for (let i = 0; i < toUpsert.length; i += 500) {
    const { error } = await supabase
      .from("ui_strings")
      .upsert(toUpsert.slice(i, i + 500), { onConflict: "key,locale" });
    if (error) return { ok: false, error: error.message };
  }

  revalidateTag(UI_STRINGS_TAG);
  return { ok: true, updated: toUpsert.length, skipped: rows.length - toUpsert.length, unknownKeys };
}
