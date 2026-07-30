import { fileURLToPath } from "node:url";
import { defineConfig } from "vitest/config";

export default defineConfig({
  resolve: {
    alias: { "@": fileURLToPath(new URL("./src", import.meta.url)) },
  },
  test: {
    environment: "node",
    include: ["src/**/*.test.ts"],
    // Some units reach `lib/env` transitively (e.g. lib/seo/config needs the site
    // base URL), and that module fails fast on missing vars by design. Supply
    // schema-valid placeholders so unit tests never depend on a real .env.local.
    env: {
      NEXT_PUBLIC_APP_URL: "https://femio.test",
      NEXT_PUBLIC_SUPABASE_URL: "https://project.supabase.co",
      NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY: "test-publishable-key",
    },
  },
});
