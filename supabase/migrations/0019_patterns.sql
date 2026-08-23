-- ============================================================================
-- Femio — persisted patterns (Phase A5, `docs/29_REBUILD/02_DATA_MODEL.md` §5)
--
-- ## What `lib/patterns` already does, and where it is trapped
--
-- The engine finds three kinds of thing — when a symptom tends to fall in her
-- cycle, what she tends to log on the same day, and whether she has been rating
-- something higher or lower lately — each with the evidence it rests on and a
-- confidence. It waits about three cycles before saying anything, because fewer
-- than that is a coincidence.
--
-- All of that exists only inside the `/patterns` route, recomputed on every view.
-- So it cannot arrive as a home module (D6), cannot enter the visit pack (D3),
-- and cannot be dismissed — a finding she has read and does not want keeps coming
-- back, which is the specific thing that makes Flo's insight cards tiresome.
--
-- ## `summary_key`, never a sentence
--
-- A stored English sentence cannot be shown to an Arabic reader, and this table is
-- read by the web client, the Flutter client and the visit-pack renderer. So the
-- row carries a **key** and the numbers; the sentence is assembled at render time
-- in her language. This is the same rule as `ModuleSpec.a11y.labelKey` in chapter
-- 03, and it has no exceptions.
--
-- ## `evidence_json` is what makes this ours
--
-- "Together in 4 of 6 cycles" is the difference between a pattern and a horoscope.
-- Flo has a symptom-patterns feature too — correction C-5 — so the differentiator
-- is not that we analyse but that every finding carries its confidence and the
-- count behind it, and that we never grade her against a population band.
--
-- ## What this table must not hold
--
-- No causation. The engine says two things co-occur, never that one causes the
-- other, and there is deliberately no column that could carry a mechanism. No
-- severity *judgement* either: `severity_trend` records that she rated something
-- higher, which is a fact about what she typed, not a claim that she is worse.
-- ============================================================================

create table if not exists public.patterns (
  id            uuid primary key default gen_random_uuid(),
  profile_id    uuid not null references public.profiles (id) on delete cascade,
  kind          text not null
                check (kind in ('timing','co_occurrence','severity_trend')),

  /** The log key the finding is about, within its dimension. */
  subject       text not null,
  /** Co-occurrence only: the other key. Null for the other two kinds. */
  partner_key   text,

  /** i18n key. Never a rendered sentence — see the header. */
  summary_key   text not null,

  /**
   * The numbers behind the claim: cycles matched, cycles examined, the days of
   * cycle involved, the direction of a trend. Rendered beside the finding, not
   * hidden behind it.
   */
  evidence_json jsonb not null default '{}'::jsonb,

  /** 0..1. Shown through `--confidence-*`, never as a percentage badge. */
  confidence    numeric not null check (confidence >= 0 and confidence <= 1),
  /** How many cycles the finding rests on. Below the engine's floor it is not written at all. */
  cycles_used   smallint not null check (cycles_used >= 0),

  engine_version text not null,
  computed_at   timestamptz not null default now(),

  /** She has read it and does not want it again. Set by her, cleared by nobody. */
  dismissed_at  timestamptz
);

comment on table public.patterns is
  'Findings from `lib/patterns`, persisted so they can reach the home screen and the visit pack. Carries the evidence and the confidence, never a cause and never a judgement. `summary_key` is an i18n key because this row is read in four languages.';
comment on column public.patterns.evidence_json is
  'The numbers behind the claim — "together in 4 of 6 cycles". The difference between a pattern and a horoscope, and shown beside the finding rather than hidden behind it.';
comment on column public.patterns.dismissed_at is
  'Hers to set. A finding she has read and does not want does not return — the specific thing that makes a competitor''s repeating insight cards tiresome.';

alter table public.patterns enable row level security;

-- One live finding per (kind, subject, partner). A plain `unique` constraint
-- would not hold: `partner_key` is null for `timing` and `severity_trend`, and
-- Postgres treats nulls as distinct, so the engine could write the same finding
-- every run. Coalescing closes it without depending on `nulls not distinct`,
-- which is Postgres 15+ only.
create unique index if not exists patterns_profile_finding_key
  on public.patterns (profile_id, kind, subject, coalesce(partner_key, ''));

create index if not exists patterns_profile_live_idx
  on public.patterns (profile_id, confidence desc)
  where dismissed_at is null;

-- ----------------------------------------------------------------------------
-- RLS
--
-- Select and update are hers — update **only** so she can dismiss. Insert is
-- tier 1's, via `service_role`: a client that can write a pattern can write
-- "your headaches cluster before your period" into her record without any data
-- behind it.
--
-- The dismissal column is the one thing a client may change, and the policy
-- cannot express "only this column", so the narrowing lives in the grant below.
-- ----------------------------------------------------------------------------
drop policy if exists patterns_select_own on public.patterns;
create policy patterns_select_own on public.patterns
  for select using (profile_id = (select auth.uid()));
drop policy if exists patterns_update_own on public.patterns;
create policy patterns_update_own on public.patterns
  for update using (profile_id = (select auth.uid()))
  with check (profile_id = (select auth.uid()));
drop policy if exists patterns_delete_own on public.patterns;
create policy patterns_delete_own on public.patterns
  for delete using (profile_id = (select auth.uid()));

-- Column-level narrowing: she may dismiss, and may not rewrite a finding's
-- confidence, evidence or subject. RLS grants row access; this grants column
-- access, and both are needed for "she can dismiss but not edit" to be true.
revoke insert on public.patterns from authenticated;
revoke update on public.patterns from authenticated;
grant update (dismissed_at) on public.patterns to authenticated;
