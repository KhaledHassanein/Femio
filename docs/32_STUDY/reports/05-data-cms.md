# 05 — Database, edge functions and CMS (Supabase + Payload)

Scope: `supabase/**`, `apps/cms/**`, `scripts/content/snapshot-cms.mjs`, `scripts/i18n/seed-ui-strings.mjs`, `scripts/security/rls-audit.mjs`, `scripts/db-artifacts-probe.mjs`, `docs/runbooks/{supabase_apply_migrations,cms_setup}.md`, `docs/runbooks/sql/*`, `docs/14` (ERD), `docs/18` (RBAC). Cross-checked against `apps/web/src`, `apps/mobile` and `docs/STATE.md` to find who really uses each thing.

Legend: **Checked** = I read the file or grepped the code. **From the docs** = a doc claims it. **Hypothesis** = my reading. Anything about the *live* database is **not verified**: I did not connect to it (Supabase is restricted/402 per `docs/STATE.md`), so no row counts below are live counts.

## 1. Purpose in one paragraph

This area is the **server side of the old web product**. Supabase (Postgres + auth + 3 edge functions) stored every signed-in woman's health record behind row-level security (RLS: the database itself refuses to show a row to anyone but its owner). Payload CMS (a separate Next.js app, `apps/cms`) stored the editorial content (articles, condition hubs, bios) in a `payload` schema inside the *same* Supabase Postgres, with a medical-review gate before anything could be published. In October 2026 the direction changed (ADR-070, D7/D8): the product becomes a private Android app with no accounts, and the website becomes static. Content was already moved out of the database at runtime (D3, `snapshot-cms.mjs` writes JSON into `apps/web/src/content/snapshot/`). What remains of this area is therefore mostly **a closed web tracker's backend plus an editor tool whose only job is to produce a snapshot**. **Checked:** the Flutter app has no Supabase dependency (`apps/mobile/pubspec.yaml` lists only `flutter`, `flutter_localizations`, `intl`, `path_provider`; `lib/data/store.dart` says "nothing here makes a network request").

## 2. Inventory table

Folder-level rows where files are many; every Supabase/CMS source file is listed.

