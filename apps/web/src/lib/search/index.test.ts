import { describe, expect, it } from "vitest";

import { groupByKind, KIND_ORDER, search, type SearchDoc } from "./index.ts";

const docs: SearchDoc[] = [
  { id: "c1", kind: "condition", title: "Endometriosis", href: "/conditions/endometriosis" },
  { id: "a1", kind: "article", title: "Living with endometriosis", href: "/learn/a1" },
  {
    id: "a2",
    kind: "article",
    title: "Period pain",
    summary: "When cramps are worth mentioning",
    href: "/learn/a2",
  },
  {
    id: "g1",
    kind: "glossary",
    title: "Dysmenorrhoea",
    keywords: ["period pain", "cramps"],
    href: "/glossary#g1",
  },
  { id: "k1", kind: "calculator", title: "Cycle length calculator", href: "/tools/cycle" },
  { id: "a3", kind: "article", title: "Understanding PMS", href: "/learn/a3" },
  { id: "a4", kind: "article", title: "Tracking symptoms", href: "/learn/a4" },
  { id: "a5", kind: "article", title: "Fatigué et le cycle", href: "/learn/a5" },
];

describe("search", () => {
  it("returns nothing for an empty query rather than the whole library", () => {
    // Search is an alternative to browsing, not a dump of it.
    expect(search("", docs)).toEqual([]);
    expect(search("   ", docs)).toEqual([]);
  });

  it("puts an exact title first", () => {
    expect(search("endometriosis", docs)[0]!.id).toBe("c1");
  });

  it("ranks the condition above an article that merely shares the word", () => {
    // She typed the name of a thing; the library entry that gathers everything
    // about it is what she meant, not whichever article happens to contain it.
    const ids = search("endometriosis", docs).map((h) => h.id);
    expect(ids.indexOf("c1")).toBeLessThan(ids.indexOf("a1"));
  });

  it("does not match a word from the middle of another word", () => {
    // "pms" inside "symptoms" is a substring, not a hit — the single most common
    // way a naive matcher embarrasses itself.
    const ids = search("pms", docs).map((h) => h.id);
    expect(ids).toContain("a3");
    expect(ids).not.toContain("a4");
  });

  it("finds a term by its synonym without needing it in the title", () => {
    // "period pain" is what she calls it; "dysmenorrhoea" is what it is filed as.
    expect(search("cramps", docs).map((h) => h.id)).toContain("g1");
  });

  it("strips accents, so an unaccented query still finds accented text", () => {
    expect(search("fatigue", docs).map((h) => h.id)).toContain("a5");
  });

  it("matches a summary, but ranks it below a title or keyword match", () => {
    const hits = search("cramps", docs);
    const bySummary = hits.find((h) => h.id === "a2");
    const byKeyword = hits.find((h) => h.id === "g1");
    expect(bySummary).toBeDefined();
    expect(byKeyword!.score).toBeGreaterThan(bySummary!.score);
  });

  it("respects the limit", () => {
    expect(search("e", docs, 2)).toHaveLength(2);
  });

  it("is deterministic, so the same query never reorders between renders", () => {
    expect(search("period", docs)).toEqual(search("period", docs));
  });
});

describe("groupByKind", () => {
  it("uses the declared order and drops empty groups", () => {
    const groups = groupByKind(search("period", docs));
    expect(groups.every((g) => g.hits.length > 0)).toBe(true);
    const kinds = groups.map((g) => g.kind);
    const ranked = [...kinds].sort((x, y) => KIND_ORDER.indexOf(x) - KIND_ORDER.indexOf(y));
    expect(kinds).toEqual(ranked);
  });
});

describe("search, beyond a single name", () => {
  const more: SearchDoc[] = [
    {
      id: "x1",
      kind: "article",
      title: "Travel and your cycle",
      summary: "A trip to Spain, and period pain on the way",
      href: "/learn/x1",
    },
    {
      id: "x2",
      kind: "article",
      title: "Bleeding in the weeks after birth",
      keywords: ["When bleeding is too heavy"],
      href: "/learn/x2",
    },
  ];

  it("finds a word that starts later in the text after a mid-word miss", () => {
    // "pain" first occurs inside "Spain", then later as a word of its own.
    expect(search("pain", more).map((h) => h.id)).toEqual(["x1"]);
  });

  it("matches a question when every meaningful word is in the document", () => {
    expect(search("heavy bleeding after birth", more)[0]?.id).toBe("x2");
    expect(search("heavy bleeding in pregnancy", more)).toEqual([]);
  });

  it("ignores short words, so 'is it' does not match everything", () => {
    expect(search("is it", more)).toEqual([]);
  });
});
