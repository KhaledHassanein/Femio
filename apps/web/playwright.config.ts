import { defineConfig, devices } from "@playwright/test";

// E2E against a locally-served build (no database, no secrets).
// so onboarding/auth flows exercise the real backend. RTL snapshots + more land
// with P1.22.
export default defineConfig({
  testDir: "./e2e",
  timeout: 60_000,
  // Generous: Next dev lazy-compiles a route on first hit.
  expect: { timeout: 25_000 },
  fullyParallel: false,
  // One worker: the whole suite shares a single dev/prod server and hits live
  // Supabase, so parallel files contend (first-compile timeouts, auth races).
  workers: 1,
  retries: process.env.CI ? 1 : 0,
  reporter: "list",
  use: {
    baseURL: "http://localhost:3000",
    trace: "on-first-retry",
  },
  projects: [{ name: "chromium", use: { ...devices["Desktop Chrome"] } }],
  webServer: {
    // Local dev lazy-compiles routes; CI serves the already-built app (`next start`,
    // faster + closer to prod). The CI e2e step runs after `pnpm build`, so `.next` exists.
    command: process.env.CI ? "pnpm start" : "pnpm dev",
    url: "http://localhost:3000/en",
    timeout: 120_000,
    reuseExistingServer: !process.env.CI,
  },
});
