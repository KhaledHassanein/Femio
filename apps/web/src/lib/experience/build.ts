/**
 * `buildExperienceConfig` — the resolution becomes a document (R2.2, ADR-061).
 *
 * Pure and dependency-free on purpose: this is tier 1 in `docs/24` §1, so it has
 * to lift into a Supabase Edge Function unchanged. No React, no Supabase, no
 * `next/*`, no clock — `resolvedAt` is passed in so the output is deterministic
 * and testable.
 *
 * ## The composition rules, and where each one comes from
 *
 * 1. **Layers add; they never replace.** D3/D4/D7 all say the D1 experience stays
 *    "completely intact and foregrounded". So a layer's modules are merged onto the
 *    base by id — a matching id is *upgraded*, never dropped.
 * 2. **Most-acute emphasis wins the hero** (`docs/09` §8 rule 2). Exactly one hero
 *    survives, and `docs/25` §5a allows exactly one raised element per screen.
 * 3. **Safety layers merge, never double-count** (`docs/09` §8 rule 1). Alerts are
 *    unioned by id.
 * 4. **Tone is the most protective of any applicable layer** (invariant 7). An
 *    anxiety-aware layer switches celebration off and it cannot be switched back on
 *    by a clinical layer stacked beside it.
 * 5. **Nothing is ever removed.** There is no code path here that subtracts a
 *    module, a tool or an alert, and the type could not express it if there were.
 */

import type { Resolution } from "@/lib/persona/resolver";
import type {
  AlertSpec,
  Emphasis,
  ExperienceConfig,
  LogKind,
  ModuleSpec,
  PersonaRecord,
  Phase,
  Tone,
} from "./types";
import { EXPERIENCE_CONTRACT_VERSION } from "./types";

const EMPHASIS_RANK: Record<Emphasis, number> = { secondary: 0, primary: 1, hero: 2 };

/** Registry lookup, injected so this stays pure and the caller owns the data. */
export type Registry = {
  find(id: string): PersonaRecord | undefined;
};

export function registryOf(records: readonly PersonaRecord[]): Registry {
  return { find: (id) => records.find((r) => r.id === id) };
}

/**
 * Walk `extends` from the base up to the persona itself.
 *
 * Returns base-first so later layers merge on top. A cycle would hang the loop, so
 * it is bounded by the records already seen rather than by a magic depth number.
 */
function chain(personaId: string, registry: Registry): PersonaRecord[] {
  const out: PersonaRecord[] = [];
  const seen = new Set<string>();
  let current = registry.find(personaId);
  while (current && !seen.has(current.id)) {
    seen.add(current.id);
    out.unshift(current);
    current = current.extends ? registry.find(current.extends) : undefined;
  }
  return out;
}

/**
 * Merge a layer's modules onto the accumulated list.
 *
 * A module already present keeps its position and takes the **higher** emphasis,
 * with params shallow-merged — so D7 adding `strip.thyroid` beside D1's week card
 * changes nothing about the week card, and a layer that raises an existing module
 * promotes it rather than duplicating it.
 */
function mergeModules(
  base: readonly ModuleSpec[],
  layer: readonly ModuleSpec[],
): ModuleSpec[] {
  const out = base.map((m) => ({ ...m }));
  for (const incoming of layer) {
    const existing = out.find((m) => m.id === incoming.id);
    if (!existing) {
      out.push({ ...incoming });
      continue;
    }
    if (EMPHASIS_RANK[incoming.emphasis] > EMPHASIS_RANK[existing.emphasis]) {
      existing.emphasis = incoming.emphasis;
    }
    if (incoming.params) existing.params = { ...existing.params, ...incoming.params };
  }
  return out;
}

/**
 * `docs/09` §8 rule 2. Keep the **last** hero declared — the chain is base-first,
 * so the most specific layer wins — and demote any earlier one to `primary` rather
 * than deleting it. D2 replacing D1's week card with a milestone is exactly this:
 * the week card stays on the screen, it just stops being the answer.
 */
function resolveHero(modules: ModuleSpec[]): ModuleSpec[] {
  const heroes = modules.filter((m) => m.emphasis === "hero");
  if (heroes.length <= 1) return modules;
  const winner = heroes[heroes.length - 1]!;
  return modules.map((m) =>
    m.emphasis === "hero" && m !== winner ? { ...m, emphasis: "primary" as const } : m,
  );
}

/**
 * A copy of the record whose modules never claim `hero`. Used when an emotional
 * layer is stacked *beside* a clinical persona rather than being the persona.
 * Demoted to `primary`, never dropped — nothing is ever removed.
 */
function demoteHero(record: PersonaRecord): PersonaRecord {
  const home: PersonaRecord["home"] = {};
  for (const [phase, modules] of Object.entries(record.home)) {
    home[phase as Phase] = (modules ?? []).map((m) =>
      m.emphasis === "hero" ? { ...m, emphasis: "primary" as const } : m,
    );
  }
  return { ...record, home };
}