| path | lines | purpose | status |
|---|---|---|---|
| `supabase/config.toml` | 4 | Only `project_id = "wnthtqtcajkhskdygbgo"`; no local-stack config, auth settings live in the dashboard | live (project link only) |
| `supabase/.gitignore` | 3 | Ignores CLI temp dirs and `.env` | live |
| `supabase/migrations/0001_schema_v1.sql` | 369 | 23 tables (identity, consent, sketch content, EMR core, persona state, roles, audit), all RLS-on | app-only |
| `supabase/migrations/0002_rls_policies.sql` | 221 | Helpers `has_core_consent`, `is_staff`, `handle_new_user` trigger; owner-only policies; staff policies | app-only |
| `supabase/migrations/0003_delete_account.sql` | 20 | `delete_account()` RPC: deletes caller from `auth.users`, cascade wipes record | app-only |
| `supabase/migrations/0004_grant_service_role.sql` | 20 | Grants `service_role` full access incl. default privileges | app-only |
| `supabase/migrations/0005_analytics_consent_purpose.sql` | 28 | Adds `analytics` to consent purpose CHECK | app-only |
| `supabase/migrations/0006_insights_aggregates.sql` | 281 | k-anonymous (k=10) staff-only counts: `insights_overview/by_dimension/retention/k` | app-only |
| `supabase/migrations/0007_fetal_movement_sessions.sql` | 50 | Table + 4 owner policies (consent-gated insert) | app-only |
| `supabase/migrations/0008_contractions.sql` | 55 | Table + 4 owner policies | app-only |
| `supabase/migrations/0009_pregnancy_ended_on.sql` | 44 | `pregnancy.ended_on date` | app-only |
| `supabase/migrations/0010_stated_cycle_baseline.sql` | 44 | `profiles.stated_cycle_length/_period_length` | app-only |
| `supabase/migrations/0011_partner_sharing.sql` | 335 | Partner invite columns, scope CHECK, `redeem_partner_invite`, `partner_shared_rows` (service-role only) | app-only |
| `supabase/migrations/0012_partner_recipient_label.sql` | 40 | `partner_links.recipient_label` (<=60 chars) | app-only |
| `supabase/migrations/0013_notifications.sql` | 100 | `notification_prefs`, `push_subscriptions` (web push) | app-only |
| `supabase/migrations/0014_grant_new_tables.sql` | 60 | Re-grants table/function privileges and default privileges to anon/authenticated | app-only |
| `supabase/migrations/0015_period_days.sql` | 121 | `period_days` table + backfill from `cycles` | app-only |
| `supabase/migrations/0016_log_dimensions.sql` | 102 | `symptom_logs.dimension` + backfill of mood rows | app-only |
| `supabase/migrations/0017_log_provenance.sql` | 97 | `source` column on `vitals`, `fertility_logs` | app-only |
| `supabase/migrations/0018_predictions.sql` | 122 | `predictions` table (select/delete only for owner; insert revoked) | dead (no writer) |
| `supabase/migrations/0019_patterns.sql` | 121 | `patterns` table; insert revoked, only `dismissed_at` updatable | app-only |
| `supabase/migrations/0020_experience_documents.sql` | 73 | `experience_documents` cache table; insert revoked | dead (no writer) |
| `supabase/migrations/0021_feature_flags.sql` | 161 | `feature_flags` + audit trigger writing `audit_log` | app-only |
| `supabase/migrations/0022_content_search.sql` | 268 | `femio_ts_config`, `femio_search_tsquery`, `search_content` over the `payload` schema | dead (search is now a static index) |
| `supabase/migrations/0023_search_locale_fallback.sql` | 192 | `search_content_in` + English-fallback wrapper | dead |
| `supabase/migrations/0024_drop_unused_content_tables.sql` | 33 | Drops `content`, `content_i18n`, `content_history` (refuses if non-empty) | live (applied 2026-10-07 per STATE) |
| `supabase/migrations/0025_advisor_hardening.sql` | 74 | Pins `search_path`, revokes/grants function execute, adds FK indexes | app-only |
| `supabase/functions/experience/index.ts` | 172 | Resolves persona + returns `ExperienceConfig` on the caller's JWT | app-only |
| `supabase/functions/partner-view/index.ts` | 190 | What a partner sees, derived server-side; uses service key for one RPC | app-only |
| `supabase/functions/patterns/index.ts` | 132 | Computes pattern findings, upserts into `patterns` via service key | app-only |
| `apps/cms/package.json` | 40 | Payload 3.90, Next 16, db-postgres adapter, lexical editor | live (editor tool) |
| `apps/cms/src/payload.config.ts` | 119 | Collections, 4 locales (en default, ar RTL, fr, es; `fallback: true`), schema `payload`, pool max 3, push only on local DB | live |
| `apps/cms/src/access/{content,roles}.ts` | 9 + 19 | Role helpers (`admin/editor/medical_reviewer/translator`), `readPublishedOrStaff` | live |
| `apps/cms/src/collections/` (9 files) | 11 each, People 72, Users 35, factory 49, Media 23 | Collection definitions (see §3) | live |
| `apps/cms/src/fields/{editorial,publishing}.ts` | 63 + 84 | Review workflow fields; byline/SEO fields | live |
| `apps/cms/src/hooks/review-gate.ts` | 30 | `beforeChange`: only reviewer/admin may approve/publish; publish needs `approved` | live |
| `apps/cms/src/migrations/` (3 `.ts` + 3 `.json` + `index.ts`) | 22 / 185 / 11 + ~7.1k–8.1k each json | Baseline (intentionally empty), publishing fields, Payload 3.90 column | live |
| `apps/cms/src/payload-types.ts` | 919 | Generated types | live (generated) |
| `apps/cms/src/app/(payload)/**` (7 files) | ~120 total | Payload admin/API route shells, importMap | live |
| `apps/cms/{next.config.mjs,tsconfig.json,vercel.json,.env.example}` | 6 / 44 / 7 / 8 | Build config; `vercel.json` pins region `dub1` and an ignore-build script | live |
| `apps/cms/scripts/import-articles.mjs` | 301 | Markdown -> Payload importer (English, draft only, validates) | live (one-off tool) |
| `apps/cms/scripts/import-translations.mjs` | 198 | Fills a locale on an existing document; refuses to create parents | live (one-off tool, no translations exist yet) |
| `apps/cms/scripts/publish-reviewed.mjs` | 141 | Approves/publishes imported drafts through Local API (runs the review gate) | live (one-off) |
| `apps/cms/scripts/wire-bylines.mjs` | 192 | Sets author + reviewer relationships; never overwrites | live (one-off) |
| `apps/cms/scripts/upsert-people.mjs` | 187 | Creates/updates bios from `docs/content/people/*.json` | live (one-off) |
| `apps/cms/scripts/unpublish-person.mjs` | 55 | Takes a bio off the public site | live (one-off) |
| `apps/cms/scripts/set-user-roles.mjs` | 102 | Bootstrap an admin / reset a CMS password | live (one-off) |
| `apps/cms/scripts/migrate-apply.mjs` | 68 | Runs `payload migrate` answering the dev-mode prompt | live |
| `apps/cms/scripts/migrate-on-deploy.mjs` | 60 | Migrates only when `VERCEL_ENV=production` | duplicate of intent with migrate-apply; unknown whether wired into build |
| `apps/cms/scripts/drop-dev-migration-row.mjs` | 119 | Removes the legacy `batch=-1` row so `payload migrate` is non-interactive | live (one-off, likely already run) |
| `scripts/content/snapshot-cms.mjs` | 95 | Fetches published docs from `https://femio-cms.vercel.app/api/*` per locale, writes `apps/web/src/content/snapshot/*.json` | live (the bridge that makes Payload retirable) |
| `scripts/i18n/seed-ui-strings.mjs` | 80 | Upserts every key of `apps/web/messages/*.json` into `ui_strings` (EN = `human_reviewed`, others `machine`), service key | dead after retirement |
| `scripts/security/rls-audit.mjs` | 200 | Live RLS proof with two throwaway anonymous users; 5 sections | app-only (manual gate) |
| `scripts/db-artifacts-probe.mjs` | 106 | Checks tables/columns from 0015-0021 exist, 2 anon behaviours | app-only |
| `docs/runbooks/supabase_apply_migrations.md` | 62 | How to apply 0001/0002 and enable anonymous sign-in; stale ("23 tables", only 0001-0003 mentioned) | duplicate / stale |
| `docs/runbooks/cms_setup.md` | 89 | Payload setup; Step 6 still tells you `PAYLOAD_DB_PUSH=true` is set though `payload.config.ts` now keys push off the DB host | stale |
| `docs/runbooks/sql/2026-10-07_apply_all.sql` | 250 | One-transaction paste of 0024 + 0025 + the Payload 3.90 column + history rows | dead (already applied per STATE) |
| `apps/web/src/content/snapshot/*.json` (6 files, 1.7 MB) | - | The exported content (outside my scope but the heart of retirement) | live |

