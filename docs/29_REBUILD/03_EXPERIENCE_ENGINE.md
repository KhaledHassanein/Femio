# 29.03 — The experience engine

This is the chapter everything else waits on. Chapter 06's screens are unbuildable
against the current contract, and every screen built against it is a screen that gets
rewritten.

Current state: `lib/experience` (2,909 lines) and `lib/persona` (2,100) resolve a
versioned `ExperienceConfig` through three sources — Edge Function, local cache, then
the identical tier-1 code in the browser. That resolution design is genuinely good
and has no analogue in any competitor. The contract it produces is thin.

---

## 1. The problem, precisely

```ts
export type ModuleSpec = {
  id: ModuleId;
  emphasis: Emphasis;
  params?: Readonly<Record<string, string | number | boolean>>;
};
```

Three fields. Flo's server-driven element envelope carries eleven, and the eight we
lack are not decoration:

| Flo field | What it prevents |
|---|---|
| `accessibility` | A served module shipping unlabelled |
| `impressionConfig` | A served module shipping untracked |
| `onFirstAppearance` | "Seen once" behaviour needing client state |
| `onVariableChanged` | Cross-module reactivity needing client code |
| `output` | A module writing a value another module reads |
| `visibilityAnimation` | Motion being a per-screen decision |
| `style` (typed per element) | The server sending a button style to a text node |
| `floatingMenu` | Contextual actions being hard-coded |

The two that matter most are the first two, because they turn a convention into a
constraint. Today a developer *may* remember an aria-label and an analytics event.
After this change, a module without them does not type-check.

---

## 2. `ExperienceConfig` v2

```ts
export const EXPERIENCE_CONTRACT_VERSION = 2;

export type ExperienceConfig = {
  version: 2;
  resolvedAt: string;
  resolverVersion: string;          // NEW — which resolver produced this

  track: Track;
  personaId: string;
  modifiers: readonly string[];
  emotionalContext: readonly string[];
  confidence: number;
  offer: { personaId: string; confidence: number } | null;
  transition: { id: string; to: Track; personaId: string } | null;

  phase: Phase | null;
  home: { modules: readonly ModuleSpec[]; quickLog: readonly LogKind[] };
  tools: readonly LogKind[];
  content: ContentSkin;
  alerts: readonly AlertSpec[];
  emrView: readonly string[];
  tone: Tone;

  surfaces: SurfaceMap;             // NEW — see §3
  variables: Readonly<Record<string, VariableValue>>;  // NEW — see §6
};
```

### The module envelope

```ts
export type ModuleSpec = {
  id: ModuleId;
  emphasis: Emphasis;
  params?: Readonly<Record<string, string | number | boolean>>;

  /** REQUIRED. A module with no accessible name does not compile. */
  a11y: {
    labelKey: string;                  // i18n key, never a rendered string
    role?: "region" | "article" | "group" | "status";
    liveRegion?: "polite" | "assertive";
    descriptionKey?: string;
  };

  /** REQUIRED. A served module cannot ship untracked. */
  impression: {
    event: AnalyticsEvent;             // from docs/19's schema, typed
    minVisibleMs?: number;             // default 1000
    minVisibleRatio?: number;          // default 0.5
  };

  /** Optional behaviour */
  visibility?: { enter?: MotionToken; exit?: MotionToken };
  onFirstAppearance?: ActionSpec;
  reactsTo?: readonly string[];        // variable names; re-render on change
  writes?: string;                     // variable name this module sets
  action?: ActionSpec;                 // primary tap target
};
```

Three deliberate departures from Flo's shape.

**`labelKey`, not `label`.** Flo ships a rendered string because it serves one
language and translates at runtime. We serve four and translate at build time — a
rendered string in the document cannot be shown to an Arabic user. **Every
human-readable field in this contract is a key.** This rule has no exceptions and it
is the reason our version of their envelope is safer than theirs.

