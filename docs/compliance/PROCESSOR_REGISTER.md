# Femio — Processor Register (Art. 30 record)

Status: **living** · Owner: Khaled + DPO · Ties to `docs/13` §5
Every sub-processor that touches personal data needs a signed **DPA**, a defined role, and a
documented region + transfer mechanism. **No processor receives special-category health data
except the hosting/database processor.** Review the SDK/processor allowlist quarterly.

| Processor | Role / purpose | Data categories | Health data? | Region | DPA | Transfer mech | Status |
|---|---|---|---|---|---|---|---|
| **Supabase** | Postgres DB, Auth, Storage, Edge Functions (primary datastore) | All app data incl. health | **Yes** | EU | ☐ sign | EU hosting | project `wnthtqtcajkhskdygbgo` live; DPA TBD |
| **Vercel** | Web hosting / edge / previews | Request metadata, IP (transient) | No | choose EU region | ☐ sign | ☐ SCC if US | planned (P1.4) |
| **PostHog (EU)** | Product analytics | Pseudonymous events, **health-field-free** | **No — excluded** | EU | ☐ sign | EU | planned; event schema must be reviewed |
| **Sentry** | Error monitoring | Stack traces, user id (pseudonymous) — scrub health | No | choose EU | ☐ sign | ☐ SCC | planned (P1.4); PII scrubbing on |
| **Resend** | Transactional email | Email address, message content | No | ☐ confirm | ☐ sign | ☐ SCC if US | planned |
| **DeepL** | Translation drafts (UI/content strings) | Source strings (no user health data) | No | EU | ☐ sign | EU | planned (P1.19) |
| **Stripe / Paddle** | Billing (Phase 2) | Billing identifiers, payment (tokenized) | No | — | ☐ sign | ☐ SCC | Phase 2 |
| **Shopify** | Headless store (Phase 3) | Order/customer data | No | Markets per country | ☐ sign | ☐ | Phase 3 |

## Rules
- A processor is not enabled in production until its **DPA is signed** and this row is completed.
- Any processor that could receive health data is **blocked** unless explicitly justified in a
  DPIA update and approved by the DPO (only Supabase qualifies today).
- IP/device data to analytics stays pseudonymous and health-field-free.

## Open → DPO/counsel
Sign DPAs; confirm each processor's region + transfer mechanism (SCCs/adequacy); finalize the
PostHog event schema review; confirm Sentry PII scrubbing config.
