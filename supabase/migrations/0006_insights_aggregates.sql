-- ============================================================================
-- Femio — first-party product insights, aggregate-only + k-anonymous (P1.20.3)
--
-- WHY THIS EXISTS IN THE DATABASE RATHER THAN THE APP
-- The dimensions the product team actually needs — life-stage mode, condition/
-- persona tag, age band, cohort retention — are exactly the ones docs/13 §5
-- forbids sending to a third-party analytics SDK: attached to a pseudonymous id
-- they are special-category health inferences (ADR-017). So they can never come
-- from PostHog; they must be computed first-party, over our own Postgres.
--
-- But staff cannot read those rows: RLS is owner-only, and that is deliberate —
-- nobody at Femio should be able to page through a woman's symptom log. The way
-- to have both is a `security definer` function that reads the rows and returns
-- **only counts**. There is no code path here that emits a row, an id, a date, a
-- symptom or a free-text note; every return type below is (label, count).
--
-- K-ANONYMITY, AND WHY PRIMARY SUPPRESSION ALONE IS NOT ENOUGH
-- A count of 1 is a person, so every group smaller than K (10) is suppressed
-- inside SQL — a small cell never leaves the database, and the app cannot leak
-- what it was never sent.
--
-- But hiding a cell does not hide its value if the rest of the table can be
-- subtracted from a total. With 56 accounts and "anonymous = 55" on screen,
-- "registered = 1" is arithmetic, not disclosure control. So this file also does
-- **secondary suppression**:
--   * breakdowns absorb the smallest visible group into the `withheld` bucket,
--     repeatedly, until that bucket clears K and merges at least 2 groups — the
--     only thing differencing can then recover is a number that is itself
--     k-anonymous;
--   * complementary overview metrics (registered / anonymous, which sum to the
--     total) are suppressed together, because either one gives the other away.
-- If a whole dimension cannot be made anonymous, it returns nothing at all.
--
-- ACCESS
-- Each function checks `is_staff(auth.uid(), ...)` itself and raises otherwise —
-- the guard is inside the security-definer boundary, not in the caller. Execute
-- is granted to `authenticated` only; `anon` (no JWT) is revoked explicitly.
--
-- Safe to apply: creates functions only, touches no table, no data migration.
-- ============================================================================

-- The k-anonymity threshold, defined once so every function and any future
-- report share it (and so it is auditable in one place).
create or replace function public.insights_k()
returns integer
language sql
immutable
as $$ select 10 $$;

comment on function public.insights_k() is
  'k-anonymity threshold for first-party insights: groups smaller than this are never returned.';

-- ----------------------------------------------------------------------------
-- Overview — headline counts. NULL value = suppressed (below k).
-- ----------------------------------------------------------------------------
create or replace function public.insights_overview()
returns table (metric text, value bigint)
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  k integer := public.insights_k();
begin
  if not public.is_staff((select auth.uid()), array['admin']) then
    raise exception 'not authorized' using errcode = '42501';
  end if;

  return query
  with counts as (
    select
      (select count(*) from public.profiles)                                    as total_users,
      (select count(*) from public.profiles where account_type = 'registered')  as registered_users,
      (select count(*) from public.profiles where account_type = 'anon')        as anonymous_users,
      (select count(*) from public.persona_state where track is not null)       as onboarded_users,
      (select count(distinct profile_id) from (
         select profile_id from public.cycles where created_at > now() - interval '28 days'
         union
         select profile_id from public.symptom_logs where logged_at > now() - interval '28 days'
       ) recent)                                                                as active_28d
  ),
  guarded as (
    select
      c.total_users,
      c.onboarded_users,
      c.active_28d,
      -- registered + anonymous = total, so publishing one publishes the other.
      -- Either below k suppresses both (secondary suppression).
      case when c.registered_users >= k and c.anonymous_users >= k
           then c.registered_users end as registered_users,
      case when c.registered_users >= k and c.anonymous_users >= k
           then c.anonymous_users end as anonymous_users
    from counts c
  )
  -- Alias columns are named away from the OUT parameters (metric/value) on
  -- purpose: in PL/pgSQL an unqualified name matching both a variable and a
  -- column raises "reference is ambiguous" at runtime, not at create time.
  select m.m_key, case when m.m_val >= k then m.m_val else null end
  from guarded g
  cross join lateral (values
    ('total_users', g.total_users),
    ('registered_users', g.registered_users),
    ('anonymous_users', g.anonymous_users),
    ('onboarded_users', g.onboarded_users),
    ('active_28d', g.active_28d)
  ) as m(m_key, m_val);
end;
$$;

comment on function public.insights_overview() is
  'Aggregate-only product overview for staff. Counts below insights_k() return NULL (P1.20.3).';

-- ----------------------------------------------------------------------------
-- Breakdown by one dimension. Returns (bucket, users), k-suppressed, with a
-- `withheld` roll-up only when it cannot re-reveal a suppressed group.
-- ----------------------------------------------------------------------------
create or replace function public.insights_by_dimension(p_dimension text)
returns table (bucket text, users bigint)
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  k integer  := public.insights_k();
  rec        record;
  keep_b     text[]   := '{}';   -- visible groups, ascending by size
  keep_n     bigint[] := '{}';
  pot        bigint   := 0;      -- everything merged into `withheld`
  pot_groups integer  := 0;
  i          integer;
