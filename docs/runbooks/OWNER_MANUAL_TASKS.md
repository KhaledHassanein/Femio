# Runbook — Owner (Khaled) manual tasks

Audience: **you, Khaled.** These are the tasks that only you can do because they need a
password, a service-role key, a paid account, DDL rights, or a human sign-off — Claude
Code holds only the **client-safe publishable key** and can't do them.

This is written to **teach while you do**: each task says *why it matters*, then gives
*exact A–Z steps*, *how to verify it worked*, and *common gotchas*. Do them in the
priority order below; later tasks assume earlier ones are done.

Key facts you'll reuse:
- **Supabase project ref:** `wnthtqtcajkhskdygbgo` (EU region).
- **Dashboard:** https://supabase.com/dashboard/project/wnthtqtcajkhskdygbgo
- **Never commit or paste secrets into chat.** Service-role keys and DB passwords stay
  on your machine / in Vercel env only.

---

## ▶ Do these next (everything else can wait)

Re-audited on **2026-08-16**. Row 1 of the old table — your credentials (P1.9.7) — is **done**:
the bio is published and all 30 articles carry it, so it has left this list. What is actually
outstanding, in the order I would do it:

| # | Task | Time | Why it matters |
|---|---|---|---|
| **1** | **Approve the 14 postpartum drafts + look at the new screens** — *`MANUAL_TEST_PLAN.md` T8, T10–T22* | 90 min | Fifteen items shipped on 2026-08-16 and **I have seen none of them rendered.** **Start with T16**, the postpartum mood check: it is the only screen in Femio that *acts* on an answer, and you are the clinician. Two want you specifically as a clinician: the charting screen must not read as contraception (T11), and the MRS must not read as a grade (T12). The rest is craft — teen mode, appointments, and whether the Arabic sounds like a person wrote it. |
| **2** | **Read the ten Arabic crisis strings** (P1.26.2) — *see `MANUAL_TEST_PLAN.md` T2* | 5 min | You are the recorded reviewer (ADR-063). The English fallback that used to render in Arabic is **gone**, so these are what a woman at risk now sees. Open `/ar` on the live site and tap **تحتاجين مساعدة الآن؟**, or read `apps/web/src/lib/crisis/crisis.json`. A correction is an edit, not a blocked release. |
| **3** | **Look at the new homepage on a phone** (R1.3d) — *see `MANUAL_TEST_PLAN.md` T1* | 5 min | `femioapp.com/en` and `/ar` at 390px, light and dark. I verified the copy with `curl`; I have never seen it rendered. Craft is your call. |
| **4** | ✅ **Migration `0009` applied** 2026-08-19 | — | `pregnancy.ended_on` exists, tier 1 reads it before `updated_at`, and the follow-up card can say where she is. **Row 5 matters more now:** the Edge Function still computes her postpartum week from `updated_at` until it is re-deployed, so the server and the local fallback disagree for any woman who has edited an ended pregnancy. |
| **5** | ▶ **Re-deploy the experience Edge Function** (R2.4) | 2 min | **This one has teeth now.** Its source changed again on 2026-08-19 to read `pregnancy.ended_on` (migration 0009). Until it runs, the server counts her postpartum week from `updated_at` — *last edited* — while the local fallback counts from the day she recorded. For a woman who corrected anything on an ended pregnancy the two now give different answers, and the served one is the wrong one. `npx supabase@latest functions deploy experience` from `E:\Femio`. |
| **6** | ✅ **Two-step sign-in enrolled** 2026-08-16 (B6) | — | `/admin/*` is reachable — the translation portal and the insights dashboard. Recovery if you lose the authenticator is `scripts/auth/reset-mfa.mjs`. |
| **7** | **Gate signup** (P0.12.5) | 15 min | Before any outside tester. An invite code, an allowlist, or a "private beta" notice on `/welcome`. It keeps "we are only testing" true rather than merely intended. |
| **8** | **PostHog EU key** (B5) | 5 min | Optional. **The DPA is signed and the processor register records it** (2026-08-16) — what is left is two environment variables in Vercel: `NEXT_PUBLIC_POSTHOG_KEY` and `NEXT_PUBLIC_POSTHOG_HOST=https://eu.i.posthog.com`. Until they exist the event layer stays a **verified no-op**: no vendor script loads at all. A non-EU host fails the build by design. |

**Anything that needs your eyes rather than your credentials lives in
`MANUAL_TEST_PLAN.md`** — **T1–T25 now**, and T8 and T10–T25 have never been looked at by
anyone. The three that changed since this row was written: **T22** (the fourteen postpartum
drafts), **T24** (the ten teen drafts) and **T25** (the thirty-seven week-by-week drafts) are
the review gate itself — 75 of 101 articles are written and invisible to readers until you
approve them, which is the largest single gap between what is built and what anyone can use.
This file stays keys, config and one-off commands.

**Nothing on this list blocks me.** Every item is a strict improvement on a working product:
the Edge Function has a local fallback that computes the identical document, and the five new
screens are live. They are here because they are yours to judge, not because work is waiting.

### Task 4, verbatim — Supabase CLI

Do **not** `npm i -g supabase`; the CLI does not support a global npm install. On Windows use
`npx`, which needs no install at all:

```powershell
npx supabase@latest login
npx supabase@latest link --project-ref wnthtqtcajkhskdygbgo
```

`login` opens a browser and stores a token. `link` connects this folder to the Femio project —
run it from the repo root (`E:\Femio`), where `supabase/config.toml` already carries the ref.

**The function is deployed** (verified 2026-08-12: 401 unauthenticated, 200 with a session).
`login` and `link` are already done, so re-deploying after a source change is one line:

```powershell
npx supabase@latest functions deploy experience
```

**Do this when a session note says the function changed** — 2026-08-16 is the current one.
Nothing breaks if you delay it: the client tries the function, falls back to its cache, then
computes the same answer locally from **the same modules** — literally the same files, which
is what `tier1-portability-lint` and the golden fixtures exist to keep true. Deploying is a
strict upgrade, never a switch-over.

If you would rather have it installed properly than go through `npx` each time:

