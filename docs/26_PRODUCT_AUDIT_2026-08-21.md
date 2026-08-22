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

---

# Part 2 — Every persona, and the competitive gap

## 5. Every persona dashboard is one viewport

Each life stage was driven through real onboarding and measured:

| Persona dashboard | Height | DOM nodes in `<main>` |
|---|---|---|
| Cycle | 844 px | 20 |
| **TTC** | 844 px | **12** |
| Pregnancy | 844 px | 19 |
| Menopause | 844 px | 137 |

Four personas, four identical viewport heights, because none of them has enough content to
scroll. **The TTC dashboard contains twelve DOM nodes.** A woman trying to conceive — the
highest-intent, highest-willingness-to-pay segment in this entire category — gets the emptiest
screen in the product.

Menopause at 137 nodes is the only dashboard with real substance, and it is the one built last.
That is the proof the team can build a rich screen when it decides to; it simply has not done
so anywhere else.

## 6. What competitors actually ship on the home screen

Flo's main screen leads with a **cycle ring** — a circular visualisation where the current day,
the predicted ovulation day and the post-ovulation days are each distinguished — plus the time
to fertile window, a persistent log affordance, and daily insight cards. Clue leads with
analysis views and custom tagging aimed at clinician conversations.

Femio leads with a sentence of prose in a purple box.

Feature-by-feature against what the category treats as table stakes:

| Capability | Flo | Clue | **Femio today** |
|---|---|---|---|
| Cycle ring / wheel | ✅ | ✅ | ❌ none |
| Calendar view on home | ✅ | ✅ | ❌ none |
| Cycle-phase education (follicular/luteal…) | ✅ | ✅ | ❌ none |
| Symptom↔cycle correlation | ✅ | ✅ | ❌ logs only, never analysed |
| Daily personalised insight | ✅ | ➖ | ❌ none |
| End-of-cycle report | ✅ | ✅ | ❌ none |
| Partner sharing | ✅ | ❌ | ❌ none |
| Custom symptom tracking | ➖ | ✅ | ❌ fixed list |
| Honest irregular-cycle handling | ❌ | ❌ | ✅ **only Femio** |
| No paywall on basics | ❌ | ➖ | ✅ **only Femio** |

## 7. The wedge, evidenced

Three consistent complaints about the incumbents define the opening:

1. **Neither Flo nor Clue handles irregular cycles well** — stated plainly in 2026 comparisons.
   This is precisely Femio's product rule 3 and its strongest existing asset. It is currently
   expressed only as *withholding* a prediction. It must become a **positive feature**:
   pattern-finding, range-based guidance, and PCOS/endometriosis-aware framing.
2. **Flo paywalls the basics** — users report current cycle state and hormone information moving
   behind premium, "every update taking one free feature away." Femio can hold these free
   permanently and say so.
3. **Flo's home screen is cluttered with articles and images; navigation is unclear.** This is
   the failure mode on the *other* side of Femio's. The target is a dense, *useful* home — tools
   and personal data — not a home stuffed with content cards. Femio's 20 marketing routes make
   this a live risk if the fix is "add article cards to the dashboard."

Two further findings worth designing against: women repeatedly criticise **pink, flowery
iconography** in favour of discreet, functional design — Femio currently pairs a saturated
purple hero with a hot-pink CTA on the same screen — and criticise **heteronormative and
cisnormative assumptions** in copy and icons.

The most valuable single insight from the research: *apps that educate about cycle phases and
help users plan accordingly deliver dramatically more value than apps that only predict when
bleeding starts.* Femio today does only the second thing, and does it in prose.

## 8. What is genuinely strong (verified, not assumed)

- **Arabic/RTL is properly built.** `/ar` renders `dir=rtl`, `lang=ar`, Arabic-Indic numerals
  (`١٣–١٥`), and zero Latin leakage in `<main>`. This is real i18n, not a translation veneer,
  and it is a moat in MENA that neither Flo nor Clue contests seriously.
