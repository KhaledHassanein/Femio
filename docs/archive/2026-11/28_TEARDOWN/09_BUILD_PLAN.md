# 28.09 — Build plan

This chapter does not start a new roadmap. `docs/27_REVAMP_PLAN_2026-08.md` is the
live plan with phases 0–6, and `docs/25_DESIGN_DIRECTION_BRIEF.md` §2 explicitly
asks for "an honest competitor teardown" as step 1 of the R1 design workstream —
which is what chapters 02–04 are. **This study closes that step and feeds the rest.**

So what follows is a mapping: where each gap belongs in the existing plan, what is
genuinely new, and the order that respects the dependencies.

Per Khaled's direction of 2026-08-23, none of this is written into
`07_MASTER_TODO.md` yet.

---

## 1. Where the gaps land in `docs/27`

| `docs/27` phase | Gaps and differentiators it should absorb |
|---|---|
| Phase 0 — stop the bleeding | TD-16 (offline honesty in the UI) |
| Phase 1 — a dashboard that is a product | **TD-01 (charts)**, TD-02 (motion), TD-03 (module contract) |
| Phase 1b — she tells Femio what she knows | TD-09 (onboarding as narrative) |
| Phase 1c — the report she takes to a doctor | **D3 (visit pack)**, TD-05 (my questions) |
| Phase 2 — navigation, rescuing orphans | TD-14 (search), D6 (surfacing patterns) |
| Phase 3 — the insight engine | **D2 (interrogable confidence)**, D6, TD-06 (vocabulary) |
| Phase 4 — per-persona depth | TD-04 (wire the personas), **D7**, D8, D9 |
| Phase 5 — design direction, closes `docs/25` | TD-13 (tokens as a system), TD-02 |
| Phase 6 — cleanup | — |
| **Not yet in `docs/27`** | TD-07 (platform health), TD-08 / **D4 (Arabic content)**, TD-10 (remote config), TD-15 (widget), D1 (life timeline), D5 (privacy ledger), TD-11/TD-12 (community, assistant — decisions first) |

The last row is the useful output of this table: seven items the current plan has no
home for, three of which (**D4**, TD-07, TD-10) are large.

---

## 2. The dependency spine

Four things must happen in order, and everything else can be scheduled around them.

**First, the contract (TD-03).** Adding `accessibility`, `impressionConfig`, a typed
style slot and a visibility-animation slot to `ModuleSpec` is a versioned change to
`ExperienceConfig` with golden-fixture updates. Every module written before it is a
module that gets revisited — which is exactly the trap `CLAUDE.md` warns about for
pre-R2 screens. Do it before writing more modules, not after.

**Second, the visual foundation (TD-13 → TD-01 → TD-02).** Tokens before charts,
because chart colours belong in the token file. Charts before motion, because the
things worth animating are mostly state changes in charts and logging. And per Flo's
lesson, pick the numeric spacing scale now rather than migrating off a multiplier
scale later.

**Third, the vocabulary (TD-06).** Richer logging makes better patterns (D6) and
better charts have more to draw. Doing it after TD-01 means each new dimension
arrives with its visualisation.

**Fourth, Arabic content (TD-08 → D4).** Independent of all of the above and can run
in parallel from day one, because it is a content and CMS workstream, not an
engineering one. It is also the single highest-leverage item in the study, so it
should start first even though it finishes last.

---

## 3. Web and Flutter

The architecture rule (ADR-060/061) already answers most of this: the backend owns
decisions, the clients render. That means the split is clean.

**Tier 1 / shared — build once, both clients get it.** TD-03 (contract), TD-04
(persona registry), TD-06 (vocabulary), TD-09 (onboarding as a served document),
TD-10 (remote config), D2's confidence explanations, D6's pattern surfacing, D7's
condition-awareness. None of this is client work.

**Web-first — because the web app exists and is live.** TD-01 charts, TD-02 motion,
TD-13 tokens, TD-14 search, D1 timeline, D3 visit pack, D5 privacy ledger. Prove the
design language on the surface we can ship to today, then port.

**Flutter-only, and therefore gated on the mobile client existing.** TD-07 (Health
Connect / HealthKit — there is no web equivalent) and TD-15 (home-screen widget).

**A note on the charts decision.** TD-01 has to be answered twice — once for web and
once for Dart — and the two must agree visually. The safest shape given the twin-implementation
rule in `CLAUDE.md` is: chart *data* and *bands* computed in tier 1 and delivered in
the `ExperienceConfig` module params; chart *drawing* implemented per client against
shared tokens and bound by golden fixtures. That keeps anything medical — what
counts as a band, what confidence a window has — out of both renderers.

---

## 4. The migration lesson, applied

Chapter 02 §1 found Flo running native and served implementations of the same screen
side by side, switched by flag, one screen at a time. `docs/24` framed our equivalent
as a rewrite.

**Adopt the migration shape.** When a screen moves to the served experience engine,
keep the current implementation alive behind the same flag mechanism until the served
one is better on a 390×844 phone in light, dark and Arabic RTL. It removes the flag
day, it makes each screen independently revertible, and it means TD-01 and TD-02 can
land on served modules without blocking on every screen being converted first.

This depends on TD-10 (remote config) existing, which is the argument for pulling
TD-10 earlier than its tier-2 ranking suggests.

---

## 5. Suggested sequence

Not a schedule — an order. Each block assumes the previous one landed.

**Block 1 — foundations.** TD-03 contract. TD-13 tokens. Start TD-08/D4 Arabic
content in parallel and keep it running throughout.

**Block 2 — the surface Khaled asked for.** TD-01 charts across every track that has
data. TD-02 motion vocabulary and logging confirmations. TD-16 offline honesty.
This block is what makes the product feel like a 2026 product.

**Block 3 — depth.** TD-06 vocabulary. D6 patterns surfaced. D2 interrogable
confidence. TD-14 search.

**Block 4 — the clinician bridge.** TD-05 pregnancy tools, "my questions" first.
D3 visit pack. This is `docs/27` Phase 1c, finished.

**Block 5 — the taxonomy pays off.** TD-04 wire the remaining personas. D7
condition-awareness. D8 teen mode. D9 the difficult transitions.

**Block 6 — infrastructure and mobile.** TD-10 remote config and experiments — or
earlier, per §4. TD-07 platform health. TD-15 widget. D1 life timeline. D5 privacy
ledger.

**Decisions, not blocks.** TD-11 (community) and TD-12 (assistant) need owner
direction before they need engineering. Both belong in `docs/05`.

---

## 6. Definition of done, inherited

`docs/27` already sets this and it holds unchanged here: every item is judged on a
390×844 phone viewport, in light and dark, and in Arabic RTL, with a screenshot as
the test. Add one clause from this study — **every new served module ships with its
accessibility metadata and its impression config populated**, because the whole point
of TD-03 is that those stop being optional.

---

## 7. What this study cannot tell us

Recorded so nobody over-trusts it.

We never ran these apps. Everything about *feel* — how the animations time, how the
navigation flows, whether the dashboards actually read well — is inferred from
assets and structure. Chapter 06's motion and dashboard rows are the ones most worth
checking against a real device before committing a design direction.

Flo's server-delivered content, layouts and copy were not fetched, so every count in
Flo's column is a floor.

And none of this measures whether users like any of it. Three shipped apps tell us
what is buildable and what the market has settled on; they do not tell us what
Femio's users want. `docs/02` and the manual test plan remain the place that question
gets answered.
