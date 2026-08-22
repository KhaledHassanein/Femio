-- ============================================================================
-- Femio — partner sharing (Phase 4.5)
--
-- Design: docs/compliance/PARTNER_SHARING_DESIGN.md (owner-approved 2026-08-23).
-- Risk analysis: docs/compliance/DPIA.md §3 (coercion) and §4 (mitigations).
--
-- `partner_links` has existed, empty, since schema v1 — the seventh table unused
-- since then. It is reused rather than replaced: it already carries the exact
-- shape the design asks for (an owner, a named recipient, a scope, a revocation
-- stamp), and a second table beside it would be a second mechanism where the
-- house pattern is one revocable ledger.
--
-- Four things happen here, and the third is a fix rather than a feature.
--   1. The columns the design needs: an expiry, a policy version, and a
--      single-use invite code so the grant can be account-based.
--   2. A CHECK that `scope_json` can only ever name a shareable category, so the
--      never-shareable class (§4) is unrepresentable in the database and not only
--      absent from the UI.
--   3. **The v1 partner SELECT policy is dropped.** It let the recipient read the
--      whole row — including `scope_json` and `revoked_at`. That is precisely the
--      two failures the design spends its longest sections on: it hands him a map
--      of what she chose to conceal (§3) and it makes her revocation observable
--      (§2). The policy predates the design and was written before either risk was
--      named; it goes now, and the recipient reaches everything through the
--      curated function below.
--   4. Two SECURITY DEFINER functions: one to redeem an invite, one to return the
--      scoped rows. Neither computes anything medical — see the note on
--      `partner_shared_rows` — because tier 1 owns that (ADR-060) and a second
--      implementation in PL/pgSQL would be bound by nothing.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Columns
-- ----------------------------------------------------------------------------
alter table public.partner_links
  -- Null until he redeems the code. The v1 NOT NULL assumed she could name an
  -- account she has no way to look up; requiring an email address instead would
  -- leak whether that address has a Femio account, which is its own disclosure.
  alter column partner_profile_id drop not null;

alter table public.partner_links
  add column if not exists invite_code text,
  add column if not exists redeemed_at timestamptz,
  add column if not exists expires_at  timestamptz,
  add column if not exists version     text;

comment on column public.partner_links.invite_code is
  'Single-use rendezvous code, cleared on redemption. Grants nothing on its own: access follows partner_profile_id.';
comment on column public.partner_links.expires_at is
  'Grants are time-boxed (6 months). Consent that never expires stops being informed.';
comment on column public.partner_links.version is
  'Partner-sharing consent version — deliberately distinct from consent_records.version (Art. 9(2)(a) vs Art. 6).';

-- Unique only while the code is live; cleared codes are NULL and do not collide.
create unique index if not exists partner_links_invite_code_idx
  on public.partner_links (invite_code) where invite_code is not null;

-- ----------------------------------------------------------------------------
-- 2. The scope can only name a shareable category
--
-- The absence of a checkbox is the protection (design §4) — but a checkbox is a
-- UI, and a UI is one refactor from changing. This makes it a data constraint:
-- an INSERT naming `screenerResults` is rejected by Postgres, whatever the client
-- believes it is doing.
-- ----------------------------------------------------------------------------
create or replace function public.partner_scope_is_allowed(scope jsonb)
returns boolean
language sql
immutable
as $$
  select scope is not null
     and jsonb_typeof(scope) = 'object'
     and not exists (
       select 1
       from jsonb_object_keys(scope) as k
       where k not in ('nextPeriod','cycleDates','phase','pregnancy','symptoms','medications','fertility')
     );
$$;
comment on function public.partner_scope_is_allowed(jsonb) is
  'True when every key of a partner scope names a shareable category. Screener results, the crisis surface and appointment questions have no id and cannot appear.';

alter table public.partner_links
  drop constraint if exists partner_links_scope_allowed;
alter table public.partner_links
  add constraint partner_links_scope_allowed check (public.partner_scope_is_allowed(scope_json));

-- ----------------------------------------------------------------------------
-- 3. RLS — the owner manages her links; the recipient reads no row at all
--
-- Replacing `partner_links_select_involved`. See the header: reading the row is
-- reading the scope, and reading the scope is reading what she withheld.
-- ----------------------------------------------------------------------------
drop policy if exists partner_links_select_involved on public.partner_links;

create policy partner_links_select_own on public.partner_links
  for select using (profile_id = (select auth.uid()));

