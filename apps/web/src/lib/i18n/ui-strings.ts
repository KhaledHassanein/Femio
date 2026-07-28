/**
 * Pure UI-strings helpers (P1.19). No Next/Supabase imports, so they are
 * unit-testable in isolation. The DB fetch + caching lives in `ui-strings-loader.ts`.
 *
 * The JSON catalogs are the base; the translation portal's human-approved rows in
 * `ui_strings` are overlaid on top (see the loader).
 */
export const UI_STRINGS_TAG = "ui-strings";

export type FlatStrings = Record<string, string>;
export type Nested = { [k: string]: string | Nested };

/** Nested messages → flat dotted keys (only string leaves). */
export function flatten(obj: Nested, prefix = ""): FlatStrings {
  const out: FlatStrings = {};
  for (const [k, v] of Object.entries(obj)) {
    const key = prefix ? `${prefix}.${k}` : k;
    if (typeof v === "string") out[key] = v;
    else if (v && typeof v === "object") Object.assign(out, flatten(v, key));
  }
  return out;
}

/** Flat dotted keys → nested object. */
export function unflatten(flat: FlatStrings): Nested {
  const root: Nested = {};
  for (const [key, value] of Object.entries(flat)) {
    const parts = key.split(".");
    let node: Nested = root;
    for (let i = 0; i < parts.length - 1; i++) {
      const p = parts[i]!;
      if (typeof node[p] !== "object" || node[p] == null) node[p] = {};
      node = node[p] as Nested;
    }
    node[parts.at(-1)!] = value;
  }
  return root;
}

/** JSON base overlaid with DB values (empty DB values are ignored). */
export function overlay(base: Nested, dbFlat: FlatStrings): Nested {
  const merged: FlatStrings = { ...flatten(base) };
  for (const [k, v] of Object.entries(dbFlat)) if (v) merged[k] = v;
  return unflatten(merged);
}
