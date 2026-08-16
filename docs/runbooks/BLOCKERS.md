# Blockers and gates — the only things waiting on Khaled

**This file is exclusively work that cannot proceed without you.** Nothing optional, nothing
"nice to have". If it is here, something is stopped.

- Config, keys and one-off commands that are *not* blocking → `OWNER_MANUAL_TASKS.md`
- Things needing your eyes rather than your input → `MANUAL_TEST_PLAN.md`

**Three open questions: B7, B8 and B9.** B8 (ten teen titles) and B9 (what a pregnancy week
entry should be) each hold a content item that is otherwise ready to draft, and both are one
reply. **B7** — whether Femio carries baby-care content at all, which
is a scope decision rather than a build one. B1–B4 are closed. B5 and B6 remain,
and neither stops anything: B5 gates a dashboard nobody is waiting on, B6 gates `/admin/*`
only. They are kept here because they are still genuinely yours to do.

---

## B1 · ✅ DONE 2026-08-12 — one public bio: `Dr. Khaled M. · MBBCh, CPC`, no affiliation shown

**Blocked:** P1.9.8 (bylines on all 30 imported articles), the homepage clinician trust line,
and doc 15 §8 compliance — which requires a named reviewer *with* credentials and a bio link
before any health page claims review.

**Why I cannot proceed:** `upsert-people.mjs` refuses `--publish` for a `medical_reviewer` with
blank credentials, deliberately. A bio reading only "K.H." is weaker evidence than none — it
looks like the requirement was met when it was not. I will not guess post-nominals.

**Status 2026-08-12:** `credentials` received and set to **`MBBCh, CPC`**.
**`affiliation` is still blank**, and `upsert-people.mjs` refuses `--publish` without it — so
this is still blocked, on one more word.

| Field | Example | Currently |
|---|---|---|
| `credentials` | `MBBCh, MSc` | ✅ `MBBCh, CPC` |
| `affiliation` | `Cairo University`, or a clinic, or `Independent` | ❌ `""` |

If you genuinely have no institutional affiliation, say **`Independent`** — that is a true
answer and it satisfies doc 15 §8, which asks for a named reviewer with credentials and a bio,
not for an employer.

**What happens next (I do this):** update `docs/content/people/kh.json`, then

```powershell
pnpm --filter cms exec payload run ./scripts/upsert-people.mjs -- --apply --publish
```

then wire `authors` + `medicalReviewerProfile` on the 30 drafts, then restore the homepage
line "every guide is reviewed by a clinician — named, with credentials".

---

## B2 · ✅ APPROVED 2026-08-16 — the 14 postpartum titles, unchanged, drafting is authorised

**You replied "postpartum approved" with no cuts**, so the list stands as written: 1 your body
in the first six weeks · 2 bleeding after birth · 3 postpartum warning signs · 4 perineal and
caesarean wound healing · 5 afterpains · 6 pelvic floor · 7 your mood after birth · 8 sleep and
exhaustion · 9 breastfeeding, the first two weeks · 10 if breastfeeding is not working · 11 when
your periods come back · 12 contraception after birth · 13 your six-week check · 14 sex after
birth.

**Written and imported 2026-08-16 (P2.3c).** All fourteen are in the CMS as drafts, they pass
the content guard, and every source URL resolves. **The review gate is yours** — `MANUAL_TEST_PLAN.md`
T22 is the checklist. The postpartum dashboard's reading card fills itself in as you publish, with
no deploy needed.

Route (a): drafted under `docs/content/CODEX_AUTHORING_BRIEF.md`, the same path the 31 live
articles took. `content-lint` checks them mechanically first — Tier-1/2 sourcing with ≥2
sources, forbidden claim verbs, red-flag boxes, reading level, metadata uniqueness — then the
importer writes them as `draft`. Tracked as **P2.3c** in the queue, in batches of ten.

**The one thing still yours, and it is not a blocker:** each draft needs approving in the CMS
before it is public. `femio-cms.vercel.app/admin` → Articles → open → `reviewStatus: approved`
→ publish. Your account already holds `medical_reviewer` (ADR-032), and the gate is what makes
the byline on every page true. Nothing goes live on my say-so.

**Week-by-week (P2.2.2) is a separate ask** — 40 short entries under one pillar, batched by
trimester — and it is *not* covered by this approval. I will bring you that list when the
postpartum batch is drafted, rather than assuming.

---

## B3 · ✅ DONE 2026-08-12 — deployed and verified live (401 unauthed, 200 returns a real config)

