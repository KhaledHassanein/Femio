"use client";

import { useState } from "react";
import { ShieldAlert, Phone } from "lucide-react";
import { chipVariants } from "@/components/ui/chip";
import { cn } from "@/lib/utils";

/**
 * Country picker for the help-now page: two toggle buttons (Egypt, Saudi Arabia), and
 * that country's numbers only once one is chosen, so a number is never presented as
 * global. All text arrives already translated from the server page (`helpNow`
 * namespace), so this file holds no copy and needs no message namespace on the client.
 *
 * Emergency services and support lines are drawn apart (docs/compliance/CRISIS_RESOURCES.md):
 * emergency rows use the danger tokens with an icon, support rows the neutral surface.
 * Each row is a 56px `tel:` link, number large, service name small, source beside it.
 *
 * The same `CountryList` is also rendered inside `<noscript>` by the page, so a
 * reader without JavaScript sees both countries, each under its own name.
 */
export type NumberRow = {
  id: string;
  number: string;
  label: string;
  callLabel: string;
  sourceUrl: string;
};
export type NumberGroup = { kind: "emergency" | "support"; title: string; rows: NumberRow[] };
export type CountryBlock = { id: string; name: string; groups: NumberGroup[] };

export function CountryList({
  country,
  sourceLabel,
}: {
  country: CountryBlock;
  sourceLabel: string;
}) {
  return (
    <div className="flex flex-col gap-5">
      {country.groups.map((group) => (
        <section key={group.kind} className="flex flex-col gap-2">
          <h4 className="text-sm font-semibold text-text">{group.title}</h4>
          <ul className="flex flex-col gap-2">
            {group.rows.map((row) => (
              <li key={row.id} className="flex flex-col gap-1">
                <a
                  href={`tel:${row.number}`}
                  aria-label={`${row.label}: ${row.callLabel}`}
                  className={cn(
                    "flex min-h-14 items-center gap-3 rounded-md border px-4 py-2",
                    group.kind === "emergency"
                      ? "border-danger-border bg-danger-soft text-danger-text"
                      : "border-border bg-surface-sunken text-text",
                  )}
                >
                  {group.kind === "emergency" ? (
                    <ShieldAlert className="size-5 shrink-0" aria-hidden />
                  ) : (
                    <Phone className="size-5 shrink-0" aria-hidden />
                  )}
                  <span className="flex flex-col">
                    <span dir="ltr" className="text-start text-xl font-bold tabular-nums">
                      {row.number}
                    </span>
                    <span className="text-sm">{row.label}</span>
                  </span>
                </a>
                <a
                  href={row.sourceUrl}
                  rel="noreferrer"
                  referrerPolicy="no-referrer"
                  target="_blank"
                  className="ms-1 w-fit text-2xs text-text-link underline"
                >
                  {sourceLabel}
                </a>
              </li>
            ))}
          </ul>
        </section>
      ))}
    </div>
  );
}

export function CountryNumbers({
  prompt,
  countries,
  sourceLabel,
}: {
  prompt: string;
  countries: CountryBlock[];
  sourceLabel: string;
}) {
  const [chosen, setChosen] = useState<string | null>(null);
  const current = countries.find((c) => c.id === chosen) ?? null;

  return (
    <div className="flex flex-col gap-4">
      <p className="text-sm text-text-muted" id="country-prompt">
        {prompt}
      </p>
      <div role="group" aria-labelledby="country-prompt" className="flex flex-wrap gap-2">
        {countries.map((c) => (
          <button
            key={c.id}
            type="button"
            aria-pressed={chosen === c.id}
            onClick={() => setChosen(chosen === c.id ? null : c.id)}
            className={chipVariants({ selected: chosen === c.id })}
          >
            {c.name}
          </button>
        ))}
      </div>
      {current ? (
        <div aria-live="polite" className="flex flex-col gap-3">
          <h3 className="font-display text-lg text-text">{current.name}</h3>
          <CountryList country={current} sourceLabel={sourceLabel} />
        </div>
      ) : null}
    </div>
  );
}
