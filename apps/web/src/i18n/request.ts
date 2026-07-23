import { getRequestConfig } from "next-intl/server";
import { isLocale, routing } from "./routing";

// Per-request i18n config. Messages are local JSON now; they will later be served
// from the DB-backed translation portal (ui_strings, P1.19) — this loader is the swap point.
export default getRequestConfig(async ({ requestLocale }) => {
  const requested = await requestLocale;
  const locale = isLocale(requested) ? requested : routing.defaultLocale;

  return {
    locale,
    messages: (await import(`../../messages/${locale}.json`)).default,
  };
});