- **Onboarding covers six life stages** including teen and postpartum — broader than Flo's entry.

## 9. Further test rot (compounding §1.2)

`onboarding.spec.ts` asserts `expect(options).toHaveCount(4)`. The wizard renders **six**
life-stage radios, plus an age-band step the test never touches. The assertion would fail today.
Combined with §1.2, the position is: the excluded half of the suite tests a product that no
longer exists.

---

# Part 3 — Pending

File-by-file criticism and the deletion inventory. Not yet written.

---

# Part 2b — Two product bugs the repaired tests exposed

Repairing the `@live` suite (R3.0.3) was supposed to be test maintenance. It surfaced two real
defects, which is the argument for the repair in one line.

## 10. Offline sync reached the database and never reached the screen

`OfflineSync` flushed the queue and called `router.refresh()`. That re-runs **server**
components — and every tracker screen moved to the client-side `useSupabaseQuery` hook in
P4.0/ADR-048. Nothing re-read.

A period logged offline was therefore written to Supabase correctly and stayed invisible behind
*"No periods logged yet"* until the user manually reloaded. To someone who had just recorded her
period, that is indistinguishable from having lost it — on the single screen where that
misreading is least forgivable, in an app whose pitch is that her record is safe.

Fixed by emitting a `femio:offline-flushed` event that `useSupabaseQuery` listens for, so every
client-side screen re-reads rather than just the tracker. `router.refresh()` is kept for any
server-rendered surface that remains.

## 11. Analytics consent fails silently for anyone who skipped the age question

`isMinor(null)` returns `true` (`lib/persona/minor.ts:43`) — unknown age is treated as a child.
That is the correct fail-closed default and should not change.

But onboarding offers **"Skip — I'm not sure"** on the age step, so `age_band: null` is a
reachable, ordinary state. For that user, `consent/actions.ts:69` refuses every analytics or
research grant with `not_permitted_for_age` — and that string is returned and **consumed nowhere
in the codebase**. The Settings toggle therefore appears, is tappable, does nothing, and explains
nothing. Forever.

Two problems, one of them compliance-adjacent: a control that cannot work should not be offered,
and GDPR Art. 7(3) reasoning about withdrawal being as easy as granting sits awkwardly beside a
grant that fails in silence. **Not fixed here** — logged as R3.0.8, because the fix is a UX
decision (hide the toggle, explain the refusal, or offer to set an age) rather than a bug with
one obvious repair.

## 12. The `@live` tag was doing two jobs

One tag meant both "needs live Supabase" and "needs a live CMS". Excluding it from CI to avoid
the CMS dependency therefore also excluded onboarding, tracking, symptoms, consent, the summary
and offline sync. Split into `@live` (Supabase — now runs in CI) and `@cms` (still excluded, and
already guarded in production by `scripts/seo/sitemap-check.mjs`).

Result: **70 product specs now pass in the CI subset**, where 0 ran before.

---

# Part 2c — What a *seeded* dashboard showed that an empty one could not

Parts 1 and 2 measured a brand-new account, because that was all the tooling could reach. Once
`scripts/dev/seed-and-shoot.mjs` could give a user three logged cycles, defects appeared that are
invisible without data. Recording the lesson as much as the bugs: **an empty-state audit is half
an audit**, and the dashboard is precisely the screen that shows least when it has least.

## 13. The same prediction, rendered twice, in two date formats

With cycles logged, the dashboard drew two nearly identical purple heroes back to back:

```
DAY 17 OF YOUR CYCLE        NEXT PERIOD
Expected between            Expected between
Aug 31 and Sep 4            Aug 31, 2026 and Sep 4, 2026
```

`dashboard-screen.tsx:205` hardcodes a `HeroCard` behind `showsCyclePredictions(mode) && mode !==
"ttc"`, and the registry's `cycle.window` module draws the same prediction from the same data.
Both fired for any Track B user with a history. 226px of the dashboard was a duplicate.

The two also disagreed on date format — `fmtShort` above `fmt` — so the duplication was visible
even to someone who did not notice it was the same sentence.

