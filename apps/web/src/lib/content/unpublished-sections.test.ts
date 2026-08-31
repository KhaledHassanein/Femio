import { readFileSync } from "node:fs";
import { join } from "node:path";
import { describe, expect, it } from "vitest";

import { isUnpublishedSection, UNPUBLISHED_SECTIONS } from "./unpublished-sections.ts";

const read = (rel: string) => readFileSync(join(process.cwd(), "src", rel), "utf8");

describe("isUnpublishedSection", () => {
  it("hides the sections whose collections are empty", () => {
    expect(isUnpublishedSection("/glossary")).toBe(true);
    expect(isUnpublishedSection("/faq")).toBe(true);
  });

  it("leaves everything with content alone", () => {
    for (const href of ["/learn", "/conditions", "/calculators", "/search", "/about"]) {
      expect(isUnpublishedSection(href)).toBe(false);
    }
  });
});

describe("every surface that promotes a section applies the filter", () => {
  // Three files list these paths independently — header, footer and sitemap. The
  // defect was that all three promoted two empty pages; the risk now is that a
  // future edit restores one of them, which nobody would notice because the other
  // two would still be right.
  it.each([
    ["components/site/site-header.tsx"],
    ["components/site/site-footer.tsx"],
    ["app/sitemap.ts"],
  ])("%s filters unpublished sections", (rel) => {
    const source = read(rel);
    expect(source).toContain("isUnpublishedSection");
  });
});

describe("the list is a temporary state, not an architecture", () => {
  it("names only paths, so re-enabling is deleting one entry", () => {
    // If this ever grows a reason field, a date, or a nested shape, the honest
    // move is to write the content instead.
    expect(UNPUBLISHED_SECTIONS.every((p) => typeof p === "string" && p.startsWith("/"))).toBe(
      true,
    );
  });
});
