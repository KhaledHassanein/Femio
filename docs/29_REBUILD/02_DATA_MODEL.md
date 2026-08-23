# 29.02 — Data model

Current state: 27 tables across 14 migrations, every one holding real data. The model
is already broader than any competitor's — none of the three has `labs`,
`meds_supplements`, `screener_results`, `conditions_flagged`, `consent_records` or
`audit_log`. What it lacks is resolution in three specific places and a home for
three new capabilities.

Migrations are numbered from `0015`. Each section states what changes and why; none
of them drops a column.

---

## 1. `cycles` — flow is per-cycle, and it needs to be per-day

**Current.**

```sql
cycles (id, profile_id, period_start, period_end,
        flow text check (flow in ('spotting','light','medium','heavy')),
        cycle_length, created_at, updated_at)
```

**The problem.** One `flow` value describes an entire period. A real period is heavy
on day two and spotting on day five, and OD-15 asks the calendar to distinguish the
first and last day of a run — which needs per-day data to be honest about. Flo logs
flow per day and animates each level; we cannot render a flow strip that means
anything from a single enum.

**Change — `0015_period_days.sql`.**

```sql
create table public.period_days (
  id          uuid primary key default gen_random_uuid(),
  profile_id  uuid not null references public.profiles (id) on delete cascade,
  cycle_id    uuid references public.cycles (id) on delete cascade,
  day         date not null,
  flow        text not null check (flow in ('spotting','light','medium','heavy')),
  source      text not null default 'user'
              check (source in ('user','imported','health_platform')),
  created_at  timestamptz not null default now(),
  unique (profile_id, day)
);
```

`cycles.flow` stays, deprecated in a comment, backfilled onto every day of each
existing period so nothing regresses. `cycles` remains the authority for
`period_start`, `period_end` and `cycle_length`; `period_days` is the detail.

`source` matters for TD-07: a day written by Health Connect must be distinguishable
from one she typed, because only one of them is her testimony.

---

## 2. `symptom_logs` — one dimension doing four jobs

**Current.**

```sql
symptom_logs (id, profile_id, logged_at, type text, severity smallint 0..4,
              value_json jsonb, note, created_at)
```

with `type` an open set. Roughly 22 keys are in use, and mood is mixed in among them.

**The problem.** Mood, physical symptom, discharge and the intercourse marker are
four different kinds of fact with different clinical meaning, different privacy
weight and different analytical treatment. Flattening them into `type` means
`lib/patterns` cannot distinguish "co-occurs with a mood" from "co-occurs with a
symptom", and it means we cannot apply a different consent or sharing rule to the
intercourse marker — which OD-5 requires us to treat carefully.

**Change — `0016_log_dimensions.sql`.**

```sql
alter table public.symptom_logs
  add column dimension text not null default 'symptom'
    check (dimension in ('symptom','mood','discharge','intercourse','vital'));

create index symptom_logs_profile_dim_time_idx
  on public.symptom_logs (profile_id, dimension, logged_at desc);
```

Backfill: the nine keys in `SYMPTOM_GROUPS[group="mood"]` — `happy`, `calm`,
`anxious`, `irritable`, `sad`, `moodSwings`, `lowMotivation`, `tearfulness`,
`panicFeelings` — become `dimension = 'mood'`; everything else keeps the `'symptom'`
default. (An earlier draft of this list was written from memory and was wrong in
three places; the migration carries the correct set and a note that it goes stale if
the group changes.)

**`dimension` is a discriminator, not a partition.** `symptoms.ts` says the
vocabulary is *"grown, never partitioned"*, because a separate menopause list would
mean a woman in cycle mode could not log a night sweat — product rule 2 violated in
the schema. Dimension groups facts for analysis and privacy; it never decides what
she may log.

**The vocabulary that fills it** (chapter 03 §4 owns the canonical list, tier 1):

| Dimension | Content | Notes |
|---|---|---|
| `symptom` | Expanded from ~22 toward Flo's 47, chosen for clinical weight rather than count. Adds the perimenopause set (hot flushes, night sweats, brain fog, joint pain, palpitations, vaginal dryness, bladder leaks) and the pregnancy/postpartum set (heartburn, food aversions, perineal pain, stretch marks) that `docs/16` and the MRS already imply. | |
| `mood` | Its own dimension, roughly 12–16 entries | |
| `discharge` | Cervical fluid types — clinically meaningful for TTC and infection awareness. **Already exists as `fertility_logs.cm_type`**; the work is surfacing it beyond the TTC screen (§3) | |
| `intercourse` | **One marker. Date only.** No act types, no orgasm or masturbation entries. Conservative wording in all four languages. **Already exists as `fertility_logs.intercourse boolean`** — it was right from schema v1 | **OD-5** |
| `vital` | Pointer dimension; the values live in `vitals` | |

