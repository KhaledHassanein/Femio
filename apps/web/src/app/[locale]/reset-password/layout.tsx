import type { ReactNode } from "react";
import { NextIntlClientProvider } from "next-intl";
import { getLocale, getMessages } from "next-intl/server";
import { pickAuthClientMessages } from "@/i18n/client-namespaces";

// Sign-in, onboarding and reset-password strings reach the browser only on these pages
// (see `AUTH_CLIENT_NAMESPACES`); with the web app closed (D8) they redirect to /app.
export default async function AuthLayout({ children }: { children: ReactNode }) {
  const messages = pickAuthClientMessages(await getMessages());
  const locale = await getLocale();
  return (
    <NextIntlClientProvider locale={locale} messages={messages}>
      {children}
    </NextIntlClientProvider>
  );
}
