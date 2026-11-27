# 24 — Revamp plan: the experience engine and the two-client architecture

**Status:** decided 2026-08-09 (ADR-060, ADR-061). Supersedes the packaging half of ADR-048.
Read `docs/23_STRATEGIC_REVIEW_2026-08-09.md` first — this document is the *how*; the *why* is
there.

This plan answers two questions with one mechanism:

1. **How do 73 personas become a product** instead of a document, given that personalization
   today is a `mode ===` comparison inside a React component?
2. **How do a web app and a Flutter app share one brain** without two implementations of
   anything medical?

The answer to both is: **the backend resolves the experience and returns it as a document; the
clients render it.** Personas stop being code. Medicine stops being duplicated.

---

## 1. The three tiers

| Tier | Where it runs | What it holds | Why there |
|---|---|---|---|
| **1 — Decisions** | Supabase Edge Function (Deno, TypeScript — today's modules reused verbatim) | persona resolution, experience configuration, alert and red-flag sets, content skin, screener scoring, transition detection | One implementation of anything medical. A Flutter client never re-implements a clinical rule. |
| **2 — Offline math** | Twin implementations, TS and Dart, bound by **shared golden fixtures both must pass in CI** | cycle prediction windows, gestational age, calendar geometry, band geometry | Must answer instantly and offline. Drift is prevented mechanically, not by discipline. |
| **3 — Rendering** | Each client, independently | UI, i18n, navigation, offline write queue, device concerns | Genuinely per-platform. This is the only layer Flutter re-writes. |

**Sizing, measured 2026-08-09.** `apps/web/src/lib` holds 4,592 lines, of which ~2,425 are
domain logic (`cycle`, `pregnancy`, `menopause`, `persona`, `calculators`, `ui/range-band`).
Roughly 900 of those must run offline and therefore become tier 2; the rest is tier 1. The
6,197 lines of components and 1,995 lines of routes are tier 3 and are *expected* to be
rewritten per platform — that is what a native app is.

---

## 2. The contract: `ExperienceConfig`

The document tier 1 returns. It is the machine-readable form of what every persona spec already
writes in prose in its **§E (feature set), §F (content modules), §G (tools/logs/alerts)** and
**§I (personalization rules → home config)**. `D7_pregnancy_thyroid.md` §I is the reference
example: a D1 week-by-week hero *plus* a thyroid strip, a quick-log row, trimester-varying
module order, and "hidden-but-reachable: nothing locked".

```ts
/** Versioned so a cached document from an older client is recognisable, never guessed at. */
type ExperienceConfig = {
  version: number;               // contract version; clients refuse to render a newer major
  resolvedAt: string;            // ISO — the client shows nothing about staleness, but logs it

  // --- who the resolver thinks she is (docs/09 §2) -------------------------
  track: "A" | "B" | "C" | "D" | "E" | "F" | "Z";
  personaId: string;             // "D7"
  modifiers: string[];           // ["thyroid", "pregnancy_after_loss"] — composable layers
  emotionalContext: string[];    // ["prior_loss", "waiting"] — tone inputs, never personas
  confidence: number;            // 0–1
  offer: { personaId: string; confidence: number } | null; // Z1's "want me to tailor this?"

  // --- the five outputs docs/09 §2 specifies, and ONLY these --------------
  home: {
    hero: HeroSpec;              // which hero, which tone, which clock
    modules: ModuleSpec[];       // ordered; each { id, emphasis, params }
    quickLog: LogKind[];         // the quick-log row
  };
  tools: LogKind[];              // which trackers are SURFACED (never which are permitted)
  content: { skin: string; foreground: string[]; readingLevel: "standard" | "gentle" };
  alerts: AlertSpec[];           // cadence + red-flag sets, merged not double-counted
  emrView: string[];             // which persona fields surface over the constant core
};
```

**Two properties this type must never lose.**

*It cannot express restriction.* There is no `hidden`, `blocked`, `disabled` or `available`
field, and `tools` is named "surfaced" for that reason. Product rule 2 — *personalize, never
restrict* — becomes structural rather than remembered, the same way `Resolution` in
`lib/persona/resolver.ts` already works and the movement log deliberately has no `result`
column. A test asserts the shape. If a future feature genuinely needs to hide something, that
is a product decision requiring its own ADR, not a field added here.

*Every module is addressable by id.* `ModuleSpec.id` is a registry key the client resolves to a
component. That indirection is the whole point: a new persona ships as a new **row of data**,
not a new branch in a screen.

---

## 3. How resolution flows

```
wizard answers ─┐
logged events ──┼─► signals (tier 1, from RLS-scoped Postgres)
DB state ───────┘        │
                         ▼
                  resolvePersona()          ← today's lib/persona/resolver.ts, moved
                         │
                         ▼
            buildExperienceConfig(resolution, persona registry)
                         │
                         ▼
          ExperienceConfig  ──► cached on device ──► client renders modules by id
```

**The persona registry is data.** Each persona contributes a JSON record derived from its spec's
§E/§F/§G/§I — hero, module order, surfaced tools, content skin, alert set, EMR fields, tone —
with modifier layers merged on top per `docs/09` §8 (union of safety layers; most-acute emphasis
wins the hero; distinct paths stay distinct). **This un-defers P0.23**, the machine-readable
persona export parked in July as "revisit before engineering handoff". This is that handoff.

**Re-resolution is event-driven, not once.** `docs/08` §1 says the resolver *"re-resolves
continuously"*. Tier 1 re-runs on the universal events of `docs/09` §6 — positive test, loss,
delivery, high mood screen, red-flag symptom, taking a break, mode toggled, age milestone — plus
on wizard re-entry and on a plain schedule. Every re-resolution writes an `adaptation_events`
row, which the schema has carried since v1 and which is what makes a transition reversible
rather than merely repeatable.

**Offline is a cache, not a fallback path.** The last `ExperienceConfig` is stored on device and
rendered unchanged when the network is gone. Tier-2 math (today's window, gestational age)
recomputes locally against it. Nothing medical is *decided* offline; what is decided is only
re-displayed. New logs continue to go through the existing IndexedDB queue, and re-resolution
happens when they flush.

---

## 4. Anti-drift: shared golden fixtures

Tier 2 is the only place the same rule exists twice, so it is the only place drift can happen —
and drift here means two clients disagreeing about a woman's health.

The mechanism: a directory of **plain JSON fixtures** (`fixtures/domain/*.json`), each an
`{ input, expected }` pair, versioned in this repo. The TypeScript suite loads them; the Dart
suite loads the same files. **Both runtimes fail CI on the same fixture.** New behaviour lands
as a new fixture before it lands as code in either language, so a Dart implementation cannot
quietly diverge and a TS change cannot quietly break the app.

The existing test suites are the seed: `predict.test.ts`, `calendar.test.ts`,
`pregnancy.test.ts`, `menopause.test.ts`, `movements.test.ts` and `calculators.test.ts` are
already table-driven, which is why this is a conversion rather than a rewrite.

---

## 5. What this retires, and what is repointed

**Retired — ADR-048's packaging plan.** `packages/tracker` and `apps/native` were designed so a
Capacitor build could mount the same React screens. With Flutter as the target, a shared React
screen package earns nothing. Marked `[DEPRECATED — approved 2026-08-09]` in the TODO, not
deleted, per the covenant.

**Repointed — `native-readiness-lint`.** Today it forbids server reads, `force-dynamic`, Server
Actions and `searchParams` in the tracker path. Under this architecture the tracker *should*
call the server, so the rule as written now contradicts the design. It becomes a guard on the
constraint that actually protects the product:

> **No medical decision logic inside a client component.** Thresholds, red-flag sets, persona
> rules, alert cadences and screener scoring live in tier 1 or tier 2 — never inline in a screen.

Same ratchet machinery, same "watch it fail before trusting it" rule, pointed at the thing worth
guarding. The web tracker regains the freedom to server-render where that is better for the web
product, which is now a first-class product in its own right.

**Kept, and worth keeping.** The P4.0 conversion to client-side reads plus `AuthGate` was good
work on its own merits — RLS stayed the security boundary, six routes became statically
prerendered, and the client-fetch pattern is what tier 3 wants anyway. The static-export proof
(`docs/20`, `docs/21`) stays as knowledge; `trailingSlash` and the `capacitor://` auth question
(P4.0.5) become moot under Flutter, which is a saving, not a loss.

---

## 6. Migration order — the app stays shippable throughout

Each step is independently valuable and independently revertible. **Nothing here is a big-bang
rewrite**, which is the failure mode this plan exists to avoid.

1. **Extract the registry for one track.** Encode Track D's personas (D1, D2, D3, D4, D7) from
   their specs into persona records. Data only — no code path consumes it yet.
2. **Build `buildExperienceConfig` as a pure function, in the web app, tested.** It takes
   today's `Resolution` plus the registry and returns an `ExperienceConfig`. Still running in
   the browser; still no behaviour change.
3. **Render the pregnancy dashboard from the config.** Replace `mode === "pregnancy"` with a
   module registry lookup. This is the proof: D3 and D4 must now differ on screen, and D7 must
   show a thyroid strip, without a new `if`.
4. **Move tiers 1 and 2 to the seam.** `buildExperienceConfig` and `resolvePersona` move to an
   Edge Function; the offline subset splits out with its fixtures. The web client starts
   consuming the endpoint and caching the result.
5. **Roll the registry across the remaining tracks** as R3 builds each stage's depth — including
   Tracks **A** and **E**, which have no mode today and are simply new registry rows once the
   engine exists.
6. **Flutter consumes the same endpoint and the same fixtures.** Tier-3 work only.

Steps 1–3 are the whole of R2 and prove the architecture on one life stage before anything is
moved. If step 3 does not visibly differentiate D3 from D4, the design is wrong and it is cheap
to find out there.

---

## 7. What this does not change

The six product rules, the eight guards, RLS as the security boundary, the consent ledger, the
crisis layer, the constant-EMR-with-additive-layers schema, the public content site and its SEO
engine, and the medical review gate. **The revamp is a change of where decisions live and how
personas reach the screen — not a change of what Femio is allowed to say.**