## 3. Key modules and responsibilities

**Database tables (public schema, 29 after 0024).** Inputs come from the web tracker's browser client (`@supabase/supabase-js` with the publishable key); RLS decides every row.

1. **Identity and consent** — `profiles` (one row per auth user, auto-created by trigger `on_auth_user_created`), `consent_records` (per-purpose log; a granted `core` row gates all health inserts via `has_core_consent`). Written by onboarding and consent screens.
2. **Health record** — `cycles`, `period_days`, `symptom_logs` (+`dimension`), `vitals`, `fertility_logs`, `meds_supplements`, `conditions_flagged`, `screener_results`, `labs`, `pregnancy`, `fetal_movement_sessions`, `contractions`, `appointments`, `key_dates`. Owner-only select/update/delete; insert needs consent. Read by dashboard, calendar, summary, export.
3. **Adaptation** — `persona_state` (the resolved track, stated intent flags), `adaptation_events` (append-only log). Read/written by `lib/persona/state.ts` and onboarding.
4. **Derived, server-written** — `patterns` (written only by the `patterns` function), `predictions` and `experience_documents` (designed to be written by tier 1; **nothing writes them**, Checked by grep of `supabase/functions` and `apps/web/src`).
5. **Sharing** — `partner_links` (+ RPC `redeem_partner_invite`, function `partner_shared_rows`).
6. **Notifications** — `notification_prefs`, `push_subscriptions` (web push endpoints).
7. **Ops** — `staff_roles`, `audit_log`, `feature_flags`, `subscriptions` (stub; only the export screen mentions it), `ui_strings`.

**Edge functions (Deno).** All three import tier-1 TypeScript straight from `apps/web/src/lib/...` by relative path, so the function bundle cannot be deployed without the web source tree (kept alias-free by `pnpm tier1-portability-lint`).
- `experience` — POST with the caller's JWT; runs six reads (profile, cycles, conditions, pregnancy, symptoms, persona_state), builds an `ExperienceConfig`, no writes, no service key. Called by `lib/experience/client.ts:127` (falls back to computing locally in the browser).
- `partner-view` — verifies the recipient's JWT, then calls `partner_shared_rows(recipient)` with the service key, derives the window/phase, and emits only keys the owner granted (absent, not empty). Called by `lib/partner/actions.ts:254`.
- `patterns` — reads her cycles and up to 2000 log rows on her JWT, computes with `lib/patterns`, upserts findings using the service key scoped to the verified user. Called by `lib/patterns/recompute.ts:56`.