-- ----------------------------------------------------------------------------
-- 4a. Redeeming an invite
--
-- SECURITY DEFINER because the recipient must be able to match a code against a
-- row he cannot select — that is the whole reason the policy above can be as tight
-- as it is. It writes his id onto the row and clears the code, so a code works
-- exactly once and access is thereafter bound to an account she can cut off.
--
-- Returns a boolean rather than raising: a wrong code and an expired code must be
-- indistinguishable to the caller, and neither is an error condition.
-- ----------------------------------------------------------------------------
create or replace function public.redeem_partner_invite(code text)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  target public.partner_links%rowtype;
begin
  if auth.uid() is null then
    return false;
  end if;

  select * into target
    from public.partner_links
   where invite_code = code
     and partner_profile_id is null
     and revoked_at is null
     and expires_at is not null
     and expires_at > now()
   limit 1;

  if not found then
    return false;
  end if;

  -- The v1 CHECK forbids owner = recipient once both are set; catching it here
  -- turns a constraint violation into the same quiet "no" as a wrong code.
  if target.profile_id = auth.uid() then
    return false;
  end if;

  -- Redemption is what starts the six months. Until now the row has been running
  -- on the invite's short fortnight, which is deliberate: an invite left sitting in
  -- a message thread should die quickly, and the term she consented to should begin
  -- when the sharing actually does. 183 days is `SHARE_DURATION_DAYS` in
  -- `apps/web/src/lib/partner/index.ts`; the two are stated in both places because
  -- the client shows the date and the database enforces it.
  update public.partner_links
     set partner_profile_id = auth.uid(),
         redeemed_at        = now(),
         expires_at         = now() + interval '183 days',
         invite_code        = null
   where id = target.id;

  return true;
end;
$$;
comment on function public.redeem_partner_invite(text) is
  'Binds a single-use invite code to the calling account. Returns false for anything that is not a live, unredeemed code — wrong and expired are indistinguishable on purpose.';

revoke all on function public.redeem_partner_invite(text) from public;
grant execute on function public.redeem_partner_invite(text) to authenticated;

