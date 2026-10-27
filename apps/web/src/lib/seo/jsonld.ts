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
    logo: `${siteConfig.baseUrl}/icons/icon-512.png`,
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

export function faqPageJsonLd(items: { question: string; answer: string }[]) {
  return {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    mainEntity: items.map((it) => ({
      "@type": "Question",
      name: it.question,
      acceptedAnswer: { "@type": "Answer", text: it.answer },
    })),
  };
}

export function definedTermSetJsonLd(args: {
  name: string;
  url: string;
  terms: { term: string; definition: string }[];
}) {
  return {
    "@context": "https://schema.org",
    "@type": "DefinedTermSet",
    name: args.name,
    url: args.url,
    hasDefinedTerm: args.terms.map((t) => ({
      "@type": "DefinedTerm",
      name: t.term,
      description: t.definition,
    })),
  };
}

// Author / medical-reviewer bio page (P1.9b.3b). E-E-A-T: who wrote or approved
// Femio's health content, with their credentials and verifiable professional
// profiles (`sameAs`). Empty fields are omitted rather than emitted blank.
export function personJsonLd(args: {
  name: string;
  url: string;
  description?: string | null;
  credentials?: string | null;
  jobTitle?: string | null;
  affiliation?: string | null;
  sameAs?: string[];
}) {
  return {
    "@context": "https://schema.org",
    "@type": "Person",
    name: args.name,
    url: args.url,
    ...(args.description ? { description: args.description } : {}),
    ...(args.credentials ? { honorificSuffix: args.credentials } : {}),
    ...(args.jobTitle ? { jobTitle: args.jobTitle } : {}),
    ...(args.affiliation
      ? { affiliation: { "@type": "Organization", name: args.affiliation } }
      : {}),
    ...(args.sameAs && args.sameAs.length > 0 ? { sameAs: args.sameAs } : {}),
    worksFor: { "@type": "Organization", name: siteConfig.name, url: siteConfig.baseUrl },
  };
}

/**
 * `Article` for a health page, carrying the E-E-A-T signals doc 15 §8 requires:
 * a named author, a named medical reviewer with credentials, and the dates.
 * Emitted alongside `MedicalWebPage` — they answer different questions (what
 * kind of page vs. who stands behind it), and Google reads both.
 */
export function articleJsonLd(args: {
  headline: string;
  description: string;
  url: string;
  locale: string;
  authors?: { name: string; credentials?: string | null; url?: string }[];
  reviewer?: { name: string; credentials?: string | null; url?: string } | null;
  datePublished?: string | null;
  dateModified?: string | null;
}) {
  const person = (p: { name: string; credentials?: string | null; url?: string }) => ({
    "@type": "Person",
    name: p.name,
    ...(p.credentials ? { honorificSuffix: p.credentials } : {}),
    ...(p.url ? { url: p.url } : {}),
  });

  return {
    "@context": "https://schema.org",
    "@type": "Article",
    headline: args.headline,
    description: args.description,
    url: args.url,
    inLanguage: args.locale,
    ...(args.authors && args.authors.length > 0 ? { author: args.authors.map(person) } : {}),
    // `reviewedBy` is the signal that a clinician checked this, not merely that
    // someone edited it — the distinction doc 15 is built around.
    ...(args.reviewer ? { reviewedBy: person(args.reviewer) } : {}),
    ...(args.datePublished ? { datePublished: args.datePublished.slice(0, 10) } : {}),
    ...(args.dateModified ? { dateModified: args.dateModified.slice(0, 10) } : {}),
    publisher: { "@type": "Organization", name: siteConfig.name, url: siteConfig.baseUrl },
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
