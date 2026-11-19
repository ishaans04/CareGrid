import { defineConfig } from "@playwright/test";
export default defineConfig({
  testDir: "./e2e",
  workers: 1,
  retries: 0,
  timeout: 60_000,
  outputDir: "../tmp/browser-results",
  reporter: "list",
  use: {
    baseURL: "http://127.0.0.1:4173",
    channel: "chrome",
    headless: true,
    viewport: { width: 1600, height: 1100 },
    launchOptions: { chromiumSandbox: true },
    screenshot: "only-on-failure",
    trace: "retain-on-failure",
  },
  // Start the API separately with node scripts/dev.mjs. Never mock the backend.
  webServer: {
    command:
      process.env.CAREGRID_START_FULL === "1"
        ? "node ../scripts/dev.mjs"
        : "node server.mjs",
    url: "http://127.0.0.1:4173/api/accounts",
    reuseExistingServer: !process.env.CI,
    timeout: 180_000,
  },
});
