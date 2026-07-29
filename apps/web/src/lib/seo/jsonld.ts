import { siteConfig } from "./config";

// Schema.org builders (femio-seo-aso §on-page). Returned as plain objects; render
// with the <JsonLd> component. MedicalWebPage/FAQPage builders arrive with content
// pages (P1.9).

export function websiteJsonLd(locale: string) {
  return {
    "@context": "https://schema.org",
    "@type": "WebSite",
    name: siteConfig.name,
    url: `${siteConfig.baseUrl}/${locale}`,
    inLanguage: locale,
  };
}

export function organizationJsonLd() {
  return {
    "@context": "https://schema.org",
    "@type": "Organization",
    name: siteConfig.name,
    url: siteConfig.baseUrl,
    logo: `${siteConfig.baseUrl}/icons/app-icon.svg`,
  };
}

export function webApplicationJsonLd(args: {
  name: string;
  description: string;
  url: string;
  locale: string;
}) {
  return {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    name: args.name,
    description: args.description,
    url: args.url,
    inLanguage: args.locale,
    applicationCategory: "HealthApplication",
    operatingSystem: "Web",
    isAccessibleForFree: true,
    offers: { "@type": "Offer", price: "0", priceCurrency: "USD" },
    publisher: { "@type": "Organization", name: siteConfig.name, url: siteConfig.baseUrl },
  };
}

// Content article page (P1.6.2/P1.11.1). MedicalWebPage carries the E-E-A-T
// signals (last reviewed, description); the medical-review sign-off happens in the CMS.
export function medicalWebPageJsonLd(args: {
  title: string;
  description: string;
  url: string;
  locale: string;
  lastReviewed?: string | null;
}) {
  return {
    "@context": "https://schema.org",
    "@type": "MedicalWebPage",
    name: args.title,
    description: args.description,
    url: args.url,
    inLanguage: args.locale,
    isPartOf: { "@type": "WebSite", name: siteConfig.name, url: siteConfig.baseUrl },
    ...(args.lastReviewed ? { lastReviewed: args.lastReviewed.slice(0, 10) } : {}),
  };
}

export function breadcrumbJsonLd(items: { name: string; url: string }[]) {
  return {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    itemListElement: items.map((it, i) => ({
      "@type": "ListItem",
      position: i + 1,
      name: it.name,
      item: it.url,
    })),
  };
}
