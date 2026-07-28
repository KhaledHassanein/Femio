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
  const messages = await loadMessages(locale, json);

  return { locale, messages };
});