**Payload collections** (schema `payload`, localized fields marked L):
- `users` (auth; `roles` hasMany select; admin-only role edits).
- `media` (upload; alt text L+required; allowlist png/jpeg/webp/avif/svg).
- `articles` — title L, slug, excerpt L, body (rich text) L, publishing fields (authors -> people, medicalReviewerProfile -> people, firstPublishedAt, `seo` group with seoTitle/metaDescription/socialTitle/socialDescription L, canonicalOverride, noIndex, socialImage), editorial fields (reviewStatus, medicalReviewer -> users, lastReviewed, nextReviewDue, readingLevelOk, disclaimerType, sources[title,url,tier]), drafts on.
- `conditions` — same shape with `summary` instead of `excerpt`.
- `faqs` (question L, answer L), `glossary` (term L, definition L), `tips` (title L, body L) — editorial fields, no publishing group.
- `people` — name L, slug, roles[author, medical_reviewer], credentials L, jobTitle L, affiliation L, bio L, photo, sameAs[label,url]; drafts on; no review gate.
- Localization: `en` default, `ar` (rtl), `fr`, `es`, `fallback: true`. **Checked:** snapshot has `ar/fr/es = 0` for every collection, so only English content exists in the CMS.
- Hook `enforceReviewGate`: reviewer/admin only for `approved` and for `_status: published`; publish needs `reviewStatus === approved`.

**Scripts.** `snapshot-cms.mjs` (reads public REST, keeps only published docs, trims to a whitelist of fields, byline-only person objects, `fallback-locale=none` so absent translations are not faked). `seed-ui-strings.mjs` (see above). `rls-audit.mjs` and `db-artifacts-probe.mjs` are live-DB checks run by hand.

## 4. Data flow

**Content (authoring -> reader).** Markdown drafts in `docs/content/articles/*.md` (107 files: 106 English + 1 Arabic) -> `import-articles.mjs` (to Payload as drafts) -> medical reviewer approves/publishes in the CMS (`publish-reviewed.mjs`, `wire-bylines.mjs`, `upsert-people.mjs`) -> `node scripts/content/snapshot-cms.mjs` pulls `https://femio-cms.vercel.app/api/{articles,conditions,faqs,glossary,people}` -> JSON in `apps/web/src/content/snapshot/` (committed) -> `apps/web/src/lib/cms/client.ts` imports the JSON; pages are prerendered; search is a static JSON route (`app/api/search-index/[locale]/route.ts`, `force-static`). **Checked:** a page view makes no database call.

**UI strings.** `apps/web/messages/{en,ar,fr,es}.json` (1619 keys each, 536 KB total) are the base. `seed-ui-strings.mjs` copied them into `ui_strings`. At request time `i18n/request.ts` -> `lib/i18n/ui-strings-loader.ts` reads `ui_strings` where `status = 'human_reviewed'` for non-English locales with the anon key, cached one hour (`revalidate: 3600`, tag `UI_STRINGS_TAG`). English never overlays (ADR-064). The admin page `app/[locale]/(app)/admin/translations` (staff only) writes approvals back. **This is the one remaining Supabase read on the public site.** (STATE.md says the same: "serves `ui_strings` hourly".) Whether any ar/fr/es row is actually `human_reviewed` is **not verified**; if none are, the overlay changes nothing.

**Health record (closed web tracker).** Browser -> `@supabase/supabase-js` -> Postgres under RLS; three edge functions; Supabase Auth (anonymous sign-in + email); session cookie refresh in `middleware.ts` only when `NEXT_PUBLIC_WEB_APP_ENABLED=1` (unset in production, set by CI). External services touched from this area: Supabase (Postgres, Auth, Edge Functions, PostgREST) EU/Ireland; Vercel (two projects: web, and `femio-cms` with region `dub1`); Payload's own admin. No Sentry/PostHog calls live in this area (analytics is elsewhere; consent purpose `analytics` is only a CHECK value).

**Mobile.** Local JSON file in the app sandbox. No flow into this area.

## 5. Dependencies

- Imports into the edge functions from the web tree: `lib/persona/{resolver,signals-from-rows}.ts`, `lib/experience/{build,phase,layers,registry/index}.ts`, `lib/cycle/{predict,phases,symptom-patterns}.ts`, `lib/pregnancy/index.ts`, `lib/calculators/dates.ts`, `lib/patterns/{co-occurrence,severity,rows}.ts`. Deleting or reshaping those breaks function deploys.
- What imports Supabase from the web app (Checked by grep): ~45 `.from()` call sites across `lib/partner`, `lib/persona`, `lib/consent`, `lib/notifications`, `lib/onboarding`, `lib/analytics/consent.ts`, `lib/auth/roles.ts`, `lib/i18n`, `lib/insights`, `lib/experience/v2/use-surface-version.ts`, and the tracker components (dashboard, calendar, track, summary, pregnancy, fertility, medications, appointments, screeners, patterns). RPCs: `delete_account` (delete-button), `insights_*` (admin insights), `redeem_partner_invite` (partner actions).
- Web environment: `lib/env.ts:17-18` makes `NEXT_PUBLIC_SUPABASE_URL` and `_PUBLISHABLE_KEY` **required** (not optional), and `NEXT_PUBLIC_CMS_URL` optional (`env.ts:28`, `next.config.mjs:61` adds it to the CSP). Both must change on retirement.
- CI: `.github/workflows/ci.yml:34` passes `E2E_SUPABASE_URL` (placeholder fallback); `@live` e2e hit production Supabase.
- `docs/archive/2026-11/18_RBAC_MODEL.md` and `docs/14` §3-5 describe the model; `docs/14` still says anonymous users use `device_key` and shows `content`/`content_i18n`/`content_history`, all contradicted by 0002's header (native anonymous sign-in, ADR-010) and 0024.

