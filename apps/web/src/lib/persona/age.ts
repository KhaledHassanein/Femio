/**
 * Age bands, as their own module (R2.4).
 *
 * These lived in `state.ts`, which is fine until you try to run the resolver
 * anywhere other than a browser: `state.ts` imports the Supabase client, so a
 * `type AgeBand` import dragged the whole data layer into tier 1. The resolver has
 * to lift into an Edge Function — and later into Dart — unchanged, so the pure
 * values live on their own and `state.ts` re-exports them for existing callers.
 *
 * Mirrors the `profiles.age_band` check constraint. Age is stored as a band rather
 * than a date wherever possible: data minimisation, and nothing in the taxonomy
 * needs more precision than this (`docs/14`).
 */
export const AGE_BANDS = [
  "under_13",
  "13_15",
  "16_17",
  "18_24",
  "25_34",
  "35_44",
  "45_54",
  "55_plus",
] as const;

export type AgeBand = (typeof AGE_BANDS)[number];
