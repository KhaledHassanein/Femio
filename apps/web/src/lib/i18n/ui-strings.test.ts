import { describe, expect, it } from "vitest";
import { flatten, overlay, unflatten } from "./ui-strings";

describe("flatten / unflatten", () => {
  it("round-trips nested messages through dotted keys", () => {
    const nested = { a: "1", b: { c: "2", d: { e: "3" } } };
    const flat = flatten(nested);
    expect(flat).toEqual({ a: "1", "b.c": "2", "b.d.e": "3" });
    expect(unflatten(flat)).toEqual(nested);
  });
});

describe("overlay", () => {
  it("applies DB values over the JSON base, ignoring empty values", () => {
    const base = { track: { calendar: { heading: "Calendar", legendToday: "Today" } } };
    const merged = overlay(base, { "track.calendar.heading": "Cal.", "track.calendar.legendToday": "" });
    expect(merged).toEqual({ track: { calendar: { heading: "Cal.", legendToday: "Today" } } });
  });

  it("adds keys the base does not have", () => {
    expect(overlay({ a: "1" }, { "b.c": "2" })).toEqual({ a: "1", b: { c: "2" } });
  });

  it("leaves the base untouched when there are no overrides", () => {
    const base = { a: "1", b: { c: "2" } };
    expect(overlay(base, {})).toEqual(base);
  });
});
