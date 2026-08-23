/**
 * The variable scope (RB-B4, `docs/29_REBUILD/03` §6).
 *
 * Flo's `output` / `onVariableChanged` pair lets one element write a value another
 * reads with no client wiring. This is ours, and it is narrower on purpose.
 *
 * ## Values, never expressions
 *
 * A variable holds `string | number | boolean | null`. There is no comparison, no
 * arithmetic, no template language. Conditions live in the resolver, where a
 * clinician can read them and a golden fixture can pin them.
 *
 * Flo's onboarding graph makes the same choice — 141 tags and no operators beyond
 * OR-within-an-entry — and that is precisely why non-engineers can author it. An
 * expression language in a served document is a second, unreviewed place where
 * medical logic can live, which ADR-061 exists to prevent.
 *
 * ## Two guarantees this module enforces
 *
 * **Seeded variables are read-only.** `cycleDay`, `phase`, `daysToPrediction` and
 * `confidenceBand` come from tier 1. A module that could write `cycleDay` would let
 * a renderer contradict a medical decision — the exact inversion ADR-060 forbids —
 * and it would do so invisibly, because the screen would still look right.
 *
 * **Every reference resolves.** A module reacting to a variable nothing declares is
 * dead wiring: it renders once and never updates, and no test notices because the
 * screen is not wrong, only frozen. `validateWiring` turns that into a failure at
 * resolve time.
 *
 * Portable: no framework, no data layer, so the Edge Function, the browser and the
 * Dart twin all agree on what a document means.
 */

import type { ExperienceConfigV2, ModuleSpecV2, VariableValue } from "./types.ts";

/**
 * Variables tier 1 seeds into every document. Modules read them; nothing writes
 * them.
 *
 * They are the values more than one module needs and none of them owns — the
 * cycle day the ring and the calendar both show, the confidence band the
 * prediction and its explanation both render.
 */
export const SEED_VARIABLES = [
  "cycleDay",
  "phase",
  "daysToPrediction",
  "confidenceBand",
] as const;

export type SeedVariable = (typeof SEED_VARIABLES)[number];

export function isSeedVariable(name: string): name is SeedVariable {
  return (SEED_VARIABLES as readonly string[]).includes(name);
}

/* ------------------------------------------------------------------ *
 * Validation
 * ------------------------------------------------------------------ */

export type WiringProblem =
  | { kind: "writes-seed"; moduleId: string; variable: string }
  | { kind: "reacts-to-unknown"; moduleId: string; variable: string }
  | { kind: "written-twice"; variable: string; moduleIds: readonly string[] }
  | { kind: "cycle"; moduleIds: readonly string[] };

/** Every module across every surface, in one list. */
function allModules(config: ExperienceConfigV2): readonly ModuleSpecV2[] {
  const { home, calendar, insights } = config.surfaces;
  return [...home.modules, ...calendar.modules, ...insights.modules];
}

/**
 * Check a document's wiring. Returns every problem rather than the first, because
 * a resolver that fixes one and re-runs is slower than one that sees all four.
 *
 * An empty array is the only acceptable result at resolve time.
 */
export function validateWiring(config: ExperienceConfigV2): readonly WiringProblem[] {
  const modules = allModules(config);
  const problems: WiringProblem[] = [];

  // Which names exist at all: tier-1 seeds, plus anything a module declares it writes.
  const declared = new Set<string>([...SEED_VARIABLES, ...Object.keys(config.variables)]);
  for (const m of modules) {
    if (m.writes !== undefined) declared.add(m.writes);
  }

  // 1. Nothing may write a seeded variable.
  for (const m of modules) {
    if (m.writes !== undefined && isSeedVariable(m.writes)) {
      problems.push({ kind: "writes-seed", moduleId: m.id, variable: m.writes });
    }
  }

  // 2. Every `reactsTo` must name something that exists.
  for (const m of modules) {
    for (const name of m.reactsTo ?? []) {
      if (!declared.has(name)) {
        problems.push({ kind: "reacts-to-unknown", moduleId: m.id, variable: name });
      }
    }
  }

  // 3. Two modules writing one variable is a race, and which wins depends on
  //    render order — which is to say, on nothing anybody chose.
  const writers = new Map<string, string[]>();
  for (const m of modules) {
    if (m.writes === undefined) continue;
    const list = writers.get(m.writes) ?? [];
    list.push(m.id);
    writers.set(m.writes, list);
  }
  for (const [variable, moduleIds] of writers) {
    if (moduleIds.length > 1) problems.push({ kind: "written-twice", variable, moduleIds });
  }

  // 4. A writes what B reacts to, and B writes what A reacts to: each change
  //    re-renders the other, forever. Cheap to detect here, miserable to diagnose
  //    on a device.
  const cycleModules = findCycle(modules);
  if (cycleModules.length > 0) problems.push({ kind: "cycle", moduleIds: cycleModules });

  return problems;
}

/**
 * Depth-first search over "module A's write is module B's dependency".
 *
 * Returns the modules on the first cycle found, or an empty array. One cycle is
 * enough: the document is invalid either way, and reporting every cycle in a
 * tangled graph is noise.
 */
function findCycle(modules: readonly ModuleSpecV2[]): readonly string[] {
  const byWrite = new Map<string, ModuleSpecV2>();
  for (const m of modules) {
    if (m.writes !== undefined) byWrite.set(m.writes, m);
  }

  const state = new Map<string, "visiting" | "done">();
  const stack: string[] = [];

  function visit(m: ModuleSpecV2): readonly string[] {
    const s = state.get(m.id);
    if (s === "done") return [];
    if (s === "visiting") return [...stack.slice(stack.indexOf(m.id)), m.id];

    state.set(m.id, "visiting");
    stack.push(m.id);
    for (const name of m.reactsTo ?? []) {
      const writer = byWrite.get(name);
      if (writer === undefined || writer.id === m.id) continue;
      const found = visit(writer);
      if (found.length > 0) return found;
    }
    stack.pop();
    state.set(m.id, "done");
    return [];
  }

  for (const m of modules) {
    const found = visit(m);
    if (found.length > 0) return found;
  }
  return [];
}

/* ------------------------------------------------------------------ *
 * Runtime
 * ------------------------------------------------------------------ */

export type VariableScope = Readonly<Record<string, VariableValue>>;

/**
 * Apply one `setVariable` action.
 *
 * Pure, and it refuses to write a seeded variable at runtime as well as at
 * validation time. Validation catches an authoring mistake; this catches a
 * document that reached a client without being validated — which will happen,
 * because the cached document in `client.ts` outlives the resolver that made it.
 */
export function setVariable(
  scope: VariableScope,
  name: string,
  value: VariableValue,
): VariableScope {
  if (isSeedVariable(name)) return scope;
  return { ...scope, [name]: value };
}

/**
 * Which modules must re-render after `changed` variables moved.
 *
 * A module with no `reactsTo` never re-renders from a variable change: the default
 * is static, and reactivity is opted into. That is the opposite of a store-driven
 * UI and it is deliberate — a served document should not be able to make the whole
 * screen thrash.
 */
export function modulesAffectedBy(
  modules: readonly ModuleSpecV2[],
  changed: readonly string[],
): readonly string[] {
  const changedSet = new Set(changed);
  return modules
    .filter((m) => (m.reactsTo ?? []).some((n) => changedSet.has(n)))
    .map((m) => m.id);
}
