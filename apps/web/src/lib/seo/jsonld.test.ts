import { describe, expect, it } from "vitest";
import { faqPageJsonLd, personJsonLd } from "./jsonld";

describe("personJsonLd", () => {
  it("emits a Person with the E-E-A-T fields that are present", () => {
    const data = personJsonLd({
      name: "Dr Amina Khalil",
      url: "https://example.com/en/authors/amina-khalil",
      description: "Consultant obstetrician and gynaecologist.",
      credentials: "MD, MRCOG",
      jobTitle: "Medical reviewer",
      affiliation: "Cairo University",
      sameAs: ["https://orcid.org/0000-0000-0000-0000"],
    });

    expect(data["@type"]).toBe("Person");
    expect(data.name).toBe("Dr Amina Khalil");
    expect(data).toMatchObject({
      honorificSuffix: "MD, MRCOG",
      jobTitle: "Medical reviewer",
      affiliation: { "@type": "Organization", name: "Cairo University" },
      sameAs: ["https://orcid.org/0000-0000-0000-0000"],
    });
  });

  it("omits empty/absent fields rather than emitting blanks", () => {
    const data = personJsonLd({ name: "A. Editor", url: "https://example.com/en/authors/a-editor" });

    expect(Object.keys(data)).not.toContain("honorificSuffix");
    expect(Object.keys(data)).not.toContain("jobTitle");
    expect(Object.keys(data)).not.toContain("affiliation");
    expect(Object.keys(data)).not.toContain("sameAs");
    expect(Object.keys(data)).not.toContain("description");
  });

  it("omits sameAs when the array is empty", () => {
    const data = personJsonLd({ name: "A", url: "https://example.com/x", sameAs: [] });
    expect(Object.keys(data)).not.toContain("sameAs");
  });

  it("always attributes the person to Femio", () => {
    const data = personJsonLd({ name: "A", url: "https://example.com/x" });
    expect(data.worksFor).toMatchObject({ "@type": "Organization", name: "femio" });
  });
});

describe("faqPageJsonLd", () => {
  it("emits a FAQPage with a Question and accepted Answer per item", () => {
    const data = faqPageJsonLd([
      { question: "Why a range?", answer: "Ovulation does not fall on the same day every cycle." },
      { question: "Is it stored?", answer: "No." },
    ]);
    expect(data["@type"]).toBe("FAQPage");
    expect(data.mainEntity).toHaveLength(2);
    expect(data.mainEntity[0]).toEqual({
      "@type": "Question",
      name: "Why a range?",
      acceptedAnswer: { "@type": "Answer", text: "Ovulation does not fall on the same day every cycle." },
    });
  });
});