**Your 2026-08-12 attempt failed and it was my bug, not yours.** The deploy reported
`failed to read file: .../persona/resolver` and then `EISDIR`. Deno resolves relative imports
literally — no extension inference, no directory/index lookup — and the tier-1 modules imported
each other the TypeScript way (`from "./types"`, `from "../pregnancy"`). Both work perfectly in
the web app and both fail at deploy.

Fixed: every tier-1 relative import now carries an explicit `.ts`, and the portability guard
gained a rule for it that was watched failing on the exact pattern. **`login` and `link` already
succeeded, so only the last line is needed:**

```powershell
npx supabase@latest functions deploy experience
```

(The `WARNING: Docker is not running` line is harmless — Docker is only needed to run functions
locally, not to deploy.)

**Blocked:** R2.4 cannot close. **Nothing is broken meanwhile** — the client falls back to
computing the same document locally from the same modules, which is why it was built that way.
This is a strict upgrade, not a switch-over.

Run from `E:\Femio`. `scoop` is not installed on this machine and is not needed — `npx` works.

**Tell me when it is done** and I will point the dashboard at the served document and repoint
`native-readiness-lint` (R2.7).

---

## B4 · ✅ BUILT 2026-08-12 — set `NEXT_PUBLIC_BETA_INVITE_CODE` in Vercel to switch it on

**Blocked:** P1.24, the beta with 20–50 real users. **This is the single
highest-information action available to the project** and it has been available for weeks;
every quality judgement so far, including yours and mine, is internal.

**Why it is a gate:** signup is open on a live domain while P0.12 legal is deliberately
deferred. The trigger for P0.12 was never incorporation — it is the first real user storing
health data. While that is only you and testers, this is genuinely fine. It stops being fine
the moment you invite someone.

**Built 2026-08-12** — option (a) with (c)'s wording alongside it, as you approved. **It is
off until you set one environment variable**, and with it unset signup behaves exactly as it
does today:

```
NEXT_PUBLIC_BETA_INVITE_CODE=femio-beta
```

Set it in Vercel on the **web** project and redeploy. The last step of onboarding then shows
the private-beta notice and asks for the code; the code is matched ignoring case and
punctuation, so `FEMIO-BETA`, `femio beta` and `femiobeta` all work.

**Stated plainly because it must not be oversold:** this is a speed bump, not a security
control. It is a `NEXT_PUBLIC_` value and readable in the bundle. It stops a stranger arriving
from a search result and storing real health data while the privacy policy is a draft; someone
determined to read the bundle is making an informed choice, which is what the notice is for.
The real control is P0.12.

---

## B5 · PostHog EU project — 20 minutes, optional

**Blocked:** P1.20's dashboard half. The event layer is built, fails closed, and is a
**verified no-op** with no key — no vendor script loads at all. Nothing else waits on it.

1. Create a PostHog project in the **EU** region (not US — a non-EU host fails the build by
   design).
2. Sign their DPA.
3. Add it to `docs/compliance/PROCESSOR_REGISTER.md` as signed.
4. Set in Vercel (web project): `NEXT_PUBLIC_POSTHOG_KEY`, `NEXT_PUBLIC_POSTHOG_HOST=https://eu.i.posthog.com`.

---

## B6 · Enrol two-step sign-in — 3 minutes

**Blocked:** `/admin/*` only — the translation portal and the insights dashboard. Staff routes
check for a second factor and redirect you to Settings until you enrol. The tracker, the public
site and the CMS are unaffected.

Sign in → **Settings** → two-step sign-in → scan the QR with any authenticator app → enter the
code. Recovery if you lose the authenticator is `scripts/auth/reset-mfa.mjs` (runbook B★★★).


---

## B7 · Does Femio carry **baby-care** content? — a scope decision, not a build one

**You asked for** "how to raise your child in the first days… for at least 6 months to a year"
alongside the after-birth work. Everything else you asked for is built (see below); this one
part I have deliberately not started, because it is the first thing in months that sits outside
the product definition rather than inside it.

**Why it is a question at all.** `CLAUDE.md` defines Femio as *"one account for a woman's whole
health life"*. Every persona spec is mother-centred, and **E2 §E names baby tracking as
explicitly out of scope** — "full baby-tracking (diapers, sleep, growth curves)" — in the very
persona that would host it. Adding newborn-care content is not an oversight being corrected; it
is a decision to widen what Femio is. That is yours, not mine.

**It also changes the compliance surface.** Every claim Femio makes today is about an adult
woman's own body, and the medical-review chain (doc 15 §8, your byline) is built on that.
Content about **an infant** is advice about a second person who is not the account holder,
whose red flags are different, sharper, and time-critical — a newborn's fever is not an adult's.
It would need its own review posture, and probably its own reviewer statement.

