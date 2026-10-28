import { JsonLd } from "@/components/seo/json-ld";
import { calculatorFaqJsonLd, type CalculatorFaqItem } from "@/lib/calculators/faq";

/**
 * The short question-and-answer list under a calculator (growth pack 04 §3.1).
 *
 * The questions are real headings and the answers are visible text, so the FAQPage
 * markup describes what is on the page and nothing else. Server component; renders
 * nothing when the calculator has no list.
 */
export function CalculatorFaq({ title, items }: { title: string; items: readonly CalculatorFaqItem[] }) {
  if (items.length === 0) return null;
  const jsonLd = calculatorFaqJsonLd(items);
  return (
    <section aria-labelledby="calculator-faq" className="flex flex-col gap-4">
      {jsonLd ? <JsonLd data={jsonLd} /> : null}
      <h2 id="calculator-faq" className="font-display text-xl text-text">
        {title}
      </h2>
      <div className="flex flex-col divide-y divide-border">
        {items.map(({ q, a }) => (
          <div key={q} className="flex flex-col gap-1 py-3 first:pt-0 last:pb-0">
            <h3 className="text-base font-semibold text-text">{q}</h3>
            <p className="text-sm leading-relaxed text-text-muted">{a}</p>
          </div>
        ))}
      </div>
    </section>
  );
}
