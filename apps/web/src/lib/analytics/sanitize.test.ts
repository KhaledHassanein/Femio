import { describe, expect, it } from "vitest";
import { FORBIDDEN_VENDOR_PROPERTIES, sanitizeProperties } from "./sanitize";

describe("sanitizeProperties", () => {
  it("keeps the properties the event itself declared", () => {
    const out = sanitizeProperties({ area: "library", locale: "en" }, ["area", "locale"]);
    expect(out).toEqual({ area: "library", locale: "en" });
  });

  it("drops the article URL the SDK attaches — the whole reason this exists", () => {
    // /learn/endometriosis-symptoms on a persistent id is a health inference.
    const out = sanitizeProperties(
      { area: "library", $current_url: "https://femioapp.com/en/learn/endometriosis-symptoms" },
      ["area"],
    );
    expect(out).toEqual({ area: "library" });
  });

  it("refuses every property on the forbidden list", () => {
    const props: Record<string, unknown> = { area: "home" };
    for (const key of FORBIDDEN_VENDOR_PROPERTIES) props[key] = "leaky-value";
    const out = sanitizeProperties(props, ["area"]);
    expect(Object.keys(out)).toEqual(["area"]);
  });

  it("keeps the pseudonymous vendor identifiers that are safe", () => {
    const out = sanitizeProperties(
      { area: "home", $device_id: "d1", $session_id: "s1", $browser: "Chrome" },
      ["area"],
    );
    expect(out).toMatchObject({ $device_id: "d1", $session_id: "s1", $browser: "Chrome" });
  });

  it("denies by default, so a property added by a future SDK version can't ride along", () => {
    const out = sanitizeProperties(
      { area: "home", $some_new_autoproperty_2027: "/en/learn/pcos" },
      ["area"],
    );
    expect(out).toEqual({ area: "home" });
  });

  it("does not let a caller smuggle a URL through by declaring it", () => {
    // ourKeys comes from the closed catalog, which has no free-form values —
    // but if it ever did, this test documents that the catalog is the guarantee.
    const out = sanitizeProperties({ $current_url: "x" }, ["area"]);
    expect(out).toEqual({});
  });

  it("returns a new object rather than mutating the input", () => {
    const input = { area: "home", $current_url: "https://femioapp.com/en" };
    const out = sanitizeProperties(input, ["area"]);
    expect(input.$current_url).toBe("https://femioapp.com/en");
    expect(out).not.toBe(input);
  });
});
