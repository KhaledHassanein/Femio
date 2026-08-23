-- ============================================================================
-- Femio — predictions, with what they rest on and what happened (Phase A4,
-- `docs/29_REBUILD/02_DATA_MODEL.md` §4)
--
-- ## Why a prediction has to be stored
--
-- Today a prediction is computed, rendered, and forgotten. That makes four things
-- impossible, and the fourth is the one that matters:
--
--   1. Explaining a prediction after the fact — the ⓘ in chapter 06 §1.
--   2. Rendering two probability tiers consistently across the dashboard, the
--      calendar and the summary, because each surface would recompute its own.
--   3. Saying whether Femio has been accurate **for her**.
--   4. Knowing we were wrong.
--
-- The teardown found Flo in exactly this position: its copy hedges well ("likely
-- to start", "on or around") and its product cannot say *why*, because there is
-- nowhere for the reasoning to live. Its calendar collapses the two tiers its own
-- strings describe into one dotted ring. Storing the prediction is what separates
-- hedging from explaining.
--
-- ## `basis_json` is the feature, not metadata
--
-- It carries what D2 renders: which cycle lengths were used, how many, their
-- spread, and which rule fired. It is written by tier 1 and **read** by the
-- client. No renderer recomputes it — that is the ADR-061 line, and a chart that
-- re-derives a band is a second implementation of a medical decision.
--
-- ## Two tiers, stored separately
--
-- `likely_*` is the narrow band; `window_*` is the full one. OD-15 asks the
-- calendar to render both, differently. Storing them as separate columns rather
-- than deriving one from the other means the two surfaces cannot disagree, and it
-- means tier 1 can change how the narrow band is chosen without every client
-- following.
--
-- ## What this table must never become
--
-- A score. There is no `accuracy` column and no grade. `observed_date` records
-- what happened; any statement about accuracy is computed from it at read time and
-- phrased as a fact about her record ("the last six were within two days"), never
-- as a mark out of ten. Chapter 01 §6: nothing labels anything normal or abnormal.
-- ============================================================================

create table if not exists public.predictions (
  id             uuid primary key default gen_random_uuid(),
  profile_id     uuid not null references public.profiles (id) on delete cascade,
  kind           text not null
                 check (kind in ('period_start','fertile_window','ovulation','cycle_length')),
  computed_at    timestamptz not null default now(),

  /** The answer. `point_date` for a single day, the window pair for a span. */
  point_date     date,
  window_start   date,
  window_end     date,

  /**
   * The narrow band — "likely to start" — inside `window_*`, which is "may start".
   * Both stored so the calendar, the dashboard and the summary cannot disagree.
   */
  likely_start   date,
  likely_end     date,

  /** 0..1. Rendered through `--confidence-*` tokens, never as a percentage badge. */
  confidence     numeric not null check (confidence >= 0 and confidence <= 1),

  /**
   * What D2 shows her: the cycles used, how many, their spread, which rule fired.
   * Written by tier 1, read by the client, never recomputed in a renderer.
   */
  basis_json     jsonb not null default '{}'::jsonb,

  /** Which resolver produced this, so a model change is attributable. */
  engine_version text not null,

  /** Filled when the event actually happens. Null is the normal state. */
  observed_date  date,
  observed_at    timestamptz,

  created_at     timestamptz not null default now()
);

comment on table public.predictions is
  'What Femio predicted, how sure it was, what it rested on, and what happened. Stored so a prediction can be explained rather than merely hedged. Carries no accuracy score: any such statement is computed at read time and phrased as a fact about her record.';
comment on column public.predictions.basis_json is
  'The reasoning D2 renders — cycles used, count, spread, rule fired. Tier 1 writes it; no client recomputes it (ADR-061).';
comment on column public.predictions.likely_start is
  'The narrow "likely" band inside the wider "may" window. Both stored so surfaces cannot disagree, and so tier 1 can change how the band is chosen without every client following.';

alter table public.predictions enable row level security;

create index if not exists predictions_profile_kind_time_idx
  on public.predictions (profile_id, kind, computed_at desc);

-- Outcome backfill: "which predictions are still waiting for their event".
create index if not exists predictions_pending_idx
  on public.predictions (profile_id, kind)
  where observed_date is null;

-- ----------------------------------------------------------------------------
-- RLS
--
-- Read and delete are hers. **There is no insert or update policy for
-- `authenticated`**, and that is deliberate: a prediction is a tier-1 output, and
-- a client that can write one can write a fertility window she did not earn.
-- `service_role` bypasses RLS, which is how the Edge Function writes.
--
-- Delete is hers because export-and-delete has to reach everything, and because a
-- record of what an app guessed about her body is hers to remove.
-- ----------------------------------------------------------------------------
drop policy if exists predictions_select_own on public.predictions;
create policy predictions_select_own on public.predictions
  for select using (profile_id = (select auth.uid()));
drop policy if exists predictions_delete_own on public.predictions;
create policy predictions_delete_own on public.predictions
  for delete using (profile_id = (select auth.uid()));

-- The blanket grant from 0014 hands `authenticated` insert and update on every
-- table. RLS then denies both for want of a policy, which is the correct
-- default-deny — but revoking makes the intent explicit rather than incidental,
-- and survives someone adding a permissive policy without reading this comment.
revoke insert, update on public.predictions from authenticated;
