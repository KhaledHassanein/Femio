# Femio — Data Protection Impact Assessment (skeleton)

Status: **SKELETON for DPO to run formally** · Owner: DPO + Khaled · Ties to `docs/13` §5
A DPIA is mandatory here: systematic, large-scale processing of special-category health
data, including minors, with profiling (GDPR Art. 35). Update **before each new data
category** (CI checklist item). This skeleton is engineering input, not the formal DPIA.

## 1. Description of processing
- **What:** cycle/symptom/mood/vitals/labs/fertility/pregnancy/screener data + derived
  persona state; education delivery; uncertainty-honest predictions.
- **Whom:** women/girls across life stages, incl. minors (teen mode).
- **How:** web PWA → Supabase (Postgres + RLS, EU); server-side resolver/predictions;
  pseudonymous product analytics (health-field-free).
- **Scale:** consumer scale, multi-jurisdiction (EU, Gulf PDPL, Egypt 151/2020).
- Data map: `DATA_MAP.md`. Processors: `PROCESSOR_REGISTER.md`.

## 2. Necessity & proportionality
- Data minimization: field→feature mapping (data map); prefer `age_band` over DOB; collect
  nothing no active feature needs.
- Purpose limitation + **granular explicit consent** (core / insights / research), captured
  **before the first health field is stored** and enforced at the DB (consent gate, 0002).
- Storage limits + export/delete (cascade). Anonymous mode (native anon auth) for identity-free use.

## 3. Risks to data subjects
- Sensitive health inference; re-identification of pseudonymous data; unauthorized access/breach;
  secondary use / ad-targeting; minors' exposure; cross-border exposure; **reproductive-data risk**
  (regional criminalization / disclosure concerns).

## 4. Mitigations (state — verify at review)
- [x] No health data to analytics/ad SDKs (health-field-free event schema) — enforced by policy + review gate.
- [x] Owner-only RLS on every health table; consent-gated inserts (0002).
- [x] Anonymous mode; export/delete pipelines planned (P1.16); EU region.
- [ ] Encryption at rest/in transit — confirm Supabase config + document.
- [ ] Teen safeguards (no ads/DMs/UGC; parental consent flow) — P1.12 / counsel.
- [ ] Breach runbook operational (`BREACH_RUNBOOK.md`) — 72h.
- [ ] Retention windows set per field.

## 5. Residual risk & sign-off
- Residual risk assessment: **TBD by DPO.**
- Sign-off: DPO ______  Khaled ______  Date ______  Review cadence: ______

## 6. Open → DPO/counsel
Run the formal DPIA; decide reproductive-data risk posture per jurisdiction; confirm minors'
handling and DPIA consultation triggers.
