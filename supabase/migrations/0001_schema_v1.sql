-- ============================================================================
-- Femio — schema v1 (P1.3)
-- Constant EMR core + additive persona layers (docs/14 §3, ADR-007).
--
-- Every table is created WITH ROW-LEVEL SECURITY ENABLED but no policies here,
-- which means DEFAULT-DENY until 0002_rls_policies.sql grants access. Never ship
-- a table without RLS (femio-engineering-standards §4).
--
-- Open clinical value sets (symptom type, lab test_type, vital type, screener
-- tool) are plain text on purpose — they evolve; closed sets use CHECK.
-- All health rows are owner-scoped via profile_id and cascade-delete with the
-- profile to support GDPR account deletion.
-- ============================================================================

-- Keep updated_at honest.
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- ----------------------------------------------------------------------------
-- Identity & account
-- ----------------------------------------------------------------------------
create table public.profiles (
  id            uuid primary key references auth.users (id) on delete cascade,
  account_type  text not null default 'anon' check (account_type in ('anon', 'registered')),
  device_key    text,
  dob           date,
  age_band      text check (age_band in
                  ('under_13','13_15','16_17','18_24','25_34','35_44','45_54','55_plus')),
  locale        text not null default 'en' check (locale in ('en','ar','fr','es')),
  rtl_pref      boolean,
  discreet_mode boolean not null default false,
  theme         text not null default 'system' check (theme in ('light','dark','system')),
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);
comment on table public.profiles is 'One row per user (auth.uid). No name/PII required; anonymous users allowed. Data minimization: prefer age_band over dob.';
alter table public.profiles enable row level security;
create trigger profiles_set_updated_at before update on public.profiles
  for each row execute function public.set_updated_at();

create table public.consent_records (
  id         uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles (id) on delete cascade,
  purpose    text not null check (purpose in ('core','insights','research','ads_contextual')),
  granted    boolean not null,
  version    text not null,
  granted_at timestamptz not null default now(),
  revoked_at timestamptz
);
comment on table public.consent_records is 'Granular, per-purpose consent log. A valid granted core row gates all health writes (see 0002).';
alter table public.consent_records enable row level security;
create index consent_records_profile_purpose_idx on public.consent_records (profile_id, purpose);

-- ----------------------------------------------------------------------------
-- Content & i18n (defined before content_history which references content)
-- ----------------------------------------------------------------------------
create table public.content (
  id             uuid primary key default gen_random_uuid(),
  type           text not null check (type in ('article','condition','faq','tip','screener')),
  slug           text not null unique,
  status         text not null default 'draft' check (status in ('draft','in_review','published')),
  medical_reviewer text,
  last_reviewed  date,
  next_review_due date,
  sources_json   jsonb,
  disclaimer_type text,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now()
);
comment on table public.content is 'CMS-authored education (Payload authors; Postgres serves). Public read only when status=published (0002).';
alter table public.content enable row level security;
create trigger content_set_updated_at before update on public.content
  for each row execute function public.set_updated_at();
create index content_status_idx on public.content (status);

create table public.content_i18n (
  id                uuid primary key default gen_random_uuid(),
  content_id        uuid not null references public.content (id) on delete cascade,
  locale            text not null check (locale in ('en','ar','fr','es')),
  title             text,
  body              text,
  reading_level_ok  boolean,
  reviewer_signed   boolean not null default false,
  hreflang          text,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now(),
  unique (content_id, locale)
);
comment on table public.content_i18n is 'Per-locale content. A locale row missing reviewer_signed cannot be published (enforced in app/CMS).';
alter table public.content_i18n enable row level security;
create trigger content_i18n_set_updated_at before update on public.content_i18n
  for each row execute function public.set_updated_at();

create table public.ui_strings (
  id       uuid primary key default gen_random_uuid(),
  key      text not null,
  locale   text not null check (locale in ('en','ar','fr','es')),
  value    text,
  status   text not null default 'machine' check (status in ('machine','human_reviewed')),
  icu      boolean not null default false,
  updated_at timestamptz not null default now(),
  unique (key, locale)
);
comment on table public.ui_strings is 'Translation-portal source of truth (P1.19). Served to next-intl; machine draft -> human review.';
alter table public.ui_strings enable row level security;
create trigger ui_strings_set_updated_at before update on public.ui_strings
  for each row execute function public.set_updated_at();

-- ----------------------------------------------------------------------------
-- Constant EMR core (present for everyone)
-- ----------------------------------------------------------------------------
create table public.cycles (
  id           uuid primary key default gen_random_uuid(),
  profile_id   uuid not null references public.profiles (id) on delete cascade,
  period_start date not null,
  period_end   date,
  flow         text check (flow in ('spotting','light','medium','heavy')),
  cycle_length integer,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);
alter table public.cycles enable row level security;
create trigger cycles_set_updated_at before update on public.cycles
  for each row execute function public.set_updated_at();
