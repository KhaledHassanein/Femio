-- =============================================================================
-- Femio — everything the 2026-10-07 revamp needs from the database, in ONE paste.
--
-- HOW TO RUN (see docs/runbooks/OWNER_GUIDE_A_TO_Z.md, step 2):
--   Supabase dashboard → your "Femio" project → SQL Editor → New query →
--   paste this whole file → Run.
--
-- It is ONE transaction: either all of it applies, or none of it does. Safe to run
-- twice: the second run does nothing harmful (it stops at the guard in part 1 only if
-- the content tables were somehow refilled, and says why).
--
-- What it does, in plain words:
--   1. Removes three empty tables nobody uses (migration 0024). It checks they are
--      empty first and refuses otherwise.
--   2. Applies the Supabase security advisor fixes (migration 0025).
--   3. Adds one column the upgraded CMS (Payload 3.90) needs, so CMS login keeps
--      working after the merge.
--   4. Writes all three into the migration history, so the Supabase CLI and Payload
--      both know they are done and never try to run them again.
-- =============================================================================

begin;

-- ---------------------------------------------------------------- part 1 · 0024
-- supabase/migrations/0024_drop_unused_content_tables.sql, made re-runnable: it does
-- nothing if the tables are already gone, and refuses if any of them holds a row.
do $m0024$
declare
  n bigint;
begin
  if to_regclass('public.content') is null then
    raise notice '0024 already applied: skipping';
    return;
  end if;
  select (select count(*) from public.content)
       + (select count(*) from public.content_i18n)
       + (select count(*) from public.content_history)
    into n;
  if n > 0 then
    raise exception '0024 refused: % row(s) in content/content_i18n/content_history. Nothing was changed. Tell Claude.', n;
  end if;
  drop table if exists public.content_history;
  drop table if exists public.content_i18n;
  drop table if exists public.content;
end
$m0024$;

-- ---------------------------------------------------------------- part 2 · 0025
-- 0025 — act on the Supabase security and performance advisors (read 2026-10-07).
--
-- First run of the advisors since the project was created. Every finding below was
-- read against the function's definition and the app's RPC calls before changing it.
-- What is deliberately NOT changed is listed at the end with the reason.

