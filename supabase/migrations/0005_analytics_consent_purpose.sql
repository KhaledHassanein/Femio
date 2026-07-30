-- ============================================================================
-- Femio — add the 'analytics' consent purpose (P1.20)
--
-- docs/13 §6 specifies granular consent per purpose (essential / analytics /
-- research), but schema v1 shipped ('core','insights','research','ads_contextual')
-- with no analytics purpose. 'insights' is not a substitute: it means "use my
-- entries to show me patterns" — first-party processing of her own data — and
-- reusing it as permission to send events to a third-party vendor would be
-- purpose creep of exactly the kind the FTC pursued Flo for.
--
-- Product analytics is non-essential, so it is opt-in: no row means no consent,
-- and lib/analytics/track.ts fails closed. Adding the purpose grants nothing to
-- anyone; it only makes a future grant recordable.
--
-- Widening a CHECK constraint accepts every existing row unchanged, so this is
-- safe to apply to the live database with no backfill.
-- ============================================================================
alter table public.consent_records
  drop constraint if exists consent_records_purpose_check;

alter table public.consent_records
  add constraint consent_records_purpose_check
  check (purpose in ('core', 'insights', 'research', 'ads_contextual', 'analytics'));

comment on table public.consent_records is
  'Granular, per-purpose consent log. A valid granted core row gates all health writes (see 0002). '
  'analytics = optional, opt-in permission for pseudonymous, health-field-free product analytics '
  '(P1.20); it never authorizes sending health data to a third party.';