```powershell
scoop install supabase
```

---

## Priority checklist

Statuses marked **verified** were checked directly against the live database / deployed site on
2026-07-30, not just remembered.

- [x] **A.** Apply migration `0003` (delete-account RPC) — **verified**: `delete_account()` exists.
- [x] **A2.** Apply migration `0005` (analytics consent purpose, P1.20) — **verified**: the `consent_records` purpose check now includes `analytics`.
- [x] **B.** Activate the translation portal (P1.19) — **verified**: `staff_roles` = `admin`; `ui_strings` = 293 keys x 4 locales (EN approved, AR/FR/ES machine drafts).
  - [ ] **B5.** ▶ **Re-seed now that new screens shipped** — 482 strings in the app vs 293 in the database — 2 min
- [x] **A3.** Apply migration `0006` (first-party insights aggregates, P1.20.3) — **verified 2026-08-07** by `node scripts/security/rls-audit.mjs`: 15/15 passed and the three `non-staff cannot call insights_*()` checks ran without the `[SKIPPED]` label.
- [x] **A4.** Apply migration `0007` (`fetal_movement_sessions`, P2.2) — applied by owner 2026-08-07. End-to-end save still to be exercised once pregnancy mode is reachable (Settings → Your Femio experience, P1.27.1).
- [~] **B★.** Auth email: redirect URLs + real sender — redirect URLs look configured (Google sign-in is live, which needs them); **custom SMTP is still required before launch** (Supabase's built-in sender is rate-limited and spam-prone).
- [ ] **B★★★.** ▶ **Enrol two-step sign-in** — required to open `/admin/*` (translation portal, insights) — 3 min
- [x] **B★★.** "Continue with Google" sign-in — **verified**: the provider is enabled in Supabase *and* the button is live on `/en/sign-in`.
- [~] **C.** CMS online — **verified live** (`femio-cms` answers, collections exist), but two pieces remain:
  - [x] **C3.6.** Schema for the **People** (bios) collection — **verified**: tables exist, `/api/people` → 200.
  - [x]C3.7.** ▶ **Make your CMS account an `admin`** — without it you cannot publish — 1 min
  - [x] **C3.5.** ▶ **Set `NEXT_PUBLIC_CMS_URL` on the web project** + redeploy — 5 min
  - [x] **C4.** Remove `PAYLOAD_DB_PUSH` (production currently auto-syncs its schema on every deploy) — do it before real articles exist, with Claude's `payload migrate` switch (P1.6.5)
- [x] **D.** ▶ Choose + set up an analytics vendor (PostHog EU) — **verified not configured**: no key in the live bundle — 20 min
- [~] **E.** Vercel env hygiene — **verified**: `NEXT_PUBLIC_APP_URL` is correct (canonical URLs resolve to `femio-web.vercel.app`) and the **crisis directory link is live** (`https://findahelpline.com` renders on `/help-now`). ⚠ That link is only meant to be on once ThroughLine's linking terms are confirmed — close that question in `docs/compliance/CRISIS_RESOURCES.md` (task H).
- [ ] **F.** Google Search Console + custom domain (SEO) — **verified not done**: no verification token in the live pages, still on the `vercel.app` domain — 20 min
- [ ] **G.** Sentry error monitoring (optional) — 10 min
- [ ] **H.** Human sign-offs: crisis posture, ThroughLine link terms, AR/FR/ES crisis copy (P1.26) — ongoing
- [ ] **I.** Legal + DPO launch gate (P0.12) — the big one before real users. Now includes **P0.12.4**: replace the draft text on `/privacy` + `/terms`, then remove the draft banner and let them be indexed.

---

## Concepts you'll want to understand (read once)

- **RLS (Row-Level Security):** Postgres rule that every query is filtered to the rows the
  logged-in user is allowed to see. Femio relies on it so the browser can talk straight to
  the database safely. It's why "just the publishable key" is enough for the app but *not*
  enough for admin/DDL work.
- **publishable key vs service-role key:** the *publishable* key is public and always
  obeys RLS. The *service-role* key **bypasses RLS** — it's a master key. Use it only in
  trusted scripts on your machine, never in the browser, never in git.
- **DDL vs DML:** DDL = changing the shape of the database (create table, add column) via
  migration files. DML = reading/writing rows. Claude authors DDL as migration files; you
  apply them.
- **`NEXT_PUBLIC_*` env vars bake in at build time.** Changing one in Vercel requires a
  **fresh deploy** to take effect — editing the value alone does nothing to the running site.

---

## A. Apply migration `0003` (delete-account RPC)

> [DONE] **Verified 2026-07-30** — the live DB has `delete_account()` in `pg_proc`. Kept for reference.

**Why:** GDPR "delete my account" must remove the *auth* user too, not just the health
rows. `0003` adds a `delete_account()` function that does the full cascade. Until applied,
the app falls back to deleting the profile row (which still cascades health data), but the
auth login lingers. See also `docs/runbooks/supabase_apply_migrations.md`.

**Steps:**
1. Open the dashboard → **SQL Editor** (left sidebar) → **New query**.
2. In your editor, open `supabase/migrations/0003_delete_account.sql`, copy its entire contents.
3. Paste into the SQL Editor and click **Run** (bottom-right).
4. You should see "Success. No rows returned."

**Verify:** In SQL Editor run:
```sql
select proname from pg_proc where proname = 'delete_account';
```
It should return one row.

**Gotcha:** If it errors "function already exists", it's already applied — safe to ignore.

---

## A2. Apply migration `0005` (analytics consent purpose) — 3 min

> [DONE] **Verified 2026-07-30** — `consent_records_purpose_check` now lists `analytics`. Kept for reference.

**Why:** the consent ledger currently only accepts the purposes `core`, `insights`,
`research` and `ads_contextual`. Product analytics needs its **own** opt-in purpose —
reusing `insights` ("use my entries to show me patterns", which is about showing *you* your
own data) as permission to send events to an outside company would be exactly the kind of
purpose creep the FTC fined other cycle apps for. `0005` widens the allowed list to include
`analytics`.

**This grants nothing to anyone.** It only makes a future consent grant recordable. Widening
a CHECK constraint accepts every existing row unchanged, so there's no backfill and no risk
to live data.

**Steps:** same as task A — SQL Editor → New query → paste all of
`supabase/migrations/0005_analytics_consent_purpose.sql` → **Run**.

**Verify:** In SQL Editor run:
```sql
select pg_get_constraintdef(oid) from pg_constraint
where conname = 'consent_records_purpose_check';
```
The returned definition should include `'analytics'`.

**Gotcha:** apply this before, or together with, task D — otherwise the analytics consent
toggle (P1.20.2) will have nothing valid to write.

---

## A3. Apply migration `0006` (first-party insights) — 3 min

> [TODO] New 2026-07-30 with the insights dashboard (P1.20.3).

**Why:** the product questions worth asking — which life stage people are in, which conditions
they follow, which age bands, whether they come back — are, about a real person, **health
inferences**. Sending those to an outside analytics vendor is exactly what Femio promises never to
do (docs/13 §5), so they are computed **inside our own database** instead, and only ever as counts.

`0006` adds three read-only functions (`insights_overview`, `insights_by_dimension`,
`insights_retention`). They are `security definer` — they can read past row-level security — so
each one checks that you are an **admin** before returning anything, and every function returns
only `(label, count)`: no ids, no dates, no symptoms, no notes ever leave the database.

They are also **k-anonymous**: any group smaller than **10 people** is withheld and — because
hiding a cell does not hide it if you can subtract the rest from a total — small groups are merged
together until what is left to infer is itself anonymous. On today's data that means most
breakdowns will say "not enough people yet". That is the guard working, not a bug.

**Steps:** SQL Editor → New query → paste all of
`supabase/migrations/0006_insights_aggregates.sql` → **Run**. It creates functions only: no table
is touched and no row is changed.

**Verify:** open `https://femio-web.vercel.app/en/admin/insights` signed in as an app admin (the
`staff_roles` admin you already have — this is separate from the CMS admin in C3.7). You should see
the dashboard, with most groups withheld while the user base is small. Then run
`node scripts/security/rls-audit.mjs`: the three `non-staff cannot call insights_*()` checks should
appear **without** the `[SKIPPED — migration 0006 not applied]` label.

**Gotcha:** the file was validated against your live schema inside a transaction that was rolled
back, so it applies cleanly — but it does nothing for non-admins by design. If the page says "not
set up yet", the migration has not been run.

---

## A4. Apply migration `0007` (pregnancy movement log) — 3 min

> [TODO] New 2026-08-06 with the pregnancy movement log (P2.2.1, ADR-049).

**Why:** the movement log is built and deployed, but it has nowhere to write. Until this runs,
starting a session works and pressing **Finish and save** fails. Nothing else in the app is
affected.

`0007` creates **one new table**, `fetal_movement_sessions`, holding a start time, an end time, a
count and an optional note. It creates nothing else, changes no existing table, and touches no
existing row.

It carries the same four owner-only row-level-security policies as every other health table: you
can only ever read, write, change or delete your **own** rows, and inserting requires core consent.
It is foreign-keyed to your profile with `on delete cascade`, so "delete my account" removes it
along with everything else — the GDPR delete needed no change.

Two columns are deliberately absent, and it matters that they stay absent: there is **no**
`result`, `normal`, `passed` or `target` column. Femio's reviewed guidance is that there is no
normal number of movements — what matters is a change from your baby's usual pattern — so the app
must never be able to store or show a verdict (ADR-049).

**Steps:** Supabase → **SQL Editor** → **New query** → paste all of
`supabase/migrations/0007_fetal_movement_sessions.sql` → **Run**.

**Verify — two checks, both quick:**

1. In the SQL Editor, run:

   ```sql
   select count(*) as policies
   from pg_policies
   where tablename = 'fetal_movement_sessions';
   ```

   Expect **4**. If the table were created without its policies, row-level security would block
   every write and the log would still not save — so this is the check that matters, not merely
   that the table exists.

2. In the app, sign in, make sure your mode is pregnancy, open **Track**, press **Start a
   session**, tap **I felt a movement** once, then **Finish and save**. It should save without an
   error and the session should appear under "Your recent sessions".

**Gotcha:** if the save reports an error mentioning `row-level security`, you are signed in but
have not granted core consent on that account — the insert policy requires it, exactly as it does
for periods and symptoms. Granting consent in Settings clears it.

---

## B. Activate the translation portal (P1.19)

> [DONE] **B1–B4 verified 2026-07-30** — `public.staff_roles` = `admin`; `public.ui_strings` holds 1,172 rows (293 keys x 4 locales; EN `human_reviewed`, AR/FR/ES `machine`). **B5 below is still open**: the app has grown to 482 strings, so re-seed to make the newest screens reviewable.

**Why:** Femio's UI text lives in the database so non-engineers can translate/approve it.
The portal at `/admin/translations` lets staff edit AR/FR/ES and approve strings; approving
one publishes it live. Two one-time steps switch it on: give yourself a **staff role**, then
**seed** the current English/Arabic/French/Spanish text into the DB.

**Prerequisite:** you need to be able to **sign in** to Femio with your own email account
(the sign-in page is task-linked below). If you onboarded anonymously, first create/link an
email in the app so you have a login.

### B1 — Find your auth user id
1. Dashboard → **Authentication** → **Users**.
2. Find your email, click the row, copy the **UID** (a uuid like `a1b2c3d4-…`).

### B2 — Grant yourself the `admin` role
1. Dashboard → **SQL Editor** → New query. Run (paste your UID):
```sql
insert into public.staff_roles (user_id, role)
values ('PASTE-YOUR-UID-HERE', 'admin');
```
2. "Success. No rows returned" = done. (Only an existing admin can grant roles via the app;
   this SQL bootstraps the very first one.)

**Verify:** 
```sql
select role from public.staff_roles where user_id = 'PASTE-YOUR-UID-HERE';
```
should return `admin`.

### B3 — Get the service-role key
1. Dashboard → **Project Settings** → **API** → **Project API keys** → copy the
   **`service_role`** key (marked *secret*). **Do not** paste it anywhere public.

### B4 — Seed the strings
From the repo root, in a terminal (Git Bash / PowerShell):
```bash
# Bash:
SUPABASE_SERVICE_KEY="<PASTE-YOUR-REAL-KEY-HERE>" node scripts/i18n/seed-ui-strings.mjs
```
```powershell
# PowerShell:
$env:SUPABASE_SERVICE_KEY="<PASTE-YOUR-REAL-KEY-HERE>"; node scripts/i18n/seed-ui-strings.mjs
```
You should see `✓ Seeded ui_strings…`. English is stored as **approved**, AR/FR/ES as
**drafts**.

> **`Invalid API key`?** The placeholder above is not a value — replace the whole
> `<PASTE-YOUR-REAL-KEY-HERE>` including the angle brackets with the actual secret from
> Supabase → **Project Settings → API Keys** → the **`service_role`** / secret key (starts
> `sb_secret_…` or `eyJ…`), *not* the publishable one. Running the line as printed sends the
> literal placeholder text as your key, which is exactly what the error is telling you.
>
> Afterwards, clear it from the shell so the secret isn't left in your session:
> `$env:SUPABASE_SERVICE_KEY=""` (or just close the terminal).
>
> The `Assertion failed … UV_HANDLE_CLOSING` line after an error is harmless Node-on-Windows
> exit noise — ignore it.

**Verify:** sign in to Femio, go to `https://<your-site>/en/admin/translations`. You should
see the status board and a table. Edit an Arabic string, click **Save & approve**, then open
an Arabic page — the new text should appear (within ~60s, or immediately since approving
busts the cache).

**Gotchas:**
- **"permission denied for table ui_strings"** when seeding → the `service_role` was missing
  base table grants (migration 0002 granted only `anon`/`authenticated`). Fix once by applying
  **`supabase/migrations/0004_grant_service_role.sql`** — paste its contents into the SQL Editor
  and Run, then re-run the seed. (The `Assertion failed … UV_HANDLE_CLOSING` line after the error
  is harmless Node-on-Windows exit noise.)
- "Not authorized" in the portal → the staff role (B2) isn't on the account you're signed in
  as. Re-check the UID matches your logged-in user.
- Seed script "Need … SERVICE_KEY" → the env var wasn't set in the same command.
- After seeding, **English looks unchanged** — correct: EN is the master and overlays
  identically. Only AR/FR/ES change as you approve them.

---

### B5 — Re-seed after new UI text ships (do this now)
Seeding is not one-and-done: the script imports whatever is in the JSON catalogs *today*. Since
the last seed, several screens shipped (privacy, terms, authors & reviewers, analytics consent, …),
so the database holds **293** strings per locale while the catalogs hold **482** — the new text is
live in English but invisible in the portal, so nobody can review the Arabic/French/Spanish drafts
Claude wrote for it.

Re-run exactly the B4 command. It **upserts**: existing rows keep their status (your approved
Arabic stays approved), new keys arrive as EN-approved / AR-FR-ES machine drafts.

```powershell
$env:SUPABASE_SERVICE_KEY="<PASTE-YOUR-REAL-KEY-HERE>"; node scripts/i18n/seed-ui-strings.mjs
```

**Verify:** `/en/admin/translations` shows a higher total per locale (≈482), and searching for
`privacy.` or `authors.` finds the new keys.

**Rule of thumb:** re-seed whenever Claude says "added N new UI strings" — or just before a
translation review session.

---

## B★. Configure auth email (redirect URLs + sender) — required for sign-in

**Why:** sign-in uses a **magic link** (passwordless). Supabase only redirects a magic link to
a URL on its **allow-list**; if the callback URL isn't listed, it silently falls back to the
**Site URL** — so you land on the home page, never signed in. Separately, Supabase's built-in
email is heavily rate-limited (a few/hour) and often spam-filtered — fine for testing, not launch.

**Steps — URL configuration (do this before trying sign-in):**
1. Dashboard → **Authentication → URL Configuration**.
2. **Site URL:** `https://femio-web.vercel.app` (or your custom domain when you add one).
3. **Redirect URLs** → add:
   - `https://femio-web.vercel.app/**`
   - `http://localhost:3000/**` (for local dev)
4. Save. Now request a link at `/en/sign-in`, open it (same browser, check spam) → it should land
   on `/api/auth/callback` and sign you in to the dashboard.

**Steps — real email sender (before launch):**
1. Dashboard → **Authentication → Emails / SMTP** → enable **Custom SMTP**.
2. Use a transactional provider (Resend, Postmark, SES, etc.): host, port, user, password, and a
   verified **from** address on your domain.
3. Optionally customize the magic-link email template.

**Verify:** you receive the link within seconds and clicking it signs you in.

**Gotcha:** the link is single-use and short-lived — if it expires, just request a new one.

**"Invalid login credentials" on password sign-in?** Your account was created passwordless
(onboarding links an email but sets no password), so there's nothing to match yet. Set one of
these ways: (a) fastest, no email — run the admin script with your service key:
```powershell
$env:SUPABASE_SERVICE_KEY="…"; $env:EMAIL="dr.khaled.hassanein@gmail.com"; $env:NEW_PASSWORD="a-strong-password"; node scripts/auth/set-password.mjs
```
then sign in with email + password; or (b) use **Forgot password?** / magic link (needs the
redirect URLs above), then set a password in **Settings → Password**.

---

## B★★. Enable "Continue with Google" sign-in (optional, staff-friendly)

> [DONE] **Verified 2026-07-30** — Supabase reports the Google provider enabled, and the live `/en/sign-in` renders the "Continue with Google" button, so `NEXT_PUBLIC_ENABLE_GOOGLE_AUTH` is set *and* deployed.

**Why:** magic link + password already work. Google sign-in is fast and
phishing-resistant — nice for staff. The code is built; the button stays hidden
until you (1) configure the Google provider in Supabase and (2) flip an env flag,
so users never hit an unconfigured provider.

**Steps:**
1. **Google Cloud** → create an OAuth 2.0 Client ID (type: *Web application*).
   - Authorized redirect URI: `https://wnthtqtcajkhskdygbgo.supabase.co/auth/v1/callback`
     (Supabase shows the exact URL in the next step). Copy the **Client ID** + **Client secret**.
2. **Supabase** → Authentication → **Providers → Google** → enable, paste the Client ID +
   secret, save.
3. **Vercel** → add env var `NEXT_PUBLIC_ENABLE_GOOGLE_AUTH=true` (Production + Preview) and
   **redeploy** (NEXT_PUBLIC_* bake in at build). For local dev, add it to `apps/web/.env.local`.
4. Confirm your app callback URLs are still allow-listed (task B★).

**Verify:** the sign-in page now shows "Continue with Google"; clicking it completes Google
sign-in and lands on the dashboard.

**Gotcha:** if the button doesn't appear, the env flag isn't set/deployed. If clicking errors
"provider is not enabled", finish step 2.

---

## B★★★. Enrol two-step sign-in (required for the back office) — 3 min

> [TODO] New 2026-07-31 with P1.23.3. **This changes something you'll notice:** staff pages now
> check for a second factor, so `/en/admin/translations` and `/en/admin/insights` will bounce you
> to Settings until you finish the steps below. That is the feature working, not a fault.

**Why:** a back-office session can read the translation portal and the aggregate insights — and an
admin can grant roles to other accounts. A stolen or reused password should not be enough for any
of that. The rest of Femio is unchanged: the tracker, the public site and the CMS don't ask for it
(the CMS is a separate app with its own login).

**Steps:**
1. Sign in at `https://femio-web.vercel.app/en/sign-in`.
2. Go to **Settings** -> **Two-step sign-in** -> **Set up two-step sign-in**.
3. Scan the QR code with an authenticator app — Google Authenticator, 1Password, Aegis, Apple
   Passwords, whichever you already use. (Can't scan? The key is printed underneath; type it in.)
4. Enter the 6-digit code the app shows and confirm. Codes rotate every 30 seconds — if one is
   rejected, use the current one.

**Verify:** Settings shows "Two-step sign-in is on", and `/en/admin/insights` opens after asking
for one code.

**Gotchas:**
- **Save the setup key** (the text under the QR) somewhere safe, or add the account to an
  authenticator that syncs.
- **If you lose the authenticator**, recovery is a service-key script (there is no self-service
  reset in Supabase). From the repo root, look first, then clear:
  ```powershell
  $env:SUPABASE_SERVICE_KEY="…"; $env:EMAIL="you@example.com"; $env:DRY_RUN="1"; node scripts/auth/reset-mfa.mjs
  # happy with what it lists? run it again without DRY_RUN
  ```
  It deletes factors only — your password, roles and data are untouched — and you can sign in with
  the password alone until you re-enrol, which you should do straight away (staff pages stay closed
  until you do).
- Enrolling on the account you use daily is fine; you are asked for a code once per session, not on
  every page.
- If codes keep failing, check the phone clock is set automatically — TOTP is time-based.

---

## C. Bring the CMS online — deploy on Vercel (no local setup)

**Why:** the Payload CMS (`apps/cms`) is where medical articles/conditions are authored and
run through the draft→medical-review→publish gate. It's designed to run as its **own Vercel
project** on the **shared Supabase database** (ADR-012) — you don't need to run anything
locally. Claude prepared it so this is turnkey: Payload's tables live in an isolated `payload`
schema (they can't touch the app's tables), and a one-time env flag makes the first deploy
create the schema automatically.

**You need two secrets + a few dashboard clicks. Claude can't do this part — it has no access
to your Vercel/Supabase accounts or the DB password.**

### C1 — Gather the two secrets
1. **DATABASE_URL** — Supabase dashboard → **Project Settings → Database → Connection string →
   "Session pooler" (URI)**. Copy it and put your DB password in place of `[YOUR-PASSWORD]`.
   Must be the **session** pooler (port **5432**), not transaction (6543). Looks like:
   `postgresql://postgres.wnthtqtcajkhskdygbgo:<db-password>@aws-0-<region>.pooler.supabase.com:5432/postgres`
2. **PAYLOAD_SECRET** — a long random string. On Windows (no `openssl`), generate with Node:
   ```powershell
   node -e "console.log(require('crypto').randomBytes(32).toString('base64'))"
   ```

### C1.5 — Create the isolated `payload` schema (one line, required)
Payload's tables live in a dedicated `payload` schema so they never collide with the app's
`public` tables. Create it: Supabase → **SQL Editor** → run:
```sql
create schema if not exists payload;
```
Idempotent — safe to re-run.

### C2 — Create the CMS Vercel project (from the same repo)
1. Vercel → **Add New… → Project** → import the **same GitHub repo** (KhaledHassanein/Femio).
2. In the configure screen, set **Root Directory = `apps/cms`** (click *Edit* next to Root
   Directory and pick it). Framework preset auto-detects **Next.js**; leave build/install commands
   as default (Vercel runs the pnpm workspace install automatically).
3. **Environment Variables** (add for Production **and** Preview):
   - `DATABASE_URL` = the session-pooler URI from C1
   - `PAYLOAD_SECRET` = the random string from C1
   - `PAYLOAD_DB_PUSH` = `true`  ← makes the first deploy create Payload's tables automatically
4. Click **Deploy**. Give the project a name like `femio-cms`.

### C2.5 — Create the database schema once (required)
Payload's auto-create (`push`) does **not** run on Vercel's serverless environment (it's
non-interactive), so the tables must be created once from a machine that can connect. Easiest:
run the CMS locally a single time against the shared Supabase DB — this creates every table, after
which the deployed CMS works permanently.
1. In `apps/cms/.env.local` set `DATABASE_URL` (session pooler + real password) and
   `PAYLOAD_SECRET` (same as Vercel).
2. From the repo root: `pnpm --filter cms dev`. If prompted "Accept schema changes?", press **y**.
3. Open `http://localhost:3001/admin`, create the first admin, then stop the server (Ctrl+C).
4. (Confirm in Supabase → Table Editor that `users`, `articles`, … now exist.)

*(Proper alternative for repeatable deploys: generate migrations once with
`pnpm --filter cms exec payload migrate:create`, commit them, and set the Vercel build command to
`pnpm --filter cms exec payload migrate && next build`. Claude can wire this later.)*

### C3 — Log in to the deployed admin
1. Open `https://<your-cms-project>.vercel.app/admin`.
2. Log in with the admin you created in C2.5 (or, if the schema existed but no user yet, the
   "create first user" screen appears — set email + password).

### C3.5 — Connect the website to the CMS (show content on the site)

> [TODO] **The one thing Claude cannot check from outside.** `NEXT_PUBLIC_CMS_URL` is read server-side only, so it leaves no trace in the public HTML — and with zero published articles the page looks identical either way.
>
> **How to tell in 30 seconds:** publish one Article in the CMS, wait ~5 min (ISR), open `https://femio-web.vercel.app/en/learn`. Article visible → the variable is set. Still "new guides on the way" → it is missing, or the running deploy predates it (`NEXT_PUBLIC_*` bakes in at build — redeploy after adding it).
So published articles appear on the public site (`/learn`):
1. Vercel → the **web app** project (femio-web) → Settings → Environment Variables → add
   `NEXT_PUBLIC_CMS_URL` = your CMS URL (e.g. `https://femio-cms.vercel.app`).
2. **Redeploy** the web app (NEXT_PUBLIC_* bake in at build).
3. In the CMS, create an Article, run it through review to **Published** → it shows at
   `https://<web>/en/learn` (and the article page) within ~5 min (ISR). Until then `/learn`
   shows a friendly "new guides on the way" empty state.

### C3.6 — Schema for a new collection (**People** — already done, nothing for you)
**Status: done automatically, verified 2026-07-30.** The `people` tables (author / medical-reviewer
bios) exist in the `payload` schema and the live CMS serves `/api/people` (HTTP 200), so
`https://<web>/en/authors` will list bios as soon as you publish one.

Why it needed no local run: **`PAYLOAD_DB_PUSH=true` is still set on the `femio-cms` Vercel
project**, so the deploy that shipped the collection created the tables itself (purely additive
changes don't hit Payload's interactive prompt). Useful now — but it means **production still
auto-syncs its schema on every deploy**, which is exactly what C4 says to turn off. Recommended:
leave it while the content model is still moving (P1.9 will add fields), then do C4 before real
content exists, because a *destructive* change (a removed field) could otherwise drop a column of
published content without asking. Claude will wire `payload migrate` when you're ready.

### C3.7 — Make yourself a CMS **admin** (1 command, 1 minute) — do this to publish anything
**Why:** Payload's "create first user" screen skips the admin-only rule but still applies the role
default, so your CMS account (`dr.khaled.hassanein@gmail.com`) is **`editor`** — and the `roles`
field can only be changed *by an admin*, of which there are currently **none**. That's a bootstrap
deadlock: as an editor you can write drafts but **cannot approve, cannot publish, and cannot manage
users**. It's the CMS twin of the `staff_roles` bootstrap in task B2.

Claude wrote the fix but is not permitted to run privilege changes against your database, so this
one is yours. Nothing to paste — the script reads `apps/cms/.env.local`, which already has your
`DATABASE_URL` + `PAYLOAD_SECRET`. From the repo root:

```powershell
# PowerShell
$env:EMAIL="dr.khaled.hassanein@gmail.com"; $env:ROLES="admin,editor"; pnpm --filter cms set-roles
```
```bash
# Bash
EMAIL=dr.khaled.hassanein@gmail.com ROLES=admin,editor pnpm --filter cms set-roles
```
It prints `roles before` / `roles after`. Valid roles: `admin`, `editor`, `medical_reviewer`,
`translator`. If you've also **lost the CMS password**, add `NEW_PASSWORD=…` to the same command
(Payload has no email sender configured, so its forgot-password link can't reach you).

**Verify:** sign in at `https://femio-cms.vercel.app/admin` → **Users** is now editable, and an
Article can go **Approved → Published** (as `admin` you pass the review gate).

**Then:** add a bio under **People** (name, slug, credentials, job title, affiliation, short
biography, profile links) and **Publish** it → it appears at `https://<web>/en/authors` within ~5 min.

**Governance note:** approving your own content satisfies the software gate but not the *spirit* of
doc 15 (independent medical review). Before the first public article, create a **separate
`medical_reviewer` account** for the reviewing clinician (as admin you can, in *Users*) and let that
account do the approving. (Tracked in the TODO under P1.9.)

### C4 — Harden (after it works)
- Once you can log in and see the collections, remove `PAYLOAD_DB_PUSH` from Vercel (and
  redeploy) so production no longer auto-syncs schema; schema changes then go through migrations
  (Claude can add these later).

**Verify:** you can log into `/admin`, and Articles / Conditions / FAQs / Tips / Glossary
collections appear. In Supabase → Database → Schemas you'll see a new **`payload`** schema with
its tables (your app's `public` tables are untouched).

**Gotchas:**
- Wrong pooler (6543) → prepared-statement errors. Use **5432** (session pooler).
  Note (2026-08-05, ADR-044): the 5432 session pooler holds one Postgres connection per
  client for its whole life and caps at 15. That is fine now — the CMS pins `max: 1` per
  instance — but it is why `EMAXCONNSESSION` appeared twice while publishing. If it ever
  returns, look for orphaned local `payload` processes and per-document query loops before
  touching the pooler mode.
- **"Application error: a server-side exception (Digest …)"** at `/admin` → read the real error:
  Vercel → the `femio-cms` project → **Deployments → (latest) → Runtime Logs** (or the *Functions*
  tab), reload `/admin`, and find the logged stack. Most common causes:
  1. **Bad `DATABASE_URL`** (wrong password, or transaction pooler 6543 instead of session 5432) → fix, redeploy.
  2. **`PAYLOAD_SECRET` empty** → set it, redeploy.
  3. **`PAYLOAD_DB_PUSH` not `true`** on the first deploy → tables never created; set it, redeploy.
  Env-var changes only take effect after a **redeploy**. Quick check without the logs UI: open
  `https://<cms>.vercel.app/api/users` — a DB problem often returns a JSON error with the real message.
- If the first admin screen doesn't load, the schema didn't create → confirm `PAYLOAD_DB_PUSH=true`
  is set and redeploy; check the deploy logs for a DB connection error (usually a bad password in
  DATABASE_URL).
- This is a **second** Vercel project (separate from the web app) sharing one database — that's
  intended.

*(Local alternative, if you ever want it: fill `apps/cms/.env.local` from `.env.example` and run
`pnpm --filter cms dev` → `http://localhost:3001/admin`. Not needed for production.)*

---

## D. Choose + set up an analytics vendor (unblocks P1.20)

> [TODO] **Verified not configured 2026-07-30** (no PostHog key in the live bundle). The ground has moved since this section was written: migration `0005` is applied and **the event layer is already built** (P1.20, ADR-017) — typed allow-list, health-field-free, consent-gated, and a no-op while no key exists. Read `docs/19_ANALYTICS_EVENT_SCHEMA.md` (especially the deliberate exclusions) before signing the DPA, then set `NEXT_PUBLIC_POSTHOG_KEY` + `NEXT_PUBLIC_POSTHOG_HOST` (**EU host — a non-EU value fails the build on purpose**) and redeploy.

**Why:** we want product analytics (funnels, retention) **without any health data** ever
reaching a third-party SDK (product rule 4 + the DPIA). That means an **EU-hosted,
consent-respecting** tool. Recommended: **PostHog EU Cloud** (or self-host). Once you give
me the key, Claude wires a health-field-free event layer that only fires with consent.

**Steps (PostHog EU):**
1. Go to https://eu.posthog.com and sign up (choose the **EU** region — important for GDPR).
2. Create a project "Femio".
3. Project Settings → copy the **Project API key** (starts `phc_…`) and the **host**
   (`https://eu.i.posthog.com`).
4. Add them to Vercel (see task E) as `NEXT_PUBLIC_POSTHOG_KEY` and
   `NEXT_PUBLIC_POSTHOG_HOST`. Tell Claude the values are set (not the key itself).

**Already built (2026-07-30, P1.20):** the event layer exists and is a **verified no-op**
until you set the key — no third-party script loads at all today. The event catalog is a
*closed* list (fixed events, fixed properties, every value from a short fixed set, no
free-form text/numbers/dates), a runtime guard drops anything else, and `pnpm analytics-lint`
in CI blocks any future drift. Read `docs/19_ANALYTICS_EVENT_SCHEMA.md` before approving —
the part to check is the **deliberate exclusions**, because a few things you might expect to
see are excluded on purpose (article slugs, *which* calculator was used, life-stage mode,
condition tags, age bands, and anything about the crisis-help surface).

**Two things must happen before analytics actually collects anything:**
1. **Sign the PostHog DPA** and mark the row signed in `docs/compliance/PROCESSOR_REGISTER.md`.
   Setting the key without a signed DPA is the violation, not a shortcut.
2. **The consent toggle must ship (P1.20.2).** Analytics has its own opt-in consent purpose,
   and nothing asks for it yet — so even with the key set, `track()` stays off for every user
   until that UI lands. Also apply migration **`0005`** (task A2 below) so the purpose is
   recordable.

**Gotcha (now enforced, not just advised):** the host must be the PostHog **EU** cloud. Their
SDK defaults to the **US** host, so a wrong or missing host would quietly ship data abroad —
`NEXT_PUBLIC_POSTHOG_HOST` is therefore validated and a non-EU value (or a key with no host)
**fails the build** rather than deploying. If a deploy fails with `Invalid environment
variables: NEXT_PUBLIC_POSTHOG_HOST`, that guard is doing its job.

**Still to ask for:** the dashboard itself. The dimensions the original plan wanted (retention
by life-stage, condition tags, age bands) can't come from PostHog — they're special-category
data — so they become a first-party dashboard over our own database (P1.20.3).

---

## E. Vercel env hygiene + optional crisis directory link

> [MOSTLY DONE] **Verified 2026-07-30** — canonical URLs resolve to `https://femio-web.vercel.app` (so `NEXT_PUBLIC_APP_URL` is right), and the **crisis directory link is live**: `/en/help-now` renders `https://findahelpline.com`.
>
> **One thing to close:** that link was meant to go on *only after* ThroughLine's linking/commercial terms were confirmed. If you have confirmed them, record it in `docs/compliance/CRISIS_RESOURCES.md § Directory policy` (task H) so the decision is evidenced. If not, either confirm them or unset `NEXT_PUBLIC_CRISIS_DIRECTORY_URL` and redeploy — the crisis screen works fine without it.

**Why:** the site reads its config from `NEXT_PUBLIC_*` env vars **baked in at build**.
Changing them needs a redeploy.

**Steps:**
1. Vercel → your project → **Settings → Environment Variables**.
2. Confirm these exist (Production + Preview):
   - `NEXT_PUBLIC_APP_URL` (your live URL)
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY`
3. **Optional — turn on the crisis helpline directory link:** add
   `NEXT_PUBLIC_CRISIS_DIRECTORY_URL=https://findahelpline.com/` **only after** confirming
   ThroughLine's linking terms (see `docs/compliance/CRISIS_RESOURCES.md`). Any other host or
   a URL with a query string **fails the build on purpose** — that's the safety guard.
4. After any change, **redeploy** (Deployments → ⋯ → Redeploy, or push a commit).

**Verify:** open the site, hard-refresh; the "Need help now?" dialog shows the Find A Helpline
link once the var is set.

---

## F. Google Search Console + custom domain (SEO, P1.11.GSC)

> **Domain purchased 2026-08-03: `femioapp.com`.** Do this **before** the P1.9 content push —
> every article's canonical URL, sitemap entry, hreflang tag and social preview is built from
> `NEXT_PUBLIC_APP_URL`, so publishing sixty articles first means sixty redirects and a
> re-indexing cycle afterwards. The four steps, in order:
>
> 1. **Vercel → femio-web → Settings → Domains** → add `femioapp.com` (and `www.femioapp.com`,
>    redirecting to the apex). Add the DNS records it shows at your registrar; wait for it to go
>    green.
> 2. **Vercel → femio-web → Settings → Environment Variables** → set
>    `NEXT_PUBLIC_APP_URL=https://femioapp.com` (Production **and** Preview) → **redeploy**. This
>    is the one that matters for SEO; it bakes in at build time.
> 3. **Supabase → Authentication → URL Configuration** → Site URL `https://femioapp.com`, and add
>    `https://femioapp.com/**` to Redirect URLs (keep `http://localhost:3000/**` for local work).
>    Without this, magic links and Google sign-in land on the old origin.
> 4. **Search Console** → add a **Domain** property for `femioapp.com`, verify by DNS TXT, then
>    submit `https://femioapp.com/sitemap.xml`. Set `NEXT_PUBLIC_GOOGLE_SITE_VERIFICATION` in
>    Vercel if you use the meta-tag method instead.
>
> Leave the CMS on `femio-cms.vercel.app` — it is back-office and its address is never seen by a
> visitor. `NEXT_PUBLIC_CMS_URL` does **not** change.
>
> **Verify:** `curl -sI https://femioapp.com/en | grep -i location` returns nothing (no redirect
> loop), and the page source shows `<link rel="canonical" href="https://femioapp.com/en"/>`.
> Tell Claude when it's live — a few docs still name the vercel.app host.

> [TODO] **Verified not done 2026-07-30** — no `google-site-verification` tag in the live pages, and canonicals still point at `femio-web.vercel.app`. Worth doing before content lands so indexing starts early; nothing in the build depends on it.

**Why:** to appear in Google and control indexing. Femio is SEO-first, so this matters for
growth.

**Steps:**
1. **Custom domain:** Vercel → Settings → Domains → add your domain, follow the DNS records
   it shows at your registrar. Then update `NEXT_PUBLIC_APP_URL` (task E) to the new domain and
   redeploy.
2. **Search Console:** https://search.google.com/search-console → add a property (Domain
   type). Verify via the DNS TXT record it gives you.
3. Grab the verification token; set `NEXT_PUBLIC_GOOGLE_SITE_VERIFICATION` in Vercel (task E)
   and redeploy (Femio injects it into the page head automatically).
4. In Search Console → **Sitemaps** → submit `https://<your-domain>/sitemap.xml`.

**Verify:** Search Console shows the property "Verified" and the sitemap "Success".

**Gotcha:** `/help-now` is intentionally excluded from the sitemap and marked noindex — that's
correct, don't add it.

---

## G. Sentry error monitoring — 5 min

> **The code is wired (2026-08-03, ADR-026); only the DSN is missing.** Set it and errors start
> arriving. It is no longer optional in spirit: the 500-instead-of-404 bug lived in production for
> weeks precisely because nothing was watching.
>
> 1. Sentry → create the project with **region: EU** (the DSN must read `…ingest.de.sentry.io`).
>    A US DSN **fails the Femio build on purpose** — error reports carry request context, so they
>    follow the same EU-residency rule as everything else.
> 2. Copy the **DSN**.
> 3. Vercel → **femio-web** → Settings → Environment Variables → `NEXT_PUBLIC_SENTRY_DSN`
>    (Production + Preview) → **redeploy**.
> 4. Verify: Sentry → your project → *Issues*. Nothing should appear (that's good). To prove the
>    pipe works, visit a page and trigger any client error, or tell Claude and it can add a
>    throwaway route for one deploy.
>
> **What Sentry will and won't see.** It gets the route *pattern* (`/[locale]/learn/[slug]`), the
> error and the stack. It does **not** get the URL you were on, anything you typed, your cookies,
> your user id, or a session recording — all stripped before sending. Stack traces are minified
> until source-map upload is set up (P1.4.3b, needs an auth token).


**Why:** catch runtime errors in production (like the hydration crash we hit once) before
users report them.

**Steps:**
1. Create a Sentry project (Next.js). Copy the **DSN**.
2. Add `SENTRY_DSN` (and any `NEXT_PUBLIC_SENTRY_DSN`) in Vercel; redeploy.
3. Tell Claude it's set and to wire the SDK (kept out of health-data paths).

---

## H. Human sign-offs — crisis safety (P1.26)

**Why:** safety-critical copy needs a human, not code, to bless it.

- **P1.26.1 — global-only crisis posture:** your DPO + a medical reviewer confirm that
  showing a global "emergency services / nearest ED" route (instead of per-country phone
  numbers) is acceptable, and record it in `docs/compliance/DPIA.md §5`. This rides along with
  the P0.12 legal gate (task I).
- **P1.26.2 — translate the crisis copy:** a human linguistic reviewer translates the
  Arabic/French/Spanish crisis wording, then Claude sets it in `crisis.json` with a new
  12-month review date. Until then those locales safely show the approved **English** text.

**Verify:** the CI "crisis-safety compliance guard" stays green (it fails if approved copy is
expired or missing reviewer metadata).

---

## I. Legal + DPO launch gate (P0.12) — before any real user health data

**Why:** Femio processes special-category health data across the EU, Gulf, and Egypt. Real
users cannot onboard for real until counsel + a DPO finalize the foundations.

**Checklist (hand to counsel/DPO):**
- Entity + Data Protection Officer appointed; EU representative if required.
- Privacy Policy + Terms finalized (drafts in `docs/13_LEGAL_COMPLIANCE.md`).
- **DPIA** completed and signed (`docs/compliance/DPIA.md` — includes the crisis posture,
  task H, and the security review `docs/compliance/SECURITY_REVIEW.md`).
- Per-jurisdiction minor-consent ages + verifiable parental consent.
- International-transfer mechanism; processor register up to date.
- Consent wording reviewed (the app's current copy is a faithful placeholder).

**Verify:** all items signed; DPIA §5 has a residual-risk assessment + sign-off.

---

*Maintained alongside `docs/07_MASTER_TODO.md`. When you finish a task, tick its box here and
tell Claude — several unlock further automated work (e.g., B lets Claude verify the portal
end-to-end; D lets Claude wire analytics).*
