import { cn } from "@/lib/utils";

export type LegendKey = "start" | "period" | "fertile" | "ovulation" | "nextPeriod" | "testFrom" | "term" | "cycleSpan";

const SWATCH: Record<LegendKey, string> = {
  start: "rounded-round bg-accent-solid",
  period: "rounded-xs bg-log-period-alt",
  fertile: "rounded-xs bg-success-soft",
  ovulation: "rounded-round bg-phase-ovulatory",
  nextPeriod: "rounded-xs border border-dashed border-log-period bg-log-period-alt",
  testFrom: "rounded-xs bg-primary-soft",
  term: "rounded-xs bg-prediction-band/40",
  cycleSpan: "rounded-xs bg-surface-sunken",
};

/** Only the marks in use on this view; swatches are decorative, the words carry it. */
export function CalendarLegend({ items }: { items: ReadonlyArray<{ key: LegendKey; label: string }> }) {
  if (items.length === 0) return null;
  return (
    <ul className="flex flex-wrap gap-x-4 gap-y-1 text-2xs text-text-muted">
      {items.map((item) => (
        <li key={item.key} className="flex items-center gap-1.5">
          <span aria-hidden className={cn("inline-block size-[14px] shrink-0", SWATCH[item.key])} />
          {item.label}
        </li>
      ))}
    </ul>
  );
}
