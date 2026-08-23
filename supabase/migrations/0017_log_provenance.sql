-- ============================================================================
-- Femio — provenance on measured values (Phase A3,
-- `docs/29_REBUILD/02_DATA_MODEL.md` §3, **corrected**)
--
-- ## The correction this migration records
--
-- Chapter 02 §3 said BBT "has nowhere to live". That was wrong, and it is the
-- same mistake as correction C-1 in the teardown ledger: describing a gap from
-- the plan instead of from the code.
--
-- `fertility_logs` has carried all three of the supposedly missing things since
-- schema v1:
--
--   * `bbt numeric` — with `lib/fertility` already doing plausibility checks and
--     unit inference (`isPlausibleBbt`, Celsius/Fahrenheit detection).
--   * `cm_type text` — cervical mucus, which is the discharge vocabulary.
--   * `intercourse boolean` — **exactly the conservative date-only marker OD-5
--     asks for.** No act types, no orgasm entries, no category. A boolean on a
--     date. It was already right.
--
-- So the real gap is not schema, it is **surfacing**: these columns are reachable
-- only from the TTC charting screen, so a woman on the cycle track cannot log a
-- temperature or a discharge observation at all. That is a Phase C and D problem
-- (the log screen and the vocabulary), not a migration.
--
-- What genuinely is missing here is provenance.
--
-- ## Provenance, and why it is not cosmetic
--
-- When Health Connect and HealthKit land (TD-07), rows will arrive that she did
-- not type. A weight synced from a scale and a weight she entered are different
-- kinds of evidence, and three things depend on telling them apart:
--
--   * **The visit pack** (D3) must say which numbers are hers and which came from
--     a device, because a clinician reading it will ask.
--   * **Her own trust** — a value she never entered appearing in her record with
--     no explanation is alarming, and correctly so.
--   * **Deletion.** Disconnecting a platform should be able to remove what that
--     platform wrote without touching what she did.
--
-- Adding it now, before any integration exists, means the integration cannot ship
-- without it. Adding it afterwards means a backfill that has to guess.
-- ============================================================================

alter table public.vitals
  add column if not exists source text not null default 'user';
alter table public.vitals
  drop constraint if exists vitals_source_allowed;
alter table public.vitals
  add constraint vitals_source_allowed
  check (source in ('user','imported','health_platform'));

alter table public.fertility_logs
  add column if not exists source text not null default 'user';
alter table public.fertility_logs
  drop constraint if exists fertility_logs_source_allowed;
alter table public.fertility_logs
  add constraint fertility_logs_source_allowed
  check (source in ('user','imported','health_platform'));

comment on column public.vitals.source is
  'user | imported | health_platform. A device reading is not her testimony; the visit pack has to be able to say which is which, and disconnecting a platform must be able to remove only what it wrote.';
comment on column public.fertility_logs.source is
  'user | imported | health_platform. Same rule as `vitals.source`.';

-- ----------------------------------------------------------------------------
-- The canonical vital kinds, documented rather than constrained.
--
-- `vitals.type` stays an open set on purpose — the same reason
-- `symptom_logs.type` does. A CHECK here would mean a migration every time a new
-- measurement is supported, and the closed set that matters lives in tier 1 as
-- `LogVocabulary` (Phase B3), where both clients read the same list.
--
-- This comment is the record of what tier 1 is expected to register:
--   weight · glucose · bp_sys · bp_dia · temp_body · resting_hr · hrv
--   sleep_minutes · steps
--
-- **BBT is deliberately absent from that list.** It lives in `fertility_logs.bbt`
-- where `lib/fertility` already reads it, and duplicating it here would create two
-- sources of truth for one measurement — the exact defect this migration exists to
-- avoid elsewhere.
-- ----------------------------------------------------------------------------
comment on column public.vitals.type is
  'Open set. Canonical kinds are registered in tier 1 (`LogVocabulary`): weight, glucose, bp_sys, bp_dia, temp_body, resting_hr, hrv, sleep_minutes, steps. BBT is NOT here — it lives in `fertility_logs.bbt`.';

-- ----------------------------------------------------------------------------
-- Time-series reads.
--
-- The existing `(profile_id, measured_at desc)` index serves "her recent vitals".
-- Every chart in Phase C asks a different question — "this measurement, over
-- time" — and would otherwise scan her whole history to draw one line.
-- ----------------------------------------------------------------------------
create index if not exists vitals_profile_type_time_idx
  on public.vitals (profile_id, type, measured_at desc);

create index if not exists fertility_logs_profile_date_idx
  on public.fertility_logs (profile_id, logged_at desc);
