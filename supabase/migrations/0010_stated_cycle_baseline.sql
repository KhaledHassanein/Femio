-- ============================================================================
-- Femio — the cycle baseline she states herself (R3.1b.1)
--
-- Every app in this category asks two questions during setup: how long her cycle
-- usually is, and how long her period usually lasts. Femio asked neither. It
-- asked a life stage, an age band and consent, then said nothing useful until she
-- had logged two full cycles — which is why the first run felt empty, and why
-- predictions were hostage to whatever rows happened to exist (R3.1.9).
--
-- These are **her statement**, not an observation, and the distinction is the
-- whole point of storing them separately rather than seeding a fake `cycles` row:
--
--   * A fabricated cycle row would be indistinguishable from something she
--     recorded. It would appear in her history, in her export, and in the report
--     she hands a clinician, as though she had logged a period that never
--     happened. The report has to tell recorded from derived (phase 1c), and that
--     is impossible if the seed is laundered into the record on day one.
--   * Her own logged cycles must be able to overrule this without deleting it.
--     Keeping it on the profile means observation takes over silently and the
--     stated value is still there to explain where the early numbers came from.
--
-- Nullable on purpose. Both questions are skippable — Flo and Clue both allow
-- "I don't know" — and a skipped answer must stay distinguishable from a stated
-- one, so the UI can say which number it is using rather than quietly defaulting.
--
-- Bounds match what the app already treats as a cycle: `lib/cycle/phases.ts`
-- refuses to estimate below 21 days because the backwards ovulation estimate
-- collides with the bleeding days, and 21–35 is the range the NHS describes as
-- usual. Values outside it are a typo, not a cycle, and the constraint says so
-- here rather than trusting four clients to agree.
-- ============================================================================

alter table public.profiles
  add column if not exists stated_cycle_length  integer
    check (stated_cycle_length is null or stated_cycle_length between 21 and 35),
  add column if not exists stated_period_length integer
    check (stated_period_length is null or stated_period_length between 1 and 10);

comment on column public.profiles.stated_cycle_length is
  'Her stated usual cycle length in days. NOT an observation — used as the baseline '
  'until her own logged cycles are a better answer. Null means she skipped the question.';

comment on column public.profiles.stated_period_length is
  'Her stated usual period length in days. NOT an observation. Null means skipped.';
