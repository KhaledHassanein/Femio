-- 0008 — contraction timing (P2.2.3)
--
-- One row per contraction, not per session. Interval is the gap between the start
-- of one and the start of the next, which is the number people are asked for, and
-- deriving it from consecutive rows means a session that was interrupted, resumed
-- an hour later, or recorded from two devices still produces the right answer. A
-- session table would have had to guess where the boundaries were.
--
-- WHAT THIS TABLE DELIBERATELY DOES NOT HAVE, and must not gain:
--
--   * No `intensity`, `strength` or `pain_score`. Femio times contractions; it does
--     not grade labour.
--   * No `is_labour`, `stage`, `phase` or any verdict column. The widely-taught
--     5-1-1 pattern is guidance a midwife gives about *when to call*, and an app
--     that concluded "this is active labour" would be making a clinical assessment
--     from a stopwatch (product rule 1). Same reasoning as the movement log's
--     missing `result` column (ADR-049) and `ClinicalStrip`'s missing `status`.
--
-- `ended_at` is nullable on purpose: a contraction in progress is a real row, and
-- so is one she never stopped because she put the phone down. ON DELETE CASCADE
-- keeps GDPR delete_account() whole.

create table public.contractions (
  id           uuid primary key default gen_random_uuid(),
  profile_id   uuid not null references public.profiles (id) on delete cascade,
  pregnancy_id uuid references public.pregnancy (id) on delete cascade,
  started_at   timestamptz not null,
  ended_at     timestamptz,
  created_at   timestamptz not null default now(),
  constraint contractions_ends_after_start check (ended_at is null or ended_at >= started_at)
);

comment on table public.contractions is
  'Contraction timing (P2.2.3). One row per contraction; interval is derived from consecutive rows. Intentionally has no intensity and no verdict column — Femio times contractions, it does not decide whether this is labour.';
comment on column public.contractions.ended_at is
  'Nullable on purpose — a contraction in progress, or one she never stopped, must still be a real row.';

alter table public.contractions enable row level security;

create index contractions_profile_time_idx on public.contractions (profile_id, started_at desc);

-- Same four owner-only policies every health table gets (0002), including the
-- core-consent gate on insert. Written out rather than looped because 0002's loop
-- has already run.
create policy contractions_select_own on public.contractions
  for select using (profile_id = (select auth.uid()));
create policy contractions_insert_own on public.contractions
  for insert with check (
    profile_id = (select auth.uid()) and public.has_core_consent((select auth.uid()))
  );
create policy contractions_update_own on public.contractions
  for update using (profile_id = (select auth.uid()))
  with check (profile_id = (select auth.uid()));
create policy contractions_delete_own on public.contractions
  for delete using (profile_id = (select auth.uid()));
