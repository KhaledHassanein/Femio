/**
 * Which message namespaces reach the browser.
 *
 * Server components read the whole catalog on the server and ship rendered HTML.
 * Client components (`"use client"`) need their strings serialised into the page,
 * and `NextIntlClientProvider` would otherwise send the entire catalog on every
 * page. So the root layout sends only the namespaces a client component actually
 * uses, and `scripts/i18n/client-namespaces-lint.mjs` fails the gate when a
 * client component reads a namespace that is not listed (a runtime error in
 * someone's browser) or when a listed namespace has no client reader (weight
 * shipped for nothing).
 *
 * The website is static and has no signed-in area (2026-10-27), so there is one
 * public list plus the calculators, which are client components because they
 * compute in the browser and never send a date anywhere.
 */
import type { AbstractIntlMessages } from "next-intl";

export const PUBLIC_CLIENT_NAMESPACES = ["search", "tools", "notFound", "theme", "locale"] as const;

export const CALCULATOR_CLIENT_NAMESPACES = ["calculators"] as const;

export const CLIENT_NAMESPACES = [...PUBLIC_CLIENT_NAMESPACES, ...CALCULATOR_CLIENT_NAMESPACES] as const;

export type ClientNamespace = (typeof CLIENT_NAMESPACES)[number];

function pick(messages: AbstractIntlMessages, names: readonly string[]): AbstractIntlMessages {
  const out: AbstractIntlMessages = {};
  for (const name of names) {
    const value = messages[name];
    if (value !== undefined) out[name] = value;
  }
  return out;
}

/** Messages for the root locale layout: every page gets these. */
export function pickClientMessages(messages: AbstractIntlMessages): AbstractIntlMessages {
  return pick(messages, PUBLIC_CLIENT_NAMESPACES);
}

/**
 * Messages for the calculators layout. A nested provider replaces the context
 * rather than adding to it, so this carries the public set as well.
 */
export function pickCalculatorClientMessages(messages: AbstractIntlMessages): AbstractIntlMessages {
  return pick(messages, [...PUBLIC_CLIENT_NAMESPACES, ...CALCULATOR_CLIENT_NAMESPACES]);
}
