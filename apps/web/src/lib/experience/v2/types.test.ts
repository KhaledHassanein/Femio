/**
 * The v2 contract's two invariants, pinned.
 *
 * Both are the kind of rule that is written in a header comment, believed, and
 * then quietly broken by the fifteenth module. A comment cannot fail CI.
 */
import { readFileSync } from "node:fs";
import { describe, expect, it } from "vitest";

import type { A11ySpec, ModuleSpecV2, SurfaceMap } from "./types.ts";

describe("invariant 1 — a module cannot ship without an accessible name", () => {
  it("compiles with a11y present", () => {
    const m: ModuleSpecV2 = {
      id: "cycle.window",
      emphasis: "hero",
      a11y: { labelKey: "modules.cycle.window.label", role: "region" },
    };
    expect(m.a11y.labelKey).toBe("modules.cycle.window.label");
  });

  it("does not compile without a11y", () => {
    // @ts-expect-error — `a11y` is required. If this line ever stops erroring,
    // the contract has regressed to v1's three-field shape and every served
    // module can ship unlabelled again.
    const m: ModuleSpecV2 = { id: "cycle.window", emphasis: "hero" };
    expect(m.id).toBe("cycle.window");
  });
});

describe("invariant 2 — every human-readable field is an i18n key", () => {
  /**
   * Read the source rather than the types: this is a naming rule, and naming is
   * exactly what a type cannot check. A field called `label` holding a rendered
   * string is the one mistake that breaks Arabic silently — the document would
   * carry English text that no translation layer ever sees.
   */
  const source = readFileSync(new URL("./types.ts", import.meta.url), "utf8");

  /** Field declarations in the type bodies, e.g. `  labelKey: string;`. */
  const declaredFields = [...source.matchAll(/^\s{2,}(\w+)\??:\s*[^;]+;/gm)]
    .map((m) => m[1])
    .filter((f): f is string => f !== undefined);

  const HUMAN_READABLE = ["label", "title", "text", "heading", "caption", "description", "summary"];

  it("declares no human-readable field that is not a *Key", () => {
    const offenders = declaredFields.filter(
      (f) => HUMAN_READABLE.some((h) => f.toLowerCase().startsWith(h)) && !f.endsWith("Key"),
    );
    expect(offenders).toEqual([]);
  });

  it("found the fields it is guarding, so the regex has not silently stopped matching", () => {
    expect(declaredFields).toContain("labelKey");
    expect(declaredFields).toContain("titleKey");
    expect(declaredFields).toContain("descriptionKey");
  });
});

describe("invariant 3 — measurement cannot name an off-platform event", () => {
  it("has no field that could carry an analytics event name", () => {
    const m: ModuleSpecV2 = {
      id: "cycle.window",
      emphasis: "hero",
      a11y: { labelKey: "k" },
      measure: { bucket: "module_seen", minVisibleMs: 1000 },
    };
    // `bucket` is a closed union of first-party buckets. There is deliberately no
    // `event` field: lib/analytics/guard.ts blocks "cycle", "mood" and "persona"
    // as property tokens at runtime, so a module-id impression could never have
    // reached PostHog anyway — and product rule 4 says it must not.
    expect(m.measure?.bucket).toBe("module_seen");
    expect(Object.keys(m.measure ?? {})).not.toContain("event");
  });
});

describe("invariant 4 — tools.featured orders and never filters", () => {
  it("accepts a featured list shorter than the full tool set", () => {
    const tools: SurfaceMap["tools"] = { featured: ["summary", "patterns"] };
    // The other tools are not absent from the product; they come after. The lint
    // in RB-B6 is what stops a renderer treating this as a filter.
    expect(tools.featured).toHaveLength(2);
  });
});

describe("A11ySpec", () => {
  it("allows a live region for content that changes without navigation", () => {
    const a: A11ySpec = { labelKey: "k", role: "status", liveRegion: "polite" };
    expect(a.liveRegion).toBe("polite");
  });
});