-- ---------------------------------------------------------------------------
-- 1 · SECURITY DEFINER functions that a visitor with no session could call.
--
-- Supabase grants EXECUTE on new functions to PUBLIC, and so to `anon`. Each of
-- these needs a signed-in caller: they read auth.uid(), or they check a staff role
-- inside. An anonymous *account* (onboarding's "no email needed") is `authenticated`,
-- not `anon`, so nothing in the product loses access. Only callers with no JWT at
-- all do.
-- ---------------------------------------------------------------------------
revoke execute on function public.delete_account() from public, anon;
grant  execute on function public.delete_account() to authenticated, service_role;

revoke execute on function public.redeem_partner_invite(text) from public, anon;
grant  execute on function public.redeem_partner_invite(text) to authenticated, service_role;

revoke execute on function public.insights_overview() from public, anon;
revoke execute on function public.insights_by_dimension(text) from public, anon;
revoke execute on function public.insights_retention(integer) from public, anon;
grant  execute on function public.insights_overview() to authenticated, service_role;
grant  execute on function public.insights_by_dimension(text) to authenticated, service_role;
grant  execute on function public.insights_retention(integer) to authenticated, service_role;

-- A trigger function, never an RPC. EXECUTE is checked when a trigger is created,
-- not when it fires, so revoking it from every API role changes nothing about
-- signup and closes /rest/v1/rpc/handle_new_user.
revoke execute on function public.handle_new_user() from public, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 2 · Functions with a role-mutable search_path. None is SECURITY DEFINER, so the
-- exposure is small, but pinning it costs nothing. `public, pg_temp` rather than ''
-- because some of them call each other unqualified.
-- ---------------------------------------------------------------------------
alter function public.set_updated_at() set search_path = public, pg_temp;
alter function public.insights_k() set search_path = public, pg_temp;
alter function public.partner_scope_is_allowed(jsonb) set search_path = public, pg_temp;
alter function public.notification_kinds_are_allowed(jsonb) set search_path = public, pg_temp;
alter function public.femio_ts_config(text) set search_path = public, pg_temp;
alter function public.femio_search_tsquery(regconfig, text) set search_path = public, pg_temp;

-- ---------------------------------------------------------------------------
-- 3 · Performance.
-- ---------------------------------------------------------------------------
-- Two identical indexes, (profile_id, logged_at desc). Every write paid for both.
drop index if exists public.fertility_logs_profile_idx;

-- Foreign keys with no covering index: a delete of the parent row (deleting a
-- pregnancy, or an account) scans the child table.
create index if not exists contractions_pregnancy_idx on public.contractions (pregnancy_id);
create index if not exists fetal_movement_sessions_pregnancy_idx on public.fetal_movement_sessions (pregnancy_id);
create index if not exists audit_log_actor_idx on public.audit_log (actor);
create index if not exists feature_flags_updated_by_idx on public.feature_flags (updated_by);

-- ---------------------------------------------------------------------------
-- Not changed, on purpose:
-- - has_core_consent(uuid) and is_staff(uuid, text[]) stay executable by anon and
--   authenticated. RLS policies call them, and a policy evaluates with the caller's
--   privileges: revoking EXECUTE would turn every anon read of feature_flags (and
--   every insert gated on consent) into a permission error. They return a boolean
--   about a uuid the caller must already know.
-- - search_content / search_content_in stay public: /search is public by design
--   (0022), and it searches only published content.
-- - "Anonymous access policies" on every user table are expected: anonymous sign-in
--   is the product's no-email start, and every one of those policies is scoped to
--   auth.uid().
-- - Unused-index findings: the app has had no real traffic, so "never used" means
--   "never exercised yet", not "useless". Re-read after launch.
-- - Leaked-password protection is a dashboard setting (OWNER_ACTIONS).
-- ---------------------------------------------------------------------------


-- ---------------------------------------------------------------- part 3 · Payload 3.90
ALTER TABLE "payload"."users" ADD COLUMN IF NOT EXISTS "reset_password_requested_at" timestamp(3) with time zone;

-- ---------------------------------------------------------------- part 4 · history
insert into supabase_migrations.schema_migrations (version, name, statements)
values
  ('0024', 'drop_unused_content_tables', array[$h1$-- 0024 — drop the three content tables schema v1 sketched and nothing ever used.
--
-- `content` and `content_i18n` were superseded before launch: Payload owns authored
-- content in its own `payload` schema (see apps/cms/src/payload.config.ts), and the
-- revamp publishes from the repository (docs/30_REVAMP/03 §4, I-1). `content_history`
-- (per-user reading history) references `content` and has never had a reader or a
-- writer anywhere in the codebase — verified by search on 2026-10-07.
--
-- Unused tables are not free: each carries RLS policies an audit has to read, grants
-- that a future `alter default privileges` change touches, and a name that invites the
-- next session to build on it. Dropping them makes the schema say what is true.
--
-- GUARDED: this refuses to run if any of the three holds a single row. "Never used" was
-- established from the code; the database gets to disagree, and if it does, a human
-- looks before anything is lost. Policies, triggers and indexes go with the tables.

do $$
declare
  n bigint;
begin
  select (select count(*) from public.content)
       + (select count(*) from public.content_i18n)
       + (select count(*) from public.content_history)
    into n;
  if n > 0 then
    raise exception '0024 refused: % row(s) in content/content_i18n/content_history — inspect before dropping', n;
  end if;
end
$$;

drop table if exists public.content_history;
drop table if exists public.content_i18n;
drop table if exists public.content;
$h1$]),
  ('0025', 'advisor_hardening', array[$h2$-- 0025 — act on the Supabase security and performance advisors (read 2026-10-07).
--
-- First run of the advisors since the project was created. Every finding below was
-- read against the function's definition and the app's RPC calls before changing it.
-- What is deliberately NOT changed is listed at the end with the reason.

-- ---------------------------------------------------------------------------
-- 1 · SECURITY DEFINER functions that a visitor with no session could call.
--
-- Supabase grants EXECUTE on new functions to PUBLIC, and so to `anon`. Each of
-- these needs a signed-in caller: they read auth.uid(), or they check a staff role
-- inside. An anonymous *account* (onboarding's "no email needed") is `authenticated`,
-- not `anon`, so nothing in the product loses access. Only callers with no JWT at
-- all do.
-- ---------------------------------------------------------------------------
revoke execute on function public.delete_account() from public, anon;
grant  execute on function public.delete_account() to authenticated, service_role;

revoke execute on function public.redeem_partner_invite(text) from public, anon;
grant  execute on function public.redeem_partner_invite(text) to authenticated, service_role;

revoke execute on function public.insights_overview() from public, anon;
revoke execute on function public.insights_by_dimension(text) from public, anon;
revoke execute on function public.insights_retention(integer) from public, anon;
grant  execute on function public.insights_overview() to authenticated, service_role;
grant  execute on function public.insights_by_dimension(text) to authenticated, service_role;
grant  execute on function public.insights_retention(integer) to authenticated, service_role;

-- A trigger function, never an RPC. EXECUTE is checked when a trigger is created,
-- not when it fires, so revoking it from every API role changes nothing about
-- signup and closes /rest/v1/rpc/handle_new_user.
revoke execute on function public.handle_new_user() from public, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 2 · Functions with a role-mutable search_path. None is SECURITY DEFINER, so the
-- exposure is small, but pinning it costs nothing. `public, pg_temp` rather than ''
-- because some of them call each other unqualified.
-- ---------------------------------------------------------------------------
alter function public.set_updated_at() set search_path = public, pg_temp;
alter function public.insights_k() set search_path = public, pg_temp;
alter function public.partner_scope_is_allowed(jsonb) set search_path = public, pg_temp;
alter function public.notification_kinds_are_allowed(jsonb) set search_path = public, pg_temp;
alter function public.femio_ts_config(text) set search_path = public, pg_temp;
alter function public.femio_search_tsquery(regconfig, text) set search_path = public, pg_temp;

-- ---------------------------------------------------------------------------
-- 3 · Performance.
-- ---------------------------------------------------------------------------
-- Two identical indexes, (profile_id, logged_at desc). Every write paid for both.
drop index if exists public.fertility_logs_profile_idx;

-- Foreign keys with no covering index: a delete of the parent row (deleting a
-- pregnancy, or an account) scans the child table.
create index if not exists contractions_pregnancy_idx on public.contractions (pregnancy_id);
create index if not exists fetal_movement_sessions_pregnancy_idx on public.fetal_movement_sessions (pregnancy_id);
create index if not exists audit_log_actor_idx on public.audit_log (actor);
create index if not exists feature_flags_updated_by_idx on public.feature_flags (updated_by);

-- ---------------------------------------------------------------------------
-- Not changed, on purpose:
-- - has_core_consent(uuid) and is_staff(uuid, text[]) stay executable by anon and
--   authenticated. RLS policies call them, and a policy evaluates with the caller's
--   privileges: revoking EXECUTE would turn every anon read of feature_flags (and
--   every insert gated on consent) into a permission error. They return a boolean
--   about a uuid the caller must already know.
-- - search_content / search_content_in stay public: /search is public by design
--   (0022), and it searches only published content.
-- - "Anonymous access policies" on every user table are expected: anonymous sign-in
--   is the product's no-email start, and every one of those policies is scoped to
--   auth.uid().
-- - Unused-index findings: the app has had no real traffic, so "never used" means
--   "never exercised yet", not "useless". Re-read after launch.
-- - Leaked-password protection is a dashboard setting (OWNER_ACTIONS).
-- ---------------------------------------------------------------------------
$h2$])
on conflict (version) do nothing;

insert into payload.payload_migrations (name, batch, updated_at, created_at)
select '20261007_192351_payload_3_90',
       coalesce((select max(batch) from payload.payload_migrations where batch > 0), 0) + 1,
       now(), now()
where not exists (select 1 from payload.payload_migrations where name = '20261007_192351_payload_3_90');

commit;

-- After it says "Success. No rows returned", you are done. Tell Claude "SQL done".
