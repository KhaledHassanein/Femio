import { z } from "zod";

/**
 * Typed, validated environment (femio-engineering-standards §2).
 * Extend this as integrations land (Supabase — P1.3, Sentry — P1.4). Never read
 * `process.env` directly elsewhere; import from here so every var is validated once.
 */
const envSchema = z.object({
  NODE_ENV: z.enum(["development", "test", "production"]).default("development"),
  NEXT_PUBLIC_APP_URL: z.string().url().default("http://localhost:3000"),
});

const parsed = envSchema.safeParse(process.env);

if (!parsed.success) {
  // Fail fast at boot rather than surfacing undefined config deep in a request.
  console.error("Invalid environment variables:", parsed.error.flatten().fieldErrors);
  throw new Error("Invalid environment variables");
}

export const env = parsed.data;