**Not fixed by deleting the hardcoded one.** Only `track-b.ts` contributes `cycle.window`, so
`general` — the Z1 fallback, i.e. the women who have told Femio least about themselves — would
have lost the prediction entirely. Suppressed by module id instead, the pattern `quickLog`
already used. Giving `general` a real registry document is R3.1.6.

Dashboard height with data: **1313px → 1087px**, and the page says strictly more than before.

## 14. Arabic and English disagree about which digits to use

The seeded Arabic dashboard renders dates as `2026/08/31` — Western digits — while the onboarding
age bands render `١٣–١٥` in Arabic-Indic. Both are defensible in isolation; together, in one app,
they are an inconsistency a native reader will notice immediately.

Neither is obviously the "right" answer — Arabic-Indic is standard in Egypt and the Gulf, Western
digits in the Maghreb — which makes it a locale decision rather than a bug fix. Logged as
**R3.5.2** for the design phase, not patched here.

## 15. Note on screenshot artifacts

Full-page screenshots place `position: fixed` elements at the initial viewport origin, so the
crisis pill and the tab bar appear mid-page in every full-page capture in this audit. That is a
capture artifact, **not** a layout bug, and §3's consent overlap was confirmed separately by
measuring bounding-box intersection at the real scroll position rather than by looking at a
picture. Any future finding of this shape must be verified the same way before it is written down.

## 16. `irregular` was two questions wearing one flag

`predict.ts:50` read `spread > 9 || lengths.length < 2`, so **two logged periods — one interval,
no measurable spread at all — set the flag**, and the dashboard told her:

> Your cycles vary, so predictions stay a wider range — that's expected.

That is a statement about her body inferred from a single data point, shown to every user
immediately after onboarding. It is the same error ADR-066 was careful to avoid when naming
phases, sitting unnoticed one layer down in the prediction maths.

Split into `irregular` (her cycles genuinely vary — false until two intervals exist to compare)
and `learning` (Femio has not seen enough yet). Each gets its own sentence, because one is about
her and may never narrow, and the other is about us and narrows on its own.

**Two things the split nearly broke, both caught rather than shipped:**

- `daysUntilPredicted` suppressed the "late" counter on `irregular` alone. Splitting the flag
  would have quietly re-enabled a late count for the thinnest histories — the users it is least
  defensible for. Both states now suppress it, and a test pins that.
- The golden fixtures failed on `signals-from-rows` case 5, which is exactly two starts. With
  `irregular` no longer true there, `regularityFrom` would have returned **`"regular"`** — trading
  one unfounded claim about her cycles for the opposite one. It returns `"unknown"`, a value the
  `CycleRegularity` type already carried for precisely this. Case 7 (three starts, two intervals)
  is a real measurement and stays `irregular`.

The fixtures did the job they were written for: a behaviour change in a tier-2 module could not
pass silently. Both fixture edits are one line each and deliberate.

## 17. 🔴 Logging each day of a period destroys her predictions

Found while checking why the new flow strip showed one mark for a multi-day period.

`cycles` holds one row per **period start**, but `log-period.tsx` inserts a row for whatever date
is selected, with nothing preventing consecutive days. A woman who logs Monday, Tuesday and
Wednesday while bleeding — the most natural possible behaviour, and what a strip labelled "your
bleeding" actively invites — creates three cycle *starts* one day apart.

Verified in the running app, not inferred:

> **Your average cycle — 1 days**
> Expected between Aug 17 and Aug 21

`predictNextPeriod` computes intervals of 1 day, and because those intervals are perfectly
consistent, `spread` is 0 and **`irregular` is false**. So Femio does not merely get it wrong; it
gets it wrong *confidently*, with the uncertainty machinery reporting everything is fine. This is
worse than §16, which at least erred toward caution.

Nothing in the tracker warns her, and the predicted window is already in the past.

Two smaller defects visible in the same string: **"1 days"** is unpluralised, and a window that
has already elapsed is presented as a forecast.

