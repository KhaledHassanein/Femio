# Blockers and gates — the only things waiting on Khaled

**This file is exclusively work that cannot proceed without you.** Nothing optional, nothing
"nice to have". If it is here, something is stopped.

- Config, keys and one-off commands that are *not* blocking → `OWNER_MANUAL_TASKS.md`
- Things needing your eyes rather than your input → `MANUAL_TEST_PLAN.md`

Ordered by what unblocks the most. **B1 and B2 are the real ones** — the rest are single items
that stay `[~]` until done and stop nothing else.

---

## B1 · Your credentials and affiliation — 2 minutes, unblocks the most

**Blocked:** P1.9.8 (bylines on all 30 imported articles), the homepage clinician trust line,
and doc 15 §8 compliance — which requires a named reviewer *with* credentials and a bio link
before any health page claims review.

**Why I cannot proceed:** `upsert-people.mjs` refuses `--publish` for a `medical_reviewer` with
blank credentials, deliberately. A bio reading only "K.H." is weaker evidence than none — it
looks like the requirement was met when it was not. I will not guess post-nominals.

**What I need — reply with two strings:**

| Field | Example | Currently |
|---|---|---|
| `credentials` | `MBBCh, MSc` | `""` |
| `affiliation` | `Cairo University` | `""` |

**What happens next (I do this):** update `docs/content/people/kh.json`, then

```powershell
pnpm --filter cms exec payload run ./scripts/upsert-people.mjs -- --apply --publish
```

then wire `authors` + `medicalReviewerProfile` on the 30 drafts, then restore the homepage
line "every guide is reviewed by a clinician — named, with credentials".

---

## B2 · Medical content — the gate on all of R3

**Blocked:** P2.2.2 pregnancy **week-by-week** (the highest-engagement feature in the whole
category) and postpartum depth. The queue says it plainly: *blocked on reviewed medical
content, not on code — do not hand-write it.*

**The evidence:** of the 31 published articles, **zero** are postpartum and **zero** are
week-by-week. Postpartum mode shipped on 2026-08-12 with a reading panel that says the guides
"are being written", because that is true.

**What I need — pick one:**

- **(a) Authorise me to draft them** under `docs/content/CODEX_AUTHORING_BRIEF.md`, the same
  route the 31 live articles took. `content-lint` checks them mechanically first — Tier-1/2
  sourcing with ≥2 sources, forbidden claim verbs, red-flag boxes, reading level, metadata
  uniqueness — then the importer writes them as `draft`, and **you approve each one in the CMS
  as `medical_reviewer`.** The review gate still decides publication; nothing goes live on my
  say-so.
- **(b) Commission them elsewhere** and tell me when drafts exist.
- **(c) Defer** — then R3 skips to appointments, the TTC toolkit and menopause depth, all of
  which need no content. Say so and I will re-order the queue.

**Scope if (a):** ~14 postpartum articles (recovery, bleeding, mood, feeding, return of
cycle, when to seek care) and 40 week entries. Several sessions, in batches of ten, titles
confirmed with you first.

**Approving in the CMS, when drafts exist:** `femio-cms.vercel.app/admin` → Articles → open →
set `reviewStatus: approved` → publish. Your account already holds `medical_reviewer`
(ADR-032).

---

## B3 · Deploy the experience Edge Function — 5 minutes

**Blocked:** R2.4 cannot close. **Nothing is broken meanwhile** — the client falls back to
computing the same document locally from the same modules, which is why it was built that way.
This is a strict upgrade, not a switch-over.

```powershell
npx supabase@latest login
npx supabase@latest link --project-ref wnthtqtcajkhskdygbgo
npx supabase@latest functions deploy experience
```

Run from `E:\Femio`. Do **not** `npm i -g supabase` — the CLI does not support a global npm
install. `scoop install supabase` works if you prefer it installed.

**Tell me when it is done** and I will point the dashboard at the served document and repoint
`native-readiness-lint` (R2.7).

---

## B4 · Signup gating — before any outside tester

**Blocked:** P1.24, the beta with 20–50 real users. **This is the single
highest-information action available to the project** and it has been available for weeks;
every quality judgement so far, including yours and mine, is internal.

**Why it is a gate:** signup is open on a live domain while P0.12 legal is deliberately
deferred. The trigger for P0.12 was never incorporation — it is the first real user storing
health data. While that is only you and testers, this is genuinely fine. It stops being fine
the moment you invite someone.

**What I need — a decision, then I build it (about an hour):**

- **(a) Invite code** — one shared code on `/welcome`. Simplest, and enough.
- **(b) Allowlist** — email allowlist; requires email signup, which breaks the anonymous path.
- **(c) Private-beta notice** — no gate, just a clear statement on `/welcome` that this is a
  test system and not a live service.

My recommendation is **(a)**, with **(c)**'s wording alongside it.

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

## Not blockers, listed so they stay off this file

- **AR/FR/ES review** — ungated by your direction (ADR-063). Review happens during testing; a
  correction is an edit, not a blocked release.
- **P0.12 legal** — deferred by your direction. Blocks nothing except B4's honesty.
- **Search Console, custom CMS subdomain, Sentry DSN** — real, unblocking nothing. They live in
  `OWNER_MANUAL_TASKS.md`.
