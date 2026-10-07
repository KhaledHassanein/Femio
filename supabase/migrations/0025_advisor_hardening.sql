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
