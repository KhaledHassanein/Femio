-- ============================================================================
-- Femio — per-day period flow (Phase A1, `docs/29_REBUILD/02_DATA_MODEL.md` §1)
--
-- ## What was wrong with one flow per cycle
--
-- `cycles.flow` is a single enum describing an entire period. A real period is
-- heavy on day two and spotting on day five, and the calendar we are about to
-- build (OD-15) has to distinguish the first and last day of a run and show
-- intensity in the fill. Neither is possible from one value.
--
-- It also blocked something quieter: `lib/patterns` can correlate a symptom with
-- "a period" but not with *a heavy day*, which is the correlation a woman with
-- heavy menstrual bleeding (B4) actually wants.
--
-- ## Why a new table rather than a jsonb column on `cycles`
--
-- Because a period day is a fact she logged on a date, and a cycle is a derived
-- span. Retroactive logging writes days before it knows which cycle they belong
-- to — Flo's calendar lets you tap any past day — so `cycle_id` is nullable and
-- gets attached when the cycle is resolved. A jsonb blob on `cycles` would have
-- forced the cycle to exist first.
--
-- `unique (profile_id, day)` because a day has one flow. Logging over it is an
-- update, not a second row: two contradictory intensities for one date is not a
-- state the product should be able to reach.
--
-- ## `cycles.flow` is kept
--
-- Deprecated in a comment, not dropped. It is read by code that predates this
-- migration and dropping a column is the one schema change that cannot be rolled
-- back cheaply. It is backfilled *from* here going forward, not to here.
-- ============================================================================

create table if not exists public.period_days (
  id         uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles (id) on delete cascade,
  /**
   * Attached when the cycle is resolved, null when she logs a day that does not
   * yet belong to one. Cascades: deleting a cycle deletes its days.
   */
  cycle_id   uuid references public.cycles (id) on delete cascade,
  day        date not null,
  flow       text not null check (flow in ('spotting','light','medium','heavy')),
  /**
   * Where the day came from. `health_platform` matters because a day written by
   * Health Connect is not her testimony — it is another app's reading — and the
   * visit pack has to be able to say which is which.
   */
  source     text not null default 'user'
             check (source in ('user','imported','health_platform')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (profile_id, day)
);

comment on table public.period_days is
  'One row per bleeding day. The detail behind `cycles`, which stays the authority for start, end and length. Retroactive logging is why `cycle_id` is nullable.';
comment on column public.period_days.source is
  'user | imported | health_platform. A platform reading is not her testimony and must stay distinguishable from it.';
comment on column public.cycles.flow is
  'DEPRECATED by `period_days` (migration 0015). Kept for code predating it; do not write new logic against it.';

alter table public.period_days enable row level security;

drop trigger if exists period_days_set_updated_at on public.period_days;
create trigger period_days_set_updated_at before update on public.period_days
  for each row execute function public.set_updated_at();

create index if not exists period_days_profile_day_idx
  on public.period_days (profile_id, day desc);
create index if not exists period_days_cycle_idx
  on public.period_days (cycle_id);

-- ----------------------------------------------------------------------------
-- RLS — hers, and nobody else's.
--
-- No staff read. A list of bleeding days is the most identifying health data in
-- the product, and nothing in support or moderation needs it.
--
-- Partner sharing does not read this table directly: it goes through
-- `partner_shared_rows`, which is service-role only (ADR-068). A partner with the
-- `period_dates` scope sees dates from `cycles`, not intensity from here —
-- deliberately, because "she bled heavily on the 3rd" is a different disclosure
-- from "her period was the 1st to the 5th" and she consented to the second.
-- ----------------------------------------------------------------------------
drop policy if exists period_days_select_own on public.period_days;
create policy period_days_select_own on public.period_days
  for select using (profile_id = (select auth.uid()));
drop policy if exists period_days_insert_own on public.period_days;
create policy period_days_insert_own on public.period_days
  for insert with check (profile_id = (select auth.uid()));
drop policy if exists period_days_update_own on public.period_days;
create policy period_days_update_own on public.period_days
  for update using (profile_id = (select auth.uid()))
  with check (profile_id = (select auth.uid()));
drop policy if exists period_days_delete_own on public.period_days;
create policy period_days_delete_own on public.period_days
  for delete using (profile_id = (select auth.uid()));

-- ----------------------------------------------------------------------------
-- Backfill
--
-- Every day of every existing period gets a row, carrying that cycle's single
-- `flow` value, or 'medium' where none was recorded. This is a lossless widening:
-- the flow strip renders identically before and after, because every day of a
-- given period had the same value implicitly and now has it explicitly.
--
-- `period_end` is nullable — a period in progress. Those cycles are skipped:
-- inventing an end date to backfill against would be writing data she never gave.
-- ----------------------------------------------------------------------------
insert into public.period_days (profile_id, cycle_id, day, flow, source)
select
  c.profile_id,
  c.id,
  d::date,
  coalesce(c.flow, 'medium'),
  'imported'
from public.cycles c
cross join lateral generate_series(c.period_start::timestamp, c.period_end::timestamp, interval '1 day') as d
where c.period_end is not null
on conflict (profile_id, day) do nothing;