-- ----------------------------------------------------------------------------
-- 4b. The scoped read
--
-- Returns one JSON object per live share, carrying **only the granted categories**
-- as keys. A withheld category is absent from the object rather than present and
-- empty, so nothing downstream can render "hidden" for it (design §3).
--
-- ## What this function deliberately does not do
--
-- **It does not compute.** No prediction, no phase, no cycle length, no average.
-- Anything medical belongs in tier 1 or tier 2 (ADR-060), bound to the Dart twin
-- by the golden fixtures; a prediction written a third time in PL/pgSQL would be
-- bound by nothing and would quietly disagree with both clients. The `partner-view`
-- Edge Function calls this for rows and runs the same tier-2 modules the dashboard
-- runs, which is what makes "he sees the same window she does" a fact.
--
-- **It is not the partner's endpoint, and this is the one place Femio uses the
-- service role in a request path.** The `experience` function deliberately does
-- not, because it reads the caller's own record and RLS is therefore a sufficient
-- boundary. This one cannot work that way: a partner granted `nextPeriod` and not
-- `cycleDates` must receive a window *derived from* start dates he may not see, so
-- the rows have to be fetched somewhere he cannot read the response. The three
-- alternatives are all worse — return the starts to his browser and let the client
-- filter (the leak this design exists to prevent), fold the derivation into SQL (a
-- third implementation of cycle prediction, bound by no fixture), or forbid
-- `nextPeriod` without `cycleDates` (granularity removed to protect a boundary).
-- So: `service_role` only, one caller, named argument rather than `auth.uid()`, and
-- no browser can reach it.
--
-- **It never touches the never-shareable class.** `screener_results`, `help-now`
-- and `appointments.prep_json` are not read here, by any code path, for any scope.
--
-- **It refuses a minor's record.** `isMinor(null)` is true in the app
-- (`lib/persona/minor.ts`) and unknown age counts as a minor here too. Art. 8
-- parental consent has no bearing on a 15-year-old disclosing her cycle to a
-- boyfriend, so the gate is repeated at the boundary rather than trusted to the UI.
-- ----------------------------------------------------------------------------
create or replace function public.partner_shared_rows(recipient uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  link      record;
  scope     jsonb;
  payload   jsonb;
  shares    jsonb := '[]'::jsonb;
begin
  if recipient is null then
    return shares;
  end if;

  for link in
    select l.id, l.profile_id, l.scope_json, l.expires_at
      from public.partner_links l
      join public.profiles p on p.id = l.profile_id
     where l.partner_profile_id = recipient
       and l.revoked_at is null
       and l.expires_at is not null
       and l.expires_at > now()
       -- Unknown age counts as a minor, exactly as the app does.
       and p.age_band is not null
       and p.age_band not in ('under_13','13_15','16_17')
  loop
    scope   := coalesce(link.scope_json, '{}'::jsonb);
    payload := jsonb_build_object('expiresAt', link.expires_at);

    -- Cycle starts back the two categories that need them. Which of the two the
    -- recipient actually granted is decided by the Edge Function, not here: this
    -- is the trusted side of the boundary, and fetching once keeps the two paths
    -- from disagreeing about her history.
    if scope ? 'nextPeriod' or scope ? 'cycleDates' or scope ? 'phase' then
      payload := payload || jsonb_build_object(
        'cycleStarts',
        coalesce((
          select jsonb_agg(c.period_start order by c.period_start desc)
            from public.cycles c
           where c.profile_id = link.profile_id
        ), '[]'::jsonb),
        'statedCycleLength',
        to_jsonb((select pr.stated_cycle_length from public.profiles pr where pr.id = link.profile_id))
      );
    end if;

    if scope ? 'pregnancy' then
      payload := payload || jsonb_build_object(
        'pregnancy',
        coalesce((
          select to_jsonb(x)
            from (
              select pg.edd, pg.status
                from public.pregnancy pg
               where pg.profile_id = link.profile_id
               order by pg.created_at desc
               limit 1
            ) x
        ), 'null'::jsonb)
      );
    end if;

    -- Type and date only. No note, ever: `symptom_logs.note` is free text she
    -- wrote for herself, and free text is the category §4 refuses on principle.
    if scope ? 'symptoms' then
      payload := payload || jsonb_build_object(
        'symptoms',
        coalesce((
          select jsonb_agg(jsonb_build_object('type', s.type, 'loggedAt', s.logged_at)
                           order by s.logged_at desc)
            from (
              select sl.type, sl.logged_at
                from public.symptom_logs sl
               where sl.profile_id = link.profile_id
               order by sl.logged_at desc
               limit 60
            ) s
        ), '[]'::jsonb)
      );
    end if;

    -- Names of what she is currently taking. `schedule_json` carries her dose and
    -- her private note and is not read.
    if scope ? 'medications' then
      payload := payload || jsonb_build_object(
        'medications',
        coalesce((
          select jsonb_agg(jsonb_build_object('name', m.name) order by m.name)
            from public.meds_supplements m
           where m.profile_id = link.profile_id and m.active
        ), '[]'::jsonb)
      );
    end if;

    -- Charting: the dates she logged and whether she recorded a peak. Never the
    -- `intercourse` flag, and never an HPT result — a partner learning of a
    -- positive test from an app rather than from her is the disclosure this
    -- feature must not make.
    if scope ? 'fertility' then
      payload := payload || jsonb_build_object(
        'fertility',
        coalesce((
          select jsonb_agg(jsonb_build_object('loggedAt', f.logged_at, 'opk', f.opk_result)
                           order by f.logged_at desc)
            from (
              select fl.logged_at, fl.opk_result
                from public.fertility_logs fl
               where fl.profile_id = link.profile_id
               order by fl.logged_at desc
               limit 60
            ) f
        ), '[]'::jsonb)
      );
    end if;

    shares := shares || jsonb_build_array(
      jsonb_build_object('id', link.id, 'scope', scope, 'data', payload)
    );
  end loop;

  return shares;
end;
$$;
comment on function public.partner_shared_rows(uuid) is
  'Rows a recipient is entitled to, keyed by granted category only. service_role-only: the partner-view Edge Function is the sole caller. Never reads screener_results, prep_json or anything from the crisis surface.';

-- 0004 grants execute on every public function to service_role, including ones
-- created later, so the grant below is belt-and-braces. The revokes are the part
-- that matters: without them `authenticated` would inherit PUBLIC execute and the
-- recipient's browser could ask for her start dates directly.
revoke all on function public.partner_shared_rows(uuid) from public;
revoke all on function public.partner_shared_rows(uuid) from anon;
revoke all on function public.partner_shared_rows(uuid) from authenticated;
grant execute on function public.partner_shared_rows(uuid) to service_role;
