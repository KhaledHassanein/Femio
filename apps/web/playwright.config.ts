import { defineConfig, devices } from "@playwright/test";

// E2E against a locally-served build. The dev server loads .env.local (Supabase),
// so onboarding/auth flows exercise the real backend. RTL snapshots + more land
// with P1.22.
export default defineConfig({
  testDir: "./e2e",
  timeout: 60_000,
  // Generous: Next dev lazy-compiles a route on first hit.
  expect: { timeout: 25_000 },
  fullyParallel: false,
  retries: 0,
  reporter: "list",
  use: {
    baseURL: "http://localhost:3000",
    trace: "on-first-retry",
  },
  projects: [{ name: "chromium", use: { ...devices["Desktop Chrome"] } }],
  webServer: {
    command: "pnpm dev",
    url: "http://localhost:3000/en",
    timeout: 120_000,
    reuseExistingServer: !process.env.CI,
  },
});
