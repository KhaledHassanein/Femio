import type { CollectionBeforeChangeHook } from "payload";
import { APIError } from "payload";
import { hasRole } from "../access/roles";

// Enforces the draft → medical-review → publish gate at the data layer, so it
// holds no matter which API is used (admin, REST, GraphQL):
//  - only medical reviewers/admins may mark content "approved";
//  - only medical reviewers/admins may publish, and only once approved.
// This keeps unreviewed medical content from ever going live (P0.22 spirit).
export const enforceReviewGate: CollectionBeforeChangeHook = ({ data, req }) => {
  const user = req.user;

  if (data?.reviewStatus === "approved" && !hasRole(user, "admin", "medical_reviewer")) {
    throw new APIError("Only a medical reviewer can mark content approved.", 403);
  }

  if (data?._status === "published") {
    if (!hasRole(user, "admin", "medical_reviewer")) {
      throw new APIError("Only a medical reviewer can publish content.", 403);
    }
    if (data?.reviewStatus !== "approved") {
      throw new APIError(
        "Content must be approved by a medical reviewer before publishing.",
        400,
      );
    }
  }

  return data;
};
