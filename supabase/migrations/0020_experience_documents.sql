-- ============================================================================
-- Femio — the served experience document (Phase A6,
-- `docs/29_REBUILD/02_DATA_MODEL.md` §6)
--
-- ## Why store what was already resolved
--
-- `ExperienceConfig` is resolved on demand and never kept. Three consequences:
--
--   1. **"Why did it show me this?" is unanswerable.** Not a support nicety — the
--      document decides which red flags she saw, and if a question ever arises
--      about what Femio told a woman on a given day, the honest answer today is
--      "we would have to guess".
--   2. **A contract version bump has nothing to migrate.** Chapter 03 §5 runs the
--      v1→v2 move per surface behind a flag, with both documents live at once.
--      That comparison needs both to exist somewhere.
--   3. **The resolver cannot be regression-tested against real inputs**, only
--      against fixtures.
--
-- ## One row per profile per contract version
--
-- Not a ledger. A history of every resolve would be a minute-by-minute record of
-- her health state, which is exactly the row that is useful to nobody and
-- interesting to the wrong person — the same reasoning `notification_prefs` used
-- in migration 0013 for not keeping preference history.
--
-- So: the **current** document per version, overwritten on each resolve. `docs/24`
-- already treats the config as derived state; this is a cache with provenance,
-- not an audit trail.
--
-- ## It is health data
--
-- `document_json` carries `modifiers` — her recorded conditions — and `phase`.
-- Anyone reading this table knows she has PCOS and where she is in her cycle. RLS
-- is owner-only and there is no staff read, for the same reason `symptom_logs`
-- has none.
-- ============================================================================

create table if not exists public.experience_documents (
  profile_id       uuid not null references public.profiles (id) on delete cascade,
  /** The contract version this document conforms to. Two rows during a migration. */
  contract_version integer not null,
  document_json    jsonb not null,
  /** Which resolver built it, so a behaviour change is attributable. */
  resolver_version text not null,
  resolved_at      timestamptz not null default now(),
  primary key (profile_id, contract_version)
);

comment on table public.experience_documents is
  'The current served ExperienceConfig per profile per contract version. A cache with provenance, not a ledger: a history of every resolve would be a minute-by-minute record of her health state. Two rows exist only during a contract migration.';
comment on column public.experience_documents.document_json is
  'Health data. Carries `modifiers` (her recorded conditions) and `phase`. Owner-only, no staff read.';

alter table public.experience_documents enable row level security;

-- ----------------------------------------------------------------------------
-- RLS
--
-- Select and delete are hers — delete because export-and-delete must reach
-- everything. Insert and update belong to tier 1 via `service_role`: a client that
-- can write its own experience document can grant itself a persona, and
-- `persona_state`'s comment is emphatic that persona never controls access — but a
-- forged document could still put a red flag in front of a woman who has no reason
-- to see one, or take one away from a woman who does.
-- ----------------------------------------------------------------------------
drop policy if exists experience_documents_select_own on public.experience_documents;
create policy experience_documents_select_own on public.experience_documents
  for select using (profile_id = (select auth.uid()));
drop policy if exists experience_documents_delete_own on public.experience_documents;
create policy experience_documents_delete_own on public.experience_documents
  for delete using (profile_id = (select auth.uid()));

revoke insert, update on public.experience_documents from authenticated;
