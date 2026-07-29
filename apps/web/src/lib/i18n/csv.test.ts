import { describe, expect, it } from "vitest";
import { parseCsv, parseCsvRecords, toCsv } from "./csv";

describe("toCsv", () => {
  it("writes a BOM, header, and quoted fields", () => {
    const out = toCsv(["key", "value"], [{ key: "a", value: "hi, there" }, { key: "b", value: 'say "x"' }]);
    expect(out.charCodeAt(0)).toBe(0xfeff);
    expect(out).toContain('a,"hi, there"');
    expect(out).toContain('b,"say ""x"""');
  });
});

describe("parseCsv", () => {
  it("handles quotes, commas and newlines inside fields", () => {
    const grid = parseCsv('key,value\r\na,"hi, there"\r\nb,"line1\nline2"\r\n');
    expect(grid).toEqual([
      ["key", "value"],
      ["a", "hi, there"],
      ["b", "line1\nline2"],
    ]);
  });

  it("strips a leading BOM", () => {
    expect(parseCsv("﻿key,value\r\na,1")[0]).toEqual(["key", "value"]);
  });
});

describe("round-trip", () => {
  it("survives commas, quotes, newlines and Arabic", () => {
    const headers = ["key", "english", "translation"];
    const rows = [
      { key: "meta.title", english: "Femio", translation: "فيميو" },
      { key: "x.y", english: "a, b", translation: 'quote " and\nnewline' },
    ];
    const { headers: h, records } = parseCsvRecords(toCsv(headers, rows));
    expect(h).toEqual(headers);
    expect(records).toEqual(rows);
  });

  it("drops fully-empty rows", () => {
    const { records } = parseCsvRecords("key,value\r\n\r\na,1\r\n");
    expect(records).toEqual([{ key: "a", value: "1" }]);
  });
});
