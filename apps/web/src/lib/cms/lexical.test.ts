import { describe, expect, it } from "vitest";
import { lexicalToPlainText, splitAfterFirstSection } from "./lexical";

describe("lexicalToPlainText", () => {
  it("extracts text across paragraphs and headings", () => {
    const value = {
      root: {
        children: [
          { type: "heading", tag: "h2", children: [{ type: "text", text: "Cycles" }] },
          {
            type: "paragraph",
            children: [
              { type: "text", text: "A cycle " },
              { type: "text", text: "varies", format: 2 },
              { type: "text", text: " in length." },
            ],
          },
        ],
      },
    };
    expect(lexicalToPlainText(value)).toBe("Cycles A cycle varies in length.");
  });

  it("is safe on empty / null input", () => {
    expect(lexicalToPlainText(null)).toBe("");
    expect(lexicalToPlainText({ root: { children: [] } })).toBe("");
  });
});

describe("splitAfterFirstSection (R6.8 mid-article placement)", () => {
  const h2 = (text: string) => ({ type: "heading", tag: "h2", children: [{ type: "text", text }] });
  const p = (text: string) => ({ type: "paragraph", children: [{ type: "text", text }] });

  it("splits right before the second H2, so the first section stays whole", () => {
    const nodes = [p("intro"), h2("One"), p("a"), { type: "list", children: [] }, h2("Two"), p("b")];
    const { head, rest } = splitAfterFirstSection({ root: { children: nodes } });
    expect(head).toEqual(nodes.slice(0, 4));
    expect(rest).toEqual(nodes.slice(4));
  });

  it("gives one part and no rest when the body has fewer than two H2s", () => {
    const nodes = [p("intro"), h2("Only"), p("a"), { type: "heading", tag: "h3", children: [] }, p("b")];
    expect(splitAfterFirstSection({ root: { children: nodes } })).toEqual({ head: nodes, rest: [] });
    expect(splitAfterFirstSection(null)).toEqual({ head: [], rest: [] });
  });
});
