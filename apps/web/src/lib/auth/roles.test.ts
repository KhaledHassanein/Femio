import { describe, expect, it } from "vitest";
import { hasRole, isStaff, STAFF_ROLES } from "./roles";

describe("role predicates", () => {
  it("hasRole matches any required role", () => {
    expect(hasRole(["editor"], "admin", "editor")).toBe(true);
    expect(hasRole(["translator"], "admin", "editor")).toBe(false);
  });

  it("hasRole is safe on null/empty", () => {
    expect(hasRole(null, "admin")).toBe(false);
    expect(hasRole(undefined, "admin")).toBe(false);
    expect(hasRole([], "admin")).toBe(false);
  });

  it("isStaff is true for any back-office role, false otherwise", () => {
    for (const r of STAFF_ROLES) expect(isStaff([r])).toBe(true);
    expect(isStaff([])).toBe(false);
    expect(isStaff(["consumer"])).toBe(false);
    expect(isStaff(null)).toBe(false);
  });

  it("covers the five canonical roles (parity with Supabase staff_roles + Payload)", () => {
    expect([...STAFF_ROLES]).toEqual(["admin", "editor", "medical_reviewer", "translator", "support"]);
  });
});
