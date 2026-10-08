import type { ReactNode } from "react";
import { NextIntlClientProvider } from "next-intl";
import { getLocale, getMessages } from "next-intl/server";
import { pickCalculatorClientMessages } from "@/i18n/client-namespaces";

// The calculators' strings reach the browser only on calculator pages (see
// `CALCULATOR_CLIENT_NAMESPACES`). A nested provider replaces the context, so it carries
// the public set and the locale too, as the `(app)` layout does.
export default async function CalculatorsLayout({ children }: { children: ReactNode }) {
  const messages = pickCalculatorClientMessages(await getMessages());
  const locale = await getLocale();
  return (
    <NextIntlClientProvider locale={locale} messages={messages}>
      {children}
    </NextIntlClientProvider>
  );
}