## 6. Strings and i18n

- Database: `ui_strings (key, locale, value, status machine|human_reviewed, icu)` is the only user-facing-string table. Files: `apps/web/messages/*.json` hold the same text in the repo, which is the real source (English always; overlay only for others).
- Edge functions return machine codes (`"unauthorized"`, `"unavailable"`, `"read-failed"`, `"write-failed"`); no user-facing prose, which is correct (`partner-view/index.ts:77+`, `patterns/index.ts:50+`). `patterns.summary_key` stores an i18n key, never a sentence (0019).
- CMS admin UI labels are hard-coded English in config (e.g. `editorial.ts:7-14` "Draft / In medical review / Approved", `access` errors in `hooks/review-gate.ts:14,20,25` "Only a medical reviewer can ..."). Acceptable: staff-only admin, but it is a literal violation of the zero-hard-coded-strings rule. Locale labels in `payload.config.ts:44-47` ("العربية", "Français", "Español") are native names, fine.
- Content localisation: Payload localisation is complete in schema (4 locales, fallback to English) but has **no translated content** (snapshot ar/fr/es = 0). `docs/content/articles` has one `.ar.md`.

## 7. Tests

- **Checked:** `apps/cms` has no test files. There is no automated test for the review gate, access rules, importers, or migrations.
- No test runs the SQL migrations (no local Supabase stack; `config.toml` is project-link only). RLS is proven only by `scripts/security/rls-audit.mjs` and `scripts/db-artifacts-probe.mjs`, which are **manual, against the live project**, and will fail while Supabase is restricted/402.
- Edge functions have no unit tests of their own; their logic is the tier-1 modules, tested under `apps/web/src/lib/**` (e.g. `patterns/rows.test.ts`, `persona/signals-from-rows` tests) and bound by `tier1-portability-lint`.
- Snapshot consumers are covered (`lib/cms/select.test.ts`, `faq.test.ts`, `lexical.test.ts`); the snapshot script itself is untested.
- Untested: column-level grant on `patterns` (probe comment says it lives in a manual test plan), `partner_shared_rows` scope logic, the k-anonymity SQL (the TS twin `lib/insights/k-anon.ts` has a test).

## 8. Smells, risks, dead code

