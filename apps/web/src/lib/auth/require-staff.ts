import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { getMyRoles, hasRole, type StaffRole } from "./roles";
import { getMfaStatus, staffMfaRedirect } from "./mfa";

/**
 * Server-side route guard for back-office pages (P1.19–P1.21 admin portal). Reads
 * the current user's roles and redirects non-matching users home. RLS is still
 * the real boundary — this just keeps the admin UI off non-staff screens and
 * returns the roles so a page can adapt within the staff surface.
 *
 * Usage (Server Component): `const roles = await requireStaff(locale, "admin");`
 */
export async function requireStaff(
  locale: string,
  ...required: StaffRole[]
): Promise<StaffRole[]> {
  const supabase = await createClient();
  const roles = await getMyRoles(supabase);
  const ok = required.length === 0 ? roles.length > 0 : hasRole(roles, ...required);
  if (!ok) redirect(`/${locale}`);

  // Second factor required for every back-office surface (P1.23.3): a stolen
  // staff password must not be enough to read the portal or grant a role.
  // Un-enrolled staff are sent to Settings (not staff-gated), so enforcing this
  // can never lock the only admin out of the place they'd fix it.
  const mfa = await getMfaStatus(supabase);
  const destination = staffMfaRedirect(mfa, locale, STAFF_LANDING);
  if (destination) redirect(destination);

  return roles;
}

/**
 * Where to return after a step-up. Locale-less on purpose: the challenge page
 * navigates with the i18n router, which adds the prefix itself. The guard runs in
 * a Server Component, so the current URL isn't available without opting the page
 * into dynamic rendering via `headers()` — the admin index is a safe landing spot.
 */
const STAFF_LANDING = "/admin/insights";
