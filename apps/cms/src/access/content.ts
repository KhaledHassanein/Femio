import type { Access } from "payload";
import { hasRole } from "./roles";

// Public (and the web app via the API) sees only published content; any staff
// member sees everything, including drafts and in-review items.
export const readPublishedOrStaff: Access = ({ req }) => {
  if (hasRole(req.user, "admin", "editor", "medical_reviewer", "translator")) return true;
  return { _status: { equals: "published" } };
};
