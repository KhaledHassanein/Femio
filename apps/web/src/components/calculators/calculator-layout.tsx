import type { ReactNode } from "react";
import { ArrowLeft, Info } from "lucide-react";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Link } from "@/i18n/navigation";
import { JsonLd } from "@/components/seo/json-ld";
import { AppHandoffCard } from "@/components/site/app-handoff-card";
import { CalculatorFaq } from "@/components/calculators/calculator-faq";
import type { CalculatorFaqItem } from "@/lib/calculators/faq";
import { siteConfig } from "@/lib/seo/config";
import { webApplicationJsonLd } from "@/lib/seo/jsonld";

/**
 * Shared chrome for every calculator page (02_DESIGN_SPEC §2.8): back link, the
 * heading, the tool itself (the page's one raised element), the hand-off to the
 * app, the FAQ (growth pack §3.1) and the wellness line every tool carries (MR-40). Server component.
 */
export function CalculatorLayout({
  title,
  intro,
  disclaimer,
  backLabel,
  locale,
  path,
  faqTitle,
  faq = [],
  children,
}: {
  title: string;
  intro: string;
  disclaimer: string;
  backLabel: string;
  locale: string;
  path: string;
  /** Heading and entries of the FAQ under the tool; omitted entries render nothing. */
  faqTitle?: string;
  faq?: readonly CalculatorFaqItem[];
  children: ReactNode;
}) {
  const url = `${siteConfig.baseUrl}/${locale}${path}`;
  return (
    <main className="mx-auto flex w-full max-w-2xl flex-col gap-6 px-4 py-6 md:px-6 md:py-12">
      <JsonLd data={webApplicationJsonLd({ name: title, description: intro, url, locale })} />
      <Link href="/calculators" className="inline-flex items-center gap-1 text-sm text-text-link rtl:flex-row-reverse">
        <ArrowLeft className="size-4 rtl:rotate-180" aria-hidden />
        {backLabel}
      </Link>
      <div className="flex flex-col gap-2">
        <h1 className="font-display text-3xl leading-tight tracking-tighter text-text rtl:tracking-normal">{title}</h1>
        <p className="text-base text-text-muted">{intro}</p>
      </div>
      {children}
      <AppHandoffCard />
      {faqTitle ? <CalculatorFaq title={faqTitle} items={faq} /> : null}
      <Alert variant="info" icon={<Info className="size-5" />}>
        <AlertDescription>{disclaimer}</AlertDescription>
      </Alert>
    </main>
  );
}
