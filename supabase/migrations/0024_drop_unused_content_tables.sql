-- 0024 — drop the three content tables schema v1 sketched and nothing ever used.
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