1. **Approval state exists only in the CMS and the snapshot, not in the repo markdown.** `docs/content/articles/*.md`: all 107 say `status: "draft"`, `medically_reviewed_by: "PENDING"`, `last_reviewed: null`. The snapshot has 100 articles with `lastReviewed` on all 100, a named reviewer on 25, `authors` on 26 (plus 5 conditions, all with reviewer). Retiring Payload without moving this into the repo (frontmatter or the snapshot JSON as the record) would silently lose the clinical sign-off.
2. **Snapshot is lossy.** `snapshot-cms.mjs:KEEP` drops `reviewStatus`, `nextReviewDue`, `readingLevelOk`, the workflow `medicalReviewer` user, media, version history and `tips` entirely. Fine for the site, not fine as an archive.
3. **`predictions` and `experience_documents` have no writer** (no function inserts; `INSERT` revoked from clients). `calendar-screen.tsx:56-58` reads `predictions` with `kind = "period"`, but the CHECK allows only `period_start | fertile_window | ovulation | cycle_length`, so that read is always empty. Dead tables, dead read.
4. **`search_content*` (0022/0023) read `payload.*` tables with `security definer`.** No caller exists (search is a static index since P2.2; `library.ts` only mentions it in a comment). They would break the moment the `payload` schema is dropped, and they are dead anyway.
5. **`feature_flags_write_staff`** (`0021_feature_flags.sql:97-106`) lets *any* row in `staff_roles` write flags, including the `support` role, unlike every other staff policy which names roles.
6. **Broad base grants.** `0014_grant_new_tables.sql` grants `select` on all tables to `anon` and execute on all functions to `anon, authenticated`, and sets default privileges so future functions inherit that. RLS still blocks rows, but this is the reverse of least privilege; 0025 had to re-revoke several functions. Fine for a closed product, notable if the database were ever reopened.
7. **CORS `*`** on all three functions (`experience/index.ts:49`, `partner-view/index.ts:50`, `patterns/index.ts:44`). Bearer-token endpoints, so low risk, but wide.
8. **Edge functions are glued to the web source tree** by relative imports (`../../../apps/web/src/...`). Any refactor of those web files can break a deploy that CI (web gate) does not exercise.
9. **CMS safety rests on discipline.** `apps/cms/.env.local` holds the *production* connection string (many script headers say so); `payload.config.ts:63` uses `ssl: { rejectUnauthorized: false }`; scripts default to a dry run but `--apply` writes straight to production. `publish-reviewed.mjs:30` and `wire-bylines.mjs:44` hard-code the owner's personal email as default `REVIEWER_EMAIL`.
10. **Doc drift.** `cms_setup.md:52` still describes `PAYLOAD_DB_PUSH=true` on the deployed CMS; `supabase_apply_migrations.md` still says "23 tables" and lists only 0001-0003; `docs/14` still shows `device_key` anonymity and the dropped content tables; `docs/18` says admin-portal pages are "later" though two exist. `profiles.device_key` is unused by the web code (grep found no reference).
11. **Two-identity roles.** Supabase `staff_roles` and Payload `users.roles` are separate stores (RBAC doc admits it). Moot after retirement.
12. **`migrate-on-deploy.mjs` vs `migrate-apply.mjs`** overlap; I did not verify which one the CMS build actually calls (**not verified**; `apps/cms/package.json` build script is plain `next build`, so `migrate-on-deploy.mjs` appears unwired).
13. **Dead one-offs.** `docs/runbooks/sql/2026-10-07_apply_all.sql` has been applied (STATE: "applied and recorded (verified via the connector)").

## 9. Keep / rebuild / delete verdict

Verdict vocabulary requested: **export-then-drop**, **keep for a later phase**, **dead**. "Export" below always means: write to a private archive outside the repo for anything that could be personal, into the repo only for public editorial content.

### Tables, public schema

| table | holds | used at runtime today by | verdict |
|---|---|---|---|
| `ui_strings` | 1619 keys x 4 locales; only `human_reviewed` non-English rows have any effect | Public site overlay (hourly), `/admin/translations` | **export-then-drop.** Export the rows where `status='human_reviewed'` and locale in ar/fr/es (and diff against `messages/*.json`); merge differences into the JSON files, then drop. The JSON files already contain every key, so the only thing worth rescuing is human edits not yet in JSON |
| `profiles`, `consent_records`, `persona_state`, `adaptation_events` | Per-user identity and flags | Closed web tracker | **dead** once the web tracker is deleted; **keep for a later phase** only if cloud sync returns (ADR-070 says the code "can return when sync does"). No export: no real users (docs: 0 MAU) |
| `cycles`, `period_days`, `symptom_logs`, `vitals`, `fertility_logs`, `meds_supplements`, `conditions_flagged`, `screener_results`, `labs`, `pregnancy`, `fetal_movement_sessions`, `contractions`, `appointments`, `key_dates` | Health record | Closed web tracker | **dead** for the private phone app (the phone stores the record). Do **not** export: real health data must never enter a repo or chat. If the owner's own test rows matter, take a private `pg_dump` into the archive, not the repo. The column/shape design is worth keeping as a reference for the Dart models, which already exist |
| `partner_links` + `redeem_partner_invite` + `partner_shared_rows` + `partner-view` function | Partner sharing | Closed web tracker | **keep for a later phase** (it is a designed product feature: `docs/compliance/PARTNER_SHARING_DESIGN.md`), otherwise dead. Needs a server by definition; a private no-accounts app cannot do it |
| `notification_prefs`, `push_subscriptions` | Web-push prefs/endpoints | Closed web tracker | **dead** (Android uses local notifications) |
| `patterns` + `patterns` function | Derived findings | Closed web tracker | **dead** server-side; the logic lives in `lib/patterns` and should be twinned in Dart |
| `predictions`, `experience_documents` | Intended caches | Nothing writes them | **dead** (drop; empty by construction) |
| `feature_flags` + audit trigger | Remote config | `use-surface-version.ts` | **dead** for the static site and phone app; if remote flags are wanted later, a static JSON file is cheaper |
| `staff_roles`, `audit_log` | Back-office roles, trail | Admin pages, flag trigger | **dead** after Payload and admin pages go. Export nothing (check `staff_roles` holds only the owner) |
| `subscriptions` | Stub | Only the export list | **dead** (billing is Play Billing later, on the phone) |
| `insights_*` RPCs, `insights_k` | Aggregate staff counts | `/admin/insights` | **dead**. Privacy-preserving by design but meaningless without accounts |
| `search_content*`, `femio_ts_config`, `femio_search_tsquery` | Full-text search over Payload | Nothing | **dead** (drop before or with the `payload` schema) |
| `delete_account`, `handle_new_user`, `has_core_consent`, `is_staff`, `set_updated_at`, `*_is_allowed` helpers | Plumbing | Web tracker | **dead** with the tables |

