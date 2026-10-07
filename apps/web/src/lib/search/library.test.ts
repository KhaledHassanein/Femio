import { describe, expect, it } from "vitest";

import { search } from "./index.ts";
import { headingsOf, libraryDocs } from "./library.ts";

const body = {
  root: {
    type: "root",
    children: [
      { type: "paragraph", children: [{ type: "text", text: "Prose is not indexed." }] },
      {
        type: "heading",
        children: [
          { type: "text", text: "When to call " },
          { type: "text", text: "your midwife" },
        ],
      },
      { type: "heading", children: [{ type: "text", text: "Is ibuprofen safe?" }] },
      { type: "heading", children: [{ type: "text", text: "Is ibuprofen safe?" }] },
    ],
  },
};

describe("headingsOf", () => {
  it("joins a heading's text runs and drops duplicates", () => {
    expect(headingsOf(body)).toEqual(["When to call your midwife", "Is ibuprofen safe?"]);
  });

  it("is empty for a missing body", () => {
    expect(headingsOf(null)).toEqual([]);
    expect(headingsOf({})).toEqual([]);
  });
});

describe("libraryDocs", () => {
  const docs = libraryDocs({
    articles: [{ slug: "afterpains", title: "Afterpains", excerpt: "Cramps after birth", body }],
    conditions: [{ slug: "pcos", title: "PCOS", summary: "Polycystic ovary syndrome" }],
    glossary: [{ slug: "lh", term: "LH" }, { slug: "untitled" }],
  });

  it("routes each kind to its page and skips an entry with no title", () => {
    expect(docs.map((d) => [d.kind, d.href])).toEqual([
      ["condition", "/conditions/pcos"],
      ["article", "/learn/afterpains"],
      ["glossary", "/glossary#lh"],
    ]);
  });

  it("never carries the body: only title, summary and headings", () => {
    expect(JSON.stringify(docs)).not.toContain("Prose is not indexed");
    expect(docs[1]).toMatchObject({
      summary: "Cramps after birth",
      keywords: ["When to call your midwife", "Is ibuprofen safe?"],
    });
  });

  it("finds an article by a question its headings answer", () => {
    expect(search("ibuprofen", docs)[0]?.id).toBe("article:afterpains");
    expect(search("call midwife", docs)[0]?.id).toBe("article:afterpains");
  });
});
