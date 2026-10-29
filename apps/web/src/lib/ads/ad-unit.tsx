"use client";

import { useEffect, useRef, useState } from "react";
import { waitForAdConsent } from "./ad-consent";
import type { AdUnitConfig } from "./placements";

/**
 * One responsive AdSense unit, labelled, filled only after consent (R6.8, ADR-075).
 *
 * Client component because AdSense fills a unit only after `adsbygoogle.push({})` runs
 * in the browser, once per `<ins>`. The box is hidden until the visitor's consent tool
 * grants `ad_storage` (`./ad-consent.ts`), so a reader who has not answered, or who
 * declined, sees no ad, no label and no empty space: the privacy notice's "only after you
 * allow them" is a property of this component, not a promise. The shift when the box
 * appears follows the visitor's own tap on Allow.
 *
 * The label comes in as a prop from a server component, which reads it from the `ads`
 * message namespace, so this module reads no messages and the namespace never ships to
 * the browser.
 *
 * What it never does: it reads nothing from the page, pushes nothing to `dataLayer`, and
 * renders nothing when `config` is null (publisher id or slot unset). Where it may sit is
 * decided in `./placements.ts`.
 */
export function AdUnit({ config, label }: { config: AdUnitConfig | null; label: string }) {
  const [granted, setGranted] = useState(false);
  const pushed = useRef(false);

  useEffect(() => {
    if (!config) return;
    return waitForAdConsent(() => setGranted(true));
  }, [config]);

  useEffect(() => {
    if (!config || !granted || pushed.current) return;
    pushed.current = true;
    const w = window as Window & { adsbygoogle?: unknown[] };
    (w.adsbygoogle = w.adsbygoogle || []).push({});
  }, [config, granted]);

  if (!config) return null;
  return (
    <aside
      aria-label={label}
      data-ad-placement={config.placement}
      data-ad-state={granted ? "granted" : "waiting"}
      hidden={!granted}
      className="flex flex-col gap-1 border-y border-border py-3"
    >
      <span className="text-2xs uppercase tracking-wide text-text-subtle">{label}</span>
      <ins
        className="adsbygoogle block min-h-[100px] w-full"
        data-ad-client={config.client}
        data-ad-slot={config.slot}
        data-ad-format="auto"
        data-full-width-responsive="true"
      />
    </aside>
  );
}
