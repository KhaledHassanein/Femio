import { fileURLToPath } from "node:url";
import { defineConfig } from "vitest/config";

export default defineConfig({
  resolve: {
    alias: {
      "@": fileURLToPath(new URL("./src", import.meta.url)),
      // `next-intl/navigation` does a bare `import "next/navigation"`, which Next
      // resolves through its own bundler and plain Node ESM does not — it wants the
      // `.js`. Any module reaching `@/i18n/navigation` therefore failed to load in
      // this runner, which is why `module-registry.tsx` long avoided it and passed
      // link-bearing nodes in from the screens instead. That indirection is what
      // let R1.9l happen (a slot filled with `null` type-checks), so fix the
      // resolution rather than keep designing around it.
      "next/navigation": "next/navigation.js",
    },
  },
  // Next's tsconfig sets `jsx: "preserve"` (the compiler is Next's, not tsc's),
  // so Vitest 4 / Vite 8 can't parse a .tsx module a test imports — the Lexical
  // renderer's tests do. Transform JSX in the runner rather than weakening the
  // app's tsconfig for the test suite's benefit. (Vite 8 transforms with oxc, so
  // this is `oxc:`, not the `esbuild:` option older guides show.)
  oxc: { jsx: { runtime: "automatic" } },
  test: {
    environment: "node",
    include: ["src/**/*.test.ts"],
    // The alias above only bites if Vite actually transforms next-intl; left
    // external, Node resolves its bare `next/navigation` itself and fails.
    server: { deps: { inline: ["next-intl"] } },
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