create index cycles_profile_start_idx on public.cycles (profile_id, period_start desc);

create table public.symptom_logs (
  id         uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles (id) on delete cascade,
  logged_at  timestamptz not null default now(),
  type       text not null,
  severity   smallint check (severity between 0 and 4),
  value_json jsonb,
  note       text,
  created_at timestamptz not null default now()
);
comment on column public.symptom_logs.type is 'Open set: mood/energy/sleep/pain/etc.';
alter table public.symptom_logs enable row level security;
create index symptom_logs_profile_time_idx on public.symptom_logs (profile_id, logged_at desc);

create table public.meds_supplements (
  id            uuid primary key default gen_random_uuid(),
  profile_id    uuid not null references public.profiles (id) on delete cascade,
  name          text not null,
  schedule_json jsonb,
  active        boolean not null default true,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);
alter table public.meds_supplements enable row level security;
create trigger meds_supplements_set_updated_at before update on public.meds_supplements
  for each row execute function public.set_updated_at();
create index meds_supplements_profile_idx on public.meds_supplements (profile_id);

create table public.conditions_flagged (
  id             uuid primary key default gen_random_uuid(),
  profile_id     uuid not null references public.profiles (id) on delete cascade,
  condition_code text not null,
  source         text not null check (source in ('self','screener')),
  non_diagnostic boolean not null default true,
  created_at     timestamptz not null default now()
);
comment on table public.conditions_flagged is 'User-flagged conditions. non_diagnostic is always true — Femio never diagnoses.';
alter table public.conditions_flagged enable row level security;
create index conditions_flagged_profile_idx on public.conditions_flagged (profile_id);

create table public.screener_results (
  id             uuid primary key default gen_random_uuid(),
  profile_id     uuid not null references public.profiles (id) on delete cascade,
  tool           text not null,
  score          numeric,
  subscores_json jsonb,
  taken_at       timestamptz not null default now(),
  non_diagnostic boolean not null default true,
  created_at     timestamptz not null default now()
);
comment on table public.screener_results is 'Screening only (EPDS/PHQ9/DRSP/MRS…), never diagnosis. Crisis routing handled in app logic.';
alter table public.screener_results enable row level security;
create index screener_results_profile_time_idx on public.screener_results (profile_id, taken_at desc);

create table public.content_history (
  id         uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles (id) on delete cascade,
  content_id uuid references public.content (id) on delete set null,
  viewed_at  timestamptz not null default now()
);
alter table public.content_history enable row level security;
create index content_history_profile_idx on public.content_history (profile_id, viewed_at desc);

-- ----------------------------------------------------------------------------
-- Persona layers (additive; presence gated by resolved state, never destroyed)
-- ----------------------------------------------------------------------------
create table public.labs (
  id          uuid primary key default gen_random_uuid(),
  profile_id  uuid not null references public.profiles (id) on delete cascade,
  test_type   text not null,
  value       numeric,
  unit        text,
  taken_at    date,
  source_note text,
  created_at  timestamptz not null default now()
);
comment on table public.labs is 'User-entered labs (TSH/AMH/HbA1c/ferritin…). Entry-only; never interpreted as diagnosis.';
alter table public.labs enable row level security;
create index labs_profile_idx on public.labs (profile_id, taken_at desc);

create table public.vitals (
  id          uuid primary key default gen_random_uuid(),
  profile_id  uuid not null references public.profiles (id) on delete cascade,
  type        text not null,
  value       numeric,
  unit        text,
  measured_at timestamptz not null default now(),
  created_at  timestamptz not null default now()
);
comment on column public.vitals.type is 'Open set: BP_sys/BP_dia/glucose/weight/temp_bbt…';
alter table public.vitals enable row level security;
create index vitals_profile_time_idx on public.vitals (profile_id, measured_at desc);

create table public.fertility_logs (
  id          uuid primary key default gen_random_uuid(),
  profile_id  uuid not null references public.profiles (id) on delete cascade,
  logged_at   date not null default current_date,
  bbt         numeric,
  opk_result  text check (opk_result in ('negative','low','high','peak','positive')),
  cm_type     text,
  intercourse boolean,
  hpt_result  text check (hpt_result in ('negative','positive','indeterminate')),
  dpo         smallint,
  created_at  timestamptz not null default now()
);
comment on table public.fertility_logs is 'TTC logs. Fertile-window is conception AWARENESS, never contraception (medical-device guardrail).';
alter table public.fertility_logs enable row level security;
create index fertility_logs_profile_idx on public.fertility_logs (profile_id, logged_at desc);