/** Union by id — overlapping red-flag sets merge rather than double-count. */
function mergeAlerts(base: readonly AlertSpec[], layer: readonly AlertSpec[]): AlertSpec[] {
  const out = base.map((a) => ({ ...a }));
  for (const incoming of layer) {
    const existing = out.find((a) => a.id === incoming.id);
    if (!existing) out.push({ ...incoming });
    else if (incoming.params) existing.params = { ...existing.params, ...incoming.params };
  }
  return out;
}

function unique<T>(values: readonly T[]): T[] {
  return [...new Set(values)];
}

/**
 * Tone folds toward the more protective option, never away from it.
 *
 * `celebrationByDefault` and `countdown` are AND-ed, so any layer that turns them
 * off wins permanently — invariant 7 says loss suppresses celebratory content
 * "instantly… until she says otherwise", and a clinical layer merging in afterwards
 * must not undo that. `readingLevel` sticks at `gentle` for the same reason.
 */
function mergeTone(base: Tone, layer: Tone): Tone {
  const REGISTER_RANK: Record<Tone["register"], number> = {
    neutral: 0,
    warm: 1,
    vigilantReassuring: 2,
    anxietyAware: 3,
    gentle: 4,
  };
  return {
    register:
      REGISTER_RANK[layer.register] > REGISTER_RANK[base.register] ? layer.register : base.register,
    celebrationByDefault: base.celebrationByDefault && layer.celebrationByDefault,
    countdown: base.countdown && layer.countdown,
    readingLevel: base.readingLevel === "gentle" || layer.readingLevel === "gentle" ? "gentle" : "standard",
  };
}

export type BuildInput = {
  resolution: Resolution;
  /** Null when the track has no phase concept, or when it is not yet known. */
  phase: Phase | null;
  registry: Registry;
  /** Injected rather than read from a clock, so the output is deterministic. */
  resolvedAt: string;
  /**
   * Persona ids whose **tone and safety net** apply even though another persona won
   * the hero — derived by the caller from `resolution.emotionalContext`. `docs/09`
   * §8 rule 2 in practice: pregnancy + thyroid + prior loss is a D7 hero with the
   * D2 tone, not a D2 screen and not a shrug.
   */
  emotionalLayers?: readonly string[];
};

/**
 * Build the document a client renders.
 *
 * Returns a Z1-shaped minimum when the persona is unknown to the registry: the
 * generic experience is a first-class answer, not a failure (`docs/09` §5), so an
 * unregistered persona degrades to "everything, nothing assumed" rather than
 * throwing at a woman opening her app.
 */
export function buildExperienceConfig(input: BuildInput): ExperienceConfig {
  const { resolution, phase, registry, resolvedAt } = input;

  const layers = chain(resolution.personaId, registry);
  for (const id of input.emotionalLayers ?? []) {
    if (layers.some((r) => r.id === id)) continue;
    const record = registry.find(id);
    if (!record?.emotionalLayer) continue;
    /**
     * An emotional layer brings its **tone, support modules and safety net** — but
     * not its hero, unless it is the resolved persona in its own right.
     *
     * `docs/09` §8 rule 2 is worked through explicitly for this exact case:
     * pregnancy + thyroid + prior loss → *hero = pregnancy timeline; strips =
     * thyroid monitoring + PAL support; tone = anxiety-aware*. If D2's milestone
     * card took the hero here, a woman carrying a thyroid condition through a
     * pregnancy after loss would lose the clinical answer she opened the app for.
     * Caught by a test whose name disagreed with its own assertion.
     */
    layers.push(demoteHero(record));
  }

  let modules: ModuleSpec[] = [];
  let tools: LogKind[] = [];
  let alerts: AlertSpec[] = [];
  let emrView: string[] = [];
  let foreground: string[] = [];
  let skin = "general";
  let tone: Tone | null = null;

  for (const record of layers) {
    const contribution = phase ? (record.home[phase] ?? []) : [];
    modules = mergeModules(modules, contribution);
    tools = unique([...tools, ...record.tools]);
    alerts = mergeAlerts(alerts, record.alerts);
    emrView = unique([...emrView, ...record.emrView]);
    foreground = unique([...foreground, ...record.content.foreground]);
    // The most specific *non-emotional* layer names the skin: D2's tone travels,
    // but a woman carrying thyroid disease should still get the thyroid library.
    if (!record.emotionalLayer) skin = record.content.skin;
    tone = tone ? mergeTone(tone, record.tone) : record.tone;
  }

  modules = resolveHero(modules);

  return {
    version: EXPERIENCE_CONTRACT_VERSION,
    resolvedAt,
    track: resolution.track,
    personaId: resolution.personaId,
    modifiers: resolution.modifiers,
    emotionalContext: resolution.emotionalContext,
    confidence: resolution.confidence,
    offer: resolution.runnerUp,
    phase,
    home: {
      modules,
      quickLog: tools,
    },
    tools,
    content: { skin, foreground },
    alerts,
    emrView,
    tone: tone ?? {
      register: "neutral",
      celebrationByDefault: true,
      countdown: false,
      readingLevel: "standard",
    },
  };
}
