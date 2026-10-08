import { readdirSync } from "node:fs";
import { join } from "node:path";
import { describe, expect, it } from "vitest";

import { WEB_APP_SEGMENTS, webAppSegment } from "./web-app";

const LOCALES = ["en", "ar", "fr", "es"];

describe("webAppSegment", () => {
  it("recognises app routes with and without a locale", () => {
    expect(webAppSegment("/en/track/history", LOCALES)).toEqual({ locale: "en", segment: "track" });
    expect(webAppSegment("/ar/welcome", LOCALES)).toEqual({ locale: "ar", segment: "welcome" });
    expect(webAppSegment("/dashboard", LOCALES)).toEqual({ locale: null, segment: "dashboard" });
  });

  it("leaves the public site alone, crisis help above all", () => {
    for (const path of [
      "/en",
      "/en/learn/pcos",
      "/ar/help-now",
      "/en/calculators/due-date",
      "/en/app",
      "/",
    ]) {
      expect(webAppSegment(path, LOCALES).segment).toBeNull();
    }
  });

  it("covers every route in the (app) group, so a new screen cannot leak open", () => {
    const group = join(__dirname, "../app/[locale]/(app)");
    const routes = readdirSync(group, { withFileTypes: true })
      .filter((d) => d.isDirectory())
      .map((d) => d.name);
    expect(routes.length).toBeGreaterThan(5);
    for (const route of routes) expect(WEB_APP_SEGMENTS.has(route), route).toBe(true);
  });
});
