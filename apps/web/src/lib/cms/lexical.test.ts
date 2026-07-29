import { describe, expect, it } from "vitest";
import { lexicalToPlainText } from "./lexical";

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
