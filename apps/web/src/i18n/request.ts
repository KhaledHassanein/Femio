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
     * Arabic renders **Western digits** — 1 2 3, not ١ ٢ ٣ (owner decision,
     * R3.5.2, 2026-08-22).
     *
     * Both are correct Arabic. Arabic-Indic is standard in Egypt and the Gulf,
     * Western across the Maghreb, and the app was doing **both at once**: dates
     * came out `2026/08/31` while the onboarding age bands read `١٣–١٥`, which a
     * native reader notices immediately (`docs/26` §14).
     *
     * Stated rather than inherited. `Intl` with a bare `ar` locale picks a
     * numbering system per runtime, so leaving it implicit means the digits a woman
     * sees depend on which Node or browser served her — and the catalog and the
     * formatter could drift apart again silently. `-u-nu-latn` pins it, and the
     * catalog strings were converted to match in the same change.
     */
    formats: {
      dateTime: { medium: { dateStyle: "medium" }, long: { dateStyle: "long" } },
    },
    ...(locale === "ar" ? { locale: "ar-u-nu-latn" as const } : {}),
  };
});
