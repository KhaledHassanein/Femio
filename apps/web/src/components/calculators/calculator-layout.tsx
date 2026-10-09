import type { ReactNode } from "react";
import { ArrowLeft, Info, Lock } from "lucide-react";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Link } from "@/i18n/navigation";
import { JsonLd } from "@/components/seo/json-ld";
import { siteConfig } from "@/lib/seo/config";
import { webApplicationJsonLd } from "@/lib/seo/jsonld";
import { PageView } from "@/components/analytics/page-view";

// Shared chrome for every calculator page: back link, heading, the interactive
// tool (children), and the standard disclaimer. Server component (no hooks).
export function CalculatorLayout({
  title,
  intro,
  disclaimer,
  privateNote,
  backLabel,
  appCta,
  appCtaLink,
  locale,
  path,
  children,
}: {
  title: string;
  intro: string;
  disclaimer: string;
  /** "Calculated in your browser": true, and the thing a cautious woman wants to know first. */
  privateNote?: string;
  backLabel: string;
  /** The bridge to the product (D8): every result can be tracked in the app. */
  appCta?: string;
  appCtaLink?: string;
  locale: string;
  path: string;
  children: ReactNode;
}) {
  const url = `${siteConfig.baseUrl}/${locale}${path}`;
  return (
    <main className="mx-auto flex w-full max-w-2xl flex-col gap-6 px-6 py-12">
      <PageView area="calculators" />
      <JsonLd data={webApplicationJsonLd({ name: title, description: intro, url, locale })} />
      <Link
        href="/calculators"
        className="inline-flex items-center gap-1 text-sm text-text-link rtl:flex-row-reverse"
      >
        <ArrowLeft className="size-4 rtl:rotate-180" aria-hidden />
        {backLabel}
      </Link>
      <div className="flex flex-col gap-1">
        <h1 className="font-display text-2xl text-text">{title}</h1>
        <p className="text-sm text-text-muted">{intro}</p>
        {privateNote ? (
          <p className="flex items-center gap-1.5 text-xs text-text-subtle">
            <Lock className="size-3.5 shrink-0" aria-hidden />
            {privateNote}
          </p>
        ) : null}
      </div>
      {children}
      {appCta && appCtaLink ? (
        <p className="flex flex-wrap items-center gap-x-2 gap-y-1 rounded-lg bg-primary-soft px-5 py-4 text-sm text-primary-soft-text">
          <span>{appCta}</span>
          <Link href="/app" className="font-semibold underline underline-offset-4">
            {appCtaLink}
          </Link>
        </p>
      ) : null}
      <Alert variant="info" icon={<Info className="size-5" />}>
        <AlertDescription>{disclaimer}</AlertDescription>
      </Alert>
    </main>
  );
}
