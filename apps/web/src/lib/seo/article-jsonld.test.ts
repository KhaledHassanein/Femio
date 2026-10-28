import { describe, expect, it } from "vitest";
import { articleJsonLd } from "./jsonld";

const base = {
  headline: "Heavy periods: what's normal and when to get help",
  description: "What counts as heavy bleeding, and the signs worth a doctor's visit.",
  url: "https://femioapp.com/en/learn/heavy-periods",
  locale: "en",
};

describe("articleJsonLd", () => {
  it("names the author and the medical reviewer separately", () => {
    const data = articleJsonLd({
      ...base,
      authors: [{ name: "A. Writer", url: "https://femioapp.com/en/authors/a-writer" }],
      reviewer: {
        name: "Dr Amina Khalil",
        credentials: "MD, MRCOG",
        url: "https://femioapp.com/en/authors/amina-khalil",
      },
    });

    // `author` and `reviewedBy` answer different questions — who wrote it vs.
    // who checked the medicine. Doc 15 is built on that distinction.
    expect(data.author).toHaveLength(1);
    expect(data.reviewedBy).toMatchObject({
      "@type": "Person",
      name: "Dr Amina Khalil",
      honorificSuffix: "MD, MRCOG",
    });
  });

  it("omits authorship entirely when there is none, rather than emitting empty people", () => {
    const data = articleJsonLd(base);
    expect(Object.keys(data)).not.toContain("author");
    expect(Object.keys(data)).not.toContain("reviewedBy");
  });

  it("emits dates as plain dates when present", () => {
    const data = articleJsonLd({
      ...base,
      datePublished: "2026-08-01T10:30:00.000Z",
      dateModified: "2026-08-03T09:00:00.000Z",
    });
    expect(data.datePublished).toBe("2026-08-01");
    expect(data.dateModified).toBe("2026-08-03");
  });

  it("omits dates rather than guessing them", () => {
    const data = articleJsonLd({ ...base, datePublished: null, dateModified: null });
    expect(Object.keys(data)).not.toContain("datePublished");
    expect(Object.keys(data)).not.toContain("dateModified");
  });

  it("always attributes the publisher to Femio", () => {
    expect(articleJsonLd(base).publisher).toMatchObject({ name: "femio" });
  });
});
