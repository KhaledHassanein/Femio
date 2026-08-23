/**
 * `ExperienceConfig` v2 — the served contract (RB-B1, `docs/29_REBUILD/03`).
 *
 * v1 in `../types.ts` is untouched and still authoritative. The resolver emits
 * both; `feature_flags` decides per surface which one a client reads
 * (`docs/29_REBUILD/03` §5). Nothing reads v2 yet.
 *
 * ## What v2 is for
 *
 * v1's `ModuleSpec` is `{ id, emphasis, params? }`. Three fields. A served module
 * can therefore ship with no accessible name, and the contract can express a home
 * screen and nothing else — no calendar panel, no learning collections, no tool
 * ordering, which is what OD-10 asks for.
 *
 * The shape is Flo's element envelope (`docs/28` chapter 02 §2), narrowed in three
 * ways that matter.
 *
 * ## Rule 1 — every human-readable field is a key, never a string
 *
 * Flo ships rendered strings because it serves one language and translates at
 * runtime. We serve four and translate at build time, so a rendered string in a
 * served document **cannot be shown to an Arabic reader**. There is no exception
 * to this and it is why our envelope is safer than theirs.
 *
 * ## Rule 2 — the server gets `emphasis` and nothing else presentational
 *
 * Flo carries a typed `style` object per element because its server composes
 * arbitrary layouts. Ours does not: a module id maps to a component that owns its
 * appearance from `assets/brand/tokens/`. Keeping design authority in the token
 * file is `docs/12`, and a served style object would quietly move it to a server.
 *
 * ## Rule 3 — measurement is first-party, and modules are not tracked by default
 *
 * **This is a correction to `docs/29_REBUILD/03` §2, made while implementing it.**
 *
 * That section borrowed Flo's `impressionConfig` and said a served module must
 * carry a typed analytics event so it "cannot ship untracked". Checked against our
 * own code, that is not possible and should not be:
 *
 * - `lib/analytics/events.ts` carries eight deliberately coarse events.
 *   `signup_completed` omits `mode` because "life-stage is health data";
 *   `calculator_used` omits which calculator because due-date implies pregnancy.
 * - `lib/analytics/guard.ts` blocks `cycle`, `mood`, `persona`, `symptom`,
 *   `pregnan` and `menopaus` as property tokens **at runtime**.
 *
 * So an impression event naming `cycle.window` would be dropped by our own guard,
 * and rightly — it is the health inference the schema is engineered to withhold.
 * Flo can measure per-module engagement because it runs AppsFlyer, Firebase and
 * TikTok Ad Manager. Product rule 4 says we do not.
 *
 * `measure` below is therefore **first-party only, optional, and off by default**.
 * It cannot name a PostHog event because the type gives it nowhere to put one.
 */

import type { Track } from "../../persona/resolver.ts";
import type {
  AlertSpec,
  ContentSkin,
  Emphasis,
  LogKind,
  ModuleId,
  Phase,
  Tone,
} from "../types.ts";

export const EXPERIENCE_CONTRACT_VERSION_V2 = 2 as const;

/* ------------------------------------------------------------------ *
 * Leaf types
 * ------------------------------------------------------------------ */

/**
 * Motion tokens, named to match the `--motion-*` custom properties C2 adds.
 * Declared here first so the contract can reference motion before the CSS lands;
 * a module asking for an animation that does not exist yet degrades to none.
 */
export type MotionToken = "instant" | "quick" | "standard" | "deliberate" | "none";

/** Values a module may read from or write to the shared variable bag (§6). */
export type VariableValue = string | number | boolean | null;

/**
 * Routes a served action may navigate to. A closed union on purpose: the server
 * must not be able to express a destination the client does not implement, which
 * is the failure mode of every open-ended server-driven UI.
 */
export type AppRoute =
  | "dashboard"
  | "track"
  | "calendar"
  | "tools"
  | "learn"
  | "insights"
  | "patterns"
  | "screeners"
  | "summary"
  | "appointments"
  | "medications"
  | "fertility"
  | "settings";

/** Bottom sheets the client knows how to open. Closed for the same reason. */
export type SheetId =
  | "log-period"
  | "log-symptoms"
  | "log-mood"
  | "log-discharge"
  | "log-vital"
  | "explain-prediction"
  | "cycle-details";

/**
 * Everything on the Tools screen. See `SurfaceMap.tools` — this orders, never filters.
 *
 * **Read from `components/tools/tools-screen.tsx`, not invented.** The first draft of
 * this union guessed, and guessed wrong in six places: it listed `contraction-timer`,
 * `movement-counter` and `weight`, which are controls inside the pregnancy experience
 * rather than tools with routes, and it omitted `track`, `sharing` and `learn`, which
 * are three of the ten that exist.
 *
 * `scripts/tools-completeness-lint.mjs` now fails if this union and that screen ever
 * disagree, in either direction — a tool the union does not know cannot be ordered,
 * and a tool the screen has dropped cannot be found.
 */
export type ToolId =
  | "summary"
  | "track"
  | "medications"
  | "appointments"
  | "sharing"
  | "patterns"
  | "fertility"
  | "screeners"
  | "calculators"
  | "learn";