The fix is a decision about what `cycles` means. The schema says one row per cycle; the UI
behaves as though it were one row per bleeding day. Whichever wins, cycle *starts* must be
derived by collapsing dates that belong to the same bleed rather than trusting every row to be a
new cycle — which is tier-2 maths, bound by golden fixtures, and gets its own pass as **R3.1.9**.

---

# Checkpoint 1 — re-measured, including a correction to §5

Every persona driven through real onboarding again, 390×844, after Phase 1.

| Persona | §5 recorded (2026-08-21) | Now, fresh | Now, seeded | `<main>` nodes |
|---|---|---|---|---|
| Teen | — | **844** | — | **6** |
| Cycle | 844 | 972 | 930 | 72 |
| TTC | 844 | 944 | **844** | **17** |
| Pregnancy | 844 | 855 | — | 19 |
| Postpartum | — | 3707 | — | 101 |
| Menopause | 844 | **3238** | — | 135 |

## §5 was partly wrong, and the reason matters

Menopause is recorded in §5 at 844px and measures 3238px now, against changes that never touched
it. Postpartum was never measured at all. The explanation is not an improvement: **the original
measurement script did not complete onboarding.** It clicked Continue twice against a four-step
wizard — the same rot that had broken the `@live` specs, reproduced in the audit's own tooling —
so several rows recorded a partially-onboarded screen rather than a persona dashboard.

The headline of §5 stands: TTC seeded is still **844px and 17 nodes**, the emptiest screen in the
product for the highest-intent segment. But "all four personas are 844" was an artifact in at
least one row, and it is corrected here rather than left to be quoted later. The audit's own
§1.2 finding — that nobody watches the tests fail — applied to the audit.

## What Phase 1 actually moved

- **Cycle, fresh: 844 → 972px, 6 → 61 nodes.** The dead end became a question she can answer.
- **Cycle, seeded: 930px, 72 nodes**, having *removed* a duplicated hero and a philosophy card.
  Less height, more product.
- **Teen is now the emptiest screen in the app: 844px, 6 nodes.** Track A contributes almost
  nothing. This replaces TTC as the most urgent persona gap and is logged as R3.4.0.
- **Pregnancy at 855px / 19 nodes** is barely better and remains Phase 4 work.

The plan's target — ≥2.5 viewports of useful content per persona — is **not met by Phase 1 and
was never going to be**. Phase 1 removed the lies and the dead ends; the height comes from Phase
3's insight engine and Phase 4's per-persona depth. Recording that plainly so the gap between
"Phase 1 complete" and "the dashboard is good" is not mistaken for a claim it never made.

## 18. The report and the dashboard disagree about her average cycle length

Found while giving the visit summary a recorded-vs-derived split.

`buildVisitSummary` has always discarded intervals over 90 days — a 151-day gap is not a
151-day cycle — and `predictNextPeriod` never has. So the number on screen and the number on the
printed page could differ, and the printed one is the one that gets read aloud in a consulting
room.

Unifying them looked like a one-line change. It is not, and the guards said so:

- `signals-from-rows` fixture case 7 is `['2025-01-12', '2025-02-14', '2026-08-10']` — a bleed
  after roughly eighteen months.
- With the outlier rule applied, that gap is discarded, only the 33-day interval survives, and
  `regularityFrom` reports her **regular**.
- That is the exact opposite of the signal `bledAfterALongGap` and Track F's postmenopausal-bleed
  red flag exist to raise. Two Track F reachability tests failed immediately.

So the change was reverted from the shared predictor. The report keeps the safer filter, the
dashboard keeps its behaviour, `basis` and the predicted window still come from the shared
function — the two can never disagree about *where a number came from*, only about this one
outlier rule — and the whole thing is logged as **R3.1.10** rather than half-fixed.

The general lesson is worth more than the bug: **a "long gap" is not one concept.** For an
average cycle length it is noise to discard; for menopause it is the single most clinically
important thing in her record. A rule that treats it as one will be wrong for one of them.
