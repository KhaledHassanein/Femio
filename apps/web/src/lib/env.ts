import { z } from "zod";
import { isApprovedDirectoryUrl } from "@/lib/crisis/directory";
import { isApprovedPostHogHost } from "@/lib/analytics/host";

/**
 * Typed, validated environment (femio-engineering-standards §2).
 * Extend this as integrations land (Supabase — P1.3, Sentry — P1.4). Never read
 * `process.env` directly elsewhere; import from here so every var is validated once.
 */
const envSchema = z.object({
  NODE_ENV: z.enum(["development", "test", "production"]).default("development"),
  NEXT_PUBLIC_APP_URL: z.string().url().default("http://localhost:3000"),
  // Supabase — publishable key is client-safe (RLS-protected). A server-only
  // secret key (sb_secret_…) will be added later for trusted admin RPCs and must
  // never carry the NEXT_PUBLIC_ prefix.
  NEXT_PUBLIC_SUPABASE_URL: z.string().url(),
  NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY: z.string().min(1),
  // Google Search Console verification token (set in Vercel when verifying).
  NEXT_PUBLIC_GOOGLE_SITE_VERIFICATION: z.string().optional(),
  // Show the "Continue with Google" sign-in button. Set to "true" only after the
  // Google OAuth provider is configured in Supabase (docs/runbooks). Unset/anything
  // else → the button is hidden so users never hit an unconfigured provider.
  NEXT_PUBLIC_ENABLE_GOOGLE_AUTH: z.string().optional(),
  // Base URL of the Payload CMS deployment (e.g. https://femio-cms.vercel.app).
  // The web app reads PUBLISHED content from its REST API. Unset → content pages
  // render an empty state and the site still builds (graceful).
  NEXT_PUBLIC_CMS_URL: z.string().url().optional(),
  // Optional outbound link to the maintained crisis-helpline directory. Unset →
  // the directory action is hidden and the emergency-services / nearest-ED
  // fallback still works. When set it must be the canonical Find A Helpline host
  // over HTTPS with no query string (no identifiers may leak) — anything else
  // FAILS THE BUILD rather than silently shipping an unvetted external link.
  // Only set this once ThroughLine's commercial/linking terms are confirmed
  // (docs/compliance/CRISIS_RESOURCES.md § Directory policy).
  NEXT_PUBLIC_CRISIS_DIRECTORY_URL: z
    .string()
    .refine(isApprovedDirectoryUrl, {
      message: "must be an https://findahelpline.com URL with no query string or fragment",
    })
    .optional(),
  // Product analytics (PostHog). Unset → the whole event layer is a verified
  // no-op and no vendor script loads, which is the correct state until the EU
  // project + DPA exist (P1.20.APPLY). Only ever pseudonymous, health-field-free
  // events from the closed catalog in lib/analytics/events.ts.
  NEXT_PUBLIC_POSTHOG_KEY: z.string().min(1).optional(),
  // Must be the PostHog **EU** cloud: the SDK defaults to the US host, so an
  // unset or copy-pasted value would silently ship an international transfer of
  // health-adjacent product data. Anything else FAILS THE BUILD.
  NEXT_PUBLIC_POSTHOG_HOST: z
    .string()
    .refine(isApprovedPostHogHost, {
      message: "must be an https:// PostHog EU host (eu.i.posthog.com) with no query string",
    })
    .optional(),
})
  // A key without a host would fall back to the SDK's US default, so require the
  // pair. Enforced here rather than at call time: a misconfiguration must fail at
  // boot, not on the first event.
  .refine((cfg) => !cfg.NEXT_PUBLIC_POSTHOG_KEY || Boolean(cfg.NEXT_PUBLIC_POSTHOG_HOST), {
    message: "NEXT_PUBLIC_POSTHOG_HOST is required whenever NEXT_PUBLIC_POSTHOG_KEY is set",
    path: ["NEXT_PUBLIC_POSTHOG_HOST"],
  });

// Reference each var explicitly. Next.js inlines `process.env.NEXT_PUBLIC_*` only
// where written out literally — the whole `process.env` object is empty in the
// client bundle, so passing it wholesale would fail validation and crash on the
// client. (Caught by the Playwright hydration test.)
const parsed = envSchema.safeParse({
  NODE_ENV: process.env.NODE_ENV,
  NEXT_PUBLIC_APP_URL: process.env.NEXT_PUBLIC_APP_URL,
  NEXT_PUBLIC_SUPABASE_URL: process.env.NEXT_PUBLIC_SUPABASE_URL,
  NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY: process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY,
  NEXT_PUBLIC_GOOGLE_SITE_VERIFICATION: process.env.NEXT_PUBLIC_GOOGLE_SITE_VERIFICATION,
  NEXT_PUBLIC_ENABLE_GOOGLE_AUTH: process.env.NEXT_PUBLIC_ENABLE_GOOGLE_AUTH,
  NEXT_PUBLIC_CMS_URL: process.env.NEXT_PUBLIC_CMS_URL,
  NEXT_PUBLIC_CRISIS_DIRECTORY_URL: process.env.NEXT_PUBLIC_CRISIS_DIRECTORY_URL,
  NEXT_PUBLIC_POSTHOG_KEY: process.env.NEXT_PUBLIC_POSTHOG_KEY,
  NEXT_PUBLIC_POSTHOG_HOST: process.env.NEXT_PUBLIC_POSTHOG_HOST,
});

if (!parsed.success) {
  // Fail fast at boot rather than surfacing undefined config deep in a request.
  console.error("Invalid environment variables:", parsed.error.flatten().fieldErrors);
  throw new Error("Invalid environment variables");
}

export const env = parsed.data;
