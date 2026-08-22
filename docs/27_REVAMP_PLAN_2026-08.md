# 27 — Revamp Plan (answers `docs/26`)

Status: **live** · Owner: Khaled · Supersedes the open parts of `docs/24` and `docs/25`
Rule: this document exists to be executed, not discussed. Every phase ends at a **checkpoint** —
`pnpm typecheck && pnpm test && pnpm build`, commit, push, deploy — so an interrupted session
never loses more than one phase.

## The one sentence

Femio becomes **the cycle companion that is honest about uncertainty and rich anyway** — the
thing neither Flo (paywalls basics, clutters home with articles) nor Clue (sparse) is, and the
only one that treats irregular cycles as a first-class case rather than a failure mode.

## Non-negotiables carried from `CLAUDE.md`

1. Wellness/education/tracking only — never diagnosis, never contraception.
2. **Personalize, never restrict.** Her stage is *highlighted*; everything else stays one tap
   away. This governs every layout decision below.
3. Uncertainty-honest — ranges and confidence, never a certain date, never a "late" counter.
4. Privacy-by-design; health data never reaches an ad or analytics SDK.
5. Constant EMR, additive layers.
6. Arabic/RTL first-class — logical properties only (`ms-`/`me-`/`start`/`end`), never `left-`/`right-`.

## Design rules this revamp adds (from `docs/26` §7)

- **Dense with tools and her own data, never dense with article cards.** Flo's clutter is the
  failure mode on the far side of ours; do not swap one for the other.
- **No pink-flowery defaults.** Discreet and functional. One accent per screen — today's
  dashboard runs a saturated purple hero against a hot-pink CTA and must not.
- **Inclusive copy and iconography.** No assumption of a male partner, no assumption every user
  identifies as a woman.
- **Every screen must earn its scroll.** A dashboard that fits one viewport is a bug.
- Judge on 390×844, light + dark, English + Arabic. A screenshot is the test.

---

## Phase 0 — Stop the bleeding (safety net first)

Nothing else is safe to build until CI can catch a regression.

- [ ] 0.1 `summary-screen.tsx:61` `prep` → `prep_json`. Restores `/summary`.
- [ ] 0.2 Replace the false "connection problem" copy with an honest error; surface the real
      failure to Sentry rather than blaming the user's network.
- [ ] 0.3 Repair the rotted selectors in the nine `@live` specs (6 radios not 4, 4 wizard steps
      not 3, radio not button).
- [ ] 0.4 Run the product specs in CI against a seeded Supabase project — remove the blanket
      `@live` exclusion. This is the single highest-value item in the plan.
- [ ] 0.5 Raise `Need help now?` above the consent list, or suppress it during onboarding
      (Sev-3 compliance defect, `docs/26` §3).
- [ ] 0.6 Add `NEXT_PUBLIC_CMS_URL` to `.env.example` + local setup notes so content pages stop
      rendering blind locally.
- [ ] 0.7 Screenshot regression: capture the six persona dashboards at 390×844 in CI.

**Checkpoint 0** → commit, push, deploy.

## Phase 1 — A dashboard that is a product

The core of the revamp. Target: **≥ 2.5 viewports of useful, personal content** on every persona.

- [ ] 1.1 **Cycle ring** — the category-defining component. Current day, predicted window as a
      *band* not a point, ovulation estimate, phase arc. Honest by construction: the band widens
      with uncertainty and renders as "unknown" rather than guessing for irregular cycles.
- [ ] 1.2 **Today card** — cycle day, phase, what is typical for her *today*, one action.
- [ ] 1.3 Kill the duplicate empty state (§2.1) and demote the "Everything else is still here"
      manifesto (§2.2) to a single quiet link.
- [ ] 1.4 **Fix the dead-end empty state** (§2.5): first-run asks "when did your last period
      start?" with a back-dated picker inline, not a `Log today` button she cannot use.
- [ ] 1.5 Calendar strip — last 30 days at a glance, tappable to log.
- [ ] 1.6 Retire the five `mode ===` branches; the module registry drives the screen, closing
      the R2 gap `docs/26` §4.1 found still open.

