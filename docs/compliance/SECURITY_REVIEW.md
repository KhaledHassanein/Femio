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

`scripts/security/rls-audit.mjs` (`pnpm rls-audit`) proves the data-layer guarantees against the **live** project using only the publishable key. Latest run (2026-07-24): **12/12 pass**.

| # | Property | Result |
|---|----------|--------|
| 1 | Health write **rejected before** core consent; **accepted after** | ✓ |
| 2 | User B cannot **SELECT / UPDATE / DELETE** user A's rows; A's row survives | ✓ |
| 3 | Unauthenticated **anon role** reads **no** health rows; can read published content | ✓ |
| 4 | **No privilege escalation** — non-admin can't grant self a role; can't read another's roles (P1.18) | ✓ |
| 5 | **GDPR cascade** — deleting A's profile removes A's health data | ✓ |

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

## 6. Accepted dependency advisories

`pnpm audit --audit-level high` gates CI. Anything not listed here fails the build; an entry
below is a conscious acceptance, recorded in `pnpm-workspace.yaml` (`auditConfig.ignoreGhsas`)
so it shows up in a diff rather than in someone's memory.

| Advisory | Package | Why accepted | Review by |
|---|---|---|---|
| GHSA-mh99-v99m-4gvg | `brace-expansion@1.1.16` | Unbounded-expansion DoS. Reaches us only through ESLint tooling and the Serwist build, expanding glob patterns we author ourselves — never user input, never at runtime. No patch exists for the 1.x line, and forcing 5.x into a CJS caller (minimatch@3) is a four-major jump. | 2026-10-31 |

**Fixed rather than accepted, 2026-08-07.** Two advisories were published against existing
transitive dependencies and surfaced on the next push, not by a code change of ours:
**GHSA-5p4m-2wfm-xmqj** (`js-yaml` <4.3.1, high — quadratic CPU on `!!omap`, 70 paths, all
through `@payloadcms/db-postgres > payload > json-schema-to-typescript`) and
**GHSA-fxqj-rqcc-2cmp** (`postcss` ≤8.5.22, moderate — the incomplete-fix follow-up to
GHSA-6g55-p6wh-862q). Both had patches, so both were pinned in `overrides` rather than added
to the table above: `js-yaml@4: ">=4.3.1 <5"` (bounded inside its major, per the minimatch
lesson recorded in `pnpm-workspace.yaml`) and the existing `postcss` pin raised to
`">=8.5.23 <9"`. The postcss entry was raised in place instead of gaining a second row,
because one package should have one pin. `ignoreGhsas` stays **empty**, and `pnpm audit` is
clean at `--audit-level moderate` — a stricter bar than the `high` gate CI enforces.

Two moderate `next-intl` advisories (GHSA-8f24-v5vv-gm5j open redirect, GHSA-4c35-wcg5-mm9h
prototype pollution) are **not** ignored — they sit below the `high` gate and are cleared by the
v4 upgrade tracked as **P1.23.2**. The open redirect is the one that matters for us: it is
user-facing, and phishing through a health-app domain is a real risk.

## 5. Open items (launch gate)

- [ ] Independent penetration test + security reviewer sign-off (P1.23 / P0.12).
- [ ] Confirm + document Supabase at-rest encryption & key management (DPIA §4).
- [x] Add `pnpm audit` / Dependabot to CI (A06) — **done 2026-07-31** (ADR-021): `pnpm audit --audit-level high` is a CI step; fixes + `overrides` in `pnpm-workspace.yaml` took the report from 15 advisories (1 critical, 5 high) to 3; grouped weekly Dependabot PRs with majors excluded.
- [x] Security headers / CSP — **done 2026-07-31** (ADR-021, `apps/web/next.config.mjs`): CSP with an env-derived `connect-src` allow-list, `frame-ancestors 'none'`, HSTS, Referrer-Policy, Permissions-Policy, no `x-powered-by`; asserted by `e2e/security-headers.spec.ts`. **Still open:** verify Supabase project settings (JWT expiry, storage bucket visibility) — dashboard-only, Khaled.
- [x] MFA for staff/admin accounts (with P1.18 roles) — **done 2026-07-31** (ADR-023): TOTP enrolment in Settings for any account; **enforced on every staff route** by `requireStaff` (anything below `aal2` is redirected). Un-enrolled staff land on Settings, which is not staff-gated, so there is no lockout path. Recovery for a lost authenticator: `scripts/auth/reset-mfa.mjs` (service key, ADR-024).
- [~] Wire Sentry — **done 2026-08-03** (ADR-026): EU-only DSN (non-EU fails the build), health-scrubbed `beforeSend` (route patterns not URLs; no bodies, cookies, user or `extra`), tracing and session replay off. **Still open:** breach detection/alerting rules on top of it, and rehearsing the 72h notification runbook.
- [ ] Rate-limit / abuse posture for anonymous sign-in confirmed with a WAF rule if needed.
