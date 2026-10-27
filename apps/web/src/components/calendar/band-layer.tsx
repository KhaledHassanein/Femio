import { bandSegment, type Band, type BandKind } from "@/lib/calendar/grid";
import { cn } from "@/lib/utils";

/**
 * The bands drawn behind one week row (02_DESIGN_SPEC §2.5).
 *
 * Facts are filled, estimates are tinted, dotted or faded. The layer is
 * `aria-hidden`: the day buttons' labels and the result sentence carry the meaning,
 * so a screen reader hears "likely fertile, estimate" rather than a coloured box.
 * Positioned as a 7-column grid over the row, so `dir="rtl"` mirrors it for free.
 */
const KIND_CLASS: Record<BandKind, string> = {
  period: "bg-log-period-alt",
  fertile: "bg-success-soft",
  nextPeriod: "bg-log-period-alt border-y-2 border-dashed border-log-period",
  testFrom: "bg-primary-soft",
  term: "bg-prediction-band/24",
  cycleSpan: "bg-surface-sunken",
};

export function BandLayer({ bands, week }: { bands: readonly Band[]; week: ReadonlyArray<string | null> }) {
  const segments = bands
    .map((band) => ({ band, segment: bandSegment(band, week) }))
    .filter((x): x is { band: Band; segment: NonNullable<ReturnType<typeof bandSegment>> } => x.segment !== null);
  if (segments.length === 0) return null;
  return (
    <div aria-hidden className="pointer-events-none absolute inset-0 grid grid-cols-7 gap-1">
      {segments.map(({ band, segment }) => {
        const softStart = segment.isStart && band.softStart;
        const softEnd = segment.isEnd && band.softEnd;
        return (
          <span
            key={band.id}
            className={cn(
              "band-grow my-auto h-8 self-center",
              KIND_CLASS[band.kind],
              segment.isStart && "rounded-s-pill",
              segment.isEnd && "rounded-e-pill",
              softStart && "band-soft-s",
              softEnd && "band-soft-e",
              band.breathe && "band-breathe",
            )}
            style={{
              gridColumn: `${segment.colStart} / ${segment.colEnd + 1}`,
              ...(band.breathe ? ({ "--breathe-scale": "1.12" } as React.CSSProperties) : {}),
            }}
          />
        );
      })}
    </div>
  );
}