**Checkpoint 1** → commit, push, deploy.

## Phase 1b — She tells Femio what she already knows (owner direction, 2026-08-21)

Competitive check first, as instructed: **Flo and Clue both ask for the date her last period
began and how long her cycle usually is**, each skippable with a sensible default. Femio asks
neither — it asks a life stage, an age band and consent, then waits for two logged cycles before
saying anything useful. That is why the first run felt empty, and it is the root of R3.1.9: with
no stated baseline, every prediction is hostage to whatever rows happen to exist.

- [ ] 1b.1 **Ask her usual cycle length and period length in the wizard**, both skippable, both
      with a stated default rather than a hidden one. Store on `profiles`.
- [ ] 1b.2 **Use her stated length as the baseline until her own data is better.** Her answer
      seeds the first cycles; observed intervals take over once there are enough of them. The
      handover must be explicit in the maths and visible in the copy — she should never wonder
      which number she is looking at.
- [ ] 1b.3 **The knowledge base carries the formulas, not just the articles.** This was the
      owner's intent for it and it had been used only for prose. `fertile-window-explained.md`
      already cites **NHS: ovulation often falls 10–16 days before the next period** and ACOG on
      the fertile interval — so `phases.ts` stops carrying `[NEEDS SOURCE]` on invented numbers
      and cites those instead. It also means the current ±2 ovulatory window is **too narrow**:
      NHS describes a seven-day span, not five.
- [ ] 1b.4 **AI is explicitly out of scope for now.** Strict formulas only, sourced. Revisit as
      an enhancement once the deterministic version is right — a model cannot be audited against
      a golden fixture the way `predictNextPeriod` can.

## Phase 1c — The report she takes to a doctor (owner direction, 2026-08-21)

The visit summary exists and was broken until R3.0.1. It must become the artefact she can hand
over, exported as PDF, containing **everything she entered and everything Femio derived** — and
it must **distinguish the two on the page**. A clinician reading it has to know instantly which
numbers are observations and which are estimates; a report that blurs that is worse than no
report, because it launders a prediction into a record.

- [ ] 1c.1 Every logged category present: cycles, symptoms, medications, conditions, key dates,
      appointment questions, screener results.
- [ ] 1c.2 Every derived value present and **labelled as derived**: average length, predicted
      window, confidence, phase estimate, and whether the average came from her stated baseline
      or from observation (1b.2).
- [ ] 1c.3 Visual and structural separation of *recorded* from *calculated*, not a footnote.
- [ ] 1c.4 PDF export that survives print and carries the same distinction.

## Phase 2 — Navigation, and rescuing the orphans

- [ ] 2.1 Expand the 3-item nav. Settings leaves the primary bar.
- [ ] 2.2 Surface `/summary`, `/fertility`, `/appointments`, `/screeners`, `/medications` —
      five built, working, unreachable routes (§2.3).
- [ ] 2.3 A **Tools** hub: every calculator, screener and tracker in one place, always reachable
      regardless of persona (product rule 2).

**Checkpoint 2** → commit, push, deploy.

## Phase 3 — The insight engine (the biggest differentiator)

Research finding: *apps that educate about cycle phases deliver dramatically more value than
apps that only predict bleeding.* Femio does only the second, in prose.

- [ ] 3.1 **Phase education** — follicular / ovulatory / luteal / menstrual, what is happening,
      what is typical, what helps. Cited, reviewed, grade 6–8.
- [ ] 3.2 **Symptom ↔ cycle correlation.** `symptom_logs` has data and nothing reads it. Show her
      *her own* pattern — "your cramps cluster on days 1–3" — with honest confidence.
- [ ] 3.3 **End-of-cycle report** — table stakes at both competitors, absent here.
- [ ] 3.4 **Irregular-cycle mode as a feature, not an apology.** The evidenced wedge: neither
      incumbent serves this well. Pattern-finding and range guidance instead of a withheld number.
