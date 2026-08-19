-- 0009 — `pregnancy.ended_on`: the delivery date nobody stored (P2.4b).
--
-- WHY THIS EXISTS
--
-- E1's `emrView` has named `deliveryDate` since R2.5 and nothing ever wrote one.
-- Tier 1 derives `weeksSincePregnancyEnd` from `pregnancy.updated_at`, which is
-- adequate for a coarse signal — "is she inside the postpartum window" — and wrong
-- for anything anchored to a day. `updated_at` moves whenever the row is touched,
-- so correcting a typo months later would silently shift her follow-up window and
-- her postpartum week with it.
--
-- P2.4b's follow-up schedule is the first surface that needs a real date: the
-- glucose test window guidance describes runs from about four to twelve weeks
-- after birth, and a schedule anchored to a timestamp that means "last edited" is
-- a schedule that quietly lies. Rather than anchor it to that, the card declines to
-- say where she is until this column exists.
--
-- WHAT IT DELIBERATELY IS NOT
--
-- A date, not a timestamp. The hour a pregnancy ended is not something Femio has a
-- use for, and storing less is the rule for health data it does not need
-- (data minimisation, product rule 4). It is also nullable and stays nullable: a
-- woman who joined Femio after giving birth, or who ended a record without giving
-- a date, must not be blocked from having one — the wizard's "roughly when did you
-- give birth" band (P1.27.8) remains the answer for her, and the two are read in
-- that order.
--
-- No backfill. Existing rows keep `null` rather than being given `updated_at` as a
-- guess: an invented date that looks recorded is worse than an absent one, and the
-- surfaces that read it already handle absence.

alter table public.pregnancy
  add column if not exists ended_on date;

comment on column public.pregnancy.ended_on is
  'The day the pregnancy ended, as she recorded it. A date, never a timestamp — the '
  'hour has no use here. Null is normal and permanent for anyone who joined after '
  'giving birth or did not give a date; read the wizard band before falling back to '
  'updated_at, which means "last edited" and not "gave birth".';

-- RLS: the column inherits the table's existing policies, which already scope every
-- row to its owner. Nothing new to grant, and nothing new exposed — but stated here
-- because a column added to a health table without checking that is how a leak
-- happens quietly.
