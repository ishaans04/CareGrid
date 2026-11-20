import { test, expect } from "@playwright/test";
import { mkdir } from "node:fs/promises";
import path from "node:path";

async function capture(page, name) {
  if (process.env.CAREGRID_CAPTURE !== "1") return;
  const directory = path.resolve("../assets/pitch/connected");
  await mkdir(directory, { recursive: true });
  await expect(
    page.getByRole("button", { name: "Sign out", exact: true }),
  ).toBeEnabled();
  await page.evaluate(() => document.fonts.ready);
  await page.evaluate(() => window.scrollTo(0, 0));
  await page.evaluate(() => new Promise(requestAnimationFrame));
  await page.screenshot({
    path: path.join(directory, `${name}.png`),
    fullPage: name !== "02-mobile-responder",
    animations: "disabled",
    style: "#notice { visibility: hidden !important; }",
  });
}

async function login(browser, handle, pin, viewport) {
  const context = await browser.newContext({
    viewport: viewport || { width: 1600, height: 1100 },
  });
  const page = await context.newPage();
  await page.goto("http://127.0.0.1:4173/");
  await page.getByLabel("Demo account").selectOption(handle);
  await page.getByLabel("Demo PIN").fill(pin);
  await page
    .getByRole("button", { name: "Enter workspace", exact: true })
    .click();
  await expect(
    page.getByRole("button", { name: "Sign out", exact: true }),
  ).toBeVisible();
  await expect(page.locator("#connection-status")).toContainText("Synced");
  return { context, page };
}
test("member SOS crosses authenticated command, responder and care sessions", async ({
  browser,
}) => {
  const contexts = [];
  try {
    const member = await login(browser, "student.aanya", "5501", {
      width: 390,
      height: 844,
    });
    contexts.push(member.context);
    const command = await login(browser, "cmd.night", "1111");
    contexts.push(command.context);
    const care = await login(browser, "er.doctor", "2222");
    contexts.push(care.context);
    const errors = [];
    for (const { page } of [member, command, care])
      page.on("pageerror", (error) => errors.push(error.message));
    const marker = "Block B, ground floor, corridor 2";
    await member.page.getByLabel("Campus location").selectOption("HB");
    await member.page.getByLabel("Where exactly?").fill(marker);
    await member.page
      .getByLabel("What happened?")
      .fill("A friend needs the campus response team.");
    // Polling must preserve a draft even while the member edits another field.
    await member.page.waitForResponse((response) =>
      response.url().endsWith("/api/rpc/sos/mine"),
    );
    await expect(member.page.getByLabel("Where exactly?")).toHaveValue(marker);
    await member.page
      .getByRole("button", { name: "Send request to command", exact: true })
      .click();
    await expect(member.page.locator(".sos-status").first()).toContainText(
      "reviewing",
    );
    let incident;
    await expect
      .poll(async () => {
        const detail = await command.page.request.post(
          "/api/rpc/incident/board",
          { headers: { "x-caregrid-request": "1" }, data: {} },
        );
        incident = (await detail.json()).data.active.find(
          (item) => item.locationDetail === marker,
        );
        return Boolean(incident);
      })
      .toBe(true);
    await command.page
      .locator(".incident-row")
      .filter({ hasText: incident.code })
      .click();
    await expect(command.page.locator(".detail-heading")).toContainText(marker);
    await command.page
      .getByRole("button", { name: "Draft handoff brief", exact: true })
      .click();
    await expect(command.page.locator("#handoff-brief")).toContainText(
      "Gemini is not enabled",
    );
    await expect(
      command.page.getByRole("button", {
        name: "Approve recommended dispatch",
        exact: true,
      }),
    ).toBeEnabled();
    await expect(
      member.page.getByRole("button", { name: "Draft handoff brief" }),
    ).toHaveCount(0);
    await capture(command.page, "01-command-centre");
    await command.page
      .getByRole("button", { name: "Take ownership", exact: true })
      .click();
    await command.page
      .getByRole("button", {
        name: "Approve recommended dispatch",
        exact: true,
      })
      .click();
    await expect(
      command.page.getByRole("heading", {
        name: "Proof of response · per unit",
        exact: true,
      }),
    ).toBeVisible();
    const read = await command.page.request.post("/api/rpc/incident/detail", {
      headers: { "x-caregrid-request": "1" },
      data: { incidentId: incident.id },
    });
    const dispatches = (await read.json()).data.dispatches;
    const ambulance = dispatches.find(
      (item) => item.responderType === "ambulance",
    );
    expect(ambulance).toBeTruthy();
    const crew = await login(
      browser,
      ambulance.responderCode.toLowerCase().replaceAll("-", "."),
      ambulance.responderCode === "AMB-A2" ? "3302" : "3301",
      { width: 390, height: 844 },
    );
    contexts.push(crew.context);
    crew.page.on("pageerror", (error) => errors.push(error.message));
    await expect(
      crew.page.getByRole("heading", { name: "Birch Hostel", exact: true }),
    ).toBeVisible();
    await crew.page
      .getByRole("button", { name: "Acknowledge assignment", exact: true })
      .click();
    await crew.page
      .getByRole("button", { name: "Confirm departure", exact: true })
      .click();
    await expect(
      care.page.locator(".case-card").filter({ hasText: incident.code }),
    ).toBeVisible();
    await care.page
      .locator(".case-card")
      .filter({ hasText: incident.code })
      .getByRole("button", { name: "Confirm team & bay ready", exact: true })
      .click();
    await capture(crew.page, "02-mobile-responder");
    await capture(care.page, "03-care-handoff");
    await crew.page
      .getByRole("button", { name: "Confirm I am on scene", exact: true })
      .click();
    // Arrival alone must not offer closure.
    await expect(command.page.locator(".detail-heading")).toContainText(
      "On scene",
    );
    await expect(
      command.page.getByRole("button", {
        name: "Record outcome & close",
        exact: true,
      }),
    ).toHaveCount(0);
    await crew.page
      .getByRole("button", { name: "Confirm care has started", exact: true })
      .click();
    await expect(
      command.page.getByRole("button", {
        name: "Record outcome & close",
        exact: true,
      }),
    ).toBeVisible();
    await command.page
      .getByRole("button", { name: "Record outcome & close", exact: true })
      .click();
    await command.page
      .getByLabel("Response outcome")
      .fill(
        "Campus response completed; documented handoff to the receiving team.",
      );
    await command.page
      .getByRole("dialog")
      .getByRole("button", { name: "Record outcome & close", exact: true })
      .click();
    await expect(
      member.page.locator(".sos-status").filter({ hasText: incident.code }),
    ).toContainText("Closed. Take care.");
    await capture(member.page, "04-mobile-member");
    const forbidden = await member.page.request.post(
      "/api/rpc/incident/board",
      { headers: { "x-caregrid-request": "1" }, data: {} },
    );
    expect(forbidden.status()).toBe(403);
    const auditRead = await care.page.request.post("/api/rpc/admin/auditLog", {
      headers: { "x-caregrid-request": "1" },
      data: { limit: 10 },
    });
    expect(auditRead.status()).toBe(403);
    expect(
      await member.page.evaluate(
        () => document.documentElement.scrollWidth <= innerWidth,
      ),
    ).toBe(true);
    expect(
      await crew.page.evaluate(
        () => document.documentElement.scrollWidth <= innerWidth,
      ),
    ).toBe(true);
    expect(errors).toEqual([]);
  } finally {
    for (const context of contexts) await context.close();
  }
});
test("admin computes readiness and analytics, with role-limited navigation", async ({
  browser,
}) => {
  const admin = await login(browser, "ops.admin", "9090");
  try {
    await admin.page.getByRole("button", { name: "Readiness lab" }).click();
    await admin.page
      .getByRole("button", { name: "Run all scenarios", exact: true })
      .click();
    await expect(
      admin.page.locator(".metric").filter({ hasText: "Readiness score" }),
    ).toContainText("50%");
    await capture(admin.page, "05-readiness-lab");
    await admin.page.getByRole("button", { name: "After action" }).click();
    await expect(
      admin.page.locator(".metric").filter({ hasText: "Mean time to care" }),
    ).toBeVisible();
    await capture(admin.page, "06-after-action");
    await admin.page.getByRole("button", { name: "Audit trail" }).click();
    await expect(admin.page.locator("tbody tr").first()).toBeVisible();
    await capture(admin.page, "07-audit-trail");
    await expect(
      admin.page.getByRole("button", { name: "Care handoff" }),
    ).toHaveCount(0);
  } finally {
    await admin.context.close();
  }
});

test("connection loss is visible and cannot silently advance a response", async ({
  browser,
}) => {
  const crew = await login(browser, "amb.a2", "3302", {
    width: 390,
    height: 844,
  });
  try {
    await crew.page.route("**/api/rpc/**", (route) => route.abort("failed"));
    await crew.page.evaluate(() =>
      document.dispatchEvent(new Event("visibilitychange")),
    );
    await expect(crew.page.getByRole("alert")).toContainText("Connection lost");
    await expect(crew.page.locator("#connection-status")).toContainText(
      "needs attention",
    );
    await expect(
      crew.page.getByRole("button", { name: "Reconnect", exact: true }),
    ).toBeVisible();
    await capture(crew.page, "08-mobile-disconnected");
  } finally {
    await crew.context.close();
  }
});
