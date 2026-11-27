# Femio — Role-Based Access Control (P1.18)

Status: **foundation complete, 2026-07-24** (Claude Code). The admin-portal *pages*
that consume this (P1.19 translation portal, P1.20 analytics, P1.21 moderation/CS)
land later; this document is the single reference for the role model they build on.

Ties to: `docs/14_SYSTEM_ARCHITECTURE.md` §3–4, `supabase/migrations/0001` (staff_roles),
`0002` (policies + `is_staff`), `docs/compliance/SECURITY_REVIEW.md`.

## The five canonical roles

| Role | Purpose | Supabase `staff_roles` | Payload CMS |
|------|---------|:---:|:---:|
| `admin` | Full back-office control; manages users + roles | ✓ | ✓ |
| `editor` | Authors content | ✓ | ✓ |
| `medical_reviewer` | Approves content for publish (medical gate) | ✓ | ✓ |
| `translator` | Localizes content/UI strings | ✓ | ✓ |
| `support` | Customer service, moderation/CS inbox (P1.21) | ✓ | — (by design) |

`support` is deliberately **not** a Payload role: support/CS staff do not author
content and have no CMS login. It lives only in the app-side admin surface. Payload
therefore mirrors the **four content-authoring roles**; Supabase `staff_roles` is
the **superset** and the source of truth for the app.

## Where each layer enforces it

- **Database (source of truth + real boundary).** `public.staff_roles(user_id, role)`
  with RLS (0002): a user may read **only their own** roles; **only an admin** may
  insert/update/delete roles — there is **no self-escalation path**. `is_staff(uid, roles[])`
  (security-definer) backs the content/staff RLS policies. Proven live by
  `scripts/security/rls-audit.mjs` (§ "Role privilege escalation": non-admin cannot
  grant self a role; cannot read another user's roles).
- **Payload CMS** (`apps/cms/src/access/roles.ts`). Collection/field access:
  `isAdmin`, `isEditor` (admin+editor author), `isReviewer` (admin+medical_reviewer
  approve), `isStaff` (any of the 4 content roles). The draft→review→publish gate is
  a `beforeChange` hook — only reviewers/admins can set `approved`, and publish
  requires approval (ADR-012). Enforced regardless of API path.
- **Web app** (`apps/web/src/lib/auth/`). `roles.ts` — `STAFF_ROLES` (all 5),
  pure `hasRole()` / `isStaff()` predicates, and `getMyRoles(supabase)` which reads
  the current user's roles via RLS (returns `[]` for consumer/anonymous users).
  `require-staff.ts` — `requireStaff(locale, ...roles)`, a Server-Component guard that
  redirects non-matching users home. **These are UX adaptation, not the security
  boundary** — RLS is. A page still cannot read or write what RLS forbids even if a
  guard were bypassed.

## Building an admin page (P1.19+)

```ts
// Server Component
const roles = await requireStaff(locale, "admin", "translator"); // redirects non-staff
// ...render, adapting to `roles`; every DB read/write is still RLS-scoped.
```

## Provisioning

Roles are granted by an **admin** (insert into `staff_roles`), or by Khaled via the
Supabase dashboard for the first admin (no self-service escalation by design). Payload
staff accounts are created by an admin in the CMS (`Users` collection, `roles` field is
admin-updatable only). A person who is both a content author and an app-admin has a row
in **both** systems today; unifying the two identity stores is a later consideration
(tracked with the admin portal).

## Open / follow-ups

- Admin portal pages consuming `requireStaff` — P1.19 (translation portal), P1.20
  (analytics), P1.21 (moderation/CS inbox).
- MFA for staff/admin accounts — with the admin portal (SECURITY_REVIEW A07).
- Decide whether to unify Supabase `staff_roles` and Payload `Users` into one identity
  source, or keep the content-CMS and app-admin identities separate.
