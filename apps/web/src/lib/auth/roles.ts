import type { SupabaseClient } from "@supabase/supabase-js";

/**
 * Web-app view of the back-office role model (P1.18). The source of truth is the
 * Postgres `staff_roles` table + `is_staff()`, enforced by RLS (0002): a user can
 * read only their OWN roles, and only an admin can grant/revoke roles — there is
 * no self-escalation path (proven by scripts/security/rls-audit.mjs). These
 * helpers just surface the current user's roles so the UI/route guards can adapt;
 * they are NOT the security boundary (RLS is). Mirrors apps/cms/src/access/roles.ts
 * and docs/18_RBAC_MODEL.md.
 */
export const STAFF_ROLES = ["admin", "editor", "medical_reviewer", "translator", "support"] as const;
export type StaffRole = (typeof STAFF_ROLES)[number];

/** Pure predicate: does this role set include any of the required roles? */
export function hasRole(roles: readonly string[] | null | undefined, ...required: StaffRole[]): boolean {
  if (!roles) return false;
  return required.some((r) => roles.includes(r));
}

/** Any back-office role at all. */
export function isStaff(roles: readonly string[] | null | undefined): boolean {
  return hasRole(roles, ...STAFF_ROLES);
}

/**
 * Read the CURRENT user's roles. Returns [] for anonymous/consumer users (RLS
 * yields no rows). Never throws — a failure is treated as "no roles".
 */
export async function getMyRoles(supabase: SupabaseClient): Promise<StaffRole[]> {
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return [];
  const { data, error } = await supabase.from("staff_roles").select("role").eq("user_id", user.id);
  if (error || !data) return [];
  return data.map((r) => r.role).filter((r): r is StaffRole => (STAFF_ROLES as readonly string[]).includes(r));
}
