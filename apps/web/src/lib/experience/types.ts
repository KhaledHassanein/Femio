/**
 * The experience contract (R2, ADR-061, `docs/24` §2).
 *
 * The backend resolves what a woman should see; the clients render it. This file
 * is the vocabulary both sides agree on — and it is deliberately **pure data**: no
 * React, no Supabase, no `next/*`. It has to survive being lifted into a Supabase
 * Edge Function and, later, mirrored in Dart.
 *
 * ## The one property this file must never lose
 *
 * **Nothing here can express restriction.** There is no `hidden`, `blocked`,
 * `disabled`, `locked` or `available` field, and `tools` means *surfaced*, not
 * *permitted*. Product rule 2 — personalize, never restrict — becomes structural
 * rather than remembered, the same reasoning that kept a `result` column off the
 * movement-log schema (ADR-049) and a restriction field off `Resolution`
 * (ADR-057). Every Track-D spec says the same thing in its own words:
 * *"Hidden-but-reachable rule. Nothing is locked."*
 *
 * If a future feature genuinely needs to hide something, that is a product
 * decision requiring its own ADR — not a field added here.
 */

import type { Track } from "../persona/resolver";

/** Contract version. Clients refuse to render a document with a newer major. */
export const EXPERIENCE_CONTRACT_VERSION = 1;

/**
 * Where she is within a track. Track D reads this from gestational age; the specs
 * are explicit that "GA computes everything" (D1 §I), and D4 extends the same idea
 * before and after the pregnancy itself.
 */
export type Phase = "preconception" | "t1" | "t2" | "t3" | "postpartum";

/**
 * A renderable unit of the home screen, addressed by id.
 *
 * The indirection is the whole point: a client maps `id` to a component, so a new
 * persona ships as a **row of data** rather than a new branch in a screen. This is
 * what `mode === "pregnancy"` cannot do.
 */
export type ModuleId =
  // ---- D1 spine
  | "pregnancy.week"
  | "pregnancy.milestone"
  | "pregnancy.appointments"
  | "pregnancy.weight"
  | "pregnancy.movement"
  | "pregnancy.contractions"
  | "pregnancy.birthPrep"
  | "pregnancy.warningSigns"
  | "pregnancy.screeningPrep"
  // ---- clinical strips (additive, never replacing the spine)
  | "strip.glucose"
  | "strip.thyroid"
  | "strip.medication"
  | "strip.labs"
  | "strip.devices"
  // ---- emotional / support
  | "support.checkIn"
  | "support.lossAware"
  | "support.reassurance"
  // ---- shared
  | "quickLog"
  | "library";

/**
 * How loudly a module speaks. `hero` is the single answer she opened the app for;
 * `docs/25` §5a allows exactly one raised element per screen, so **at most one
 * module in a resolved config may be `hero`** — asserted by the tests.
 */
export type Emphasis = "hero" | "primary" | "secondary";

export type ModuleSpec = {
  id: ModuleId;
  emphasis: Emphasis;
  /** Opaque to the contract; the rendering client interprets it. */
  params?: Readonly<Record<string, string | number | boolean>>;
};

/** A tracker that is *surfaced*. Everything remains reachable from the library. */
export type LogKind =
  | "period"
  | "symptom"
  | "weight"
  | "glucose"
  | "medication"
  | "labs"
  | "movement"
  | "contractions"
  | "appointment"
  | "mood";

/**
 * Alert cadences and red-flag sets.
 *
 * `docs/09` §8 rule 1: overlapping safety layers are **merged, not double-counted**,
 * so red-flag sets carry an id and the union is taken by id.
 */
export type AlertSpec = {
  id: string;
  kind: "redFlag" | "cadence" | "milestone" | "education";
  /** Free-text is deliberately absent — copy lives in the i18n catalogs by id. */
  params?: Readonly<Record<string, string | number>>;
};

/**
 * Tone. Not decoration: `docs/09` invariant 7 makes emotional safety a rule, and
 * D2 §I is explicit that celebration and countdowns are **off by default** while
 * anxiety-aware mode is active.
 */
export type Tone = {
  register: "neutral" | "warm" | "vigilantReassuring" | "anxietyAware" | "gentle";
  /** Milestone/celebratory content is offered, never pushed. */
  celebrationByDefault: boolean;
  /** A countdown implies a finish line; D2 and F1/F2 both refuse one. */
  countdown: boolean;
  readingLevel: "standard" | "gentle";
};

export type ContentSkin = {
  skin: string;
  /** Content ids to foreground. Never a list of what to hide. */
  foreground: readonly string[];
};

/**
 * What one persona contributes.
 *
 * Layers rather than replacements: D3, D4 and D7 all `extends: "D1"` because each
 * spec says the D1 spine stays "completely intact and foregrounded" and the
 * clinical tools are *added*.
 */
export type PersonaRecord = {
  id: string;
  track: Track;
  /** The persona this one layers on. Resolved before merging; cycles are rejected. */
  extends?: string;
  /**
   * True when this persona's **tone and safety net apply even if another persona
   * wins the hero**. D2 is the case the taxonomy was built around: `docs/09` §8
   * rule 2 says the most-acute clinical emphasis takes the hero, while the
   * anxiety-aware tone and the loss-suppression net stay armed on top of it.
   */
  emotionalLayer?: boolean;
  /** Modules contributed per phase, merged onto the base by id. */
  home: Partial<Record<Phase, readonly ModuleSpec[]>>;
  tools: readonly LogKind[];
  content: ContentSkin;
  alerts: readonly AlertSpec[];
  /** Persona-specific EMR fields surfaced over the constant core (`docs/09` §3). */
  emrView: readonly string[];
  tone: Tone;
};

/**
 * The resolved document. Produced by tier 1, cached on device, rendered by the
 * clients. See `docs/24` §2 — this is the shape the whole revamp turns on.
 */
export type ExperienceConfig = {
  version: number;
  resolvedAt: string;

  track: Track;
  personaId: string;
  modifiers: readonly string[];
  emotionalContext: readonly string[];
  confidence: number;
  /** Z1's "want me to tailor Femio for X?" — offered, never applied (`docs/09` §5). */
  offer: { personaId: string; confidence: number } | null;

  phase: Phase | null;
  home: { modules: readonly ModuleSpec[]; quickLog: readonly LogKind[] };
  tools: readonly LogKind[];
  content: ContentSkin;
  alerts: readonly AlertSpec[];
  emrView: readonly string[];
  tone: Tone;
};