- [ ] 3.5 Custom symptom tracking (Clue's advantage; Femio has a fixed list).
- [ ] 3.6 Put `vitals` to work — still unused since Phase 1.

**Checkpoint 3** → commit, push, deploy.

## Phase 4 — Per-persona depth

**The ordering this phase was built on was wrong, and most of it dissolved on re-measurement.**

It was ranked by `docs/26` §5 — TTC 12 nodes, pregnancy 19, cycle 20 — and three of those numbers
were measurement artifacts, not product defects. §5's script never completed onboarding; checkpoint
1 inherited that; teen was measured against a contradictory age band; pregnancy was measured in its
*setup* state. Corrected numbers with coherent ages and populated data:

| Persona | Real measurement | Verdict |
|---|---|---|
| Postpartum | 3707 / 101 | rich |
| Menopause | 3593 / 143 | rich |
| Pregnancy *(due date entered)* | 1541 / 51 | healthy |
| Teen *(teen age band)* | 1501 / 35 | healthy |
| Cycle | 1440 / 85 | healthy |
| TTC | 844 / 17 | **the one real gap** |

- [x] 4.1 **TTC** — done (R3.4.1). 844 → **1646px**. The cause was not a missing feature: the cycle
      modules existed and Track C never asked for them, so her stage removed surfaces rather than
      re-emphasising them. Fixed as registry data.
- [x] 4.2 **Pregnancy** — **rationale void.** 1541px/51 nodes with a due date entered: trimester,
      week and day, days to go, full-term date. The "19 nodes" that justified this item was its
      setup screen. Week-by-week content exists; `fetal_movement_sessions` and `contractions` are
      built. Nothing here is a gap the audit found.
- [x] 4.3 **Teen** — **rationale void.** 1501px/35 nodes, leading with the "You're normal"
      reassurance A2 §B calls for. The 844px/6 that justified this item was a contradictory age
      band, not an empty persona.
- [x] 4.4 **Postpartum** — **rationale void.** 3707px/101 nodes, the richest screen in the product.
- [ ] 4.5 **Partner sharing** — genuinely open, and the only item here that was never about
      emptiness. Flo has it, Clue does not, and it needs a consent design before any code: it
      shares health data with a second person, which is a DPIA question and a `docs/13` question
      before it is a UI one. Carried into Phase 6's register rather than closed.

**Checkpoint 4** → done (commit `bab19aa`, Edge Function deployed, re-measured).

**The lesson this phase actually taught** is recorded in `docs/26` and `STATE.md`: five findings in
this workstream were measurement artifacts, all the same shape — a script driving the product
wrongly, with the result written up as a product defect. Phase 4 existed mostly because of three
of them.

## Phase 5 — Design direction (closes `docs/25`)

- [ ] 5.1 One accent per screen; resolve the purple-hero/pink-CTA clash.
- [ ] 5.2 Discreet, functional iconography — explicitly not pink-flowery.
- [ ] 5.3 Inclusive copy and icon pass.
- [ ] 5.4 Dark-mode and Arabic-RTL verification on every new component.
- [ ] 5.5 Grow `components/ui/` beyond 12 primitives; use the vendored `ui-ux-pro-max`
      accessibility and chart guidance, never letting it override `assets/brand/tokens/`.

**Checkpoint 5** → commit, push, deploy.

## Phase 6 — Cleanup (deliberately last)

Deleting before the rebuild risks removing something the rebuild needed.

- [ ] 6.1 Delete dead code and superseded docs per `docs/26` Part 3's inventory.
- [ ] 6.2 Fold `docs/24` and `docs/25` remnants into this plan; archive, never silently drop
      (MASTER_TODO covenant).
- [ ] 6.3 Re-audit: re-run Part 1's measurements and record the before/after.

**Checkpoint 6** → commit, push, deploy.

---

## Definition of done for every item

Documented in the same change · typecheck + tests + build green · screenshotted at 390×844 in
light, dark and Arabic · no `mode ===` branch introduced · no health data to any analytics SDK ·
no medical claim without a Tier-1/2 citation or a `[NEEDS SOURCE]` flag.
