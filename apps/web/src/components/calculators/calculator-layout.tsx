import type { ReactNode } from "react";
import { ArrowLeft, Info } from "lucide-react";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Link } from "@/i18n/navigation";

// Shared chrome for every calculator page: back link, heading, the interactive
// tool (children), and the standard disclaimer. Server component (no hooks).
export function CalculatorLayout({
  title,
  intro,
  disclaimer,
  backLabel,
  children,
}: {
  title: string;
  intro: string;
  disclaimer: string;
  backLabel: string;
  children: ReactNode;
}) {
  return (
    <main className="mx-auto flex w-full max-w-2xl flex-col gap-6 px-6 py-12">
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
      </div>
      {children}
      <Alert variant="info" icon={<Info className="size-5" />}>
        <AlertDescription>{disclaimer}</AlertDescription>
      </Alert>
    </main>
  );
}