### Payload collections (schema `payload`)

| collection | verdict |
|---|---|
| `articles` (100 published en) | **export-then-drop.** Already exported to `snapshot/articles.json`; take one fuller final dump (all docs including drafts, all fields, `_status`, reviewer relationships) to the archive, and move the approval metadata into the repo (see §10 sequence step 2) |
| `conditions` (5 published en) | **export-then-drop**, same as articles |
| `people` (1 bio, Dr. Khaled M.) | **export-then-drop.** `docs/content/people/khaled-m.json` + `snapshot/people.json` already hold it; confirm identical |
| `faqs`, `glossary` | **dead** (0 published in snapshot; `GLOSSARY_TERMS.md` exists as a draft source). Export any CMS drafts first, then drop |
| `tips` | **dead** (never snapshotted, no web consumer) |
| `media` | **export-then-drop only if any row exists**; nothing in the snapshot references images (**not verified** against the live table) |
| `users` (CMS staff) | **dead.** Export nothing; passwords and roles are not archive material |
| Payload bookkeeping (`payload_migrations`, `payload_preferences`, `payload_locked_documents*`, `*_v*` version tables, `*_locales`, `*_rels`) | **dead** with the schema (table list inferred from config, not enumerated live) |

### Edge functions

| function | verdict |
|---|---|
| `experience` | **dead** server-side (web falls back to local compute); the tier-1 modules it imports should be twinned in Dart for the phone instead |
| `partner-view` | **keep for a later phase** (partner sharing) or dead |
| `patterns` | **dead** server-side, same reasoning as `experience` |

### Code and scripts

| item | verdict |
|---|---|
| `apps/cms/**` (whole app) | **delete after export** (one Vercel project, a CVE surface, a 15-connection pool; plan item I-1/P2.8). Keep only `scripts/lib/markdown-to-lexical.mjs` if the Lexical body format is retained (see §10) |
| `scripts/content/snapshot-cms.mjs` | **keep until the last export**, then delete; replace with a repo-native build step |
| `scripts/i18n/seed-ui-strings.mjs` | **delete** with `ui_strings` |
| `scripts/security/rls-audit.mjs`, `scripts/db-artifacts-probe.mjs` | **delete** with the schema (keep as a pattern if cloud sync returns) |
| `supabase/migrations/*`, `supabase/functions/*` | **archive in git history / move to `docs/archive`**, then delete from the live tree; they document a data model that may return |
| `docs/runbooks/sql/2026-10-07_apply_all.sql`, `supabase_apply_migrations.md`, `cms_setup.md` | **delete or archive**, all stale |
| `lib/i18n/ui-strings-loader.ts`, `ui-strings.ts`, `translation-actions.ts`, admin translations page | **delete** (outside this area but required to finish the job) |

## 10. Retirement: what still depends on Supabase, and a safe sequence

### 10.1 What depends on Supabase at runtime today (Checked)

1. **Public website:** exactly one live read: the `ui_strings` overlay for ar/fr/es, once an hour per locale (`i18n/request.ts` -> `ui-strings-loader.ts`). Plus build/env coupling: `NEXT_PUBLIC_SUPABASE_URL/PUBLISHABLE_KEY` are required by `lib/env.ts:17-18`, and `lib/supabase/*` is imported across the tracker. With the web app closed, middleware makes no Supabase call (`middleware.ts:10-19`).
2. **Closed web tracker** (reachable only if `NEXT_PUBLIC_WEB_APP_ENABLED=1`, which production does not set): everything else, all ~45 table call sites, three functions, four RPCs, Supabase Auth.
3. **CMS:** `femio-cms.vercel.app` + the `payload` schema. Needed only to edit and to run the snapshot script. Nothing at page-view time.
4. **Scripts/CI:** `rls-audit`, `db-artifacts-probe`, `seed-ui-strings`, `snapshot-cms` and the `@live` e2e specs.
5. **Android app:** nothing.

### 10.2 Safe sequence (each step reversible until the last)

