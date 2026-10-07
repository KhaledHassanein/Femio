import * as Sentry from "@sentry/nextjs";
import { env } from "@/lib/env";
import { scrubEvent } from "@/lib/observability/scrub";
import { DENY_URLS, IGNORE_ERRORS } from "@/lib/observability/noise";

/**
 * Browser-side error monitoring (P1.4.2).
 *
 * Unset DSN → `Sentry.init` is never called and no vendor code runs, the same
 * posture as analytics. When it is set, the configuration below is mostly
 * subtraction, because Sentry's defaults are wrong for a health product:
 *
 *   - `sendDefaultPii: false`   — no IP, no cookies, no request headers by default.
 *   - tracing off               — spans carry URLs, and a Femio URL is a health
 *                                 inference. We are not diagnosing latency yet.
 *   - session replay off        — it would record the tracker screen: symptoms,
 *                                 dates, free-text notes, everything.
 *   - `ignoreErrors`/`denyUrls`  — extension, network and stale-chunk noise
 *                                 (`noise.ts`): every issue is an alert email.
 *   - `beforeSend: scrubEvent`  — the last line: normalises URLs to route patterns
 *                                 and strips bodies, cookies, user and `extra`.
 *
 * What's left is what actually fixes bugs: which route broke, and the error.
 */
if (env.NEXT_PUBLIC_SENTRY_DSN) {
  Sentry.init({
    dsn: env.NEXT_PUBLIC_SENTRY_DSN,
    sendDefaultPii: false,
    tracesSampleRate: 0,
    replaysSessionSampleRate: 0,
    replaysOnErrorSampleRate: 0,
    ignoreErrors: IGNORE_ERRORS,
    denyUrls: DENY_URLS,
    beforeSend: (event) => scrubEvent(event),
  });
}

// Required by Next for client-side navigation instrumentation; harmless when the
// SDK was never initialised.
export const onRouterTransitionStart = Sentry.captureRouterTransitionStart;
