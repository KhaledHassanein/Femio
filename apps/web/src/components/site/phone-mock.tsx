/**
 * A drawn phone showing the app's Today screen (D8): the website's picture of the
 * product until real screenshots exist. Built from tokens, not an image, so it is
 * crisp at any size, follows the theme and reads right-to-left in Arabic.
 *
 * The prediction is a band, never a ring (docs/25 §5a), and says how sure it is.
 */
export type PhoneMockStrings = {
  day: string;
  title: string;
  range: string;
  note: string;
  period: string;
};

// A 28-day cycle as phase segments, in days: the same order the app's band uses.
const PHASES = [
  { key: "menstrual", days: 5, className: "bg-phase-menstrual" },
  { key: "follicular", days: 7, className: "bg-phase-follicular" },
  { key: "ovulatory", days: 4, className: "bg-phase-ovulatory" },
  { key: "luteal", days: 12, className: "bg-phase-luteal" },
] as const;
const TODAY = 12;
const LENGTH = 28;

export function PhoneMock({ strings }: { strings: PhoneMockStrings }) {
  return (
    <div
      aria-hidden
      className="relative mx-auto w-[248px] shrink-0 rounded-[2.75rem] bg-[#1d0f1c] p-2.5 shadow-[0_30px_80px_-20px_rgb(0_0_0/0.55)] ring-1 ring-white/15"
    >
      <div className="absolute start-1/2 top-3.5 z-10 h-4 w-16 -translate-x-1/2 rounded-pill bg-black rtl:translate-x-1/2" />
      <div className="flex h-[500px] flex-col gap-4 overflow-hidden rounded-[2.25rem] bg-bg px-4 pb-5 pt-10 text-text">
        <div className="flex items-center justify-between">
          <span className="font-display text-lg lowercase leading-none text-primary" dir="ltr">
            femio
          </span>
          <span className="text-2xs text-text-muted">{strings.day}</span>
        </div>

        <div className="hero-glow flex flex-col gap-2 rounded-lg bg-primary-solid p-4 text-primary-fg-solid">
          <span className="text-2xs uppercase tracking-widest opacity-80">{strings.title}</span>
          <span className="font-display text-xl leading-tight">{strings.range}</span>
          <span className="text-2xs opacity-85">{strings.note}</span>
        </div>

        <div className="flex flex-col gap-2">
          <div className="relative flex h-3 w-full overflow-hidden rounded-pill">
            {PHASES.map((p) => (
              <span
                key={p.key}
                className={p.className}
                style={{ width: `${(p.days / LENGTH) * 100}%` }}
              />
            ))}
          </div>
          <div className="relative h-3">
            <span
              className="absolute top-0 size-3 -translate-x-1/2 rounded-round border-2 border-bg bg-text shadow rtl:translate-x-1/2"
              style={{ insetInlineStart: `${((TODAY - 0.5) / LENGTH) * 100}%` }}
            />
          </div>
        </div>

        <div className="rounded-md border border-border bg-surface p-3 text-xs text-text-muted">
          {strings.period}
        </div>

        <div className="mt-auto grid grid-cols-4 gap-2">
          {["bg-log-period-alt", "bg-log-symptom-alt", "bg-log-mood-alt", "bg-log-vital-alt"].map(
            (c) => (
              <span key={c} className={`h-12 rounded-md ${c}`} />
            ),
          )}
        </div>
      </div>
    </div>
  );
}