**Pick one:**

- **(a) Mother-facing only — my recommendation.** Femio covers feeding *from her side*
  (supply, pain, mastitis, pumping, weaning, "is this normal for me"), her recovery, her mood,
  her cycle returning. Where a question is really about the baby, it says so plainly and points
  to her health visitor or paediatrician. **This is what is now built**, and it is what the E2
  spec describes.
- **(b) Add a newborn-basics layer**, 6–12 months, as its own content pillar with its own
  review chain. Say so and I will bring you a title list the way B2's fourteen came — nothing
  drafted before you approve it.
- **(c) Defer.** Nothing changes; the queue line stays open.

**Nothing is blocked on this.** The after-birth experience is complete without it.


---

## B8 · Ten teen titles, for approval — the same shape B2 took

**Blocked:** P2.13. Track A has had a mode since R2.5c and **two modules with no article
behind them** — `teen.body` and `teen.readiness` are listed in `UNIMPLEMENTED`, so the gap is
counted rather than invisible. The authoring brief requires a confirmed title list before
drafting, for the reason it gives: two articles competing for one query is the most common way
a content set underperforms.

**Read these as a clinician and as the parent of a thirteen-year-old.** A2 §D is explicit that
PCOS must never be suggested within two to three years of menarche, and A2 §B names the
question the set has to answer — *"it said Tuesday and it didn't; is the app broken or am I
broken?"*

1. **What's changing in my body** — puberty in the order it usually happens, with ranges, no averages presented as targets.
2. **What is a period?** — written for someone who has not had one yet.
3. **Getting ready for your first period** — the plan: what to carry, where to keep it, who to tell.
4. **Period myths, checked** — swimming, exercise, washing, "how much blood is that really".
5. **Is my period normal?** — the first years are irregular by design; this is the article that answers A2 §B.
6. **Period products, and how to choose** — pads, tampons, cups, period underwear, without a recommendation.
7. **Period pain: what helps, and when it is too much** — no doses, and a clear line to a clinician.
8. **A period at school** — leaks, PE, asking to leave a lesson, what to keep in a bag.
9. **Tracking without stress** — why Femio shows a wide window at her age, and why that is honest rather than broken.
10. **When to tell an adult, and when to see a doctor** — including the A1 §D thresholds (early signs before 8, no signs by 13), framed as "let's ask together".

**Deliberately not on the list:** anything that names a condition as a possibility. That is A2
§D, and it is why "could I have PCOS" is not one of the ten.

**Reply with cuts, additions, or "approved".** Nothing is drafted before you do.

---

## B9 · Pregnancy week-by-week — a scope question before a title list

**Blocked:** P2.2.2, and through it the `week-by-week` topic that D1 has foregrounded since
R2.1. The queue line says "do not hand-write it", which is right, and it is also why this needs
a decision from you rather than a list from me.

**The question is what a week entry *is*.** Forty pages called "Week 14 of pregnancy" is the
shape every competitor uses, and it is forty pages that mostly say the same four things. The
alternative is three trimester pillars with the week detail inside them, which is one strong
page per trimester instead of forty weak ones.

- **(a) Three trimester pillars, week detail inside — my recommendation.** Each pillar carries
  the weeks as sections: what is usually happening, what she may notice, what care is typically
  offered around then. Strongest for a reader, and it does not manufacture forty near-duplicate
  pages competing with each other for the same searches.
- **(b) Forty week entries**, short, batched by trimester. Matches what people search for, and
  it is the option that needs the most review time from you — forty pages of clinical content
  rather than three.
- **(c) Both**: three pillars now, week entries later if the traffic argues for them.

**Either way, two things hold.** Fetal-development detail stays *about her body and her care*
rather than becoming a baby-size-in-fruit tracker, and every week that carries a red flag —
bleeding, severe headache, vision changes, reduced movement, severe abdominal pain — gets the
red-flag box, no exceptions (brief §8).

**Tell me (a), (b) or (c)** and the title list follows the way B2's fourteen did.

---

## Not blockers, listed so they stay off this file

- **AR/FR/ES review** — ungated by your direction (ADR-063). Review happens during testing; a
  correction is an edit, not a blocked release.
- **P0.12 legal** — deferred by your direction. Blocks nothing except B4's honesty.
- **Search Console, custom CMS subdomain, Sentry DSN** — real, unblocking nothing. They live in
  `OWNER_MANUAL_TASKS.md`.
