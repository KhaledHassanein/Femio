import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { getMyRoles, hasRole, type StaffRole } from "./roles";

/**
 * Server-side route guard for back-office pages (P1.19–P1.21 admin portal). Reads
 * the current user's roles and redirects non-matching users home. RLS is still
 * the real boundary — this just keeps the admin UI off non-staff screens and
 * returns the roles so a page can adapt within the staff surface.
 *
 * Usage (Server Component): `const roles = await requireStaff(locale, "admin");`
 */
export async function requireStaff(locale: string, ...required: StaffRole[]): Promise<StaffRole[]> {
  const supabase = await createClient();
  const roles = await getMyRoles(supabase);
  const ok = required.length === 0 ? roles.length > 0 : hasRole(roles, ...required);
  if (!ok) redirect(`/${locale}`);
  return roles;
}
