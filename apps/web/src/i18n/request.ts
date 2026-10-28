import { getRequestConfig } from "next-intl/server";
import { isLocale, routing } from "./routing";

// Per-request i18n config. The JSON catalogs in `messages/` are the only source:
// the database overlay (`ui_strings`, ADR-009/ADR-014) was retired with the web
// tracker on 2026-10-27, so a page view never touches a server.
//
// The `locale` returned here MUST be one of `routing.locales`. next-intl 4 treats it
// as the routing locale: `Link`, `useRouter`, `usePathname` and `getLocale()` build
// every href from it. From 2026-08-22 to 2026-10-28 Arabic was returned as
// `ar-u-nu-latn` to pin Western digits (ADR-069), and every internal link on every
// Arabic page pointed at `/ar-u-nu-latn/…`, a 404 (found by Lighthouse run 3,
// `testing-results/2026-10-28-lighthouse/`). Western digits are pinned instead by
// `numbering.test.ts`, which fails the gate the day a runtime resolves bare `ar` to
// Arabic-Indic digits; `request.test.ts` fails it if this file ever returns a locale
// that is not a route. ADR-074.
export default getRequestConfig(async ({ requestLocale }) => {
  const requested = await requestLocale;
  const locale = isLocale(requested) ? requested : routing.defaultLocale;

  const messages = (await import(`../../messages/${locale}.json`)).default;

  return {
    locale,
    messages,
    formats: {
      dateTime: { medium: { dateStyle: "medium" }, long: { dateStyle: "long" } },
    },
  };
});
