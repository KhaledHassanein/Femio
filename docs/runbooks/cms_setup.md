# Runbook — Payload CMS setup (P1.6)

Audience: Khaled. `apps/cms` is a Payload 3 app on the **shared Supabase Postgres**. It builds
without a live DB (verified in CI), but running it + creating content needs two secrets and a
one-time schema setup. Claude Code holds only the client-safe publishable key, so these are
your steps.

## Step 1 — Secrets (`apps/cms/.env.local`, gitignored)
Copy `apps/cms/.env.example` → `apps/cms/.env.local` and fill:

```bash
# Supabase → Settings → Database → Connection string → "Session pooler" (URI).
# Use the SESSION pooler (port 5432), not the transaction pooler (6543) — Payload
# manages schema and needs prepared statements.
DATABASE_URL=postgresql://postgres.wnthtqtcajkhskdygbgo:<password>@aws-0-<region>.pooler.supabase.com:5432/postgres

# Generate a strong secret:  openssl rand -base64 32
PAYLOAD_SECRET=<long-random-string>
```

## Step 2 — Create the schema
Payload manages its own tables (prefixed, separate from the app's schema-v1 tables). From the repo root:

```bash
pnpm --filter cms dev
```
In dev, the Postgres adapter pushes the schema automatically on first boot. For production, prefer
explicit migrations instead of auto-push:
```bash
pnpm --filter cms exec payload migrate:create   # generate a migration from the schema
pnpm --filter cms exec payload migrate           # apply it
```

## Step 3 — First admin user
Visit **http://localhost:3001/admin** — Payload shows a "create first user" screen. Create your
admin account (give it the `admin` role). After that, add editors / medical reviewers / translators
under **Users** (only admins can set roles).

## Step 4 — Verify the review gate
- As an **editor**: create an Article, fill localized title/body, add Tier-1/2 sources. You can set
  reviewStatus up to *In medical review*, but **cannot** publish.
- As a **medical reviewer**: set reviewStatus *Approved*, then Publish. Publishing is blocked unless
  the item is approved — this is enforced server-side (`hooks/review-gate.ts`).
- Public/API reads (`/api/articles`) return only **published** items; staff see drafts.

## Step 5 — Deploy (separate Vercel project)
Create a **second Vercel project** pointing at this repo with **Root Directory = `apps/cms`**, set
`DATABASE_URL` + `PAYLOAD_SECRET` in its env (EU region), and deploy. The web app (`apps/web`) will
read published content from this CMS's REST/GraphQL API (wired in P1.8/P1.9).

## Step 6 — Schema changes when a collection is added
`PAYLOAD_DB_PUSH=true` is currently still set on the deployed CMS, so **additive** schema changes
(a new collection or field) are created by the deploy itself — verified 2026-07-30 with the
**People** collection (author / medical-reviewer bios, P1.9b.3b): the tables appeared in the
`payload` schema and `/api/people` returns 200 with no local run at all.

Two caveats worth keeping in mind:
- Payload's push is **interactive** whenever a change is *ambiguous or destructive*, and a
  non-interactive deploy cannot answer that prompt — so a removed/renamed field is the case that
  fails (or worse, drops a column). Prefer explicit migrations before real content exists:
  ```bash
  pnpm --filter cms exec payload migrate:create   # generate SQL from the schema diff
  pnpm --filter cms exec payload migrate          # apply it
  ```
  then remove `PAYLOAD_DB_PUSH` from Vercel and set the build command to run `payload migrate`.
- To apply a change from this machine instead, `pnpm --filter cms dev` still pushes on boot
  (answer **y** if prompted), exactly as in Step 2.

**Verify a collection landed:** Supabase → Table Editor → schema `payload` shows the table (plus its
`_locales` / `_v` siblings), and `https://<cms>/api/<collection>` returns JSON. On the website,
`/{locale}/authors` lists any **published** bio.

## Step 7 — Fix the first-user role deadlock (needed once)
Payload's "create first user" screen bypasses the admin-only `create` rule but still applies the
`roles` default (`editor`), and `roles` is admin-only editable — so the first account can be an
editor with **no admin in the system**, unable to approve, publish, or manage users. Repair it
out-of-band with the bundled script (Local API, so hashing/hooks/validation behave normally):

```bash
EMAIL=you@example.com ROLES=admin,editor pnpm --filter cms set-roles
```
Add `NEW_PASSWORD=…` to the same command to reset a lost CMS password (there is no email sender
configured, so Payload's forgot-password flow can't deliver a link). See
`apps/cms/scripts/set-user-roles.mjs`.

## Notes
- Locales: EN/AR/FR/ES (AR is RTL). Fetch a locale with `/api/articles?locale=ar`.
- The sketch `content`/`content_i18n` tables from migration 0001 are **superseded** by Payload and
  will be dropped in a later migration (tracked in P1.6 follow-ups). `ui_strings` stays.
