-- ============================================================================
-- Femio — `symptom_logs.dimension` (Phase A2, `docs/29_REBUILD/02_DATA_MODEL.md` §2)
--
-- ## One column doing four jobs
--
-- `symptom_logs.type` is an open set, and roughly twenty-two keys are in use with
-- mood mixed in among the physical symptoms. Four different kinds of fact are
-- flattened into one dimension, and they are not interchangeable:
--
--   * A **mood** is a state she reports about herself.
--   * A **symptom** is a bodily event with a severity and a clinical name.
--   * **Discharge** is an observation with its own vocabulary, clinically
--     meaningful for TTC and for infection awareness.
--   * The **intercourse marker** is a date, and it is the most sensitive row in
--     the table.
--
-- Flattening them costs three things. `lib/patterns` cannot distinguish "this
-- symptom co-occurs with a mood" from "with another symptom", which are different
-- findings. The log screen cannot give mood its own section without a hardcoded
-- client-side list of which keys are moods. And nothing can apply a different
-- sharing or discreet-mode rule to the intercourse marker, which OD-5 requires.
--
-- ## A discriminator, not a partition
--
-- `symptoms.ts` already carries the right instinct, in its own words: the
-- vocabulary is *"grown, never partitioned"*, because a separate menopause list
-- beside the cycle one would have meant a woman in cycle mode could not log a
-- night sweat — restriction by data structure, which is product rule 2 violated
-- in the schema.
--
-- `dimension` must not undo that. It groups facts for **analysis and privacy**;
-- it never decides what she may log. Every term stays offered to every persona,
-- and what a persona changes is emphasis. Any code that filters the loggable set
-- by dimension is the bug this paragraph exists to name.
--
-- ## Why a column and not four tables
--
-- Because they share every other property — profile, timestamp, severity, note,
-- soft-delete behaviour, RLS — and because the pattern engine reads across them.
-- Four tables would mean four unions in every query that matters. The dimension
-- is a discriminator, not a different entity.
--
-- ## The closed set
--
-- A CHECK rather than a client convention, for the same reason migration 0011
-- constrained the partner-sharing scope: a UI is one refactor away from changing
-- and a constraint is not. `vital` is a pointer — the values live in `vitals` —
-- and exists so a log entry can reference one without a nullable join.
--
-- ## Backfill
--
-- The mood keys are the ones `apps/web/src/lib/cycle/symptoms.ts` already treats
-- as moods. Everything else stays `symptom`, which is the default, so a row this
-- migration does not recognise is classified the safe way rather than the clever
-- way.
-- ============================================================================

alter table public.symptom_logs
  add column if not exists dimension text not null default 'symptom';

alter table public.symptom_logs
  drop constraint if exists symptom_logs_dimension_allowed;
alter table public.symptom_logs
  add constraint symptom_logs_dimension_allowed
  check (dimension in ('symptom','mood','discharge','intercourse','vital'));

comment on column public.symptom_logs.dimension is
  'symptom | mood | discharge | intercourse | vital. A discriminator, not a category: these are four kinds of fact with different clinical meaning and different privacy weight. `vital` points at `vitals`.';

comment on column public.symptom_logs.type is
  'The log key within its dimension. Open set by design; the canonical vocabulary is a tier-1 artefact (`LogVocabulary`), not a client constant.';

-- ----------------------------------------------------------------------------
-- Backfill: the keys that were always moods.
--
-- These are exactly the nine keys in `SYMPTOM_GROUPS[group="mood"]` in
-- `apps/web/src/lib/cycle/symptoms.ts` as of this migration. Anything not listed
-- keeps the `symptom` default — a row we do not recognise is better classified
-- conservatively than guessed at.
--
-- **If that group changes, this list is stale.** The permanent fix is B3, which
-- moves the vocabulary to a tier-1 `LogVocabulary` artefact carrying its own
-- dimension per term; this backfill is the one-time bridge to it.
-- ----------------------------------------------------------------------------
update public.symptom_logs
   set dimension = 'mood'
 where dimension = 'symptom'
   and type in (
     'happy','calm','anxious','irritable','sad',
     'moodSwings','lowMotivation','tearfulness','panicFeelings'
   );

-- ----------------------------------------------------------------------------
-- The index the pattern engine and the log screen both need.
--
-- The existing `(profile_id, logged_at desc)` index stays and still serves "her
-- most recent logs". This one serves "her moods over time" and "everything she
-- logged in this dimension on this day", which are the two shapes the new log
-- screen issues.
-- ----------------------------------------------------------------------------
create index if not exists symptom_logs_profile_dim_time_idx
  on public.symptom_logs (profile_id, dimension, logged_at desc);
