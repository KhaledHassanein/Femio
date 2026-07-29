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

## Priority checklist

- [ ] **A.** Apply migration `0003` (delete-account RPC) — 5 min
- [ ] **B.** Activate the translation portal (P1.19): grant a staff role + seed strings — 15 min
- [ ] **B★.** Configure auth email (redirect URLs) so sign-in works — 5 min
- [ ] **C.** Bring the CMS online (unblocks content, P1.11.1) — 20 min
- [ ] **D.** Choose + set up an analytics vendor (unblocks P1.20) — 20 min
- [ ] **E.** Vercel env hygiene + optional crisis directory link — 10 min
- [ ] **F.** Google Search Console + custom domain (SEO) — 20 min
- [ ] **G.** Sentry error monitoring (optional) — 10 min
- [ ] **H.** Human sign-offs: crisis posture + translations (P1.26) — ongoing
- [ ] **I.** Legal + DPO launch gate (P0.12) — the big one before real users

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

## B. Activate the translation portal (P1.19)

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
SUPABASE_SERVICE_KEY="paste-service-role-key" node scripts/i18n/seed-ui-strings.mjs
```
```powershell
# PowerShell:
$env:SUPABASE_SERVICE_KEY="paste-service-role-key"; node scripts/i18n/seed-ui-strings.mjs
```
You should see `✓ Seeded ui_strings…`. English is stored as **approved**, AR/FR/ES as
**drafts**.

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

### C3 — Create the first admin
1. When the deploy is **Ready**, open `https://<your-cms-project>.vercel.app/admin`.
2. Payload shows a "create first user" screen → set your email + a password. That's your CMS
   admin login.

### C4 — Harden (after it works)
- Once you can log in and see the collections, remove `PAYLOAD_DB_PUSH` from Vercel (and
  redeploy) so production no longer auto-syncs schema; schema changes then go through migrations
  (Claude can add these later).

**Verify:** you can log into `/admin`, and Articles / Conditions / FAQs / Tips / Glossary
collections appear. In Supabase → Database → Schemas you'll see a new **`payload`** schema with
its tables (your app's `public` tables are untouched).

**Gotchas:**
- Wrong pooler (6543) → prepared-statement errors. Use **5432** (session pooler).
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

**What Claude will build once set:** a typed event allowlist (page/feature/funnel events
only — never symptoms, dates, conditions), gated on analytics consent, no-op when the key is
absent; plus the dashboard embed.

**Gotcha:** never put health context (persona mode, symptom names, cycle dates) into an
event — that's the whole point. If unsure whether an event is safe, ask.

---

## E. Vercel env hygiene + optional crisis directory link

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

## G. Sentry error monitoring (optional)

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
