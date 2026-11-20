import { test, expect } from "@playwright/test";
import path from "node:path";

test("Google sign-in layout loads the bundled SDK without exposing seeded accounts", async ({
  page,
}) => {
  const requests = [];
  page.on("request", (request) => {
    if (request.url().includes("/api/"))
      requests.push(new URL(request.url()).pathname);
  });
  // Configuration preview only: no Google account, OAuth popup or live ID token.
  // Other browser tests exercise the real backend workflow without mocks.
  await page.route("**/api/config", (route) =>
    route.fulfill({
      json: {
        data: {
          authentication: "firebase",
          demoEnabled: false,
          campus: "Meridian Demo Campus",
          firebase: {
            projectId: "caregrid-test-project",
            apiKey: "AIzaTestOnlyPublicConfiguration123456789",
            appId: "1:123456789:web:testonly",
            authDomain: "caregrid-test-project.firebaseapp.com",
          },
        },
      },
    }),
  );
  await page.route("https://*.googleapis.com/**", (route) => route.abort());
  await page.route("https://*.firebaseapp.com/**", (route) => route.abort());
  await page.goto("/");
  await expect(
    page.getByRole("button", { name: "Continue with Google" }),
  ).toBeEnabled();
  await expect(page.getByLabel("Demo account")).toHaveCount(0);
  await expect(
    page.getByText("Sign-in stays in memory", { exact: false }),
  ).toBeVisible();
  expect(requests).not.toContain("/api/accounts");
  expect(
    await page.evaluate(() =>
      Object.keys(localStorage).filter((key) => key.startsWith("firebase:")),
    ),
  ).toEqual([]);
  if (process.env.CAREGRID_CAPTURE === "1") {
    await page.evaluate(() => document.fonts.ready);
    await page.screenshot({
      path: path.resolve(
        "../assets/pitch/connected/09-google-entry-preview.png",
      ),
      fullPage: true,
      animations: "disabled",
    });
  }
});
