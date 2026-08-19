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

import type { Track } from "../persona/resolver.ts";

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
  // ---- Track A — adolescent (R2.5c)
  | "teen.reassurance"
  | "teen.window"
  | "teen.worthMentioning"
  | "teen.body"
  | "teen.readiness"
  | "teen.privacy"
  // ---- Track B — cycle & gynae (R2.8)
  /**
   * Two window modules, not one with a flag. `cycle.window` is a prediction with
   * its confidence attached; `cycle.variability` is her own cycle lengths and, when
   * they cannot support a window, the sentence saying so. Whether Femio is willing
   * to predict at all is a tier-1 decision (`docs/24` §5), so it is expressed as
   * *which module the record contributes* rather than as a `predict: false` param —
   * the same shape as A1 contributing no window at all.
   */
  | "cycle.window"
  | "cycle.variability"
  | "cycle.phase"
  | "cycle.flowStrip"
  | "cycle.personalNormal"
  | "cycle.changeAwareness"
  // ---- Track C — trying to conceive (R2.11)
  /**
   * `ttc.window` is awareness, not a verdict: `lib/fertility` has no `isFertile`
   * and never will, so this module surfaces her own logs and the dates she can
   * plan around — never "days you could avoid", which is the contraception line
   * and the medical-device line in one step.
   */
  | "ttc.window"
  | "ttc.logSummary"
  | "ttc.workup"
  | "ttc.conditionContext"
  // ---- Track F — perimenopause & menopause (R2.9)
  /**
   * `menopause.trend` is what replaces the ring `docs/25` §5a rejects: her recent
   * cycle lengths, with skipped cycles drawn rather than left as gaps, and no
   * endpoint marked. Nothing in this track may draw progress toward twelve months —
   * a bar filling toward the marker reads as a countdown to a diagnosis (ADR-042).
   */
  | "menopause.trend"
  | "menopause.since"
  | "menopause.marker"
  | "menopause.symptomStrip"
  | "menopause.longTerm"
  /** The only danger surface in Track F, and it carries no phone number. */
  | "menopause.pmb"
  | "mrs"
  | "medications"
  | "gsm"
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
  // ---- postpartum condition follow-up (E4, E7)
  | "followup.schedule"
  | "thyroid.watch"
  // ---- emotional / support
  | "support.checkIn"
  | "support.moodScreener"
  | "support.moodSupport"
  | "support.intrusiveThoughts"
  | "support.feeding"
  | "support.breastSymptoms"
  | "support.lossAware"
  | "support.reassurance"
  // ---- shared
  | "quickLog"
  | "library"
  /**
   * Hidden-but-reachable, given a surface. Every B and F spec repeats the principle
   * in its §I, and today it is true of the router and invisible on the screen — a
   * product rule with no UI is a claim rather than a property.
   */
  | "explore"
  | "visitPrep"
  | "privacy";

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
  | "mood"
  /**
   * The two kinds that shipped as screens before they existed here (R2.10a).
   *
   * `/fertility` (P2.1) and the feeding surfaces (P2.3) are built and reachable,
   * and neither could ever be *surfaced by the engine*: a persona cannot ask for a
   * logger the contract has no word for. So the TTC dashboard reaches its own
   * screen through a `mode === "ttc"` button — the last shape of the defect
   * `docs/23` opened this workstream with, surviving in the one place the engine
   * could not see.
   *
   * They are added here, alone, and deliberately ahead of the registries adopting
   * them: which personas *surface* a logger is a persona decision that belongs in
   * `registry/`, and inventing the vocabulary inside a screen is exactly what
   * `native-readiness-lint` exists to catch. A kind with no record offering it
   * costs nothing and is visible; a screen inventing one is invisible.
   *
   * `feeding` is scoped by E2 §E and must stay so: her feeding, her breasts, her
   * body. It is not a baby tracker, and a `LogKind` is where that could quietly
   * stop being true.
   */
  | "fertility"
  | "feeding";

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
  /**
   * Modules contributed per phase, merged onto the base by id.
   *
   * `default` is what a track with **no phase concept** contributes — Track A has
   * no gestational age and no trimester, and filing its modules under a Track-D
   * phase name to make the lookup work would be a lie in a data structure. It is
   * used only when the phase is null or the record has nothing for that phase, so
   * Track D behaves exactly as before.
   */
  home: Partial<Record<Phase, readonly ModuleSpec[]>> & {
    default?: readonly ModuleSpec[];
  };
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
  /**
   * A universal transition Femio would suggest (`docs/09` §6–§7, P1.27.6) —
   * a positive test, a pregnancy that has ended, a postpartum period that has
   * passed. Separate from `offer` because they are different claims: `offer`
   * says *we could tailor this*, `transition` says *something in your record
   * changed*. Both are suggestions and neither is ever applied on its own
   * authority (invariant 3).
   */
  transition: { id: string; to: Track; personaId: string } | null;

  phase: Phase | null;
  home: { modules: readonly ModuleSpec[]; quickLog: readonly LogKind[] };
  tools: readonly LogKind[];
  content: ContentSkin;
  alerts: readonly AlertSpec[];
  emrView: readonly string[];
  tone: Tone;
};
