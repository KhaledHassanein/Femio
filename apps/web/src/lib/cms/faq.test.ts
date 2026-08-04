import { describe, expect, it } from "vitest";
import { extractFaqs } from "./faq";
import type { RichTextValue } from "./client";

const text = (value: string) => ({ type: "text", text: value });
const heading = (tag: string, value: string) => ({ type: "heading", tag, children: [text(value)] });
const para = (value: string) => ({ type: "paragraph", children: [text(value)] });
const body = (children: unknown[]) => ({ root: { children } }) as unknown as RichTextValue;

describe("extractFaqs", () => {
  it("pairs a question heading with the prose beneath it", () => {
    const faqs = extractFaqs(
      body([heading("h3", "Can you have PCOS without cysts?"), para("Yes. The name can mislead.")]),
    );
    expect(faqs).toEqual([
      { question: "Can you have PCOS without cysts?", answer: "Yes. The name can mislead." },
    ]);
  });

  it("joins a multi-paragraph answer and stops at the next heading", () => {
    const faqs = extractFaqs(
      body([
        heading("h3", "Is it serious?"),
        para("Sometimes."),
        para("Ask a clinician."),
        heading("h3", "Next question?"),
        para("Another answer."),
      ]),
    );
    expect(faqs).toHaveLength(2);
    expect(faqs[0]?.answer).toBe("Sometimes. Ask a clinician.");
    expect(faqs[1]?.question).toBe("Next question?");
  });

  it("ignores headings that are not questions", () => {
    const faqs = extractFaqs(body([heading("h3", "What care can involve"), para("Several options.")]));
    expect(faqs).toEqual([]);
  });

  it("ignores h2 section headings even when phrased as a question", () => {
    // Only H3s are FAQ entries; an H2 is a section of the article body.
    const faqs = extractFaqs(body([heading("h2", "What is PCOS?"), para("A hormonal condition.")]));
    expect(faqs).toEqual([]);
  });

  it("skips a question with no answer rather than emitting an empty pair", () => {
    // Google rejects an incomplete Q&A, so an empty acceptedAnswer is worse than nothing.
    const faqs = extractFaqs(body([heading("h3", "Unanswered?"), heading("h3", "Answered?"), para("Yes.")]));
    expect(faqs).toEqual([{ question: "Answered?", answer: "Yes." }]);
  });

  it("recognises the Arabic question mark, not just the Latin one", () => {
    // The whole reason the rule keys off punctuation instead of the section heading:
    // "Frequently asked questions" is authored copy and differs per locale.
    const faqs = extractFaqs(body([heading("h3", "هل هذا طبيعي؟"), para("نعم، غالبًا.")]));
    expect(faqs).toHaveLength(1);
    expect(faqs[0]?.question).toBe("هل هذا طبيعي؟");
  });

  it("includes list and quote content in the answer", () => {
    const faqs = extractFaqs(
      body([
        heading("h3", "What should I track?"),
        {
          type: "list",
          children: [
            { type: "listitem", children: [text("Flow.")] },
            { type: "listitem", children: [text("Pain.")] },
          ],
        },
      ]),
    );
    expect(faqs[0]?.answer).toBe("Flow.Pain.");
  });

  it("returns nothing for an empty or missing body", () => {
    expect(extractFaqs(undefined)).toEqual([]);
    expect(extractFaqs(body([]))).toEqual([]);
    expect(extractFaqs(body([para("Just prose, no questions.")]))).toEqual([]);
  });
});
