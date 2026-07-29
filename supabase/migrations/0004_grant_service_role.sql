-- Femio — grant the service_role standard access to the public schema (P1.19).
-- ----------------------------------------------------------------------------
-- Migration 0002 granted table privileges to `anon` and `authenticated` only.
-- `service_role` (the trusted server key used by admin scripts — e.g. the
-- translation seed, scripts/i18n/seed-ui-strings.mjs) bypasses RLS but still
-- needs base table GRANTs, so writes were failing with "permission denied for
-- table …". This restores the Supabase-standard posture: service_role has full
-- access to the public schema (it is the master server key; RLS does not apply
-- to it), including tables/sequences created later.
-- ----------------------------------------------------------------------------

grant usage on schema public to service_role;
grant all on all tables in schema public to service_role;
grant all on all sequences in schema public to service_role;
grant execute on all functions in schema public to service_role;

-- Future objects created in this schema also grant to service_role automatically.
alter default privileges in schema public grant all on tables to service_role;
alter default privileges in schema public grant all on sequences to service_role;
alter default privileges in schema public grant execute on functions to service_role;
