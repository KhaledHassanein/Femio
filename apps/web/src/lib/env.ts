import { z } from "zod";
import { isApprovedDirectoryUrl } from "@/lib/crisis/directory";

/**
 * Typed, validated environment (femio-engineering-standards §2). Never read
 * `process.env` elsewhere; import from here so every variable is validated once.
 *
 * The website is static and holds no data, so the whole list is three public
 * values. Anything that would send a visitor's request somewhere else (analytics,
 * error reporting, a database) was removed with the web tracker on 2026-10-27;
 * adding one back is a decision for `docs/DECISIONS.md`, not a variable here.
 */
const envSchema = z.object({
  NODE_ENV: z.enum(["development", "test", "production"]).default("development"),
  NEXT_PUBLIC_APP_URL: z.string().url().default("http://localhost:3000"),
  // Google Search Console verification token (set in Vercel when verifying).
  NEXT_PUBLIC_GOOGLE_SITE_VERIFICATION: z.string().optional(),
  // Optional outbound link to the maintained crisis-helpline directory. Unset →
  // the directory action is hidden and the emergency-services / nearest-ED
  // fallback still works. When set it must be the canonical Find A Helpline host
  // over HTTPS with no query string (no identifiers may leak); anything else
  // FAILS THE BUILD rather than shipping an unvetted external link
  // (docs/compliance/CRISIS_RESOURCES.md § Directory policy).
  NEXT_PUBLIC_CRISIS_DIRECTORY_URL: z
    .string()
    .refine(isApprovedDirectoryUrl, {
      message: "must be an https://findahelpline.com URL with no query string or fragment",
    })
    .optional(),
});

// Reference each variable explicitly: Next inlines `process.env.NEXT_PUBLIC_*`
// only where written out literally, so the object itself is empty in the client.
const parsed = envSchema.safeParse({
  NODE_ENV: process.env.NODE_ENV,
  NEXT_PUBLIC_APP_URL: process.env.NEXT_PUBLIC_APP_URL,
  NEXT_PUBLIC_GOOGLE_SITE_VERIFICATION: process.env.NEXT_PUBLIC_GOOGLE_SITE_VERIFICATION,
  NEXT_PUBLIC_CRISIS_DIRECTORY_URL: process.env.NEXT_PUBLIC_CRISIS_DIRECTORY_URL,
});

if (!parsed.success) {
  // Fail fast at boot rather than surfacing undefined config deep in a request.
  console.error("Invalid environment variables:", parsed.error.flatten().fieldErrors);
  throw new Error("Invalid environment variables");
}

export const env = parsed.data;
