import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";
import { describe, expect, it } from "vitest";
import { QUESTIONS, START_HERE, groupByTopic, pregnancyWeek, rankOf, topicOf } from "./topics";

// The authored library, one file per article (docs/content/articles). The hub reads
// the CMS at runtime; this is the same set of slugs, available offline in CI.
// Condition pillars ("condition pillar") are the /conditions collection, not Learn.
const DIR = join(__dirname, "../../../../../docs/content/articles");
const SLUGS = readdirSync(DIR)
  .filter((f) => f.endsWith(".md"))
  .filter((f) => !/^content_type: "condition pillar"$/m.test(readFileSync(join(DIR, f), "utf8")))
  .map((f) => f.replace(/\.md$/, ""));

describe("Learn hub topics", () => {
  it("files every authored article under a real topic (nothing falls to 'more')", () => {
    const orphans = SLUGS.filter((s) => topicOf(s) === "more" && s !== "meet-femio");
    expect(orphans).toEqual([]);
  });

  it("only points the start row and the question chips at articles that exist", () => {
    for (const slug of [...START_HERE, ...QUESTIONS.map((q) => q.slug)]) {
      expect(SLUGS, slug).toContain(slug);
    }
  });

  it("orders pregnancy weeks numerically, not as strings", () => {
    const rows = groupByTopic(
      ["pregnancy-week-10", "pregnancy-week-4", "pregnancy-week-40"].map((slug) => ({ slug })),
    );
    expect(rows[0]!.items.map((i) => pregnancyWeek(i.slug))).toEqual([4, 10, 40]);
  });

  it("leads with the wedge and keeps every non-empty stage", () => {
    const rows = groupByTopic(SLUGS.map((slug) => ({ slug })));
    expect(rows[0]!.topic).toBe("ttc");
    expect(rows.map((r) => r.topic)).toEqual(
      expect.arrayContaining([
        "ttc",
        "weeks",
        "pregnancy",
        "afterBirth",
        "newborn",
        "cycles",
        "conditions",
        "teens",
        "menopause",
      ]),
    );
  });

  it("never drops an unknown slug: it goes to 'more', last", () => {
    expect(topicOf("a-guide-added-tomorrow")).toBe("more");
    expect(rankOf("a-guide-added-tomorrow")).toBeGreaterThan(rankOf("pcos-signs"));
  });
});
