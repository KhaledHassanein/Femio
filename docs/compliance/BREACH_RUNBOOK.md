# Femio — Data Breach Runbook (72-hour)

Status: **SKELETON — finalize with DPO/counsel** · Owner: DPO + Khaled · Ties to `docs/13` §11
Purpose: meet GDPR Art. 33/34 (supervisory-authority notice within **72h** of awareness; notify
affected individuals without undue delay when high risk), plus PDPL/Egypt 151 breach duties.

## 0. Roles (fill in)
- **Incident lead:** ______  · **DPO:** ______  · **Eng on-call:** ______  · **Comms/legal:** ______
- Out-of-hours contact path: ______

## 1. Detect & triage (hour 0)
- Sources: Sentry alerts, Supabase logs, abuse reports, processor notice.
- Open an incident record (time of awareness = clock start). Assign incident lead.
- Classify: is personal data involved? Is **special-category health data** involved? (raises severity)

## 2. Contain (hours 0–4)
- Revoke/rotate exposed credentials/keys (Supabase keys, service tokens); force-expire sessions.
- Isolate affected systems; disable compromised accounts/roles; snapshot logs/evidence (do not alter).
- If a processor is the source, invoke their breach process; capture their notice.

## 3. Assess risk (hours 4–24)
- Scope: which tables/fields (see `DATA_MAP.md`), how many data subjects, which jurisdictions.
- Special-category health data + minors → treat as **high risk** by default.
- Determine likelihood/severity of harm to individuals (reproductive-data sensitivity).

## 4. Notify (by hour 72)
- **Supervisory authority** (lead SA per entity — TBD counsel) within 72h if risk to rights/freedoms:
  nature of breach, categories/approx. numbers, likely consequences, measures taken.
- **Affected individuals** without undue delay if **high risk**: plain-language what happened, what
  data, what to do, contact point. Localized (EN/AR/FR/ES).
- PDPL (Saudi/UAE) + Egypt 151/2020 authorities per their timelines — **confirm with counsel**.
- Document the decision even if you decide notice is **not** required (with rationale).

## 5. Remediate & review
- Root-cause analysis; fix; add regression test / monitoring; update RLS/policies if needed.
- Post-incident review; update this runbook, DPIA, and processor register.
- Retain the incident record per retention policy.

## Templates → to draft with counsel
- SA notification · individual notification (4 locales) · internal escalation.

## Open → DPO/counsel
Identify lead supervisory authority + local authorities and exact timelines; approve notification
templates; set the on-call rotation.
