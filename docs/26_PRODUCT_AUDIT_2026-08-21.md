# 26 — Product Audit, 2026-08-21

Status: **Part 1 of 3 — live** · Author: audit session 2026-08-21 · Owner: Khaled
Scope: the shipped web app, judged as the seed of a mobile product meant to compete with Flo.
Method: the app run locally against live Supabase EU, driven through real onboarding in
Chromium at 390×844, plus a structural read of the repo. Screenshots and request logs are the
evidence; nothing below is inferred from reading code alone.

Parts 2 and 3 (dark/RTL/per-persona screens; file-by-file criticism and the deletion
inventory) follow. The revamp plan is `docs/27`, and is deliberately not written until this
document is complete — the plan has to answer the audit, not run ahead of it.

---

## The verdict

Khaled's read is correct, and the numbers are worse than the impression. Femio is not a
women's health companion with a thin dashboard. It is **a content marketing site with a
tracking demo attached**, and the proportions in the repo say so plainly.

The single most damning measurement in this audit needs no interpretation:

| Screen | Rendered height at 390px |
|---|---|
| **Dashboard** (the product's home) | **844 px** |
| Settings | 5066 px |
| Screeners | 4327 px |
| Track | 2872 px |
| Public marketing home | 4933 px |

**The settings screen carries six times the content of the home screen.** The marketing page
about the app is nearly six times the app's actual home. A new user's dashboard fits inside
one phone viewport with vertical space to spare, and two of the five things on it are
duplicate empty states.

That is the whole finding. Everything below is detail.

---

## Severity 1 — Broken in production

### 1.1 The doctor-visit summary has never worked

`/summary` renders a red error box reading *"We couldn't load your summary. Nothing is missing
from your record — this is a connection problem."*

It is not a connection problem. The request returns HTTP 400 from PostgREST:

```
GET /rest/v1/appointments?select=prep%2Cdatetime&order=datetime.asc
{"code":"42703","message":"column appointments.prep does not exist"}
```

The column is `prep_json`, declared in `supabase/migrations/0001_schema_v1.sql:259`.
`apps/web/src/components/account/summary-screen.tsx:61` selects `prep`. A one-word drift
between code and schema has disabled an entire user-facing feature — and one that matters
disproportionately, because "bring this to your doctor" is a core promise of the positioning.

Two aggravating factors. The error copy **actively lies** to the user, blaming her connection
for a server-side schema fault, which will generate support load that points at the wrong
cause. And this is the export path a woman would use in a clinical setting, so it fails at the
exact moment the product claims to be most useful.

### 1.2 Half the e2e suite does not run, and has rotted

Nine of eighteen specs in `apps/web/e2e/` are tagged `@live` and excluded from CI by
`test:e2e:ci`: `admin`, `consent`, `mfa`, `offline`, `onboarding`, `sitemap`, `summary`,
`symptoms`, `track`.

That list is not peripheral. It is onboarding, tracking, symptoms, consent and the summary —
the actual product. The DB-free CI run covers marketing pages and legal text.

Worse, the excluded specs no longer pass. Driving `onboarding.spec.ts`'s own steps against the
running app fails: it clicks through three steps and expects the dashboard, but the wizard now
has **four**, and step one is a `radio` where `summary.spec.ts` still calls
`getByRole("button", { name: /tracking my cycle/i })`. The tests were written, excluded from
CI, and left to drift.

`summary.spec.ts` is the test that would have caught §1.1. It exists. It has never been run in
CI, and would fail on its selectors before it ever reached the assertion.

**This is the mechanism that let everything else in this audit happen.** There is no
functioning safety net on the product surface.

---

## Severity 2 — The dashboard is not a product

The screenshot of a fresh cycle-tracking user's dashboard shows, top to bottom:

1. `Your dashboard` + a `Cycle` badge
2. A purple hero card: **"Log a couple of periods to unlock insights."**
3. Grey body text: **"Log a period and it will show here."**
4. A pink `Log today` button
5. A white card: **"Everything else is still here"** — three lines explaining Femio's
   personalization philosophy, plus a link
6. A three-item bottom nav: Home · Track · Settings

### 2.1 Two empty states saying the same sentence

Items 2 and 3 are the same message written twice, stacked, separated by ~100px of nothing.
The largest, most colour-saturated element on the screen — the purple hero — is spent
telling her the product has nothing for her yet.

### 2.2 The biggest card on the home screen is a manifesto

"Everything else is still here" is product philosophy. It is the correct philosophy
(product rule 2, personalize-never-restrict) and it belongs in onboarding or an about page.
On the daily home screen it is **the single largest content block**, and it will say the same
thing on day 400. Nobody opens a cycle app daily to re-read its design principles.

### 2.3 A three-item navigation, one third of which is Settings

Home · Track · Settings. For comparison, Flo's primary navigation carries Today, Calendar,
Insights, and a chat/assistant surface, with content and community below them.

Femio devotes 33% of its primary navigation to configuration. Meanwhile `/summary`,
`/fertility`, `/appointments`, `/screeners` and `/medications` — five real routes with real
code behind them — are **unreachable from the navigation entirely**. They exist and are
orphaned. The app is bigger than its own nav admits, which is the worst of both worlds: the
work was done and the user cannot find it.

### 2.4 No cycle visualisation of any kind

There is no ring, no wheel, no calendar strip, no chart on the dashboard. The circular cycle
wheel is the defining interface of this entire product category — Flo, Clue, Natural Cycles
and Ovia all lead with one, because it answers "where am I" in a single glance without
reading. Femio answers it with a sentence of prose in a purple box.

`vitals` remains unused (noted in CLAUDE.md and still true). `charts` data exists in the
freshly-installed `ui-ux-pro-max` catalogue and is used nowhere.

### 2.5 The empty state does not solve its own problem

The dashboard says "log a couple of periods" and offers a button called `Log today`, which
logs *today*. A new user's periods are in the **past**. The one action offered cannot produce
the state the screen is asking for. Getting to useful output requires her to find `/track`,
then a calendar, then back-date entries — none of which the empty state mentions.

This is the highest-leverage broken flow in the product: it is the first thing every single
user sees, and it dead-ends.

---

## Severity 3 — Consent screen defects with compliance exposure

Onboarding step 3 of 4 ("Your privacy comes first") has two overlap bugs, captured in
`ob-3-start.png`:

- The floating **"Need help now?"** pill sits on top of the consent checkbox list, covering
  the text of *"Use my anonymized data to improve women's health research"* and obscuring the
  option below it.
- The sticky Back/Continue bar covers the final checkbox and the line *"You can change these
  anytime in Settings."*

On any other screen this is a layout bug. On the **granular consent screen** it is a
regulatory problem: GDPR Art. 7 requires consent be informed and specific, and a checkbox
whose label is physically covered by an unrelated floating button is not informed consent.
`docs/13` and the DPIA both lean on this screen as the evidence that consent is granular.
It should be treated as a compliance defect, not a cosmetic one.

(The dark circular badge at bottom-left in the screenshots is the Next.js dev-tools
indicator — a local artifact, not a product bug. Excluded from all findings.)

---

## Severity 4 — The proportions of the project

| Measure | Count |
|---|---|
| App source files (`apps/web/src`) | 289 |
| Documentation files (`docs/**.md`) | 245 |
| Persona specs | 73 |
| Public/marketing routes | 20 |
| Real app routes (excl. 2 admin + MFA) | **8** |
| `components/ui/` primitives | 12 |
| `components/dashboard/` files | **1** |

Documentation is at near parity with source. Twenty marketing routes serve eight product
routes. Seventy-three persona specifications — a genuinely large research asset — are served
by a single dashboard file of 298 lines, of which a substantial share is explanatory comment
rather than code.

### 4.1 The architecture rule is documented but not followed

`CLAUDE.md` states personas must reach the UI as a versioned `ExperienceConfig` through a
module registry, **"never as a `mode ===` branch"**, and R2 is recorded as complete.

`apps/web/src/components/dashboard/dashboard-screen.tsx` currently contains:

```
mode === "teen"        (line ~231)
mode === "pregnancy"   (line ~242)
mode === "postpartum"  (line ~252)
mode === "menopause"   (line ~268)
showsCyclePredictions(mode) && mode !== "ttc"
```

Five mode comparisons deciding what renders, in the file the rule most directly governs. The
`ExperienceConfig` is loaded, and then largely bypassed. The engine was built; the screen was
not moved onto it. Any claim that R2 closed this needs revisiting.

### 4.2 Comments have replaced product

The dashboard file's comments run to paragraphs, citing P1.28.4, R1.9a, ADR-057, ADR-041/043
and more. The reasoning is often genuinely good. But a 298-line file whose comments explain at
length why each of five sparse cards exists is a file that has been *argued about* far more
than it has been *built*. The energy went into justifying the surface rather than enlarging it.

---

## What is actually good (and must not be destroyed in the revamp)

Fairness matters here, because the revamp should keep these:

- **The medical honesty layer is real and differentiating.** "No 'you are 4 days late'",
  the confidence bands, the refusal to predict for irregular cycles — this is genuinely
  better than Flo and is defensible positioning.
- **The content exists and is live.** Production `/learn` serves real clinician-bylined
  articles; ~200 `/learn/` URLs in the sitemap. The local `/learn` renders empty only because
  `.env.local` lacks `NEXT_PUBLIC_CMS_URL` — a dev-environment gap, not a content gap. (It
  does mean all local UI work on content pages is currently done blind, which should be fixed.)
- **The persona research is a genuine asset.** 73 specs is a moat if it reaches the screen.
- **Privacy engineering is done properly** — anonymous-first onboarding, granular consent,
  EU hosting, a real processor register with signed DPAs tracked.
- **The marketing home page is competent.** Generic in styling, but structurally sound.
- **Dependency and security discipline is unusually strong** — per-advisory overrides,
  hand-triaged install scripts, audit exceptions with review dates.

The problem is not quality of thought. It is that almost none of it reaches a screen.

---

## Root cause

One sentence: **the project optimised for what could be written down rather than what could be
used**, and the absence of a working CI safety net on product routes meant nothing pushed back.

Documentation, persona specs, medical citations and ADRs all have a clean feedback loop — they
get written, reviewed, and marked done. Product surface has no such loop here: half the e2e
tests do not run, the dashboard has no visual regression check, and "done" is recorded in a
TODO rather than demonstrated on a screen. Given those incentives, the outcome was inevitable
and is not a matter of effort.

---

## Carried into the plan (`docs/27`)

Quick wins, one line each, to be scheduled rather than done here:

1. `summary-screen.tsx:61` — `prep` → `prep_json`. One word. Restores a whole feature.
2. Un-exclude the `@live` specs, repair their selectors, run them in CI against a seeded project.
3. Raise the "Need help now?" pill above the consent list, or suppress it during onboarding.
4. Replace `Log today` on the empty dashboard with a back-dated "when did your last period
   start?" entry point.
5. Expose the five orphaned routes in navigation.

The structural work — a real dashboard, a cycle visualisation, the module registry actually
driving the screen — is the body of `docs/27`.