**`impression.event` is typed against `docs/19`**, not a free string. An event name
that is not in the analytics schema is a compile error, which closes the gap where
analytics drifts from the product.

**No `style` object.** Flo needs one because its server composes arbitrary layouts.
Ours does not: a module id maps to a component that owns its own appearance from our
tokens. `emphasis` (primary / secondary / gentle) is the only presentational lever
the server gets. This is a smaller, safer contract than theirs, and it keeps design
authority in `assets/brand/tokens/` where `docs/12` puts it.

### `ActionSpec`

```ts
export type ActionSpec =
  | { kind: "navigate"; route: AppRoute; params?: Record<string, string> }
  | { kind: "log"; logKind: LogKind }
  | { kind: "openSheet"; sheet: SheetId }
  | { kind: "openContent"; slug: string }
  | { kind: "setVariable"; name: string; value: VariableValue }
  | { kind: "dismiss"; scope: "module" | "pattern"; id: string };
```

A closed union. The server cannot express an action the client does not implement,
which is the failure mode of every open-ended server-driven UI.

---

## 3. Surfaces — the thing OD-10 needs

Today `ExperienceConfig` personalises the home screen and the quick-log set. OD-10
asks for tools and learning resources surfaced per persona **with everything still
reachable in its original place** — which is product rule 2, and which the current
contract cannot express because it has one `home.modules` array and nothing else.

```ts
export type SurfaceMap = {
  home:     { modules: readonly ModuleSpec[]; quickLog: readonly LogKind[] };
  calendar: { modules: readonly ModuleSpec[] };   // the day-detail panel
  learn:    { collections: readonly CollectionSpec[] };
  tools:    { featured: readonly ToolId[] };      // ordering only — never filtering
  insights: { modules: readonly ModuleSpec[] };
};

export type CollectionSpec = {
  id: string;
  titleKey: string;
  query: ContentQuery;                 // tags, condition, life-stage, locale
  layout: "carousel" | "grid" | "list";
  a11y: ModuleSpec["a11y"];
  impression: ModuleSpec["impression"];
};
```

**`tools.featured` orders; it never filters.** The Tools screen shows everything,
always, in every persona. This is rule 2 expressed in a type, and it is worth a
lint: any code path that removes a tool from the tools list is a bug.

---

## 4. The vocabulary lives in tier 1

Chapter 02 §2 adds a `dimension` column. The canonical list of what may be logged is
a **tier-1 artefact**, not a client constant, because it is medical content and
because both clients must agree:

```ts
export type LogVocabulary = {
  version: number;
  dimensions: {
    symptom:     readonly LogTerm[];
    mood:        readonly LogTerm[];
    discharge:   readonly LogTerm[];
    intercourse: readonly LogTerm[];   // exactly one term — OD-5
    vital:       readonly LogTerm[];
  };
};

export type LogTerm = {
  key: string;                 // stable; never renamed
  labelKey: string;            // i18n
  clinicalName?: string;       // for the visit pack and the summary
  severityScale?: boolean;     // does 0..4 apply
  lifeStages: readonly Track[];// which tracks surface it by default
  sensitivity: "normal" | "elevated";  // drives sharing and discreet mode
};
```

`sensitivity: "elevated"` covers the intercourse marker and anything a shared device
should not reveal at a glance. `partner_links` sharing and `discreet_mode` both read
it, so the rule is written once.

**The intercourse dimension contains one term.** Its `labelKey` resolves to
conservative wording in all four languages, and OD-5 makes that a review item, not a
copy detail: a term that reads clinical in English and crude in Arabic fails.

---

## 5. Migration — per screen, behind a flag, no flag day

This is the teardown's most useful architectural finding. Flo ships
`CalendarScreenActivity` **and** `UicCalendarActivity` simultaneously and flips per
screen.

