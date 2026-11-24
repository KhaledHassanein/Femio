import { describe, expect, it } from "vitest";
import enMessages from "../../../messages/en.json";
import arMessages from "../../../messages/ar.json";
import frMessages from "../../../messages/fr.json";
import esMessages from "../../../messages/es.json";
import { calculatorFaqJsonLd, readFaqMessages } from "./faq";

const TOOLS = ["ovulation", "dueDate", "gestationalAge", "period", "pregnancyTest", "cycleLength", "bmi", "pregnancyCalendar", "weightGain", "contractionTimer"] as const;

describe("readFaqMessages", () => {
  it("keeps well-formed entries and drops everything else", () => {
    const raw = [{ q: "Why?", a: "Because." }, { q: "", a: "x" }, { q: "No answer" }, null, "text", { q: 1, a: 2 }];
    expect(readFaqMessages(raw)).toEqual([{ q: "Why?", a: "Because." }]);
  });

  it("returns an empty list when the key is missing or not an array", () => {
    expect(readFaqMessages(undefined)).toEqual([]);
    expect(readFaqMessages({ q: "a", a: "b" })).toEqual([]);
  });
});

describe("calculatorFaqJsonLd", () => {
  it("builds FAQPage markup with one Question per entry", () => {
    const data = calculatorFaqJsonLd([{ q: "Why a range?", a: "Ovulation moves." }]);
    expect(data).toMatchObject({
      "@type": "FAQPage",
      mainEntity: [{ "@type": "Question", name: "Why a range?", acceptedAnswer: { "@type": "Answer", text: "Ovulation moves." } }],
    });
  });

  it("returns null for an empty list, so no empty FAQPage is emitted", () => {
    expect(calculatorFaqJsonLd([])).toBeNull();
  });
});

describe("the shipped calculator FAQs", () => {
  const catalogs = { en: enMessages, ar: arMessages, fr: frMessages, es: esMessages } as const;

  for (const [locale, catalog] of Object.entries(catalogs)) {
    it(`${locale}: every calculator has exactly three well-formed questions`, () => {
      for (const tool of TOOLS) {
        const raw = (catalog.calculators as unknown as Record<string, { faq?: unknown }>)[tool]?.faq;
        expect(readFaqMessages(raw), `${locale}.${tool}`).toHaveLength(3);
        expect(Array.isArray(raw) ? raw.length : 0, `${locale}.${tool} has a malformed entry`).toBe(3);
      }
    });
  }
});
