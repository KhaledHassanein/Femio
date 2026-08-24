/**
 * v1 → v2 (RB-B5, `docs/29_REBUILD/03` §5).
 *
 * ## Why a derivation and not a second resolver
 *
 * The phase gate says v1's output must stay **byte-identical**. The cheapest way to
 * guarantee that is to not touch the thing that produces it: `buildExperienceConfig`
 * is unchanged, and v2 is a pure function of its result. A parallel resolver would
 * have two copies of every persona rule, and the day they drifted, two women with
 * the same record would see different screens depending on a flag.
 *
 * So the resolver emits v1, this derives v2, and both are written to
 * `experience_documents` keyed by contract version. `feature_flags` decides per
 * surface which one a client reads — `experience.v2.home`, `experience.v2.calendar`
 * and so on — which is the per-screen migration Flo runs, with
 * `CalendarScreenActivity` and `UicCalendarActivity` shipping side by side.
 *
 * ## What this can and cannot fill
 *
 * v1 knows about the home screen and a set of surfaced log kinds. It knows nothing
 * about a calendar panel, a learning collection or a tool ordering, because the
 * contract could not express them — that absence *is* the gap OD-10 named.
 *
 * A derivation cannot invent them. So the new surfaces come out **empty**, and empty
 * has a defined meaning: *the screen's own default*. An empty `tools.featured` is
 * not "no tools"; it is "no persona ordering yet, render the screen's natural
 * order", which is what `tools-completeness-lint` exists to keep true. Filling them
 * is Phase D, from the persona registry, not from here.
 *
 * ## The one thing it must invent: an accessible name
 *
 * v2 requires `a11y` on every module and v1 has none, so the derivation supplies
 * `modules.<id>.label`. **Those keys do not exist yet.** That is deliberate rather
 * than sloppy: nothing renders v2, so nothing looks them up, and inventing English
 * strings here would put rendered copy in a served document — the one thing rule 1
 * forbids. C4 adds the keys in four languages when the dashboard first reads v2, and
 * `i18n-client-lint` will fail loudly if it is attempted without them.
 */

import type { ExperienceConfig } from "../types.ts";
import type { ExperienceConfigV2, ModuleSpecV2, SurfaceMap, VariableValue } from "./types.ts";
import { SEED_VARIABLES, validateWiring } from "./variables.ts";

/**
 * Bumped whenever this derivation changes what it produces, so a stored document
 * can be attributed to the code that made it. Independent of the contract version:
 * the shape can stay at v2 while the mapping into it improves.
 */
export const RESOLVER_VERSION = "v2-derive-1";

/** i18n key for a module's accessible name. See the header — these are not written yet. */
export function moduleLabelKey(id: string): string {
  return `modules.${id}.label`;
}

export type UpgradeOptions = {
  /**
   * Tier-1 seeds. Every name must be in `SEED_VARIABLES`; anything else is dropped,
   * because a "seed" a module could also write is not a seed.
   */
  seed?: Readonly<Record<string, VariableValue>>;
};

/**
 * Derive the v2 document. Pure, total, and it never throws: a resolver that fails
 * closed on an unexpected v1 document would take the whole screen down, and the
 * fallback path in `client.ts` exists precisely so it does not.
 */
export function toV2(v1: ExperienceConfig, options: UpgradeOptions = {}): ExperienceConfigV2 {
  const surfaces: SurfaceMap = {
    home: {
      modules: v1.home.modules.map(upgradeModule),
      quickLog: v1.home.quickLog,
    },
    /**
     * Empty means "the screen's own default", not "nothing". v1 cannot express any
     * of these, which is the gap rather than an omission here.
     */
    calendar: { modules: [] },
    learn: { collections: [] },
    tools: { featured: [] },
    insights: { modules: [] },
  };

  return {
    version: 2,
    resolvedAt: v1.resolvedAt,
    resolverVersion: RESOLVER_VERSION,

    track: v1.track,
    personaId: v1.personaId,
    modifiers: v1.modifiers,
    emotionalContext: v1.emotionalContext,
    confidence: v1.confidence,
    offer: v1.offer,
    transition: v1.transition,

    phase: v1.phase,
    content: v1.content,
    alerts: v1.alerts,
    emrView: v1.emrView,
    tone: v1.tone,

    surfaces,
    variables: seedScope(options.seed),
  };
}

/**
 * One v1 module becomes one v2 module. `params` is carried through untouched, and
 * `emphasis` and `id` are the same values — so a renderer reading v2 shows the same
 * modules in the same order, which is what makes the flag flip safe to reverse.
 */
function upgradeModule(m: ExperienceConfig["home"]["modules"][number]): ModuleSpecV2 {
  return {
    id: m.id,
    emphasis: m.emphasis,
    ...(m.params === undefined ? {} : { params: m.params }),
    a11y: { labelKey: moduleLabelKey(m.id), role: "region" },
  };
}

/**
 * Every seed name present, unknown names dropped, missing ones null.
 *
 * Null rather than absent so a module reacting to `cycleDay` before it is known
 * finds the name declared and the value empty — `validateWiring` treats an absent
 * name as dead wiring, and a woman with no logged cycle yet should not produce an
 * invalid document.
 */
function seedScope(seed: UpgradeOptions["seed"]): Readonly<Record<string, VariableValue>> {
  const scope: Record<string, VariableValue> = {};
  for (const name of SEED_VARIABLES) {
    scope[name] = seed?.[name] ?? null;
  }
  return scope;
}

/**
 * Derive and check in one step, for the resolver's write path.
 *
 * Returns the document and any wiring problems rather than throwing. A derived
 * document should never have problems — nothing here sets `reactsTo` or `writes` —
 * so a non-empty list means the mapping itself has a bug, and the caller should log
 * it and still serve v1 rather than fail the request.
 */
export function toV2Checked(
  v1: ExperienceConfig,
  options: UpgradeOptions = {},
): { config: ExperienceConfigV2; problems: ReturnType<typeof validateWiring> } {
  const config = toV2(v1, options);
  return { config, problems: validateWiring(config) };
}
