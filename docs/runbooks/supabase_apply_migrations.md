# Runbook — Apply Supabase migrations (P1.3)

Audience: Khaled. The migrations live in `supabase/migrations/` and are **authored but not yet
applied** to the remote project (Claude Code holds only the client-safe publishable key, which
cannot run DDL). Apply them once; re-run only new migration files as they are added.

Project: `wnthtqtcajkhskdygbgo` (EU).

---

## Step 1 — Apply the schema + RLS (choose ONE)

### Option A — Dashboard SQL Editor (no install, recommended for first apply)
1. Supabase dashboard → **SQL Editor** → New query.
2. Paste the **entire contents** of `supabase/migrations/0001_schema_v1.sql`, Run.
3. New query → paste **`supabase/migrations/0002_rls_policies.sql`**, Run.
4. Order matters: 0001 before 0002. The editor runs as the `postgres` role, so the
   `on_auth_user_created` trigger on `auth.users` is allowed.

### Option B — Supabase CLI (repeatable, for future migrations)
```bash
npx supabase login                                   # opens browser for an access token
npx supabase link --project-ref wnthtqtcajkhskdygbgo # prompts for the DB password
npx supabase db push                                 # applies pending migrations in order
```
Config is in `supabase/config.toml`. Never commit the DB password or access token.

---

## Step 2 — Enable anonymous sign-ins (required)
Femio's privacy model needs anonymous mode (product rule 4). The project currently has it
**off** (`anonymous_users: false`).
- Dashboard → **Authentication → Sign In / Providers → Anonymous** → enable.
- (Email is already enabled. Enable OAuth providers later with their client IDs/secrets.)

---

## Step 3 — Smoke-test (verify)
In the SQL Editor:
```sql
-- 23 tables present, all with RLS enabled (rowsecurity = true expected for every row)
select tablename, rowsecurity
from pg_tables where schemaname = 'public' order by tablename;

-- policies exist
select tablename, count(*) from pg_policies where schemaname = 'public'
group by tablename order by tablename;
```
Then, from the app (`pnpm dev`), a signed-in test:
- Sign up / anonymous sign-in creates an `auth.users` row → a `public.profiles` row auto-appears
  (handle_new_user trigger).
- Insert into a health table **fails** until a `core` consent row exists (consent gate), then
  succeeds and is only visible to that user (owner-only RLS).

---

## Notes
- The publishable key is client-safe (RLS-protected). A **server-only secret key**
  (`sb_secret_…`) will be needed later for trusted admin RPCs (P1.18+) — add it to `.env.local`
  as `SUPABASE_SECRET_KEY` (no `NEXT_PUBLIC_` prefix), never commit it.
- New schema changes = **new** numbered migration files (never edit an applied one).
