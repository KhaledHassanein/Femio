// Minimal, correct CSV for the translation portal's Excel round-trip (P1.19.2).
// RFC4180-style quoting; UTF-8 BOM + CRLF on output so Excel opens Arabic/French
// correctly. Pure + unit-tested; no dependencies.

/** Quote a field if it contains a comma, quote, or newline; double embedded quotes. */
function escapeField(value: string): string {
  return /[",\r\n]/.test(value) ? `"${value.replace(/"/g, '""')}"` : value;
}

export function toCsv(headers: string[], rows: Record<string, string>[]): string {
  const lines = [headers.map(escapeField).join(",")];
  for (const row of rows) {
    lines.push(headers.map((h) => escapeField(row[h] ?? "")).join(","));
  }
  // BOM makes Excel read UTF-8; CRLF is the spreadsheet-friendly line ending.
  return "﻿" + lines.join("\r\n") + "\r\n";
}

/** Parse CSV text into a 2-D array of fields (handles quotes, commas, and newlines in fields). */
export function parseCsv(input: string): string[][] {
  let text = input;
  if (text.charCodeAt(0) === 0xfeff) text = text.slice(1); // strip BOM
  const rows: string[][] = [];
  let row: string[] = [];
  let field = "";
  let inQuotes = false;

  for (let i = 0; i < text.length; i++) {
    const c = text[i];
    if (inQuotes) {
      if (c === '"') {
        if (text[i + 1] === '"') {
          field += '"';
          i++;
        } else {
          inQuotes = false;
        }
      } else {
        field += c;
      }
    } else if (c === '"') {
      inQuotes = true;
    } else if (c === ",") {
      row.push(field);
      field = "";
    } else if (c === "\n") {
      row.push(field);
      rows.push(row);
      row = [];
      field = "";
    } else if (c === "\r") {
      // ignore; \n handles the row break (covers CRLF and lone LF)
    } else {
      field += c;
    }
  }
  // Flush the trailing field/row unless the input ended exactly on a newline.
  if (field !== "" || row.length > 0) {
    row.push(field);
    rows.push(row);
  }
  return rows;
}

export type CsvRecords = { headers: string[]; records: Record<string, string>[] };

/** Parse CSV into header-keyed records, dropping fully-empty rows. */
export function parseCsvRecords(input: string): CsvRecords {
  const grid = parseCsv(input).filter((r) => r.some((c) => c.trim() !== ""));
  if (grid.length === 0) return { headers: [], records: [] };
  const headers = grid[0]!.map((h) => h.trim());
  const records = grid.slice(1).map((r) => {
    const obj: Record<string, string> = {};
    headers.forEach((h, i) => (obj[h] = r[i] ?? ""));
    return obj;
  });
  return { headers, records };
}
