import { describe, expect, it, vi } from "vitest";

// Outside a Next.js server render `next-intl/server` resolves to its client stub, which
// throws; the real `getRequestConfig` only returns the function it is given.
vi.mock("next-intl/server", () => ({ getRequestConfig: (fn: unknown) => fn }));

import config from "./request";
import { isLocale, routing } from "./routing";

/**
 * The per-request config must hand next-intl a *routing* locale. next-intl 4 builds
 * every `Link` href, `useRouter` push and `usePathname` from that value, so a
 * formatting tag such as `ar-u-nu-latn` there sends every Arabic link to a 404
 * (live from 2026-08-22 to 2026-10-28; ADR-074). Western digits are pinned by
 * `numbering.test.ts` instead.
 */
describe("request config", () => {
  for (const locale of routing.locales) {
    it(`returns the routing locale "${locale}" unchanged, with its catalog`, async () => {
      const result = await config({ requestLocale: Promise.resolve(locale) });
      expect(result.locale).toBe(locale);
      expect(isLocale(result.locale)).toBe(true);
      expect(Object.keys(result.messages ?? {}).length).toBeGreaterThan(0);
    });
  }

  it("falls back to the default locale for an unknown or missing request locale", async () => {
    expect((await config({ requestLocale: Promise.resolve("de") })).locale).toBe(routing.defaultLocale);
    expect((await config({ requestLocale: Promise.resolve(undefined) })).locale).toBe(routing.defaultLocale);
  });
});