`severity` (0–4) already exists and stays; the pattern engine's severity trend
depends on it.

---

## 3. Provenance on measured values — and a correction

**Corrected 2026-08-23, during implementation.** This section originally said BBT
"has nowhere to live". That was wrong, and it is correction C-1's mistake repeated:
describing a gap from the plan rather than from the code.

`fertility_logs` has carried all three supposedly-missing things since schema v1:

| Column | What it is |
|---|---|
| `bbt numeric` | Basal body temperature. `lib/fertility` already does plausibility checking and Celsius/Fahrenheit inference (`isPlausibleBbt`). |
| `cm_type text` | Cervical mucus — the discharge vocabulary. |
| `intercourse boolean` | **Exactly the conservative date-only marker OD-5 asks for.** No act types, no categories. A boolean on a date. It was already right. |

`vitals` likewise already has an open `type` set whose own column comment names
`temp_bbt`, plus `value`, `unit` and `measured_at`.

**So the gap is surfacing, not schema.** These columns are reachable only from the
TTC charting screen, which means a woman on the cycle track cannot log a temperature
or a discharge observation at all. That is a Phase C problem (the log screen,
chapter 06 §3) and a Phase D problem (the vocabulary), not a migration.

### What is actually missing: provenance

**Change — `0017_log_provenance.sql`.** A `source` column on `vitals` and
`fertility_logs`, checked to `user | imported | health_platform`, matching
`period_days`.

When Health Connect and HealthKit land (TD-07), rows will arrive that she did not
type. Three things depend on telling them apart: the **visit pack** must say which
numbers are hers and which came from a device, because a clinician will ask; **her
own trust**, because a value she never entered appearing in her record with no
explanation is alarming and correctly so; and **deletion**, because disconnecting a
platform should remove what that platform wrote without touching what she did.

Adding it now, before any integration exists, means the integration cannot ship
without it. Adding it afterwards means a backfill that has to guess.

The migration also documents the canonical `vitals.type` set in a column comment
rather than a CHECK — the closed set lives in tier 1 as `LogVocabulary` (chapter 03
§4) where both clients read it — and adds the `(profile_id, type, measured_at)` index
every Phase C chart needs to draw one line without scanning her whole history.

**BBT is deliberately not registered as a `vitals` kind.** It stays in
`fertility_logs.bbt` where `lib/fertility` reads it; duplicating it would create two
sources of truth for one measurement.

## 4. `predictions` — new, and the reason D2 is possible

**The problem.** Predictions are computed and shown, and then thrown away. Nothing
records what we predicted, how wide the window was, what it rested on, or whether it
turned out right. That makes four things impossible: explaining a prediction after
the fact, showing whether Femio has been accurate *for her*, rendering two
probability tiers consistently across surfaces, and improving the model honestly.

Flo has the same hole — it hedges but cannot explain (`docs/28` chapter 10 §6c).

**Change — `0018_predictions.sql`.**

```sql
create table public.predictions (
  id            uuid primary key default gen_random_uuid(),
  profile_id    uuid not null references public.profiles (id) on delete cascade,
  kind          text not null check (kind in
                  ('period_start','fertile_window','ovulation','cycle_length')),
  computed_at   timestamptz not null default now(),
  -- the answer
  point_date    date,
  window_start  date,
  window_end    date,
  -- the two tiers OD-15 asks the calendar to render
  likely_start  date,
  likely_end    date,
  -- why we believe it
  confidence    numeric not null check (confidence between 0 and 1),
  basis_json    jsonb not null,
  engine_version text not null,
  -- what actually happened
  observed_date date,
  observed_at   timestamptz
);
create index predictions_profile_kind_idx
  on public.predictions (profile_id, kind, computed_at desc);
```

`basis_json` is the payload D2 renders: the cycle lengths used, how many, their
spread, and which rule fired. It is written by tier 1 and read by the client — the
client never recomputes it.

`observed_date` is filled when the event happens, which over time gives us something
no competitor has: **"Femio's last six period predictions were within two days"**, as
a fact about her record rather than a marketing claim.

---

## 5. `patterns` — surface what the engine already finds

**The problem.** `lib/patterns` computes timing, co-occurrence and severity trends
with confidence, and the result exists only inside the `/patterns` route. It cannot
appear as a home module (D6), cannot enter the visit pack (D3), and is recomputed on
every view.

**Change — `0019_patterns.sql`.**

