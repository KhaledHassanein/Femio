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

## Notes
- Locales: EN/AR/FR/ES (AR is RTL). Fetch a locale with `/api/articles?locale=ar`.
- The sketch `content`/`content_i18n` tables from migration 0001 are **superseded** by Payload and
  will be dropped in a later migration (tracked in P1.6 follow-ups). `ui_strings` stays.
