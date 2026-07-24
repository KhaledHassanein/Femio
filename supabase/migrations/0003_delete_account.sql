-- ============================================================================
-- Femio — GDPR account deletion (P1.16)
-- Deleting the auth user cascades to public.profiles and every owner-scoped
-- health table (all FK'd with ON DELETE CASCADE), so one call removes the whole
-- record. Security-definer so it can delete from auth.users; it only ever removes
-- the CALLER's own account (auth.uid()).
-- ============================================================================
create or replace function public.delete_account()
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  delete from auth.users where id = auth.uid();
end;
$$;

revoke execute on function public.delete_account() from public, anon;
grant execute on function public.delete_account() to authenticated;
