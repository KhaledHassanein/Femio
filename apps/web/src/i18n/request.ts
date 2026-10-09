import { getRequestConfig } from "next-intl/server";
import { isLocale, routing } from "./routing";
import { loadMessages } from "@/lib/i18n/ui-strings-loader";

// Per-request i18n config (P1.19). The local JSON catalogs are the base; the
// translation portal's human-approved `ui_strings` rows are overlaid on top
// (cached, approved-only). If nothing is approved or the DB is unavailable, the
// app serves pure JSON — no behaviour change. This is the ADR-009/ADR-014 swap point.
export default getRequestConfig(async ({ requestLocale }) => {
  const requested = await requestLocale;
  const locale = isLocale(requested) ? requested : routing.defaultLocale;

  const json = (await import(`../../messages/${locale}.json`)).default;
  // The default locale never takes the DB overlay — English is the master and it
  // lives in the repo (ADR-064).
  const messages = await loadMessages(locale, json, routing.defaultLocale);

  return {
    locale,
    messages,
    /**
     * Arabic renders **Western digits** (owner decision, R3.5.2, 2026-08-22), and
     * `numbering.test.ts` pins that bare `ar` resolves to them.
     *
     * The returned `locale` must stay a **route** locale. Returning
     * `ar-u-nu-latn` here (2026-08-23 to 2026-10-09) made `useLocale()` return it,
     * so every next-intl `Link` on the Arabic site pointed at `/ar-u-nu-latn/...`
     * and 404'd: the Arabic site could only be read by typing URLs. If the digits
     * ever need pinning again, pass `numberingSystem: "latn"` where we format,
     * never through this field. `request.test.ts` guards it.
     */
    formats: {
      dateTime: { medium: { dateStyle: "medium" }, long: { dateStyle: "long" } },
    },
  };
});