/**
 * What a tap does. A closed union, so a served document cannot ask for behaviour
 * that does not exist.
 */
export type ActionSpec =
  | { kind: "navigate"; route: AppRoute; params?: Readonly<Record<string, string>> }
  | { kind: "log"; logKind: LogKind }
  | { kind: "openSheet"; sheet: SheetId }
  | { kind: "openContent"; slug: string }
  | { kind: "setVariable"; name: string; value: VariableValue }
  | { kind: "dismiss"; scope: "module" | "pattern"; id: string };

/* ------------------------------------------------------------------ *
 * The module envelope
 * ------------------------------------------------------------------ */

/**
 * Accessible name and role. **Required** — this is the whole point of v2. A module
 * with no accessible name does not type-check, which turns a convention a
 * developer may remember into a constraint the compiler enforces.
 */
export type A11ySpec = {
  /** i18n key. Never a rendered string — see rule 1 in the file header. */
  labelKey: string;
  role?: "region" | "article" | "group" | "status";
  /** Set only where content changes without navigation, e.g. a prediction updating. */
  liveRegion?: "polite" | "assertive";
  descriptionKey?: string;
};

/**
 * First-party visibility measurement. Optional, off by default, and it cannot
 * carry an analytics event name — see rule 3 in the file header.
 *
 * When present, the client records that a module was visible for
 * `minVisibleMs` at `minVisibleRatio` **to our own store**, where health data is
 * permitted and k-anonymity already applies (`lib/insights`). It never reaches a
 * third-party sink.
 */
export type MeasureSpec = {
  /** Aggregate bucket in our own store. Not an event name, and never sent off-platform. */
  bucket: "module_seen";
  minVisibleMs?: number;
  minVisibleRatio?: number;
};

export type ModuleSpecV2 = {
  id: ModuleId;
  emphasis: Emphasis;
  params?: Readonly<Record<string, string | number | boolean>>;

  /** REQUIRED. See `A11ySpec`. */
  a11y: A11ySpec;

  /** Optional and first-party. See `MeasureSpec` and rule 3. */
  measure?: MeasureSpec;

  /** How it enters and leaves. Motion becomes a contract concern, not a per-screen choice. */
  visibility?: { enter?: MotionToken; exit?: MotionToken };

  /** Fires once, the first time she sees it. Replaces per-screen "seen once" client state. */
  onFirstAppearance?: ActionSpec;

  /** Variable names that should re-render this module when they change (§6). */
  reactsTo?: readonly string[];

  /** The variable name this module writes, if any. */
  writes?: string;

  /** Primary tap target. */
  action?: ActionSpec;
};

/* ------------------------------------------------------------------ *
 * Surfaces — OD-10
 * ------------------------------------------------------------------ */

/** A query the learn surface runs against the content corpus. Tags, not slugs. */
export type ContentQuery = {
  tags?: readonly string[];
  condition?: string;
  track?: Track;
  phase?: Phase;
  limit?: number;
};

export type CollectionSpec = {
  id: string;
  /** i18n key — rule 1. */
  titleKey: string;
  query: ContentQuery;
  layout: "carousel" | "grid" | "list";
  a11y: A11ySpec;
  measure?: MeasureSpec;
};

/**
 * Every surface the served document personalises.
 *
 * **`tools.featured` orders; it never filters.** The Tools screen shows every tool
 * in every persona — product rule 2 expressed in a type, and enforced by
 * `scripts/tools-completeness-lint.mjs` (RB-B6). A `featured` list shorter than
 * `ToolId` does not mean the rest are hidden; it means the rest come after.
 */
export type SurfaceMap = {
  home: { modules: readonly ModuleSpecV2[]; quickLog: readonly LogKind[] };
  /** The day-detail panel beneath the calendar grid (chapter 06 §2). */
  calendar: { modules: readonly ModuleSpecV2[] };
  learn: { collections: readonly CollectionSpec[] };
  tools: { featured: readonly ToolId[] };
  insights: { modules: readonly ModuleSpecV2[] };
};

/* ------------------------------------------------------------------ *
 * The document
 * ------------------------------------------------------------------ */

export type ExperienceConfigV2 = {
  version: typeof EXPERIENCE_CONTRACT_VERSION_V2;
  resolvedAt: string;
  /** Which resolver produced this, so a behaviour change is attributable. */
  resolverVersion: string;

  track: Track;
  personaId: string;
  modifiers: readonly string[];
  emotionalContext: readonly string[];
  confidence: number;
  offer: { personaId: string; confidence: number } | null;
  transition: { id: string; to: Track; personaId: string } | null;

  phase: Phase | null;
  content: ContentSkin;
  alerts: readonly AlertSpec[];
  emrView: readonly string[];
  tone: Tone;

  /** Replaces v1's single `home` + `tools`. See `SurfaceMap`. */
  surfaces: SurfaceMap;

  /** The shared bag `reactsTo` and `writes` operate on (§6). */
  variables: Readonly<Record<string, VariableValue>>;
};