begin
  if not public.is_staff((select auth.uid()), array['admin']) then
    raise exception 'not authorized' using errcode = '42501';
  end if;

  -- Pass 1 — primary suppression: anything below k goes straight into the pot.
  -- Ascending order matters for pass 2, which absorbs the *smallest* survivors.
  for rec in
    select
      case p_dimension
        -- Life-stage mode and persona tag are health inferences: first-party only.
        when 'mode'         then coalesce(ps.track, 'unset')
        when 'persona'      then coalesce(ps.persona_id, 'unset')
        when 'age_band'     then coalesce(p.age_band, 'unset')
        when 'locale'       then p.locale
        when 'account_type' then p.account_type
      end as b,
      count(*) as n
    from public.profiles p
    left join public.persona_state ps on ps.profile_id = p.id
    group by 1
    having case p_dimension
             when 'mode'         then coalesce(ps.track, 'unset')
             when 'persona'      then coalesce(ps.persona_id, 'unset')
             when 'age_band'     then coalesce(p.age_band, 'unset')
             when 'locale'       then p.locale
             when 'account_type' then p.account_type
           end is not null
    order by 2 asc, 1 asc
  loop
    if rec.n < k then
      pot := pot + rec.n;
      pot_groups := pot_groups + 1;
    else
      keep_b := array_append(keep_b, rec.b);
      keep_n := array_append(keep_n, rec.n);
    end if;
  end loop;

  -- Pass 2 — secondary suppression. A pot that is itself smaller than k, or that
  -- holds a single group, can be recovered by subtracting the visible rows from
  -- the total. Absorb the smallest visible group and re-check, until what is
  -- left to infer is itself k-anonymous.
  while pot > 0 and (pot < k or pot_groups < 2) and coalesce(array_length(keep_b, 1), 0) > 0 loop
    pot := pot + keep_n[1];
    pot_groups := pot_groups + 1;
    keep_b := keep_b[2:];
    keep_n := keep_n[2:];
  end loop;

  -- Emit the survivors, largest first.
  for i in reverse coalesce(array_length(keep_b, 1), 0) .. 1 loop
    bucket := keep_b[i];
    users  := keep_n[i];
    return next;
  end loop;

  -- The pot is published only when it cannot re-reveal what it hides. If it
  -- still can't clear k (too few people overall), it is dropped entirely and the
  -- dimension simply shows nothing.
  if pot >= k and pot_groups >= 2 then
    bucket := 'withheld';
    users  := pot;
    return next;
  end if;
end;
$$;

comment on function public.insights_by_dimension(text) is
  'Staff-only k-anonymous user counts by mode | persona | age_band | locale | account_type (P1.20.3).';

-- ----------------------------------------------------------------------------
-- Retention — monthly signup cohorts, and how many were still logging in the
-- following months. Cohorts below k are dropped entirely; individual cells are
-- suppressed to NULL.
-- ----------------------------------------------------------------------------
create or replace function public.insights_retention(p_months integer default 6)
returns table (cohort date, cohort_size bigint, month_1 bigint, month_2 bigint)
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  k integer := public.insights_k();
begin
  if not public.is_staff((select auth.uid()), array['admin']) then
    raise exception 'not authorized' using errcode = '42501';
  end if;

  return query
  -- CTE columns are named away from the OUT parameters for the same reason as above.
  with signups as (
    select p.id as pid, date_trunc('month', p.created_at) as c_month
    from public.profiles p
    where p.created_at > now() - make_interval(months => greatest(p_months, 1))
  ),
  activity as (
    select c.profile_id as pid, date_trunc('month', c.created_at) as a_month
    from public.cycles c
    union
    select sl.profile_id, date_trunc('month', sl.logged_at) from public.symptom_logs sl
  ),
  per_cohort as (
    select
      s.c_month,
      count(*) as n,
      count(*) filter (
        where exists (
          select 1 from activity a
          where a.pid = s.pid and a.a_month = s.c_month + interval '1 month'
        )
      ) as n1,
      count(*) filter (
        where exists (
          select 1 from activity a
          where a.pid = s.pid and a.a_month = s.c_month + interval '2 months'
        )
      ) as n2
    from signups s
    group by s.c_month
  )
  select
    pc.c_month::date,
    pc.n,
    case when pc.n1 >= k then pc.n1 else null end,
    case when pc.n2 >= k then pc.n2 else null end
  from per_cohort pc
  where pc.n >= k
  order by 1 desc;
end;
$$;

comment on function public.insights_retention(integer) is
  'Staff-only k-anonymous monthly retention cohorts. Cohorts below insights_k() are omitted (P1.20.3).';

-- ----------------------------------------------------------------------------
-- Grants: signed-in staff only. `anon` (no JWT) can never reach these, and the
-- in-function is_staff() check is the real boundary for everyone else.
-- ----------------------------------------------------------------------------
revoke all on function public.insights_overview() from public, anon;
revoke all on function public.insights_by_dimension(text) from public, anon;
revoke all on function public.insights_retention(integer) from public, anon;
revoke all on function public.insights_k() from public, anon;

grant execute on function public.insights_overview() to authenticated;
grant execute on function public.insights_by_dimension(text) to authenticated;
grant execute on function public.insights_retention(integer) to authenticated;
grant execute on function public.insights_k() to authenticated;
