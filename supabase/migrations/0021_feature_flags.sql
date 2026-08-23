-- ============================================================================
-- Femio — feature flags (Phase A7, `docs/29_REBUILD/02_DATA_MODEL.md` §7)
--
-- ## A safety mechanism before it is a growth mechanism
--
-- Femio has no remote config, no experiments and no kill switches. For a product
-- whose tier-1 decisions are medical, that means **a wrong red-flag threshold
-- requires a deploy**. If a threshold is found to be alarming women who should not
-- be alarmed, the current remedy is a code change, a review, a build and a
-- release. That is the argument for this table, and it comes before any argument
-- about experimentation.
--
-- The second reason is chapter 03 §5: the v1→v2 contract migration runs one
-- surface at a time behind a flag, with both documents live. Without flags that
-- migration is a flag day, which is exactly what the teardown showed Flo avoiding.
--
-- ## Shape borrowed from Flo, narrowed
--
-- Their model is `feature_id` + `dependencies` + an ordered supplier chain, with
-- 149 feature classes. We take the dependency edge and the supplier order and
-- leave the rest: no per-feature class hierarchy, no experiment arms in the schema.
-- An experiment is a flag with an audience; if that proves too thin, widen it then.
--
-- **Client resolution order is remote → cached → compiled default**, the same
-- three-source shape `lib/experience/client.ts` already uses for the config
-- itself. A device with no network gets the last value it saw, then the value
-- compiled into the build. It never gets nothing.
--
-- ## What a flag may not do
--
-- It may not carry medical content. A threshold's *value* lives in tier 1 where
-- it is versioned, reviewed and fixture-bound; a flag may switch **which** tier-1
-- rule is active, and may not smuggle a number past that review. `payload_json`
-- exists for rollout percentages and surface names, not for clinical constants.
-- ============================================================================

create table if not exists public.feature_flags (
  key           text primary key,
  enabled       boolean not null default false,

  /**
   * Configuration for the flag — rollout percentage, surface name, variant label.
   * **Never a clinical value.** See the header.
   */
  payload_json  jsonb not null default '{}'::jsonb,

  /**
   * Who it applies to: track, persona, locale, platform, staff-only. Empty means
   * everyone. Evaluated server-side during resolve, so a client cannot widen its
   * own audience by lying about itself.
   */
  audience_json jsonb not null default '{}'::jsonb,

  /**
   * Other flags that must be on for this one to take effect. Flo carries the same
   * edge, and it is what stops turning one thing off leaving a half-built surface
   * reachable.
   */
  depends_on    text[] not null default '{}',

  /** Human-readable, for the staff screen and for the audit trail's benefit. */
  description   text,

  updated_at    timestamptz not null default now(),
  updated_by    uuid references auth.users (id)
);

comment on table public.feature_flags is
  'Remote config. A safety mechanism first: without it a wrong medical threshold requires a deploy. Resolution is remote -> cached -> compiled default, so a device offline still gets a value. Flags may switch which tier-1 rule is active; they may never carry a clinical value.';
comment on column public.feature_flags.payload_json is
  'Rollout percentage, surface name, variant label. Never a clinical constant — those live in tier 1 where they are versioned, reviewed and fixture-bound.';
comment on column public.feature_flags.depends_on is
  'Flags that must also be on. Stops turning one thing off from leaving a half-built surface reachable.';

alter table public.feature_flags enable row level security;

drop trigger if exists feature_flags_set_updated_at on public.feature_flags;
create trigger feature_flags_set_updated_at before update on public.feature_flags
  for each row execute function public.set_updated_at();

-- ----------------------------------------------------------------------------
-- RLS
--
-- **Readable by everyone, writable by staff.** Reading is not a leak: a flag key
-- says what the product can do, not anything about her. Anonymous read matters
-- because the public site and a signed-out first run both need to know which
-- surfaces exist.
--
-- Writes are staff-only through `staff_roles`, and every write lands in
-- `audit_log` via the trigger below — a flag that changes what a woman is told
-- about her body is exactly the change that must be attributable to a person.
-- ----------------------------------------------------------------------------
drop policy if exists feature_flags_select_all on public.feature_flags;
create policy feature_flags_select_all on public.feature_flags
  for select using (true);

drop policy if exists feature_flags_write_staff on public.feature_flags;
create policy feature_flags_write_staff on public.feature_flags
  for all
  using (exists (
    select 1 from public.staff_roles sr
     where sr.user_id = (select auth.uid())
  ))
  with check (exists (
    select 1 from public.staff_roles sr
     where sr.user_id = (select auth.uid())
  ));

revoke insert, update, delete on public.feature_flags from anon;

-- ----------------------------------------------------------------------------
-- Every flag change is attributable.
--
-- A flag that changes what a woman is told about her body is exactly the change
-- that must have a person's name on it. The trigger writes to `audit_log`, which
-- is append-only and admin-read.
--
-- `updated_by` is set from `auth.uid()` rather than trusted from the client, for
-- the obvious reason.
-- ----------------------------------------------------------------------------
create or replace function public.audit_feature_flag_change()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  actor_id uuid := auth.uid();
begin
  if tg_op = 'DELETE' then
    insert into public.audit_log (actor, action, target, meta_json)
    values (actor_id, 'feature_flag.delete', old.key,
            jsonb_build_object('was_enabled', old.enabled));
    return old;
  end if;

  new.updated_by := actor_id;

  insert into public.audit_log (actor, action, target, meta_json)
  values (
    actor_id,
    case when tg_op = 'INSERT' then 'feature_flag.create' else 'feature_flag.update' end,
    new.key,
    jsonb_build_object(
      'enabled_from', case when tg_op = 'UPDATE' then old.enabled else null end,
      'enabled_to',   new.enabled,
      'payload',      new.payload_json,
      'audience',     new.audience_json
    )
  );
  return new;
end;
$$;

drop trigger if exists feature_flags_audit on public.feature_flags;
create trigger feature_flags_audit
  before insert or update or delete on public.feature_flags
  for each row execute function public.audit_feature_flag_change();

-- The function is reachable only through the trigger.
revoke all on function public.audit_feature_flag_change() from public, anon, authenticated;