```sql
create table public.patterns (
  id           uuid primary key default gen_random_uuid(),
  profile_id   uuid not null references public.profiles (id) on delete cascade,
  kind         text not null check (kind in ('timing','co_occurrence','severity_trend')),
  subject      text not null,             -- the log key the pattern is about
  partner_key  text,                      -- co-occurrence only
  summary_key  text not null,             -- i18n key, never a rendered sentence
  evidence_json jsonb not null,           -- "in 4 of 6 cycles" — the numbers
  confidence   numeric not null check (confidence between 0 and 1),
  cycles_used  smallint not null,
  computed_at  timestamptz not null default now(),
  dismissed_at timestamptz
);
```

`summary_key` not a sentence: a stored English string cannot be shown to an Arabic
user, and this table will be read by both clients.

`dismissed_at` because a pattern she has dismissed should not keep returning to her
home screen — Flo has no equivalent and its insight cards repeat.

---

## 6. `experience_documents` — new, and it is what makes the migration safe

**The problem.** `ExperienceConfig` is resolved on demand and never stored. There is
no record of what a user was actually served, which means a support question ("why
did it show me this?") is unanswerable, and a contract version bump has nothing to
migrate.

**Change — `0020_experience_documents.sql`.**

```sql
create table public.experience_documents (
  profile_id       uuid not null references public.profiles (id) on delete cascade,
  contract_version integer not null,
  document_json    jsonb not null,
  resolved_at      timestamptz not null default now(),
  resolver_version text not null,
  primary key (profile_id, contract_version)
);
```

One row per profile per contract version, so a v2 document can be written beside a
live v1 and compared before the flag flips (chapter 03 §5).

---

## 7. `feature_flags` — the prerequisite nobody scheduled

**The problem.** TD-10. We have no remote config, no experiments, no kill switches.
For a product whose tier-1 decisions are medical, this is a **safety mechanism before
it is a growth mechanism**: a wrong red-flag threshold currently requires a deploy.
It is also the mechanism the per-screen migration depends on.

Flo's model is worth copying in shape: a feature is `feature_id` plus `dependencies`
plus an ordered **supplier chain** — remote overrides local overrides compiled
default.

**Change — `0021_feature_flags.sql`.**

```sql
create table public.feature_flags (
  key          text primary key,
  enabled      boolean not null default false,
  payload_json jsonb,
  audience_json jsonb,          -- track / persona / locale / platform targeting
  depends_on   text[] not null default '{}',
  updated_at   timestamptz not null default now(),
  updated_by   uuid references auth.users (id)
);
```

Readable by every authenticated user, writable only by staff (`staff_roles`), and
every write lands in `audit_log`. Client resolution order is **remote → cached →
compiled default**, matching the three-source pattern `lib/experience/client.ts`
already uses for the config itself.

---

## 8. Content tables — locale becomes first-class

`content`, `content_history` and `content_i` exist. What is missing is stated in
`docs/28` chapter 05 §9: all 105 authored articles are `locale: "en"`, and the CMS
does not model review state per locale.

Chapter 04 owns this. The schema consequence: **review state, reviewer identity and
review date belong per `(content_id, locale)`**, not per content item, because an
Arabic translation reviewed by nobody is not a reviewed article.

---

## 9. What does not change

`profiles` is right as it is — `age_band` preferred over `dob`, `locale` and
`rtl_pref` and `discreet_mode` already first-class. This is good data minimisation
and no competitor comes close.

`persona_state` is right — `track`, `persona_id`, `modifiers`, `emotional_context`,
`flags_json`, `clock_json`, `confidence`. Its comment already says the important
thing: *"Never controls access — only emphasis."* That is product rule 2 enforced in
the schema.

`consent_records`, `audit_log`, `partner_links`, `screener_results`,
`conditions_flagged`, `labs`, `meds_supplements`, `appointments`, `contractions`,
`fetal_movement_sessions`, `key_dates`, `notification_prefs`, `push_subscriptions`,
`subscriptions`, `staff_roles`, `ui_strings` — unchanged.

---

## 10. Migration order and gates

| # | Migration | Depends on | Gate |
|---|---|---|---|
| 0015 | `period_days` | — | Backfill verified against `cycles`; flow strip renders identically before and after |
| 0016 | `symptom_logs.dimension` | — | Every existing row classified; `lib/patterns` output unchanged on golden fixtures |
| 0017 | `vitals` kinds + `source` | — | `WeightChart` unaffected |
| 0018 | `predictions` | 0015 | Tier 1 writes on every resolve; nothing reads it yet |
| 0019 | `patterns` | 0016 | Engine output matches the on-demand computation exactly |
| 0020 | `experience_documents` | — | Written on every resolve; v1 documents byte-identical to what was served |
| 0021 | `feature_flags` | — | Staff-only writes; audit rows appear |

Every one of these carries RLS policies **and grants** — the defect fixed in
`c1123e1` was tables with policies and no grants, and it will recur unless each
migration is checked for both.

Nothing in this chapter is user-visible on its own. That is deliberate: the schema
lands first, silently, and chapters 03–06 consume it.
