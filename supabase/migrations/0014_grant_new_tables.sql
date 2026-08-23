-- ============================================================================
-- Femio — base GRANTs for the tables added after 0002, and a default so the next
-- one cannot repeat this (found on the deployed site, 2026-08-23)
--
-- ## What was wrong
--
-- `0013_notifications.sql` created two tables, enabled RLS, and wrote four
-- policies each. It looked complete and it was not: **RLS narrows a privilege, it
-- does not grant one.** Migration 0002 granted table privileges with
--
--     grant select, insert, update, delete on all tables in schema public
--       to authenticated;
--
-- and `ALL TABLES` means *all tables that existed at that moment*. Every table
-- created since has inherited nothing, so `notification_prefs` and
-- `push_subscriptions` returned **403 / 42501 to their own owner**.
--
-- ## Why it survived the local gate
--
-- Because nothing failed. `readPrefs()` treats a missing row as the normal state —
-- it is, for anyone who has never opened the panel — and returns the defaults. So
-- an unreadable table and an empty one are indistinguishable from the screen: the
-- panel rendered perfectly, every checkbox unticked, and *saving* would have
-- failed silently the first time a real user touched it.
--
-- It was caught by driving the deployed site and watching the network, which is
-- the "check the deployed thing" rule in `STATE.md` earning its place again. No
-- test would have found it: the unit tests do not touch Postgres, and the e2e
-- suite has no signed-in notification flow yet.
--
-- ## The fix, and the part that matters more
--
-- The grants below close it. `alter default privileges` is what stops the next
-- table repeating it — 0004 did exactly this for `service_role` and the same line
-- for `authenticated` was never written, which is the whole reason this bug
-- existed. RLS is still the boundary; a GRANT without a policy grants nothing,
-- and every one of these tables denies by default.
-- ============================================================================

grant select, insert, update, delete on all tables in schema public to authenticated;
grant select on all tables in schema public to anon;
grant execute on all functions in schema public to anon, authenticated;

-- The line 0004 wrote for service_role and nobody wrote for authenticated.
-- A table created after this one arrives with privileges and no policies, which
-- means default-deny — the correct starting point, and a loud one.
alter default privileges in schema public grant select, insert, update, delete on tables to authenticated;
alter default privileges in schema public grant select on tables to anon;
alter default privileges in schema public grant execute on functions to anon, authenticated;

-- ----------------------------------------------------------------------------
-- The two functions added since 0002 that must NOT be reachable from a browser.
-- The blanket grant above re-grants execute on everything, so the revokes from
-- 0011 are re-applied here; without this, running these migrations in order would
-- hand `partner_shared_rows` back to `authenticated` and undo ADR-068's boundary.
-- ----------------------------------------------------------------------------
revoke all on function public.partner_shared_rows(uuid) from public;
revoke all on function public.partner_shared_rows(uuid) from anon;
revoke all on function public.partner_shared_rows(uuid) from authenticated;
grant execute on function public.partner_shared_rows(uuid) to service_role;
