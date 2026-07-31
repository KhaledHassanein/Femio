import { describe, expect, it } from "vitest";
import { mfaStatus, safeNextPath, staffMfaRedirect } from "./mfa";

describe("mfaStatus", () => {
  it("reports no enrolment when the account cannot reach aal2", () => {
    expect(mfaStatus("aal1", "aal1")).toBe("not_enrolled");
  });

  it("requires a step-up when a factor exists but this session is only aal1", () => {
    expect(mfaStatus("aal1", "aal2")).toBe("step_up_required");
  });

  it("is satisfied once the session itself reached aal2", () => {
    expect(mfaStatus("aal2", "aal2")).toBe("verified");
  });

  it("fails closed on missing levels rather than assuming verified", () => {
    expect(mfaStatus(null, null)).toBe("not_enrolled");
    expect(mfaStatus(undefined, "aal2")).toBe("step_up_required");
  });
});

describe("staffMfaRedirect", () => {
  it("lets a stepped-up session through", () => {
    expect(staffMfaRedirect("verified", "en", "/admin/insights")).toBeNull();
  });

  it("sends an enrolled-but-not-stepped-up session to the challenge, keeping the destination", () => {
    expect(staffMfaRedirect("step_up_required", "en", "/admin/insights")).toBe(
      "/en/mfa?next=%2Fadmin%2Finsights",
    );
  });

  it("sends an un-enrolled staff member to Settings, not to a dead end", () => {
    // Settings is not staff-gated, so this can never lock the only admin out.
    expect(staffMfaRedirect("not_enrolled", "ar", "/admin/translations")).toBe(
      "/ar/settings?mfa=required",
    );
  });

  it("keeps the locale of the request", () => {
    expect(staffMfaRedirect("step_up_required", "fr", "/admin/insights")).toContain("/fr/mfa");
  });
});

describe("safeNextPath", () => {
  it("accepts a same-origin path", () => {
    expect(safeNextPath("/admin/insights", "/dashboard")).toBe("/admin/insights");
  });

  it("rejects protocol-relative and absolute URLs (open redirect)", () => {
    expect(safeNextPath("//evil.com", "/dashboard")).toBe("/dashboard");
    expect(safeNextPath("https://evil.com", "/dashboard")).toBe("/dashboard");
  });

  it("falls back when there is nothing to use", () => {
    expect(safeNextPath(null, "/dashboard")).toBe("/dashboard");
    expect(safeNextPath("", "/dashboard")).toBe("/dashboard");
  });
});
