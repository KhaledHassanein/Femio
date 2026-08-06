# Femio — Project audit (2026-08-06)

Commissioned by Khaled: *"make sure we did not lose context on focusing on CMS rather
than the real app and functions we are doing the project for in the first place."*

Answer up front: **the concern was justified and the trajectory has corrected — but it is
not the biggest risk this project has.** The audit found a larger one that nobody has
costed, and it sits directly under the cross-platform goal.

---

## 1. Did we over-invest in CMS and content?

**Partly, and it self-corrected the moment it was raised.** Measured by files touched
since 2026-08-04:

| Area | Files touched |
|---|---|
| Governance docs (ADRs, TODO, handovers) | 46 |
| App features (dashboards, tracking, i18n strings) | 40 |
| Content, CMS, SEO plumbing | 40 |

Two honest readings of that:

- The **first half** of the session was almost entirely content and CMS — the authoring
  guard, the importer, structured data, sitemap work. That was owner-approved work with a
  real deliverable (31 live articles, the SEO engine), so it was not wasted. But it ran
  long, and some of it was over-built: the reviewer-bio publishing guard was scaffolding
  around a one-line problem, and the owner was right to push back.
- The **second half**, after the push-back, has been app work: pregnancy mode, menopause
  mode, ending a pregnancy, pregnancy symptom logging with urgency tiers.

**The governance overhead is real and worth naming.** 46 doc touches against 40 app-file
touches is a high ratio. ADRs earn their place when a decision is non-obvious or was got
wrong once — several today were exactly that (the migrate prompt, the pool exhaustion, the
sitemap emptying). Others were ceremony. A cheaper rule going forward: **an ADR for a
decision that cost something or that a future session could plausibly reverse by accident;
a commit message for everything else.**

**Verdict:** focus drifted, was corrected, and is now in the right place. This is a
process note, not a crisis.

---

## 2. The finding that actually matters: the app may not wrap

Femio's stated shape is **one product across web, iOS and Android**, with Phase 4 being a
Capacitor wrap of the same codebase (`docs/06_TECH_STACK`, CLAUDE.md). That plan has an
unvalidated assumption, and every week of building increases the cost of finding out.

**Every screen of the actual tracker is a server-rendered React Server Component that
reads the database on the server:**

| Route | Rendering | Data |
|---|---|---|
| `/[locale]/dashboard` | `force-dynamic` | server-side Supabase read |
| `/[locale]/track` | `force-dynamic` | server-side Supabase read |
| `/[locale]/settings` | `force-dynamic` | server-side Supabase read |
| `/[locale]/summary` | `force-dynamic` | server-side Supabase read |
| `/[locale]/mfa`, `/admin/*` | `force-dynamic` | server-side |

**Capacitor has no server.** It ships a static bundle to the device and loads it from the
filesystem. A `force-dynamic` route and a server component that calls
`createClient()` from `lib/supabase/server` cannot execute there. So today, the Phase 4
plan as written cannot run — and this is not a bug, it is an architectural mismatch that
has never been tested because nothing has tried to build for mobile yet.

There are three ways out, and they cost very differently:

1. **Point Capacitor at the live URL** (a webview onto `femioapp.com`). Cheapest, and the
   worst outcome: no offline, no native feel, and a real risk of rejection under Apple's
   4.2 "minimum functionality" guideline, which is aimed squarely at repackaged websites.
2. **Static export** (`output: "export"`). Incompatible with `force-dynamic`, with
   server-side Supabase reads, with the middleware, and with next-intl's server config as
   currently used. Effectively a rewrite of the app shell.
3. **Make the tracker a client-rendered SPA** that talks to Supabase from the browser
   (which the offline sync layer already does), keeping the public content site as the
   server-rendered part. This is the honest middle path: the public site stays great for
   SEO, the app half becomes portable. It is real work, but it is work that gets *more
   expensive with every server component added to the tracker.*

**This should be decided before Phase 2 features are built, not after.** Phase 2 is where
most of the app gets written; writing it twice would be the single most expensive mistake
available to this project.

**Recommendation:** spend one session proving the path — take `/track` and `/dashboard`,
convert them to client-side data fetching against Supabase, and check the offline sync
layer still behaves. That is a small, reversible experiment that answers a question worth
tens of sessions.

