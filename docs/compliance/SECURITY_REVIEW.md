# Femio — Security Review (P1.23)

Status: **engineering pass, 2026-07-24** (Claude Code) · Owner: Khaled + (future) security reviewer
Scope: the live web app (`apps/web`, Next.js 15 PWA) + Supabase data layer (Postgres + RLS + auth, EU) + Payload CMS (`apps/cms`). This is the internal engineering security review; an independent penetration test + counsel/DPO sign-off remain a launch gate (P0.12).

Ties to: `docs/13_LEGAL_COMPLIANCE.md`, `docs/14_SYSTEM_ARCHITECTURE.md`, `DPIA.md`, `supabase/migrations/0001–0003`.

---

## 1. Architecture & trust boundaries

Femio has an unusually small server-side attack surface: the browser talks **directly** to Supabase using the **publishable (client-safe) key**, and every health table is protected by **owner-only Row-Level Security** plus a **consent gate** enforced in the database. There is no bespoke API tier holding secrets or re-implementing authorization that could drift from the RLS rules.

- **Auth:** Supabase Auth (email + native anonymous). Anonymous users are real `authenticated` JWTs with a genuine `auth.uid()` (ADR-010); they get the *same* owner-only RLS as registered users.
- **Authorization:** RLS on every table. Health tables = `profile_id = auth.uid()`; inserts additionally require an active granted `core` consent (`has_core_consent`, 0002). Back-office content is gated by `is_staff(uid, roles[])`.
- **No service key in the client or CI.** DDL/admin is applied by Khaled (ADR-011); the only privileged server action is the `delete_account()` security-definer RPC (0003).
- **Secrets:** `NEXT_PUBLIC_*` are build-time public by design (URL + publishable key only). No secret key is `NEXT_PUBLIC_`. `env.ts` validates every variable and fails the build on a bad value (incl. the crisis directory host).

## 2. Automated access-control audit

`scripts/security/rls-audit.mjs` (`pnpm rls-audit`) proves the data-layer guarantees against the **live** project using only the publishable key. Latest run (2026-07-24): **10/10 pass**.

| # | Property | Result |
|---|----------|--------|
| 1 | Health write **rejected before** core consent; **accepted after** | ✓ |
| 2 | User B cannot **SELECT / UPDATE / DELETE** user A's rows; A's row survives | ✓ |
| 3 | Unauthenticated **anon role** reads **no** health rows; can read published content | ✓ |
| 4 | **GDPR cascade** — deleting A's profile removes A's health data | ✓ |

This is a manual pre-release gate (it creates throwaway anonymous users against the real DB), not a CI step. Re-run before each release and after any migration touching RLS, consent, or the table list.

## 3. OWASP Top-10 (2021) posture

| Risk | Posture | Residual / follow-up |
|------|---------|----------------------|
| **A01 Broken Access Control** | Owner-only RLS on all health tables + consent-gated inserts, proven by §2. Anonymous == authenticated-owner model (one uniform path to audit). Staff/content gated by `is_staff`. | Partner-link RPCs (security-definer) need review when built. Re-run §2 after any RLS change. |
| **A02 Cryptographic Failures** | TLS in transit; Supabase encryption at rest (EU region). Health data is special-category; no health data in analytics/ad SDKs. | **Confirm + document** Supabase at-rest encryption + key management (DPIA §4 open item). |
| **A03 Injection** | No hand-built SQL from user input in the app; Supabase client parameterizes. RLS DO-block uses `format(%I)` identifier quoting over a fixed table list. React escapes output by default. | No `dangerouslySetInnerHTML` on user data (verify remains true as content lands, P1.9). |
| **A04 Insecure Design** | Privacy/medical-device guardrails encoded at the data layer (consent gate, RLS) not just UI; claims-guard + crisis-guard in CI; uncertainty-honest by design. | Threat-model partner/clinician sharing before it ships. |
| **A05 Security Misconfiguration** | `env.ts` fail-closed validation; RLS enabled per table (not default-open); CMS review gate enforced in a `beforeChange` hook (P1.6). | Security headers/CSP review (§4). Verify Supabase project settings (JWT expiry, no public buckets). |
| **A06 Vulnerable Components** | pnpm lockfile pinned; Dependabot/`pnpm audit` recommended. | **Add `pnpm audit` (or Dependabot) to CI.** |
| **A07 Identification & Auth Failures** | Supabase Auth (bcrypt/Argon, rate-limited endpoints, secure session cookies via `@supabase/ssr`). Anonymous upgrade keeps the same uid, no credential re-use. | MFA for staff/admin (P1.18). Email-link callback hardening (P1.12.1). |
| **A08 Software & Data Integrity** | CI runs claims-lint, crisis-lint, lint, typecheck, unit, build, DB-free e2e + axe on every PR. Migrations are versioned, reviewed SQL. | Sign/verify release artifacts at launch. |
| **A09 Logging & Monitoring Failures** | Supabase auth/DB logs; Sentry hook available (DSN optional). **No analytics on the crisis interface** by design. | Wire Sentry DSN; define security-event alerting + the 72h breach runbook (DPIA §4). |
| **A10 SSRF** | No server-side fetch of user-supplied URLs. The one outbound link (crisis directory) is a static, build-validated, canonical host opened client-side with `referrerPolicy=no-referrer` — never fetched/proxied server-side. | Keep any future server fetch on an allowlist. |

## 4. Rate limiting & abuse

- **Auth endpoints** (sign-in, sign-up, anonymous, magic-link) are rate-limited by **Supabase Auth** (per-IP/per-project). Confirm the project's limits are set appropriately for anonymous sign-in abuse (throwaway-account creation) before launch.
- **Data endpoints** are Supabase PostgREST behind RLS; add per-role/per-IP limits at the edge if abuse appears. Consider a Cloudflare/Vercel WAF + rate rule in front of the auth path.
- **CAPTCHA / attestation** on anonymous sign-in is a candidate mitigation if throwaway-account creation becomes a problem (weigh against the privacy-first, no-friction goal).
- **App-level:** no custom API routes hold secrets or bypass RLS today, so there is no hand-rolled endpoint to rate-limit yet. Re-evaluate when server actions/RPCs are added.

## 5. Open items (launch gate)

- [ ] Independent penetration test + security reviewer sign-off (P1.23 / P0.12).
- [ ] Confirm + document Supabase at-rest encryption & key management (DPIA §4).
- [ ] Add `pnpm audit` / Dependabot to CI (A06).
- [ ] Security headers / CSP review; verify Supabase project settings (JWT expiry, storage bucket visibility).
- [ ] MFA for staff/admin accounts (with P1.18 roles).
- [ ] Wire Sentry + define breach detection/alerting and the 72h runbook.
- [ ] Rate-limit / abuse posture for anonymous sign-in confirmed with a WAF rule if needed.
