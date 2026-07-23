import { z } from "zod";

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
});

const parsed = envSchema.safeParse(process.env);

if (!parsed.success) {
  // Fail fast at boot rather than surfacing undefined config deep in a request.
  console.error("Invalid environment variables:", parsed.error.flatten().fieldErrors);
  throw new Error("Invalid environment variables");
}

export const env = parsed.data;