---

## 3. What the app actually is today, versus what it promises

**Built and solid (Phase 1 MVP is essentially complete):**

- Onboarding across four life-stage modes; persona state stored.
- Cycle tracking: calendar, flow, predictions **with uncertainty ranges** and an
  irregular-cycle mode that refuses to show a false-precision date.
- Symptom logging (~26 curated symptoms + custom), severity, notes.
- Four real dashboards — cycle, TTC, pregnancy, menopause — each showing what that stage
  actually needs and hiding what would mislead.
- Pregnancy lifecycle: due date → weeks/trimester → urgency-tiered symptom logging →
  ending a pregnancy (birth, loss, other) with copy written for the worst day.
- Menopause: months since last period, cycle variability, filtered symptoms.
- Export and delete (GDPR), offline logging with an IndexedDB sync queue, consent
  manager, staff MFA, first-party k-anonymous insights.
- Visit summary (print/PDF).

**Promised but not built — this is Phase 2, and Phase 2 has not started:**

| Gap | Why it matters |
|---|---|
| TTC toolkit (BBT, OPK, cervical mucus) | TTC mode is currently *just* a fertile-window estimate |
| Pregnancy week-by-week, kick counter, contraction timer, weight | The stage with the highest engagement in the category |
| Postpartum mode | Does not exist; "your baby arrived" honestly says so |
| Menopause depth (MRS score, HRT log, 34-symptom set) | Current view is a count and a symptom filter |
| Pattern engine | The differentiator — "honest patterns" — is not built |
| Validated screeners (PHQ-9, GAD-7, DRSP, PBAC) | Named in the strategy as a trust driver |
| Notifications | No reason to return to the app between sessions |
| Billing / Pro tier | No revenue path exists in code |

**The honest summary:** Femio today is *a good cycle tracker with four thin life-stage
views and an excellent content library*. The product it is pitched as — one account for a
whole health life, with pattern intelligence — is Phase 2, and Phase 2 is unstarted.

That is not a failure; Phase 1 was the right thing to finish first. But it means **the
next stretch of work should be almost entirely app depth**, and the audit's answer to
"did we lose focus" is: not fatally, but the runway from here has to be app-shaped.

---

## 4. Other findings worth carrying forward

- **No real users, and no beta.** P1.24 (20–50 testers including Arabic speakers) has not
  started. Every quality judgement so far is internal. The single highest-information
  action available is putting it in front of ten real women.
- **Signup is open on a live domain** while the legal work is deliberately deferred
  (owner direction, and reasonable). The trigger for P0.12 is not incorporation, it is the
  first real user — so gate signup before outside testers (tracked as P0.12.5).
- **Arabic is untested in practice.** RTL is implemented and the catalogs have key parity,
  but every Arabic string is currently an English placeholder awaiting human translation.
  A first-class Arabic experience is a stated differentiator and is currently a promise.
- **`meet-femio`, the one hand-entered article, has no sources or SEO fields** (P1.9.6).
  It is the page a reader is most likely to land on first.
- **Reliability improved sharply today** and the remaining risk is understood: the CMS
  pool is now capped per instance, outages return 5xx instead of 404, and the sitemap
  fails loudly instead of silently emptying. Three separate silent-failure classes, all
  found by looking at production rather than at tests.
- **Repeated lesson, worth institutionalising:** every serious defect this session was
  invisible from inside the build — the migrate prompt, the pool exhaustion, the empty
  sitemap, the 404s during an outage. *Check the deployed thing.* The guards that caught
  real problems were the ones pointed at production.

---

## 5. Recommended order from here

1. **Prove the mobile path** (one session, reversible). Convert `/track` and `/dashboard`
   to client-side Supabase reads and confirm offline sync still works. Answers the biggest
   open question before Phase 2 multiplies its cost.
2. **Phase 2 app depth**, in engagement order: pregnancy week-by-week and kick counter →
   postpartum → TTC toolkit → menopause depth → pattern engine.
3. **Beta with real users** (P1.24), gating signup first (P0.12.5).
4. **Notifications**, once there is something worth returning for.
5. Content and CMS work only when it is blocking, or in small batches between app work.

Legal (P0.12), billing (P2.10) and store compliance (P4.3) are all deferred by owner
direction and none of them blocks the above.
