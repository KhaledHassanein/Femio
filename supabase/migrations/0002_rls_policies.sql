-- ============================================================================
-- Femio — RLS policies, consent gate, and auth triggers (P1.3c)
-- Implements docs/14 §4. Default is deny (RLS enabled in 0001); this file grants
-- the minimum access. Health writes are gated on a granted 'core' consent row.
--
-- Role model (Supabase): truly-unauthenticated requests run as `anon`;
-- signed-in users — INCLUDING native anonymous-mode users — run as
-- `authenticated` with a real auth.uid(). So anonymous mode gets full owner CRUD
-- via RLS, while `anon` only reads published content + UI strings. This is why
-- Femio uses native anonymous sign-in rather than a device_key (ADR-010).
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Helper functions (SECURITY DEFINER so policies can consult gated tables
-- without recursion; search_path pinned + all names schema-qualified).
-- ----------------------------------------------------------------------------
create or replace function public.has_core_consent(uid uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.consent_records
    where profile_id = uid
      and purpose = 'core'
      and granted = true
      and revoked_at is null
  );
$$;
comment on function public.has_core_consent(uuid) is 'True when the profile has an active granted core consent. Gates all health writes.';

create or replace function public.is_staff(uid uuid, roles text[])
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.staff_roles where user_id = uid and role = any (roles)
  );
$$;
comment on function public.is_staff(uuid, text[]) is 'True when the user holds any of the given back-office roles.';

-- ----------------------------------------------------------------------------
-- Auto-provision a profile for every new auth user (incl. anonymous).
-- ----------------------------------------------------------------------------
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, account_type)
  values (new.id, case when new.is_anonymous then 'anon' else 'registered' end)
  on conflict (id) do nothing;
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ----------------------------------------------------------------------------
-- Base privileges (RLS still decides WHICH rows; these say "may attempt").
-- ----------------------------------------------------------------------------
grant usage on schema public to anon, authenticated;
grant select, insert, update, delete on all tables in schema public to authenticated;
grant select on all tables in schema public to anon;
grant execute on all functions in schema public to anon, authenticated;

-- ----------------------------------------------------------------------------
-- Owner-only health tables — select/update/delete for the owner; insert also
-- requires an active core consent. Applied uniformly via a loop over the table
-- list so the rule is auditable in one place.
-- ----------------------------------------------------------------------------
do $$
declare
  t text;
  owner_tables text[] := array[
    'cycles','symptom_logs','meds_supplements','conditions_flagged',
    'screener_results','content_history','labs','vitals','fertility_logs',
    'pregnancy','appointments','key_dates','persona_state'
  ];
begin
  foreach t in array owner_tables loop
    execute format(
      'create policy %I on public.%I for select using (profile_id = (select auth.uid()));',
      t || '_select_own', t);
    execute format(
      'create policy %I on public.%I for insert with check (profile_id = (select auth.uid()) and public.has_core_consent((select auth.uid())));',
      t || '_insert_own', t);
    execute format(
      'create policy %I on public.%I for update using (profile_id = (select auth.uid())) with check (profile_id = (select auth.uid()));',
      t || '_update_own', t);
    execute format(
      'create policy %I on public.%I for delete using (profile_id = (select auth.uid()));',
      t || '_delete_own', t);
  end loop;
end;
$$;

-- ----------------------------------------------------------------------------
-- profiles — the owner manages their own row (insert is normally the trigger).
-- ----------------------------------------------------------------------------
create policy profiles_select_own on public.profiles
  for select using (id = (select auth.uid()));
create policy profiles_insert_own on public.profiles
  for insert with check (id = (select auth.uid()));
create policy profiles_update_own on public.profiles
  for update using (id = (select auth.uid())) with check (id = (select auth.uid()));
create policy profiles_delete_own on public.profiles
  for delete using (id = (select auth.uid()));

-- ----------------------------------------------------------------------------
-- consent_records — NOT consent-gated (this is how consent is granted/revoked).
-- No delete: the consent log is append/revoke-only.
-- ----------------------------------------------------------------------------
create policy consent_select_own on public.consent_records
  for select using (profile_id = (select auth.uid()));
create policy consent_insert_own on public.consent_records
  for insert with check (profile_id = (select auth.uid()));
create policy consent_update_own on public.consent_records
  for update using (profile_id = (select auth.uid())) with check (profile_id = (select auth.uid()));

-- ----------------------------------------------------------------------------
-- adaptation_events — append-only: owner select + consent-gated insert only.
-- ----------------------------------------------------------------------------
create policy adaptation_events_select_own on public.adaptation_events
  for select using (profile_id = (select auth.uid()));