0. **Freeze and look (read-only, owner or a connector session).** Run these counts and write them to `docs/STATE.md` as *verified*: rows in `auth.users`, `profiles`, `consent_records`; `select locale,status,count(*) from ui_strings group by 1,2`; Payload `articles/conditions/faqs/glossary/tips/people/media` counts grouped by `_status`. Expectation from the docs is 0 real users; **not verified**. If any non-test user rows exist, stop and ask the owner before any export (safety line: no real health data into a repo or chat).
1. **Take a full private backup** (`pg_dump` of `public` and `payload`, or the Supabase backup) to `E:\_Archive\2026-10\supabase`, outside the repo.
2. **Make the repo the record of editorial approval.** Before Payload goes, write the 25 reviewer names, 100 `lastReviewed` dates, `firstPublishedAt`, `disclaimerType` and byline links from the snapshot into the markdown frontmatter (`status: published`, `medically_reviewed_by`, `date_published`, `last_reviewed`) or adopt the snapshot JSON as the source. Add a script that builds the snapshot from the repo only and a test that fails if a published article has no reviewer/date. Resolve the one md-only slug, `ramadan-fasting-pregnancy`, deliberately (draft or publish). This is the only step that can lose clinical sign-off if skipped.
3. **Final fuller content export.** Pull every collection (including drafts and non-whitelisted fields) from the CMS to the archive; compare the counts and slugs against the snapshot and `docs/content`. Public editorial content (articles, conditions, people) goes in the repo (already there); drafts/unknowns go to the archive.
4. **UI strings.** Export approved ar/fr/es overrides; diff against `apps/web/messages/*.json`; merge the diffs into the JSON by hand through the localization workflow (translator review for Arabic). Then remove the overlay: delete `ui-strings-loader.ts`, make `i18n/request.ts` import JSON only. After this, the public site has **zero** Supabase calls. Verify with the network log on a deployed preview (and `grep -r supabase apps/web/src/app` outside admin).
5. **Decouple build and env.** Make `NEXT_PUBLIC_SUPABASE_*` optional/removed in `lib/env.ts`, remove `NEXT_PUBLIC_CMS_URL` and the CSP entry in `next.config.mjs:61`, drop Supabase from CI (`ci.yml:34`), delete or quarantine the `@live` e2e specs. Decide the tracker code's fate (delete, or keep behind the flag with a stub client). If it is deleted, `supabase/functions` (which import web tier-1 files) can go too; the tier-1 modules stay as the source for the Dart twins.
6. **Pause, do not delete, the Supabase project** (reversible; it is already restricted). Watch for a week: nothing should break. Then take a last backup and delete the project, or keep it paused if the owner wants the option of partner sharing later (a paused free project costs nothing).
7. **Retire the CMS.** Remove the `femio-cms` Vercel project and domain, then delete `apps/cms/`, the `content-import*` root scripts (`package.json:37-38`), `scripts/lib/markdown-to-lexical.mjs` if no longer used, `scripts/content/snapshot-cms.mjs`, and the CMS-related ignore-build hooks. Remove PAYLOAD secrets from Vercel.
8. **Archive and document.** Move `supabase/` and the stale runbooks to `docs/archive/`, update `CLAUDE.md` (stack section still says Supabase and Payload are the stack), `docs/STATE.md`, ADR (supersedes ADR-060-era stack choices for the web), CHANGELOG, and the compliance data-map (the privacy policy language about EU hosting and processors changes: Supabase is no longer a processor, which simplifies the Egypt PDPL position).

**Why this order:** step 2 is the only irreversible information loss; steps 4-5 remove runtime coupling while the project still exists to fall back on; the pause in step 6 is the live test; only then do deletes happen.

## 11. Open questions (owner or a deeper read)

1. How many `ui_strings` rows are `human_reviewed` for ar/fr/es in the live database? If zero, step 4 is just deleting code. (Not verified; needs the connector or the dashboard.)
2. Does the live Payload hold drafts or documents not in the snapshot/markdown (translations, FAQs, glossary, tips, media, extra people)? The snapshot only returns published English.
3. Are there any real (non-test) users or consent rows in the live Supabase? Docs say 0 MAU on 2026-10-06; needs a count.
4. Is partner sharing (and therefore a server) still wanted in any future phase? That decides "delete" vs "archive and keep paused" for `partner_links`, `partner-view` and the project itself.
5. Should approval metadata live in markdown frontmatter, or should the committed snapshot JSON become the editable source? (Affects who can publish: today "approve in CMS" is a UI click; afterwards it is a reviewed commit.)
6. Is `migrate-on-deploy.mjs` wired anywhere, and has `drop-dev-migration-row.mjs` been run? Irrelevant if the CMS is deleted soon, relevant if it must be deployed again.
7. Does Egypt PDPL licensing (from 2026-10-31, per CLAUDE.md) still require anything for data already collected in this Supabase project, even if it holds only test accounts?
