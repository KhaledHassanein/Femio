import { describe, expect, it } from "vitest";
import { LIST_FIELDS, selectParams } from "./client";

describe("CMS field selection", () => {
  it("builds Payload's select query string", () => {
    expect(selectParams(["slug", "title"])).toBe("&select[slug]=true&select[title]=true");
  });

  // The whole point: a list must never pull article bodies (2.1 MB for 100 articles,
  // over Next's 2 MB cache limit, so it was refetched on every render).
  it("never asks a list for a body", () => {
    expect(LIST_FIELDS).not.toContain("body");
    expect(LIST_FIELDS).toEqual(expect.arrayContaining(["slug", "title", "updatedAt"]));
  });
});
