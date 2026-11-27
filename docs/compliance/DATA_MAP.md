# Femio — Data Map (per-field processing record)

Status: **living** · Owner: Khaled + DPO · Source schema: `supabase/migrations/` (schema v1, P1.3)
Ties to `docs/archive/2026-11/13_LEGAL_COMPLIANCE.md` §8. **Rule: every new field is added here in the
same PR that introduces it** (CI checklist item). Labels must match Play Data-Safety /
Apple nutrition labels at store submission.

Legend — **Special?** = GDPR Art. 9 special-category health data. **Basis**: explicit
consent (health), contract (account/billing), legitimate interest (security, health-field-free).
**Consent group**: core / insights / research / — (n/a). Region: EU (Supabase). Retention:
until account deletion unless stated; deletion cascades (FK `on delete cascade`).

## Identity & account
| Table.field | Purpose | Special? | Basis | Consent grp | Notes |
|---|---|---|---|---|---|
| profiles.id | User identity (= auth.uid) | No | contract | — | Pseudonymous; not PII by itself |
| profiles.account_type | Anon vs registered | No | contract | — | |
| profiles.device_key | Legacy anon linking (unused; native anon auth) | No | contract | — | See ADR-010 |
| profiles.dob | Age gating | No* | consent | core | *Minimize: prefer age_band; DOB optional |
| profiles.age_band | Age gating, teen-mode | No | consent | core | |
| profiles.locale / rtl_pref / theme / discreet_mode | UX preferences | No | contract | — | |
| consent_records.* | Consent ledger (purpose, granted, version, ts) | No | legal obligation | — | Proof of consent; append/revoke-only |

## Constant EMR core (special-category health)
| Table.field | Purpose | Special? | Basis | Consent grp | Notes |
|---|---|---|---|---|---|
| cycles.* (period_start/end, flow, cycle_length) | Cycle tracking + predictions | **Yes** | explicit consent | core | |
| symptom_logs.* (type, severity, value_json, note) | Symptom/mood tracking | **Yes** | explicit consent | core | note is free-text — may contain sensitive detail |
| meds_supplements.* | Medication/supplement log | **Yes** | explicit consent | core | |
| conditions_flagged.* | Self/screener-flagged conditions | **Yes** | explicit consent | core | non_diagnostic always true |
| screener_results.* (tool, score, subscores) | Screening results (EPDS/PHQ9/…) | **Yes** | explicit consent | core | Crisis routing in app logic; non_diagnostic |
| content_history.* | Education viewed | No | consent | insights | Behavioral; used for personalization |

## Persona layers (special-category health)
| Table.field | Purpose | Special? | Basis | Consent grp | Notes |
|---|---|---|---|---|---|
| labs.* (test_type, value, unit) | User-entered labs | **Yes** | explicit consent | core | Entry-only, never interpreted |
| vitals.* (BP/glucose/weight/BBT) | Vitals tracking | **Yes** | explicit consent | core | |
| fertility_logs.* (bbt, opk, cm, intercourse, hpt, dpo) | TTC tracking | **Yes** | explicit consent | core | intercourse/hpt = never-shareable class |
| pregnancy.* (edd, ga, modifiers, status) | Pregnancy tracking | **Yes** | explicit consent | core | |
| appointments.* | Visit prep/log | **Yes** | explicit consent | core | clinician name = third-party personal data |
| key_dates.* | Meaningful dates incl. loss | **Yes** | explicit consent | core | Emotional-safety display control |
| partner_links.* (scope_json, consent_ts) | Scoped partner sharing | **Yes** | explicit consent | core | Revocable; raw rows never shared |

## Adaptation state
| Table.field | Purpose | Special? | Basis | Consent grp | Notes |
|---|---|---|---|---|---|
| persona_state.* (track, persona_id, modifiers, flags, clock) | Personalization state | **Yes** | explicit consent | core | Derived; controls emphasis, never access |
| adaptation_events.* | Transition audit | **Yes** | explicit consent | core | Append-only |

## Content, i18n, commerce, roles (non-health)
| Table.field | Purpose | Special? | Basis | Consent grp | Notes |
|---|---|---|---|---|---|
| content / content_i18n / ui_strings | Public education + UI copy | No | — | — | Public read; not personal data |
| subscriptions.* | Billing tier/status | No | contract | — | Written by billing processor |
| staff_roles.* | Back-office RBAC | No | contract (employment) | — | |
| audit_log.* | Admin/access trail | No | legal obligation / LI | — | Append-only |

## Processors touching this data
See `PROCESSOR_REGISTER.md`. **No health data to PostHog or any ad/analytics SDK** —
product events are pseudonymous and health-field-free (doc 13 §6, §9).

That prohibition is now **enforced in code**, not just stated: the event catalog in
`apps/web/src/lib/analytics/events.ts` is a closed enum schema with no free-form string,
number or date, a runtime guard drops any payload that deviates, and `pnpm analytics-lint`
fails CI if the schema drifts. The full catalog and the deliberate exclusions (article
slugs, calculator identity, life-stage mode, condition/persona tags, age bands, the crisis
surface) are documented in `docs/archive/2026-11/19_ANALYTICS_EVENT_SCHEMA.md`. Analytics consent is a
distinct opt-in purpose (`consent_records.purpose = 'analytics'`, migration 0005) — **not**
`insights`, which is first-party pattern processing of the user's own data.

## Open items → DPO/counsel
- Confirm retention windows per field (defaults: until deletion; screeners/logs configurable).
- Confirm lawful-basis wording for `content_history` (insights vs core).
- Free-text fields (`symptom_logs.note`, `appointments.*`) — flag for DSAR export scope.