create table public.pregnancy (
  id                   uuid primary key default gen_random_uuid(),
  profile_id           uuid not null references public.profiles (id) on delete cascade,
  edd                  date,
  gestational_age_days integer,
  modifiers_json       jsonb,
  status               text not null default 'active' check (status in ('active','completed','loss','ended')),
  created_at           timestamptz not null default now(),
  updated_at           timestamptz not null default now()
);
comment on table public.pregnancy is 'Rows, not one-per-profile — a life spans multiple pregnancies. modifiers_json carries GDM/thyroid/HTN flags.';
alter table public.pregnancy enable row level security;
create trigger pregnancy_set_updated_at before update on public.pregnancy
  for each row execute function public.set_updated_at();
create index pregnancy_profile_idx on public.pregnancy (profile_id);

create table public.appointments (
  id          uuid primary key default gen_random_uuid(),
  profile_id  uuid not null references public.profiles (id) on delete cascade,
  clinician   text,
  type        text,
  datetime    timestamptz,
  prep_json   jsonb,
  results_due date,
  created_at  timestamptz not null default now()
);
alter table public.appointments enable row level security;
create index appointments_profile_idx on public.appointments (profile_id, datetime);

create table public.key_dates (
  id           uuid primary key default gen_random_uuid(),
  profile_id   uuid not null references public.profiles (id) on delete cascade,
  label        text,
  date         date not null,
  display_pref text,
  created_at   timestamptz not null default now()
);
comment on table public.key_dates is 'Meaningful dates incl. loss anniversaries; display_pref lets users control surfacing (emotional safety).';
alter table public.key_dates enable row level security;
create index key_dates_profile_idx on public.key_dates (profile_id);

create table public.partner_links (
  id                 uuid primary key default gen_random_uuid(),
  profile_id         uuid not null references public.profiles (id) on delete cascade,
  partner_profile_id uuid not null references public.profiles (id) on delete cascade,
  scope_json         jsonb not null default '{}'::jsonb,
  consent_ts         timestamptz,
  revoked_at         timestamptz,
  created_at         timestamptz not null default now(),
  check (profile_id <> partner_profile_id)
);
comment on table public.partner_links is 'Scoped, revocable partner sharing (X2). Raw health rows are NEVER shared directly — only curated RPC output (0002/§4).';
alter table public.partner_links enable row level security;
create index partner_links_owner_idx on public.partner_links (profile_id);
create index partner_links_partner_idx on public.partner_links (partner_profile_id);

-- ----------------------------------------------------------------------------
-- Adaptation state (the persisted "brain" — docs/09)
-- ----------------------------------------------------------------------------
create table public.persona_state (
  profile_id        uuid primary key references public.profiles (id) on delete cascade,
  track             text check (track in ('A','B','C','D','E','F','Z')),
  persona_id        text,
  modifiers         text[] not null default '{}',
  emotional_context text[] not null default '{}',
  flags_json        jsonb not null default '{}'::jsonb,
  clock_json        jsonb not null default '{}'::jsonb,
  confidence        numeric,
  updated_at        timestamptz not null default now()
);
comment on table public.persona_state is 'One resolved state per profile. Written by the server-side resolver (RPC, later). Never controls access — only emphasis.';
alter table public.persona_state enable row level security;
create trigger persona_state_set_updated_at before update on public.persona_state
  for each row execute function public.set_updated_at();

create table public.adaptation_events (
  id         uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles (id) on delete cascade,
  event_type text not null,
  payload_json jsonb,
  from_state jsonb,
  to_state   jsonb,
  created_at timestamptz not null default now()
);
comment on table public.adaptation_events is 'Append-only audit of state transitions (positive_test/loss/red_flag…). Supports reversibility.';
alter table public.adaptation_events enable row level security;
create index adaptation_events_profile_idx on public.adaptation_events (profile_id, created_at desc);

-- ----------------------------------------------------------------------------
-- Commerce & roles (stubs for later phases)
-- ----------------------------------------------------------------------------
create table public.subscriptions (
  id         uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles (id) on delete cascade,
  tier       text not null default 'free' check (tier in ('free','pro','ai')),
  provider   text,
  status     text,
  renews_at  timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.subscriptions enable row level security;
create trigger subscriptions_set_updated_at before update on public.subscriptions
  for each row execute function public.set_updated_at();
create index subscriptions_profile_idx on public.subscriptions (profile_id);

create table public.staff_roles (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references auth.users (id) on delete cascade,
  role       text not null check (role in ('admin','editor','medical_reviewer','translator','support')),
  created_at timestamptz not null default now(),
  unique (user_id, role)
);
comment on table public.staff_roles is 'Back-office roles. Referenced by content/staff RLS policies (0002).';
alter table public.staff_roles enable row level security;

create table public.audit_log (
  id         uuid primary key default gen_random_uuid(),
  actor      uuid references auth.users (id) on delete set null,
  action     text not null,
  target     text,
  meta_json  jsonb,
  created_at timestamptz not null default now()
);
comment on table public.audit_log is 'Append-only admin/data-access trail. Admin-read only (0002).';
alter table public.audit_log enable row level security;
create index audit_log_created_idx on public.audit_log (created_at desc);
