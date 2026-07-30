/**
 * Femio analytics event catalog — health-field-free BY CONSTRUCTION.
 *
 * The binding rule (docs/13 §5, docs/compliance/DATA_MAP.md): **no health data
 * reaches a third-party analytics SDK, ever.** Wording alone can't enforce that,
 * so this catalog is a *closed* schema rather than a convention:
 *
 *   1. Only the event names below may be sent.
 *   2. Each event declares a fixed set of property keys — no extras.
 *   3. Every property value must come from a closed enum listed here. There is
 *      no free-form string, no number, and no date anywhere in the schema, so a
 *      symptom name, article slug, cycle date, or lab value has no channel to
 *      travel down even if a caller tries.
 *
 * That third rule is the important one. A free-form `page` property would carry
 * `/learn/endometriosis-symptoms`, and an article slug on a pseudonymous
 * `distinct_id` is a health inference about a person — precisely what the FTC
 * actions against Flo and Premom were about. So we send a coarse product *area*
 * and never the slug.
 *
 * Adding an event or a property value is a compliance change, not a code change:
 * update this file, `docs/19_ANALYTICS_EVENT_SCHEMA.md`, and the data map in the
 * same PR (docs/13 §9 feature-review gate). `pnpm analytics-lint` fails the build
 * if this file grows a key that looks like health data.
 */

import { routing } from "@/i18n/routing";

/**
 * Coarse product areas. Deliberately coarser than our route structure: `library`
 * covers /learn, /conditions, /faq and /glossary together, because "read a
 * conditions page" is already a weak health signal and the per-section split
 * isn't worth carrying that. Individual slugs are never sent at any granularity.
 *
 * There is deliberately **no crisis value.** The crisis surface must never be
 * measured — opening it reveals mental-health intent, and P1.26/ADR-013 already
 * guarantee that `useCrisisHelp().open()` takes no payload and fires no
 * analytics. `FORBIDDEN_AREAS` below turns that promise into a test.
 */
export const AREAS = [
  "home",
  "library",
  "calculators",
  "trust",
  "auth",
  "onboarding",
  "app",
] as const;
export type Area = (typeof AREAS)[number];

/** Surfaces that must never appear in an event, with the reason each is barred. */
export const FORBIDDEN_AREAS: Record<string, string> = {
  crisis: "opening crisis help reveals mental-health intent (ADR-013, CRISIS_RESOURCES)",
  "help-now": "same as crisis — the account-less mirror of the same surface",
};

/** How the person authenticated. Not health data; shapes the sign-in funnel. */
export const AUTH_METHODS = ["anonymous", "email_password", "magic_link", "google"] as const;
export type AuthMethod = (typeof AUTH_METHODS)[number];

/** Outcome of a flow, so a funnel can distinguish an abandon from a failure. */
export const OUTCOMES = ["success", "error"] as const;
export type Outcome = (typeof OUTCOMES)[number];

const LOCALES = routing.locales;

/**
 * The catalog: event name → property key → the closed set of values that key
 * accepts. An empty object means the event carries no properties at all.
 */
export const EVENT_SCHEMA = {
  /** A coarse product area was viewed. Never a slug, never a full path. */
  page_viewed: { area: AREAS, locale: LOCALES },

  /** Someone began the onboarding wizard. */
  signup_started: { locale: LOCALES },

  /** Onboarding finished. `mode` is deliberately absent — life-stage is health data. */
  signup_completed: { locale: LOCALES, auth_method: AUTH_METHODS, outcome: OUTCOMES },

  /** A returning user signed in. */
  signin_completed: { locale: LOCALES, auth_method: AUTH_METHODS, outcome: OUTCOMES },

  /**
   * A public calculator was used. `which` calculator is deliberately absent:
   * "used the due-date calculator" implies pregnancy and "fertile window"
   * implies TTC, both of which are health inferences. Per-tool demand is a
   * first-party question (P1.20.3), not a PostHog one.
   */
  calculator_used: { locale: LOCALES },

  /** Interface language switched — tells us which locales are actually used. */
  language_changed: { from_locale: LOCALES, to_locale: LOCALES },

  /** The PWA was installed from the browser prompt. */
  app_installed: { locale: LOCALES },
} as const satisfies Record<string, Record<string, readonly string[]>>;

export type EventName = keyof typeof EVENT_SCHEMA;

/** Properties accepted by a given event, typed to its allowlisted values. */
export type EventProps<E extends EventName> = {
  [K in keyof (typeof EVENT_SCHEMA)[E]]: (typeof EVENT_SCHEMA)[E][K] extends readonly (infer V)[]
    ? V
    : never;
};

export const EVENT_NAMES = Object.keys(EVENT_SCHEMA) as EventName[];
