import * as Sentry from "@sentry/nextjs";

/**
 * Server + edge error monitoring (P1.4.2). Same posture as the client half:
 * nothing initialises without an EU DSN, tracing stays off (spans carry URLs),
 * and every event goes through the scrubber before it leaves.
 *
 * The init lives inside `register()` rather than at module scope so the env is
 * read at runtime on the server, where `NEXT_PUBLIC_*` inlining does not apply.
 */
export async function register() {
  const { env } = await import("@/lib/env");
  if (!env.NEXT_PUBLIC_SENTRY_DSN) return;

  const { scrubEvent } = await import("@/lib/observability/scrub");

  Sentry.init({
    dsn: env.NEXT_PUBLIC_SENTRY_DSN,
    sendDefaultPii: false,
    tracesSampleRate: 0,
    beforeSend: (event) => scrubEvent(event),
  });
}

/**
 * Reports errors thrown while rendering a Server Component. Sentry's own helper
 * builds the event; ours still runs over it via `beforeSend`, so the same
 * scrubbing applies — a server render error would otherwise carry the full URL.
 */
export const onRequestError = Sentry.captureRequestError;
