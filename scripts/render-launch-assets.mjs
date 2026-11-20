// Isolated browser capture of the finalized UI. Never uses a personal profile.
// Start the real local backend first; this script does not seed/reset it.
import { createRequire } from "node:module";
import { mkdir, writeFile, readFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";
const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const require = createRequire(
  path.join(
    process.env.CAREGRID_TOOLING_ROOT || root,
    "caregrid_web/package.json",
  ),
);
const { chromium, expect } = require("@playwright/test");
const origin = process.env.CAREGRID_CAPTURE_ORIGIN || "http://127.0.0.1:4173";
if (!/^http:\/\/(127\.0\.0\.1|localhost):\d+$/.test(origin))
  throw Error(
    "Capture only the synthetic local backend; cloud OAuth is a separate acceptance check.",
  );
const output = path.join(root, "assets/pitch/launch");
await mkdir(output, { recursive: true });
const browser = await chromium.launch({ channel: "chrome", headless: true });
const captures = [];
async function capture(page, name, description) {
  await page.evaluate(() => document.fonts.ready);
  await expect(
    page.getByText("Loading your workspace", { exact: true }),
  ).toHaveCount(0);
  await page.screenshot({
    path: path.join(output, name + ".png"),
    animations: "disabled",
    fullPage: false,
    style: "#notice { visibility: hidden !important; }",
  });
  captures.push({
    file: name + ".png",
    description,
    viewport: page.viewportSize(),
  });
  console.log("Captured " + name);
}
async function login(handle, pin, mobile = false) {
  const context = await browser.newContext({
    viewport: mobile
      ? { width: 390, height: 844 }
      : { width: 1600, height: 1100 },
    reducedMotion: "reduce",
  });
  const page = await context.newPage();
  await page.goto(origin + "/console");
  await page.getByLabel("Demo account").selectOption(handle);
  await page.getByLabel("Demo PIN").fill(pin);
  await page
    .getByRole("button", { name: "Enter workspace", exact: true })
    .click();
  await expect(
    page.getByRole("button", { name: "Sign out", exact: true }),
  ).toBeVisible();
  await expect(page.locator("#connection-status")).toContainText("Synced");
  await expect(page.locator("#main h1")).toBeVisible();
  return page;
}
try {
  const landing = await browser.newPage({
    viewport: { width: 1600, height: 1100 },
    reducedMotion: "reduce",
  });
  await landing.goto(origin);
  await capture(
    landing,
    "01-landing",
    "Finalized product landing page; illustrative campus model.",
  );
  const member = await login("student.aanya", "5501", true);
  await member.getByLabel("Campus location").selectOption("HB");
  await member
    .getByLabel("Where exactly?")
    .fill("Block B, ground floor, corridor 2");
  await member
    .getByLabel("What happened?")
    .fill(
      "Synthetic screenshot rehearsal: a friend needs the campus response team.",
    );
  await member
    .getByRole("button", { name: "Send request to command", exact: true })
    .click();
  await expect(member.locator(".sos-status").first()).toBeVisible();
  const command = await login("cmd.night", "1111");
  await expect(command.locator(".incident-row").first()).toBeVisible();
  await capture(
    command,
    "02-command-centre",
    "Meridian command queue backed by local Serverpod/PostgreSQL synthetic seed.",
  );
  const row = command.locator(".incident-row").first();
  if (await row.count()) {
    await row.click();
    await expect(command.locator(".detail-heading")).toBeVisible();
    const dispatch = command.getByRole("button", {
      name: "Approve recommended dispatch",
      exact: true,
    });
    if (await dispatch.count()) {
      await command
        .getByRole("button", { name: "Take ownership", exact: true })
        .click();
      await dispatch.click();
      await expect(
        command.getByRole("heading", { name: /Proof of response/ }),
      ).toBeVisible();
    }
    await capture(
      command,
      "03-response-workspace",
      "Owned and dispatched response with per-unit proof; local connected synthetic data.",
    );
  }
  const admin = await login("ops.admin", "9090");
  await admin
    .getByRole("button", { name: "Readiness lab", exact: true })
    .click();
  await admin
    .getByRole("button", { name: "Run all scenarios", exact: true })
    .click();
  await expect(
    admin.locator(".metric").filter({ hasText: "Readiness score" }),
  ).toBeVisible();
  await capture(
    admin,
    "04-readiness-lab",
    "Computed readiness scenarios using the Meridian routing twin; local connected synthetic data.",
  );
  await admin.getByRole("button", { name: "Audit trail", exact: true }).click();
  await expect(admin.locator("tbody tr").first()).toBeVisible();
  await capture(
    admin,
    "05-audit-trail",
    "Server-written local audit records; synthetic operator personas.",
  );
  await capture(
    member,
    "06-mobile-member",
    "390px member SOS interface; synthetic local account.",
  );
  const crew = await login("amb.a2", "3302", true);
  await capture(
    crew,
    "07-mobile-responder",
    "390px responder view; synthetic local ambulance account.",
  );
  const care = await login("er.doctor", "2222");
  await capture(
    care,
    "08-care-handoff",
    "Role-minimized care workspace; local synthetic handoffs.",
  );
  const brand = await readFile(
    path.join(root, "caregrid_web/brand.css"),
    "utf8",
  );
  await writeFile(
    path.join(output, "capture-manifest.json"),
    JSON.stringify(
      {
        capturedAt: new Date().toISOString(),
        sourceRelease: "aa9e40d",
        origin,
        mode: "real local Serverpod/PostgreSQL; PIN identities; no provider mocks",
        brand: brand.includes("--butter: #f6dd78")
          ? "finalized blue/butter editorial UI"
          : "check brand source",
        captures,
      },
      null,
      2,
    ) + "\n",
  );
} finally {
  await browser.close();
}