create policy adaptation_events_insert_own on public.adaptation_events
  for insert with check (profile_id = (select auth.uid()) and public.has_core_consent((select auth.uid())));

-- ----------------------------------------------------------------------------
-- partner_links — owner manages; the partner may READ links naming them (so they
-- know their scope). Raw health rows are never exposed here — only via curated
-- security-definer RPCs (later). The never-shareable class is excluded there.
-- ----------------------------------------------------------------------------
create policy partner_links_select_involved on public.partner_links
  for select using (profile_id = (select auth.uid()) or partner_profile_id = (select auth.uid()));
create policy partner_links_insert_own on public.partner_links
  for insert with check (profile_id = (select auth.uid()));
create policy partner_links_update_own on public.partner_links
  for update using (profile_id = (select auth.uid())) with check (profile_id = (select auth.uid()));
create policy partner_links_delete_own on public.partner_links
  for delete using (profile_id = (select auth.uid()));

-- ----------------------------------------------------------------------------
-- subscriptions — owner reads own; writes come from billing webhooks (service
-- role, which bypasses RLS).
-- ----------------------------------------------------------------------------
create policy subscriptions_select_own on public.subscriptions
  for select using (profile_id = (select auth.uid()));

-- ----------------------------------------------------------------------------
-- content / content_i18n — public read when published; staff-only writes.
-- ----------------------------------------------------------------------------
create policy content_select_published on public.content
  for select using (
    status = 'published'
    or public.is_staff((select auth.uid()), array['admin','editor','medical_reviewer'])
  );
create policy content_insert_staff on public.content
  for insert with check (public.is_staff((select auth.uid()), array['admin','editor']));
create policy content_update_staff on public.content
  for update using (public.is_staff((select auth.uid()), array['admin','editor','medical_reviewer']))
  with check (public.is_staff((select auth.uid()), array['admin','editor','medical_reviewer']));
create policy content_delete_admin on public.content
  for delete using (public.is_staff((select auth.uid()), array['admin']));

create policy content_i18n_select_published on public.content_i18n
  for select using (
    exists (select 1 from public.content c where c.id = content_id and c.status = 'published')
    or public.is_staff((select auth.uid()), array['admin','editor','medical_reviewer','translator'])
  );
create policy content_i18n_insert_staff on public.content_i18n
  for insert with check (public.is_staff((select auth.uid()), array['admin','editor','translator']));
create policy content_i18n_update_staff on public.content_i18n
  for update using (public.is_staff((select auth.uid()), array['admin','editor','translator']))
  with check (public.is_staff((select auth.uid()), array['admin','editor','translator']));
create policy content_i18n_delete_staff on public.content_i18n
  for delete using (public.is_staff((select auth.uid()), array['admin','editor']));

-- ----------------------------------------------------------------------------
-- ui_strings — public read (UI strings are not sensitive); staff-only writes.
-- ----------------------------------------------------------------------------
create policy ui_strings_select_all on public.ui_strings
  for select using (true);
create policy ui_strings_insert_staff on public.ui_strings
  for insert with check (public.is_staff((select auth.uid()), array['admin','editor','translator']));
create policy ui_strings_update_staff on public.ui_strings
  for update using (public.is_staff((select auth.uid()), array['admin','editor','translator']))
  with check (public.is_staff((select auth.uid()), array['admin','editor','translator']));
create policy ui_strings_delete_admin on public.ui_strings
  for delete using (public.is_staff((select auth.uid()), array['admin']));

-- ----------------------------------------------------------------------------
-- staff_roles — a user sees own roles; only admins manage roles.
-- ----------------------------------------------------------------------------
create policy staff_roles_select on public.staff_roles
  for select using (user_id = (select auth.uid()) or public.is_staff((select auth.uid()), array['admin']));
create policy staff_roles_insert_admin on public.staff_roles
  for insert with check (public.is_staff((select auth.uid()), array['admin']));
create policy staff_roles_update_admin on public.staff_roles
  for update using (public.is_staff((select auth.uid()), array['admin']))
  with check (public.is_staff((select auth.uid()), array['admin']));
create policy staff_roles_delete_admin on public.staff_roles
  for delete using (public.is_staff((select auth.uid()), array['admin']));

-- ----------------------------------------------------------------------------
-- audit_log — append-only; admins read.
-- ----------------------------------------------------------------------------
create policy audit_log_select_admin on public.audit_log
  for select using (public.is_staff((select auth.uid()), array['admin']));
create policy audit_log_insert_self on public.audit_log
  for insert with check (actor = (select auth.uid()));
