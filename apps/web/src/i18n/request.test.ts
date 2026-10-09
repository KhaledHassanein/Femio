import { describe, expect, it, vi } from "vitest";
import { routing } from "./routing";

vi.mock("next-intl/server", () => ({ getRequestConfig: (fn: unknown) => fn }));
vi.mock("@/lib/i18n/ui-strings-loader", () => ({
  loadMessages: async (_l: string, json: unknown) => json,
}));

/**
 * The locale the request config returns is the locale every next-intl `Link`
 * prefixes. From 2026-08-23 to 2026-10-09 Arabic returned `ar-u-nu-latn` (to pin
 * digits), and every link on the Arabic site went to `/ar-u-nu-latn/...`, a 404.
 */
describe("request config", () => {
  it("returns a route locale for every locale we ship", async () => {
    const { default: config } = await import("./request");
    const run = config as unknown as (p: { requestLocale: Promise<string> }) => Promise<{ locale: string }>;
    for (const locale of routing.locales) {
      const out = await run({ requestLocale: Promise.resolve(locale) });
      expect(out.locale).toBe(locale);
    }
  });
});
