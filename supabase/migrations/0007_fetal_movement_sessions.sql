-- ============================================================================
-- Femio — fetal movement sessions (P2.2)
--
-- A record of what she felt and when, NOT a test with a pass mark.
--
-- The clinical position Femio follows is the one already published in
-- docs/content/articles/pregnancy-warning-signs.md and cleared by review:
-- "There is no single normal number for everyone. Your baby's change from usual
-- matters." So this table stores a raw count and a duration and nothing else —
-- there is deliberately no `result`, `normal`, `passed` or `target` column,
-- because the moment a schema can hold a verdict, something will render one.
--
-- Why the count is nullable: a session that is abandoned because she is worried
-- and going to phone maternity is the most important session in the table. It
-- must be storable without first being completed.
-- ============================================================================
create table public.fetal_movement_sessions (
  id            uuid primary key default gen_random_uuid(),
  profile_id    uuid not null references public.profiles (id) on delete cascade,
  pregnancy_id  uuid references public.pregnancy (id) on delete cascade,
  started_at    timestamptz not null,
  ended_at      timestamptz,
  movement_count integer check (movement_count is null or movement_count >= 0),
  note          text,
  created_at    timestamptz not null default now()
);

comment on table public.fetal_movement_sessions is
  'Movement pattern log (P2.2). Intentionally has no verdict column: there is no normal number, only a change from her own pattern. ON DELETE CASCADE keeps GDPR delete_account() whole.';
comment on column public.fetal_movement_sessions.movement_count is
  'Nullable on purpose — an abandoned session (she stopped to call maternity) must still be recordable.';

alter table public.fetal_movement_sessions enable row level security;

create index fetal_movement_sessions_profile_idx
  on public.fetal_movement_sessions (profile_id, started_at desc);

-- Owner-scoped policies, matching the pattern in 0002 for every health table:
-- read/update/delete your own; insert requires core consent.
create policy fetal_movement_sessions_select_own on public.fetal_movement_sessions
  for select using (profile_id = (select auth.uid()));
create policy fetal_movement_sessions_insert_own on public.fetal_movement_sessions
  for insert with check (
    profile_id = (select auth.uid()) and public.has_core_consent((select auth.uid()))
  );
create policy fetal_movement_sessions_update_own on public.fetal_movement_sessions
  for update using (profile_id = (select auth.uid()))
  with check (profile_id = (select auth.uid()));
create policy fetal_movement_sessions_delete_own on public.fetal_movement_sessions
  for delete using (profile_id = (select auth.uid()));
