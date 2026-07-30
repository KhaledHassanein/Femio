import { describe, expect, it } from "vitest";
import {
  K,
  WITHHELD_BUCKET,
  isFullyWithheld,
  isSuppressed,
  maxVisible,
  suppressBuckets,
  suppressCount,
  type Bucket,
} from "./k-anon";

describe("k-anonymity guard", () => {
  it("withholds any count below k, including a count of one", () => {
    expect(suppressCount(1)).toBeNull();
    expect(suppressCount(K - 1)).toBeNull();
    expect(suppressCount(0)).toBeNull();
  });

  it("passes counts at or above k", () => {
    expect(suppressCount(K)).toBe(K);
    expect(suppressCount(250)).toBe(250);
  });

  it("keeps an already-withheld value withheld", () => {
    expect(suppressCount(null)).toBeNull();
    expect(isSuppressed(suppressCount(null))).toBe(true);
  });

  it("drops small buckets entirely rather than labelling them", () => {
    // "PCOS — withheld" would itself disclose that a tiny PCOS group exists.
    const rows: Bucket[] = [
      { bucket: "B", users: 40 },
      { bucket: "C", users: 3 },
    ];
    expect(suppressBuckets(rows)).toEqual([{ bucket: "B", users: 40 }]);
  });

  it("keeps the roll-up bucket and null-valued rows", () => {
    const rows: Bucket[] = [
      { bucket: "B", users: 40 },
      { bucket: WITHHELD_BUCKET, users: 12 },
      { bucket: "D", users: null },
    ];
    expect(suppressBuckets(rows)).toHaveLength(3);
  });

  it("re-suppresses even if the database returned something too small", () => {
    // Defence in depth: the SQL is authoritative, but must not be the only guard.
    const leaked: Bucket[] = [{ bucket: "F", users: 2 }];
    expect(suppressBuckets(leaked)).toEqual([]);
  });

  it("recognises a breakdown with nothing showable", () => {
    expect(isFullyWithheld([])).toBe(true);
    expect(isFullyWithheld([{ bucket: WITHHELD_BUCKET, users: 15 }])).toBe(true);
    expect(isFullyWithheld([{ bucket: "B", users: 40 }])).toBe(false);
  });

  it("scales bars off the largest visible count only", () => {
    const rows: Bucket[] = [
      { bucket: "B", users: 40 },
      { bucket: "C", users: null },
    ];
    expect(maxVisible(rows)).toBe(40);
    expect(maxVisible([{ bucket: "C", users: null }])).toBe(0);
  });

  it("uses a threshold high enough for health data", () => {
    // 5 is the common minimum; health inference warrants more headroom.
    expect(K).toBeGreaterThanOrEqual(10);
  });
});
