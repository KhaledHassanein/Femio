import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { Newsreader, Plus_Jakarta_Sans, Noto_Naskh_Arabic, IBM_Plex_Sans_Arabic } from "next/font/google";
import { NextIntlClientProvider } from "next-intl";
import { getMessages, getTranslations, setRequestLocale } from "next-intl/server";
import { getDir, isLocale, routing } from "@/i18n/routing";
import { pickClientMessages } from "@/i18n/client-namespaces";
import { ThemeProvider } from "@/components/theme-provider";
import { CrisisHelpProvider } from "@/components/crisis/crisis-help-provider";
import { ogLocale, siteConfig } from "@/lib/seo/config";
import { localizedAlternates } from "@/lib/seo/metadata";
import { env } from "@/lib/env";
import { VisitMeasurement } from "@/lib/analytics/visit-measurement";
import "@femio/tokens/tokens.css";
import "../globals.css";

// Type v3 "Dusk Bloom" (docs/30_REVAMP/03 §3.3). Each script gets a real face rather
// than a fallback: Newsreader and Noto Naskh Arabic share the display role, Plus
// Jakarta Sans and IBM Plex Sans Arabic share the UI role. Tailwind's family stacks list
// both, and the browser picks per glyph, so a mixed Arabic/Latin line renders each run
// in its own face with no per-locale branching.
const sansLatin = Plus_Jakarta_Sans({
  subsets: ["latin"],
  variable: "--font-sans-latin",
  display: "swap",
});
const displayLatin = Newsreader({
  subsets: ["latin"],
  axes: ["opsz"],
  variable: "--font-display-latin",
  display: "swap",
});
const naskh = Noto_Naskh_Arabic({
  subsets: ["arabic"],
  weight: ["500", "600", "700"],
  variable: "--font-naskh",
  display: "swap",
  // Not preloaded: an English page must not download Arabic fonts up front. The
  // browser fetches them the moment Arabic text needs them (P2 page-weight pass:
  // 8 preloaded font files on every page became 2).
  preload: false,
});
// The Arabic UI face is preloaded: Arabic is the first language, and a late swap of the
// body text was the largest visual change on every Arabic page (Lighthouse Speed Index
// 4.7 s against 2.2 s for the same page in English, 2026-10-28). Two weights keep that to
// two files; font-medium and font-bold fall to the nearest.
const plexArabic = IBM_Plex_Sans_Arabic({
  subsets: ["arabic"],
  weight: ["400", "600"],
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
      images: [{ url: `/og/${locale}.png`, width: 1200, height: 630, alt: title }],
    },
    twitter: { card: "summary_large_image", title, description, images: [`/og/${locale}.png`] },
    robots: { index: true, follow: true },
    // The full set lives under /icons (scripts/brand/generate-icons.mjs); the SVG
    // is first because modern browsers prefer it and it scales to any tab size.
    icons: {
      icon: [
        { url: "/icon.svg", type: "image/svg+xml" },
        { url: "/icons/icon-32.png", sizes: "32x32", type: "image/png" },
        { url: "/icons/icon-16.png", sizes: "16x16", type: "image/png" },
      ],
      apple: [{ url: "/icons/icon-180.png", sizes: "180x180", type: "image/png" }],
      shortcut: ["/favicon.ico"],
    },
    ...(env.NEXT_PUBLIC_GOOGLE_SITE_VERIFICATION
      ? { verification: { google: env.NEXT_PUBLIC_GOOGLE_SITE_VERIFICATION } }
      : {}),
  };
}

export default async function LocaleLayout({ children, params }: LayoutProps) {
  const { locale } = await params;
  if (!isLocale(locale)) notFound();
  setRequestLocale(locale);

  const fontVars = `${sansLatin.variable} ${displayLatin.variable} ${naskh.variable} ${plexArabic.variable}`;

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
        {/* ADR-075 as amended 2026-11-24: cookieless, aggregate visit counts (path only). */}
        <VisitMeasurement />
      </body>
    </html>
  );
}