**Mechanism.** `feature_flags` (chapter 02 §7) with key `experience.v2.<surface>`.
The resolver writes both a v1 and a v2 document to `experience_documents`; the client
reads whichever the flag names.

**Per-surface sequence.**

1. Resolver emits v2 alongside v1. Nothing reads v2. Golden fixtures assert the v1
   output is byte-identical to before.
2. One surface's components are ported to the v2 envelope behind
   `experience.v2.home = false`.
3. Flag on for staff only. Judge it on 390×844, light and dark, Arabic RTL.
4. Flag on for everyone. The v1 path stays for one release, then is deleted.
5. Repeat per surface. When the last one flips, drop v1 from the resolver.

**Why this is materially cheaper.** No flag day. Each surface is independently
revertible. And chapters 05 and 06 can land on v2 surfaces while others are still v1,
so the chart and motion work does not queue behind a full conversion.

**It depends on `feature_flags` existing**, which is why chapter 02 §7 is scheduled
before any of this rather than in a later "infrastructure" phase.

---

## 6. Variables — the small piece that removes a lot of client code

Flo's `output` / `onVariableChanged` pair lets one element write a value another
reads, without client wiring. Ours, narrower:

```ts
export type VariableValue = string | number | boolean | null;
```

`config.variables` seeds the scope from tier 1 (cycle day, phase, days-to-prediction,
confidence band). A module declares `writes` to set one and `reactsTo` to re-render
on change.

Deliberately not a general expression language. Variables are values; conditions live
in the resolver where they can be reviewed. Flo's onboarding graph makes the same
choice — tags, no operators — and that is why non-engineers can author it.

---

## 7. Onboarding as data

TD-09 plus OD-6. The shape is Flo's, because it is right:

```ts
export type OnboardingDocument = {
  version: number;
  steps: Record<StepId, OnboardingStep>;
  transitions: readonly {
    in: StepId;
    out: StepId;
    condition?: readonly string[];   // tags, OR within an entry, AND across
    progress: number;                // precomputed, so a skipped branch is honest
  }[];
  presentation: { closable: boolean; showProgress: boolean; allowBack: boolean };
};
```

**What we take.** Tag conditions with no operators. Precomputed progress per edge. A
reason-for-asking subtitle on every question. "I don't know" as a first-class answer.
A recovery step when she cannot remember a date. The pre-permission primer before any
OS dialog.

**What we reject (OD-6).** Flo's ratio of 124 selling cards to 90 questions. The
social-proof stat cards. The donation cards. The tap-and-hold commitment ritual. The
three-layer goal interrogation. The paywall as terminus.

**The target shape**, taking Petal's card-stack economy and Flo's rhythm: **under
fifteen steps to a working dashboard**, one question per step, each carrying its
normal range as helper text where one exists, with an escape on every step. What
Femio needs to resolve a persona is far less than what Flo needs to segment a market.

Femio's Z1 fallback is the designed refusal path — it must be a real destination with
its own artwork, not an error state.

---

## 8. Wiring the remaining personas

TD-04. 73 specced, 24 registered. `build.ts` already has an `extends` chain, so a
persona differing from its parent by two modules is a ten-line record.

Two rules. **Every specced persona ends this work either registered or explicitly
deferred with a stated reason** — silence is what let two-thirds go unnoticed. And
`persona-branch-lint` should fail on a spec file with no registry record and no
deferral marker, so the gap cannot reopen.

---

## 9. What must not change

The three-source resolution in `client.ts` — Edge Function, cache, then identical
tier-1 code in the browser. It is the best engineering in the repository and it is
what lets tier 1 be authoritative without the app being unusable when the function is
undeployed.

`persona_state`'s guarantee: *"Never controls access — only emphasis."*

The tier-1/tier-2 split and the golden fixtures binding twin implementations. Every
new tier-1 artefact in this chapter — `LogVocabulary`, `predictions.basis_json`, the
onboarding document — needs fixtures before it has a second implementation.
