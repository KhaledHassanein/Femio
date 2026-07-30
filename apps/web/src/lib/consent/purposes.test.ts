import { describe, expect, it } from "vitest";
import {
  CONSENT_VERSION,
  OPTIONAL_PURPOSES,
  isGranted,
  latestFor,
  resolveOptionalConsents,
  type ConsentRow,
} from "./purposes";

const row = (
  purpose: string,
  granted: boolean,
  granted_at: string,
  revoked_at: string | null = null,
): ConsentRow => ({ purpose, granted, granted_at, revoked_at });

describe("consent resolution", () => {
  it("fails closed when there is no record at all", () => {
    // The normal state for every user who predates a newly added purpose.
    expect(isGranted([], "analytics")).toBe(false);
    expect(resolveOptionalConsents([])).toEqual({
      insights: false,
      research: false,
      analytics: false,
    });
  });

  it("reads a live grant as consent", () => {
    expect(isGranted([row("analytics", true, "2026-07-30T10:00:00Z")], "analytics")).toBe(true);
  });

  it("treats a revoked grant as no consent even though granted is true", () => {
    const rows = [row("analytics", true, "2026-07-30T10:00:00Z", "2026-07-30T12:00:00Z")];
    expect(isGranted(rows, "analytics")).toBe(false);
  });

  it("lets the newest record win: revoke after grant", () => {
    const rows = [
      row("research", true, "2026-07-01T10:00:00Z", "2026-07-30T09:00:00Z"),
      row("research", false, "2026-07-30T09:00:00Z"),
    ];
    expect(isGranted(rows, "research")).toBe(false);
  });

  it("lets the newest record win: re-grant after revoke", () => {
    const rows = [
      row("insights", true, "2026-07-01T10:00:00Z", "2026-07-10T10:00:00Z"),
      row("insights", false, "2026-07-10T10:00:00Z"),
      row("insights", true, "2026-07-30T10:00:00Z"),
    ];
    expect(isGranted(rows, "insights")).toBe(true);
  });

  it("keeps purposes independent", () => {
    const rows = [
      row("core", true, "2026-07-01T10:00:00Z"),
      row("insights", true, "2026-07-01T10:00:00Z"),
      row("research", false, "2026-07-01T10:00:00Z"),
    ];
    expect(resolveOptionalConsents(rows)).toEqual({
      insights: true,
      research: false,
      analytics: false, // never asked → never assumed
    });
    expect(isGranted(rows, "core")).toBe(true);
  });

  it("picks the newest row regardless of input order", () => {
    const rows = [
      row("analytics", true, "2026-07-30T10:00:00Z"),
      row("analytics", false, "2026-07-01T10:00:00Z"),
    ];
    expect(latestFor(rows, "analytics")?.granted_at).toBe("2026-07-30T10:00:00Z");
    expect(isGranted(rows, "analytics")).toBe(true);
  });

  it("never infers one purpose from another (the FTC failure mode)", () => {
    // Granting "show me my patterns" must not imply "send events to a vendor".
    const rows = [row("insights", true, "2026-07-30T10:00:00Z")];
    expect(isGranted(rows, "analytics")).toBe(false);
  });

  it("keeps the optional list free of core and of purposes with no UI", () => {
    expect(OPTIONAL_PURPOSES).not.toContain("core");
    expect(OPTIONAL_PURPOSES).not.toContain("ads_contextual");
  });

  it("records a dated policy version", () => {
    expect(CONSENT_VERSION).toMatch(/^\d{4}-\d{2}-\d{2}$/);
  });
});
