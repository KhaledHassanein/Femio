import type { Access, FieldAccess } from "payload";

export type Role = "admin" | "editor" | "medical_reviewer" | "translator";

/** True when the authenticated user holds any of the given roles. */
export function hasRole(user: unknown, ...roles: Role[]): boolean {
  const userRoles = (user as { roles?: string[] } | null)?.roles;
  return Array.isArray(userRoles) && roles.some((role) => userRoles.includes(role));
}

export const isAdmin: Access = ({ req }) => hasRole(req.user, "admin");
export const isAdminField: FieldAccess = ({ req }) => hasRole(req.user, "admin");

export const isStaff: Access = ({ req }) =>
  hasRole(req.user, "admin", "editor", "medical_reviewer", "translator");

/** Editors/admins author; medical reviewers approve (see collection hooks). */
export const isEditor: Access = ({ req }) => hasRole(req.user, "admin", "editor");
export const isReviewer: Access = ({ req }) => hasRole(req.user, "admin", "medical_reviewer");
