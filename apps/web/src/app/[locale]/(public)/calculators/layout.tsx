import type { ReactNode } from "react";
import { NextIntlClientProvider } from "next-intl";
import { getMessages, setRequestLocale } from "next-intl/server";
import { pickCalculatorClientMessages } from "@/i18n/client-namespaces";

type LayoutProps = { children: ReactNode; params: Promise<{ locale: string }> };

// The calculators' strings reach the browser only on calculator pages (see
// `CALCULATOR_CLIENT_NAMESPACES`). A nested provider replaces the context, so it carries
// the public set and the locale too.
//
// The locale comes from `params` and is set before any next-intl read: reading it from
// the request instead (`getLocale()`) made every calculator page dynamic (rendered per
// request, never prerendered) and streamed its <meta name="description"> into the body.
export default async function CalculatorsLayout({ children, params }: LayoutProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const messages = pickCalculatorClientMessages(await getMessages());
  return (
    <NextIntlClientProvider locale={locale} messages={messages}>
      {children}
    </NextIntlClientProvider>
  );
}
