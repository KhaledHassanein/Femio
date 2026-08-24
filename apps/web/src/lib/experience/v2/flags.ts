/**
 * Which contract version a surface reads (RB-B5, `docs/29_REBUILD/03` §5).
 *
 * The migration runs **one surface at a time, with both documents live**, which is
 * what the teardown found Flo doing: `CalendarScreenActivity` and
 * `UicCalendarActivity` ship in the same build and a flag chooses. There is no flag
 * day, and any surface can be put back by flipping one row.
 *
 * ## Resolution order, and why the default is a compiled constant
 *
 * `remote → cached → compiled default`, the same three-source shape
 * `lib/experience/client.ts` already uses for the document itself. A device with no
 * network gets the last value it saw; a device that has never seen one gets the
 * value in the build. **It never gets nothing**, because "no flag" would mean an
 * unrendered screen.
 *
 * The compiled default for every surface is `1`. A surface only reaches v2 by
 * someone deliberately turning it on, which is the correct direction for a
 * migration: forgetting to set a flag leaves the working screen in place.
 *
 * ## What a flag may not do here
 *
 * Choose a *renderer*, never a *rule*. Both documents are produced by the same
 * resolver from the same persona records (`upgrade.ts`), so flipping a surface
 * changes how something is drawn and never what Femio decided. If a flag could
 * change the decision, two women with the same record would get different medical
 * output depending on a rollout percentage.
 */

/** The surfaces that migrate independently. Matches `SurfaceMap`'s keys. */
export const MIGRATABLE_SURFACES = ["home", "calendar", "learn", "tools", "insights"] as const;

export type MigratableSurface = (typeof MIGRATABLE_SURFACES)[number];

export type ContractVersion = 1 | 2;

/** `experience.v2.home`, and so on. The key a `feature_flags` row uses. */
export function surfaceFlagKey(surface: MigratableSurface): string {
  return `experience.v2.${surface}`;
}

/**
 * Everything a client knows about flags, in the order it should be trusted.
 *
 * `remote` absent means the fetch has not happened or failed; `cached` absent means
 * this device has never completed one. Both are normal, and neither is an error.
 */
export type FlagSources = {
  remote?: Readonly<Record<string, boolean>>;
  cached?: Readonly<Record<string, boolean>>;
};

/**
 * Which version this surface should render. Pure, total, and never throws — a
 * surface that cannot decide must still draw something.
 */
export function versionForSurface(
  surface: MigratableSurface,
  sources: FlagSources = {},
): ContractVersion {
  const key = surfaceFlagKey(surface);
  const remote = sources.remote?.[key];
  if (remote !== undefined) return remote ? 2 : 1;
  const cached = sources.cached?.[key];
  if (cached !== undefined) return cached ? 2 : 1;
  return 1;
}

/** Every surface's decision at once, for a client that renders more than one. */
export function versionsForSurfaces(
  sources: FlagSources = {},
): Readonly<Record<MigratableSurface, ContractVersion>> {
  const out = {} as Record<MigratableSurface, ContractVersion>;
  for (const surface of MIGRATABLE_SURFACES) {
    out[surface] = versionForSurface(surface, sources);
  }
  return out;
}

/**
 * Is the migration finished?
 *
 * When every surface reads v2, the v1 path can be deleted from the resolver — step
 * 5 of the sequence. Worth asking in code rather than by memory, because a
 * half-migrated product carrying both paths indefinitely is the cost Flo is visibly
 * still paying.
 */
export function migrationComplete(sources: FlagSources = {}): boolean {
  return MIGRATABLE_SURFACES.every((s) => versionForSurface(s, sources) === 2);
}
