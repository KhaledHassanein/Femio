-- ============================================================================
-- Femio — notification preferences and push subscriptions (P2.8)
--
-- The first thing Femio does *to* a woman rather than *for* her. Both tables are
-- shaped by that: nothing is on by default, and neither table can hold a reason.
--
-- `notification_prefs` is one row per profile rather than a ledger, because unlike
-- consent there is no legal need to know what she used to want — and a history of
-- "she turned off period reminders in March" is exactly the sort of row that is
-- useful to nobody and interesting to the wrong person.
-- ============================================================================

create table if not exists public.notification_prefs (
  profile_id   uuid primary key references public.profiles (id) on delete cascade,
  /**
   * Per-kind opt-in, mirroring `NOTIFICATION_KINDS` in
   * `apps/web/src/lib/notifications/index.ts`. Empty by default: every kind off.
   * A closed set is enforced by the CHECK below rather than by the client, for the
   * same reason partner sharing's scope is (migration 0011) — a UI is one refactor
   * from changing and a constraint is not.
   */
  kinds        jsonb not null default '{}'::jsonb,
  /** Lock-screen wording that names nothing. Defaults ON, and stays on unless she says otherwise. */
  discreet     boolean not null default true,
  /** Local hours. from = to means no quiet window, never a silent 24 hours. */
  quiet_from   smallint not null default 22 check (quiet_from between 0 and 23),
  quiet_to     smallint not null default 8  check (quiet_to between 0 and 23),
  updated_at   timestamptz not null default now()
);
comment on table public.notification_prefs is
  'One row per profile. Nothing is enabled by default. Carries no history: what she used to want is useful to nobody and interesting to the wrong person.';

alter table public.notification_prefs enable row level security;
create trigger notification_prefs_set_updated_at before update on public.notification_prefs
  for each row execute function public.set_updated_at();

create or replace function public.notification_kinds_are_allowed(kinds jsonb)
returns boolean
language sql
immutable
as $$
  select kinds is not null
     and jsonb_typeof(kinds) = 'object'
     and not exists (
       select 1 from jsonb_object_keys(kinds) as k
       where k not in ('periodWindow','logReminder','appointment','medication','cycleSummary')
     );
$$;

alter table public.notification_prefs
  drop constraint if exists notification_prefs_kinds_allowed;
alter table public.notification_prefs
  add constraint notification_prefs_kinds_allowed check (public.notification_kinds_are_allowed(kinds));

-- ----------------------------------------------------------------------------
-- Push subscriptions
--
-- One per browser/device. The endpoint is a URL at a push service (Apple, Google,
-- Mozilla) — not health data, but it is a stable device identifier, so it is
-- owner-scoped by RLS exactly like everything else and cascades on delete.
--
-- **No `user_agent`, no IP, no `last_seen`.** A device inventory is not needed to
-- deliver a notification, and P1.20's whole posture is that Femio does not collect
-- what it does not use.
-- ----------------------------------------------------------------------------
create table if not exists public.push_subscriptions (
  id         uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles (id) on delete cascade,
  endpoint   text not null,
  p256dh     text not null,
  auth       text not null,
  created_at timestamptz not null default now(),
  unique (endpoint)
);
comment on table public.push_subscriptions is
  'Web-push endpoints, one per device. No user agent, no IP, no last-seen: a device inventory is not needed to deliver a notification.';

alter table public.push_subscriptions enable row level security;
create index if not exists push_subscriptions_profile_idx on public.push_subscriptions (profile_id);

-- ----------------------------------------------------------------------------
-- RLS — hers, and nobody else's. No staff read: a list of who wants period
-- reminders is a list of who has periods.
-- ----------------------------------------------------------------------------
create policy notification_prefs_select_own on public.notification_prefs
  for select using (profile_id = (select auth.uid()));
create policy notification_prefs_insert_own on public.notification_prefs
  for insert with check (profile_id = (select auth.uid()));
create policy notification_prefs_update_own on public.notification_prefs
  for update using (profile_id = (select auth.uid()))
  with check (profile_id = (select auth.uid()));
create policy notification_prefs_delete_own on public.notification_prefs
  for delete using (profile_id = (select auth.uid()));

create policy push_subscriptions_select_own on public.push_subscriptions
  for select using (profile_id = (select auth.uid()));
create policy push_subscriptions_insert_own on public.push_subscriptions
  for insert with check (profile_id = (select auth.uid()));
create policy push_subscriptions_delete_own on public.push_subscriptions
  for delete using (profile_id = (select auth.uid()));
