import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { Inter, Fraunces, IBM_Plex_Sans_Arabic } from "next/font/google";
import { NextIntlClientProvider } from "next-intl";
import { getMessages, getTranslations, setRequestLocale } from "next-intl/server";
import { getDir, isLocale, routing } from "@/i18n/routing";
import { pickClientMessages } from "@/i18n/client-namespaces";
import { ThemeProvider } from "@/components/theme-provider";
import { CrisisHelpProvider } from "@/components/crisis/crisis-help-provider";
import { ogLocale, siteConfig } from "@/lib/seo/config";
import { localizedAlternates } from "@/lib/seo/metadata";
import { env } from "@/lib/env";
import "@femio/tokens/tokens.css";
import "../globals.css";

const inter = Inter({ subsets: ["latin"], variable: "--font-inter", display: "swap" });
const fraunces = Fraunces({ subsets: ["latin"], variable: "--font-fraunces", display: "swap" });
const plexArabic = IBM_Plex_Sans_Arabic({
  subsets: ["arabic"],
  weight: ["400", "500", "600", "700"],
  variable: "--font-plex-arabic",
  display: "swap",
});

type LayoutProps = {
  children: React.ReactNode;
  params: Promise<{ locale: string }>;
};

export function generateStaticParams() {
  return routing.locales.map((locale) => ({ locale }));
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ locale: string }>;
}): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "meta" });
  const title = t("title");
  const description = t("description");

  return {
    metadataBase: new URL(siteConfig.baseUrl),
    title: { default: title, template: `%s — ${siteConfig.name}` },
    description,
    applicationName: siteConfig.name,
    alternates: localizedAlternates(locale, "/"),
    openGraph: {
      type: "website",
      siteName: siteConfig.name,
      title,
      description,
      url: `${siteConfig.baseUrl}/${locale}`,
      locale: ogLocale[locale] ?? locale,
    },
    twitter: { card: "summary_large_image", title, description },
    robots: { index: true, follow: true },
    icons: { icon: "/icon.svg" },
    ...(env.NEXT_PUBLIC_GOOGLE_SITE_VERIFICATION
      ? { verification: { google: env.NEXT_PUBLIC_GOOGLE_SITE_VERIFICATION } }
      : {}),
  };
}

export default async function LocaleLayout({ children, params }: LayoutProps) {
  const { locale } = await params;
  if (!isLocale(locale)) notFound();
  setRequestLocale(locale);

  const fontVars = `${inter.variable} ${fraunces.variable} ${plexArabic.variable}`;

  // Send only the namespaces client components actually use (P1.11.2). Without this
  // the whole catalog is serialised into every page — see i18n/client-namespaces.ts.
  const clientMessages = pickClientMessages(await getMessages());

  return (
    <html lang={locale} dir={getDir(locale)} className={fontVars} suppressHydrationWarning>
      <body className={locale === "ar" ? "font-arabic" : "font-sans"}>
        {/* `locale` is passed explicitly, and it is not decoration (2026-08-23).
            Without it `useLocale()` in a client component resolves to the default
            locale, and every client component that *branches* on the locale rather
            than merely reading a message silently rendered the English version.
            There is exactly one such component and it is the worst possible one:
            `CrisisHelpProvider` calls `getCrisisContent(useLocale())`, so an Arabic
            reader got the English crisis launcher and an LTR English dialog — the
            copy the owner personally reviewed and approved in Arabic (ADR-063),
            unreachable in the locale it was approved for. `/ar/help-now` was
            correct throughout, because it is a server component, which is why this
            survived: the page looked right and the launcher on every other page did
            not. The two `[ar]` crisis e2e specs were failing and had been. */}
        <NextIntlClientProvider locale={locale} messages={clientMessages}>
          <ThemeProvider attribute="data-theme" defaultTheme="system" enableSystem disableTransitionOnChange>
            <CrisisHelpProvider>{children}</CrisisHelpProvider>
          </ThemeProvider>
        </NextIntlClientProvider>
      </body>
    </html>
  );
}
